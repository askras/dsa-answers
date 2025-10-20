#### Стек, Очередь, Дек
#### Лавренчук С.А.


```python
# Базовый класс Stack
class Stack:
    def isEmpty(self):
        raise "метод не реализован"
    def push(self, data):
        raise "метод не реализован"
    def pop(self):
        raise "метод не реализован"
    def peek(self):
        raise "метод не реализован"

# Базовый класс Queue
class Queue:
    def __init__(self):
        raise "no method"
    def enqueue(self, data):
        raise "no method"
    def dequeue(self):
        raise "no method"
    def isEmpty(self):
        raise "no method"
    def peek(self):
        raise "no method"

# Базовый класс Deque
class Deque:
    def __init__(self):
        raise "no method"
    def is_empty(self):
        raise "no method"
    def pushfront(self, item):
        raise "no method"
    def pushback(self, item):
        raise "no method"
    def popfront(self):
        raise "no method"
    def popBack(self):
        raise "no method"
    def get_first(self):
        raise "no method"
    def get_last(self):
        raise "no method"

# Узел для связных списков
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None
```


    Для выполнения ячеек с "Python 3.12.3" требуется пакет ipykernel.


    <a href='command:jupyter.createPythonEnvAndSelectController'>Создать среду Python</a> с необходимыми пакетами.


    Или установите "ipykernel" с помощью следующей команды: "/usr/bin/python3 -m pip install ipykernel -U --user --force-reinstall"


    #### Задание 1.1


```python
class StackArray(Stack):
    def __init__(self):
        self.items = []
    
    def isEmpty(self):
        return len(self.items) == 0
    
    def push(self, data):
        self.items.append(data)
    
    def pop(self):
        if self.isEmpty():
            return "empty"
        return self.items.pop()
    
    def peek(self):
        if self.isEmpty():
            return "empty"
        return self.items[-1]
    
    def display(self):
        return self.items
    
    print("1. Стек на массиве:")
s1 = StackArray()
s1.push(1)
s1.push(2)
s1.push(3)
print(f"   push(1,2,3) -> {s1.display()}")
print(f"   pop() = {s1.pop()}")
print(f"   peek() = {s1.peek()}")
print(f"   Текущее состояние: {s1.display()}")
print()
```

    #### Задание 1.2


```python
class StackList(Stack):
    def __init__(self):
        self.top = None
        self.size = 0
    
    def isEmpty(self):
        return self.top is None
    
    def push(self, data):
        new_node = Node(data)
        new_node.next = self.top
        self.top = new_node
        self.size += 1
    
    def pop(self):
        if self.isEmpty():
            return "empty"
        data = self.top.data
        self.top = self.top.next
        self.size -= 1
        return data
    
    def peek(self):
        if self.isEmpty():
            return "empty"
        return self.top.data
    
    def display(self):
        result = []
        current = self.top
        while current:
            result.append(current.data)
            current = current.next
        return result
```

    #### Задание 1.3


```python
class QueueArray(Queue):
    def __init__(self):
        self.items = []
    
    def enqueue(self, data):
        self.items.append(data)
    
    def dequeue(self):
        if self.isEmpty():
            return "empty"
        return self.items.pop(0)
    
    def isEmpty(self):
        return len(self.items) == 0
    
    def peek(self):
        if self.isEmpty():
            return "empty"
        return self.items[0]
    
    def display(self):
        return self.items
```

    #### Задание 1.4


```python
class LinkedListQueue(Queue):
    def __init__(self):
        self.head = None
        self.tail = None
        self.size = 0
    
    def isEmpty(self):
        return self.head is None
    
    def enqueue(self, data):
        new_node = Node(data)
        if self.isEmpty():
            self.head = self.tail = new_node
        else:
            self.tail.next = new_node
            self.tail = new_node
        self.size += 1
    
    def dequeue(self):
        if self.isEmpty():
            return "empty"
        data = self.head.data
        self.head = self.head.next
        if self.head is None:
            self.tail = None
        self.size -= 1
        return data
    
    def peek(self):
        if self.isEmpty():
            return "empty"
        return self.head.data
    
    def display(self):
        elements = []
        current = self.head
        while current:
            elements.append(current.data)
            current = current.next
        return elements
```

    #### Задание 1.5


```python
class SimpleArrayDeque(Deque):
    def __init__(self):
        self.data = []
    
    def is_empty(self):
        return len(self.data) == 0
    
    def pushfront(self, item):
        self.data.insert(0, item)
    
    def pushback(self, item):
        self.data.append(item)
    
    def popfront(self):
        if self.is_empty():
            return "empty"
        return self.data.pop(0)
    
    def popBack(self):
        if self.is_empty():
            return "empty"
        return self.data.pop()
    
    def get_first(self):
        if self.is_empty():
            return "empty"
        return self.data[0]
    
    def get_last(self):
        if self.is_empty():
            return "empty"
        return self.data[-1]
    
    def display(self):
        return self.data
```

    #### Задание 1.6


```python
class LinkedListDeque(Deque):
    def __init__(self):
        self.front = None
        self.rear = None
        self.size = 0
    
    def is_empty(self):
        return self.front is None
    
    def pushfront(self, item):
        new_node = Node(item)
        if self.is_empty():
            self.front = self.rear = new_node
        else:
            new_node.next = self.front
            self.front = new_node
        self.size += 1
    
    def pushback(self, item):
        new_node = Node(item)
        if self.is_empty():
            self.front = self.rear = new_node
        else:
            self.rear.next = new_node
            self.rear = new_node
        self.size += 1
    
    def popfront(self):
        if self.is_empty():
            return "empty"
        data = self.front.data
        self.front = self.front.next
        if self.front is None:
            self.rear = None
        self.size -= 1
        return data
    
    def popBack(self):
        if self.is_empty():
            return "empty"
        if self.front == self.rear:
            data = self.front.data
            self.front = self.rear = None
        else:
            current = self.front
            while current.next != self.rear:
                current = current.next
            data = self.rear.data
            current.next = None
            self.rear = current
        self.size -= 1
        return data
    
    def get_first(self):
        if self.is_empty():
            return "empty"
        return self.front.data
    
    def get_last(self):
        if self.is_empty():
            return "empty"
        return self.rear.data
    
    def display(self):
        result = []
        current = self.front
        while current:
            result.append(current.data)
            current = current.next
        return result
```
