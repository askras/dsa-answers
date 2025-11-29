# Криптоалгоритмы
Баскаков Д. С.
ИУ10-38

## Цель работы:
Получение практических навыков защиты программного обеспечения от несанкционированного доступа путем шифрования с использованием криптоалгоритмов.

```python
import hashlib
import math

class RossignolCipher:
    def __init__(self, key):
        self.key = self._generate_key(key)
        self.table = self._create_table()

    def _generate_key(self, key):
        # Генерация числового ключа на основе хеша
        return int(hashlib.sha256(key.encode()).hexdigest(), 16) % (10**8)

    def _create_table(self):
        # Создание таблицы 5x5 с буквами (I и J объединены)
        alphabet = "ABCDEFGHIKLMNOPQRSTUVWXYZ"
        table = []
        for i in range(5):
            row = []
            for j in range(5):
                index = (i * 5 + j + self.key) % 25
                row.append(alphabet[index])
            table.append(row)
        return table

    def _char_to_coords(self, char):
        # Поиск координат символа в таблице
        char = char.upper().replace('J', 'I')
        for i, row in enumerate(self.table):
            for j, ch in enumerate(row):
                if ch == char:
                    return i, j
        raise ValueError(f"Символ {char} не найден в таблице")

    def _coords_to_char(self, i, j):
        # Получение символа по координатам
        return self.table[i][j]

    def encrypt(self, text):
        # Шифрование текста
        encrypted = []
        for char in text.upper():
            if char.isalpha():
                i, j = self._char_to_coords(char)
                # Применяем перестановку на основе ключа
                new_i = (i + self.key) % 5
                new_j = (j + self.key) % 5
                encrypted.append(self._coords_to_char(new_i, new_j))
            else:
                encrypted.append(char)
        return ''.join(encrypted)

    def decrypt(self, text):
        # Расшифровка текста
        decrypted = []
        for char in text.upper():
            if char.isalpha():
                i, j = self._char_to_coords(char)
                # Обратная перестановка
                new_i = (i - self.key) % 5
                new_j = (j - self.key) % 5
                decrypted.append(self._coords_to_char(new_i, new_j))
            else:
                decrypted.append(char)
        return ''.join(decrypted)

class DamgardJurikCipher:
    def __init__(self, key):
        self.key = self._generate_key(key)

    def _generate_key(self, key):
        # Генерация ключа на основе хеша
        return int(hashlib.sha256(key.encode()).hexdigest(), 16)

    def _pad_text(self, text):
        # Дополнение текста до длины, кратной 8
        padding_length = 8 - (len(text) % 8)
        return text + ' ' * padding_length

    def _unpad_text(self, text):
        # Удаление дополнения
        return text.rstrip()

    def _block_permutation(self, block):
        # Перестановка битов в блоке на основе ключа
        key_hash = hashlib.sha256(str(self.key).encode()).digest()
        permuted_block = []
        for i, char in enumerate(block):
            key_byte = key_hash[i % len(key_hash)]
            new_char = chr((ord(char) + key_byte) % 256)
            permuted_block.append(new_char)
        return ''.join(permuted_block)

    def _inverse_block_permutation(self, block):
        # Обратная перестановка битов в блоке
        key_hash = hashlib.sha256(str(self.key).encode()).digest()
        original_block = []
        for i, char in enumerate(block):
            key_byte = key_hash[i % len(key_hash)]
            original_char = chr((ord(char) - key_byte) % 256)
            original_block.append(original_char)
        return ''.join(original_block)

    def encrypt(self, text):
        # Шифрование текста
        padded_text = self._pad_text(text)
        encrypted_blocks = []
        for i in range(0, len(padded_text), 8):
            block = padded_text[i:i+8]
            permuted_block = self._block_permutation(block)
            encrypted_blocks.append(permuted_block)
        return ''.join(encrypted_blocks)

    def decrypt(self, text):
        # Расшифровка текста
        decrypted_blocks = []
        for i in range(0, len(text), 8):
            block = text[i:i+8]
            original_block = self._inverse_block_permutation(block)
            decrypted_blocks.append(original_block)
        return self._unpad_text(''.join(decrypted_blocks))

if __name__ == "__main__":
    key = "фф12К52"
    text = "HELLO WORLD"

    # Шифр Россиньоля
    rossignol = RossignolCipher(key)
    encrypted_rossignol = rossignol.encrypt(text)
    decrypted_rossignol = rossignol.decrypt(encrypted_rossignol)

    print("Россиньоль:")
    print(f"Исходный: {text}")
    print(f"Зашифрованный: {encrypted_rossignol}")
    print(f"Расшифрованный: {decrypted_rossignol}")
    print(f"Совпадение: {text.upper() == decrypted_rossignol}")

    # Криптосистема Дамгорда-Юрика
    damgard_jurik = DamgardJurikCipher(key)
    encrypted_damgard = damgard_jurik.encrypt(text)
    decrypted_damgard = damgard_jurik.decrypt(encrypted_damgard)

    print("\nДамгорд-Юрик:")
    print(f"Исходный: {text}")
    print(f"Зашифрованный: {encrypted_damgard}")
    print(f"Расшифрованный: {decrypted_damgard}")
    print(f"Совпадение: {text == decrypted_damgard}")

```
