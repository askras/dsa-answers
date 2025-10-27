#### Задание 1


```python
class Node:
    def __init__(self, key, value):
        self.key = key
        self.value = value
        self.next = None

class ChainingHashTable:
    def __init__(self, capacity=10, load_factor=0.75):
        self.capacity = capacity
        self.load_factor = load_factor
        self.size = 0
        self.table = [None] * capacity
    
    def _hash(self, key):
        if isinstance(key, int):
            return key % self.capacity
        elif isinstance(key, str):
            hash_val = 0
            prime = 31
            for char in key:
                hash_val = (hash_val * prime + ord(char)) % self.capacity
            return hash_val
        else:
            return hash(key) % self.capacity
    
    def insert(self, key, value):
        if self.size / self.capacity >= self.load_factor:
            self._resize()
        
        index = self._hash(key)
        
        if self.table[index] is None:
            self.table[index] = Node(key, value)
            self.size += 1
            return
        
        current = self.table[index]
        while current:
            if current.key == key:
                current.value = value
                return
            if current.next is None:
                break
            current = current.next
        
        current.next = Node(key, value)
        self.size += 1
    
    def search(self, key):
        index = self._hash(key)
        current = self.table[index]
        
        while current:
            if current.key == key:
                return current.value
            current = current.next
        
        return None
    
    def delete(self, key):
        index = self._hash(key)
        current = self.table[index]
        prev = None
        
        while current:
            if current.key == key:
                if prev:
                    prev.next = current.next
                else:
                    self.table[index] = current.next
                self.size -= 1
                return True
            prev = current
            current = current.next
        
        return False
    
    def _resize(self):
        old_table = self.table
        self.capacity *= 2
        self.table = [None] * self.capacity
        self.size = 0
        
        for head in old_table:
            current = head
            while current:
                self.insert(current.key, current.value)
                current = current.next
    
    def display(self):
        for i in range(self.capacity):
            print(f"Bucket {i}: ", end="")
            current = self.table[i]
            elements = []
            while current:
                elements.append(f"({current.key}: {current.value})")
                current = current.next
            print(" -> ".join(elements) if elements else "Empty")

    def put(self, key, value):
        self.insert(key, value)
    
    def get(self, key):
        return self.search(key)
    
    def remove(self, key):
        return self.delete(key)
    
    def __len__(self):
        return self.size
    
    def __contains__(self, key):
        return self.search(key) is not None
    
    def __getitem__(self, key):
        value = self.search(key)
        if value is None:
            raise KeyError(f"Key '{key}' not found")
        return value
    
    def __setitem__(self, key, value):
        self.insert(key, value)


def test_chaining_hash_table():
    print("=== Тестирование хеш-таблицы с методом цепочек ===")
    
    ht = ChainingHashTable()
    
    ht.put("apple", 5)
    ht.put("banana", 10)
    assert ht.get("apple") == 5
    assert ht.get("banana") == 10
    assert ht.get("orange") is None
    print("✓ Базовая функциональность работает")
    
    ht.put("apple", 15)
    assert ht.get("apple") == 15
    assert len(ht) == 2
    print("✓ Обновление значений работает")
    
    assert ht.remove("apple") == True
    assert ht.remove("apple") == False
    assert ht.get("apple") is None
    assert len(ht) == 1
    print("✓ Удаление элементов работает")
    
    ht["grape"] = 20
    assert ht["grape"] == 20
    assert "grape" in ht
    assert "apple" not in ht
    print("✓ Python операторы работают")
    
    small_ht = ChainingHashTable(2)
    small_ht.put("a", 1)
    small_ht.put("b", 2)
    small_ht.put("c", 3)
    assert small_ht.get("a") == 1
    assert small_ht.get("b") == 2
    assert small_ht.get("c") == 3
    print("✓ Обработка коллизий работает")
    
    print("\nДополнительные тесты:")
    
    resize_ht = ChainingHashTable(3)
    for i in range(10):
        resize_ht.put(f"key{i}", i)
    assert len(resize_ht) == 10
    assert resize_ht.get("key5") == 5
    print("✓ Ресайз таблицы работает")
    
    print("Пример отображения таблицы:")
    demo_ht = ChainingHashTable(5)
    demo_ht.put("cat", 1)
    demo_ht.put("dog", 2)
    demo_ht.put("bird", 3)
    demo_ht.display()
    
    print("\nВсе тесты метода цепочек пройдены! ✅")


if __name__ == "__main__":
    test_chaining_hash_table()
```

    === Тестирование хеш-таблицы с методом цепочек ===
    ✓ Базовая функциональность работает
    ✓ Обновление значений работает
    ✓ Удаление элементов работает
    ✓ Python операторы работают
    ✓ Обработка коллизий работает
    
    Дополнительные тесты:
    ✓ Ресайз таблицы работает
    Пример отображения таблицы:
    Bucket 0: Empty
    Bucket 1: Empty
    Bucket 2: (cat: 1) -> (bird: 3)
    Bucket 3: Empty
    Bucket 4: (dog: 2)
    
    Все тесты метода цепочек пройдены! ✅


#### Задание 2


```python
class HashTableOpenAddressing:    
    def __init__(self, size=10):
        self.size = size
        self.table = [None] * size
        self.count = 0
        self.load_factor_threshold = 0.7
        self.DELETED = object()

    def _hash(self, key):
        if isinstance(key, int):
            return key % self.size
        elif isinstance(key, str):
            hash_value = 0
            for char in key:
                hash_value = (hash_value * 31 + ord(char)) % self.size
            return hash_value 
        else:
            return hash(key) % self.size

    def _probe(self, key, i):
        return (self._hash(key) + i) % self.size

    def _resize(self):
        if self.count / self.size > self.load_factor_threshold:
            old_table = self.table
            old_size = self.size
            self.size = self.size * 2
            self.table = [None] * self.size
            self.count = 0
            for item in old_table:
                if item and item != self.DELETED:
                    self.put(item[0], item[1])

    def put(self, key, value):
        self._resize()
        for i in range(self.size):
            index = self._probe(key, i)
            if self.table[index] is None or self.table[index] == self.DELETED:
                self.table[index] = (key, value)
                self.count += 1
                return
            elif self.table[index][0] == key:
                self.table[index] = (key, value)
                return
        raise Exception("Hash table is full")

    def get(self, key):
        for i in range(self.size):
            index = self._probe(key, i)
            if self.table[index] is None:
                break
            elif self.table[index] != self.DELETED and self.table[index][0] == key:
                return self.table[index][1]
        raise KeyError(f"Key {key} not found")

    def delete(self, key):
        for i in range(self.size):
            index = self._probe(key, i)
            if self.table[index] is None:
                break
            elif self.table[index] != self.DELETED and self.table[index][0] == key:
                self.table[index] = self.DELETED
                self.count -= 1
                return True
        raise KeyError(f"Key {key} not found")

    def contains(self, key):
        try:
            self.get(key)
            return True
        except KeyError:
            return False

    def display(self):
        result = []
        for i, item in enumerate(self.table):
            if item is None:
                result.append(f"Bucket {i}: None")
            elif item == self.DELETED:
                result.append(f"Bucket {i}: DELETED")
            else:
                result.append(f"Bucket {i}: ({item[0]}: {item[1]})")
        return "\n".join(result)


def test_open_addressing_hash_table():
    print("=== Тестирование хеш-таблицы с открытой адресацией ===")
    
    ht = HashTableOpenAddressing()
    
    ht.put("apple", 5)
    ht.put("banana", 10)
    assert ht.get("apple") == 5
    assert ht.get("banana") == 10
    assert ht.count == 2
    print("✓ Базовая функциональность работает")
    
    ht.put("apple", 15)
    assert ht.get("apple") == 15
    assert ht.count == 2
    print("✓ Обновление значений работает")
    
    assert ht.delete("apple") == True
    assert ht.count == 1
    try:
        ht.get("apple")
        assert False
    except KeyError:
        pass
    assert ht.contains("banana") == True
    assert ht.contains("apple") == False
    print("✓ Удаление элементов работает")
    
    small_ht = HashTableOpenAddressing(5)
    small_ht.put("a", 1)
    small_ht.put("b", 2)
    small_ht.put("c", 3)
    small_ht.put("d", 4)
    assert small_ht.get("a") == 1
    assert small_ht.get("b") == 2
    assert small_ht.get("c") == 3
    assert small_ht.get("d") == 4
    assert small_ht.count == 4
    
    small_ht.delete("b")
    assert small_ht.contains("b") == False
    small_ht.put("e", 5)
    assert small_ht.get("e") == 5
    print("✓ Обработка коллизий работает")
    
    print("Все тесты открытой адресации пройдены! ✅\n")


if __name__ == "__main__":
    test_open_addressing_hash_table()
```

    === Тестирование хеш-таблицы с открытой адресацией ===
    ✓ Базовая функциональность работает
    ✓ Обновление значений работает
    ✓ Удаление элементов работает
    ✓ Обработка коллизий работает
    Все тесты открытой адресации пройдены! ✅
    


#### Задание 3


```python
import hashlib
import time

class Block:
    def __init__(self, index, timestamp, data, previous_hash):
        self.index = index
        self.timestamp = timestamp
        self.data = data
        self.previous_hash = previous_hash
        self.hash = self.calculate_hash()

    def calculate_hash(self):
        block_string = f"{self.index}{self.timestamp}{self.data}{self.previous_hash}"
        return hashlib.sha256(block_string.encode()).hexdigest()

    def __str__(self):
        return f"Block {self.index} [Hash: {self.hash}, Previous: {self.previous_hash}, Data: {self.data}]"

class Blockchain:    
    def __init__(self):
        self.chain = [self.create_genesis_block()]

    def create_genesis_block(self):
        return Block(0, time.time(), "Genesis Block", "0")

    def add_block(self, data):
        previous_block = self.chain[-1]
        new_block = Block(
            index=len(self.chain),
            timestamp=time.time(),
            data=data,
            previous_hash=previous_block.hash
        )
        self.chain.append(new_block)

    def is_chain_valid(self):
        for i in range(1, len(self.chain)):
            current_block = self.chain[i]
            previous_block = self.chain[i-1]
            if current_block.hash != current_block.calculate_hash():
                return False
            if current_block.previous_hash != previous_block.hash:
                return False
        return True

    def get_latest_block(self):
        return self.chain[-1]

    def get_chain_length(self):
        return len(self.chain)

    def display_chain(self):
        for block in self.chain:
            print(block)


def test_blockchain():
    print("=== Тестирование блокчейна ===")
    
    blockchain = Blockchain()
    
    assert len(blockchain.chain) == 1
    assert blockchain.chain[0].index == 0
    assert blockchain.chain[0].data == "Genesis Block"
    assert blockchain.chain[0].previous_hash == "0"
    assert blockchain.chain[0].hash == blockchain.chain[0].calculate_hash()
    print("✓ Генезис-блок создан корректно")
    
    blockchain.add_block("Transaction 1")
    blockchain.add_block("Transaction 2")
    assert len(blockchain.chain) == 3
    assert blockchain.chain[1].data == "Transaction 1"
    assert blockchain.chain[2].data == "Transaction 2"
    print("✓ Добавление блоков работает")
    
    assert blockchain.chain[1].previous_hash == blockchain.chain[0].hash
    assert blockchain.chain[2].previous_hash == blockchain.chain[1].hash
    print("✓ Связи между блоками корректны")
    
    assert blockchain.is_chain_valid() == True
    
    original_data = blockchain.chain[1].data
    blockchain.chain[1].data = "Tampered Data"
    assert blockchain.is_chain_valid() == False
    blockchain.chain[1].data = original_data
    
    original_hash = blockchain.chain[1].hash
    assert blockchain.chain[1].calculate_hash() == original_hash
    blockchain.chain[1].data = "Modified Data"
    assert blockchain.chain[1].calculate_hash() != original_hash
    blockchain.chain[1].data = original_data
    print("✓ Целостность данных и валидация работают")
    
    print("Все тесты блокчейна пройдены! ✅\n")


if __name__ == "__main__":
    test_blockchain()
```

    === Тестирование блокчейна ===
    ✓ Генезис-блок создан корректно
    ✓ Добавление блоков работает
    ✓ Связи между блоками корректны
    ✓ Целостность данных и валидация работают
    Все тесты блокчейна пройдены! ✅
    


#### Задание 4


```python
def has_intersection(arr1, arr2):
    hash_set = set(arr1)
    for item in arr2:
        if item in hash_set:
            return True
    return False


def test_has_intersection():
    print("=== Тестирование проверки пересечения массивов ===")
    
    arr1 = [1, 2, 3, 4, 5]
    arr2 = [5, 6, 7, 8, 9]
    assert has_intersection(arr1, arr2) == True
    print("✓ Тест 1: Есть пересечение - пройден")
    
    arr1 = [1, 2, 3, 4]
    arr2 = [5, 6, 7, 8]
    assert has_intersection(arr1, arr2) == False
    print("✓ Тест 2: Нет пересечения - пройден")
    
    arr1 = []
    arr2 = [1, 2, 3]
    assert has_intersection(arr1, arr2) == False
    arr1 = [1, 2, 3]
    arr2 = []
    assert has_intersection(arr1, arr2) == False
    arr1 = []
    arr2 = []
    assert has_intersection(arr1, arr2) == False
    print("✓ Тест 3: Пустые массивы - пройден")
    
    arr1 = [1, 2, 3, 4, 5]
    arr2 = [3, 4, 5, 6, 7]
    assert has_intersection(arr1, arr2) == True
    print("✓ Тест 4: Множественные пересечения - пройден")
    
    arr1 = ["apple", "banana", "orange"]
    arr2 = ["banana", "grape", "kiwi"]
    assert has_intersection(arr1, arr2) == True
    arr1 = [1.5, 2.7, 3.1]
    arr2 = [3.1, 4.2, 5.8]
    assert has_intersection(arr1, arr2) == True
    print("✓ Тест 5: Разные типы данных - пройден")
    
    print("Все тесты проверки пересечения пройдены! ✅\n")


if __name__ == "__main__":
    test_has_intersection()
```

    === Тестирование проверки пересечения массивов ===
    ✓ Тест 1: Есть пересечение - пройден
    ✓ Тест 2: Нет пересечения - пройден
    ✓ Тест 3: Пустые массивы - пройден
    ✓ Тест 4: Множественные пересечения - пройден
    ✓ Тест 5: Разные типы данных - пройден
    Все тесты проверки пересечения пройдены! ✅
    


#### Задание 5


```python
def has_unique_elements(arr):
    hash_set = set()
    for item in arr:
        if item in hash_set:
            return False
        hash_set.add(item)
    return True


def test_has_unique_elements():
    print("=== Тестирование проверки уникальности элементов ===")
    
    arr = [1, 2, 3, 4, 5]
    assert has_unique_elements(arr) == True
    print("✓ Тест 1: Все элементы уникальны - пройден")
    
    arr = [1, 2, 3, 2, 4]
    assert has_unique_elements(arr) == False
    print("✓ Тест 2: Есть дубликаты - пройден")
    
    arr = []
    assert has_unique_elements(arr) == True
    print("✓ Тест 3: Пустой массив - пройден")
    
    arr = [42]
    assert has_unique_elements(arr) == True
    print("✓ Тест 4: Один элемент - пройден")
    
    arr = ["apple", "banana", "orange"]
    assert has_unique_elements(arr) == True
    arr = ["apple", "banana", "apple"]
    assert has_unique_elements(arr) == False
    arr = [1, "1", 2, "2"]
    assert has_unique_elements(arr) == True
    print("✓ Тест 5: Разные типы данных - пройден")
    
    print("Все тесты проверки уникальности пройдены! ✅\n")


if __name__ == "__main__":
    test_has_unique_elements()
```

    === Тестирование проверки уникальности элементов ===
    ✓ Тест 1: Все элементы уникальны - пройден
    ✓ Тест 2: Есть дубликаты - пройден
    ✓ Тест 3: Пустой массив - пройден
    ✓ Тест 4: Один элемент - пройден
    ✓ Тест 5: Разные типы данных - пройден
    Все тесты проверки уникальности пройдены! ✅
    


#### Задание 6


```python
def find_pairs_with_sum(arr, target_sum):
    result = []
    seen = set()
    for num in arr:
        complement = target_sum - num
        if complement in seen:
            result.append((complement, num))
        seen.add(num)
    return result


def test_find_pairs_with_sum():
    print("=== Тестирование поиска пар с заданной суммой ===")
    
    arr = [2, 7, 11, 15, 3, 6, 8]
    target = 9
    result = find_pairs_with_sum(arr, target)
    
    assert (2, 7) in result
    assert (3, 6) in result
    assert len(result) == 2
    print("✓ Основной тест: найдены пары (2,7) и (3,6)")
    
    arr = [1, 2, 3, 4]
    target = 10
    result = find_pairs_with_sum(arr, target)
    assert len(result) == 0
    print("✓ Тест без пар - пройден")
    
    arr = [1, -2, 3, -4, 5]
    target = -1
    result = find_pairs_with_sum(arr, target)
    assert (3, -4) in result or (-4, 3) in result
    print("✓ Тест с отрицательными числами - пройден")
    
    arr = [1, 2, 2, 3, 4]
    target = 4
    result = find_pairs_with_sum(arr, target)
    assert (1, 3) in result
    assert (2, 2) in result
    print("✓ Тест с дубликатами - пройден")
    
    print("Все тесты поиска пар пройдены! ✅\n")


if __name__ == "__main__":
    test_find_pairs_with_sum()
```

#### Задание 7


```python
def are_anagrams(str1, str2):
    """Проверяет, являются ли две строки анаграммами"""
    if len(str1) != len(str2):
        return False
    
    char_count = {}
    for char in str1:
        char_count[char] = char_count.get(char, 0) + 1
    
    for char in str2:
        if char not in char_count or char_count[char] == 0:
            return False
        char_count[char] -= 1
    
    return True


def test_are_anagrams():
    print("=== Тестирование проверки анаграмм ===")
    
    str1 = "listen"
    str2 = "silent"
    assert are_anagrams(str1, str2) == True
    print("✓ Основной тест: 'listen' и 'silent' являются анаграммами")
    
    str1 = "hello"
    str2 = "hell"
    assert are_anagrams(str1, str2) == False
    print("✓ Тест с разной длиной - пройден")
    
    str1 = "hello"
    str2 = "world"
    assert are_anagrams(str1, str2) == False
    print("✓ Тест не анаграмм - пройден")
    
    str1 = "Dormitory"
    str2 = "Dirty room"
    assert are_anagrams(str1.lower().replace(" ", ""), str2.lower().replace(" ", "")) == True
    print("✓ Тест с пробелами и регистром - пройден")
    
    str1 = "aabbcc"
    str2 = "abcabc"
    assert are_anagrams(str1, str2) == True
    print("✓ Тест с повторяющимися символами - пройден")
    
    print("Все тесты проверки анаграмм пройдены! ✅\n")


if __name__ == "__main__":
    test_are_anagrams()
```
