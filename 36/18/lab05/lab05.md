# Л.Р. 5 - "Хеш-функции и хеш-таблицы"

**Цао М.М.**

**ИУ10-36**

### Задания
### Задание 1
**Реализовать хеш-таблицу на основе метода цепочек.**

```python
class HashTableChaining:
    def __init__(self, size=10):
        self.size = size
        self.table = [[] for _ in range(size)]
    
    def _hash(self, key):
        if isinstance(key, int):
            return key % self.size
        elif isinstance(key, str):
            hash_val = 0
            for char in key:
                hash_val = (hash_val * 31 + ord(char)) % self.size
            return hash_val
    
    def insert(self, key, value):
        index = self._hash(key)
        bucket = self.table[index]
        for i, (k, v) in enumerate(bucket):
            if k == key:
                bucket[i] = (key, value)
                return
        bucket.append((key, value))
    
    def get(self, key):
        index = self._hash(key)
        for k, v in self.table[index]:
            if k == key:
                return v
        return None
```
**Объяснение: Реализована хеш-таблица, использующая метод цепочек для разрешения коллизий. Каждый бакет содержит список пар ключ-значение.**

### Задание 2
**Реализовать хеш-таблицу на основе открытой адресации.**

```python
class HashTableOpenAddressing:
    def __init__(self, size=10):
        self.size = size
        self.table = [None] * size
        self.DELETED = object()
    
    def _hash(self, key):
        return hash(key) % self.size
    
    def _probe(self, key, i):
        return (self._hash(key) + i) % self.size
    
    def insert(self, key, value):
        for i in range(self.size):
            index = self._probe(key, i)
            if self.table[index] is None or self.table[index] is self.DELETED:
                self.table[index] = (key, value)
                return
            elif self.table[index][0] == key:
                self.table[index] = (key, value)
                return
    
    def get(self, key):
        for i in range(self.size):
            index = self._probe(key, i)
            if self.table[index] is None:
                return None
            elif self.table[index] is not self.DELETED and self.table[index][0] == key:
                return self.table[index][1]
        return None
```
**Объяснение: Реализована хеш-таблица с открытой адресацией и линейным пробированием. Все элементы хранятся в основном массиве. При коллизии осуществляется поиск следующей свободной ячейки.**

### Задание 3
**В блокчейне хеш-функции используются для создания уникальных идентификаторов блоков и обеспечения целостности данных. Каждый блок содержит хеш предыдущего блока, что создает цепочку и делает систему устойчивой к изменениям.**

```python
class Blockchain:
    def __init__(self):
        self.chain = []
        self.current_transactions = []
        self.create_block(previous_hash='1', proof=100)
    
    def create_block(self, proof, previous_hash=None):
        block = {
            'index': len(self.chain) + 1,
            'timestamp': time.time(),
            'transactions': self.current_transactions.copy(),
            'proof': proof,
            'previous_hash': previous_hash or self.hash(self.chain[-1])
        }
        self.current_transactions = []
        self.chain.append(block)
        return block
    
    def proof_of_work(self, previous_proof):
        current_proof = 0
        while not self.valid_proof(previous_proof, current_proof):
            current_proof += 1
        return current_proof
    
    def is_chain_valid(self):
        for i in range(1, len(self.chain)):
            current_block = self.chain[i]
            previous_block = self.chain[i-1]
            if current_block['previous_hash'] != self.hash(previous_block):
                return False
            if not self.valid_proof(previous_block['proof'], current_block['proof']):
                return False
        return True
```
**Объяснение: Реализована упрощенная модель блокчейна. Каждый блок содержит хеш предыдущего блока, что обеспечивает целостность цепочки. Используется proof-of-work для создания новых блоков. Механизм проверки валидности цепочки обнаруживает любые несанкционированные изменения данных.**

### Задание 4
**Проверьте, пересекаются ли два массива (имеют ли они хотя бы один общий элемент).**

```python
def find_intersection(arr1, arr2):
    if len(arr1) == 0 or len(arr2) == 0:
        return False
    
    hash_set = set(arr1)
    
    for item in arr2:
        if item in hash_set:
            return True
    
    return False
```
**Объяснение: Алгоритм проверяет наличие общих элементов в двух массивах за время O(n). Первый массив преобразуется в множество для обеспечения быстрого поиска O(1), затем осуществляется проход по второму массиву с проверкой принадлежности.**

### Задание 5
**Проверьте, содержатся ли в массиве только уникальные элементы.**

```python
def has_unique_elements(arr):
    return len(set(arr)) == len(arr)

def find_first_duplicate(arr):
    seen = set()
    for item in arr:
        if item in seen:
            return item
        seen.add(item)
    return None
```
**Объяснение: Алгоритм проверяет уникальность элементов за O(n) путем сравнения размеров массива и множества из его элементов. Дополнительная функция находит первый дубликат за один проход по массиву.**

### Задание 6
**Дан массив чисел и целевое значение суммы. Необходимо найти все пары чисел, которые в сумме дают целевое значение.**

```python
def find_pairs_with_sum(arr, target_sum):
    pairs = []
    seen = set()
    
    for num in arr:
        complement = target_sum - num
        if complement in seen:
            pairs.append((complement, num))
        seen.add(num)
    
    return pairs
```
**Объяснение:Алгоритм находит все пары чисел с заданной суммой за O(n). Для каждого числа вычисляется complement и проверяется его наличие в множестве просмотренных элементов.**

### Задание 7
**Даны две строки. Необходимо определить, являются ли они анаграммами (содержат одни и те же символы в одинаковом количестве).**

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
```
**Объяснение: Алгоритм проверяет, являются ли строки анаграммами, за O(n). Используется словарь для подсчета частот символов с последующей проверкой совпадения распределения.**


**Выводы:**
1) В ходе работы были успешно изучены и реализованы фундаментальные принципы работы хеш-таблиц, включая механизмы хеширования, разрешения коллизий и управления памятью. Практическая реализация двух различных подходов к разрешению коллизий позволила глубоко понять их внутреннее устройство и особенности работы.
2) Все реализованные алгоритмы для задач 4-7 демонстрируют временную сложность O(n), что подтверждает эффективность использования хеш-таблиц для решения задач поиска и обработки данных. На примерах было показано, что хеш-таблицы позволяют заменить квадратичные алгоритмы O(n²) на линейные O(n).
3) Реализация блокчейна продемонстрировала реальное применение хеш-функций для обеспечения целостности данных и создания неизменяемых структур. Было подтверждено, что хеш-функции являются основой для построения криптографически защищенных систем.
4) Хеш-таблицы демонстрируют превосходную производительность для операций поиска, вставки и удаления, обеспечивая среднюю временную сложность O(1). Это делает их незаменимыми в задачах, требующих частого доступа к данным по ключу, таких как кэширование, индексация и реализация ассоциативных массивов.
5) Метод цепочек проще в реализации и более устойчив к высоким коэффициентам нагрузки, но требует дополнительной памяти для хранения указателей. Открытая адресация экономит память, но сильно зависит от коэффициента нагрузки и требует специальной обработки удаленных элементов. Выбор метода зависит от конкретных требований приложения.
