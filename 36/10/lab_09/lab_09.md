# Криптоалгоритмы


## Цель работы

Получение практических навыков защиты программного обеспечения от несанкционированного доступа путем шифрования с использованием криптоалгоритмов.


```python
import hashlib
import secrets
from ecdsa import SigningKey, VerifyingKey, SECP256k1
from ecdsa.util import sigencode_der, sigdecode_der
import binascii
import os

class BookCipher:
    def __init__(self, key_text):
        self.key_text = key_text
        self.text_length = len(key_text)
    
    def _char_to_position(self, char):
        positions = []
        for i, c in enumerate(self.key_text):
            if c == char:
                positions.append(i)
        return positions
    
    def encrypt(self, plaintext):
        encrypted = []
        
        for char in plaintext:
            positions = self._char_to_position(char)
            if positions:
                position = secrets.choice(positions)
                encrypted.append(str(position))
            else:
                encrypted.append(f"X{ord(char)}")
        
        return ",".join(encrypted)
    
    def decrypt(self, ciphertext):
        decrypted = []
        positions = ciphertext.split(",")
        
        for pos in positions:
            if pos.startswith("X"):
                char_code = int(pos[1:])
                decrypted.append(chr(char_code))
            else:
                position = int(pos)
                if position < self.text_length:
                    decrypted.append(self.key_text[position])
                else:
                    decrypted.append("?")
        
        return "".join(decrypted)

class ECDSACipher:
    def __init__(self, user_key=None):
        if user_key:
            seed = hashlib.sha256(user_key.encode()).digest()
            self.private_key = SigningKey.from_secret_exponent(
                int.from_bytes(seed[:32], 'big'), curve=SECP256k1
            )
        else:
            self.private_key = SigningKey.generate(curve=SECP256k1)
        
        self.public_key = self.private_key.get_verifying_key()
    
    def sign(self, message):
        signature = self.private_key.sign(message.encode(), sigencode=sigencode_der)
        return binascii.hexlify(signature).decode()
    
    def verify(self, message, signature):
        try:
            signature_bytes = binascii.unhexlify(signature)
            return self.public_key.verify(signature_bytes, message.encode(), sigdecode=sigdecode_der)
        except:
            return False
    
    def get_public_key_hex(self):
        return binascii.hexlify(self.public_key.to_string()).decode()

class CryptoProgram:
    def __init__(self):
        self.book_cipher = None
        self.ecdsa_cipher = None
    
    def setup_book_cipher(self, key_text):
        self.book_cipher = BookCipher(key_text)
        print("Книжный шифр инициализирован")
    
    def setup_ecdsa_cipher(self, user_key=None):
        self.ecdsa_cipher = ECDSACipher(user_key)
        print("ECDSA инициализирован")
        print(f"Публичный ключ: {self.ecdsa_cipher.get_public_key_hex()}")
    
    def book_cipher_demo(self):
        if not self.book_cipher:
            print("Сначала настройте книжный шифр!")
            return
        
        print("\n" + "="*50)
        print("ДЕМОНСТРАЦИЯ КНИЖНОГО ШИФРА")
        print("="*50)
        
        plaintext = input("Введите текст для шифрования: ")
        
        encrypted = self.book_cipher.encrypt(plaintext)
        print(f"\nЗашифрованный текст: {encrypted}")
        
        decrypted = self.book_cipher.decrypt(encrypted)
        print(f"Расшифрованный текст: {decrypted}")
        
        if plaintext == decrypted:
            print("Шифрование/расшифровка прошли успешно!")
        else:
            print("Ошибка в шифровании/расшифровке!")
    
    def ecdsa_demo(self):
        if not self.ecdsa_cipher:
            print("Сначала настройте ECDSA!")
            return
        
        print("\n" + "="*50)
        print("ДЕМОНСТРАЦИЯ ECDSA")
        print("="*50)
        
        message = input("Введите сообщение для подписи: ")
        
        signature = self.ecdsa_cipher.sign(message)
        print(f"\nПодпись: {signature}")
        
        is_valid = self.ecdsa_cipher.verify(message, signature)
        print(f"Проверка подписи: {'ВАЛИДНА' if is_valid else 'НЕВАЛИДНА'}")
        
        fake_message = message + "x"
        is_valid_fake = self.ecdsa_cipher.verify(fake_message, signature)
        print(f"Проверка с измененным сообщением: {'ВАЛИДНА' if is_valid_fake else 'НЕВАЛИДНА (ожидаемо)'}")
    
    def run(self):
        print("ПРОГРАММА ШИФРОВАНИЯ")
        print("="*50)
        
        while True:
            print("\nДоступные операции:")
            print("1. Настроить книжный шифр")
            print("2. Настроить ECDSA")
            print("3. Демо: книжный шифр")
            print("4. Демо: ECDSA")
            print("5. Полная демонстрация")
            print("0. Выход")
            
            choice = input("\nВыберите операцию: ")
            
            if choice == "1":
                key_text = input("Введите ключевой текст для книжного шифра: ")
                self.setup_book_cipher(key_text)
            
            elif choice == "2":
                user_key = input("Введите ключ для ECDSA (или Enter для случайной генерации): ")
                if user_key.strip():
                    self.setup_ecdsa_cipher(user_key)
                else:
                    self.setup_ecdsa_cipher()
            
            elif choice == "3":
                self.book_cipher_demo()
            
            elif choice == "4":
                self.ecdsa_demo()
            
            elif choice == "5":
                self.full_demo()
            
            elif choice == "0":
                print("Выход из программы...")
                break
            
            else:
                print("Неверный выбор!")
    
    def full_demo(self):
        print("\n" + "="*60)
        print("ПОЛНАЯ ДЕМОНСТРАЦИЯ ВСЕХ МЕТОДОВ ШИФРОВАНИЯ")
        print("="*60)
        
        book_key = "Это пример ключевого текста для книжного шифра. Он должен быть достаточно длинным чтобы содержать различные символы."
        ecdsa_key = "мой_секретный_ключ_123"
        
        print("\n1. Настройка книжного шифра...")
        self.setup_book_cipher(book_key)
        
        print("\n2. Настройка ECDSA...")
        self.setup_ecdsa_cipher(ecdsa_key)
        
        print("\n3. Демонстрация книжного шифра:")
        test_message = "Привет мир!"
        print(f"Исходное сообщение: {test_message}")
        
        encrypted = self.book_cipher.encrypt(test_message)
        print(f"Зашифровано: {encrypted}")
        
        decrypted = self.book_cipher.decrypt(encrypted)
        print(f"Расшифровано: {decrypted}")
        
        print("\n4. Демонстрация ECDSA:")
        signature = self.ecdsa_cipher.sign(test_message)
        print(f"Подпись для '{test_message}': {signature[:50]}...")
        
        is_valid = self.ecdsa_cipher.verify(test_message, signature)
        print(f"Проверка подписи: {'УСПЕШНО' if is_valid else 'ОШИБКА'}")
        
        print("\n" + "="*60)
        print("ДЕМОНСТРАЦИЯ ЗАВЕРШЕНА")
        print("="*60)

def main():
    try:
        import ecdsa
    except ImportError:
        print("Ошибка: Для работы программы требуется установить библиотеку ecdsa")
        print("Установите её с помощью: pip install ecdsa")
        return
    
    program = CryptoProgram()
    program.run()

if __name__ == "__main__":
    main()
```

    ПРОГРАММА ШИФРОВАНИЯ
    ==================================================
    
    Доступные операции:
    1. Настроить книжный шифр
    2. Настроить ECDSA
    3. Демо: книжный шифр
    4. Демо: ECDSA
    5. Полная демонстрация
    0. Выход


    
    Выберите операцию:  3


    Сначала настройте книжный шифр!
    
    Доступные операции:
    1. Настроить книжный шифр
    2. Настроить ECDSA
    3. Демо: книжный шифр
    4. Демо: ECDSA
    5. Полная демонстрация
    0. Выход


    
    Выберите операцию:  1
    Введите ключевой текст для книжного шифра:  ghjkl;'


    Книжный шифр инициализирован
    
    Доступные операции:
    1. Настроить книжный шифр
    2. Настроить ECDSA
    3. Демо: книжный шифр
    4. Демо: ECDSA
    5. Полная демонстрация
    0. Выход


    
    Выберите операцию:  3


    
    ==================================================
    ДЕМОНСТРАЦИЯ КНИЖНОГО ШИФРА
    ==================================================


    Введите текст для шифрования:  hello, world


    
    Зашифрованный текст: 1,X101,4,4,X111,X44,X32,X119,X111,X114,4,X100
    Расшифрованный текст: hello, world
    Шифрование/расшифровка прошли успешно!
    
    Доступные операции:
    1. Настроить книжный шифр
    2. Настроить ECDSA
    3. Демо: книжный шифр
    4. Демо: ECDSA
    5. Полная демонстрация
    0. Выход


    
    Выберите операцию:  2
    Введите ключ для ECDSA (или Enter для случайной генерации):  ghjkl;'


    ECDSA инициализирован
    Публичный ключ: 8488306e36799117fc0caf17e3e506d400e443e6d723fce4e9d04cae01b870d94ac3ff476d48a21b8f6b9291e916c703728c8675f75370bb5edc10f9c9b947ae
    
    Доступные операции:
    1. Настроить книжный шифр
    2. Настроить ECDSA
    3. Демо: книжный шифр
    4. Демо: ECDSA
    5. Полная демонстрация
    0. Выход


    
    Выберите операцию:  4


    
    ==================================================
    ДЕМОНСТРАЦИЯ ECDSA
    ==================================================


    Введите сообщение для подписи:  hello, world!


    
    Подпись: 3044022100802d5759502c07b04524799eb9e2358565f546f6d6eab9bc0dbfbd8c477fe044021f7430541f8f9943f3c959ede27a4282d42f3ba180ed384c509dc9bff72cd017
    Проверка подписи: ВАЛИДНА
    Проверка с измененным сообщением: НЕВАЛИДНА (ожидаемо)
    
    Доступные операции:
    1. Настроить книжный шифр
    2. Настроить ECDSA
    3. Демо: книжный шифр
    4. Демо: ECDSA
    5. Полная демонстрация
    0. Выход


    
    Выберите операцию:  0


    Выход из программы...



```python

```
