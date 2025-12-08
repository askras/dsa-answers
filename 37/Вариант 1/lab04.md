# Стек, Очередь, Дек
Голубков А. А  
ИУ10-37  
Вариант 1


```python
# Общий класс Node для связных списков
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None
        self.prev = None
```

## Задание 1
Реализовать следующие структуры данных:

**1.1** Стек на основе массива  
**1.2** Стек на основе связного списка  
**1.3** Очередь на основе массива  
**1.4** Очередь на основе связного списка  
**1.5** Дек на основе массива  
**1.6** Дек на основе связного списка

### 1.1 Стек на основе массива


```python
class Stack:
    def __init__(self, capacity=100):
        self.capacity = capacity
        self.array = [None] * capacity
        self.top_index = -1 

    def isEmpty(self):
        return self.top_index == -1

    def isFull(self):
        return self.top_index == self.capacity - 1

    def push(self, value):
        if self.isFull():
            raise OverflowError("Стек переполнен")
        self.top_index += 1
        self.array[self.top_index] = value
        print(f"Добавлено: {value}")

    def pop(self):
        if self.isEmpty():
            raise IndexError("Стек пуст")
        value = self.array[self.top_index]
        self.array[self.top_index] = None
        self.top_index -= 1
        print(f"Удалено: {value}")
        return value

    def peek(self):
        if self.isEmpty():
            raise IndexError("Стек пуст")
        return self.array[self.top_index]

    def size(self):
        return self.top_index + 1

print("=== Стек на массиве ===")
stack = Stack(5)
stack.push(10)
stack.push(20)
stack.push(30)
print("Верхний элемент:", stack.peek())
print("Размер стека:", stack.size())
stack.pop()
stack.pop()
stack.pop()
print("Стек пуст?", stack.isEmpty())
```

    === Стек на массиве ===
    Добавлено: 10
    Добавлено: 20
    Добавлено: 30
    Верхний элемент: 30
    Размер стека: 3
    Удалено: 30
    Удалено: 20
    Удалено: 10
    Стек пуст? True
    

### 1.2 Стек на основе связного списка


```python
class LinkedListStack:
    def __init__(self):
        self.head = None

    def isEmpty(self):
        return self.head is None

    def push(self, value):
        new_node = Node(value)
        new_node.next = self.head
        self.head = new_node
        print(f"Добавлено: {value}")

    def pop(self):
        if self.isEmpty():
            raise IndexError("Стек пуст")
        value = self.head.data
        self.head = self.head.next
        print(f"Удалено: {value}")
        return value

    def peek(self):
        if self.isEmpty():
            raise IndexError("Стек пуст")
        return self.head.data

    def size(self):
        count = 0
        current = self.head
        while current:
            count += 1
            current = current.next
        return count

print("\n=== Стек на связном списке ===")
stack = LinkedListStack()
stack.push(5)
stack.push(15)
stack.push(25)
print("Верхний элемент:", stack.peek())
print("Размер стека:", stack.size())
stack.pop()
stack.pop()
stack.pop()
print("Стек пуст?", stack.isEmpty())
```

    
    === Стек на связном списке ===
    Добавлено: 5
    Добавлено: 15
    Добавлено: 25
    Верхний элемент: 25
    Размер стека: 3
    Удалено: 25
    Удалено: 15
    Удалено: 5
    Стек пуст? True
    

### 1.3 Очередь на основе массива


```python
class ArrayQueue:
    def __init__(self, capacity=100):
        self.capacity = capacity
        self.array = [None] * capacity
        self.head = 0
        self.tail = 0
        self.size_count = 0

    def isEmpty(self):
        return self.size_count == 0

    def isFull(self):
        return self.size_count == self.capacity

    def enqueue(self, value):
        if self.isFull():
            raise OverflowError("Очередь переполнена")
        self.array[self.tail] = value
        self.tail = (self.tail + 1) % self.capacity
        self.size_count += 1
        print(f"Добавлено: {value}")

    def dequeue(self):
        if self.isEmpty():
            raise IndexError("Очередь пуста")
        value = self.array[self.head]
        self.array[self.head] = None
        self.head = (self.head + 1) % self.capacity
        self.size_count -= 1
        print(f"Удалено: {value}")
        return value

    def peek(self):
        if self.isEmpty():
            raise IndexError("Очередь пуста")
        return self.array[self.head]

    def size(self):
        return self.size_count

print("\n=== Очередь на массиве ===")
queue = ArrayQueue(5)
queue.enqueue(1)
queue.enqueue(2)
queue.enqueue(3)
print("Первый элемент:", queue.peek())
print("Размер очереди:", queue.size())
queue.dequeue()
queue.dequeue()
queue.enqueue(4)
queue.enqueue(5)
queue.enqueue(6)
print("Размер очереди:", queue.size())
print("Первый элемент:", queue.peek())
```

    
    === Очередь на массиве ===
    Добавлено: 1
    Добавлено: 2
    Добавлено: 3
    Первый элемент: 1
    Размер очереди: 3
    Удалено: 1
    Удалено: 2
    Добавлено: 4
    Добавлено: 5
    Добавлено: 6
    Размер очереди: 4
    Первый элемент: 3
    

### 1.4 Очередь на основе связного списка


```python
class LinkedListQueue:
    def __init__(self):
        self.head = None
        self.tail = None
        self.size_count = 0 

    def isEmpty(self):
        return self.head is None

    def enqueue(self, value):
        new_node = Node(value)
        if self.isEmpty():
            self.head = self.tail = new_node
        else:
            self.tail.next = new_node
            self.tail = new_node
        self.size_count += 1
        print(f"Добавлено: {value}")

    def dequeue(self):
        if self.isEmpty():
            raise IndexError("Очередь пуста")
        value = self.head.data
        self.head = self.head.next
        if self.head is None:
            self.tail = None
        self.size_count -= 1
        print(f"Удалено: {value}")
        return value

    def peek(self):
        if self.isEmpty():
            raise IndexError("Очередь пуста")
        return self.head.data

    def size(self):
        return self.size_count

print("\n=== Очередь на связном списке ===")
queue = LinkedListQueue()
queue.enqueue(10)
queue.enqueue(20)
queue.enqueue(30)
print("Первый элемент:", queue.peek())
print("Размер очереди:", queue.size())
queue.dequeue()
queue.dequeue()
print("Первый элемент:", queue.peek())
print("Размер очереди:", queue.size())
queue.dequeue()
print("Очередь пуста?", queue.isEmpty())
```

    
    === Очередь на связном списке ===
    Добавлено: 10
    Добавлено: 20
    Добавлено: 30
    Первый элемент: 10
    Размер очереди: 3
    Удалено: 10
    Удалено: 20
    Первый элемент: 30
    Размер очереди: 1
    Удалено: 30
    Очередь пуста? True
    

### 1.5 Дек на основе массива


```python
class ArrayDeque:
    def __init__(self, capacity=10):
        self.capacity = capacity
        self.deque = [None] * capacity
        self.front = 0
        self.rear = -1
        self.size = 0

    def isEmpty(self):
        return self.size == 0

    def isFull(self):
        return self.size == self.capacity

    def pushFront(self, value):
        if self.isFull():
            raise OverflowError("Дек переполнен")
        self.front = (self.front - 1 + self.capacity) % self.capacity
        self.deque[self.front] = value
        self.size += 1
        print(f"Добавлено в начало: {value}")
        if self.size == 1:
            self.rear = self.front

    def pushBack(self, value):
        if self.isFull():
            raise OverflowError("Дек переполнен")
        self.rear = (self.rear + 1) % self.capacity
        self.deque[self.rear] = value
        self.size += 1
        print(f"Добавлено в конец: {value}")
        if self.size == 1:
            self.front = self.rear

    def popFront(self):
        if self.isEmpty():
            raise IndexError("Дек пуст")
        value = self.deque[self.front]
        self.deque[self.front] = None
        self.front = (self.front + 1) % self.capacity
        self.size -= 1
        print(f"Удалено из начала: {value}")
        return value

    def popBack(self):
        if self.isEmpty():
            raise IndexError("Дек пуст")
        value = self.deque[self.rear]
        self.deque[self.rear] = None
        self.rear = (self.rear - 1 + self.capacity) % self.capacity
        self.size -= 1
        print(f"Удалено из конца: {value}")
        return value

    def peekFront(self):
        if self.isEmpty():
            raise IndexError("Дек пуст")
        return self.deque[self.front]

    def peekBack(self):
        if self.isEmpty():
            raise IndexError("Дек пуст")
        return self.deque[self.rear]

    def __str__(self):
        if self.isEmpty():
            return "Дек пуст"
        result = []
        index = self.front
        for _ in range(self.size):
            result.append(str(self.deque[index]))
            index = (index + 1) % self.capacity
        return " <- ".join(result)

print("\n=== Дек на массиве ===")
d = ArrayDeque(5)
d.pushBack(10)
d.pushBack(20)
d.pushFront(5)
print("Содержимое дека:", d)
print("Первый элемент:", d.peekFront())
print("Последний элемент:", d.peekBack())
d.popFront()
d.popBack()
print("После удаления:", d)
d.pushBack(30)
d.pushBack(40)
d.pushFront(1)
print("Итоговое состояние дека:", d)
```

    
    === Дек на массиве ===
    Добавлено в конец: 10
    Добавлено в конец: 20
    Добавлено в начало: 5
    Содержимое дека: 5 <- 10 <- 20
    Первый элемент: 5
    Последний элемент: 20
    Удалено из начала: 5
    Удалено из конца: 20
    После удаления: 10
    Добавлено в конец: 30
    Добавлено в конец: 40
    Добавлено в начало: 1
    Итоговое состояние дека: 1 <- 10 <- 30 <- 40
    

### 1.6 Дек на основе связного списка


```python
class LinkedListDeque:
    def __init__(self):
        self.head = None
        self.tail = None
        self.size_count = 0

    def isEmpty(self):
        return self.head is None

    def size(self):
        return self.size_count

    def pushFront(self, value):
        new_node = Node(value)
        if self.isEmpty():
            self.head = self.tail = new_node
        else:
            new_node.next = self.head
            self.head.prev = new_node
            self.head = new_node
        self.size_count += 1
        print(f"Добавлено в начало: {value}")

    def pushBack(self, value):
        new_node = Node(value)
        if self.isEmpty():
            self.head = self.tail = new_node
        else:
            self.tail.next = new_node
            new_node.prev = self.tail
            self.tail = new_node
        self.size_count += 1
        print(f"Добавлено в конец: {value}")

    def popFront(self):
        if self.isEmpty():
            raise IndexError("Дек пуст")
        value = self.head.data
        self.head = self.head.next
        if self.head is not None:
            self.head.prev = None
        else:
            self.tail = None
        self.size_count -= 1
        print(f"Удалено из начала: {value}")
        return value

    def popBack(self):
        if self.isEmpty():
            raise IndexError("Дек пуст")
        value = self.tail.data
        self.tail = self.tail.prev
        if self.tail is not None:
            self.tail.next = None
        else:
            self.head = None
        self.size_count -= 1
        print(f"Удалено из конца: {value}")
        return value

    def peekFront(self):
        if self.isEmpty():
            raise IndexError("Дек пуст")
        return self.head.data

    def peekBack(self):
        if self.isEmpty():
            raise IndexError("Дек пуст")
        return self.tail.data

    def __str__(self):
        if self.isEmpty():
            return "Дек пуст"
        result = []
        current = self.head
        while current:
            result.append(str(current.data))
            current = current.next
        return " <-> ".join(result)

print("\n=== Дек на связном списке ===")
deque = LinkedListDeque()
deque.pushBack(10)
deque.pushBack(20)
deque.pushFront(5)
print("Содержимое дека:", deque)
print("Первый элемент:", deque.peekFront())
print("Последний элемент:", deque.peekBack())
deque.popFront()
deque.popBack()
print("После удаления:", deque)
deque.pushBack(30)
deque.pushFront(1)
deque.pushBack(50)
print("Итоговое состояние дека:", deque)
print("Размер дека:", deque.size())
```

    
    === Дек на связном списке ===
    Добавлено в конец: 10
    Добавлено в конец: 20
    Добавлено в начало: 5
    Содержимое дека: 5 <-> 10 <-> 20
    Первый элемент: 5
    Последний элемент: 20
    Удалено из начала: 5
    Удалено из конца: 20
    После удаления: 10
    Добавлено в конец: 30
    Добавлено в начало: 1
    Добавлено в конец: 50
    Итоговое состояние дека: 1 <-> 10 <-> 30 <-> 50
    Размер дека: 4
    

## Задание 2
Используя операции со стеком, написать программу, проверяющую своевременность закрытия скобок «(, ), [, ], {, }» в строке символов.


```python
def check_brackets(expression):
    stack = []
    brackets = {')': '(', ']': '[', '}': '{'}
    
    for char in expression:
        if char in '([{':
            stack.append(char)
        elif char in ')]}':
            if not stack:
                return False, f"Ошибка: лишняя закрывающая скобка '{char}'"
            
            last_open = stack.pop()
            
            if brackets[char] != last_open:
                return False, f"Ошибка: несоответствие скобок '{last_open}' и '{char}'"
    
    if stack:
        return False, f"Ошибка: не закрыты скобки {stack}"
    
    return True, "Скобки расставлены корректно"

print("\n=== Проверка скобок ===")
test_cases = [
    "()",
    "()[]{}",
    "([{}])",
    "((()))",
    "([)]",
    "(()",
    "())",
    "{[]}"
]

for test in test_cases:
    is_valid, message = check_brackets(test)
    print(f"'{test}': {message}")
```

    
    === Проверка скобок ===
    '()': Скобки расставлены корректно
    '()[]{}': Скобки расставлены корректно
    '([{}])': Скобки расставлены корректно
    '((()))': Скобки расставлены корректно
    '([)]': Ошибка: несоответствие скобок '[' и ')'
    '(()': Ошибка: не закрыты скобки ['(']
    '())': Ошибка: лишняя закрывающая скобка ')'
    '{[]}': Скобки расставлены корректно
    

## Задание 3
Написать программу вычисления значения выражения, представленного в обратной польской записи (постфиксной записи).


```python
def evaluate_postfix(expression):
    stack = []
    operators = {
        '+': lambda x, y: x + y,
        '-': lambda x, y: x - y,
        '*': lambda x, y: x * y,
        '/': lambda x, y: x / y
    }
    
    for token in expression.split():
        if token.isdigit():
            stack.append(int(token))
        elif token in operators:
            if len(stack) < 2:
                raise ValueError("Недостаточно операндов для операции")
            
            y = stack.pop()
            x = stack.pop()
            
            result = operators[token](x, y)
            stack.append(result)
            print(f"Выполнено: {x} {token} {y} = {result}")
        else:
            raise ValueError(f"Неизвестный токен: {token}")
    
    if len(stack) != 1:
        raise ValueError("Некорректное выражение")
    
    return stack[0]

print("\n=== Вычисление постфиксных выражений ===")
postfix_expressions = [
    "3 4 +",
    "5 2 * 3 +",
    "10 5 - 2 *",
    "4 2 / 1 +",
    "3 4 2 * 1 5 - / +"
]

for expr in postfix_expressions:
    try:
        result = evaluate_postfix(expr)
        print(f"'{expr}' = {result}")
    except Exception as e:
        print(f"Ошибка в выражении '{expr}': {e}")
```

    
    === Вычисление постфиксных выражений ===
    Выполнено: 3 + 4 = 7
    '3 4 +' = 7
    Выполнено: 5 * 2 = 10
    Выполнено: 10 + 3 = 13
    '5 2 * 3 +' = 13
    Выполнено: 10 - 5 = 5
    Выполнено: 5 * 2 = 10
    '10 5 - 2 *' = 10
    Выполнено: 4 / 2 = 2.0
    Выполнено: 2.0 + 1 = 3.0
    '4 2 / 1 +' = 3.0
    Выполнено: 4 * 2 = 8
    Выполнено: 1 - 5 = -4
    Выполнено: 8 / -4 = -2.0
    Выполнено: 3 + -2.0 = 1.0
    '3 4 2 * 1 5 - / +' = 1.0
    
