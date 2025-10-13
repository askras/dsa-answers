# Хэш-функции и хэш-таблицы

***

Старшинов Владислав Эдуардович

ИУ10-37

Вариант 6

## Задания 

***

### Хэш-таблица на основе метода цепочек


```python
class HashTable:
    """Хеш-таблица с методом цепочек, использующая dict для цепочек"""
    
    def __init__(self, capacity=10):
        self.capacity = capacity
        self.size = 0
        self.buckets = [dict() for _ in range(capacity)]
    
    def _hash(self, key):
        """Хеш-функция для вычисления индекса корзины"""
        return hash(key) % self.capacity
    
    def insert(self, key, value):
        """Вставка пары ключ-значение в хеш-таблицу"""
        index = self._hash(key)
        bucket = self.buckets[index]
        
        # Если ключа еще нет в корзине, увеличиваем размер
        if key not in bucket:
            self.size += 1
        
        # Вставляем или обновляем значение
        bucket[key] = value
        
        # Проверка необходимости рехеширования
        if self.load_factor() > 0.7:
            self._rehash()
    
    def get(self, key, default=None):
        """Получение значения по ключу"""
        index = self._hash(key)
        bucket = self.buckets[index]
        return bucket.get(key, default)
    
    def delete(self, key):
        """Удаление пары ключ-значение"""
        index = self._hash(key)
        bucket = self.buckets[index]
        
        if key in bucket:
            del bucket[key]
            self.size -= 1
            return True
        return False
    
    def contains(self, key):
        """Проверка наличия ключа в таблице"""
        index = self._hash(key)
        return key in self.buckets[index]
    
    def load_factor(self):
        """Вычисление коэффициента загрузки"""
        return self.size / self.capacity
    
    def _rehash(self):
        """Увеличение размера таблицы и перехеширование всех элементов"""
        old_buckets = self.buckets
        old_capacity = self.capacity
        
        self.capacity *= 2
        self.buckets = [dict() for _ in range(self.capacity)]
        self.size = 0
        
        # Перемещение всех элементов в новую таблицу
        for bucket in old_buckets:
            for key, value in bucket.items():
                self.insert(key, value)
    
    def keys(self):
        """Получение всех ключей таблицы"""
        all_keys = []
        for bucket in self.buckets:
            all_keys.extend(bucket.keys())
        return all_keys
    
    def values(self):
        """Получение всех значений таблицы"""
        all_values = []
        for bucket in self.buckets:
            all_values.extend(bucket.values())
        return all_values
    
    def items(self):
        """Получение всех пар ключ-значение таблицы"""
        all_items = []
        for bucket in self.buckets:
            all_items.extend(bucket.items())
        return all_items
    
    def clear(self):
        """Очистка всей таблицы"""
        self.buckets = [dict() for _ in range(self.capacity)]
        self.size = 0
    
    def update(self, other):
        """Обновление таблицы элементами из другой таблицы или словаря"""
        if isinstance(other, HashTable):
            for key, value in other.items():
                self.insert(key, value)
        elif isinstance(other, dict):
            for key, value in other.items():
                self.insert(key, value)
        else:
            for key, value in other:
                self.insert(key, value)
    
    def __len__(self):
        """Возвращает количество элементов в таблице"""
        return self.size
    
    def __contains__(self, key):
        """Поддержка оператора 'in'"""
        return self.contains(key)
    
    def __getitem__(self, key):
        """Поддержка оператора [] для получения значения"""
        value = self.get(key)
        if value is None:
            raise KeyError(f"Key '{key}' not found")
        return value
    
    def __setitem__(self, key, value):
        """Поддержка оператора [] для установки значения"""
        self.insert(key, value)
    
    def __delitem__(self, key):
        """Поддержка оператора del"""
        if not self.delete(key):
            raise KeyError(f"Key '{key}' not found")
    
    def __iter__(self):
        """Итератор по ключам таблицы"""
        return iter(self.keys())
    
    def __str__(self):
        """Строковое представление таблицы"""
        items = []
        for bucket in self.buckets:
            for key, value in bucket.items():
                items.append(f"{key}: {value}")
        return "{" + ", ".join(items) + "}"
    
    def __repr__(self):
        """Представление таблицы для отладки"""
        return f"HashTable(capacity={self.capacity}, size={self.size})"
    
    def bucket_stats(self):
        """Статистика по корзинам для анализа распределения"""
        stats = {
            'capacity': self.capacity,
            'size': self.size,
            'load_factor': self.load_factor(),
            'buckets_used': sum(1 for bucket in self.buckets if bucket),
            'empty_buckets': sum(1 for bucket in self.buckets if not bucket),
            'max_chain_length': max(len(bucket) for bucket in self.buckets),
            'min_chain_length': min(len(bucket) for bucket in self.buckets if bucket) if self.size > 0 else 0,
            'avg_chain_length': self.size / sum(1 for bucket in self.buckets if bucket) if self.size > 0 else 0
        }
        return stats
```

### Хэш-таблица на основе открытой адресации


```python
class HashTable:
    """Хеш-таблица с открытой адресацией"""
    
    def __init__(self, size=10):
        """
        Инициализация хеш-таблицы
        
        Args:
            size (int): начальный размер таблицы
        """
        self.size = size
        self.count = 0  # Количество элементов в таблице
        self.table = {}  # Используем dict для хранения данных
        self.DELETED = object()  # Маркер удаленного элемента
        
    def _hash(self, key):
        """Вычисление хеша для ключа"""
        return hash(key) % self.size
    
    def _probe(self, key, for_insert=False):
        """
        Поиск позиции для ключа с помощью линейного пробирования
        
        Args:
            key: ключ для поиска
            for_insert (bool): True если поиск для вставки
            
        Returns:
            tuple: (позиция, значение) или (позиция, None) если не найдено
        """
        index = self._hash(key)
        start_index = index
        
        while True:
            # Если ячейка пустая
            if index not in self.table:
                return index, None
            
            # Если нашли ключ и он не помечен как удаленный
            if self.table[index] is not self.DELETED and self.table[index][0] == key:
                return index, self.table[index][1]
            
            # Если ищем для вставки и нашли удаленную ячейку
            if for_insert and self.table[index] is self.DELETED:
                return index, None
                
            # Линейное пробирование
            index = (index + 1) % self.size
            
            # Если прошли весь круг
            if index == start_index:
                return None, None
    
    def _resize(self, new_size):
        """Изменение размера таблицы"""
        old_table = self.table
        self.table = {}
        self.size = new_size
        self.count = 0
        
        for index, value in old_table.items():
            if value is not self.DELETED:
                key, val = value
                self.put(key, val)
    
    def _check_resize(self):
        """Проверка необходимости изменения размера"""
        load_factor = self.count / self.size
        if load_factor > 0.7:  # Увеличиваем при коэффициенте загрузки > 70%
            self._resize(self.size * 2)
        elif load_factor < 0.2 and self.size > 10:  # Уменьшаем при коэффициенте < 20%
            self._resize(max(10, self.size // 2))
    
    def put(self, key, value):
        """
        Добавление или обновление элемента в таблице
        
        Args:
            key: ключ
            value: значение
        """
        index, existing_value = self._probe(key, for_insert=True)
        
        if index is None:
            self._resize(self.size * 2)
            self.put(key, value)
            return
        
        # Если ключ уже существует, обновляем значение
        if existing_value is not None:
            self.table[index] = (key, value)
        else:
            # Добавляем новый элемент
            self.table[index] = (key, value)
            self.count += 1
        
        self._check_resize()
    
    def get(self, key, default=None):
        """
        Получение значения по ключу
        
        Args:
            key: ключ
            default: значение по умолчанию, если ключ не найден
            
        Returns:
            значение или default
        """
        index, value = self._probe(key)
        
        if value is not None:
            return value
        return default
    
    def delete(self, key):
        """
        Удаление элемента по ключу
        
        Args:
            key: ключ для удаления
            
        Returns:
            bool: True если элемент был удален, False если не найден
        """
        index, value = self._probe(key)
        
        if value is not None:
            self.table[index] = self.DELETED
            self.count -= 1
            self._check_resize()
            return True
        
        return False
    
    def contains(self, key):
        """
        Проверка наличия ключа в таблице
        
        Args:
            key: ключ для проверки
            
        Returns:
            bool: True если ключ существует
        """
        _, value = self._probe(key)
        return value is not None
    
    def __getitem__(self, key):
        """Поддержка оператора [] для получения значения"""
        value = self.get(key)
        if value is None:
            raise KeyError(f"Key '{key}' not found")
        return value
    
    def __setitem__(self, key, value):
        """Поддержка оператора [] для установки значения"""
        self.put(key, value)
    
    def __delitem__(self, key):
        """Поддержка оператора del"""
        if not self.delete(key):
            raise KeyError(f"Key '{key}' not found")
    
    def __contains__(self, key):
        """Поддержка оператора in"""
        return self.contains(key)
    
    def __len__(self):
        """Возвращает количество элементов в таблице"""
        return self.count
    
    def keys(self):
        """Возвращает все ключи таблицы"""
        return [item[0] for item in self.table.values() if item is not self.DELETED]
    
    def values(self):
        """Возвращает все значения таблицы"""
        return [item[1] for item in self.table.values() if item is not self.DELETED]
    
    def items(self):
        """Возвращает все пары ключ-значение"""
        return [item for item in self.table.values() if item is not self.DELETED]
    
    def clear(self):
        """Очистка таблицы"""
        self.table.clear()
        self.count = 0
    
    def __str__(self):
        """Строковое представление таблицы"""
        items = []
        for item in self.table.values():
            if item is not self.DELETED:
                items.append(f"{item[0]}: {item[1]}")
        return "{" + ", ".join(items) + "}"
    
    def __repr__(self):
        return f"HashTable(size={self.size}, count={self.count})"
```

### Блокчейн


```python
import hashlib
import time
import json
from typing import Any, Dict, Optional

class Block:
    """Класс блока в блокчейне"""
    
    def __init__(self, index: int, timestamp: float, data: Dict[str, Any], previous_hash: str):
        """
        Инициализация блока
        
        Args:
            index (int): номер блока в цепочке
            timestamp (float): временная метка создания
            data (Dict): данные блока
            previous_hash (str): хеш предыдущего блока
        """
        self.index = index
        self.timestamp = timestamp
        self.data = data
        self.previous_hash = previous_hash
        self.hash = self.calculate_hash()
        self.nonce = 0  # Для доказательства работы
    
    def calculate_hash(self) -> str:
        """
        Вычисление хеша блока
        
        Returns:
            str: хеш блока в hex-формате
        """
        block_string = json.dumps({
            "index": self.index,
            "timestamp": self.timestamp,
            "data": self.data,
            "previous_hash": self.previous_hash,
            "nonce": self.nonce
        }, sort_keys=True)
        return hashlib.sha256(block_string.encode()).hexdigest()
    
    def mine_block(self, difficulty: int) -> None:
        """
        Майнинг блока (доказательство работы)
        
        Args:
            difficulty (int): сложность майнинга (количество ведущих нулей)
        """
        target = "0" * difficulty
        while self.hash[:difficulty] != target:
            self.nonce += 1
            self.hash = self.calculate_hash()
    
    def to_dict(self) -> Dict[str, Any]:
        """Преобразование блока в словарь"""
        return {
            "index": self.index,
            "timestamp": self.timestamp,
            "data": self.data,
            "previous_hash": self.previous_hash,
            "hash": self.hash,
            "nonce": self.nonce
        }
    
    def __repr__(self) -> str:
        return f"Block(index={self.index}, hash={self.hash[:16]}...)"


class Blockchain:
    """Класс блокчейна с использованием хеш-таблиц"""
    
    def __init__(self, difficulty: int = 2):
        """
        Инициализация блокчейна
        
        Args:
            difficulty (int): сложность майнинга
        """
        self.chain = []  # Список блоков
        self.difficulty = difficulty
        self.block_index_map = {}  # Хеш-таблица: индекс -> блок
        self.block_hash_map = {}   # Хеш-таблица: хеш -> блок
        self.data_map = {}         # Хеш-таблица: идентификатор данных -> блок
        
        # Создаем genesis block
        self.create_genesis_block()
    
    def create_genesis_block(self) -> None:
        """Создание начального блока"""
        genesis_block = Block(0, time.time(), {"message": "Genesis Block"}, "0")
        genesis_block.mine_block(self.difficulty)
        self.add_block_to_maps(genesis_block)
        self.chain.append(genesis_block)
    
    def add_block_to_maps(self, block: Block) -> None:
        """
        Добавление блока в хеш-таблицы
        
        Args:
            block (Block): блок для добавления
        """
        # Добавляем в таблицу по индексу
        self.block_index_map[block.index] = block
        
        # Добавляем в таблицу по хешу
        self.block_hash_map[block.hash] = block
        
        # Добавляем данные в таблицу
        if isinstance(block.data, dict) and "id" in block.data:
            self.data_map[block.data["id"]] = block
    
    def get_last_block(self) -> Block:
        """
        Получение последнего блока в цепочке
        
        Returns:
            Block: последний блок
        """
        return self.chain[-1]
    
    def add_block(self, data: Dict[str, Any]) -> Block:
        """
        Добавление нового блока в блокчейн
        
        Args:
            data (Dict): данные для добавления в блок
            
        Returns:
            Block: созданный блок
        """
        previous_block = self.get_last_block()
        new_block = Block(
            index=len(self.chain),
            timestamp=time.time(),
            data=data,
            previous_hash=previous_block.hash
        )
        
        # Майнинг блока
        new_block.mine_block(self.difficulty)
        
        # Проверка целостности перед добавлением
        if self.is_valid_new_block(new_block, previous_block):
            self.chain.append(new_block)
            self.add_block_to_maps(new_block)
            return new_block
        else:
            raise ValueError("Invalid block")
    
    def is_valid_new_block(self, new_block: Block, previous_block: Block) -> bool:
        """
        Проверка валидности нового блока
        
        Args:
            new_block (Block): новый блок
            previous_block (Block): предыдущий блок
            
        Returns:
            bool: True если блок валиден
        """
        # Проверка хеша предыдущего блока
        if new_block.previous_hash != previous_block.hash:
            return False
        
        # Проверка корректности хеша нового блока
        if new_block.hash != new_block.calculate_hash():
            return False
        
        # Проверка доказательства работы
        if new_block.hash[:self.difficulty] != "0" * self.difficulty:
            return False
        
        return True
    
    def is_chain_valid(self) -> bool:
        """
        Проверка целостности всей цепочки
        
        Returns:
            bool: True если цепочка валидна
        """
        for i in range(1, len(self.chain)):
            current_block = self.chain[i]
            previous_block = self.chain[i - 1]
            
            if not self.is_valid_new_block(current_block, previous_block):
                return False
        
        return True
    
    def get_block_by_index(self, index: int) -> Optional[Block]:
        """
        Быстрый поиск блока по индексу через хеш-таблицу
        
        Args:
            index (int): индекс блока
            
        Returns:
            Optional[Block]: найденный блок или None
        """
        return self.block_index_map.get(index)
    
    def get_block_by_hash(self, block_hash: str) -> Optional[Block]:
        """
        Быстрый поиск блока по хешу через хеш-таблицу
        
        Args:
            block_hash (str): хеш блока
            
        Returns:
            Optional[Block]: найденный блок или None
        """
        return self.block_hash_map.get(block_hash)
    
    def get_block_by_data_id(self, data_id: str) -> Optional[Block]:
        """
        Быстрый поиск блока по идентификатору данных
        
        Args:
            data_id (str): идентификатор данных
            
        Returns:
            Optional[Block]: найденный блок или None
        """
        return self.data_map.get(data_id)
    
    def verify_data_integrity(self, data_id: str, expected_data: Dict[str, Any]) -> bool:
        """
        Проверка целостности данных
        
        Args:
            data_id (str): идентификатор данных
            expected_data (Dict): ожидаемые данные
            
        Returns:
            bool: True если данные не изменялись
        """
        block = self.get_block_by_data_id(data_id)
        if not block:
            return False
        
        # Проверяем, что данные в блоке соответствуют ожидаемым
        return block.data == expected_data
    
    def get_chain_info(self) -> Dict[str, Any]:
        """
        Получение информации о блокчейне
        
        Returns:
            Dict: информация о блокчейне
        """
        return {
            "length": len(self.chain),
            "difficulty": self.difficulty,
            "last_block_hash": self.get_last_block().hash,
            "is_valid": self.is_chain_valid(),
            "total_blocks_in_maps": len(self.block_hash_map)
        }
    
    def print_chain(self) -> None:
        """Вывод всей цепочки блоков"""
        for block in self.chain:
            print(f"Block #{block.index}")
            print(f"Hash: {block.hash}")
            print(f"Previous Hash: {block.previous_hash}")
            print(f"Data: {block.data}")
            print(f"Nonce: {block.nonce}")
            print("-" * 50)


class BlockchainNetwork:
    """Класс для управления сетью блокчейнов"""
    
    def __init__(self):
        """Инициализация сети"""
        self.blockchains = {}  # Хеш-таблица: имя -> блокчейн
    
    def create_blockchain(self, name: str, difficulty: int = 2) -> Blockchain:
        """
        Создание нового блокчейна
        
        Args:
            name (str): имя блокчейна
            difficulty (int): сложность майнинга
            
        Returns:
            Blockchain: созданный блокчейн
        """
        blockchain = Blockchain(difficulty)
        self.blockchains[name] = blockchain
        return blockchain
    
    def get_blockchain(self, name: str) -> Optional[Blockchain]:
        """
        Получение блокчейна по имени
        
        Args:
            name (str): имя блокчейна
            
        Returns:
            Optional[Blockchain]: найденный блокчейн
        """
        return self.blockchains.get(name)
    
    def add_transaction(self, blockchain_name: str, transaction: Dict[str, Any]) -> Optional[Block]:
        """
        Добавление транзакции в блокчейн
        
        Args:
            blockchain_name (str): имя блокчейна
            transaction (Dict): данные транзакции
            
        Returns:
            Optional[Block]: созданный блок
        """
        blockchain = self.get_blockchain(blockchain_name)
        if blockchain:
            return blockchain.add_block(transaction)
        return None
    
    def get_network_info(self) -> Dict[str, Any]:
        """
        Получение информации о сети
        
        Returns:
            Dict: информация о сети
        """
        return {
            "total_blockchains": len(self.blockchains),
            "blockchains": {name: bc.get_chain_info() for name, bc in self.blockchains.items()}
        }
```

### Проверка двух массивов на пересечение


```python
def have_intersection(arr1, arr2):
    """
    Проверяет, пересекаются ли два массива (имеют ли они хотя бы один общий элемент)
    
    Args:
        arr1: первый массив
        arr2: второй массив
        
    Returns:
        bool: True если массивы пересекаются, иначе False
        
    Временная сложность: O(n + m) где n и m - длины массивов
    """
    # Создаем словарь для элементов первого массива
    elements_dict = {}
    
    # Добавляем все элементы первого массива в словарь
    # Временная сложность: O(n)
    for element in arr1:
        elements_dict[element] = True
    
    # Проверяем элементы второго массива на наличие в словаре
    # Временная сложность: O(m)
    for element in arr2:
        if element in elements_dict:
            return True
    
    return False


def find_intersection_elements(arr1, arr2):
    """
    Находит все общие элементы двух массивов
    
    Args:
        arr1: первый массив
        arr2: второй массив
        
    Returns:
        list: список общих элементов
        
    Временная сложность: O(n + m)
    """
    elements_dict = {}
    intersection = []
    
    # Добавляем элементы первого массива в словарь
    # Временная сложность: O(n)
    for element in arr1:
        elements_dict[element] = True
    
    # Проверяем элементы второго массива и собираем пересечения
    # Временная сложность: O(m)
    for element in arr2:
        if element in elements_dict:
            intersection.append(element)
            # Удаляем из словаря, чтобы избежать дубликатов
            # если во втором массиве есть повторяющиеся элементы
            del elements_dict[element]
    
    return intersection


def have_intersection_with_counts(arr1, arr2):
    """
    Проверяет пересечение с учетом количества элементов
    
    Args:
        arr1: первый массив
        arr2: второй массив
        
    Returns:
        bool: True если есть хотя бы один общий элемент
        
    Временная сложность: O(n + m)
    """
    from collections import defaultdict
    
    # Создаем словарь для подсчета элементов
    count_dict = defaultdict(int)
    
    # Считаем элементы первого массива
    # Временная сложность: O(n)
    for element in arr1:
        count_dict[element] += 1
    
    # Проверяем элементы второго массива
    # Временная сложность: O(m)
    for element in arr2:
        if count_dict[element] > 0:
            return True
    
    return False

# Альтернативная реализация с использованием set (тоже O(n))
def have_intersection_with_set(arr1, arr2):
    """
    Альтернативная реализация с использованием set
    
    Args:
        arr1: первый массив
        arr2: второй массив
        
    Returns:
        bool: True если массивы пересекаются
        
    Временная сложность: O(n + m)
    """
    set1 = set(arr1)  # O(n)
    set2 = set(arr2)  # O(m)
    
    # Проверка пересечения множеств - O(min(n, m)) в среднем случае
    return len(set1 & set2) > 0
```

### Проверка уникальности элементов в массиве


```python
def all_unique(arr):
    """
    Проверяет, содержатся ли в массиве только уникальные элементы
    
    Args:
        arr: массив для проверки
        
    Returns:
        bool: True если все элементы уникальны, иначе False
        
    Временная сложность: O(n)
    """
    if not arr:
        return True
    
    seen = {}
    
    for element in arr:
        # Если элемент уже встречался, возвращаем False
        if element in seen:
            return False
        # Добавляем элемент в словарь
        seen[element] = True
    
    return True


def all_unique_with_count(arr):
    """
    Проверяет уникальность с подсчетом количества повторений
    
    Args:
        arr: массив для проверки
        
    Returns:
        tuple: (bool, dict) - результат проверки и словарь с количеством повторений
        
    Временная сложность: O(n)
    """
    if not arr:
        return True, {}
    
    count_dict = {}
    
    for element in arr:
        count_dict[element] = count_dict.get(element, 0) + 1
    
    # Проверяем, есть ли элементы с количеством > 1
    has_duplicates = any(count > 1 for count in count_dict.values())
    
    return not has_duplicates, count_dict


def find_duplicates(arr):
    """
    Находит все дубликаты в массиве
    
    Args:
        arr: массив для проверки
        
    Returns:
        list: список дублирующихся элементов
        
    Временная сложность: O(n)
    """
    if not arr:
        return []
    
    count_dict = {}
    duplicates = []
    
    for element in arr:
        count_dict[element] = count_dict.get(element, 0) + 1
        # Если элемент встретился второй раз, добавляем в дубликаты
        if count_dict[element] == 2:
            duplicates.append(element)
    
    return duplicates


def all_unique_using_set(arr):
    """
    Альтернативная реализация с использованием set
    
    Args:
        arr: массив для проверки
        
    Returns:
        bool: True если все элементы уникальны
        
    Временная сложность: O(n)
    """
    if not arr:
        return True
    
    # Сравниваем длину массива с длиной множества
    # Множество автоматически удаляет дубликаты
    return len(arr) == len(set(arr))


class UniqueChecker:
    """
    Класс для проверки уникальности с дополнительной функциональностью
    """
    
    def __init__(self):
        self.element_count = {}
    
    def check_array(self, arr):
        """
        Проверяет массив на уникальность
        
        Args:
            arr: массив для проверки
            
        Returns:
            bool: True если все элементы уникальны
        """
        self.element_count.clear()
        
        for element in arr:
            if element in self.element_count:
                return False
            self.element_count[element] = 1
        
        return True
    
    def get_duplicate_info(self, arr):
        """
        Возвращает подробную информацию о дубликатах
        
        Args:
            arr: массив для проверки
            
        Returns:
            dict: информация о дубликатах
        """
        self.element_count.clear()
        
        for element in arr:
            self.element_count[element] = self.element_count.get(element, 0) + 1
        
        duplicates = {element: count for element, count in self.element_count.items() if count > 1}
        is_unique = len(duplicates) == 0
        
        return {
            'is_unique': is_unique,
            'total_elements': len(arr),
            'unique_elements': len(self.element_count),
            'duplicates': duplicates
        }
```

### Равна ли сумма пары чисел целевой сумме


```python
def find_pairs_with_sum(arr, target_sum):
    """
    Находит все пары чисел, которые в сумме дают целевое значение
    
    Args:
        arr: массив чисел
        target_sum: целевая сумма
        
    Returns:
        list: список кортежей с парами чисел (в порядке их появления)
        
    Временная сложность: O(n)
    """
    if not arr or len(arr) < 2:
        return []
    
    pairs = []
    seen = {}
    
    for num in arr:
        complement = target_sum - num
        
        # Проверяем, видели ли мы complement и сколько раз
        if complement in seen and seen[complement] > 0:
            pairs.append((complement, num))
            seen[complement] -= 1
        else:
            # Добавляем текущее число в словарь
            seen[num] = seen.get(num, 0) + 1
    
    return pairs


def find_pairs_with_sum_all_combinations(arr, target_sum):
    """
    Находит все уникальные пары (без учета порядка) с заданной суммой
    
    Args:
        arr: массив чисел
        target_sum: целевая сумма
        
    Returns:
        list: список кортежей с уникальными парами чисел
        
    Временная сложность: O(n)
    """
    if not arr or len(arr) < 2:
        return []
    
    pairs = set()
    seen = set()
    
    for num in arr:
        complement = target_sum - num
        
        if complement in seen:
            # Добавляем пару в отсортированном виде для уникальности
            pair = tuple(sorted((complement, num)))
            pairs.add(pair)
        
        seen.add(num)
    
    return list(pairs)


def find_pairs_with_indices(arr, target_sum):
    """
    Находит пары чисел с индексами
    
    Args:
        arr: массив чисел
        target_sum: целевая сумма
        
    Returns:
        list: список кортежей (число1, индекс1, число2, индекс2)
        
    Временная сложность: O(n)
    """
    if not arr:
        return []
    
    pairs = []
    num_indices = {}
    
    for i, num in enumerate(arr):
        complement = target_sum - num
        
        if complement in num_indices:
            for comp_index in num_indices[complement]:
                pairs.append((complement, comp_index, num, i))
        
        # Добавляем текущее число и его индекс
        if num not in num_indices:
            num_indices[num] = []
        num_indices[num].append(i)
    
    return pairs


def find_pairs_count_only(arr, target_sum):
    """
    Подсчитывает количество пар с заданной суммой
    
    Args:
        arr: массив чисел
        target_sum: целевая сумма
        
    Returns:
        int: количество пар
        
    Временная сложность: O(n)
    """
    if not arr or len(arr) < 2:
        return 0
    
    count = 0
    num_count = {}
    
    for num in arr:
        complement = target_sum - num
        
        if complement in num_count:
            count += num_count[complement]
        
        num_count[num] = num_count.get(num, 0) + 1
    
    return count


class PairFinder:
    """
    Класс для поиска пар с дополнительной функциональностью
    """
    
    def __init__(self):
        self.history = []
    
    def find_pairs(self, arr, target_sum):
        """
        Основной метод поиска пар
        
        Args:
            arr: массив чисел
            target_sum: целевая сумма
            
        Returns:
            list: список пар
        """
        pairs = find_pairs_with_sum(arr, target_sum)
        self.history.append({
            'array': arr.copy(),
            'target_sum': target_sum,
            'pairs': pairs.copy(),
            'count': len(pairs)
        })
        return pairs
    
    def get_statistics(self):
        """
        Возвращает статистику по всем поискам
        
        Returns:
            dict: статистика
        """
        if not self.history:
            return {}
        
        total_pairs = sum(item['count'] for item in self.history)
        avg_pairs = total_pairs / len(self.history)
        most_common_target = max(
            [(item['target_sum'], item['count']) for item in self.history],
            key=lambda x: x[1]
        )
        
        return {
            'total_searches': len(self.history),
            'total_pairs_found': total_pairs,
            'average_pairs_per_search': avg_pairs,
            'most_common_target': most_common_target[0],
            'pairs_for_most_common': most_common_target[1]
        }
```

### Проверка, что две строки являются анаграммами


```python
def are_anagrams(str1, str2):
    """
    Проверяет, являются ли две строки анаграммами
    
    Args:
        str1: первая строка
        str2: вторая строка
        
    Returns:
        bool: True если строки являются анаграммами, иначе False
        
    Временная сложность: O(n + m) где n и m - длины строк
    """
    # Если длины строк разные, они не могут быть анаграммами
    if len(str1) != len(str2):
        return False
    
    # Создаем словарь для подсчета символов
    char_count = {}
    
    # Подсчитываем символы первой строки
    # Временная сложность: O(n)
    for char in str1:
        char_count[char] = char_count.get(char, 0) + 1
    
    # Проверяем символы второй строки
    # Временная сложность: O(m)
    for char in str2:
        # Если символа нет в словаре или его счетчик равен 0
        if char not in char_count or char_count[char] == 0:
            return False
        # Уменьшаем счетчик символа
        char_count[char] -= 1
    
    # Проверяем, что все счетчики равны 0
    # Временная сложность: O(k) где k - количество уникальных символов
    return all(count == 0 for count in char_count.values())


def are_anagrams_sorted(str1, str2):
    """
    Альтернативная реализация с использованием сортировки (не O(n))
    
    Args:
        str1: первая строка
        str2: вторая строка
        
    Returns:
        bool: True если строки являются анаграммами
        
    Временная сложность: O(n log n) - не удовлетворяет требованию O(n)
    """
    return sorted(str1) == sorted(str2)


def find_anagram_difference(str1, str2):
    """
    Находит разницу между строками для анаграмм
    
    Args:
        str1: первая строка
        str2: вторая строка
        
    Returns:
        dict: информация о различиях
        
    Временная сложность: O(n + m)
    """
    char_count = {}
    
    # Подсчитываем символы первой строки (положительные значения)
    for char in str1:
        char_count[char] = char_count.get(char, 0) + 1
    
    # Подсчитываем символы второй строки (отрицательные значения)
    for char in str2:
        char_count[char] = char_count.get(char, 0) - 1
    
    # Фильтруем ненулевые значения
    differences = {char: count for char, count in char_count.items() if count != 0}
    
    return {
        'are_anagrams': len(differences) == 0,
        'differences': differences,
        'extra_in_str1': {char: count for char, count in differences.items() if count > 0},
        'extra_in_str2': {char: -count for char, count in differences.items() if count < 0}
    }


def group_anagrams(words):
    """
    Группирует слова по анаграммам
    
    Args:
        words: список слов
        
    Returns:
        dict: словарь где ключ - отсортированная версия слова, значение - список анаграмм
        
    Временная сложность: O(n * k log k) где n - количество слов, k - длина самого длинного слова
    """
    anagram_groups = {}
    
    for word in words:
        # Сортируем символы слова чтобы получить ключ
        sorted_word = ''.join(sorted(word))
        
        if sorted_word not in anagram_groups:
            anagram_groups[sorted_word] = []
        anagram_groups[sorted_word].append(word)
    
    return anagram_groups


def are_anagrams_case_insensitive(str1, str2):
    """
    Проверяет анаграммы без учета регистра
    
    Args:
        str1: первая строка
        str2: вторая строка
        
    Returns:
        bool: True если строки являются анаграммами (без учета регистра)
        
    Временная сложность: O(n + m)
    """
    return are_anagrams(str1.lower(), str2.lower())


class AnagramChecker:
    """
    Класс для проверки анаграмм с дополнительной функциональностью
    """
    
    def __init__(self):
        self.history = []
    
    def check(self, str1, str2):
        """
        Проверяет являются ли строки анаграммами
        
        Args:
            str1: первая строка
            str2: вторая строка
            
        Returns:
            bool: результат проверки
        """
        result = are_anagrams(str1, str2)
        
        self.history.append({
            'string1': str1,
            'string2': str2,
            'result': result,
            'length1': len(str1),
            'length2': len(str2)
        })
        
        return result
    
    def get_statistics(self):
        """
        Возвращает статистику по всем проверкам
        
        Returns:
            dict: статистика
        """
        if not self.history:
            return {}
        
        total_checks = len(self.history)
        anagram_count = sum(1 for item in self.history if item['result'])
        success_rate = anagram_count / total_checks
        
        return {
            'total_checks': total_checks,
            'anagram_count': anagram_count,
            'non_anagram_count': total_checks - anagram_count,
            'success_rate': success_rate,
            'average_length': sum(item['length1'] + item['length2'] for item in self.history) / (total_checks * 2)
        }
    
    def find_most_common_anagram_pair(self):
        """
        Находит самую частую пару анаграмм
        
        Returns:
            tuple: (str1, str2, count) или None если нет анаграмм
        """
        from collections import defaultdict
        
        pair_count = defaultdict(int)
        
        for item in self.history:
            if item['result']:
                # Сортируем строки для уникальности пары
                pair = tuple(sorted([item['string1'], item['string2']]))
                pair_count[pair] += 1
        
        if not pair_count:
            return None
        
        most_common = max(pair_count.items(), key=lambda x: x[1])
        return (*most_common[0], most_common[1])
```
