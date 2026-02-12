```python
# Базовые классы для наследования
class BaseStack:
    def push(self, x):
        raise NotImplementedError
    def pop(self):
        raise NotImplementedError
    def peek(self):
        raise NotImplementedError
    def is_empty(self):
        raise NotImplementedError
    def size(self):
        raise NotImplementedError

class BaseQueue:
    def enqueue(self, x):
        raise NotImplementedError
    def dequeue(self):
        raise NotImplementedError
    def peek(self):
        raise NotImplementedError
    def is_empty(self):
        raise NotImplementedError
    def size(self):
        raise NotImplementedError

class BaseDeque:
    def push_front(self, x):
        raise NotImplementedError
    def push_back(self, x):
        raise NotImplementedError
    def pop_front(self):
        raise NotImplementedError
    def pop_back(self):
        raise NotImplementedError
    def peek_front(self):
        raise NotImplementedError
    def peek_back(self):
        raise NotImplementedError
    def is_empty(self):
        raise NotImplementedError
    def size(self):
        raise NotImplementedError
```


```python
# ## Задание 1: Реализация структур данных
# ### Вспомогательные классы
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class DoublyNode:
    def __init__(self, data):
        self.data = data
        self.prev = None
        self.next = None

# ### 1.1 Стек на массиве
class ArrayStack(BaseStack):
    def __init__(self):
        self._items = []
    def push(self, x):
        self._items.append(x)
    def pop(self):
        if self.is_empty():
            raise IndexError("Стек пуст")
        return self._items.pop()
    def peek(self):
        if self.is_empty():
            raise IndexError("Стек пуст")
        return self._items[-1]
    def is_empty(self):
        return len(self._items) == 0
    def size(self):
        return len(self._items)
    def __str__(self):
        return f"Stack({self._items})"
```


```python
# ### 1.2 Стек на связном списке
class LinkedListStack(BaseStack):
    def __init__(self):
        self.head = None
        self._size = 0
    def push(self, x):
        new_node = Node(x)
        new_node.next = self.head
        self.head = new_node
        self._size += 1
    def pop(self):
        if self.is_empty():
            raise IndexError("Стек пуст")
        data = self.head.data
        self.head = self.head.next
        self._size -= 1
        return data
    def peek(self):
        if self.is_empty():
            raise IndexError("Стек пуст")
        return self.head.data
    def is_empty(self):
        return self.head is None
    def size(self):
        return self._size
    def __str__(self):
        items = []
        current = self.head
        while current:
            items.append(current.data)
            current = current.next
        return f"Stack({items})"
```


```python
# ### 1.3 Очередь на массиве
class ArrayQueue(BaseQueue):
    def __init__(self):
        self._items = []
    def enqueue(self, x):
        self._items.append(x)
    def dequeue(self):
        if self.is_empty():
            raise IndexError("Очередь пуста")
        return self._items.pop(0)
    def peek(self):
        if self.is_empty():
            raise IndexError("Очередь пуста")
        return self._items[0]
    def is_empty(self):
        return len(self._items) == 0
    def size(self):
        return len(self._items)
    def __str__(self):
        return f"Queue({self._items})"
```


```python
# ### 1.4 Очередь на связном списке
class LinkedListQueue(BaseQueue):
    def __init__(self):
        self.head = None
        self.tail = None
        self._size = 0
    def enqueue(self, x):
        new_node = Node(x)
        if self.is_empty():
            self.head = self.tail = new_node
        else:
            self.tail.next = new_node
            self.tail = new_node
        self._size += 1
    def dequeue(self):
        if self.is_empty():
            raise IndexError("Очередь пуста")
        data = self.head.data
        self.head = self.head.next
        if self.head is None:
            self.tail = None
        self._size -= 1
        return data
    def peek(self):
        if self.is_empty():
            raise IndexError("Очередь пуста")
        return self.head.data
    def is_empty(self):
        return self.head is None
    def size(self):
        return self._size
    def __str__(self):
        items = []
        current = self.head
        while current:
            items.append(current.data)
            current = current.next
        return f"Queue({items})"
```


```python
# ### 1.5 Дек на массиве
class ArrayDeque(BaseDeque):
    def __init__(self):
        self._items = []
    def push_front(self, x):
        self._items.insert(0, x)
    def push_back(self, x):
        self._items.append(x)
    def pop_front(self):
        if self.is_empty():
            raise IndexError("Дек пуст")
        return self._items.pop(0)
    def pop_back(self):
        if self.is_empty():
            raise IndexError("Дек пуст")
        return self._items.pop()
    def peek_front(self):
        if self.is_empty():
            raise IndexError("Дек пуст")
        return self._items[0]
    def peek_back(self):
        if self.is_empty():
            raise IndexError("Дек пуст")
        return self._items[-1]
    def is_empty(self):
        return len(self._items) == 0
    def size(self):
        return len(self._items)
    def __str__(self):
        return f"Deque({self._items})"
```


```python
# ### 1.6 Дек на связном списке
class LinkedListDeque(BaseDeque):
    def __init__(self):
        self.head = None
        self.tail = None
        self._size = 0
    def push_front(self, x):
        new_node = DoublyNode(x)
        if self.is_empty():
            self.head = self.tail = new_node
        else:
            new_node.next = self.head
            self.head.prev = new_node
            self.head = new_node
        self._size += 1
    def push_back(self, x):
        new_node = DoublyNode(x)
        if self.is_empty():
            self.head = self.tail = new_node
        else:
            new_node.prev = self.tail
            self.tail.next = new_node
            self.tail = new_node
        self._size += 1
    def pop_front(self):
        if self.is_empty():
            raise IndexError("Дек пуст")
        data = self.head.data
        if self.head == self.tail:
            self.head = self.tail = None
        else:
            self.head = self.head.next
            self.head.prev = None
        self._size -= 1
        return data
    def pop_back(self):
        if self.is_empty():
            raise IndexError("Дек пуст")
        data = self.tail.data
        if self.head == self.tail:
            self.head = self.tail = None
        else:
            self.tail = self.tail.prev
            self.tail.next = None
        self._size -= 1
        return data
    def peek_front(self):
        if self.is_empty():
            raise IndexError("Дек пуст")
        return self.head.data
    def peek_back(self):
        if self.is_empty():
            raise IndexError("Дек пуст")
        return self.tail.data
    def is_empty(self):
        return self.head is None
    def size(self):
        return self._size
    def __str__(self):
        items = []
        current = self.head
        while current:
            items.append(current.data)
            current = current.next
        return f"Deque({items})"

```


```python
# ## Задание 2: Проверка корректности скобочной последовательности
def check_brackets(sequence):
    stack = ArrayStack()
    brackets = {'(': ')', '[': ']', '{': '}'}
    for char in sequence:
        if char in brackets.keys():
            stack.push(char)
        elif char in brackets.values():
            if stack.is_empty():
                return False
            opening_bracket = stack.pop()
            if brackets[opening_bracket] != char:
                return False
    return stack.is_empty()
```


```python
# ## Задание 3: Вычисление выражения в обратной польской записи
def evaluate_rpn(expression):
    stack = ArrayStack()
    operators = {
        '+': lambda x, y: x + y,
        '-': lambda x, y: x - y,
        '*': lambda x, y: x * y,
        '/': lambda x, y: x / y
    }
    for token in expression.split():
        if token.isdigit():
            stack.push(int(token))
        elif token in operators:
            if stack.size() < 2:
                raise ValueError("Недостаточно операндов")
            y = stack.pop()
            x = stack.pop()
            result = operators[token](x, y)
            stack.push(result)
        else:
            raise ValueError(f"Неизвестный токен: {token}")
    if stack.size() != 1:
        raise ValueError("Некорректное выражение")
    return stack.pop()

```


```python
# ## Задание 4: Перевод из инфиксной в постфиксную запись
def infix_to_postfix(expression):
    precedence = {'+': 1, '-': 1, '*': 2, '/': 2, '^': 3}
    stack = ArrayStack()
    output = []
    for token in expression.split():
        if token.isdigit():
            output.append(token)
        elif token == '(':
            stack.push(token)
        elif token == ')':
            while not stack.is_empty() and stack.peek() != '(':
                output.append(stack.pop())
            if not stack.is_empty() and stack.peek() == '(':
                stack.pop()
        else:
            while (not stack.is_empty() and 
                   stack.peek() != '(' and 
                   precedence.get(stack.peek(), 0) >= precedence.get(token, 0)):
                output.append(stack.pop())
            stack.push(token)
    while not stack.is_empty():
        output.append(stack.pop())
    return ' '.join(output)

```


```python
# ## Тестирование структур данных
array_stack = ArrayStack()
linked_stack = LinkedListStack()

for stack in [array_stack, linked_stack]:
    stack.push(1)
    stack.push(2)
    stack.push(3)
    print(f"{stack} -> peek: {stack.peek()}")
    print(f"pop: {stack.pop()}")
    print(f"После pop: {stack}")
    print(f"Пустой?: {stack.is_empty()}")
    print(f"Размер: {stack.size()}")
    print()

array_queue = ArrayQueue()
linked_queue = LinkedListQueue()

for queue in [array_queue, linked_queue]:
    queue.enqueue(1)
    queue.enqueue(2)
    queue.enqueue(3)
    print(f"{queue} -> peek: {queue.peek()}")
    print(f"dequeue: {queue.dequeue()}")
    print(f"После dequeue: {queue}")
    print(f"Пустой?: {queue.is_empty()}")
    print(f"Размер: {queue.size()}")
    print()

```

    Stack([1, 2, 3]) -> peek: 3
    pop: 3
    После pop: Stack([1, 2])
    Пустой?: False
    Размер: 2
    
    Stack([3, 2, 1]) -> peek: 3
    pop: 3
    После pop: Stack([2, 1])
    Пустой?: False
    Размер: 2
    
    Queue([1, 2, 3]) -> peek: 1
    dequeue: 1
    После dequeue: Queue([2, 3])
    Пустой?: False
    Размер: 2
    
    Queue([1, 2, 3]) -> peek: 1
    dequeue: 1
    После dequeue: Queue([2, 3])
    Пустой?: False
    Размер: 2
    
    


```python
array_deque = ArrayDeque()
linked_deque = LinkedListDeque()

for deque in [array_deque, linked_deque]:
    deque.push_front(1)
    deque.push_back(2)
    deque.push_front(0)
    deque.push_back(3)
    print(f"{deque}")
    print(f"peek_front: {deque.peek_front()}, peek_back: {deque.peek_back()}")
    print(f"pop_front: {deque.pop_front()}, pop_back: {deque.pop_back()}")
    print(f"После операций: {deque}")
    print(f"Пустой?: {deque.is_empty()}")
    print(f"Размер: {deque.size()}")
    print()
```

    Deque([0, 1, 2, 3])
    peek_front: 0, peek_back: 3
    pop_front: 0, pop_back: 3
    После операций: Deque([1, 2])
    Пустой?: False
    Размер: 2
    
    Deque([0, 1, 2, 3])
    peek_front: 0, peek_back: 3
    pop_front: 0, pop_back: 3
    После операций: Deque([1, 2])
    Пустой?: False
    Размер: 2
    
    


```python
test_cases = [
    "()", "()[]{}", "([{}])", "(", ")", "([)]", "{(})"
]

for case in test_cases:
    result = check_brackets(case)
    print(f"'{case}' -> {'Корректно' if result else 'Некорректно'}")

rpn_expressions = [
    "3 4 +",
    "5 2 3 * +",
    "10 5 - 2 *",
    "15 7 1 1 + - / 3 * 2 1 1 + + -"
]

for expr in rpn_expressions:
    try:
        result = evaluate_rpn(expr)
        print(f"{expr} = {result}")
    except Exception as e:
        print(f"Ошибка в выражении '{expr}': {e}")

```

    '()' -> Корректно
    '()[]{}' -> Корректно
    '([{}])' -> Корректно
    '(' -> Некорректно
    ')' -> Некорректно
    '([)]' -> Некорректно
    '{(})' -> Некорректно
    3 4 + = 7
    5 2 3 * + = 11
    10 5 - 2 * = 10
    15 7 1 1 + - / 3 * 2 1 1 + + - = 5.0
    


```python
infix_expressions = [
    "3 + 4",
    "5 + 2 * 3",
    "( 10 - 5 ) * 2",
    "15 / ( 7 - ( 1 + 1 ) ) * 3 - ( 2 + ( 1 + 1 ) )"
]

for expr in infix_expressions:
    postfix = infix_to_postfix(expr)
    print(f"Инфиксная: {expr}")
    print(f"Постфиксная: {postfix}")
    try:
        result_infix = evaluate_rpn(postfix)
        print(f"Результат: {result_infix}\n")
    except Exception as e:
        print(f"Ошибка вычисления: {e}\n")
```

    Инфиксная: 3 + 4
    Постфиксная: 3 4 +
    Результат: 7
    
    Инфиксная: 5 + 2 * 3
    Постфиксная: 5 2 3 * +
    Результат: 11
    
    Инфиксная: ( 10 - 5 ) * 2
    Постфиксная: 10 5 - 2 *
    Результат: 10
    
    Инфиксная: 15 / ( 7 - ( 1 + 1 ) ) * 3 - ( 2 + ( 1 + 1 ) )
    Постфиксная: 15 7 1 1 + - / 3 * 2 1 1 + + -
    Результат: 5.0
    
    


```python
def demonstrate_all_structures():
    print("1. Стек на массиве:")
    stack = ArrayStack()
    for i in range(1, 4):
        stack.push(i)
        print(f"push({i}) -> {stack}")
    print(f"peek() -> {stack.peek()}")
    print(f"pop() -> {stack.pop()}, стек: {stack}")
    print()
    
    print("2. Очередь на связном списке:")
    queue = LinkedListQueue()
    for i in range(1, 4):
        queue.enqueue(i)
        print(f"enqueue({i}) -> {queue}")
    print(f"peek() -> {queue.peek()}")
    print(f"dequeue() -> {queue.dequeue()}, очередь: {queue}")
    print()
    
    print("3. Дек на двусвязном списке:")
    deque = LinkedListDeque()
    deque.push_front(1)
    print(f"push_front(1) -> {deque}")
    deque.push_back(2)
    print(f"push_back(2) -> {deque}")
    deque.push_front(0)
    print(f"push_front(0) -> {deque}")
    print(f"peek_front() -> {deque.peek_front()}")
    print(f"peek_back() -> {deque.peek_back()}")
    print(f"pop_front() -> {deque.pop_front()}, дек: {deque}")
    print(f"pop_back() -> {deque.pop_back()}, дек: {deque}")

demonstrate_all_structures()
```

    1. Стек на массиве:
    push(1) -> Stack([1])
    push(2) -> Stack([1, 2])
    push(3) -> Stack([1, 2, 3])
    peek() -> 3
    pop() -> 3, стек: Stack([1, 2])
    
    2. Очередь на связном списке:
    enqueue(1) -> Queue([1])
    enqueue(2) -> Queue([1, 2])
    enqueue(3) -> Queue([1, 2, 3])
    peek() -> 1
    dequeue() -> 1, очередь: Queue([2, 3])
    
    3. Дек на двусвязном списке:
    push_front(1) -> Deque([1])
    push_back(2) -> Deque([1, 2])
    push_front(0) -> Deque([0, 1, 2])
    peek_front() -> 0
    peek_back() -> 2
    pop_front() -> 0, дек: Deque([1, 2])
    pop_back() -> 2, дек: Deque([1])
    
