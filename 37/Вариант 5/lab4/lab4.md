#Самуйлов С.С Лаб4 
#Стек, Очередь, Дек
#Цель работы
#Изучение структур данных «Стек», «Очередь», «Дек», а также основных операций над ними.
#Задание 1 


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
            
i =stackarray()
i.push(5)
print(i.peek())
print(i.push(2))
print(i.pop())
print(i.push(2))
print(i.isEmpty())
print(i.display())
```

    5
    None
    2
    None
    False
    [5, 2]



```python
class Node:
    def __init__(self,data):
        self.next=None
        self.data=data
class stacklist(stack):
    
    def __init__(self):
        self.top = None
        self.size = 0
    def isEmpty(self):
        return self.top == None
    def push(self,data):
        new_node=Node(data)
        new_node.next=self.top
        self.top = new_node
        self.size +=1
    def pop(self):
        if self.isEmpty() ==None:
            return "empty"
        else:
            data=self.top.data
            self.top=self.top.next
            self.size-=1
            return data
    def peek(self):
        if self.isEmpty() ==None:
            return "empty"
        else:
            return self.top.data
    def display(self):
        o=[]
        current=self.top
        while current:
            o.append(current.data)
            current=current.next
        return o
        
            
            
        
j= stacklist()
j.push(20)
j.push(30)
j.push(40)
print(j.display())
print(j.pop())
print(j.display())
        
```

    [40, 30, 20]
    40
    [30, 20]



```python
class queue:
    def __init__(self,data):
        raise "no method"
    def enqueue(self,data):
        raise "no method"
    def dequeue(self,data):
        raise "no method"
    def isEmpty(self,data):
        raise "no method"
    def peek(self,data):
        raise "no method"
class Queuearray(queue):
    def __init__(self):
        self.items=[]
    def enqueue(self,data):
        return self.items.append(data)
    def dequeue(self):
        if self.isEmpty():
            return "empty"
        return self.items.pop(0)
    def isEmpty(self):
        return len(self.items)==0
    def peek(self):
        return self.items[0]
    def display(self):
        return(self.items)
i = Queuearray()
print(i.isEmpty())
i.enqueue(10)
i.enqueue(20)
i.enqueue(30)
print(i.isEmpty())
print(i.display())
i.dequeue()
print(i.display())
i.enqueue(10)
print(i.peek())
print(i.display())
```

    True
    False
    [10, 20, 30]
    [20, 30]
    20
    [20, 30, 10]



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
            raise IndexError("Empty")
        data = self.head.data
        
        self.head = self.head.next
        if self.head is None:
            self.tail = None
        
        self.size -= 1
        return data
    
    def peek(self):
        if self.isEmpty():
            raise IndexError("Empty")
        return self.head.data
    def display(self):
        o=[]
        current = self.head
        while current:
            o.append(current.data)
            current=current.next
        return o
    
i = LinkedListQueue()
print(i.isEmpty())
i.enqueue(10)
i.enqueue(20)
i.enqueue(30)
print(i.isEmpty())
print(i.display())
i.dequeue()
print(i.display())
i.enqueue(10)
print(i.peek())
print(i.display())
```

    True
    False
    [10, 20, 30]
    [20, 30]
    20
    [20, 30, 10]



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
    
    def __len__(self):
        return len(self.data)
    
    def __str__(self):
        return f"Простой дек: {self.data}"
i = SimpleArrayDeque()
i.pushback(10)
print(i.__str__())
```

    Простой дек: [10]



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
test_cases = [
    "()",
    "()[]{}",
    "([{}])",
    "([)]",
    "((()))",
    "({[}])",
    "(",
    "]"
]

for expr in test_cases:
    result = check_brackets(expr)
    print(f"'{expr}' -> {'Корректно' if result else 'Ошибка'}")
```

    '()' -> ✓ Корректно
    '()[]{}' -> ✓ Корректно
    '([{}])' -> ✓ Корректно
    '([)]' -> ✗ Ошибка
    '((()))' -> ✓ Корректно
    '({[}])' -> ✗ Ошибка
    '(' -> ✗ Ошибка
    ']' -> ✗ Ошибка



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

examples = [
    "3 4 +",
    "3 4 + 2 *",
    "5 1 2 + 4 * + 3 -"
]

for expr in examples:
    result = evaluate_rpn(expr)
    print(f"{expr} = {result}")
```

    3 4 + = 7
    3 4 + 2 * = 14
    5 1 2 + 4 * + 3 - = 14



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

test_cases = [
    "a+b",
    "a+b*c",
    "(a+b)*c",
    "a+(b+c)*d",
    "a^b^c",
    "a+b*c-d/e"
]

for expr in test_cases:
    postfix = infix_to_postfix(expr)
    print(f"'{expr}' -> '{postfix}'")
```

    'a+b' -> 'a b +'
    'a+b*c' -> 'a b c * +'
    '(a+b)*c' -> 'a b + c *'
    'a+(b+c)*d' -> 'a b c + d * +'
    'a^b^c' -> 'a b ^ c ^'
    'a+b*c-d/e' -> 'a b c * + d e / -'



```python

```
