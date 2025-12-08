# Линейные списки
Фомин И.Н.
ИУ10-37
## Задания
### Задание 1
#### Версия 1. Базовый односвязный список с добавлением в конец



```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class SinglyLinkedListV1:
    def __init__(self):
        self.head = None

    def append(self, data):
        new_node = Node(data)
        if not self.head:
            self.head = new_node
            return
        current = self.head
        while current.next:
            current = current.next
        current.next = new_node

    def display(self):
        current = self.head
        while current:
            print(current.data, end=" -> ")
            current = current.next
        print("None")

sll = SinglyLinkedListV1()
sll.append(1)
sll.append(2)
sll.append(3)
sll.display()

```

    1 -> 2 -> 3 -> None


#### Версия 2. Добавление вставки в начало списка


```python
class SinglyLinkedListV2(SinglyLinkedListV1):
    def prepend(self, data):
        new_node = Node(data)
        new_node.next = self.head
        self.head = new_node

sll = SinglyLinkedListV2()
sll.append(2)
sll.prepend(1)
sll.append(3)
sll.display()

```

    1 -> 2 -> 3 -> None


#### Версия 3. Вставка после конкретного узла


```python
class SinglyLinkedListV3(SinglyLinkedListV2):
    def insert_after(self, target, data):
        current = self.head
        while current and current.data != target:
            current = current.next
        if not current:
            print(f"Элемент {target} не найден")
            return
        new_node = Node(data)
        new_node.next = current.next
        current.next = new_node

sll = SinglyLinkedListV3()
sll.append(1)
sll.append(3)
sll.insert_after(1, 2)
sll.display()
```

    1 -> 2 -> 3 -> None


#### Версия 4. Удаление узла по значению


```python
class SinglyLinkedListV4(SinglyLinkedListV3):
    def delete(self, data):
        if not self.head:
            return
        if self.head.data == data:
            self.head = self.head.next
            return
        current = self.head
        while current.next and current.next.data != data:
            current = current.next
        if current.next:
            current.next = current.next.next
        else:
            print(f"Элемент {data} не найден")

sll = SinglyLinkedListV4()
sll.append(1)
sll.append(2)
sll.append(3)
sll.delete(2)
sll.display()
```

    1 -> 3 -> None


#### Версия 5. Поиск узла по значению и получение индекса


```python
class SinglyLinkedListV5(SinglyLinkedListV4):
    def find(self, data):
        current = self.head
        index = 0
        while current:
            if current.data == data:
                return index
            current = current.next
            index += 1
        return -1

sll = SinglyLinkedListV5()
sll.append(1)
sll.append(2)
sll.append(3)
print(sll.find(2))
print(sll.find(4))
```

    1
    -1


#### Версия 6. Доступ по индексу и длина списка


```python
class SinglyLinkedListV6(SinglyLinkedListV5):
    def get(self, index):
        current = self.head
        i = 0
        while current:
            if i == index:
                return current.data
            current = current.next
            i += 1
        raise IndexError("Индекс вне диапазона")

    def length(self):
        count = 0
        current = self.head
        while current:
            count += 1
            current = current.next
        return count

sll = SinglyLinkedListV6()
sll.append(10)
sll.append(20)
sll.append(30)
print(sll.get(1))
print(sll.length())
```

    20
    3


### Задание 2


```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class SinglyLinkedListV1:
    def __init__(self):
        self.head = None

    def append(self, data):
        new_node = Node(data)
        if not self.head:
            self.head = new_node
            return
        current = self.head
        while current.next:
            current = current.next
        current.next = new_node

    def display(self):
        current = self.head
        while current:
            print(current.data, end=" -> ")
            current = current.next
        print("None")
    
    def reverse(self):
        prev = None
        current = self.head
        while current:
            next_node = current.next  # сохраняем ссылку на следующий
            current.next = prev       # меняем направление ссылки
            prev = current            # перемещаем prev на текущий узел
            current = next_node       # переходим к следующему узлу
        self.head = prev

sll = SinglyLinkedListV1()
sll.append(1)
sll.append(2)
sll.append(3)
sll.append(4)

print("Исходный список:")
sll.display()

sll.reverse()
print("После reverse:")
sll.display()
```

    Исходный список:
    1 -> 2 -> 3 -> 4 -> None
    После reverse:
    4 -> 3 -> 2 -> 1 -> None


### Задание 3


```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class SinglyLinkedListV1:
    def __init__(self):
        self.head = None

    def append(self, data):
        new_node = Node(data)
        if not self.head:
            self.head = new_node
            return
        current = self.head
        while current.next:
            current = current.next
        current.next = new_node

    def display(self):
        current = self.head
        while current:
            print(current.data, end=" -> ")
            current = current.next
        print("None")

    def reverse(self):
        prev = None
        current = self.head
        while current:
            next_node = current.next
            current.next = prev
            prev = current
            current = next_node
        self.head = prev

    def sort(self):
        if not self.head or not self.head.next:
            return 
        swapped = True
        while swapped:
            swapped = False
            current = self.head
            while current.next:
                if current.data > current.next.data:
                    current.data, current.next.data = current.next.data, current.data
                    swapped = True
                current = current.next


sll = SinglyLinkedListV1()
sll.append(3)
sll.append(1)
sll.append(4)
sll.append(2)

print("Исходный список:")
sll.display()

sll.sort()
print("После сортировки:")
sll.display()

sll.reverse()
print("После reverse:")
sll.display()
```

    Исходный список:
    3 -> 1 -> 4 -> 2 -> None
    После сортировки:
    1 -> 2 -> 3 -> 4 -> None
    После reverse:
    4 -> 3 -> 2 -> 1 -> None


### Задание 4
#### Индивидуальное задание 7 (пересечение списков)


```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class SinglyLinkedListV1:
    def __init__(self):
        self.head = None

    # --- базовые методы ---
    def append(self, data):
        new_node = Node(data)
        if not self.head:
            self.head = new_node
            return
        current = self.head
        while current.next:
            current = current.next
        current.next = new_node

    def display(self):
        current = self.head
        while current:
            print(current.data, end=" -> ")
            current = current.next
        print("None")

    @staticmethod
    def intersection(L1, L2):
        result = SinglyLinkedListV1()
        elements_L2 = set()
        current = L2.head
        while current:
            elements_L2.add(current.data)
            current = current.next
        current = L1.head
        added = set()
        while current:
            if current.data in elements_L2 and current.data not in added:
                result.append(current.data)
                added.add(current.data)
            current = current.next
        return result



L1 = SinglyLinkedListV1()
L2 = SinglyLinkedListV1()

for val in [1, 2, 3, 4, 5]:
    L1.append(val)

for val in [3, 4, 5, 6, 7]:
    L2.append(val)

print("Список L1:")
L1.display()
print("Список L2:")
L2.display()

# Получаем пересечение
L = SinglyLinkedListV1.intersection(L1, L2)
print("Пересечение L1 и L2:")
L.display()
```

    Список L1:
    1 -> 2 -> 3 -> 4 -> 5 -> None
    Список L2:
    3 -> 4 -> 5 -> 6 -> 7 -> None
    Пересечение L1 и L2:
    3 -> 4 -> 5 -> None

