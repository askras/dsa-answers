#### Линейные списки (Linked list)
#### Лавренчук С.А.

# Задание 1. Последовательно реализовать 6 версий линейного односвязного списка.
    #### Вариант 1. Линейный односвязный список


```python
from typing import TypeVar, Generic, Optional

ValueType = TypeVar('ValueType')

class ListNode(Generic[ValueType]):
    def __init__(self, value: ValueType):
        self.value: ValueType = value
        self.next: Optional[ListNode[ValueType]] = None

class SingleLinkedList(Generic[ValueType]):
    def __init__(self) -> None:
        self._head: Optional[ListNode[ValueType]] = None
        self._tail: Optional[ListNode[ValueType]] = None
        self._size: int = 0
    
    def insert_first_node(self, value: ValueType) -> None:
        new_node = ListNode(value)
        if self._head is None:
            self._head = new_node
            self._tail = new_node
        else:
            new_node.next = self._head
            self._head = new_node
        self._size += 1
    
    def remove_first_node(self) -> ValueType:
        if self._head is None:
            raise IndexError("Cannot remove from empty list")
        removed_value = self._head.value
        if self._head == self._tail:
            self._head = None
            self._tail = None
        else:
            self._head = self._head.next
        self._size -= 1
        return removed_value
    
    def insert_last_node(self, value: ValueType) -> None:
        new_node = ListNode(value)
        if self._tail is None:
            self._head = new_node
            self._tail = new_node
        else:
            self._tail.next = new_node
            self._tail = new_node
        self._size += 1
    
    def remove_last_node(self) -> ValueType:
        if self._tail is None:
            raise IndexError("Cannot remove from empty list")
        removed_value = self._tail.value
        if self._head == self._tail:
            self._head = None
            self._tail = None
        else:
            current = self._head
            while current and current.next != self._tail:
                current = current.next
            if current:
                current.next = None
                self._tail = current
        self._size -= 1
        return removed_value
    
    def is_empty(self) -> bool:
        return self._head is None
    
    def get_size(self) -> int:
        return self._size
    
    def display(self) -> str:
        elements = []
        current = self._head
        while current:
            elements.append(str(current.value))
            current = current.next
        return " -> ".join(elements) if elements else "Empty list"
    
    def __str__(self) -> str:
        return self.display()
    
    def __len__(self) -> int:
        return self.get_size()


# Простой пример использования
if __name__ == "__main__":
    my_list = SingleLinkedList()
    
    my_list.insert_last_node(10)
    my_list.insert_last_node(20)
    my_list.insert_first_node(5)
    my_list.insert_last_node(30)
    
    print(my_list)
    print(f"Размер списка: {len(my_list)}")
```

    5 -> 10 -> 20 -> 30
    Размер списка: 4


    #### Вариант 2


```python
from typing import TypeVar, Generic, Optional

ValueType = TypeVar('ValueType')

class ListNode(Generic[ValueType]):
    def __init__(self, value: ValueType):
        self.value: ValueType = value
        self.next: Optional[ListNode[ValueType]] = None

class SingleLinkedListV1(Generic[ValueType]):
    def __init__(self) -> None:
        self._head: Optional[ListNode[ValueType]] = None
        self._tail: Optional[ListNode[ValueType]] = None
        self._size: int = 0
    
    def insert_first_node(self, value: ValueType) -> None:
        new_node = ListNode(value)
        if self._head is None:
            self._head = new_node
            self._tail = new_node
        else:
            new_node.next = self._head
            self._head = new_node
        self._size += 1
    
    def remove_first_node(self) -> ValueType:
        if self._head is None:
            raise IndexError("Cannot remove from empty list")
        removed_value = self._head.value
        if self._head == self._tail:
            self._head = None
            self._tail = None
        else:
            self._head = self._head.next
        self._size -= 1
        return removed_value
    
    def insert_last_node(self, value: ValueType) -> None:
        new_node = ListNode(value)
        if self._tail is None:
            self._head = new_node
            self._tail = new_node
        else:
            self._tail.next = new_node
            self._tail = new_node
        self._size += 1
    
    def remove_last_node(self) -> ValueType:
        if self._tail is None:
            raise IndexError("Cannot remove from empty list")
        removed_value = self._tail.value
        if self._head == self._tail:
            self._head = None
            self._tail = None
        else:
            current = self._head
            while current and current.next != self._tail:
                current = current.next
            if current:
                current.next = None
                self._tail = current
        self._size -= 1
        return removed_value
    
    def is_empty(self) -> bool:
        return self._head is None
    
    def display(self) -> str:
        elements = []
        current = self._head
        while current:
            elements.append(str(current.value))
            current = current.next
        return " -> ".join(elements) if elements else "Empty list"
    
    def __str__(self) -> str:
        return self.display()

class SingleLinkedListV2(SingleLinkedListV1[ValueType]):
    def get_size(self) -> int:
        count = 0
        current = self._head
        while current:
            count += 1
            current = current.next
        return count
    
    def find_node(self, value: ValueType) -> ValueType:
        current = self._head
        while current:
            if current.value == value:
                return current.value
            current = current.next
        raise ValueError(f"Value {value} not found in the list")
    
    def replace_node(self, old_value: ValueType, new_value: ValueType) -> None:
        current = self._head
        while current:
            if current.value == old_value:
                current.value = new_value
                return
            current = current.next
        raise ValueError(f"Value {old_value} not found in the list")
    
    def remove_node(self, value: ValueType) -> ValueType:
        if self._head is None:
            raise ValueError("Cannot remove from empty list")
        if self._head.value == value:
            return self.remove_first_node()
        previous = self._head
        current = self._head.next
        while current:
            if current.value == value:
                removed_value = current.value
                previous.next = current.next
                if current == self._tail:
                    self._tail = previous
                self._size -= 1
                return removed_value
            previous = current
            current = current.next
        raise ValueError(f"Value {value} not found in the list")
    
    def get_first_value(self) -> Optional[ValueType]:
        return self._head.value if self._head else None
    
    def get_last_value(self) -> Optional[ValueType]:
        return self._tail.value if self._tail else None


my_list = SingleLinkedListV2()
my_list.insert_last_node(10)
my_list.insert_last_node(20)
my_list.insert_first_node(5)
my_list.insert_last_node(30)

print(my_list)
```

    5 -> 10 -> 20 -> 30


    #### Вариант 3


```python
from typing import TypeVar, Generic, Optional

ValueType = TypeVar('ValueType')

class ListNode(Generic[ValueType]):
    def __init__(self, value: ValueType):
        self.value: ValueType = value
        self.next: Optional[ListNode[ValueType]] = None

class SingleLinkedListV1(Generic[ValueType]):
    def __init__(self) -> None:
        self._head: Optional[ListNode[ValueType]] = None
        self._tail: Optional[ListNode[ValueType]] = None
        self._size: int = 0
    
    def insert_first_node(self, value: ValueType) -> None:
        new_node = ListNode(value)
        if self._head is None:
            self._head = new_node
            self._tail = new_node
        else:
            new_node.next = self._head
            self._head = new_node
        self._size += 1
    
    def remove_first_node(self) -> ValueType:
        if self._head is None:
            raise IndexError("Cannot remove from empty list")
        removed_value = self._head.value
        if self._head == self._tail:
            self._head = None
            self._tail = None
        else:
            self._head = self._head.next
        self._size -= 1
        return removed_value
    
    def insert_last_node(self, value: ValueType) -> None:
        new_node = ListNode(value)
        if self._tail is None:
            self._head = new_node
            self._tail = new_node
        else:
            self._tail.next = new_node
            self._tail = new_node
        self._size += 1
    
    def remove_last_node(self) -> ValueType:
        if self._tail is None:
            raise IndexError("Cannot remove from empty list")
        removed_value = self._tail.value
        if self._head == self._tail:
            self._head = None
            self._tail = None
        else:
            current = self._head
            while current and current.next != self._tail:
                current = current.next
            if current:
                current.next = None
                self._tail = current
        self._size -= 1
        return removed_value
    
    def is_empty(self) -> bool:
        return self._head is None
    
    def display(self) -> str:
        elements = []
        current = self._head
        while current:
            elements.append(str(current.value))
            current = current.next
        return " -> ".join(elements) if elements else "Empty list"
    
    def __str__(self) -> str:
        return self.display()

class SingleLinkedListV2(SingleLinkedListV1[ValueType]):
    def get_size(self) -> int:
        count = 0
        current = self._head
        while current:
            count += 1
            current = current.next
        return count
    
    def find_node(self, value: ValueType) -> ValueType:
        current = self._head
        while current:
            if current.value == value:
                return current.value
            current = current.next
        raise ValueError(f"Value {value} not found in the list")
    
    def replace_node(self, old_value: ValueType, new_value: ValueType) -> None:
        current = self._head
        while current:
            if current.value == old_value:
                current.value = new_value
                return
            current = current.next
        raise ValueError(f"Value {old_value} not found in the list")
    
    def remove_node(self, value: ValueType) -> ValueType:
        if self._head is None:
            raise ValueError("Cannot remove from empty list")
        if self._head.value == value:
            return self.remove_first_node()
        previous = self._head
        current = self._head.next
        while current:
            if current.value == value:
                removed_value = current.value
                previous.next = current.next
                if current == self._tail:
                    self._tail = previous
                self._size -= 1
                return removed_value
            previous = current
            current = current.next
        raise ValueError(f"Value {value} not found in the list")

class SingleLinkedListV3(SingleLinkedListV2[ValueType]):
    def get_size(self) -> int:
        return self._size
    
    def clear(self) -> None:
        self._head = None
        self._tail = None
        self._size = 0
    
    def get_size_details(self) -> dict:
        return {
            'constant_time_size': self.get_size(),
            'internal_size_counter': self._size,
            'manual_count': self._manual_count_size()
        }
    
    def _manual_count_size(self) -> int:
        count = 0
        current = self._head
        while current:
            count += 1
            current = current.next
        return count


my_list = SingleLinkedListV3()
my_list.insert_last_node(10)
my_list.insert_last_node(20)
my_list.insert_first_node(5)
my_list.insert_last_node(30)

print(my_list)
print(f"Размер списка: {my_list.get_size()}")
print(f"Детали размера: {my_list.get_size_details()}")
```

    5 -> 10 -> 20 -> 30
    Размер списка: 4
    Детали размера: {'constant_time_size': 4, 'internal_size_counter': 4, 'manual_count': 4}


    #### Вариант 4


```python
from typing import TypeVar, Generic, Optional

ValueType = TypeVar('ValueType')

class ListNode(Generic[ValueType]):
    def __init__(self, value: ValueType):
        self.value: ValueType = value
        self.next: Optional[ListNode[ValueType]] = None

class SingleLinkedListV1(Generic[ValueType]):
    def __init__(self) -> None:
        self._head: Optional[ListNode[ValueType]] = None
        self._tail: Optional[ListNode[ValueType]] = None
        self._size: int = 0
    
    def insert_first_node(self, value: ValueType) -> None:
        new_node = ListNode(value)
        if self._head is None:
            self._head = new_node
            self._tail = new_node
        else:
            new_node.next = self._head
            self._head = new_node
        self._size += 1
    
    def remove_first_node(self) -> ValueType:
        if self._head is None:
            raise IndexError("Cannot remove from empty list")
        removed_value = self._head.value
        if self._head == self._tail:
            self._head = None
            self._tail = None
        else:
            self._head = self._head.next
        self._size -= 1
        return removed_value
    
    def insert_last_node(self, value: ValueType) -> None:
        new_node = ListNode(value)
        if self._tail is None:
            self._head = new_node
            self._tail = new_node
        else:
            self._tail.next = new_node
            self._tail = new_node
        self._size += 1
    
    def remove_last_node(self) -> ValueType:
        if self._tail is None:
            raise IndexError("Cannot remove from empty list")
        removed_value = self._tail.value
        if self._head == self._tail:
            self._head = None
            self._tail = None
        else:
            current = self._head
            while current and current.next != self._tail:
                current = current.next
            if current:
                current.next = None
                self._tail = current
        self._size -= 1
        return removed_value
    
    def is_empty(self) -> bool:
        return self._head is None
    
    def display(self) -> str:
        elements = []
        current = self._head
        while current:
            elements.append(str(current.value))
            current = current.next
        return " -> ".join(elements) if elements else "Empty list"
    
    def __str__(self) -> str:
        return self.display()

class SingleLinkedListV2(SingleLinkedListV1[ValueType]):
    def get_size(self) -> int:
        count = 0
        current = self._head
        while current:
            count += 1
            current = current.next
        return count
    
    def find_node(self, value: ValueType) -> ValueType:
        current = self._head
        while current:
            if current.value == value:
                return current.value
            current = current.next
        raise ValueError(f"Value {value} not found in the list")
    
    def replace_node(self, old_value: ValueType, new_value: ValueType) -> None:
        current = self._head
        while current:
            if current.value == old_value:
                current.value = new_value
                return
            current = current.next
        raise ValueError(f"Value {old_value} not found in the list")
    
    def remove_node(self, value: ValueType) -> ValueType:
        if self._head is None:
            raise ValueError("Cannot remove from empty list")
        if self._head.value == value:
            return self.remove_first_node()
        previous = self._head
        current = self._head.next
        while current:
            if current.value == value:
                removed_value = current.value
                previous.next = current.next
                if current == self._tail:
                    self._tail = previous
                self._size -= 1
                return removed_value
            previous = current
            current = current.next
        raise ValueError(f"Value {value} not found in the list")

class SingleLinkedListV3(SingleLinkedListV2[ValueType]):
    def get_size(self) -> int:
        return self._size
    
    def clear(self) -> None:
        self._head = None
        self._tail = None
        self._size = 0

class SingleLinkedListV4(SingleLinkedListV3[ValueType]):
    def find_previous_node(self, value: ValueType) -> ValueType:
        if self._head is None or self._head.value == value:
            raise ValueError(f"No previous node for value {value}")
        previous = self._head
        current = self._head.next
        while current:
            if current.value == value:
                return previous.value
            previous = current
            current = current.next
        raise ValueError(f"Value {value} not found in the list")
    
    def find_next_node(self, value: ValueType) -> ValueType:
        current = self._head
        while current:
            if current.value == value:
                if current.next is None:
                    raise ValueError(f"No next node for value {value}")
                return current.next.value
            current = current.next
        raise ValueError(f"Value {value} not found in the list")
    
    def insert_before_node(self, target_value: ValueType, new_value: ValueType) -> None:
        if self._head is None:
            return
        if self._head.value == target_value:
            self.insert_first_node(new_value)
            return
        previous = self._head
        current = self._head.next
        while current:
            if current.value == target_value:
                new_node = ListNode(new_value)
                new_node.next = current
                previous.next = new_node
                self._size += 1
                return
            previous = current
            current = current.next
    
    def insert_after_node(self, target_value: ValueType, new_value: ValueType) -> None:
        current = self._head
        while current:
            if current.value == target_value:
                new_node = ListNode(new_value)
                new_node.next = current.next
                current.next = new_node
                if current == self._tail:
                    self._tail = new_node
                self._size += 1
                return
            current = current.next


my_list = SingleLinkedListV4()
my_list.insert_last_node(10)
my_list.insert_last_node(20)
my_list.insert_last_node(30)

print("Исходный список:")
print(my_list)

my_list.insert_after_node(20, 25)
print("После вставки 25 после 20:")
print(my_list)

my_list.insert_before_node(20, 15)
print("После вставки 15 перед 20:")
print(my_list)

print(f"Предыдущий узел для 20: {my_list.find_previous_node(20)}")
print(f"Следующий узел для 20: {my_list.find_next_node(20)}")
```

    Исходный список:
    10 -> 20 -> 30
    После вставки 25 после 20:
    10 -> 20 -> 25 -> 30
    После вставки 15 перед 20:
    10 -> 15 -> 20 -> 25 -> 30
    Предыдущий узел для 20: 15
    Следующий узел для 20: 25


    #### Вариант 5


```python
from typing import TypeVar, Generic, Optional

ValueType = TypeVar('ValueType')

class ListNode(Generic[ValueType]):
    def __init__(self, value: ValueType):
        self.value: ValueType = value
        self.next: Optional[ListNode[ValueType]] = None

class SingleLinkedListV1(Generic[ValueType]):
    def __init__(self) -> None:
        self._head: Optional[ListNode[ValueType]] = None
        self._tail: Optional[ListNode[ValueType]] = None
        self._size: int = 0
    
    def insert_first_node(self, value: ValueType) -> None:
        new_node = ListNode(value)
        if self._head is None:
            self._head = new_node
            self._tail = new_node
        else:
            new_node.next = self._head
            self._head = new_node
        self._size += 1
    
    def remove_first_node(self) -> ValueType:
        if self._head is None:
            raise IndexError("Cannot remove from empty list")
        removed_value = self._head.value
        if self._head == self._tail:
            self._head = None
            self._tail = None
        else:
            self._head = self._head.next
        self._size -= 1
        return removed_value
    
    def insert_last_node(self, value: ValueType) -> None:
        new_node = ListNode(value)
        if self._tail is None:
            self._head = new_node
            self._tail = new_node
        else:
            self._tail.next = new_node
            self._tail = new_node
        self._size += 1
    
    def remove_last_node(self) -> ValueType:
        if self._tail is None:
            raise IndexError("Cannot remove from empty list")
        removed_value = self._tail.value
        if self._head == self._tail:
            self._head = None
            self._tail = None
        else:
            current = self._head
            while current and current.next != self._tail:
                current = current.next
            if current:
                current.next = None
                self._tail = current
        self._size -= 1
        return removed_value
    
    def is_empty(self) -> bool:
        return self._head is None
    
    def display(self) -> str:
        elements = []
        current = self._head
        while current:
            elements.append(str(current.value))
            current = current.next
        return " -> ".join(elements) if elements else "Empty list"
    
    def __str__(self) -> str:
        return self.display()

class SingleLinkedListV2(SingleLinkedListV1[ValueType]):
    def get_size(self) -> int:
        count = 0
        current = self._head
        while current:
            count += 1
            current = current.next
        return count
    
    def find_node(self, value: ValueType) -> ValueType:
        current = self._head
        while current:
            if current.value == value:
                return current.value
            current = current.next
        raise ValueError(f"Value {value} not found in the list")
    
    def replace_node(self, old_value: ValueType, new_value: ValueType) -> None:
        current = self._head
        while current:
            if current.value == old_value:
                current.value = new_value
                return
            current = current.next
        raise ValueError(f"Value {old_value} not found in the list")
    
    def remove_node(self, value: ValueType) -> ValueType:
        if self._head is None:
            raise ValueError("Cannot remove from empty list")
        if self._head.value == value:
            return self.remove_first_node()
        previous = self._head
        current = self._head.next
        while current:
            if current.value == value:
                removed_value = current.value
                previous.next = current.next
                if current == self._tail:
                    self._tail = previous
                self._size -= 1
                return removed_value
            previous = current
            current = current.next
        raise ValueError(f"Value {value} not found in the list")

class SingleLinkedListV3(SingleLinkedListV2[ValueType]):
    def get_size(self) -> int:
        return self._size
    
    def clear(self) -> None:
        self._head = None
        self._tail = None
        self._size = 0

class SingleLinkedListV4(SingleLinkedListV3[ValueType]):
    def find_previous_node(self, value: ValueType) -> ValueType:
        if self._head is None or self._head.value == value:
            raise ValueError(f"No previous node for value {value}")
        previous = self._head
        current = self._head.next
        while current:
            if current.value == value:
                return previous.value
            previous = current
            current = current.next
        raise ValueError(f"Value {value} not found in the list")
    
    def find_next_node(self, value: ValueType) -> ValueType:
        current = self._head
        while current:
            if current.value == value:
                if current.next is None:
                    raise ValueError(f"No next node for value {value}")
                return current.next.value
            current = current.next
        raise ValueError(f"Value {value} not found in the list")
    
    def insert_before_node(self, target_value: ValueType, new_value: ValueType) -> None:
        if self._head is None:
            return
        if self._head.value == target_value:
            self.insert_first_node(new_value)
            return
        previous = self._head
        current = self._head.next
        while current:
            if current.value == target_value:
                new_node = ListNode(new_value)
                new_node.next = current
                previous.next = new_node
                self._size += 1
                return
            previous = current
            current = current.next
    
    def insert_after_node(self, target_value: ValueType, new_value: ValueType) -> None:
        current = self._head
        while current:
            if current.value == target_value:
                new_node = ListNode(new_value)
                new_node.next = current.next
                current.next = new_node
                if current == self._tail:
                    self._tail = new_node
                self._size += 1
                return
            current = current.next

class SingleLinkedListV5(SingleLinkedListV4[ValueType]):
    def find_node(self, value: ValueType) -> ValueType:
        if self._head is None:
            raise ValueError(f"Value {value} not found in empty list")
        if self._head.value == value:
            return self._head.value
        if self._tail and self._tail.value == value:
            return self._tail.value
        current = self._head.next
        while current and current != self._tail:
            if current.value == value:
                return current.value
            current = current.next
        raise ValueError(f"Value {value} not found in the list")
    
    def replace_node(self, old_value: ValueType, new_value: ValueType) -> None:
        if self._head is None:
            raise ValueError(f"Value {old_value} not found in empty list")
        if self._head.value == old_value:
            self._head.value = new_value
            return
        if self._tail and self._tail.value == old_value:
            self._tail.value = new_value
            return
        current = self._head.next
        while current and current != self._tail:
            if current.value == old_value:
                current.value = new_value
                return
            current = current.next
        raise ValueError(f"Value {old_value} not found in the list")
    
    def remove_node(self, value: ValueType) -> ValueType:
        if self._head is None:
            raise ValueError("Cannot remove from empty list")
        if self._head.value == value:
            return self.remove_first_node()
        if self._tail and self._tail.value == value:
            return self.remove_last_node()
        previous = self._head
        current = self._head.next
        while current and current != self._tail:
            if current.value == value:
                removed_value = current.value
                previous.next = current.next
                self._size -= 1
                return removed_value
            previous = current
            current = current.next
        raise ValueError(f"Value {value} not found in the list")
    
    def insert_after_node(self, target_value: ValueType, new_value: ValueType) -> None:
        if self._tail and self._tail.value == target_value:
            self.insert_last_node(new_value)
            return
        super().insert_after_node(target_value, new_value)
    
    def get_tail_value(self) -> Optional[ValueType]:
        return self._tail.value if self._tail else None
    
    def get_head_value(self) -> Optional[ValueType]:
        return self._head.value if self._head else None


my_list = SingleLinkedListV5()
my_list.insert_last_node(10)
my_list.insert_last_node(20)
my_list.insert_last_node(30)

print("Исходный список:")
print(my_list)

print(f"Поиск головы: {my_list.get_head_value()}")
print(f"Поиск хвоста: {my_list.get_tail_value()}")

my_list.replace_node(30, 35)
print("После замены хвоста 30 на 35:")
print(my_list)

my_list.insert_after_node(35, 40)
print("После вставки 40 после хвоста:")
print(my_list)
```

    Исходный список:
    10 -> 20 -> 30
    Поиск головы: 10
    Поиск хвоста: 30
    После замены хвоста 30 на 35:
    10 -> 20 -> 35
    После вставки 40 после хвоста:
    10 -> 20 -> 35 -> 40


    #### Вариант 6


```python
from typing import TypeVar, Generic, Optional

ValueType = TypeVar('ValueType')

class ListNode(Generic[ValueType]):
    def __init__(self, value: ValueType):
        self.value: ValueType = value
        self.next: Optional[ListNode[ValueType]] = None

class SingleLinkedListV1(Generic[ValueType]):
    def __init__(self) -> None:
        self._head: Optional[ListNode[ValueType]] = None
        self._tail: Optional[ListNode[ValueType]] = None
        self._size: int = 0
    
    def insert_first_node(self, value: ValueType) -> None:
        new_node = ListNode(value)
        if self._head is None:
            self._head = new_node
            self._tail = new_node
        else:
            new_node.next = self._head
            self._head = new_node
        self._size += 1
    
    def remove_first_node(self) -> ValueType:
        if self._head is None:
            raise IndexError("Cannot remove from empty list")
        removed_value = self._head.value
        if self._head == self._tail:
            self._head = None
            self._tail = None
        else:
            self._head = self._head.next
        self._size -= 1
        return removed_value
    
    def insert_last_node(self, value: ValueType) -> None:
        new_node = ListNode(value)
        if self._tail is None:
            self._head = new_node
            self._tail = new_node
        else:
            self._tail.next = new_node
            self._tail = new_node
        self._size += 1
    
    def remove_last_node(self) -> ValueType:
        if self._tail is None:
            raise IndexError("Cannot remove from empty list")
        removed_value = self._tail.value
        if self._head == self._tail:
            self._head = None
            self._tail = None
        else:
            current = self._head
            while current and current.next != self._tail:
                current = current.next
            if current:
                current.next = None
                self._tail = current
        self._size -= 1
        return removed_value
    
    def is_empty(self) -> bool:
        return self._head is None
    
    def display(self) -> str:
        elements = []
        current = self._head
        while current:
            elements.append(str(current.value))
            current = current.next
        return " -> ".join(elements) if elements else "Empty list"
    
    def __str__(self) -> str:
        return self.display()

class SingleLinkedListV2(SingleLinkedListV1[ValueType]):
    def get_size(self) -> int:
        count = 0
        current = self._head
        while current:
            count += 1
            current = current.next
        return count
    
    def find_node(self, value: ValueType) -> ValueType:
        current = self._head
        while current:
            if current.value == value:
                return current.value
            current = current.next
        raise ValueError(f"Value {value} not found in the list")
    
    def replace_node(self, old_value: ValueType, new_value: ValueType) -> None:
        current = self._head
        while current:
            if current.value == old_value:
                current.value = new_value
                return
            current = current.next
        raise ValueError(f"Value {old_value} not found in the list")
    
    def remove_node(self, value: ValueType) -> ValueType:
        if self._head is None:
            raise ValueError("Cannot remove from empty list")
        if self._head.value == value:
            return self.remove_first_node()
        previous = self._head
        current = self._head.next
        while current:
            if current.value == value:
                removed_value = current.value
                previous.next = current.next
                if current == self._tail:
                    self._tail = previous
                self._size -= 1
                return removed_value
            previous = current
            current = current.next
        raise ValueError(f"Value {value} not found in the list")

class SingleLinkedListV3(SingleLinkedListV2[ValueType]):
    def get_size(self) -> int:
        return self._size
    
    def clear(self) -> None:
        self._head = None
        self._tail = None
        self._size = 0

class SingleLinkedListV4(SingleLinkedListV3[ValueType]):
    def find_previous_node(self, value: ValueType) -> ValueType:
        if self._head is None or self._head.value == value:
            raise ValueError(f"No previous node for value {value}")
        previous = self._head
        current = self._head.next
        while current:
            if current.value == value:
                return previous.value
            previous = current
            current = current.next
        raise ValueError(f"Value {value} not found in the list")
    
    def find_next_node(self, value: ValueType) -> ValueType:
        current = self._head
        while current:
            if current.value == value:
                if current.next is None:
                    raise ValueError(f"No next node for value {value}")
                return current.next.value
            current = current.next
        raise ValueError(f"Value {value} not found in the list")
    
    def insert_before_node(self, target_value: ValueType, new_value: ValueType) -> None:
        if self._head is None:
            return
        if self._head.value == target_value:
            self.insert_first_node(new_value)
            return
        previous = self._head
        current = self._head.next
        while current:
            if current.value == target_value:
                new_node = ListNode(new_value)
                new_node.next = current
                previous.next = new_node
                self._size += 1
                return
            previous = current
            current = current.next
    
    def insert_after_node(self, target_value: ValueType, new_value: ValueType) -> None:
        current = self._head
        while current:
            if current.value == target_value:
                new_node = ListNode(new_value)
                new_node.next = current.next
                current.next = new_node
                if current == self._tail:
                    self._tail = new_node
                self._size += 1
                return
            current = current.next

class SingleLinkedListV5(SingleLinkedListV4[ValueType]):
    def find_node(self, value: ValueType) -> ValueType:
        if self._head is None:
            raise ValueError(f"Value {value} not found in empty list")
        if self._head.value == value:
            return self._head.value
        if self._tail and self._tail.value == value:
            return self._tail.value
        current = self._head.next
        while current and current != self._tail:
            if current.value == value:
                return current.value
            current = current.next
        raise ValueError(f"Value {value} not found in the list")
    
    def replace_node(self, old_value: ValueType, new_value: ValueType) -> None:
        if self._head is None:
            raise ValueError(f"Value {old_value} not found in empty list")
        if self._head.value == old_value:
            self._head.value = new_value
            return
        if self._tail and self._tail.value == old_value:
            self._tail.value = new_value
            return
        current = self._head.next
        while current and current != self._tail:
            if current.value == old_value:
                current.value = new_value
                return
            current = current.next
        raise ValueError(f"Value {old_value} not found in the list")
    
    def remove_node(self, value: ValueType) -> ValueType:
        if self._head is None:
            raise ValueError("Cannot remove from empty list")
        if self._head.value == value:
            return self.remove_first_node()
        if self._tail and self._tail.value == value:
            return self.remove_last_node()
        previous = self._head
        current = self._head.next
        while current and current != self._tail:
            if current.value == value:
                removed_value = current.value
                previous.next = current.next
                self._size -= 1
                return removed_value
            previous = current
            current = current.next
        raise ValueError(f"Value {value} not found in the list")
    
    def insert_after_node(self, target_value: ValueType, new_value: ValueType) -> None:
        if self._tail and self._tail.value == target_value:
            self.insert_last_node(new_value)
            return
        super().insert_after_node(target_value, new_value)
    
    def get_tail_value(self) -> Optional[ValueType]:
        return self._tail.value if self._tail else None
    
    def get_head_value(self) -> Optional[ValueType]:
        return self._head.value if self._head else None

class SingleLinkedListV6(SingleLinkedListV5[ValueType]):
    def insert_before_node(self, target_value: ValueType, new_value: ValueType) -> None:
        if self._head is None:
            return
        if self._head.value == target_value:
            self.insert_first_node(new_value)
            return
        current = self._head
        while current:
            if current.value == target_value:
                new_node = ListNode(current.value)
                new_node.next = current.next
                current.value = new_value
                current.next = new_node
                if current == self._tail:
                    self._tail = new_node
                self._size += 1
                return
            current = current.next
    
    def remove_node(self, value: ValueType) -> ValueType:
        if self._head is None:
            raise ValueError("Cannot remove from empty list")
        if self._head.value == value:
            return self.remove_first_node()
        if self._tail and self._tail.value == value:
            return self.remove_last_node()
        current = self._head
        while current and current.next:
            if current.value == value:
                removed_value = current.value
                current.value = current.next.value
                current.next = current.next.next
                if current.next is None:
                    self._tail = current
                self._size -= 1
                return removed_value
            current = current.next
        raise ValueError(f"Value {value} not found in the list")


my_list = SingleLinkedListV6()
my_list.insert_last_node(10)
my_list.insert_last_node(20)
my_list.insert_last_node(30)

print("Исходный список:")
print(my_list)

my_list.insert_before_node(20, 15)
print("После вставки 15 перед 20 (оптимизированно):")
print(my_list)

my_list.remove_node(15)
print("После удаления 15 (оптимизированно):")
print(my_list)

print(f"Голова: {my_list.get_head_value()}")
print(f"Хвост: {my_list.get_tail_value()}")
```

    Исходный список:
    10 -> 20 -> 30
    После вставки 15 перед 20 (оптимизированно):
    10 -> 15 -> 20 -> 30
    После удаления 15 (оптимизированно):
    10 -> 20 -> 30
    Голова: 10
    Хвост: 30


#### Задание 2


```python
from typing import TypeVar, Generic, Optional

ValueType = TypeVar('ValueType')

class ListNode(Generic[ValueType]):
    def __init__(self, value: ValueType):
        self.value: ValueType = value
        self.next: Optional[ListNode[ValueType]] = None

class SingleLinkedList(Generic[ValueType]):
    def __init__(self) -> None:
        self._head: Optional[ListNode[ValueType]] = None
        self._tail: Optional[ListNode[ValueType]] = None
        self._size: int = 0
    
    def insert_first_node(self, value: ValueType) -> None:
        new_node = ListNode(value)
        if self._head is None:
            self._head = new_node
            self._tail = new_node
        else:
            new_node.next = self._head
            self._head = new_node
        self._size += 1
    
    def remove_first_node(self) -> ValueType:
        if self._head is None:
            raise IndexError("Cannot remove from empty list")
        removed_value = self._head.value
        if self._head == self._tail:
            self._head = None
            self._tail = None
        else:
            self._head = self._head.next
        self._size -= 1
        return removed_value
    
    def insert_last_node(self, value: ValueType) -> None:
        new_node = ListNode(value)
        if self._tail is None:
            self._head = new_node
            self._tail = new_node
        else:
            self._tail.next = new_node
            self._tail = new_node
        self._size += 1
    
    def remove_last_node(self) -> ValueType:
        if self._tail is None:
            raise IndexError("Cannot remove from empty list")
        removed_value = self._tail.value
        if self._head == self._tail:
            self._head = None
            self._tail = None
        else:
            current = self._head
            while current and current.next != self._tail:
                current = current.next
            if current:
                current.next = None
                self._tail = current
        self._size -= 1
        return removed_value
    
    def is_empty(self) -> bool:
        return self._head is None
    
    def get_size(self) -> int:
        return self._size
    
    def display(self) -> str:
        elements = []
        current = self._head
        while current:
            elements.append(str(current.value))
            current = current.next
        return " -> ".join(elements) if elements else "Empty list"
    
    def __str__(self) -> str:
        return self.display()
    
    def __len__(self) -> int:
        return self.get_size()
    
    def reverse(self) -> None:
        if self._head is None or self._head == self._tail:
            return
        
        previous = None
        current = self._head
        next_node = None
        
        old_tail = self._tail
        self._tail = self._head
        
        while current is not None:
            next_node = current.next
            current.next = previous
            previous = current
            current = next_node
        
        self._head = previous
        self._tail = old_tail


my_list = SingleLinkedList()
my_list.insert_last_node(1)
my_list.insert_last_node(2)
my_list.insert_last_node(3)
my_list.insert_last_node(4)
my_list.insert_last_node(5)

print("Исходный список:")
print(my_list)

my_list.reverse()

print("После переворота:")
print(my_list)

print(f"Размер: {len(my_list)}")
print(f"Первый элемент: {my_list._head.value}")
print(f"Последний элемент: {my_list._tail.value}")
```

    Исходный список:
    1 -> 2 -> 3 -> 4 -> 5
    После переворота:
    5 -> 4 -> 3 -> 2 -> 1
    Размер: 5
    Первый элемент: 5
    Последний элемент: 5


#### Задание 3


```python
from typing import TypeVar, Generic, Optional

ValueType = TypeVar('ValueType')

class ListNode(Generic[ValueType]):
    def __init__(self, value: ValueType):
        self.value: ValueType = value
        self.next: Optional[ListNode[ValueType]] = None

class SingleLinkedList(Generic[ValueType]):
    def __init__(self) -> None:
        self._head: Optional[ListNode[ValueType]] = None
        self._tail: Optional[ListNode[ValueType]] = None
        self._size: int = 0
    
    def insert_last_node(self, value: ValueType) -> None:
        new_node = ListNode(value)
        if self._tail is None:
            self._head = new_node
            self._tail = new_node
        else:
            self._tail.next = new_node
            self._tail = new_node
        self._size += 1
    
    def display(self) -> str:
        elements = []
        current = self._head
        while current:
            elements.append(str(current.value))
            current = current.next
        return " -> ".join(elements) if elements else "Empty list"
    
    def __str__(self) -> str:
        return self.display()
    
    def sort(self) -> None:
        if self._head is None or self._head == self._tail:
            return
        
        self._head = self._merge_sort(self._head)
        self._update_tail()
    
    def _merge_sort(self, head: Optional[ListNode[ValueType]]) -> Optional[ListNode[ValueType]]:
        if head is None or head.next is None:
            return head
        
        middle = self._get_middle(head)
        next_to_middle = middle.next
        middle.next = None
        
        left = self._merge_sort(head)
        right = self._merge_sort(next_to_middle)
        
        return self._merge(left, right)
    
    def _get_middle(self, head: ListNode[ValueType]) -> ListNode[ValueType]:
        slow = head
        fast = head
        while fast.next is not None and fast.next.next is not None:
            slow = slow.next
            fast = fast.next.next
        return slow
    
    def _merge(self, left: Optional[ListNode[ValueType]], right: Optional[ListNode[ValueType]]) -> Optional[ListNode[ValueType]]:
        dummy = ListNode(None)
        current = dummy
        
        while left is not None and right is not None:
            if left.value <= right.value:
                current.next = left
                left = left.next
            else:
                current.next = right
                right = right.next
            current = current.next
        
        if left is not None:
            current.next = left
        elif right is not None:
            current.next = right
        
        return dummy.next
    
    def _update_tail(self) -> None:
        if self._head is None:
            self._tail = None
            return
        current = self._head
        while current.next is not None:
            current = current.next
        self._tail = current


my_list = SingleLinkedList()
my_list.insert_last_node(5)
my_list.insert_last_node(2)
my_list.insert_last_node(8)
my_list.insert_last_node(1)
my_list.insert_last_node(9)

print("Исходный список:")
print(my_list)

my_list.sort()

print("После сортировки:")
print(my_list)
```

    Исходный список:
    5 -> 2 -> 8 -> 1 -> 9
    После сортировки:
    1 -> 2 -> 5 -> 8 -> 9


#### Задание 4.3


```python
from typing import TypeVar, Generic, Optional

ValueType = TypeVar('ValueType')

class ListNode(Generic[ValueType]):
    def __init__(self, value: ValueType):
        self.value: ValueType = value
        self.next: Optional[ListNode[ValueType]] = None

class SingleLinkedList(Generic[ValueType]):
    def __init__(self) -> None:
        self._head: Optional[ListNode[ValueType]] = None
        self._tail: Optional[ListNode[ValueType]] = None
        self._size: int = 0
    
    def insert_last_node(self, value: ValueType) -> None:
        new_node = ListNode(value)
        if self._tail is None:
            self._head = new_node
            self._tail = new_node
        else:
            self._tail.next = new_node
            self._tail = new_node
        self._size += 1
    
    def contains(self, value: ValueType) -> bool:
        current = self._head
        while current:
            if current.value == value:
                return True
            current = current.next
        return False
    
    def insert_unique(self, value: ValueType) -> bool:
        if self.contains(value):
            return False
        self.insert_last_node(value)
        return True
    
    def display(self) -> str:
        elements = []
        current = self._head
        while current:
            elements.append(str(current.value))
            current = current.next
        return " -> ".join(elements) if elements else "Empty list"
    
    def __str__(self) -> str:
        return self.display()
    
    def __len__(self) -> int:
        return self._size


# Ввод чисел через массив
numbers_array = [5, 3, 8, 2, 5, 1, 3, 8, 9, 2]

unique_list = SingleLinkedList()

print("Исходный массив чисел:", numbers_array)
print("\nОбработка:")

for number in numbers_array:
    if unique_list.insert_unique(number):
        print(f"Добавлено: {number}")
    else:
        print(f"Пропущено: {number} (уже есть)")

print(f"\nУникальные числа: {unique_list}")
print(f"Количество: {len(unique_list)}")
```

    Исходный массив чисел: [5, 3, 8, 2, 5, 1, 3, 8, 9, 2]
    
    Обработка:
    Добавлено: 5
    Добавлено: 3
    Добавлено: 8
    Добавлено: 2
    Пропущено: 5 (уже есть)
    Добавлено: 1
    Пропущено: 3 (уже есть)
    Пропущено: 8 (уже есть)
    Добавлено: 9
    Пропущено: 2 (уже есть)
    
    Уникальные числа: 5 -> 3 -> 8 -> 2 -> 1 -> 9
    Количество: 6

