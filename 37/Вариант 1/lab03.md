# Линейные списки

### Голубков Александр

### ИУ10-37

### Вариант 1

### Линейный односвязный список. Версия 1.


```python
from typing import Any
import doctest

class Node:
    def __init__(self, data: Any = None, next_node=None):
        self.data = data
        self.next = next_node

    def __repr__(self):
        return f'{self.__class__.__name__}(data={self.data}, next={self.next})'

class SingleLinkedList_v1:
    def __init__(self) -> None:
        '''Возвращает пустой список'''
        self._head = None

    def insert_first_node(self, value: Any) -> None:
        '''Добавить элемент в начало списка'''
        self._head = Node(value, self._head)

    def remove_first_node(self) -> Any:
        '''Удалить первый элемент списка'''
        if self._head is None:
            raise IndexError("Cannot remove from empty list")
        temp = self._head.data
        self._head = self._head.next
        return temp

    def insert_last_node(self, value: Any) -> None:
        '''Добавить элемент в конец списка'''
        if self._head is None:
            self.insert_first_node(value)
        else:
            current_node = self._head
            while current_node.next is not None:
                current_node = current_node.next
            current_node.next = Node(value)

    def remove_last_node(self) -> Any:
        '''Удалить последний элемент списка'''
        if self._head is None:
            raise IndexError("Cannot remove from empty list")
        if self._head.next is None:
            return self.remove_first_node()
        else:
            current_node = self._head
            while current_node.next is not None and current_node.next.next is not None:
                current_node = current_node.next
            if current_node.next is not None:
                temp = current_node.next.data
                current_node.next = None
                return temp
            else:
                raise IndexError("Unexpected error in remove_last_node")

    def __repr__(self) -> str:
        return f'{self.__class__.__name__}({self._head})'

    def __str__(self):
        node = self._head
        elements = []
        while node:
            elements.append(str(node.data))
            node = node.next
        return 'LinkedList.head -> ' + ' -> '.join(elements) + ' -> None'

# Тестирование
if __name__ == "__main__":
    # Создание списка
    lst = SingleLinkedList_v1()
    
    # Добавление элементов в конец
    lst.insert_last_node(10)
    lst.insert_last_node(20)
    lst.insert_last_node(30)
    print("После добавления в конец:", lst)
    
    # Добавление элементов в начало
    lst.insert_first_node(5)
    lst.insert_first_node(1)
    print("После добавления в начало:", lst)
    
    # Удаление первого элемента
    removed_first = lst.remove_first_node()
    print(f"Удален первый элемент: {removed_first}")
    print("После удаления первого:", lst)
    
    # Удаление последнего элемента
    removed_last = lst.remove_last_node()
    print(f"Удален последний элемент: {removed_last}")
    print("После удаления последнего:", lst)

doctest.testmod()
```

    После добавления в конец: LinkedList.head -> 10 -> 20 -> 30 -> None
    После добавления в начало: LinkedList.head -> 1 -> 5 -> 10 -> 20 -> 30 -> None
    Удален первый элемент: 1
    После удаления первого: LinkedList.head -> 5 -> 10 -> 20 -> 30 -> None
    Удален последний элемент: 30
    После удаления последнего: LinkedList.head -> 5 -> 10 -> 20 -> None
    




    TestResults(failed=0, attempted=0)



### Линейный односвязный список. Версия 2.


```python
from typing import Any, TypeVar

ValueType = TypeVar('ValueType')

class SingleLinkedList_v2:
    def __init__(self) -> None:
        '''Возвращает пустой список'''
        self._head = None

    def insert_first_node(self, value: Any) -> None:
        '''Добавить элемент в начало списка'''
        self._head = Node(value, self._head)

    def remove_first_node(self) -> Any:
        '''Удалить первый элемент списка'''
        if self._head is None:
            raise IndexError("Cannot remove from empty list")
        temp = self._head.data
        self._head = self._head.next
        return temp

    def insert_last_node(self, value: Any) -> None:
        '''Добавить элемент в конец списка'''
        if self._head is None:
            self.insert_first_node(value)
        else:
            current_node = self._head
            while current_node.next is not None:
                current_node = current_node.next
            current_node.next = Node(value)

    def remove_last_node(self) -> Any:
        '''Удалить последний элемент списка'''
        if self._head is None:
            raise IndexError("Cannot remove from empty list")
        if self._head.next is None:
            return self.remove_first_node()
        else:
            current_node = self._head
            while current_node.next is not None and current_node.next.next is not None:
                current_node = current_node.next
            if current_node.next is not None:
                temp = current_node.next.data
                current_node.next = None
                return temp
            else:
                raise IndexError("Unexpected error in remove_last_node")
    
    def get_size(self) -> int:
        '''Получить размер списка'''
        if self._head is None:
            return 0
        size = 0
        current_node = self._head
        while current_node is not None:
            size += 1
            current_node = current_node.next
        return size
    
    def find_node(self, value: ValueType) -> ValueType:
        '''Найти узел по значению'''
        current_node = self._head
        while current_node is not None:
            if current_node.data == value:
                return current_node.data
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def replace_node(self, old_value: ValueType, new_value: ValueType) -> None:
        '''Заменить значение узла'''
        self.find_node(old_value)  # Проверяем существование значения
        current_node = self._head
        while current_node is not None:
            if current_node.data == old_value:
                current_node.data = new_value
                return
            current_node = current_node.next
    
    def remove_node(self, value: ValueType) -> ValueType:
        '''Удалить узел по значению'''
        if self._head is None:
            raise ValueError(f"Value {value} not found in the list")
        if self._head.data == value:
            removed_data = self._head.data
            self._head = self._head.next
            return removed_data
        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == value:
                removed_data = current_node.next.data
                current_node.next = current_node.next.next
                return removed_data
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")

    def __repr__(self) -> str:
        return f'{self.__class__.__name__}({self._head})'

    def __str__(self):
        node = self._head
        elements = []
        while node:
            elements.append(str(node.data))
            node = node.next
        return 'LinkedList.head -> ' + ' -> '.join(elements) + ' -> None'

# Тестирование
if __name__ == "__main__":
    lst = SingleLinkedList_v2()
    
    # Добавление элементов
    lst.insert_last_node(10)
    lst.insert_last_node(20)
    lst.insert_last_node(30)
    lst.insert_first_node(5)
    
    print("Список:", lst)
    print("Размер списка:", lst.get_size())
    
    # Поиск элемента
    try:
        found = lst.find_node(20)
        print(f"Найден элемент: {found}")
    except ValueError as e:
        print(e)
    
    # Замена элемента
    lst.replace_node(20, 25)
    print("После замены 20 на 25:", lst)
    
    # Удаление элемента
    try:
        removed = lst.remove_node(25)
        print(f"Удален элемент: {removed}")
        print("После удаления:", lst)
    except ValueError as e:
        print(e)

doctest.testmod()
```

    Список: LinkedList.head -> 5 -> 10 -> 20 -> 30 -> None
    Размер списка: 4
    Найден элемент: 20
    После замены 20 на 25: LinkedList.head -> 5 -> 10 -> 25 -> 30 -> None
    Удален элемент: 25
    После удаления: LinkedList.head -> 5 -> 10 -> 30 -> None
    




    TestResults(failed=0, attempted=0)



### Линейный односвязный список. Версия 3.


```python
class SingleLinkedList_v3:
    def __init__(self) -> None:
        '''Возвращает пустой список'''
        self._head = None
        self._length: int = 0

    def insert_first_node(self, value: Any) -> None:
        '''Добавить элемент в начало списка'''
        self._head = Node(value, self._head)
        self._length += 1

    def remove_first_node(self) -> Any:
        '''Удалить первый элемент списка'''
        if self._head is None:
            raise IndexError("Cannot remove from empty list")
        temp = self._head.data
        self._head = self._head.next
        self._length -= 1
        return temp

    def insert_last_node(self, value: Any) -> None:
        '''Добавить элемент в конец списка'''
        if self._head is None:
            self.insert_first_node(value)
        else:
            current_node = self._head
            while current_node.next is not None:
                current_node = current_node.next
            current_node.next = Node(value)
        self._length += 1

    def remove_last_node(self) -> Any:
        '''Удалить последний элемент списка'''
        if self._head is None:
            raise IndexError("Cannot remove from empty list")
        if self._head.next is None:
            return self.remove_first_node()
        else:
            current_node = self._head
            while current_node.next is not None and current_node.next.next is not None:
                current_node = current_node.next
            if current_node.next is not None:
                temp = current_node.next.data
                current_node.next = None
                self._length -= 1
                return temp
            else:
                raise IndexError("Unexpected error in remove_last_node")
    
    def get_size(self) -> int:
        '''Получить размер списка (оптимизированно)'''
        return self._length
    
    def find_node(self, value: ValueType) -> ValueType:
        '''Найти узел по значению'''
        current_node = self._head
        while current_node is not None:
            if current_node.data == value:
                return current_node.data
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def replace_node(self, old_value: ValueType, new_value: ValueType) -> None:
        '''Заменить значение узла'''
        self.find_node(old_value)
        current_node = self._head
        while current_node is not None:
            if current_node.data == old_value:
                current_node.data = new_value
                return
            current_node = current_node.next
    
    def remove_node(self, value: ValueType) -> ValueType:
        '''Удалить узел по значению'''
        if self._head is None:
            raise ValueError(f"Value {value} not found in the list")
        if self._head.data == value:
            removed_data = self._head.data
            self._head = self._head.next
            self._length -= 1
            return removed_data
        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == value:
                removed_data = current_node.next.data
                current_node.next = current_node.next.next
                self._length -= 1
                return removed_data
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")

    def __repr__(self) -> str:
        return f'{self.__class__.__name__}({self._head})'

    def __str__(self):
        node = self._head
        elements = []
        while node:
            elements.append(str(node.data))
            node = node.next
        return 'LinkedList.head -> ' + ' -> '.join(elements) + ' -> None'

# Тестирование
if __name__ == "__main__":
    lst = SingleLinkedList_v3()
    
    # Добавление элементов
    lst.insert_last_node(10)
    lst.insert_last_node(20)
    lst.insert_last_node(30)
    lst.insert_first_node(5)
    
    print("Список:", lst)
    print("Размер списка:", lst.get_size())
    
    # Проверка счетчика длины
    lst.remove_first_node()
    print("После удаления первого элемента:")
    print("Список:", lst)
    print("Размер списка:", lst.get_size())

doctest.testmod()
```

    Список: LinkedList.head -> 5 -> 10 -> 20 -> 30 -> None
    Размер списка: 5
    После удаления первого элемента:
    Список: LinkedList.head -> 10 -> 20 -> 30 -> None
    Размер списка: 4
    




    TestResults(failed=0, attempted=0)



### Линейный односвязный список. Версия 4.


```python
class SingleLinkedList_v4:
    def __init__(self) -> None:
        '''Возвращает пустой список'''
        self._head = None
        self._length: int = 0

    def insert_first_node(self, value: Any) -> None:
        '''Добавить элемент в начало списка'''
        self._head = Node(value, self._head)
        self._length += 1

    def remove_first_node(self) -> Any:
        '''Удалить первый элемент списка'''
        if self._head is None:
            raise IndexError("Cannot remove from empty list")
        temp = self._head.data
        self._head = self._head.next
        self._length -= 1
        return temp

    def insert_last_node(self, value: Any) -> None:
        '''Добавить элемент в конец списка'''
        if self._head is None:
            self.insert_first_node(value)
        else:
            current_node = self._head
            while current_node.next is not None:
                current_node = current_node.next
            current_node.next = Node(value)
        self._length += 1

    def remove_last_node(self) -> Any:
        '''Удалить последний элемент списка'''
        if self._head is None:
            raise IndexError("Cannot remove from empty list")
        if self._head.next is None:
            return self.remove_first_node()
        else:
            current_node = self._head
            while current_node.next is not None and current_node.next.next is not None:
                current_node = current_node.next
            if current_node.next is not None:
                temp = current_node.next.data
                current_node.next = None
                self._length -= 1
                return temp
            else:
                raise IndexError("Unexpected error in remove_last_node")
    
    def get_size(self) -> int:
        return self._length
    
    def find_node(self, value: ValueType) -> ValueType:
        current_node = self._head
        while current_node is not None:
            if current_node.data == value:
                return current_node.data
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def replace_node(self, old_value: ValueType, new_value: ValueType) -> None:
        self.find_node(old_value)
        current_node = self._head
        while current_node is not None:
            if current_node.data == old_value:
                current_node.data = new_value
                return
            current_node = current_node.next
    
    def remove_node(self, value: ValueType) -> ValueType:
        if self._head is None:
            raise ValueError(f"List is empty")
        if self._head.data == value:
            removed_data = self._head.data
            self._head = self._head.next
            self._length -= 1
            return removed_data
        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == value:
                removed_data = current_node.next.data
                current_node.next = current_node.next.next
                self._length -= 1
                return removed_data
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def find_previous_node(self, value: ValueType) -> ValueType:
        '''Найти предыдущий узел'''
        if self._head is None:
            raise ValueError(f"List is empty")
        if self._head.data == value:
            raise ValueError(f"First element {value} has no previous node")
        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == value:
                return current_node.data
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def find_next_node(self, value: ValueType) -> ValueType:
        '''Найти следующий узел'''
        if self._head is None:
            raise ValueError(f"List is empty")
        current_node = self._head
        while current_node is not None:
            if current_node.data == value:
                if current_node.next is not None:
                    return current_node.next.data
                else:
                    raise ValueError(f"Last element {value} has no next node")
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def insert_before_node(self, target_value: ValueType, new_value: ValueType) -> None:
        '''Вставить перед указанным узлом'''
        if self._head is None:
            raise ValueError(f"List is empty")
        if self._head.data == target_value:
            self.insert_first_node(new_value)
            return
        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == target_value:
                new_node = Node(new_value)
                new_node.next = current_node.next
                current_node.next = new_node
                self._length += 1
                return
            current_node = current_node.next
        raise ValueError(f"Value {target_value} not found in the list")
    
    def insert_after_node(self, target_value: ValueType, new_value: ValueType) -> None:
        '''Вставить после указанного узла'''
        if self._head is None:
            raise ValueError(f"List is empty")
        current_node = self._head
        while current_node is not None:
            if current_node.data == target_value:
                new_node = Node(new_value)
                new_node.next = current_node.next
                current_node.next = new_node
                self._length += 1
                return
            current_node = current_node.next
        raise ValueError(f"Value {target_value} not found in the list")

    def __repr__(self) -> str:
        return f'{self.__class__.__name__}({self._head})'

    def __str__(self):
        node = self._head
        elements = []
        while node:
            elements.append(str(node.data))
            node = node.next
        return 'LinkedList.head -> ' + ' -> '.join(elements) + ' -> None'

# Тестирование
if __name__ == "__main__":
    lst = SingleLinkedList_v4()
    
    # Добавление элементов
    lst.insert_last_node(10)
    lst.insert_last_node(20)
    lst.insert_last_node(30)
    
    print("Исходный список:", lst)
    
    # Вставка перед узлом
    lst.insert_before_node(20, 15)
    print("После вставки 15 перед 20:", lst)
    
    # Вставка после узла
    lst.insert_after_node(20, 25)
    print("После вставки 25 после 20:", lst)
    
    # Поиск предыдущего и следующего
    try:
        prev = lst.find_previous_node(20)
        next_val = lst.find_next_node(20)
        print(f"Предыдущий для 20: {prev}, следующий для 20: {next_val}")
    except ValueError as e:
        print(e)

doctest.testmod()
```

    Исходный список: LinkedList.head -> 10 -> 20 -> 30 -> None
    После вставки 15 перед 20: LinkedList.head -> 10 -> 15 -> 20 -> 30 -> None
    После вставки 25 после 20: LinkedList.head -> 10 -> 15 -> 20 -> 25 -> 30 -> None
    Предыдущий для 20: 15, следующий для 20: 25
    




    TestResults(failed=0, attempted=0)



### Линейный односвязный список. Версия 5


```python
class SingleLinkedList_v5:
    def __init__(self) -> None:
        '''Возвращает пустой список'''
        self._head = None
        self._length: int = 0
        self._tail = None  # Добавляем указатель на хвост

    def get_tail(self):
        '''Получить хвост списка'''
        if self._tail is None:
            return None
        return self._tail.data

    def insert_first_node(self, value: Any) -> None:
        '''Добавить элемент в начало списка'''
        new_node = Node(value)
        if self._head is None:
            self._head = new_node
            self._tail = new_node
        else:
            new_node.next = self._head
            self._head = new_node
        self._length += 1

    def remove_first_node(self) -> Any:
        '''Удалить первый элемент списка'''
        if self._head is None:
            raise IndexError("Cannot remove from empty list")
        temp = self._head.data
        if self._head == self._tail:  # Если в списке один элемент
            self._head = None
            self._tail = None
        else:
            self._head = self._head.next
        self._length -= 1
        return temp

    def insert_last_node(self, value: Any) -> None:
        '''Добавить элемент в конец списка (оптимизированно)'''
        new_node = Node(value)
        if self._tail is None:
            self._head = new_node
            self._tail = new_node
        else:
            self._tail.next = new_node
            self._tail = new_node
        self._length += 1

    def remove_last_node(self) -> ValueType:
        '''Удалить последний элемент списка'''
        if self._head is None or self._tail is None:
            raise IndexError("Cannot remove from empty list")
        if self._head == self._tail:  # Если в списке один элемент
            temp = self._head.data
            self._head = None
            self._tail = None
            self._length -= 1
            return temp
        
        # Ищем предпоследний элемент
        current_node = self._head
        while current_node.next != self._tail:
            current_node = current_node.next
        
        temp = self._tail.data
        current_node.next = None
        self._tail = current_node
        self._length -= 1
        return temp
    
    def get_size(self) -> int:
        return self._length
    
    def find_node(self, value: ValueType) -> ValueType:
        current_node = self._head
        while current_node is not None:
            if current_node.data == value:
                return current_node.data
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def replace_node(self, old_value: ValueType, new_value: ValueType) -> None:
        current_node = self._head
        while current_node is not None:
            if current_node.data == old_value:
                current_node.data = new_value
                return
            current_node = current_node.next
        raise ValueError(f"Value {old_value} not found in the list")
    
    def remove_node(self, value: ValueType) -> ValueType:
        if self._head is None:
            raise ValueError(f"List is empty")
        if self._head.data == value:
            return self.remove_first_node()
        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == value:
                if current_node.next == self._tail:
                    self._tail = current_node
                removed_data = current_node.next.data
                current_node.next = current_node.next.next
                self._length -= 1
                return removed_data
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")

    def __repr__(self) -> str:
        return f'{self.__class__.__name__}({self._head})'

    def __str__(self):
        node = self._head
        elements = []
        while node:
            elements.append(str(node.data))
            node = node.next
        return 'LinkedList.head -> ' + ' -> '.join(elements) + ' -> None'

# Тестирование
if __name__ == "__main__":
    lst = SingleLinkedList_v5()
    
    # Добавление в конец (оптимизированно)
    lst.insert_last_node(10)
    lst.insert_last_node(20)
    lst.insert_last_node(30)
    
    print("Список:", lst)
    print("Хвост списка:", lst.get_tail())
    print("Размер:", lst.get_size())
    
    # Удаление с конца
    lst.remove_last_node()
    print("После удаления последнего:", lst)
    print("Новый хвост:", lst.get_tail())

doctest.testmod()
```

    Список: LinkedList.head -> 10 -> 20 -> 30 -> None
    Хвост списка: 30
    Размер: 3
    После удаления последнего: LinkedList.head -> 10 -> 20 -> None
    Новый хвост: 20
    




    TestResults(failed=0, attempted=0)



### Линейный односвязный список. Версия 6.


```python
class SingleLinkedList_v6:
    def __init__(self) -> None:
        '''Возвращает пустой список'''
        self._head = None
        self._length: int = 0
        self._tail = None

    def get_tail(self):
        if self._tail is None:
            return None
        return self._tail.data

    def insert_first_node(self, value: Any) -> None:
        new_node = Node(value)
        if self._head is None:
            self._head = new_node
            self._tail = new_node
        else:
            new_node.next = self._head
            self._head = new_node
        self._length += 1

    def remove_first_node(self) -> Any:
        if self._head is None:
            raise IndexError("Cannot remove from empty list")
        temp = self._head.data
        if self._head == self._tail:
            self._head = None
            self._tail = None
        else:
            self._head = self._head.next
        self._length -= 1
        return temp

    def insert_last_node(self, value: Any) -> None:
        new_node = Node(value)
        if self._tail is None:
            self._head = new_node
            self._tail = new_node
        else:
            self._tail.next = new_node
            self._tail = new_node
        self._length += 1

    def remove_last_node(self) -> ValueType:
        if self._head is None or self._tail is None:
            raise IndexError("Cannot remove from empty list")
        if self._head == self._tail:
            temp = self._head.data
            self._head = None
            self._tail = None
            self._length -= 1
            return temp
        
        current_node = self._head
        while current_node.next != self._tail:
            current_node = current_node.next
        
        temp = self._tail.data
        current_node.next = None
        self._tail = current_node
        self._length -= 1
        return temp
    
    def get_size(self) -> int:
        return self._length
    
    def find_node(self, value: ValueType) -> ValueType:
        current_node = self._head
        while current_node is not None:
            if current_node.data == value:
                return current_node.data
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def replace_node(self, old_value: ValueType, new_value: ValueType) -> None:
        current_node = self._head
        while current_node is not None:
            if current_node.data == old_value:
                current_node.data = new_value
                return
            current_node = current_node.next
        raise ValueError(f"Value {old_value} not found in the list")
    
    def remove_node(self, value: ValueType) -> ValueType:
        if self._head is None:
            raise ValueError(f"List is empty")
        if self._head.data == value:
            return self.remove_first_node()
        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == value:
                if current_node.next == self._tail:
                    self._tail = current_node
                removed_data = current_node.next.data
                current_node.next = current_node.next.next
                self._length -= 1
                return removed_data
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def reverse(self):
        '''Развернуть список'''
        if self._head is None or self._head == self._tail:
            return
        
        prev_node = None
        current_node = self._head
        self._tail = self._head  # Хвост становится головой
        
        while current_node is not None:
            next_node = current_node.next
            current_node.next = prev_node
            prev_node = current_node
            current_node = next_node
        
        self._head = prev_node  # Новая голова - последний узел

    def sort(self):
        '''Отсортировать список (пузырьковая сортировка)'''
        if self._head is None or self._head == self._tail:
            return
        
        swapped = True
        while swapped:
            swapped = False
            current_node = self._head
            while current_node and current_node.next:
                if current_node.data > current_node.next.data:
                    # Обмен значениями
                    current_node.data, current_node.next.data = current_node.next.data, current_node.data
                    swapped = True
                current_node = current_node.next
        
        # Обновляем хвост после сортировки
        self._tail = self._head
        while self._tail and self._tail.next:
            self._tail = self._tail.next

    def __repr__(self) -> str:
        return f'{self.__class__.__name__}({self._head})'

    def __str__(self):
        node = self._head
        elements = []
        while node:
            elements.append(str(node.data))
            node = node.next
        return 'LinkedList.head -> ' + ' -> '.join(elements) + ' -> None'

# Тестирование
if __name__ == "__main__":
    lst = SingleLinkedList_v6()
    
    # Добавление элементов в произвольном порядке
    lst.insert_last_node(30)
    lst.insert_first_node(10)
    lst.insert_last_node(40)
    lst.insert_first_node(5)
    lst.insert_last_node(20)
    
    print("Исходный список:", lst)
    
    # Сортировка
    lst.sort()
    print("После сортировки:", lst)
    
    # Разворот
    lst.reverse()
    print("После разворота:", lst)

doctest.testmod()
```

    Исходный список: LinkedList.head -> 5 -> 10 -> 30 -> 40 -> 20 -> None
    После сортировки: LinkedList.head -> 5 -> 10 -> 20 -> 30 -> 40 -> None
    После разворота: LinkedList.head -> 40 -> 30 -> 20 -> 10 -> 5 -> None
    




    TestResults(failed=0, attempted=0)



### Линейный односвязный список. Индивидуальное задание №1.
Задание: Написать функцию, которая по двум линейным спискам L1 и L2 формирует новый список L, состоящий из элементов, входящих в L1, но не входящих в L2.


```python
def list_difference(l1: SingleLinkedList_v6, l2: SingleLinkedList_v6) -> SingleLinkedList_v6:
    '''
    Создает новый список из элементов, входящих в L1, но не входящих в L2
    
    >>> l1 = SingleLinkedList_v6()
    >>> l2 = SingleLinkedList_v6()
    >>> l1.insert_last_node(1); l1.insert_last_node(2); l1.insert_last_node(3); l1.insert_last_node(4)
    >>> l2.insert_last_node(2); l2.insert_last_node(4); l2.insert_last_node(6)
    >>> result = list_difference(l1, l2)
    >>> str(result)
    'LinkedList.head -> 1 -> 3 -> None'
    '''
    result = SingleLinkedList_v6()
    
    # Проходим по всем элементам первого списка
    current = l1._head
    while current is not None:
        value = current.data
        try:
            # Пытаемся найти элемент во втором списке
            l2.find_node(value)
        except ValueError:
            # Если элемент не найден во втором списке, добавляем в результат
            result.insert_last_node(value)
        current = current.next
    
    return result

# Тестирование индивидуального задания
if __name__ == "__main__":
    # Создаем два списка
    list1 = SingleLinkedList_v6()
    list2 = SingleLinkedList_v6()
    
    # Заполняем первый список
    for value in [1, 2, 3, 4, 5]:
        list1.insert_last_node(value)
    
    # Заполняем второй список
    for value in [2, 4, 6, 8]:
        list2.insert_last_node(value)
    
    print("Первый список:", list1)
    print("Второй список:", list2)
    
    # Применяем функцию разности
    difference = list_difference(list1, list2)
    print("Элементы из L1, которых нет в L2:", difference)

doctest.testmod()
```

    Первый список: LinkedList.head -> 1 -> 2 -> 3 -> 4 -> 5 -> None
    Второй список: LinkedList.head -> 2 -> 4 -> 6 -> 8 -> None
    Элементы из L1, которых нет в L2: LinkedList.head -> 1 -> 3 -> 5 -> None
    




    TestResults(failed=0, attempted=6)


