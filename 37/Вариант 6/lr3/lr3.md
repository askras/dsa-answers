# Линейные списки

***

Старшинов Владислав Эдуардович

ИУ10-37

Вариант 6

## Задания

***

### Линейный односвязный список. Версия 1.


```python
from typing import Any, Self
import doctest

class Node:
    def __init__(self, data:Any=None, next=None):
        self.data = data
        self.next = next

    def __repr__(self):
         return f'{self.__class__.__name__}(data={self.data}, next={self.next})'

class SingleLinkedList_v1:
    def __init__(self) -> None:
        '''Возвращает пустой список'''
        self._head = None

    def insert_first_node(self, value:Any) -> None:
        '''Добавить элемент в начало списка'''
        self._head = Node(value, self._head)

    def remove_first_node(self) -> Any:
        '''Удалить первый элемент списка'''
        if self._head is None:
            raise IndexError("Cannot remove from empty list")
        temp = self._head.data
        self._head = self._head.next
        return temp

    def insert_last_node(self, value:Any) -> None:
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
        l = []
        while node:
            l.append(str(node.data))
            node = node.next
        return 'LinkedList.head -> ' + ' -> '.join(l) + ' -> None'


doctest.testmod()
```

### Линейный односвязный список. Версия 2.


```python
from typing import Any, Self
import doctest
from typing import TypeVar, Optional

ValueType = TypeVar('ValueType')

class Node:
    def __init__(self, data:Any=None, next=None):
        self.data = data
        self.next = next

    def __repr__(self):
         return f'{self.__class__.__name__}(data={self.data}, next={self.next})'

class SingleLinkedList_v2:
    def __init__(self) -> None:
        '''Возвращает пустой список'''
        self._head = None

    def insert_first_node(self, value:Any) -> None:
        '''Добавить элемент в начало списка'''
        self._head = Node(value, self._head)

    def remove_first_node(self) -> Any:
        '''Удалить первый элемент списка'''
        if self._head is None:
            raise IndexError("Cannot remove from empty list")
        temp = self._head.data
        self._head = self._head.next
        return temp

    def insert_last_node(self, value:Any) -> None:
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
        if self._head is None:
            return 0
        size = 0
        current_node = self._head
        while current_node is not None:
            size += 1
            current_node = current_node.next
        return size
    
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
        l = []
        while node:
            l.append(str(node.data))
            node = node.next
        return 'LinkedList.head -> ' + ' -> '.join(l) + ' -> None'


doctest.testmod()
```

### Линейный односвязный список. Версия 3.


```python
from typing import Any, Self
import doctest
from typing import TypeVar, Optional

ValueType = TypeVar('ValueType')

class Node:
    def __init__(self, data:Any=None, next=None):
        self.data = data
        self.next = next

    def __repr__(self):
         return f'{self.__class__.__name__}(data={self.data}, next={self.next})'

class SingleLinkedList_v3:

    def __init__(self) -> None:
        '''Возвращает пустой список'''
        self._head = None
        self._length: int = 0

    def insert_first_node(self, value:Any) -> None:
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

    def insert_last_node(self, value:Any) -> None:
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
                self._length -= 1
                return removed_data
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")


    def __repr__(self) -> str:
        return f'{self.__class__.__name__}({self._head})'

    def __str__(self):
        node = self._head
        l = []
        while node:
            l.append(str(node.data))
            node = node.next
        return 'LinkedList.head -> ' + ' -> '.join(l) + ' -> None'


doctest.testmod()
```

### Линейный односвязный список. Версия 4.


```python
from typing import Any, Self
import doctest
from typing import TypeVar, Optional

ValueType = TypeVar('ValueType')

class Node:
    def __init__(self, data:Any=None, next=None):
        self.data = data
        self.next = next

    def __repr__(self):
         return f'{self.__class__.__name__}(data={self.data}, next={self.next})'

class SingleLinkedList_v4:

    def __init__(self) -> None:
        '''Возвращает пустой список'''
        self._head = None
        self._length: int = 0

    def insert_first_node(self, value:Any) -> None:
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

    def insert_last_node(self, value:Any) -> None:
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
    
    def insert_before_node(self, value: ValueType) -> None:
        if self._head is None:
            raise ValueError(f"List is empty")
        if self._head.data == value:
            new_node = Node(value)
            new_node.next = self._head
            self._head = new_node
            self._length += 1
            return
        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == value:
                new_node = Node(value)
                new_node.next = current_node.next
                current_node.next = new_node
                self._length += 1
                return
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def insert_after_node(self, value: ValueType) -> None:
        if self._head is None:
            raise ValueError(f"List is empty")
        current_node = self._head
        while current_node is not None:
            if current_node.data == value:
                new_node = Node(value)
                new_node.next = current_node.next
                current_node.next = new_node
                self._length += 1
                return
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def replace_previous_node(self, old_value: ValueType, new_value: ValueType) -> None:
        if self._head is None:
            raise ValueError(f"List is empty")
        if self._head.data == old_value:
            raise ValueError(f"First element {old_value} has no previous node")
        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == old_value:
                current_node.data = new_value
                return
            current_node = current_node.next
        raise ValueError(f"Value {old_value} not found in the list")
    
    def replace_next_node(self, old_value: ValueType, new_value: ValueType) -> None:
        if self._head is None:
            raise ValueError(f"List is empty")
        current_node = self._head
        while current_node is not None:
            if current_node.data == old_value:
                if current_node.next is not None:
                    current_node.next.data = new_value
                    return
                else:
                    raise ValueError(f"Last element {old_value} has no next node")
            current_node = current_node.next
        raise ValueError(f"Value {old_value} not found in the list")
        
    def remove_previous_node(self, value: ValueType) -> ValueType:
        if self._head is None:
            raise ValueError(f"List is empty")
        if self._head.data == value:
            raise ValueError(f"First element {value} has no previous element")
        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == value:
                removed_data = current_node.data
                current_node = current_node.next
                self._length -= 1
                return removed_data
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def remove_next_node(self, value: ValueType) -> ValueType:
        if self._head is None:
            raise ValueError(f"List is empty")
        current_node = self._head
        while current_node is not None:
            if current_node.data == value:
                if current_node.next is not None:
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
        l = []
        while node:
            l.append(str(node.data))
            node = node.next
        return 'LinkedList.head -> ' + ' -> '.join(l) + ' -> None'


doctest.testmod()
```

### Линейный односвязный список. Версия 5


```python
from typing import Any, Self
import doctest
from typing import TypeVar, Optional

ValueType = TypeVar('ValueType')

class Node:
    def __init__(self, data:Any=None, next=None):
        self.data = data
        self.next = next

    def __repr__(self):
         return f'{self.__class__.__name__}(data={self.data}, next={self.next})'

class SingleLinkedList_v5:

    def __init__(self) -> None:
        '''Возвращает пустой список'''
        self._head = None
        self._length: int = 0
        self._tail = None

    def get_tail(self):
        if self._tail is None:
            return None
        return self._tail.data

    def insert_first_node(self, value:Any) -> None:
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
        if self._head == self._tail:
            self._head = None
            self._tail = None
        else:
            self._head = self._head.next
        self._length -= 1
        return temp

    def insert_last_node(self, value:Any) -> None:
        '''Добавить элемент в конец списка'''
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
        if self._head == self._tail:
            temp = self._head.data
            self._head = None
            self._tail = None
            self._length -= 1
            return temp
        current_node = self._head
        while current_node is not None and current_node.next != self._tail:
            current_node = current_node.next
        if current_node is None or self._tail is None:
            raise IndexError("Unexpected error in remove_last_node")
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
    
    def find_previous_node(self, value: ValueType) -> ValueType:
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
    
    def insert_before_node(self, value: ValueType) -> None:
        if self._head is None:
            raise ValueError(f"List is empty")
        if self._head.data == value:
            new_node = Node(value)
            new_node.next = self._head
            self._head = new_node
            self._length += 1
            return
        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == value:
                new_node = Node(value)
                new_node.next = current_node.next
                current_node.next = new_node
                self._length += 1
                return
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def insert_after_node(self, value: ValueType) -> None:
        if self._head is None:
            raise ValueError(f"List is empty")
        current_node = self._head
        while current_node is not None:
            if current_node.data == value:
                new_node = Node(value)
                new_node.next = current_node.next
                current_node.next = new_node
                if current_node == self._tail:
                    self._tail = new_node
                self._length += 1
                return
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def replace_previous_node(self, old_value: ValueType, new_value: ValueType) -> None:
        if self._head is None:
            raise ValueError(f"List is empty")
        if self._head.data == old_value:
            raise ValueError(f"First element {old_value} has no previous node")
        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == old_value:
                current_node.data = new_value
                return
            current_node = current_node.next
        raise ValueError(f"Value {old_value} not found in the list")
    
    def replace_next_node(self, old_value: ValueType, new_value: ValueType) -> None:
        if self._head is None:
            raise ValueError(f"List is empty")
        current_node = self._head
        while current_node is not None:
            if current_node.data == old_value:
                if current_node.next is not None:
                    current_node.next.data = new_value
                    return
                else:
                    raise ValueError(f"Last element {old_value} has no next node")
            current_node = current_node.next
        raise ValueError(f"Value {old_value} not found in the list")
        
    def remove_previous_node(self, value: ValueType) -> ValueType:
        if self._head is None:
            raise ValueError(f"List is empty")
        if self._head.data == value:
            raise ValueError(f"First element {value} has no previous element")
        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == value:
                removed_data = current_node.data
                current_node = current_node.next
                self._length -= 1
                return removed_data
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def remove_next_node(self, value: ValueType) -> ValueType:
        if self._head is None:
            raise ValueError(f"List is empty")
        current_node = self._head
        while current_node is not None:
            if current_node.data == value:
                if current_node.next is not None:
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
        l = []
        while node:
            l.append(str(node.data))
            node = node.next
        return 'LinkedList.head -> ' + ' -> '.join(l) + ' -> None'


doctest.testmod()
```




    TestResults(failed=0, attempted=0)



### Линейный односвязный список. Версия 6.


```python
from typing import Any, Self
import doctest
from typing import TypeVar, Optional

ValueType = TypeVar('ValueType')

class Node:
    def __init__(self, data:Any=None, next=None):
        self.data = data
        self.next = next

    def __repr__(self):
         return f'{self.__class__.__name__}(data={self.data}, next={self.next})'

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

    def insert_first_node(self, value:Any) -> None:
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
        if self._head == self._tail:
            self._head = None
            self._tail = None
        else:
            self._head = self._head.next
        self._length -= 1
        return temp

    def insert_last_node(self, value:Any) -> None:
        '''Добавить элемент в конец списка'''
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
        if self._head == self._tail:
            temp = self._head.data
            self._head = None
            self._tail = None
            self._length -= 1
            return temp
        current_node = self._head
        while current_node is not None and current_node.next != self._tail:
            current_node = current_node.next
        if current_node is None or self._tail is None:
            raise IndexError("Unexpected error in remove_last_node")
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
    
    def find_previous_node(self, value: ValueType) -> ValueType:
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
    
    def insert_before_node(self, value: ValueType) -> None:
        if self._head is None:
            raise ValueError(f"List is empty")
        if self._head.data == value:
            new_node = Node(value)
            new_node.next = self._head
            self._head = new_node
            self._length += 1
            return
        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == value:
                old_value = current_node.next.data
                current_node.next.data = value
                new_node = Node(old_value)
                new_node.next = current_node.next.next
                current_node.next.next = new_node
                if new_node.next is None:
                    self._tail = new_node
                self._length += 1
                return
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def insert_after_node(self, value: ValueType) -> None:
        if self._head is None:
            raise ValueError(f"List is empty")
        current_node = self._head
        while current_node is not None:
            if current_node.data == value:
                new_node = Node(value)
                new_node.next = current_node.next
                current_node.next = new_node
                if current_node == self._tail:
                    self._tail = new_node
                self._length += 1
                return
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def replace_previous_node(self, old_value: ValueType, new_value: ValueType) -> None:
        if self._head is None or self._head.data == old_value:
            raise ValueError(f"No previous node for {old_value}")
        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == old_value:
                current_node.data = new_value
                return
            current_node = current_node.next
        raise ValueError(f"Value {old_value} not found in the list")
    
    def replace_next_node(self, old_value: ValueType, new_value: ValueType) -> None:
        current_node = self._head
        while current_node is not None:
            if current_node.data == old_value and current_node.next is not None:
                current_node.next.data = new_value
                return
            current_node = current_node.next
        raise ValueError(f"Value {old_value} not found in the list or no next node")
        
    def remove_previous_node(self, value: ValueType) -> ValueType:
        if self._head is None:
            raise ValueError(f"List is empty")
        if self._head.data == value:
            raise ValueError(f"First element {value} has no previous element")
        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == value:
                removed_data = current_node.data
                current_node = current_node.next
                self._length -= 1
                return removed_data
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def remove_next_node(self, value: ValueType) -> ValueType:
        if self._head is None:
            raise ValueError(f"List is empty")
        current_node = self._head
        while current_node is not None:
            if current_node.data == value:
                if current_node.next is not None:
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
        l = []
        while node:
            l.append(str(node.data))
            node = node.next
        return 'LinkedList.head -> ' + ' -> '.join(l) + ' -> None'


doctest.testmod()
```

### Линейный односвязный список. Методы reverse и sort.


```python
from typing import Any, Self
import doctest
from typing import TypeVar, Optional

ValueType = TypeVar('ValueType')

class Node:
    def __init__(self, data:Any=None, next=None):
        self.data = data
        self.next = next

    def __repr__(self):
         return f'{self.__class__.__name__}(data={self.data}, next={self.next})'

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

    def insert_first_node(self, value:Any) -> None:
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
        if self._head == self._tail:
            self._head = None
            self._tail = None
        else:
            self._head = self._head.next
        self._length -= 1
        return temp

    def insert_last_node(self, value:Any) -> None:
        '''Добавить элемент в конец списка'''
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
        if self._head == self._tail:
            temp = self._head.data
            self._head = None
            self._tail = None
            self._length -= 1
            return temp
        current_node = self._head
        while current_node is not None and current_node.next != self._tail:
            current_node = current_node.next
        if current_node is None or self._tail is None:
            raise IndexError("Unexpected error in remove_last_node")
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
    
    def find_previous_node(self, value: ValueType) -> ValueType:
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
    
    def insert_before_node(self, value: ValueType) -> None:
        if self._head is None:
            raise ValueError(f"List is empty")
        if self._head.data == value:
            new_node = Node(value)
            new_node.next = self._head
            self._head = new_node
            self._length += 1
            return
        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == value:
                old_value = current_node.next.data
                current_node.next.data = value
                new_node = Node(old_value)
                new_node.next = current_node.next.next
                current_node.next.next = new_node
                if new_node.next is None:
                    self._tail = new_node
                self._length += 1
                return
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def insert_after_node(self, value: ValueType) -> None:
        if self._head is None:
            raise ValueError(f"List is empty")
        current_node = self._head
        while current_node is not None:
            if current_node.data == value:
                new_node = Node(value)
                new_node.next = current_node.next
                current_node.next = new_node
                if current_node == self._tail:
                    self._tail = new_node
                self._length += 1
                return
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def replace_previous_node(self, old_value: ValueType, new_value: ValueType) -> None:
        if self._head is None or self._head.data == old_value:
            raise ValueError(f"No previous node for {old_value}")
        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == old_value:
                current_node.data = new_value
                return
            current_node = current_node.next
        raise ValueError(f"Value {old_value} not found in the list")
    
    def replace_next_node(self, old_value: ValueType, new_value: ValueType) -> None:
        current_node = self._head
        while current_node is not None:
            if current_node.data == old_value and current_node.next is not None:
                current_node.next.data = new_value
                return
            current_node = current_node.next
        raise ValueError(f"Value {old_value} not found in the list or no next node")
        
    def remove_previous_node(self, value: ValueType) -> ValueType:
        if self._head is None:
            raise ValueError(f"List is empty")
        if self._head.data == value:
            raise ValueError(f"First element {value} has no previous element")
        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == value:
                removed_data = current_node.data
                current_node = current_node.next
                self._length -= 1
                return removed_data
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def remove_next_node(self, value: ValueType) -> ValueType:
        if self._head is None:
            raise ValueError(f"List is empty")
        current_node = self._head
        while current_node is not None:
            if current_node.data == value:
                if current_node.next is not None:
                    removed_data = current_node.next.data
                    current_node.next = current_node.next.next
                    self._length -= 1
                    return removed_data
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def reverse(self):
        if self._head is None or self._head == self._tail:
            return
        prev_node = None
        current_node = self._head
        self._tail = self._head
        while current_node is not None:
            next_node = current_node.next
            current_node.next = prev_node
            prev_node = current_node
            current_node = next_node
        self._head = prev_node

    def sort(self):
        if self._head is None or self._head == self._tail:
            return
        swapped = True
        while swapped:
            swapped = False
            current_node = self._head
            while current_node and current_node.next:
                if current_node.data > current_node.next.data:
                    current_node.data, current_node.next.data = current_node.next.data, current_node.data
                    swapped = True
                current_node = current_node.next
        self._tail = self._head
        while self._tail and self._tail.next:
            self._tail = self._tail.next    
        

    def __repr__(self) -> str:
        return f'{self.__class__.__name__}({self._head})'

    def __str__(self):
        node = self._head
        l = []
        while node:
            l.append(str(node.data))
            node = node.next
        return 'LinkedList.head -> ' + ' -> '.join(l) + ' -> None'


doctest.testmod()
```

### Линейный односвязный список. Индивидуальное задание №6.

Описание задания: написать метод, который в каждой группе подряд идущих одинаковых элементов оставляет только один.


```python
from typing import Any, Self
import doctest
from typing import TypeVar, Optional

ValueType = TypeVar('ValueType')

class Node:
    def __init__(self, data:Any=None, next=None):
        self.data = data
        self.next = next

    def __repr__(self):
         return f'{self.__class__.__name__}(data={self.data}, next={self.next})'

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

    def insert_first_node(self, value:Any) -> None:
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
        if self._head == self._tail:
            self._head = None
            self._tail = None
        else:
            self._head = self._head.next
        self._length -= 1
        return temp

    def insert_last_node(self, value:Any) -> None:
        '''Добавить элемент в конец списка'''
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
        if self._head == self._tail:
            temp = self._head.data
            self._head = None
            self._tail = None
            self._length -= 1
            return temp
        current_node = self._head
        while current_node is not None and current_node.next != self._tail:
            current_node = current_node.next
        if current_node is None or self._tail is None:
            raise IndexError("Unexpected error in remove_last_node")
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
    
    def find_previous_node(self, value: ValueType) -> ValueType:
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
    
    def insert_before_node(self, value: ValueType) -> None:
        if self._head is None:
            raise ValueError(f"List is empty")
        if self._head.data == value:
            new_node = Node(value)
            new_node.next = self._head
            self._head = new_node
            self._length += 1
            return
        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == value:
                old_value = current_node.next.data
                current_node.next.data = value
                new_node = Node(old_value)
                new_node.next = current_node.next.next
                current_node.next.next = new_node
                if new_node.next is None:
                    self._tail = new_node
                self._length += 1
                return
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def insert_after_node(self, value: ValueType) -> None:
        if self._head is None:
            raise ValueError(f"List is empty")
        current_node = self._head
        while current_node is not None:
            if current_node.data == value:
                new_node = Node(value)
                new_node.next = current_node.next
                current_node.next = new_node
                if current_node == self._tail:
                    self._tail = new_node
                self._length += 1
                return
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def replace_previous_node(self, old_value: ValueType, new_value: ValueType) -> None:
        if self._head is None or self._head.data == old_value:
            raise ValueError(f"No previous node for {old_value}")
        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == old_value:
                current_node.data = new_value
                return
            current_node = current_node.next
        raise ValueError(f"Value {old_value} not found in the list")
    
    def replace_next_node(self, old_value: ValueType, new_value: ValueType) -> None:
        current_node = self._head
        while current_node is not None:
            if current_node.data == old_value and current_node.next is not None:
                current_node.next.data = new_value
                return
            current_node = current_node.next
        raise ValueError(f"Value {old_value} not found in the list or no next node")
        
    def remove_previous_node(self, value: ValueType) -> ValueType:
        if self._head is None:
            raise ValueError(f"List is empty")
        if self._head.data == value:
            raise ValueError(f"First element {value} has no previous element")
        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == value:
                removed_data = current_node.data
                current_node = current_node.next
                self._length -= 1
                return removed_data
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def remove_next_node(self, value: ValueType) -> ValueType:
        if self._head is None:
            raise ValueError(f"List is empty")
        current_node = self._head
        while current_node is not None:
            if current_node.data == value:
                if current_node.next is not None:
                    removed_data = current_node.next.data
                    current_node.next = current_node.next.next
                    self._length -= 1
                    return removed_data
            current_node = current_node.next
        raise ValueError(f"Value {value} not found in the list")
    
    def reverse(self):
        if self._head is None or self._head == self._tail:
            return
        prev_node = None
        current_node = self._head
        self._tail = self._head
        while current_node is not None:
            next_node = current_node.next
            current_node.next = prev_node
            prev_node = current_node
            current_node = next_node
        self._head = prev_node

    def sort(self):
        if self._head is None or self._head == self._tail:
            return
        swapped = True
        while swapped:
            swapped = False
            current_node = self._head
            while current_node and current_node.next:
                if current_node.data > current_node.next.data:
                    current_node.data, current_node.next.data = current_node.next.data, current_node.data
                    swapped = True
                current_node = current_node.next
        self._tail = self._head
        while self._tail and self._tail.next:
            self._tail = self._tail.next

    def remove_duplicates(self):
        if self._head is None or self._head == self._tail:
            return
        current_node = self._head
        while current_node and current_node.next:
            if current_node.data == current_node.next.data:
                current_node.next = current_node.next.next
                self._length -= 1
            else:
                current_node = current_node.next
        self._tail = self._head
        while self._tail and self._tail.next:
            self._tail = self._tail.next
        

    def __repr__(self) -> str:
        return f'{self.__class__.__name__}({self._head})'

    def __str__(self):
        node = self._head
        l = []
        while node:
            l.append(str(node.data))
            node = node.next
        return 'LinkedList.head -> ' + ' -> '.join(l) + ' -> None'


doctest.testmod()
```
