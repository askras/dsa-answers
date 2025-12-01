```python
o={"a":1, "b":2, "c":3, "d":4, "e":5, "f":6, "g":7, "h":8, "i":9, "j":10, "k":11, "l":12, "m":13, "n":14, "o":15, "p":16, "q":17, "r":18, "s":19, "t":20, "u":21, "v":22, "w":23, "x":24, "y":25, "z":26}
secret_key = "hello"
j=[]
for i in range(len(secret_key)):
    j.append(o[secret_key[i]])
print(j)
u=input("Enter the message: ")
k=[]
for i in range(len(u)):
    k.append(o[u[i]])
print(k)
result = [k[i] + j[i % len(j)] for i in range(len(k))]
print(f"Результат: {result}")



```

    [8, 5, 12, 12, 15]
    [3, 21, 3, 21, 13, 2, 5, 18]
    Результат: [11, 26, 15, 33, 28, 10, 10, 30]



```python
o = {"a":1, "b":2, "c":3, "d":4, "e":5, "f":6, "g":7, "h":8, "i":9, "j":10,
     "k":11, "l":12, "m":13, "n":14, "o":15, "p":16, "q":17, "r":18, "s":19,
     "t":20, "u":21, "v":22, "w":23, "x":24, "y":25, "z":26}

secret_key = "hello"
j = []
for i in range(len(secret_key)):
    j.append(o[secret_key[i]])

u = input("Enter the encrypted message (цифры через пробел): ")
k = list(map(int, u.split())) 
print(k)

decrypted_nums = [k[i] - j[i % len(j)] for i in range(len(k))]
print(decrypted_nums)

reverse_o = {v: k for k, v in o.items()}  
decrypted_text = ''.join(reverse_o.get(num, '?') for num in decrypted_nums)
print(decrypted_text)
```

    [11, 26, 15, 33, 28, 10, 10, 30]
    [3, 21, 3, 21, 13, 2, 5, 18]
    cucumber



```python
class NakashSternCipher:
    def __init__(self, key):
        self.key = key
        self.russian_alphabet = 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя'
        self.english_alphabet = 'abcdefghijklmnopqrstuvwxyz'
        self.digits = '0123456789'
        self.symbols = ' !"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~'
        
        self.all_chars = (self.russian_alphabet + 
                         self.russian_alphabet.upper() + 
                         self.english_alphabet + 
                         self.english_alphabet.upper() + 
                         self.digits + 
                         self.symbols)
        
        self.alphabet = self._create_alphabet_from_key()
    
    def _create_alphabet_from_key(self):
        key_chars = []
        for char in self.key:
            if char not in key_chars:
                key_chars.append(char)
        
        alphabet_chars = key_chars.copy()
        for char in self.all_chars:
            if char not in alphabet_chars:
                alphabet_chars.append(char)
        
        return ''.join(alphabet_chars)
    
    def _get_offset(self, char):
        return self.alphabet.index(char) if char in self.alphabet else 0
    
    def _process_text(self, text, encrypt=True):
        result = []
        
        for i, char in enumerate(text):
            if char not in self.alphabet:
                result.append(char)
                continue
            
            key_char = self.key[i % len(self.key)]
            offset = self._get_offset(key_char)
            
            if not encrypt:
                offset = -offset
            
            char_pos = self.alphabet.index(char)
            new_pos = (char_pos + offset) % len(self.alphabet)
            new_char = self.alphabet[new_pos]
            result.append(new_char)
        
        return ''.join(result)
    
    def encrypt(self, plaintext):
        return self._process_text(plaintext, encrypt=True)
    
    def decrypt(self, ciphertext):
        return self._process_text(ciphertext, encrypt=False)

cipher = NakashSternCipher("ключ")
text = "Привет"
encrypted = cipher.encrypt(text)
decrypted = cipher.decrypt(encrypted)
print(encrypted)
print(decrypted)

```

    Псмееу
    Привет



```python

```
