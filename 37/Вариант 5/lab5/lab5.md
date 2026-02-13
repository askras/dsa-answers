#Хеш-функции и хеш-таблицы
Цель работы
Изучение хеш-функций и хеш-таблиц, а также основных операций над ними.
#Самуйлов С С ИУ10-37


```python
class Node:
    def __init__(self, key, value):
        self.key = key
        self.value = value
        self.next = None

class LinkedList:
    def __init__(self):
        self.head = None
    
    def insert(self, key, value):
        current = self.head
        while current:
            if current.key == key:
                current.value = value 
                return False
            current = current.next
        new_node = Node(key, value)
        new_node.next = self.head
        self.head = new_node
        return True
    
    def search(self, key):
        current = self.head
        while current:
            if current.key == key:
                return current.value
            current = current.next
        return None
    
    def delete(self, key):
        current = self.head
        prev = None
        
        while current:
            if current.key == key:
                if prev:
                    prev.next = current.next
                else:
                    self.head = current.next
                return True
            prev = current
            current = current.next
        
        return False

class HashTable:

    def __init__(self, capacity=10):
        self.capacity = capacity
        self.size = 0
        self.buckets = [LinkedList() for _ in range(capacity)]
    
    def _hash(self, key):

        return hash(key) % self.capacity
    
    def insert(self, key, value):
        index = self._hash(key)
        if self.buckets[index].insert(key, value):
            self.size += 1
    
    def search(self, key):
        index = self._hash(key)
        return self.buckets[index].search(key)
    
    def delete(self, key):
        index = self._hash(key)
        if self.buckets[index].delete(key):
            self.size -= 1
            return True
        return False

```


```python
class HashTable:
    DELETED = object()
    EMPTY = None
    
    def __init__(self, initial_size=8, load_factor=0.75):
        self.size = initial_size
        self.load_factor = load_factor
        self.count = 0
        self.keys = [self.EMPTY] * self.size
        self.values = [self.EMPTY] * self.size
    
    def _hash(self, key):
        return hash(key) % self.size
    
    def _rehash(self, hash_value, step=1):
        return (hash_value + step) % self.size
    
    def _resize(self, new_size):
        old_keys = self.keys
        old_values = self.values
        old_size = self.size
        
        self.size = new_size
        self.count = 0
        self.keys = [self.EMPTY] * self.size
        self.values = [self.EMPTY] * self.size
        
        for i in range(old_size):
            if old_keys[i] not in (self.EMPTY, self.DELETED):
                self.insert(old_keys[i], old_values[i])
    
    def _should_resize(self):
        return self.count >= self.size * self.load_factor
    
    def insert(self, key, value):
        if self._should_resize():
            self._resize(self.size * 2)
        
        index = self._hash(key)
        start_index = index
        first_deleted = None
        
        while self.keys[index] not in (self.EMPTY, self.DELETED):
            if self.keys[index] == key:
                self.values[index] = value
                return False
            
            if first_deleted is None and self.keys[index] == self.DELETED:
                first_deleted = index
            
            index = self._rehash(index)
            if index == start_index:
                break
        
        if first_deleted is not None:
            index = first_deleted
        
        self.keys[index] = key
        self.values[index] = value
        self.count += 1
        return True
    
    def search(self, key):
        index = self._hash(key)
        start_index = index
        
        while self.keys[index] != self.EMPTY:
            if self.keys[index] == key:
                return self.values[index]
            
            index = self._rehash(index)
            if index == start_index:
                break
        
        return None
    
    def delete(self, key):
        index = self._hash(key)
        start_index = index
        
        while self.keys[index] != self.EMPTY:
            if self.keys[index] == key:
                self.keys[index] = self.DELETED
                self.values[index] = self.DELETED
                self.count -= 1
                return True
            
            index = self._rehash(index)
            if index == start_index:
                break
        
        return False
    
    def contains(self, key):
        return self.search(key) is not None
    
    def __getitem__(self, key):
        result = self.search(key)
        if result is None:
            raise KeyError(f"Key '{key}' not found")
        return result
    
    def __setitem__(self, key, value):
        self.insert(key, value)
    
    def __delitem__(self, key):
        if not self.delete(key):
            raise KeyError(f"Key '{key}' not found")
    
    def __contains__(self, key):
        return self.contains(key)
    
    def __len__(self):
        return self.count
    
    def is_empty(self):
        return self.count == 0
    
    def clear(self):
        self.size = 8
        self.count = 0
        self.keys = [self.EMPTY] * self.size
        self.values = [self.EMPTY] * self.size
    
    def keys_list(self):
        return [key for key in self.keys if key not in (self.EMPTY, self.DELETED)]
    
    def values_list(self):
        return [value for value in self.values if value not in (self.EMPTY, self.DELETED)]
    
    def items(self):
        return [(key, value) for key, value in zip(self.keys, self.values) 
                if key not in (self.EMPTY, self.DELETED)]
    
    def __str__(self):
        items = []
        for key, value in self.items():
            items.append(f"{key}: {value}")
        return "{" + ", ".join(items) + "}"


def find_intersection(table1, table2):
    intersection = []
    
    keys1 = table1.keys_list()
    
    for key in keys1:
        if key in table2:
            intersection.append(key)
    
    return intersection


def find_intersection_with_values(table1, table2):
    intersection = {}
    
    keys1 = table1.keys_list()
    
    for key in keys1:
        if key in table2:
            intersection[key] = {
                'table1_value': table1.search(key),
                'table2_value': table2.search(key)
            }
    
    return intersection

table1 = HashTable()
table1.insert("apple", 10)
table1.insert("banana", 5)
table1.insert("orange", 8)
table1.insert("grape", 3)

table2 = HashTable()
table2.insert("banana", 7)
table2.insert("grape", 4)
table2.insert("kiwi", 6)
table2.insert("pear", 2)
    
    
intersection_keys = find_intersection(table1, table2)
print(intersection_keys)
    
intersection_values = find_intersection_with_values(table1, table2)
print("Пересечение с значениями:", intersection_values)



```

    ['grape', 'banana']
    Пересечение с значениями: {'grape': {'table1_value': 3, 'table2_value': 4}, 'banana': {'table1_value': 5, 'table2_value': 7}}



```python
def check_uniqueness(table):
  
    seen_keys = set()
    duplicates = []
    
    keys = table.keys_list()
    
    for key in keys:
        if key in seen_keys:
            duplicates.append(key)
        else:
            seen_keys.add(key)
    
    is_unique = len(duplicates) == 0
    return is_unique, duplicates




table1 = HashTable()
table1.insert("apple", 10)
table1.insert("banana", 5)
table1.insert("orange", 8)
table1.insert("grape", 3)
    
print("Таблица 1:", table1)
    
is_unique1, duplicates1 = check_uniqueness(table1)
print(f"Уникальность ключей: {is_unique1}")
if not is_unique1:
    print(f"Дубликаты ключей: {duplicates1}")
    

```

    Таблица 1: {grape: 3, banana: 5, orange: 8, apple: 10}
    Уникальность ключей: True



```python
class HashTable:
    DELETED = object()
    EMPTY = None
    
    def __init__(self, initial_size=8, load_factor=0.75):
        self.size = initial_size
        self.load_factor = load_factor
        self.count = 0
        self.keys = [self.EMPTY] * self.size
        self.values = [self.EMPTY] * self.size
    
    def _hash(self, key):
        return hash(key) % self.size
    
    def _rehash(self, hash_value, step=1):
        return (hash_value + step) % self.size
    
    def _resize(self, new_size):
        old_keys = self.keys
        old_values = self.values
        old_size = self.size
        
        self.size = new_size
        self.count = 0
        self.keys = [self.EMPTY] * self.size
        self.values = [self.EMPTY] * self.size
        
        for i in range(old_size):
            if old_keys[i] not in (self.EMPTY, self.DELETED):
                self.insert(old_keys[i], old_values[i])
    
    def _should_resize(self):
        return self.count >= self.size * self.load_factor
    
    def insert(self, key, value):
        if self._should_resize():
            self._resize(self.size * 2)
        
        index = self._hash(key)
        start_index = index
        first_deleted = None
        
        while self.keys[index] not in (self.EMPTY, self.DELETED):
            if self.keys[index] == key:
                self.values[index] = value
                return False
            
            if first_deleted is None and self.keys[index] == self.DELETED:
                first_deleted = index
            
            index = self._rehash(index)
            if index == start_index:
                break
        
        if first_deleted is not None:
            index = first_deleted
        
        self.keys[index] = key
        self.values[index] = value
        self.count += 1
        return True
    
    def search(self, key):
        index = self._hash(key)
        start_index = index
        
        while self.keys[index] != self.EMPTY:
            if self.keys[index] == key:
                return self.values[index]
            
            index = self._rehash(index)
            if index == start_index:
                break
        
        return None
    
    def contains(self, key):
        return self.search(key) is not None
    
    def get(self, key, default=None):
        result = self.search(key)
        return result if result is not None else default
    
    def increment(self, key, amount=1):
        current = self.search(key)
        if current is None:
            self.insert(key, amount)
        else:
            self.insert(key, current + amount)
    
    def keys_list(self):
        return [key for key in self.keys if key not in (self.EMPTY, self.DELETED)]
    
    def items(self):
        return [(key, value) for key, value in zip(self.keys, self.values) 
                if key not in (self.EMPTY, self.DELETED)]
    
    def __contains__(self, key):
        return self.contains(key)
    
    def __len__(self):
        return self.count


def is_anagram(str1, str2):

    if len(str1) != len(str2):
        return False
    
    char_count1 = HashTable()
    char_count2 = HashTable()
    
    for char in str1:
        char_count1.increment(char)
    
    for char in str2:
        char_count2.increment(char)
    
    for char in char_count1.keys_list():
        if char_count1.search(char) != char_count2.search(char):
            return False
    
    return True


test1_1, test1_2 = "listen", "silent"
print(f"'{test1_1}' и '{test1_2}': {is_anagram(test1_1, test1_2)}")

test2_1, test2_2 = "hello", "hell"
print(f"'{test2_1}' и '{test2_2}': {is_anagram(test2_1, test2_2)}")


```

    'listen' и 'silent': True
    'hello' и 'hell': False



```python
class Block:
    def __init__(self,data,prev_hash = '0'):
        self.data = data
        self.prev_hash=prev_hash
        self.hash=self._hash()
    def _hash(self):
        o = str(self.data)
        b = str(self.prev_hash)
        return [ord(char) for char in o+b]
class Blockchain:
    def __init__(self):
        self.chain = [Block("Genesis Block")]

    def add_block(self, data):
        previous_hash = self.chain[-1].hash
        new_block = Block(data, previous_hash)
        self.chain.append(new_block)    
blockchain = Blockchain()
blockchain.add_block("123")
blockchain.add_block("456")
for block in blockchain.chain:
    print(block.data, ''.join(str(num) for num in block.hash))
```

    Genesis Block 7110111010111510511532661081119910748
    123 4950519155494432494849443249494844324948494432494953443249485344324949534432515044325454443249485644324949494432575744324948554432525693
    456 5253549152574432534844325349443257494432535344325257443252524432515044325257443252564432525744325252443251504432525744325257443252564432525244325150443252574432525644325257443252524432515044325257443252574432535144325252443251504432525744325256443253514432525244325150443252574432525744325351443252524432515044325349443253484432525244325150443253524432535244325252443251504432525744325256443253544432525244325150443252574432525744325257443252524432515044325355443253554432525244325150443252574432525644325353443252524432515044325350443253544432575193



```python

```
