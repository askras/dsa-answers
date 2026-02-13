#Самуйлов С.С Лаб3 
#Линейные списки (Linked list)
#Цель работы
#изучение структуры данных «Линейные списки», а также основных операций над ними.
#Задание 1 


```python
class Node():
    def __init__(self,data):
        self.data =data
        self.next = None
class Linkedlist():
    def __init__(self):
        self.head =None
    def append(self, data):
        new_node = Node(data)
        if not self.head:
            self.head = new_node
            return
        current = self.head
        while current.next:
            current =current.next
        current.next = new_node
    def prepend(self,data):
        new_node = Node(data)
        new_node.next = self.head
        self.head= new_node
    def display (self):
        o = []
        current = self.head
        while current:
            o.append(current.data)
            current = current.next
        return o
i = Linkedlist()
i.append(10)

print(i.display())
```

    [10]



```python
class Node():
    def __init__(self,data):
        self.data =data
        self.next = None
class Linkedwithtail():
    def __init__(self):
        self.head= None
        self.tail =None
    def append(self,data):
        new_node = Node(data)
        if not self.head:
            self.head=new_node
            self.tail =new_node
        else:
            self.tail.next=new_node
            self.tail=new_node
    def prepend(self,data):
        new_node = Node(data)
        if not self.head:
            self.head = new_node
            self.tail = new_node
        else:
            new_node.next = self.head
            self.head = new_node
    def display (self):
        o = []
        current = self.head
        while current:
            o.append(current.data)
            current = current.next
        return o
i = Linkedwithtail()
i.append(10)
i.append(20)
i.prepend(30)

print(i.display())
            
```

    [30, 10, 20]



```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class RecursiveLinkedList:
    def __init__(self):
        self.head = None
    
    def append(self, data):
        new_node = Node(data)
        if not self.head:
            self.head = new_node
        else:
            current = self.head
            while current.next:
                current = current.next
            current.next = new_node
    
    def display(self):
        o = []
        current = self.head
        while current:
            o.append(current.data)
            current = current.next
        return o
    
    def display_recursive(self, node=None):
        if node is None:
            node = self.head
        
        if node is None:
            return []
        
        elements = [node.data]
        if node.next and len(elements) < 950: 
            elements.extend(self.display_recursive(node.next))
        
        return elements

i = RecursiveLinkedList()
i.append(10)
i.append(20)
i.append(30)


print(i.display())

print(i.display_recursive())

for p in range(100):
    i.append(p)

print(len(i.display()))
```

    [10, 20, 30]
    [10, 20, 30]
    103



```python
from typing import TypeVar, Generic, Optional

T = TypeVar('T')

class GenericNode(Generic[T]):
    def __init__(self, data: T):
        self.data: T = data
        self.next: Optional['GenericNode[T]'] = None

class GenericLinkedList(Generic[T]):
    def __init__(self):
        self.head: Optional[GenericNode[T]] = None
    
    def append(self, data: T) -> None:
        new_node = GenericNode(data)
        if not self.head:
            self.head = new_node
            return
        current = self.head
        while current.next:
            current = current.next
        current.next = new_node
    
    def display(self) -> list[T]:
        o = []
        current = self.head
        while current:
            o.append(current.data)
            current = current.next
        return o
i = GenericLinkedList[int]()

i.append(10)
i.append(20)
i.append(30)

print(i.display())
```

    [10, 20, 30]



```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class IterableLinkedList:
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
    
    def __iter__(self):
        current = self.head
        while current:
            yield current.data
            current = current.next
    
    def __contains__(self, data):
        return any(item == data for item in self)
i = IterableLinkedList()


i.append(10)
i.append(20)
i.append(30)

for item in i:
    print(item)
```

    10
    20
    30



```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class FunctionalLinkedList:
    def __init__(self, head=None):
        self.head = head
    
    @staticmethod
    def create(*items):
        if not items:
            return FunctionalLinkedList()
        
        head = Node(items[0])
        current = head
        for item in items[1:]:
            current.next = Node(item)
            current = current.next
        
        return FunctionalLinkedList(head)
    
    def map(self, func):
        if not self.head:
            return FunctionalLinkedList()
        
        new_head = Node(func(self.head.data))
        current_old = self.head.next
        current_new = new_head
        
        while current_old:
            current_new.next = Node(func(current_old.data))
            current_old = current_old.next
            current_new = current_new.next
        
        return FunctionalLinkedList(new_head)
    
    def filter(self, predicate):
        if not self.head:
            return FunctionalLinkedList()
        
        filtered_data = []
        current = self.head
        while current:
            if predicate(current.data):
                filtered_data.append(current.data)
            current = current.next
        
        return FunctionalLinkedList.create(*filtered_data)
    
    def reduce(self, func, initial=None):
        if not self.head:
            return initial
        
        if initial is None:
            result = self.head.data
            current = self.head.next
        else:
            result = initial
            current = self.head
        
        while current:
            result = func(result, current.data)
            current = current.next
        
        return result
    
    def to_list(self):
        result = []
        current = self.head
        while current:
            result.append(current.data)
            current = current.next
        return result
    
    def __repr__(self):
        return f"FunctionalLinkedList({self.to_list()})"
numbers = FunctionalLinkedList.create(1, 2, 3, 4, 5)
print(numbers)  

empty = FunctionalLinkedList.create()
print(empty)   


words = FunctionalLinkedList.create("apple", "banana", "cherry")
print(words)   
```

    FunctionalLinkedList([1, 2, 3, 4, 5])
    FunctionalLinkedList([])
    FunctionalLinkedList(['apple', 'banana', 'cherry'])


#Задание 2


```python
class Node():
    def __init__(self, data):
        self.data = data
        self.next = None

class Linkedlist():
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
    
    def prepend(self, data):
        new_node = Node(data)
        new_node.next = self.head
        self.head = new_node
    
    def reverse(self):
        prev = None
        current = self.head
        
        while current:
            next_node = current.next  
            current.next = prev       
            prev = current            
            current = next_node       
        
        self.head = prev 
    
    def display(self):
        o = []
        current = self.head
        while current:
            o.append(current.data)
            current = current.next
        return o

i = Linkedlist()
i.append(10)
i.append(20)
i.append(30)
i.append(40)

print(i.display()) 

i.reverse()
print(i.display())    
```

    [10, 20, 30, 40]
    [40, 30, 20, 10]


#Задание 3


```python
class Node():
    def __init__(self, data):
        self.data = data
        self.next = None

class Linkedlist():
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
    
    def prepend(self, data):
        new_node = Node(data)
        new_node.next = self.head
        self.head = new_node
    
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
            
            while current and current.next:
                if current.data > current.next.data:
                    current.data, current.next.data = current.next.data, current.data
                    swapped = True
                current = current.next
    
    def display(self):
        o = []
        current = self.head
        while current:
            o.append(current.data)
            current = current.next
        return o
i = Linkedlist()
i.append(40)
i.append(30)
i.append(20)
i.append(50)

print(i.display()) 

i.sort()
print(i.display()) 
```

    [40, 30, 20, 50]
    [20, 30, 40, 50]


#задание 4


```python
class Node():
    def __init__(self, data):
        self.data = data
        self.next = None

class Linkedlist():
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
    
    def prepend(self, data):
        new_node = Node(data)
        new_node.next = self.head
        self.head = new_node
    
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
            
            while current and current.next:
                if current.data > current.next.data:
                    current.data, current.next.data = current.next.data, current.data
                    swapped = True
                current = current.next
    
    def keep_last_occurrences(self):
        if not self.head or not self.head.next:
            return  
        
        last_seen = {}
        current = self.head
        position = 0
        
        while current:
            last_seen[current.data] = position
            current = current.next
            position += 1
        
        self._remove_all_except_last(last_seen)
    
    def _remove_all_except_last(self, last_positions):
        if not self.head:
            return
        
        dummy = Node(None)
        dummy.next = self.head
        prev = dummy
        current = self.head
        position = 0
        
        while current:
            if position == last_positions[current.data]:
                prev = current
                current = current.next
            else:
                prev.next = current.next
                current = current.next
            position += 1
        
        self.head = dummy.next
    
    def display(self):
        o = []
        current = self.head
        while current:
            o.append(current.data)
            current = current.next
        return o


list1 = Linkedlist()
for num in [1, 2, 3, 2, 4, 1, 5, 3]:
    list1.append(num)

print(list1.display()) 
list1.keep_last_occurrences()
print(list1.display()) 

```

    [1, 2, 3, 2, 4, 1, 5, 3]
    [2, 4, 1, 5, 3]



```python

```
