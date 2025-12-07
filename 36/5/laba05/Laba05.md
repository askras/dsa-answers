Гнедовец Алексей Александрович

ИУ10-36


```python
import hashlib
class HashTableChaining:
    def __init__(self, size=10):
        self.size = size
        self.table = [[] for _ in range(size)]
    
    def _hash(self, key):
        return hash(key) % self.size
    
    def insert(self, key, value):
        index = self._hash(key)
        for i, (k, v) in enumerate(self.table[index]):
            if k == key:
                self.table[index][i] = (key, value)
                return
        self.table[index].append((key, value))
    
    def get(self, key):
        index = self._hash(key)
        for k, v in self.table[index]:
            if k == key:
                return v
        return None
    
    def delete(self, key):
        index = self._hash(key)
        for i, (k, v) in enumerate(self.table[index]):
            if k == key:
                del self.table[index][i]
                return True
        return False
    
    def contains(self, key):
        return self.get(key) is not None
```


```python
class HashTableOpenAddressing:
    def __init__(self, size=10):
        self.size = size
        self.table = [None] * size
        self.DELETED = object()
    
    def _hash(self, key, i=0):
        return (hash(key) + i) % self.size
    
    def insert(self, key, value):
        for i in range(self.size):
            index = self._hash(key, i)
            if self.table[index] is None or self.table[index] is self.DELETED:
                self.table[index] = (key, value)
                return True
            elif self.table[index][0] == key:
                self.table[index] = (key, value)
                return True
        return False
    
    def get(self, key):
        for i in range(self.size):
            index = self._hash(key, i)
            if self.table[index] is None:
                return None
            elif self.table[index] is not self.DELETED and self.table[index][0] == key:
                return self.table[index][1]
        return None
    
    def delete(self, key):
        for i in range(self.size):
            index = self._hash(key, i)
            if self.table[index] is None:
                return False
            elif self.table[index] is not self.DELETED and self.table[index][0] == key:
                self.table[index] = self.DELETED
                return True
        return False
    
    def contains(self, key):
        return self.get(key) is not None
```


```python
class Block: 
    def __init__(self, data, previous_hash=""):
        self.data = data
        self.previous_hash = previous_hash
        self.hash = self.calculate_hash()
    
    def calculate_hash(self):
        import hashlib
        data_string = str(self.data) + self.previous_hash
        return hashlib.sha256(data_string.encode()).hexdigest()


class Blockchain:
    def __init__(self):
        self.chain = [self.create_genesis_block()]
    
    def create_genesis_block(self):
        return Block("Genesis Block", "0")
    
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
    
    def get_chain_info(self):
        info = []
        for i, block in enumerate(self.chain):
            info.append(f"Block {i}: Data={block.data}, Hash={block.hash[:10]}..., PrevHash={block.previous_hash[:10]}...")
        return info

def has_intersection(arr1, arr2):
    if not arr1 or not arr2:
        return False
    set1 = set(arr1)
    for element in arr2:
        if element in set1:
            return True
    return False


def has_unique_elements(arr):
    return len(arr) == len(set(arr))


def find_pairs_with_sum(arr, target_sum):
    pairs = []
    seen = set()
    
    for num in arr:
        complement = target_sum - num
        if complement in seen:
            pairs.append((complement, num))
        seen.add(num)
    
    return pairs


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
```


```python
if __name__ == "__main__":
    print("=== Демонстрация работы всех реализаций ===\n")
    print("1. Хеш-таблица с цепочками:")
    ht_chain = HashTableChaining()
    ht_chain.insert("apple", 5)
    ht_chain.insert("banana", 10)
    ht_chain.insert("orange", 15)
    print(f"   apple: {ht_chain.get('apple')}")
    print(f"   banana: {ht_chain.get('banana')}")
    print(f"   Содержит 'orange': {ht_chain.contains('orange')}")
    ht_chain.delete("banana")
    print(f"   Содержит 'banana' после удаления: {ht_chain.contains('banana')}")

    print("\n2. Хеш-таблица с открытой адресацией:")
    ht_open = HashTableOpenAddressing()
    ht_open.insert("cat", 20)
    ht_open.insert("dog", 25)
    ht_open.insert("bird", 30)
    print(f"   cat: {ht_open.get('cat')}")
    print(f"   dog: {ht_open.get('dog')}")
    ht_open.delete("dog")
    print(f"   Содержит 'dog' после удаления: {ht_open.contains('dog')}")

    print("\n3. Блокчейн:")
    blockchain = Blockchain()
    blockchain.add_block("Transaction 1")
    blockchain.add_block("Transaction 2")
    blockchain.add_block("Transaction 3")
    
    print("   Информация о цепочке:")
    for info in blockchain.get_chain_info():
        print(f"   {info}")
    print(f"   Блокчейн валиден: {blockchain.is_valid()}")
    
    print("\n4. Проверка пересечения массивов:")
    arr1 = [1, 2, 3, 4, 5]
    arr2 = [5, 6, 7, 8, 9]
    arr3 = [10, 11, 12]
    print(f"   {arr1} и {arr2} пересекаются: {has_intersection(arr1, arr2)}")
    print(f"   {arr1} и {arr3} пересекаются: {has_intersection(arr1, arr3)}")
    
    print("\n5. Проверка уникальности элементов:")
    unique_arr = [1, 2, 3, 4, 5]
    non_unique_arr = [1, 2, 3, 2, 1]
    print(f"   {unique_arr} все элементы уникальны: {has_unique_elements(unique_arr)}")
    print(f"   {non_unique_arr} все элементы уникальны: {has_unique_elements(non_unique_arr)}")
    
    print("\n6. Пары с заданной суммой:")
    numbers = [2, 7, 11, 15, 3, 6, 8]
    target = 9
    pairs = find_pairs_with_sum(numbers, target)
    print(f"   Массив: {numbers}, целевая сумма: {target}")
    print(f"   Найденные пары: {pairs}")
    
    print("\n7. Проверка анаграмм:")
    str1 = "listen"
    str2 = "silent"
    str3 = "hello"
    str4 = "world"
    print(f"   '{str1}' и '{str2}' являются анаграммами: {are_anagrams(str1, str2)}")
    print(f"   '{str3}' и '{str4}' являются анаграммами: {are_anagrams(str3, str4)}")
```

    === Демонстрация работы всех реализаций ===
    
    1. Хеш-таблица с цепочками:
       apple: 5
       banana: 10
       Содержит 'orange': True
       Содержит 'banana' после удаления: False
    
    2. Хеш-таблица с открытой адресацией:
       cat: 20
       dog: 25
       Содержит 'dog' после удаления: False
    
    3. Блокчейн:
       Информация о цепочке:
       Block 0: Data=Genesis Block, Hash=8500b59bb5..., PrevHash=0...
       Block 1: Data=Transaction 1, Hash=702b310f92..., PrevHash=8500b59bb5...
       Block 2: Data=Transaction 2, Hash=ecf727cd7b..., PrevHash=702b310f92...
       Block 3: Data=Transaction 3, Hash=d7afdc4cd2..., PrevHash=ecf727cd7b...
       Блокчейн валиден: True
    
    4. Проверка пересечения массивов:
       [1, 2, 3, 4, 5] и [5, 6, 7, 8, 9] пересекаются: True
       [1, 2, 3, 4, 5] и [10, 11, 12] пересекаются: False
    
    5. Проверка уникальности элементов:
       [1, 2, 3, 4, 5] все элементы уникальны: True
       [1, 2, 3, 2, 1] все элементы уникальны: False
    
    6. Пары с заданной суммой:
       Массив: [2, 7, 11, 15, 3, 6, 8], целевая сумма: 9
       Найденные пары: [(2, 7), (3, 6)]
    
    7. Проверка анаграмм:
       'listen' и 'silent' являются анаграммами: True
       'hello' и 'world' являются анаграммами: False
    


```python

```
