# Лабораторная работа 5 Самойлов Даниил ИУ10-38
# Хеш-функции и хеш-таблицы
## Цель работы
Изучение хеш-функций и хеш-таблиц, а также основных операций над ними.
## Задачи лабораторной работы
1. Реализовать хеш-таблицы на основе метода цепочек и на основе открытой адресации .
2. Решить алгоритмические задачки 
## Словесная постановка задачи
1. Изучить теоретический материал по хеш функциям и таблицам.
2. Реализовать хеш-таблицы на основе метода цепочек и на основе открытой адресации .
3. Написать задания, использующие реализованные ранее структуры.

# Задачи
### 1. Хеш-таблица на основе метода цепочек
``` Python
class HashTableChaining:    
    def __init__(self, size=10):
        self.size = size
        self.table = [[] for _ in range(size)]
        self.count = 0
    
    def _hash(self, key):
        return hash(key) % self.size
    
    def insert(self, key, value):
        index = self._hash(key)
        bucket = self.table[index]
        for i, (k, v) in enumerate(bucket):
            if k == key:
                bucket[i] = (key, value)
                return
        
        bucket.append((key, value))
        self.count += 1
        
        if self.count / self.size > 0.7:
            self._rehash()
    
    def search(self, key):
        index = self._hash(key)
        bucket = self.table[index]
        
        for k, v in bucket:
            if k == key:
                return v
        return None
    
    def delete(self, key):
        index = self._hash(key)
        bucket = self.table[index]
        
        for i, (k, v) in enumerate(bucket):
            if k == key:
                del bucket[i]
                self.count -= 1
                return True
        return False
    
    def _rehash(self):
        old_table = self.table
        self.size *= 2
        self.table = [[] for _ in range(self.size)]
        self.count = 0
        for bucket in old_table:
            for key, value in bucket:
                self.insert(key, value)

    def __str__(self):
        result = []
        for i, bucket in enumerate(self.table):
            if bucket:
                result.append(f"Bucket {i}: {bucket}")
        return "\n".join(result)

```
### 2. Хеш-таблица на основе открытой адресации
```Python
class HashTableOpenAddressing:
    def __init__(self, size=10):
        self.size = size
        self.table = [None] * size
        self.count = 0
        self.DEL = object()
    
    def _hash(self, key, i=0):
        return (hash(key) + i) % self.size
    
    def insert(self, key, value):
        if self.count / self.size > 0.7:
            self._rehash()
        i = 0
        while i < self.size:
            index = self._hash(key, i)
            if self.table[index] is None or self.table[index] is self.DELETED:
                self.table[index] = (key, value)
                self.count += 1
                return
            elif self.table[index][0] == key:
                self.table[index] = (key, value)
                return
            i += 1
        
        self._rehash()
        self.insert(key, value)
    
    def search(self, key):
        i = 0
        while i < self.size:
            index = self._hash(key, i)
            if self.table[index] is None:
                return None
            elif self.table[index] is not self.DELETED and self.table[index][0] == key:
                return self.table[index][1]
            i += 1
        return None
    
    def delete(self, key):
        i = 0
        while i < self.size:
            index = self._hash(key, i)
            if self.table[index] is None:
                return False
            elif self.table[index] is not self.DELETED and self.table[index][0] == key:
                self.table[index] = self.DELETED
                self.count -= 1
                return True
            i += 1
        return False
    def _rehash(self):
        old_table = self.table
        self.size *= 2
        self.table = [None] * self.size
        self.count = 0
        for item in old_table:
            if item is not None and item is not self.DELETED:
                self.insert(item[0], item[1])
    
    def __str__(self):
        result = []
        for i, item in enumerate(self.table):
            if item is None:
                result.append(f"Index {i}: None")
            elif item is self.DELETED:
                result.append(f"Index {i}: DELETED")
            else:
                result.append(f"Index {i}: {item}")
        return "\n".join(result)

```
### 3.Блокчейн ?
```Python
class Block:
    def __init__(self, data, previous_hash=""):
        self.data = data
        self.previous_hash = previous_hash
        self.hash = self.calculate_hash()
    def calculate_hash(self):
        import hashlib
        data_string = str(self.data) + self.previous_hash
        return hashlib.sha256(data_string.encode()).hexdigest()
    
    def __str__(self):
        return f"Block(Data: {self.data}, Previous Hash: {self.previous_hash[:10]}..., Hash: {self.hash[:10]}...)"
        
class Blockchain:
    def __init__(self):
        self.chain = [self.create_genesis_block()]
    
    def create_genesis_block(self):
        return Block("Block", "0")
    
    def add_block(self, data):
        previous_block = self.chain[-1]
        new_block = Block(data, previous_block.hash)
        self.chain.append(new_block)
    
    def is_valid(self):
        for i in range(1, len(self.chain)):
            current_block = self.chain[i]
            previous_block = self.chain[i-1]
            if current_block.hash != current_block.calculate_hash():
                return False
            if current_block.previous_hash != previous_block.hash:
                return False    
        return True
    
    def __str__(self):
        return "\n".join(str(block) for block in self.chain)
```
### 4. Проверка пересечения двух массивов
```Python
def intersection(array1, array2):
    hash_set = set(array1)
    for element in array2:
        if element in hash_set:
            return True
    return False
```
### 5. Проверка уникальности элементов в массиве
```Python
def unique_elements(array):
    hash_set = set()
    for element in array:
        if element in hash_set:
            return False
        hash_set.add(element)
    return True
```
### 6. Нахождение пар с заданной суммой
```Python
def find_pairs_sum(array, target_sum):
    pairs = []
    seen = set()
    for num in array:
        diff = target_sum - num
        if diff in seen:
            pairs.append((diff, num))
        seen.add(num)
    return pairs
```
### 7. Задача на проверку анаграмм
```Python
def anagram(string1, string2):
    if len(string1) != len(string2):
        return False
    count = {}
    for char in str1:
        count[char] = count.get(char, 0) + 1
    for char in str2:
        if char not in count or count[char] == 0:
            return False
        count[char] -= 1
    return True
```
# Результат:
``` Python
a=[("a",1),("b",2),("c",3)]
b=[("a",2),("g",4),("f",5)]
c=[(1),(2),(3),(4),(5),(6)]
str1="abs"
str2="bsa"
str3="absnj"
print(f"1", intersection(a, b))
print(f"2", all_unique_elements(a))
print(f"3", find_pairs_with_sum(c, 6))
print(f"4", anagram(str1, str2))
print(f"5", anagram(str3, str2))
```
1 False
2 True
3 [(2, 4), (1, 5)]
4 True
5 False