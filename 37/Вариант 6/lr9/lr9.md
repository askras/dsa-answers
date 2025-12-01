# Криптоалгоритмы

***

Старшинов Владислав Эдуардович

ИУ10-37

Вариант 6

## Задания

***

### Шифр Виженера


```python
class VigenereCipher:
    """Класс для шифра Виженера"""
    
    def __init__(self):
        # Русский алфавит
        self.russian_alphabet = 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя'
        # Английский алфавит  
        self.english_alphabet = 'abcdefghijklmnopqrstuvwxyz'
        
    def _prepare_key(self, text: str, key: str) -> str:
        """
        Подготовка ключа: повторение до длины текста
        с учетом только буквенных символов
        """
        # Приводим ключ к нижнему регистру
        key = key.lower()
        
        # Определяем алфавит на основе текста
        alphabet = self._detect_alphabet(text)
        
        # Оставляем только буквы из ключа, принадлежащие алфавиту
        key_letters = ''.join(c for c in key if c in alphabet)
        
        if not key_letters:
            key_letters = alphabet[0]  # ключ по умолчанию - первая буква алфавита
        
        # Создаем расширенный ключ той же длины, что и текст
        # с учетом только буквенных символов
        extended_key = []
        key_index = 0
        
        for char in text:
            char_lower = char.lower()
            if char_lower in self.russian_alphabet or char_lower in self.english_alphabet:
                extended_key.append(key_letters[key_index % len(key_letters)])
                key_index += 1
            else:
                extended_key.append(char)  # для не-букв сохраняем оригинал
        
        return ''.join(extended_key)
    
    def _detect_alphabet(self, text: str) -> str:
        """Определяет, какой алфавит используется в тексте"""
        text_lower = text.lower()
        russian_count = sum(1 for c in text_lower if c in self.russian_alphabet)
        english_count = sum(1 for c in text_lower if c in self.english_alphabet)
        
        if russian_count >= english_count:
            return self.russian_alphabet
        else:
            return self.english_alphabet
    
    def _get_alphabet_for_char(self, char: str) -> str:
        """Возвращает алфавит для конкретного символа"""
        char_lower = char.lower()
        if char_lower in self.russian_alphabet:
            return self.russian_alphabet
        elif char_lower in self.english_alphabet:
            return self.english_alphabet
        else:
            return ""
    
    def encrypt(self, text: str, key: str) -> str:
        """
        Шифрование текста шифром Виженера
        
        Args:
            text: исходный текст для шифрования
            key: ключ шифрования (например: "фф12К52")
        
        Returns:
            зашифрованный текст
        """
        if not text:
            return ""
        
        prepared_key = self._prepare_key(text, key)
        result = []
        
        for i, char in enumerate(text):
            char_lower = char.lower()
            alphabet = self._get_alphabet_for_char(char)
            
            if alphabet:
                # Шифруем только буквы
                text_pos = alphabet.index(char_lower)
                key_char = prepared_key[i]
                key_pos = alphabet.index(key_char.lower())
                
                # Шифрование: (текст + ключ) mod длина_алфавита
                encrypted_pos = (text_pos + key_pos) % len(alphabet)
                encrypted_char = alphabet[encrypted_pos]
                
                # Сохраняем регистр исходного символа
                if char.isupper():
                    result.append(encrypted_char.upper())
                else:
                    result.append(encrypted_char)
            else:
                # Не-буквенные символы остаются без изменений
                result.append(char)
        
        return ''.join(result)
    
    def decrypt(self, text: str, key: str) -> str:
        """
        Расшифровка текста шифром Виженера
        
        Args:
            text: зашифрованный текст
            key: ключ шифрования (должен совпадать с ключом шифрования)
        
        Returns:
            расшифрованный текст
        """
        if not text:
            return ""
        
        prepared_key = self._prepare_key(text, key)
        result = []
        
        for i, char in enumerate(text):
            char_lower = char.lower()
            alphabet = self._get_alphabet_for_char(char)
            
            if alphabet:
                # Расшифровываем только буквы
                text_pos = alphabet.index(char_lower)
                key_char = prepared_key[i]
                key_pos = alphabet.index(key_char.lower())
                
                # Расшифровка: (текст - ключ) mod длина_алфавита
                decrypted_pos = (text_pos - key_pos) % len(alphabet)
                decrypted_char = alphabet[decrypted_pos]
                
                # Сохраняем регистр исходного символа
                if char.isupper():
                    result.append(decrypted_char.upper())
                else:
                    result.append(decrypted_char)
            else:
                # Не-буквенные символы остаются без изменений
                result.append(char)
        
        return ''.join(result)
```

### Криптосистема Пайэ


```python
import random
import math
from typing import Tuple, List, Optional

class PaillierCryptosystem:
    """
    Криптосистема Пэйэ (Paillier)
    Гомоморфная probabilistic криптосистема с открытым ключом
    """
    
    def __init__(self):
        self.p: int = 0
        self.q: int = 0
        self.n: int = 0
        self.n_squared: int = 0
        self.g: int = 0
        self.lambda_val: int = 0
        self.mu: int = 0
        
    def _generate_primes_from_key(self, key: str, bit_length: int = 32) -> Tuple[int, int]:
        """
        Генерация простых чисел на основе пользовательского ключа
        """
        # Преобразуем ключ в числовое значение для seed
        key_numeric = sum(ord(c) for c in key)
        random.seed(key_numeric)
        
        def generate_prime_candidate() -> int:
            """Генерация кандидата в простые числа"""
            while True:
                candidate = random.getrandbits(bit_length)
                candidate |= (1 << bit_length - 1) | 1
                if candidate % 2 != 0:
                    return candidate
        
        def is_prime(n: int, k: int = 20) -> bool:
            """Тест Миллера-Рабина на простоту"""
            if n < 2:
                return False
            if n in (2, 3):
                return True
            if n % 2 == 0:
                return False
            
            d = n - 1
            s = 0
            while d % 2 == 0:
                d //= 2
                s += 1
            
            for _ in range(k):
                a = random.randint(2, n - 2)
                x = pow(a, d, n)
                
                if x == 1 or x == n - 1:
                    continue
                
                for _ in range(s - 1):
                    x = pow(x, 2, n)
                    if x == n - 1:
                        break
                else:
                    return False
            
            return True
        
        # Генерируем первое простое число
        p = generate_prime_candidate()
        while not is_prime(p):
            p = generate_prime_candidate()
        
        # Генерируем второе простое число (отличное от первого)
        q = generate_prime_candidate()
        while not is_prime(q) or q == p:
            q = generate_prime_candidate()
        
        return p, q
    
    def _lcm(self, a: int, b: int) -> int:
        """Наименьшее общее кратное (LCM)"""
        return abs(a * b) // math.gcd(a, b)
    
    def _mod_inverse(self, a: int, m: int) -> int:
        """Вычисление обратного элемента по модулю"""
        def extended_gcd(a: int, b: int) -> Tuple[int, int, int]:
            if a == 0:
                return b, 0, 1
            gcd, x1, y1 = extended_gcd(b % a, a)
            x = y1 - (b // a) * x1
            y = x1
            return gcd, x, y
        
        gcd, x, _ = extended_gcd(a % m, m)
        if gcd != 1:
            raise ValueError("Обратный элемент не существует")
        return (x % m + m) % m
    
    def _L(self, x: int, n: int) -> int:
        """
        Функция L(x) = (x - 1) / n
        """
        return (x - 1) // n
    
    def generate_keys(self, key: str) -> Tuple[dict, dict]:
        """
        Генерация ключей на основе пользовательского ключа
        """
        # Шаг 1: Генерация простых чисел
        self.p, self.q = self._generate_primes_from_key(key)
        
        # Шаг 2: Вычисление n = p * q
        self.n = self.p * self.q
        self.n_squared = self.n * self.n
        
        # Шаг 3: Выбор g (обычно g = n + 1)
        self.g = self.n + 1
        
        # Шаг 4: Вычисление λ = LCM(p-1, q-1)
        self.lambda_val = self._lcm(self.p - 1, self.q - 1)
        
        # Шаг 5: Вычисление μ = L(g^λ mod n^2)^(-1) mod n
        g_lambda = pow(self.g, self.lambda_val, self.n_squared)
        L_g_lambda = self._L(g_lambda, self.n)
        self.mu = self._mod_inverse(L_g_lambda, self.n)
        
        # Формируем ключи
        public_key = {
            'n': self.n,
            'g': self.g,
            'n_squared': self.n_squared
        }
        
        private_key = {
            'lambda_val': self.lambda_val,
            'mu': self.mu,
            'p': self.p,
            'q': self.q,
            'n': self.n
        }
        
        return public_key, private_key
    
    def _text_to_numbers(self, text: str) -> List[int]:
        """Преобразование текста в числовую последовательность"""
        return [ord(char) for char in text]
    
    def _numbers_to_text(self, numbers: List[int]) -> str:
        """Преобразование числовой последовательности в текст"""
        try:
            return ''.join(chr(num) for num in numbers)
        except ValueError:
            result = []
            for num in numbers:
                try:
                    result.append(chr(num))
                except ValueError:
                    result.append('?')
            return ''.join(result)
    
    def encrypt(self, plaintext: str, public_key: dict) -> List[int]:
        """Шифрование текста"""
        n = public_key['n']
        g = public_key['g']
        n_squared = public_key['n_squared']
        
        numbers = self._text_to_numbers(plaintext)
        ciphertext = []
        
        for m in numbers:
            if m >= n:
                raise ValueError(f"Сообщение {m} слишком велико для модуля n = {n}")
            
            while True:
                r = random.randint(1, n - 1)
                if math.gcd(r, n) == 1:
                    break
            
            g_m = pow(g, m, n_squared)
            r_n = pow(r, n, n_squared)
            c = (g_m * r_n) % n_squared
            
            ciphertext.append(c)
        
        return ciphertext
    
    def decrypt(self, ciphertext: List[int], private_key: dict) -> str:
        """Расшифровка текста"""
        lambda_val = private_key['lambda_val']
        mu = private_key['mu']
        n = private_key['n']
        n_squared = n * n
        
        plaintext_numbers = []
        
        for c in ciphertext:
            if c >= n_squared:
                raise ValueError(f"Шифротекст {c} слишком велик")
            
            c_lambda = pow(c, lambda_val, n_squared)
            L_c_lambda = self._L(c_lambda, n)
            m = (L_c_lambda * mu) % n
            
            plaintext_numbers.append(m)
        
        return self._numbers_to_text(plaintext_numbers)
```
