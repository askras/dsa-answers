# ОТЧЕТ ПО ЛАБОРАТОРНОЙ РАБОТЕ
## «Лабораторная работа №3. Линейные списки (Linked list)»

### Цель работы: изучение структуры данных «Линейные списки», а также основных операций над ними.

### Работу выполнил: Цыганков Д.С 
### **Задания:**

1. Последовательно реализовать 6 версий линейного односвязного списка.
2. Реализовать метод reverse для «переворота» линейного списка.
3. Реализовать метод sort для сортировки линейного списка на месте.
4. Реализовать индивидуальные задание.
5. Опционально: реализовать один из видов циклов, рассмотренных на лекции.

## Решения заданий 

### №1 Последовательно реализовать 6 версий линейного односвязного списка.
## 1.1 Базовый односвязный список 

```python 
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList:
    def __init__(self):
        self.head = None
    
    def append(self, data):
        if not self.head:
            self.head = Node(data)
        else:
            current = self.head
            while current.next:
                current = current.next
            current.next = Node(data)
    
    def display(self):
        elements = []
        current = self.head
        while current:
            elements.append(current.data)
            current = current.next
        return elements

def split_list_1(L):
    L1 = LinkedList()
    L2 = LinkedList()
    current = L.head
    while current:
        if current.data > 0:
            L1.append(current.data)
        elif current.data < 0:
            L2.append(current.data)
        current = current.next
    return L1, L2
```

## 1.2 С хвостовым указателем

```python 
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList:
    def __init__(self):
        self.head = None
        self.tail = None
    
    def append(self, data):
        new_node = Node(data)
        if not self.head:
            self.head = self.tail = new_node
        else:
            self.tail.next = new_node
            self.tail = new_node
    
    def display(self):
        elements = []
        current = self.head
        while current:
            elements.append(current.data)
            current = current.next
        return elements

def split_list_2(L):
    L1 = LinkedList()
    L2 = LinkedList()
    current = L.head
    while current:
        if current.data > 0:
            L1.append(current.data)
        elif current.data < 0:
            L2.append(current.data)
        current = current.next
    return L1, L2
```

## 1.3 С рекурсивными методами

```python 
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList:
    def __init__(self):
        self.head = None
    
    def append(self, data):
        if not self.head:
            self.head = Node(data)
        else:
            self._append_recursive(self.head, data)
    
    def _append_recursive(self, node, data):
        if not node.next:
            node.next = Node(data)
        else:
            self._append_recursive(node.next, data)
    
    def display(self):
        return self._display_recursive(self.head, [])
    
    def _display_recursive(self, node, elements):
        if not node:
            return elements
        elements.append(node.data)
        return self._display_recursive(node.next, elements)

def split_list_3(L):
    L1 = LinkedList()
    L2 = LinkedList()
    
    def _split_recursive(node):
        if not node:
            return
        if node.data > 0:
            L1.append(node.data)
        elif node.data < 0:
            L2.append(node.data)
        _split_recursive(node.next)
    
    _split_recursive(L.head)
    return L1, L2
```

## 1.4 С использованием генераторов

```python 
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList:
    def __init__(self):
        self.head = None
    
    def append(self, data):
        if not self.head:
            self.head = Node(data)
        else:
            current = self.head
            while current.next:
                current = current.next
            current.next = Node(data)
    
    def items(self):
        current = self.head
        while current:
            yield current.data
            current = current.next
    
    def display(self):
        return list(self.items())

def split_list_4(L):
    L1 = LinkedList()
    L2 = LinkedList()
    
    for item in L.items():
        if item > 0:
            L1.append(item)
        elif item < 0:
            L2.append(item)
    
    return L1, L2
```

## 1.5 С методами вставки в начало

```python 
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList:
    def __init__(self):
        self.head = None
    
    def prepend(self, data):
        new_node = Node(data)
        new_node.next = self.head
        self.head = new_node
    
    def display(self):
        elements = []
        current = self.head
        while current:
            elements.append(current.data)
            current = current.next
        return elements

def split_list_5(L):
    L1 = LinkedList()
    L2 = LinkedList()
    current = L.head
    
    while current:
        if current.data > 0:
            L1.prepend(current.data)
        elif current.data < 0:
            L2.prepend(current.data)
        current = current.next
    
    return L1, L2
```

## 1.6 С двусвязным списком

```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None
        self.prev = None

class DoublyLinkedList:
    def __init__(self):
        self.head = None
        self.tail = None
    
    def append(self, data):
        new_node = Node(data)
        if not self.head:
            self.head = self.tail = new_node
        else:
            self.tail.next = new_node
            new_node.prev = self.tail
            self.tail = new_node
    
    def display(self):
        elements = []
        current = self.head
        while current:
            elements.append(current.data)
            current = current.next
        return elements

def split_list_6(L):
    L1 = DoublyLinkedList()
    L2 = DoublyLinkedList()
    current = L.head
    
    while current:
        if current.data > 0:
            L1.append(current.data)
        elif current.data < 0:
            L2.append(current.data)
        current = current.next
    
    return L1, L2
```

### Номер 2 Реализовать метод reverse для «переворота» линейного списка.
```python 
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList:
    def __init__(self):
        self.head = None
    
    def append(self, data):
        if not self.head:
            self.head = Node(data)
        else:
            current = self.head
            while current.next:
                current = current.next
            current.next = Node(data)
    
    def display(self):
        elements = []
        current = self.head
        while current:
            elements.append(current.data)
            current = current.next
        return elements
    
    def reverse(self):
        self.head = self._reverse_recursive(self.head, None)
    
    def _reverse_recursive(self, current, prev):
        if not current:
            return prev
        
        next_node = current.next
        current.next = prev
        return self._reverse_recursive(next_node, current)
```

### Номер 3  Реализовать метод sort для сортировки линейного списка на месте.

```python 
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList:
    def __init__(self):
        self.head = None
    
    def append(self, data):
        if not self.head:
            self.head = Node(data)
        else:
            current = self.head
            while current.next:
                current = current.next
            current.next = Node(data)
    
    def display(self):
        elements = []
        current = self.head
        while current:
            elements.append(current.data)
            current = current.next
        return elements
    
    def sort(self):
        if not self.head or not self.head.next:
            return
        
        swapped = True
        while swapped:
            swapped = False
            current = self.head
            
            while current and current.next:
                if current.data > current.next.data:
                    # Меняем данные местами
                    current.data, current.next.data = current.next.data, current.data
                    swapped = True
                current = current.next
```

### Написать функцию, которая по списку L строит два новых списка: L1 – из положительных элементов и L2 – из отрицательных элементов списка L.

```python 
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList:
    def __init__(self):
        self.head = None
    
    def append(self, data):
        if not self.head:
            self.head = Node(data)
        else:
            current = self.head
            while current.next:
                current = current.next
            current.next = Node(data)
    
    def display(self):
        elements = []
        current = self.head
        while current:
            elements.append(current.data)
            current = current.next
        return elements

def split_positive_negative_1(L):
    L1 = LinkedList()  # Положительные
    L2 = LinkedList()  # Отрицательные
    
    current = L.head
    while current:
        if current.data > 0:
            L1.append(current.data)
        elif current.data < 0:
            L2.append(current.data)
        current = current.next
    
    return L1, L2
```
