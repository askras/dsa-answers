```python
### Задание 1.
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList:
    def __init__(self):
        self.head = None

    def append(self, data):
        new_node = Node(data)
        if not self.head:
            self.head = new_node
            return
        last = self.head
        while last.next:
            last = last.next
        last.next = new_node

    def print_list(self):
        temp = self.head
        while temp:
            print(temp.data, end=" -> ")
            temp = temp.next
        print("None")
```


```python
### Задание 2
def reverse(self):
    prev = None
    current = self.head
    
    while current:
        next_node = current.next
        current.next = prev
        prev = current
        current = next_node
    
    self.head = prev

LinkedList.reverse = reverse
```


```python
### Задание 3.
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

LinkedList.sort = sort
```


```python
### Задание 4
def duplicate_even_numbers(self):
    current = self.head
    
    while current:
        if current.data % 2 == 0:  
            new_node = Node(current.data)  
            new_node.next = current.next   
            current.next = new_node        
            current = new_node.next        
        else:
            current = current.next        

LinkedList.duplicate_even_numbers = duplicate_even_numbers
```


```python
### Тесты
test_list = LinkedList()

test_list.append(1)
test_list.append(2)
test_list.append(3)
test_list.append(4)
test_list.append(5)

print("Исходный список:")
test_list.print_list()

print("\nПосле дублирования четных чисел:")
test_list.duplicate_even_numbers()
test_list.print_list()

print("\nПосле сортировки:")
test_list.sort()
test_list.print_list()

print("\nПосле реверса:")
test_list.reverse()
test_list.print_list()
```

    Исходный список:
    1 -> 2 -> 3 -> 4 -> 5 -> None
    
    После дублирования четных чисел:
    1 -> 2 -> 2 -> 3 -> 4 -> 4 -> 5 -> None
    
    После сортировки:
    1 -> 2 -> 2 -> 3 -> 4 -> 4 -> 5 -> None
    
    После реверса:
    5 -> 4 -> 4 -> 3 -> 2 -> 2 -> 1 -> None
    
