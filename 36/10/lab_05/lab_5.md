---
jupytext:
  formats: ipynb,md:myst
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.17.3
kernelspec:
  name: python3
  display_name: Python 3 (ipykernel)
  language: python
---

# Хеш-функции и хеш-таблицы


### Цель работы

Изучение хеш-функций и хеш-таблиц, а также основных операций над ними.

+++

## Задания

**1. Реализовать хеш-таблицу на основе метода цепочек.**

+++

Узел для метода цепочек:

```{code-cell} ipython3
class Node:
    def __init__(self, key, value):
        self.key = key
        self.value = value
        self.next = None
```

Хеш-таблица на основе метода цепочек:

```{code-cell} ipython3
class HashTableChaining:    
    def __init__(self, size=10):
        self.size = size
        self.table = [None] * size
        self.count = 0
        self.load_factor_threshold = 0.75
    
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
    
    def _resize(self):
        if self.count / self.size > self.load_factor_threshold:
            old_table = self.table
            old_size = self.size
            self.size = self.size * 2
            self.table = [None] * self.size
            self.count = 0
            for head in old_table:
                current = head
                while current:
                    self.put(current.key, current.value)
                    current = current.next
    
    def put(self, key, value):
        self._resize()
        index = self._hash(key)
        current = self.table[index]
        while current:
            if current.key == key:
                current.value = value
                return
            current = current.next
        new_node = Node(key, value)
        new_node.next = self.table[index]
        self.table[index] = new_node
        self.count += 1
    
    def get(self, key):
        index = self._hash(key)
        current = self.table[index]
        while current:
            if current.key == key:
                return current.value
            current = current.next
        raise KeyError(f"Key {key} not found")
    
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
                self.count -= 1
                return True
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
        for i, head in enumerate(self.table):
            chain = []
            current = head
            while current:
                chain.append(f"({current.key}: {current.value})")
                current = current.next
            if chain:
                result.append(f"Bucket {i}: {' -> '.join(chain)}")
        return "\n".join(result)
```

**2. Реализовать хеш-таблицу на основе открытой адресации.**

+++

Хеш-таблица на основе открытой адресации с линейным пробированием:

```{code-cell} ipython3
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
    
    def __str__(self):
        result = []
        for i, item in enumerate(self.table):
            if item is None:
                result.append(f"Bucket {i}: None")
            elif item == self.DELETED:
                result.append(f"Bucket {i}: DELETED")
            else:
                result.append(f"Bucket {i}: ({item[0]}: {item[1]})")
        return "\n".join(result)
```

**3. Блокчейн**

+++

Блок для блокчейна:

```{code-cell} ipython3
class Block:
    def __init__(self, index, timestamp, data, previous_hash):
        self.index = index
        self.timestamp = timestamp
        self.data = data
        self.previous_hash = previous_hash
        self.hash = self.calculate_hash()
    
    def calculate_hash(self):
        import hashlib
        block_string = f"{self.index}{self.timestamp}{self.data}{self.previous_hash}"
        return hashlib.sha256(block_string.encode()).hexdigest()
    
    def __str__(self):
        return f"Block {self.index} [Hash: {self.hash}, Previous: {self.previous_hash}, Data: {self.data}]"
```

Реализация блокчейна:

```{code-cell} ipython3
class Blockchain:    
    def __init__(self):
        self.chain = [self.create_genesis_block()]
    
    def create_genesis_block(self):
        return Block(0, "01/01/2023", "Genesis Block", "0")
    
    def add_block(self, data):
        previous_block = self.chain[-1]
        new_block = Block(
            index=len(self.chain),
            timestamp="current_time",
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
    
    def __str__(self):
        return "\n".join(str(block) for block in self.chain)
```

**4. Проверка пересечения двух массивов**

```{code-cell} ipython3
def has_intersection(arr1, arr2):
    hash_set = set(arr1)
    for item in arr2:
        if item in hash_set:
            return True
    return False
```

```{code-cell} ipython3
arr1 = [1, 2, 3, 4, 5]
arr2 = [5, 6, 7, 8, 9]
arr3 = [10, 11, 12]    
print(f"Массивы {arr1} и {arr2} пересекаются: {has_intersection(arr1, arr2)}")
print(f"Массивы {arr1} и {arr3} пересекаются: {has_intersection(arr1, arr3)}")
```

**5. Проверка уникальности элементов в массиве**

```{code-cell} ipython3
def has_unique_elements(arr):
    hash_set = set()
    for item in arr:
        if item in hash_set:
            return False
        hash_set.add(item)
    return True
```

```{code-cell} ipython3
unique_arr = [1, 2, 3, 4, 5]
duplicate_arr = [1, 2, 3, 2, 4]    
print(f"\nМассив {unique_arr} содержит только уникальные элементы: {has_unique_elements(unique_arr)}")
print(f"Массив {duplicate_arr} содержит только уникальные элементы: {has_unique_elements(duplicate_arr)}")
```

**6. Нахождение пар с заданной суммой**

```{code-cell} ipython3
def find_pairs_with_sum(arr, target_sum):
    result = []
    seen = set()
    for num in arr:
        complement = target_sum - num
        if complement in seen:
            result.append((complement, num))
        seen.add(num)
    return result
```

```{code-cell} ipython3
numbers = [2, 7, 11, 15, 3, 6, 8]
target = 10    
pairs = find_pairs_with_sum(numbers, target)
print(f"\nПары в массиве {numbers} с суммой {target}: {pairs}")
```

**7. Задача на проверку анаграмм**

```{code-cell} ipython3
def are_anagrams(str1, str2):
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
```

```{code-cell} ipython3
str1 = "listen"
str2 = "silent"
str3 = "hello"
str4 = "world"    
print(f"\nСтроки '{str1}' и '{str2}' являются анаграммами: {are_anagrams(str1, str2)}")
print(f"Строки '{str3}' и '{str4}' являются анаграммами: {are_anagrams(str3, str4)}")
```
