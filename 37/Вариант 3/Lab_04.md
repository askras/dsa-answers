#### Стек, Очередь, Дек
#### Лавренчук С.А.
#### Задание 1
    #### Задание 1.1


```python
class stack:
    def isEmpty(self):
        raise "метод не реализован"
    def push(self,data):
        raise "метод не реализован"
    def pop(self):
        raise "метод не реализован"
    def peek(self):
        raise "метод не реализован"
    
class stackarray(stack):
    def __init__(self):
        self.items=[]
    def isEmpty(self):
        return len(self.items) == 0
    def push(self,data):
        self.items.append(data)
    def pop(self):
        if self.isEmpty() :
            return "empty array"
        else:
            return self.items.pop()
    def peek(self):
        if self.isEmpty() :
            return "empty array"
        else:
            return self.items[-1]
    def display(self):
        return self.items
    

print("1. Стек на массиве:")
s1 = stackarray()
s1.push(1); s1.push(2); s1.push(3)
print(f"   push(1,2,3) -> {s1.display()}, pop()={s1.pop()}, peek()={s1.peek()}")
```

    1. Стек на массиве:
       push(1,2,3) -> [1, 2, 3], pop()=3, peek()=2


    #### Задание 1.2


```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class stack:
    def isEmpty(self):
        raise "метод не реализован"
    def push(self,data):
        raise "метод не реализован"
    def pop(self):
        raise "метод не реализован"
    def peek(self):
        raise "метод не реализован"
    
class stacklist(stack):
    def __init__(self):
        self.top = None
        self.size = 0
    
    def isEmpty(self):
        return self.top == None
    
    def push(self,data):
        new_node = Node(data)
        new_node.next = self.top
        self.top = new_node
        self.size += 1
    
    def pop(self):
        if self.isEmpty():
            return "empty"
        else:
            data = self.top.data
            self.top = self.top.next
            self.size -= 1
            return data
    
    def peek(self):
        if self.isEmpty():
            return "empty"
        else:
            return self.top.data
    
    def display(self):
        result = []
        current = self.top
        while current:
            result.append(current.data)
            current = current.next
        return result

print("2. Стек на списке:")
s2 = stacklist()
s2.push(10); s2.push(20); s2.push(30)
print(f"   push(10,20,30) -> {s2.display()}, pop()={s2.pop()}, peek()={s2.peek()}")
```

    2. Стек на списке:
       push(10,20,30) -> [30, 20, 10], pop()=30, peek()=20


    #### Задание 1.3


```python
class queue:
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

class Queuearray(queue):
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

print("3. Очередь на массиве:")
q1 = Queuearray()
q1.enqueue(100); q1.enqueue(200); q1.enqueue(300)
print(f"   enqueue(100,200,300) -> {q1.display()}, dequeue()={q1.dequeue()}, peek()={q1.peek()}")
```

    3. Очередь на массиве:
       enqueue(100,200,300) -> [100, 200, 300], dequeue()=100, peek()=200


    #### Задание 1.4


```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedListQueue:
    def __init__(self):
        self.head = None  
        self.tail = None  
        self.size = 0    
    
    def isEmpty(self):
        return self.head is None
    
    def enqueue(self, data):
        new_node = Node(data)
        if self.isEmpty():
            self.head = new_node
            self.tail = new_node
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

print("4. Очередь на списке:")
q2 = LinkedListQueue()
q2.enqueue(1000); q2.enqueue(2000); q2.enqueue(3000)
print(f"   enqueue(1000,2000,3000) -> {q2.display()}, dequeue()={q2.dequeue()}, peek()={q2.peek()}")
```

    4. Очередь на списке:
       enqueue(1000,2000,3000) -> [1000, 2000, 3000], dequeue()=1000, peek()=2000


    #### Задание 1.5


```python
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
    
    def __len__(self):
        raise "no method"
    
    def __str__(self):
        raise "no method"
    
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
            raise IndexError("Empty")
        return self.data.pop(0)
    def popBack(self):
        if self.is_empty():
            raise IndexError("Empty")
        return self.data.pop()
    def get_first(self):
        if self.is_empty():
            raise IndexError("Empty")
        return self.data[0]
    def get_last(self):
        if self.is_empty():
            raise IndexError("Empty")
        return self.data[-1]
    
print("5. Дек на массиве:")
d1 = SimpleArrayDeque()
d1.pushfront(9); d1.pushback(8); d1.pushfront(7)
print(f"   pushfront(9), pushback(8), pushfront(7) -> {d1.data}, popfront()={d1.popfront()}, popBack()={d1.popBack()}")
```

    5. Дек на массиве:
       pushfront(9), pushback(8), pushfront(7) -> [7, 9, 8], popfront()=7, popBack()=8


    #### Задание 1.6


```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None
        self.prev = None

class LinkedListDeque(Deque):
    def __init__(self):
        self.front = self.rear = None
        self.size = 0
    
    def is_empty(self):
        return self.front is None
    
    def pushfront(self, item):
        new_node = Node(item)
        if self.is_empty():
            self.front = self.rear = new_node
        else:
            new_node.next = self.front
            self.front.prev = new_node
            self.front = new_node
        self.size += 1
    
    def pushback(self, item):
        new_node = Node(item)
        if self.is_empty():
            self.front = self.rear = new_node
        else:
            self.rear.next = new_node
            new_node.prev = self.rear
            self.rear = new_node
        self.size += 1
    
    def popfront(self):
        if self.is_empty():
            return "empty"
        data = self.front.data
        self.front = self.front.next
        if self.front: 
            self.front.prev = None
        else: 
            self.rear = None
        self.size -= 1
        return data
    
    def popBack(self):
        if self.is_empty():
            return "empty"
        data = self.rear.data
        self.rear = self.rear.prev
        if self.rear: 
            self.rear.next = None
        else: 
            self.front = None
        self.size -= 1
        return data
    
    def get_first(self):
        return self.front.data if self.front else "empty"
    
    def get_last(self):
        return self.rear.data if self.rear else "empty"
    
    def display(self):
        result = []
        current = self.front
        while current:
            result.append(current.data)
            current = current.next
        return result
    
print("6. Дек на списке:")
d2 = LinkedListDeque()
d2.pushfront(90); d2.pushback(80); d2.pushfront(70)
print(f"   pushfront(90), pushback(80), pushfront(70) -> {d2.display()}, popfront()={d2.popfront()}, popBack()={d2.popBack()}")

```

    6. Дек на списке:
       pushfront(90), pushback(80), pushfront(70) -> [70, 90, 80], popfront()=70, popBack()=80


#### Задание 2


```python
def check_brackets(expression):
    stack = []
    brackets = {')': '(', ']': '[', '}': '{'}
    
    for char in expression:
        if char in '([{':
            stack.append(char)
        elif char in brackets:
            if not stack or stack[-1] != brackets[char]:
                return False
            stack.pop()
    
    return len(stack) == 0

print("7. Проверка скобок:")
brackets_tests = ["()", "([)]", "({[]})"]
results = [check_brackets(test) for test in brackets_tests]
print(f"   {brackets_tests} -> {results}")

```

    7. Проверка скобок:
       ['()', '([)]', '({[]})'] -> [True, False, True]


#### Задание 3


```python
def evaluate_rpn(expression):
    stack = []
    tokens = expression.split()
    
    for token in tokens:
        if token.isdigit():
            stack.append(int(token))
        else:
            right = stack.pop()
            left = stack.pop()
            
            if token == '+':
                result = left + right
            elif token == '-':
                result = left - right
            elif token == '*':
                result = left * right
            elif token == '/':
                result = left / right
            
            stack.append(result)
    
    return stack[0]

print("8. Обратная польская запись:")
rpn_tests = ["3 4 +", "5 1 2 + 4 * + 3 -"]
results = [evaluate_rpn(test) for test in rpn_tests]
print(f"   {rpn_tests} -> {results}")
```

    8. Обратная польская запись:
       ['3 4 +', '5 1 2 + 4 * + 3 -'] -> [7, 14]


#### Задание 4


```python
def infix_to_postfix(expression):
    stack = []
    output = []
    precedence = {'+': 1, '-': 1, '*': 2, '/': 2, '^': 3}
    
    for char in expression:
        if char.isalnum(): 
            output.append(char)
        elif char == '(':
            stack.append(char)
        elif char == ')':
            while stack and stack[-1] != '(':
                output.append(stack.pop())
            stack.pop() 
        else: 
            while (stack and stack[-1] != '(' and 
                   precedence.get(char, 0) <= precedence.get(stack[-1], 0)):
                output.append(stack.pop())
            stack.append(char)
    
    while stack:
        output.append(stack.pop())
    
    return ' '.join(output)

print("9. Инфиксная в постфиксную:")
infix_tests = ["a+b", "(a+b)*c", "a+b*c-d/e"]
results = [infix_to_postfix(test) for test in infix_tests]
print(f"   {infix_tests} -> {results}")
```

    9. Инфиксная в постфиксную:
       ['a+b', '(a+b)*c', 'a+b*c-d/e'] -> ['a b +', 'a b + c *', 'a b c * + d e / -']

