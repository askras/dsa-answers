# Лабораторная работа 4
# Стек, Очередь, Дек
## Цель работы
Изучение структур данных стек, очередь, дек, их реализация с помощью массивов и списков.
## Задачи лабораторной работы
1. Изучение структур данных стек, очередь, дек.
2. Реализация стека, очереди, дека двумя способами.
## Словесная постановка задачи
1. Изучить определения стека, очереди, дека.
2. Написать по 2 версии каждой структуры данных.
3. Написать задания, использующие реализованные ранее структуры.
## Реализация односвязного списка
Первая часть реализует базовые класс Stack, Queue, Deque, а также ListNode и DoubleListNode для дальнейшего использования при реализации структур данных

## 1
``` Python
class Stack(ABC):
    @abstractmethod
    def push(self, item: Any) -> None:
        pass
    
    @abstractmethod
    def pop(self) -> Any:
        pass
    
    @abstractmethod
    def peek(self) -> Any:
        pass
    
    @abstractmethod
    def is_empty(self) -> bool:
        pass
    
    @abstractmethod
    def size(self) -> int:
        pass

class Queue(ABC):
    @abstractmethod
    def enqueue(self, item: Any) -> None:
        pass
    
    @abstractmethod
    def dequeue(self) -> Any:
        pass
    
    @abstractmethod
    def peek(self) -> Any:
        pass
    
    @abstractmethod
    def is_empty(self) -> bool:
        pass
    
    @abstractmethod
    def size(self) -> int:
        pass

class Deque(ABC):
    @abstractmethod
    def push_front(self, item: Any) -> None:
        pass
    
    @abstractmethod
    def push_back(self, item: Any) -> None:
        pass
    
    @abstractmethod
    def pop_front(self) -> Any:
        pass
    
    @abstractmethod
    def pop_back(self) -> Any:
        pass
    
    @abstractmethod
    def peek_front(self) -> Any:
        pass
    
    @abstractmethod
    def peek_back(self) -> Any:
        pass
    
    @abstractmethod
    def is_empty(self) -> bool:
        pass
    
    @abstractmethod
    def size(self) -> int:
        pass

class ListNode:
    def __init__(self, data = 0, next_node = None):
        self.data = data
        self.next = next_node

class DoubleListNode:
    def __init__(self, data=0, prev_node=None, next_node=None):
        self.data = data
        self.prev = prev_node
        self.next = next_node
```
## 2
``` Python
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
```

## 3 
``` Python
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
            
            b = stack.pop()
            a = stack.pop()
            result = operators[token](a, b)
            stack.push(result)
        else:
            raise ValueError(f"Неизвестный токен: {token}")
    
    if stack.size() != 1:
        raise ValueError("Некорректное выражение")
    
    return stack.pop()
```

## 4 
``` Python
def infix_to_postfix_with_functions(expression):
    expression = expression.replace(' ', '')
    tokens = tokenize(expression)
    
    precedence = {'+': 1, '-': 1, '*': 2, '/': 2, '^': 3}
    associativity = {'+': True, '-': True, '*': True, '/': True, '^': False}
    
    functions = ['sin', 'cos', 'tan', 'log', 'ln', 'sqrt', 'exp']
    
    stack = Stack()
    output = []
    
    i = 0
    n = len(tokens)
    
    while i < n:
        token = tokens[i]
        
        if is_number(token) or is_variable(token):
            output.append(token)
        
        elif token in functions:
            stack.push(token)
        
        elif token == '(':
            stack.push(token)
        
        elif token == ')':
            while not stack.is_empty() and stack.peek() != '(':
                output.append(stack.pop())
            stack.pop()  # Удаляем '('
            
            if not stack.is_empty() and stack.peek() in functions:
                output.append(stack.pop())
        
        elif token in precedence:
            while (not stack.is_empty() and 
                   stack.peek() != '(' and
                   stack.peek() in precedence and
                   (precedence[stack.peek()] > precedence[token] or
                    (precedence[stack.peek()] == precedence[token] and 
                     associativity[token] == True))):
                output.append(stack.pop())
            stack.push(token)
        
        elif token == ',':
            while not stack.is_empty() and stack.peek() != '(':
                output.append(stack.pop())
        i += 1
    while not stack.is_empty():
        output.append(stack.pop())
    
    return ' '.join(output)


```
