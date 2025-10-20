# ОТЧЕТ ПО ЛАБОРАТОРНОЙ РАБОТЕ
## «Лабораторная работа №4. Стек, Очередь, Дек»

### Цель работы: Изучение структур данных «Стек», «Очередь», «Дек», а также основных операций над ними.

### Работу выполнил: Цыганков Д.С 

## Задание 1 
### 1.1 Реализовать стек на основе массива.
```python
class ArrayStack(Stack):
    def __init__(self):
        self._items = []
    
    def push(self, item: Any) -> None:
        """Добавление элемента на вершину стека"""
        self._items.append(item)
    
    def pop(self) -> Any:
        """Удаление и возврат элемента с вершины стека"""
        if self.is_empty():
            raise IndexError("Stack is empty")
        return self._items.pop()
    
    def peek(self) -> Any:
        """Возврат элемента с вершины стека без удаления"""
        if self.is_empty():
            raise IndexError("Stack is empty")
        return self._items[-1]
    
    def is_empty(self) -> bool:
        """Проверка стека на пустоту"""
        return len(self._items) == 0
    
    def size(self) -> int:
        """Возврат размера стека"""
        return len(self._items)
    
```

### 1.2 Реализовать стек на основе связного списка.
```python 
class Node:
    def __init__(self, data: Any):
        self.data = data
        self.next: Optional['Node'] = None

class LinkedListStack(Stack):
    def __init__(self):
        self._head: Optional[Node] = None
        self._size = 0
    
    def push(self, item: Any) -> None:
        new_node = Node(item)
        new_node.next = self._head
        self._head = new_node
        self._size += 1
    
    def pop(self) -> Any:
        if self.is_empty():
            raise IndexError("Stack is empty")
        
        data = self._head.data
        self._head = self._head.next
        self._size -= 1
        return data
    
    def peek(self) -> Any:
        if self.is_empty():
            raise IndexError("Stack is empty")
        return self._head.data
    
    def is_empty(self) -> bool:
        return self._head is None
    
    def size(self) -> int:
        return self._size
    
    def __str__(self):
        items = []
        current = self._head
        while current:
            items.append(current.data)
            current = current.next
        return f"LinkedListStack({items})"
```

### 1.3 Реализовать очередь на основе массива.
```python 
class ArrayQueue(Queue):
    def __init__(self):
        self._items = []
    
    def enqueue(self, item: Any) -> None:
        self._items.append(item)
    
    def dequeue(self) -> Any:
        if self.is_empty():
            raise IndexError("Queue is empty")
        return self._items.pop(0)
    
    def peek(self) -> Any:
        if self.is_empty():
            raise IndexError("Queue is empty")
        return self._items[0]
    
    def is_empty(self) -> bool:
        return len(self._items) == 0
    
    def size(self) -> int:
        return len(self._items)
    
    def __str__(self):
        return f"ArrayQueue({self._items})"
```

### 1.4  Реализовать очередь на основе связного списка.
```python 
class LinkedListQueue(Queue):
    def __init__(self):
        self._head: Optional[Node] = None
        self._tail: Optional[Node] = None
        self._size = 0
    
    def enqueue(self, item: Any) -> None:
        new_node = Node(item)
        
        if self.is_empty():
            self._head = self._tail = new_node
        else:
            self._tail.next = new_node
            self._tail = new_node
        self._size += 1
    
    def dequeue(self) -> Any:
        if self.is_empty():
            raise IndexError("Queue is empty")
        
        data = self._head.data
        self._head = self._head.next
        
        if self._head is None:
            self._tail = None
        
        self._size -= 1
        return data
    
    def peek(self) -> Any:
        if self.is_empty():
            raise IndexError("Queue is empty")
        return self._head.data
    
    def is_empty(self) -> bool:
        return self._head is None
    
    def size(self) -> int:
        return self._size
    
    def __str__(self):
        items = []
        current = self._head
        while current:
            items.append(current.data)
            current = current.next
        return f"LinkedListQueue({items})"
```

### 1.5  Реализовать дек на основе массива.

```python 
class ArrayDeque(Deque):
    def __init__(self):
        self._items = []
    
    def push_front(self, item: Any) -> None:
        self._items.insert(0, item)
    
    def push_back(self, item: Any) -> None:
        self._items.append(item)
    
    def pop_front(self) -> Any:
        if self.is_empty():
            raise IndexError("Deque is empty")
        return self._items.pop(0)
    
    def pop_back(self) -> Any:
        if self.is_empty():
            raise IndexError("Deque is empty")
        return self._items.pop()
    
    def peek_front(self) -> Any:
        if self.is_empty():
            raise IndexError("Deque is empty")
        return self._items[0]
    
    def peek_back(self) -> Any:
        if self.is_empty():
            raise IndexError("Deque is empty")
        return self._items[-1]
    
    def is_empty(self) -> bool:
        return len(self._items) == 0
    
    def size(self) -> int:
        return len(self._items)
    
    def __str__(self):
        return f"ArrayDeque({self._items})"
```

### 1.6 Реализовать дек на основе связного списка.

```python 
class DoublyNode:
    def __init__(self, data: Any):
        self.data = data
        self.prev: Optional['DoublyNode'] = None
        self.next: Optional['DoublyNode'] = None

class LinkedListDeque(Deque):
    def __init__(self):
        self._head: Optional[DoublyNode] = None
        self._tail: Optional[DoublyNode] = None
        self._size = 0
    
    def push_front(self, item: Any) -> None:
        new_node = DoublyNode(item)
        
        if self.is_empty():
            self._head = self._tail = new_node
        else:
            new_node.next = self._head
            self._head.prev = new_node
            self._head = new_node
        
        self._size += 1
    
    def push_back(self, item: Any) -> None:
        new_node = DoublyNode(item)
        
        if self.is_empty():
            self._head = self._tail = new_node
        else:
            new_node.prev = self._tail
            self._tail.next = new_node
            self._tail = new_node
        
        self._size += 1
    
    def pop_front(self) -> Any:
        if self.is_empty():
            raise IndexError("Deque is empty")
        
        data = self._head.data
        
        if self._head == self._tail: 
            self._head = self._tail = None
        else:
            self._head = self._head.next
            self._head.prev = None
        
        self._size -= 1
        return data
    
    def pop_back(self) -> Any:
        if self.is_empty():
            raise IndexError("Deque is empty")
        
        data = self._tail.data
        
        if self._head == self._tail:
            self._head = self._tail = None
        else:
            self._tail = self._tail.prev
            self._tail.next = None
        
        self._size -= 1
        return data
    
    def peek_front(self) -> Any:
        if self.is_empty():
            raise IndexError("Deque is empty")
        return self._head.data
    
    def peek_back(self) -> Any:
        if self.is_empty():
            raise IndexError("Deque is empty")
        return self._tail.data
    
    def is_empty(self) -> bool:
        return self._head is None
    
    def size(self) -> int:
        return self._size
    
    def __str__(self):
        items = []
        current = self._head
        while current:
            items.append(current.data)
            current = current.next
        return f"LinkedListDeque({items})"
```

## Задание 2 - Используя операции со стеком, написать программу, проверяющую своевременность закрытия скобок «(, ), [, ] ,{, }» в строке символов (строка состоит из одних скобок этих типов).

```python
def check_brackets(expression: str) -> bool:
    
    stack = ArrayStack()
    bracket_pairs = {')': '(', ']': '[', '}': '{'}
    
    for char in expression:
        if char in '([{': 
            stack.push(char)
        elif char in ')]}':  
            if stack.is_empty():
                return False  
            
            top = stack.pop()
            if top != bracket_pairs[char]:
                return False  
    
    return stack.is_empty() 

def test_bracket_checker():
    test_cases = [
        ("()", True),
        ("()[]{}", True),
        ("([{}])", True),
        ("(]", False),
        ("([)]", False),
        ("((()))", True),
        ("((())", False),
        ("", True)
    ]
    
    print("Тестирование проверки скобок:")
    for expression, expected in test_cases:
        result = check_brackets(expression)
        status = "✓" if result == expected else "✗"
        print(f"{status} '{expression}' -> {result} (ожидается: {expected})")
```

## Задание 3 - Написать программу вычисления значения выражения, представленного в обратной польской записи (в постфиксной записи). Выражение состоит из цифр от 1 до 9 и знаков операции.

```python 
def evaluate_postfix(expression: str) -> float:
    
    stack = ArrayStack()
    operators = {
        '+': lambda x, y: x + y,
        '-': lambda x, y: x - y,
        '*': lambda x, y: x * y,
        '/': lambda x, y: x / y
    }
    
    for token in expression.split():
        if token.isdigit():  
            stack.push(float(token))
        elif token in operators: 
            if stack.size() < 2:
                raise ValueError("Недостаточно операндов для операции")
            
            right = stack.pop()
            left = stack.pop()
            result = operators[token](left, right)
            stack.push(result)
        else:
            raise ValueError(f"Неизвестный токен: {token}")
    
    if stack.size() != 1:
        raise ValueError("Некорректное выражение")
    
    return stack.pop()

# Тестирование вычисления постфиксных выражений
def test_postfix_evaluator():
    test_cases = [
        ("3 4 +", 7),
        ("5 1 2 + 4 * + 3 -", 14),
        ("2 3 * 4 +", 10),
        ("10 2 /", 5),
        ("4 2 5 * + 1 3 2 * + /", 2)
    ]
    
    print("\nТестирование вычисления постфиксных выражений:")
    for expression, expected in test_cases:
        try:
            result = evaluate_postfix(expression)
            status = "✓" if abs(result - expected) < 1e-9 else "✗"
            print(f"{status} '{expression}' = {result} (ожидается: {expected})")
        except Exception as e:
            print(f"✗ '{expression}' -> Ошибка: {e}")
```

##Задание 4 - Реализовать перевод математических выражений из инфиксной в постфиксную форму записи.

```python 
def infix_to_postfix(expression: str) -> str:
    
    # Приоритет операторов
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
            stack.pop() '('
        else:  # оператор
            while (not stack.is_empty() and 
                   stack.peek() != '(' and 
                   precedence.get(stack.peek(), 0) >= precedence.get(token, 0)):
                output.append(stack.pop())
            stack.push(token)
    
    while not stack.is_empty():
        output.append(stack.pop())
    
    return ' '.join(output)

def test_infix_to_postfix():
    test_cases = [
        ("a + b", "a b +"),
        ("( a + b ) * c", "a b + c *"),
        ("a + b * c", "a b c * +"),
        ("a * b + c", "a b * c +"),
        ("a + ( b * c )", "a b c * +"),
        ("a + b * c / d", "a b c * d / +")
    ]
    
    print("\nТестирование перевода в постфиксную запись:")
    for infix, expected_postfix in test_cases:
        result = infix_to_postfix(infix)
        status = "✓" if result == expected_postfix else "✗"
        print(f"{status} '{infix}' -> '{result}' (ожидается: '{expected_postfix}')")
```
