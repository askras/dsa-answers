# ОТЧЕТ ПО ЛАБОРАТОРНОЙ РАБОТЕ
## «Лабораторная работа №5. Хеш-функции и хеш-таблицы»

### Цель работы: Изучение хеш-функций и хеш-таблиц, а также основных операций над ними.

### Работу выполнил: Цыганков Д.С 

## Задание 1 - Реализовать хеш-таблицу на основе метода цепочек.
```python
class Node:
   
    def __init__(self, key, value):
        self.key = key
        self.value = value
        self.next = None

class HashTableChaining:
    
    def __init__(self, capacity=10):
        self.capacity = capacity
        self.size = 0
        self.table = [None] * capacity
        self.load_factor_threshold = 0.75
    
    def _hash(self, key):
        if isinstance(key, int):
            return key % self.capacity
        elif isinstance(key, str):
            hash_val = 0
            for char in key:
                hash_val = (hash_val * 31 + ord(char)) % self.capacity
            return hash_val
        else:
            return hash(key) % self.capacity
    
    def _resize(self):
        old_table = self.table
        self.capacity *= 2
        self.table = [None] * self.capacity
        self.size = 0
        
        for bucket in old_table:
            current = bucket
            while current:
                self.put(current.key, current.value)
                current = current.next
    
    def put(self, key, value):
        if self.size / self.capacity >= self.load_factor_threshold:
            self._resize()
            
        index = self._hash(key)
        
        if self.table[index] is None:
            self.table[index] = Node(key, value)
            self.size += 1
            return
        
        current = self.table[index]
        while current:
            if current.key == key:
                current.value = value  #Обнов. знач.
                return
            if current.next is None:
                break
            current = current.next
        
        current.next = Node(key, value)
        self.size += 1
    
    def get(self, key):
        index = self._hash(key)
        current = self.table[index]
        
        while current:
            if current.key == key:
                return current.value
            current = current.next
        
        raise KeyError(f"Key {key} not found")
    
    def remove(self, key):
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
                return current.value
            prev = current
            current = current.next
        
        raise KeyError(f"Key {key} not found")
    
    def contains(self, key):
        try:
            self.get(key)
            return True
        except KeyError:
            return False
    
    def __str__(self):
        result = []
        for i, bucket in enumerate(self.table):
            if bucket is not None:
                chain = []
                current = bucket
                while current:
                    chain.append(f"({current.key}: {current.value})")
                    current = current.next
                result.append(f"Bucket {i}: {' -> '.join(chain)}")
            else:
                result.append(f"Bucket {i}: None")
        return "\n".join(result)

def demo_chaining():
    print("=== Хеш-таблица с методом цепочек ===")
    ht = HashTableChaining(5)
    
    ht.put("apple", 1)
    ht.put("banana", 2)
    ht.put("orange", 3)
    ht.put("grape", 4)
    ht.put("kiwi", 5)
    
    print("Таблица после добавления элементов:")
    print(ht)
    print()
    
    print(f"Значение для 'apple': {ht.get('apple')}")
    print(f"Содержит 'banana': {ht.contains('banana')}")
    print()
    
    ht.remove("orange")
    print("После удаления 'orange':")
    print(ht)

```

## Задание 2 - Реализовать хеш-таблицу на основе открытой адресации.
```python
class HashEntry:
    def __init__(self, key, value):
        self.key = key
        self.value = value
        self.is_deleted = False

class HashTableOpenAddressing:
    
    def __init__(self, capacity=10):
        self.capacity = capacity
        self.size = 0
        self.table = [None] * capacity
        self.load_factor_threshold = 0.7
        self.DELETED = HashEntry(None, None) 
    
    def _hash(self, key):
        if isinstance(key, int):
            return key % self.capacity
        elif isinstance(key, str):
            hash_val = 0
            for char in key:
                hash_val = (hash_val * 31 + ord(char)) % self.capacity
            return hash_val
        else:
            return hash(key) % self.capacity
    
    def _hash2(self, key):
        if isinstance(key, int):
            return 1 + (key % (self.capacity - 1))
        elif isinstance(key, str):
            hash_val = 0
            for char in key:
                hash_val = (hash_val * 17 + ord(char)) % (self.capacity - 1)
            return 1 + hash_val
        else:
            return 1 + (hash(key) % (self.capacity - 1))
    
    def _probe(self, key, i):
        return (self._hash(key) + i * self._hash2(key)) % self.capacity
    
    def _resize(self):
        old_table = self.table
        self.capacity *= 2
        self.table = [None] * self.capacity
        self.size = 0
        
        for entry in old_table:
            if entry and entry != self.DELETED:
                self.put(entry.key, entry.value)
    
    def put(self, key, value):
        """Добавление элемента в таблицу"""
        if self.size / self.capacity >= self.load_factor_threshold:
            self._resize()
        
        for i in range(self.capacity):
            index = self._probe(key, i)
            
            if self.table[index] is None or self.table[index] == self.DELETED:
                self.table[index] = HashEntry(key, value)
                self.size += 1
                return
            elif self.table[index].key == key:
                self.table[index].value = value  # Обновление значения
                return
        
        raise Exception("Hash table is full")
    
    def get(self, key):
        """Получение значения по ключу"""
        for i in range(self.capacity):
            index = self._probe(key, i)
            
            if self.table[index] is None:
                break
            elif self.table[index] != self.DELETED and self.table[index].key == key:
                return self.table[index].value
        
        raise KeyError(f"Key {key} not found")
    
    def remove(self, key):
        for i in range(self.capacity):
            index = self._probe(key, i)
            
            if self.table[index] is None:
                break
            elif self.table[index] != self.DELETED and self.table[index].key == key:
                self.table[index] = self.DELETED
                self.size -= 1
                return
        
        raise KeyError(f"Key {key} not found")
    
    def contains(self, key):
        try:
            self.get(key)
            return True
        except KeyError:
            return False
    
    def __str__(self):
        result = []
        for i, entry in enumerate(self.table):
            if entry is None:
                result.append(f"Index {i}: None")
            elif entry == self.DELETED:
                result.append(f"Index {i}: DELETED")
            else:
                result.append(f"Index {i}: ({entry.key}: {entry.value})")
        return "\n".join(result)

def demo_open_addressing():
    print("\n=== Хеш-таблица с открытой адресацией ===")
    ht = HashTableOpenAddressing(7)
    
    ht.put("cat", 1)
    ht.put("dog", 2)
    ht.put("bird", 3)
    ht.put("fish", 4)
    
    print("Таблица после добавления элементов:")
    print(ht)
    print()
    
    print(f"Значение для 'cat': {ht.get('cat')}")
    print(f"Содержит 'dog': {ht.contains('dog')}")
    print()
    
    ht.remove("bird")
    print("После удаления 'bird':")
    print(ht)

```

## Задание 3 - Блокчейн (2 балла) В блокчейне хеш-функции используются для создания уникальных идентификаторов блоков и обеспечения целостности данных. Каждый блок содержит хеш предыдущего блока, что создает цепочку и делает систему устойчивой к изменениям.
```python
import hashlib
import time
import json

class Block:
    """Блок в блокчейне"""
    def __init__(self, index, timestamp, data, previous_hash):
        self.index = index
        self.timestamp = timestamp
        self.data = data
        self.previous_hash = previous_hash
        self.nonce = 0
        self.hash = self.calculate_hash()
    
    def calculate_hash(self):
        """Вычисление хеша блока"""
        block_string = json.dumps({
            "index": self.index,
            "timestamp": self.timestamp,
            "data": self.data,
            "previous_hash": self.previous_hash,
            "nonce": self.nonce
        }, sort_keys=True)
        return hashlib.sha256(block_string.encode()).hexdigest()
    
    def mine_block(self, difficulty):
        """Майнинг блока (proof-of-work)"""
        target = "0" * difficulty
        while self.hash[:difficulty] != target:
            self.nonce += 1
            self.hash = self.calculate_hash()
    
    def __str__(self):
        return f"Block {self.index} [Hash: {self.hash}, Previous: {self.previous_hash}]"

class Blockchain:
    """Простая реализация блокчейна"""
    
    def __init__(self):
        self.chain = [self.create_genesis_block()]
        self.difficulty = 2
        self.pending_transactions = []
    
    def create_genesis_block(self):
        """Создание начального блока"""
        return Block(0, time.time(), "Genesis Block", "0")
    
    def get_latest_block(self):
        """Получение последнего блока"""
        return self.chain[-1]
    
    def add_block(self, data):
        """Добавление нового блока"""
        new_block = Block(
            len(self.chain),
            time.time(),
            data,
            self.get_latest_block().hash
        )
        new_block.mine_block(self.difficulty)
        self.chain.append(new_block)
    
    def is_chain_valid(self):
        """Проверка целостности блокчейна"""
        for i in range(1, len(self.chain)):
            current_block = self.chain[i]
            previous_block = self.chain[i-1]
            
            # Проверка хеша текущего блока
            if current_block.hash != current_block.calculate_hash():
                return False
            
            # Проверка связи с предыдущим блоком
            if current_block.previous_hash != previous_block.hash:
                return False
        
        return True
    
    def display_chain(self):
        for block in self.chain:
            print(block)

def demo_blockchain():
    print("\n=== Блокчейн ===")
    blockchain = Blockchain()
    
    print("Создание блокчейна...")
    blockchain.add_block("Первая транзакция: Alice -> Bob 5 BTC")
    blockchain.add_block("Вторая транзакция: Bob -> Charlie 3 BTC")
    blockchain.add_block("Третья транзакция: Charlie -> Dave 1 BTC")
    
    print("Блокчейн:")
    blockchain.display_chain()
    
    print(f"\nЦепочка валидна: {blockchain.is_chain_valid()}")
    
    print("\nПопытка изменения данных...")
    blockchain.chain[1].data = "Поддельная транзакция: Alice -> Hacker 100 BTC"
    blockchain.chain[1].hash = blockchain.chain[1].calculate_hash()
    
    print(f"Цепочка после подделки валидна: {blockchain.is_chain_valid()}")
```

## Задание 4 - Проверка пересечения двух массивов
```python
def find_intersection(arr1, arr2):

    if not arr1 or not arr2:
        return False
    
    set1 = set(arr1)
    
    for element in arr2:
        if element in set1:
            return True
    
    return False

def demo_intersection():
    print("\n=== Проверка пересечения массивов ===")
    arr1 = [1, 2, 3, 4, 5]
    arr2 = [5, 6, 7, 8, 9]
    arr3 = [10, 11, 12]
    
    print(f"Массив 1: {arr1}")
    print(f"Массив 2: {arr2}")
    print(f"Массив 3: {arr3}")
    print(f"arr1 и arr2 пересекаются: {find_intersection(arr1, arr2)}")
    print(f"arr1 и arr3 пересекаются: {find_intersection(arr1, arr3)}")
```

## Задание 5 - Проверка уникальности элементов в массиве
```python
def has_unique_elements(arr):

    if not arr:
        return True
    
    seen = set()
    
    for element in arr:
        if element in seen:
            return False
        seen.add(element)
    
    return True

def demo_uniqueness():
    print("\n=== Проверка уникальности элементов ===")
    arr1 = [1, 2, 3, 4, 5]
    arr2 = [1, 2, 3, 2, 4]
    arr3 = []
    
    print(f"Массив {arr1} содержит только уникальные элементы: {has_unique_elements(arr1)}")
    print(f"Массив {arr2} содержит только уникальные элементы: {has_unique_elements(arr2)}")
    print(f"Массив {arr3} содержит только уникальные элементы: {has_unique_elements(arr3)}")
```

## Задание 6 - Нахождение пар с заданной суммой
```python
def find_pairs_with_sum(arr, target_sum):

    if not arr:
        return []
    
    pairs = []
    seen = set()
    complements = set()
    
    for num in arr:
        complement = target_sum - num
        
        if complement in complements:
            # Добавляем пару в отсортированном виде для избежания дубликатов
            pair = (min(num, complement), max(num, complement))
            if pair not in seen:
                pairs.append(pair)
                seen.add(pair)
        
        complements.add(num)
    
    return pairs

def demo_pairs_sum():
    print("\n=== Поиск пар с заданной суммой ===")
    arr = [2, 7, 11, 15, 3, 6, 8, 1, 4]
    target = 10
    
    print(f"Массив: {arr}")
    print(f"Целевая сумма: {target}")
    
    pairs = find_pairs_with_sum(arr, target)
    print(f"Найденные пары: {pairs}")
```

## Задание 7 -  Задача на проверку анаграмм Даны две строки. Необходимо определить, являются ли они анаграммами (содержат одни и те же символы в одинаковом количестве).
```python
def are_anagrams(str1, str2):

    if len(str1) != len(str2):
        return False
    
    char_count = {}
    
    for char in str1:
        char_count[char] = char_count.get(char, 0) + 1
    
    for char in str2:
        if char not in char_count:
            return False
        char_count[char] -= 1
        if char_count[char] == 0:
            del char_count[char]
    
    return len(char_count) == 0

def are_anagrams_sorted(str1, str2):
    """Альтернативная реализация через сортировку"""
    return sorted(str1) == sorted(str2)

def demo_anagrams():
    print("\n=== Проверка анаграмм ===")
    test_cases = [
        ("listen", "silent"),
        ("hello", "world"),
        ("anagram", "nagaram"),
        ("rat", "car"),
        ("", "")
    ]
    
    for str1, str2 in test_cases:
        result = are_anagrams(str1, str2)
        print(f"'{str1}' и '{str2}' являются анаграммами: {result}")
```
