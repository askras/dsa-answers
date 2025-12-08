# Криптоалгоритмы
Баскаков Д. С.
ИУ10-38

## Цель работы:
Получение практических навыков защиты программного обеспечения от несанкционированного доступа путем шифрования с использованием криптоалгоритмов.

```python
import hashlib

class RossignolCipher:
    
    def __init__(self, key):
        self.key = key
        self.keynum = 0
        self.makekey()
        self.table = []
        self.maketable()

    def makekey(self):
        x = hashlib.sha256(self.key.encode()).hexdigest()
        y = int(x, 16)
        self.keynum = y % 100000000

    def maketable(self):
        abc = "ABCDEFGHIKLMNOPQRSTUVWXYZ"
        for row in range(5):
            line = []
            for col in range(5):
                pos = (row * 5 + col + self.keynum) % 25
                line.append(abc[pos])
            self.table.append(line)

    def findcoords(self, ch):
        ch = ch.upper()
        if ch == "J":
            ch = "I"
        for r in range(5):
            for c in range(5):
                if self.table[r][c] == ch:
                    return r, c
        return 0, 0

    def encrypt(self, text):
        result = ""
        text = text.upper()
        for letter in text:
            if letter.isalpha():
                r, c = self.findcoords(letter)
                newr = (r + self.keynum) % 5
                newc = (c + self.keynum) % 5
                result += self.table[newr][newc]
            else:
                result += letter
        return result

    def decrypt(self, text):
        result = ""
        text = text.upper()
        for letter in text:
            if letter.isalpha():
                r, c = self.findcoords(letter)
                newr = (r - self.keynum) % 5
                newc = (c - self.keynum) % 5
                result += self.table[newr][newc]
            else:
                result += letter
        return result


class DamgardJurikCipher:
    
    def __init__(self, key):
        self.key = key
        self.numkey = 0
        self.calcKey()

    def calcKey(self):
        h = hashlib.sha256(self.key.encode()).hexdigest()
        self.numkey = int(h, 16)

    def addspaces(self, t):
        n = len(t) % 8
        if n != 0:
            t = t + " " * (8 - n)
        return t

    def removespaces(self, t):
        return t.rstrip()

    def mixblock(self, blk):
        mixed = []
        keybytes = hashlib.sha256(str(self.numkey).encode()).digest()
        for i in range(len(blk)):
            kb = keybytes[i % len(keybytes)]
            newch = chr((ord(blk[i]) + kb) % 256)
            mixed.append(newch)
        return "".join(mixed)

    def unmixblock(self, blk):
        unmixed = []
        keybytes = hashlib.sha256(str(self.numkey).encode()).digest()
        for i in range(len(blk)):
            kb = keybytes[i % len(keybytes)]
            oldch = chr((ord(blk[i]) - kb) % 256)
            unmixed.append(oldch)
        return "".join(unmixed)

    def encrypt(self, text):
        text = self.addspaces(text)
        crypted = ""
        for i in range(0, len(text), 8):
            piece = text[i:i+8]
            crypted += self.mixblock(piece)
        return crypted

    def decrypt(self, text):
        decrypted = ""
        for i in range(0, len(text), 8):
            piece = text[i:i+8]
            decrypted += self.unmixblock(piece)
        return self.removespaces(decrypted)

```
