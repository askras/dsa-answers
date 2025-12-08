```python

# 1. стек на списке
class StackList:
    def __init__(self):
        self.items = []
    
    def push(self, item):
        self.items.append(item)
    
    def pop(self):
        return self.items.pop()
    
    def peek(self):
        return self.items[-1]
    
    def empty(self):
        return self.items == []
    
    def size(self):
        return len(self.items)
    
    def clear(self):
        self.items = []


# 2. Стек на связном списке
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class StackNode:
    def __init__(self):
        self.head = None
    
    def push(self, item):
        node = Node(item)
        if self.head is None:
            self.head = node
        else:
            node.next = self.head
            self.head = node
    
    def pop(self):
        data = self.head.data
        self.head = self.head.next
        return data
    
    def peek(self):
        return self.head.data
    
    def empty(self):
        return self.head is None
    
    def size(self):
        count = 0
        current = self.head
        while current:
            count += 1
            current = current.next
        return count
    
    def clear(self):
        self.head = None


# 3. Очередь на основе массива
class QueueList:
    def __init__(self):
        self.items = []
    
    def enqueue(self, item):
        self.items.append(item)
    
    def dequeue(self):
        return self.items.pop(0)
    
    def front(self):
        return self.items[0]
    
    def empty(self):
        return self.items == []
    
    def size(self):
        return len(self.items)
    
    def clear(self):
        self.items = []


# 4. Очередь на основе связного списка
class QueueNode:
    def __init__(self):
        self.head = None
        self.tail = None
    
    def enqueue(self, item):
        node = Node(item)
        if self.head is None:
            self.head = node
            self.tail = node
        else:
            self.tail.next = node
            self.tail = node
    
    def dequeue(self):
        data = self.head.data
        self.head = self.head.next
        if self.head is None:
            self.tail = None
        return data
    
    def front_elem(self):
        return self.head.data
    
    def empty(self):
        return self.head is None
    
    def size(self):
        count = 0
        current = self.head
        while current:
            count += 1
            current = current.next
        return count
    
    def clear(self):
        self.head = None
        self.tail = None


# 5. Дек на основе массива
class DequeList:
    def __init__(self):
        self.items = []
    
    def add_front(self, item):
        self.items.insert(0, item)
    
    def add_rear(self, item):
        self.items.append(item)
    
    def remove_front(self):
        return self.items.pop(0)
    
    def remove_rear(self):
        return self.items.pop()
    
    def front(self):
        return self.items[0]
    
    def rear(self):
        return self.items[-1]
    
    def empty(self):
        return self.items == []
    
    def size(self):
        return len(self.items)
    
    def clear(self):
        self.items = []


# 6. Дек на основе связного списка
class DequeNode:
    def __init__(self):
        self.head = None 
        self.tail = None 
    
    def add_front(self, item):
        node = Node(item)
        if self.head is None:
            self.head = node
            self.tail = node
        else:
            node.next = self.head
            self.head = node
    
    def add_rear(self, item):
        node = Node(item)
        if self.tail is None:
            self.head = node
            self.tail = node
        else:
            self.tail.next = node
            self.tail = node
    
    def remove_front(self):
        data = self.head.data
        self.head = self.head.next
        if self.head is None:
            self.tail = None
        return data
    
    def remove_rear(self):
        current = self.head
        while current.next != self.tail:
            current = current.next
        
        data = self.tail.data
        current.next = None
        self.tail = current
        return data
    
    def front_elem(self):
        return self.head.data
    
    def rear_elem(self):
        return self.tail.data
    
    def empty(self):
        return self.head is None
    
    def size(self):
        count = 0
        current = self.head
        while current:
            count += 1
            current = current.next
        return count
    
    def clear(self):
        self.head = None
        self.tail = None


# Проверка скобок 
def check_brackets(text):
    stack = []
    for c in text:
        if c == '(' or c == '[' or c == '{':
            stack.append(c)
        elif c == ')':
            if not stack or stack.pop() != '(':
                return False
        elif c == ']':
            if not stack or stack.pop() != '[':
                return False
        elif c == '}':
            if not stack or stack.pop() != '{':
                return False
    return len(stack) == 0

# Задание 3
def calculate_rpn(expression):
    stack = []
    parts = expression.split()
    for part in parts:
        if part.isdigit():
            stack.append(int(part))
        else:
            b = stack.pop()
            a = stack.pop()
            if part == '+':
                result = a + b
            elif part == '-':
                result = a - b
            elif part == '*':
                result = a * b
            elif part == '/':
                result = a / b
            stack.append(result)
    return stack[0]

# Задание 4
def infix_to_postfix(s):
    ops = []
    out = []
    p = {'+': 1, '-': 1, '*': 2, '/': 2, '(': 0}
    i = 0
    while i < len(s):
        c = s[i]
        if c.isdigit():
            num = c
            while i+1 < len(s) and s[i+1].isdigit():
                i += 1
                num += s[i]
            out.append(num)
        elif c == '(':
            ops.append(c)
        elif c == ')':
            while ops and ops[-1] != '(':
                out.append(ops.pop())
            if ops and ops[-1] == '(':
                ops.pop()
        elif c in '+-*/':
            while ops and p.get(ops[-1], 0) >= p[c]:
                out.append(ops.pop())
            ops.append(c)
        i += 1
    while ops:
        out.append(ops.pop())
    return ' '.join(out)
        
```

