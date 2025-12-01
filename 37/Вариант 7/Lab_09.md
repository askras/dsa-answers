# Криптоалгоритмы
Фомин И.Н.
ИУ10-37
## Задания
### Задание 1
1. Реализовать программу, выполняющую шифрование и расшифровку текста двумя разными методами. Для методов, требующих ключа определенного вида, например для перестановок, ключ должен формироваться на основании одного произвольного ключа, задаваемого пользователем. Пример ключа: фф12К52. Зашифрованный и дешифрованный тексты должны быть идентичными. 
 
|Вариант|Симметричный шифр| Асимметричный шифр|
|:---|:---|:---|
|7|[Шифр Вернама](https://ru.wikipedia.org/wiki/Шифр_Вернама)|[Криптосистема Рабина](https://ru.wikipedia.org/wiki/Криптосистема_Рабина)|

#### Шифр Вернама


```python
def vernam_encrypt(text: str, key: str) -> bytes:
    text_bytes = text.encode("utf-8")
    key_bytes = key.encode("utf-8")

    encrypted = bytearray()
    for i in range(len(text_bytes)):
        encrypted.append(text_bytes[i] ^ key_bytes[i % len(key_bytes)])

    return bytes(encrypted)


def vernam_decrypt(cipher: bytes, key: str) -> str:
    key_bytes = key.encode("utf-8")

    decrypted = bytearray()
    for i in range(len(cipher)):
        decrypted.append(cipher[i] ^ key_bytes[i % len(key_bytes)])

    return decrypted.decode("utf-8")



plaintext = "Мужество воля труд и упорство"
key = "фф12К52"

cipher = vernam_encrypt(plaintext, key)
restored = vernam_decrypt(cipher, key)

print("Исходный текст:", plaintext)
print("Зашифрованный (bytes):", cipher)
print("Расшифрованный текст:", restored)

```

    Исходный текст: Мужество воля труд и упорство
    Зашифрованный (bytes): b'\x01\x18\x00\x07\xe1\x84\x00/\xe4\xb3\x00\x06\x016\xe1\x8c\xf0J\x87\xe2oTjU\xbe\x12\x01\x18\xe4\xb2\x00\x07\x010\x11\xe2h\xba\xe4\xb1\x01;\x01:\xe0\xb2\x01\x1b\xe4\xb0\x016\x01:'
    Расшифрованный текст: Мужество воля труд и упорство


#### Криптосистема Рабина


```python
import random
from math import gcd


def egcd(a, b):
    if a == 0:
        return b, 0, 1
    g, y, x = egcd(b % a, a)
    return g, x - (b // a) * y, y


def modinv(a, m):
    g, x, _ = egcd(a, m)
    if g != 1:
        raise ValueError("Обратного элемента не существует")
    return x % m


def generate_rabin_keys():
    p = 1_000_003
    q = 1_000_039
    n = p * q
    return p, q, n


def rabin_encrypt(m: int, n: int) -> int:
    return (m * m) % n


def rabin_decrypt(c: int, p: int, q: int):
    n = p * q

    mp = pow(c, (p + 1) // 4, p)
    mq = pow(c, (q + 1) // 4, q)

    yp = modinv(p, q)
    yq = modinv(q, p)

    r1 = (yp * p * mq + yq * q * mp) % n
    r2 = n - r1
    r3 = (yp * p * mq - yq * q * mp) % n
    r4 = n - r3

    return r1, r2, r3, r4


def text_to_int(text: str) -> int:
    return int.from_bytes(text.encode("utf-8"), "big")


def int_to_text(value: int) -> str:
    length = (value.bit_length() + 7) // 8
    return value.to_bytes(length, "big").decode("utf-8")



plaintext = "hello"

p, q, n = generate_rabin_keys()

m = text_to_int(plaintext)
c = rabin_encrypt(m, n)
roots = rabin_decrypt(c, p, q)

print("Исходное сообщение:", plaintext)
print("Зашифрованное число:", c)

for r in roots:
    try:
        decoded = int_to_text(r)
        print("Возможная расшифровка:", decoded)
    except:
        pass

```

    Исходное сообщение: hello
    Зашифрованное число: 560814691502
    Возможная расшифровка: hello

