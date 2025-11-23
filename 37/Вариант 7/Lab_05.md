# Хеш-функции и хеш-таблицы
Фомин И.Н.
ИУ10-37
## Задания
### Задание 1 Реализовать хеш-таблицу на основе метода цепочек


```python
class ChainedHashTable:
    def __init__(self, size=10):
        self.size = size
        self.table = [[] for _ in range(size)]

    def _hash(self, key):
        if isinstance(key, int):
            return key % self.size
        elif isinstance(key, str):
            hash_value = 0
            for char in key:
                hash_value = (hash_value * 31 + ord(char)) % self.size
            return hash_value
        else:
            raise TypeError("Unsupported key type")

    def insert(self, key, value):
        index = self._hash(key)
        for pair in self.table[index]:
            if pair[0] == key:
                pair[1] = value
                return
        self.table[index].append([key, value])

    def search(self, key):
        index = self._hash(key)
        for pair in self.table[index]:
            if pair[0] == key:
                return pair[1]
        return None

    def delete(self, key):
        index = self._hash(key)
        for i, pair in enumerate(self.table[index]):
            if pair[0] == key:
                self.table[index].pop(i)
                return True
        return False

ht = ChainedHashTable()
ht.insert("apple", 10)
ht.insert("banana", 20)
print(ht.search("apple"))
ht.delete("apple")
print(ht.search("apple"))
```

    10
    None


### Задание 2 Реализовать хеш-таблицу на основе открытой адресации.


```python
class OpenAddressHashTable:
    def __init__(self, size=10):
        self.size = size
        self.table = [None] * size
        self.deleted = object()

    def _hash(self, key):
        if isinstance(key, int):
            return key % self.size
        elif isinstance(key, str):
            hash_value = 0
            for char in key:
                hash_value = (hash_value * 31 + ord(char)) % self.size
            return hash_value
        else:
            raise TypeError("Unsupported key type")

    def insert(self, key, value):
        index = self._hash(key)
        for i in range(self.size):
            probe_index = (index + i) % self.size
            if self.table[probe_index] is None or self.table[probe_index] is self.deleted:
                self.table[probe_index] = (key, value)
                return
            elif self.table[probe_index][0] == key:
                self.table[probe_index] = (key, value)
                return
        raise Exception("Hash table is full")

    def search(self, key):
        index = self._hash(key)
        for i in range(self.size):
            probe_index = (index + i) % self.size
            if self.table[probe_index] is None:
                return None
            elif self.table[probe_index] is not self.deleted and self.table[probe_index][0] == key: 
                return self.table[probe_index][1]
        return None

    def delete(self, key):
        index = self._hash(key)
        for i in range(self.size):
            probe_index = (index + i) % self.size
            if self.table[probe_index] is None:
                return False
            elif self.table[probe_index] is not self.deleted and self.table[probe_index][0] == key: 
                self.table[probe_index] = self.deleted
                return True
        return False

ht2 = OpenAddressHashTable()
ht2.insert("apple", 10)
ht2.insert("banana", 20)
print(ht2.search("banana")) 
ht2.delete("banana")
print(ht2.search("banana"))
```

    20
    None


### Задание 3 Блокчейн


```python
import hashlib

class Block:
    def __init__(self, data, previous_hash='0'):
        self.data = data
        self.previous_hash = previous_hash
        self.hash = self._hash()

    def _hash(self):
        block_str = str(self.data) + self.previous_hash
        return hashlib.sha256(block_str.encode()).hexdigest()

class Blockchain:
    def __init__(self):
        self.chain = [Block("Genesis Block")]

    def add_block(self, data):
        previous_hash = self.chain[-1].hash
        new_block = Block(data, previous_hash)
        self.chain.append(new_block)

bc = Blockchain()
bc.add_block("Block 1 Data")
bc.add_block("Block 2 Data")
for block in bc.chain:
    print(block.data, block.hash)
```

    Genesis Block 8500b59bb5271135cd9bcbf0afd693028d76df3b9c7da58d412b13fc8a8f9394
    Block 1 Data 03f09f339809d9da980b1f1740af74cda2cc392e5c680f10b25283c268153417
    Block 2 Data c687457e4f9c4a622da664979022024af171bc0ca0e916704a4436cd434d2fdc


### Задание 4 Проверка пересечения двух массивов


```python
def has_intersection(arr1, arr2):
    for item in arr2:
        if item in arr1:
            return True
    return False

print(has_intersection([1,2,3],[3,4,5]))
```

    True


### Задание 5 Проверка уникальности элементов в массиве


```python
def all_unique(arr):
    return len(arr) == len(set(arr))

print(all_unique([1,2,3,3]))
```

    False


### Задание 6 Нахождение пар с заданной суммой


```python
def find_pairs_with_sum(arr, target):
    pairs = []
    for i in range(len(arr)):
        num1 = arr[i]
        for j in range(i + 1, len(arr)):
            num2 = arr[j]
            if num1 + num2 == target:
                pair = (num1, num2)
                if pair not in pairs and (pair[::-1]) not in pairs:
                    pairs.append(pair)
    return pairs

print(find_pairs_with_sum([1,2,3,4,5], 5))
```

    [(1, 4), (2, 3)]


### Задание 7 Задача на проверку анаграмм


```python
def are_anagrams(str1, str2):
    if len(str1) != len(str2):
        return False
    count = {}
    for c in str1:
        count[c] = count.get(c, 0) + 1
    for c in str2:
        if c not in count:
            return False
        count[c] -= 1
        if count[c] < 0:
            return False
    return True

print(are_anagrams("undertale","deltarune"))
```

    True

