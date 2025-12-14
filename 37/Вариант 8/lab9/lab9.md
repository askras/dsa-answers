# ОТЧЕТ ПО ЛАБОРАТОРНОЙ РАБОТЕ
## «Лабораторная работа №9. Криптоалгоритмы. 

### Цель работы: Получение практических навыков защиты программного обеспечения от несанкционированного доступа путем шифрования с использованием криптоалгоритмов.

### Работу выполнил: Цыганков Д.С 

## Задание - Реализовать программу, выполняющую шифрование и расшифровку текста двумя разными методами. Для методов, требующих ключа определенного вида, например для перестановок, ключ должен формироваться на основании одного произвольного ключа, задаваемого пользователем. Пример ключа: фф12К52. Зашифрованный и дешифрованный тексты должны быть идентичными. 

## Шифр Хилла
```python
import numpy as np

class HillCipher:
    def __init__(self, key_str="АЛЬПИНИЗМ"):
        self.alphabet = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ ?.,!"
        self.n = 37
        self.block_size = 3
        
        self.key_matrix = self._key_from_string(key_str)
        self.inv_matrix = self._mod_inverse_matrix(self.key_matrix)
    
    def _key_from_string(self, key_str):
        nums = []
        for char in key_str:
            nums.append(self.alphabet.index(char))
        while len(nums) < 9:
            nums.append(0)
        return np.array(nums[:9]).reshape(3, 3) % self.n
    
    def _mod_inverse(self, a, m):
        if a < 0:
            a = a % m
        m0, x0, x1 = m, 0, 1
        if m == 1:
            return 0
        while a > 1:
            q = a // m
            a, m = m, a % m
            x0, x1 = x1 - q * x0, x0
        if x1 < 0:
            x1 += m0
        return x1
    
    def _mod_inverse_matrix(self, matrix):
        det = int(np.round(np.linalg.det(matrix))) % self.n
        det_inv = self._mod_inverse(det, self.n)
        
        minors = np.zeros((3, 3), dtype=int)
        for i in range(3):
            for j in range(3):
                submatrix = np.delete(np.delete(matrix, i, axis=0), j, axis=1)
                minor = int(np.round(np.linalg.det(submatrix)))
                minors[i, j] = ((-1) ** (i + j)) * minor
        
        inv = (det_inv * minors) % self.n
        inv = inv.T % self.n
        
        for i in range(3):
            for j in range(3):
                if inv[i, j] < 0:
                    inv[i, j] = self.n + inv[i, j]
        
        return inv.astype(int)
    
    def encrypt(self, text):
        text = text.upper()
        text = ''.join(c for c in text if c in self.alphabet)
        
        while len(text) % self.block_size != 0:
            text += ' '
        
        encrypted = ""
        
        for i in range(0, len(text), self.block_size):
            block = text[i:i + self.block_size]
            vec = np.array([self.alphabet.index(c) for c in block])
            enc_vec = np.dot(vec, self.key_matrix) % self.n
            
            for num in enc_vec:
                encrypted += self.alphabet[num]
        
        return encrypted
    
    def decrypt(self, text):
        decrypted = ""
        
        for i in range(0, len(text), self.block_size):
            block = text[i:i + self.block_size]
            vec = np.array([self.alphabet.index(c) for c in block])
            dec_vec = np.dot(vec, self.inv_matrix) % self.n
            
            for num in dec_vec:
                decrypted += self.alphabet[int(num)]
        
        return decrypted.strip()

# Пример работы с текстом "МГТУБАУМАНА"
cipher = HillCipher("АЛЬПИНИЗМ")
plain = "МГТУБАУМАНА"

enc = cipher.encrypt(plain)
dec = cipher.decrypt(enc)

print(f"Исходный: {plain}")
print(f"Шифр: {enc}")
print(f"Дешифр: {dec}")

```

## Шифр Криптосистема Крамера – Шоупа

```python 
import random
import hashlib

class CramerShoup:
    def __init__(self, key_str="фф12К52"):
        random.seed(int(hashlib.md5(key_str.encode()).hexdigest(), 16))
        self.p = 1009
        self.g = 2
        
        self.x1 = random.randint(1, self.p-2)
        self.x2 = random.randint(1, self.p-2)
        self.y1 = random.randint(1, self.p-2)
        self.y2 = random.randint(1, self.p-2)
        self.z = random.randint(1, self.p-2)
        
        self.c = (pow(self.g, self.x1, self.p) * pow(self.g, self.x2, self.p)) % self.p
        self.d = (pow(self.g, self.y1, self.p) * pow(self.g, self.y2, self.p)) % self.p
        self.h = pow(self.g, self.z, self.p)
    
    def _hash(self, a, b):
        return (a * b) % (self.p - 1)
    
    def encrypt(self, msg):
        m = int(hashlib.md5(msg.encode()).hexdigest(), 16) % self.p
        r = random.randint(1, self.p-2)
        u1 = pow(self.g, r, self.p)
        u2 = pow(self.g, r, self.p)
        e = (m * pow(self.h, r, self.p)) % self.p
        alpha = self._hash(u1, u2)
        v = (pow(self.c, r, self.p) * pow(self.d, r*alpha, self.p)) % self.p
        return (u1, u2, e, v)
    
    def decrypt(self, cipher):
        u1, u2, e, v = cipher
        alpha = self._hash(u1, u2)
        s = pow(u1, self.z, self.p)
        s_inv = pow(s, self.p-2, self.p)
        return (e * s_inv) % self.p

cs = CramerShoup()
plain = "БАУМАНАМГТУ"
enc = cs.encrypt(plain)
dec = cs.decrypt(enc)
print(f"Сообщение: {plain}")
print(f"Шифротекст: {enc}")
print(f"Результат: {dec}")

```
