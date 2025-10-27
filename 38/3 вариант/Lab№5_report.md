# Хеш-функции и хеш-таблицы
Баскаков Д. С.
ИУ10-38

## Цель работы:
Изучение хеш-функций и хеш-таблиц, а также основных операций над ними.


## Задания
1. Реализовать хеш-таблицу на основе метода цепочек.
2. Реализовать хеш-таблицу на основе открытой адресации.
3. Блокчейн (2 балла) В блокчейне хеш-функции используются для создания уникальных идентификаторов блоков и обеспечения целостности данных. Каждый блок содержит хеш предыдущего блока, что создает цепочку и делает систему устойчивой к изменениям.
4. Проверка пересечения двух массивов
Проверьте, пересекаются ли два массива (имеют ли они хотя бы один общий элемент).
5. Проверка уникальности элементов в массиве
Проверьте, содержатся ли в массиве только уникальные элементы.
6. Нахождение пар с заданной суммой
Дан массив чисел и целевое значение суммы. Необходимо найти все пары чисел, которые в сумме дают целевое значение.
7. Задача на проверку анаграмм
Даны две строки. Необходимо определить, являются ли они анаграммами (содержат одни и те же символы в одинаковом количестве).


```python
import hashlib

class HashTable1:
    def __init__(self, n=100):
        self.n = n
        self.data = [[] for i in range(n)]
    
    def get_hash(self, key):
        return hash(key) % self.n
    
    def add(self, key, val):
        idx = self.get_hash(key)
        lst = self.data[idx]
        
        found = False
        for i in range(len(lst)):
            if lst[i][0] == key:
                lst[i] = (key, val)
                found = True
                break
        if not found:
            lst.append((key, val))
    
    def find(self, key):
        idx = self.get_hash(key)
        lst = self.data[idx]
        for k, v in lst:
            if k == key:
                return v
        return None
    
    def remove(self, key):
        idx = self.get_hash(key)
        lst = self.data[idx]
        for i in range(len(lst)):
            if lst[i][0] == key:
                lst.pop(i)
                return True
        return False

class HashTable2:
    def __init__(self, n=100):
        self.n = n
        self.data = [None] * n
    
    def get_hash(self, key):
        return hash(key) % self.n
    
    def add(self, key, val):
        idx = self.get_hash(key)
        for i in range(self.n):
            new_idx = (idx + i) % self.n
            if self.data[new_idx] is None or self.data[new_idx][0] == key:
                self.data[new_idx] = (key, val)
                return True
        return False
    
    def find(self, key):
        idx = self.get_hash(key)
        for i in range(self.n):
            new_idx = (idx + i) % self.n            
            if self.data[new_idx] is None:
                return None            
            if self.data[new_idx] is not None and self.data[new_idx][0] == key:
                return self.data[new_idx][1]
        return None
    
    def remove(self, key):
        idx = self.get_hash(key)
        for i in range(self.n):
            new_idx = (idx + i) % self.n
            if self.data[new_idx] is None:
                return False            
            if self.data[new_idx][0] == key:
                self.data[new_idx] = None
                return True
        return False


class Block:
    def __init__(self, info, prev_hash=""):
        self.info = info
        self.prev_hash = prev_hash
        self.current_hash = self.make_hash()
    
    def make_hash(self):
        text = self.info + self.prev_hash
        return hashlib.sha256(text.encode()).hexdigest()

class SimpleBlockchain:
    def __init__(self):
        self.blocks = []
        self.make_first_block()
    
    def make_first_block(self):
        first = Block("Первый блок")
        self.blocks.append(first)
    
    def add_block(self, info):
        last_hash = self.blocks[-1].current_hash
        new_block = Block(info, last_hash)
        self.blocks.append(new_block)

    def check_chain(self):
        for i in range(1, len(self.blocks)):
            current = self.blocks[i]
            previous = self.blocks[i - 1]
            if current.current_hash != current.make_hash():
                return False
            if current.prev_hash != previous.current_hash:
                return False
        return True


def check_common(arr1, arr2):
    hash_table = HashTable1(len(arr1))    
    for i in arr1:
        hash_table.add(i, True)    
    for i in arr2:
        if hash_table.contains(item):
            return True
    return False

def check_unique(arr):
    hash_table = HashTable1(len(arr))
    for i in arr:
        if hash_table.contains(i):
            return False
        hash_table.add(i, True)
    return True

def find_sum_pairs(nums, target):
    result = []
    hash_table = HashTable1(len(nums))
    for i in nums:
        need = target - i
        if hash_table.contains(need):
            result.append((need, i))
        hash_table.add(i, True)
    return result

def is_anagram(s1, s2):
    if len(s1) != len(s2):
        return False
    char_count = HashTable1(50)
    for i in s1:
        current_count = char_count.find(i)
        if current_count is None:
            char_count.add(i, 1)
        else:
            char_count.add(i, current_count + 1)    
    for i in s2:
        current_count = char_count.find(i)
        if current_count is None or current_count == 0:
            return False
        char_count.add(i, current_count - 1)
    return True


```


    
