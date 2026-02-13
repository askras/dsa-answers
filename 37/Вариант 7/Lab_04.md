# Стек, Очередь, Дек
Фомин И.Н.
ИУ10-37
## Задания
### Задание 1
### 1. Реализовать стек на основе массива


```python
class Stack:
    def __init__(self, capacity=100):
        """Инициализация стека с заданной ёмкостью"""
        self.capacity = capacity
        self.array = [None] * capacity
        self.top_index = -1 

    def isEmpty(self):
        """Проверка стека на пустоту"""
        return self.top_index == -1

    def isFull(self):
        """Проверка стека на переполнение"""
        return self.top_index == self.capacity - 1

    def push(self, value):
        """Добавление элемента на вершину стека"""
        if self.isFull():
            raise OverflowError("Стек переполнен")
        self.top_index += 1
        self.array[self.top_index] = value
        print(f"Добавлено: {value}")

    def pop(self):
        """Удаление и возврат элемента с вершины стека"""
        if self.isEmpty():
            raise IndexError("Стек пуст")
        value = self.array[self.top_index]
        self.array[self.top_index] = None
        self.top_index -= 1
        print(f"Удалено: {value}")
        return value

    def peek(self):
        """Возврат элемента с вершины стека без удаления"""
        if self.isEmpty():
            raise IndexError("Стек пуст")
        return self.array[self.top_index]

    def size(self):
        """Количество элементов в стеке"""
        return self.top_index + 1


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

    Добавлено: 10
    Добавлено: 20
    Добавлено: 30
    Верхний элемент: 30
    Размер стека: 3
    Удалено: 30
    Удалено: 20
    Удалено: 10
    Стек пуст? True


### 2. Реализовать стек на основе связного списка.


```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedListStack:
    def __init__(self):
        self.head = None

    def isEmpty(self):
        """Проверка стека на пустоту"""
        return self.head is None

    def push(self, value):
        """Добавление элемента на вершину стека"""
        new_node = Node(value)
        new_node.next = self.head
        self.head = new_node
        print(f"Добавлено: {value}")

    def pop(self):
        """Удаление и возврат элемента с вершины стека"""
        if self.isEmpty():
            raise IndexError("Стек пуст")
        value = self.head.data
        self.head = self.head.next
        print(f"Удалено: {value}")
        return value

    def peek(self):
        """Возврат элемента с вершины стека без удаления"""
        if self.isEmpty():
            raise IndexError("Стек пуст")
        return self.head.data

    def size(self):
        """Количество элементов в стеке"""
        count = 0
        current = self.head
        while current:
            count += 1
            current = current.next
        return count


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

    Добавлено: 5
    Добавлено: 15
    Добавлено: 25
    Верхний элемент: 25
    Размер стека: 3
    Удалено: 25
    Удалено: 15
    Удалено: 5
    Стек пуст? True


### 3. Реализовать очередь на основе массива.


```python
class ArrayQueue:
    def __init__(self, capacity=100):
        """Инициализация очереди с заданной ёмкостью"""
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
        """Добавление элемента в конец очереди"""
        if self.isFull():
            raise OverflowError("Очередь переполнена")
        self.array[self.tail] = value
        self.tail = (self.tail + 1) % self.capacity  # кольцевой переход
        self.size_count += 1
        print(f"Добавлено: {value}")

    def dequeue(self):
        """Удаление и возврат элемента из начала очереди"""
        if self.isEmpty():
            raise IndexError("Очередь пуста")
        value = self.array[self.head]
        self.array[self.head] = None
        self.head = (self.head + 1) % self.capacity
        self.size_count -= 1
        print(f"Удалено: {value}")
        return value

    def peek(self):
        """Возврат элемента из начала очереди без удаления"""
        if self.isEmpty():
            raise IndexError("Очередь пуста")
        return self.array[self.head]

    def size(self):
        """Количество элементов в очереди"""
        return self.size_count


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


### 4. Реализовать очередь на основе связного списка.


```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None


class LinkedListQueue:
    def __init__(self):
        self.head = None
        self.tail = None
        self.size_count = 0 

    def isEmpty(self):
        """Проверка очереди на пустоту"""
        return self.head is None

    def enqueue(self, value):
        """Добавление элемента в конец очереди"""
        new_node = Node(value)
        if self.isEmpty():
            self.head = self.tail = new_node
        else:
            self.tail.next = new_node
            self.tail = new_node
        self.size_count += 1
        print(f"Добавлено: {value}")

    def dequeue(self):
        """Удаление и возврат элемента из начала очереди"""
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
        """Просмотр элемента из начала очереди без удаления"""
        if self.isEmpty():
            raise IndexError("Очередь пуста")
        return self.head.data

    def size(self):
        """Возвращает количество элементов в очереди"""
        return self.size_count


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


#### 5. Реализовать дек на основе массива.


```python
class ArrayDeque:
    def __init__(self, capacity=10):
        """Создание дека фиксированного размера (по умолчанию 10)."""
        self.capacity = capacity
        self.deque = [None] * capacity
        self.front = 0 # индекс первого элемента
        self.rear = -1 # индекс последнего элемента
        self.size = 0

    def isEmpty(self):
        """Проверка дека на пустоту"""
        return self.size == 0

    def isFull(self):
        """Проверка дека на заполненность"""
        return self.size == self.capacity

    def pushFront(self, value):
        """Добавление элемента в начало дека"""
        if self.isFull():
            raise OverflowError("Дек переполнен")
        self.front = (self.front - 1 + self.capacity) % self.capacity
        self.deque[self.front] = value
        self.size += 1
        print(f"Добавлено в начало: {value}")

        if self.size == 1:
            self.rear = self.front

    def pushBack(self, value):
        """Добавление элемента в конец дека"""
        if self.isFull():
            raise OverflowError("Дек переполнен")
        self.rear = (self.rear + 1) % self.capacity
        self.deque[self.rear] = value
        self.size += 1
        print(f"Добавлено в конец: {value}")

        if self.size == 1:
            self.front = self.rear

    def popFront(self):
        """Удаление элемента из начала дека"""
        if self.isEmpty():
            raise IndexError("Дек пуст")
        value = self.deque[self.front]
        self.deque[self.front] = None
        self.front = (self.front + 1) % self.capacity
        self.size -= 1
        print(f"Удалено из начала: {value}")
        return value

    def popBack(self):
        """Удаление элемента из конца дека"""
        if self.isEmpty():
            raise IndexError("Дек пуст")
        value = self.deque[self.rear]
        self.deque[self.rear] = None
        self.rear = (self.rear - 1 + self.capacity) % self.capacity
        self.size -= 1
        print(f"Удалено из конца: {value}")
        return value

    def peekFront(self):
        """Просмотр первого элемента без удаления"""
        if self.isEmpty():
            raise IndexError("Дек пуст")
        return self.deque[self.front]

    def peekBack(self):
        """Просмотр последнего элемента без удаления"""
        if self.isEmpty():
            raise IndexError("Дек пуст")
        return self.deque[self.rear]

    def __str__(self):
        """Отображение содержимого дека"""
        if self.isEmpty():
            return "Дек пуст"
        result = []
        index = self.front
        for _ in range(self.size):
            result.append(str(self.deque[index]))
            index = (index + 1) % self.capacity
        return " <- ".join(result)
    

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


#### 6. Реализовать дек на основе связного списка.


```python
class Node:
    def __init__(self, data):
        self.data = data
        self.prev = None
        self.next = None


class LinkedListDeque:
    def __init__(self):
        self.head = None
        self.tail = None
        self.size_count = 0

    def isEmpty(self):
        """Проверка дека на пустоту"""
        return self.head is None

    def size(self):
        """Возвращает количество элементов"""
        return self.size_count

    def pushFront(self, value):
        """Добавление элемента в начало дека"""
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
        """Добавление элемента в конец дека"""
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
        """Удаление и возврат элемента из начала дека"""
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
        """Удаление и возврат элемента из конца дека"""
        if self.isEmpty():
            raise IndexError("Дек пуст")
        value = self.tail.data
        self.tail = self.tail.prev
        if self.tail is not None:
            self.tail.next = None
        else:
            # если дек стал пуст
            self.head = None
        self.size_count -= 1
        print(f"Удалено из конца: {value}")
        return value

    def peekFront(self):
        """Просмотр первого элемента без удаления"""
        if self.isEmpty():
            raise IndexError("Дек пуст")
        return self.head.data

    def peekBack(self):
        """Просмотр последнего элемента без удаления"""
        if self.isEmpty():
            raise IndexError("Дек пуст")
        return self.tail.data

    def __str__(self):
        """Вывод дека как строки"""
        if self.isEmpty():
            return "Дек пуст"
        result = []
        current = self.head
        while current:
            result.append(str(current.data))
            current = current.next
        return " <-> ".join(result)


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


### Задание 2


```python
class Stack:
    """Реализация стека на массиве"""
    def __init__(self):
        self.items = []

    def push(self, item):
        self.items.append(item)

    def pop(self):
        if self.is_empty():
            raise IndexError("Попытка извлечь элемент из пустого стека")
        return self.items.pop()

    def peek(self):
        if self.is_empty():
            return None
        return self.items[-1]

    def is_empty(self):
        return len(self.items) == 0


def check_brackets(sequence):
    stack = Stack()
    pairs = {')': '(', ']': '[', '}': '{'}
    error = False

    for char in sequence:
        if char in "([{":
            stack.push(char)
        elif char in ")]}":
            if stack.is_empty():
                error = True
                print(f"Ошибка: закрывающая скобка '{char}' не имеет пары.")
                break
            top = stack.pop()
            if pairs[char] != top:
                error = True
                print(f"Ошибка: ожидалась '{pairs[char]}', а встретилась '{char}'.")
                break
        else:
            print(f"Ошибка: недопустимый символ '{char}' в строке.")
            error = True
            break

    if not error and not stack.is_empty():
        print("Ошибка: остались незакрытые скобки.")
        error = True

    if not error:
        print("Скобки расставлены корректно.")
        return True
    else:
        print("Скобки расставлены неправильно.")
        return False


tests = [
    "([]{})",
    "([)]",
    "((()",
    "{[()]}",
    "}{",
    ""
]

for seq in tests:
    print(f"\nПроверка строки: {seq}")
    check_brackets(seq)

```

    
    Проверка строки: ([]{})
    Скобки расставлены корректно.
    
    Проверка строки: ([)]
    Ошибка: ожидалась '(', а встретилась ')'.
    Скобки расставлены неправильно.
    
    Проверка строки: ((()
    Ошибка: остались незакрытые скобки.
    Скобки расставлены неправильно.
    
    Проверка строки: {[()]}
    Скобки расставлены корректно.
    
    Проверка строки: }{
    Ошибка: закрывающая скобка '}' не имеет пары.
    Скобки расставлены неправильно.
    
    Проверка строки: 
    Скобки расставлены корректно.


### Задание 3


```python
class Stack:
    """Реализация стека на основе массива"""
    def __init__(self):
        self.items = []

    def push(self, item):
        self.items.append(item)

    def pop(self):
        if self.is_empty():
            raise IndexError("Ошибка: попытка извлечь элемент из пустого стека.")
        return self.items.pop()

    def peek(self):
        if self.is_empty():
            return None
        return self.items[-1]

    def is_empty(self):
        return len(self.items) == 0


def evaluate_postfix(expression):
    stack = Stack()
    operators = {'+', '-', '*', '/'}

    tokens = expression.split()

    for token in tokens:
        if token.isdigit():
            stack.push(int(token))
        elif token in operators:
            if len(stack.items) < 2:
                raise ValueError("Ошибка: недостаточно операндов в стеке для операции.")
            b = stack.pop()
            a = stack.pop()

            if token == '+':
                result = a + b
            elif token == '-':
                result = a - b
            elif token == '*':
                result = a * b
            elif token == '/':
                if b == 0:
                    raise ZeroDivisionError("Ошибка: деление на ноль.")
                result = a / b

            stack.push(result)
        else:
            raise ValueError(f"Ошибка: недопустимый символ '{token}'.")

    if len(stack.items) != 1:
        raise ValueError("Ошибка: некорректное выражение (в стеке осталось несколько элементов).")

    return stack.pop()


examples = {
    "2 3 +": "(2 + 3)",
    "2 3 + 4 *": "(2 + 3) * 4",
    "5 1 2 + 4 * + 3 -": "5 + ((1 + 2) * 4) - 3",
    "7 2 3 * -": "7 - (2 * 3)",
    "8 4 / 2 * 3 +": "((8 / 4) * 2) + 3"
}

for expr, desc in examples.items():
    print(f"\nВыражение: {desc}")
    print(f"Постфиксная форма: {expr}")
    result = evaluate_postfix(expr)
    print(f"Результат: {result}")

```

    
    Выражение: (2 + 3)
    Постфиксная форма: 2 3 +
    Результат: 5
    
    Выражение: (2 + 3) * 4
    Постфиксная форма: 2 3 + 4 *
    Результат: 20
    
    Выражение: 5 + ((1 + 2) * 4) - 3
    Постфиксная форма: 5 1 2 + 4 * + 3 -
    Результат: 14
    
    Выражение: 7 - (2 * 3)
    Постфиксная форма: 7 2 3 * -
    Результат: 1
    
    Выражение: ((8 / 4) * 2) + 3
    Постфиксная форма: 8 4 / 2 * 3 +
    Результат: 7.0


### Задание 4


```python
class Stack:
    """Реализация стека на массиве"""
    def __init__(self):
        self.items = []

    def push(self, item):
        self.items.append(item)

    def pop(self):
        if self.is_empty():
            raise IndexError("Попытка извлечь элемент из пустого стека.")
        return self.items.pop()

    def peek(self):
        if self.is_empty():
            return None
        return self.items[-1]

    def is_empty(self):
        return len(self.items) == 0


def infix_to_postfix(expression):
    stack = Stack()
    result = []

    precedence = {'+': 1, '-': 1, '*': 2, '/': 2, '^': 3}

    operators = set(precedence.keys())

    expression = expression.replace(" ", "")

    for token in expression:
        if token.isalnum():
            result.append(token)
        elif token == '(':
            stack.push(token)
        elif token == ')':
            while not stack.is_empty() and stack.peek() != '(':
                result.append(stack.pop())
            if stack.is_empty():
                raise ValueError("Ошибка: лишняя закрывающая скобка.")
            stack.pop()
        elif token in operators:
            while (not stack.is_empty() and stack.peek() in operators and
                   precedence[stack.peek()] >= precedence[token]):
                result.append(stack.pop())
            stack.push(token)
        else:
            raise ValueError(f"Ошибка: недопустимый символ '{token}' в выражении.")

    while not stack.is_empty():
        top = stack.pop()
        if top in "()":
            raise ValueError("Ошибка: несбалансированные скобки.")
        result.append(top)

    return " ".join(result)


examples = [
    "A + B * C",
    "(A + B) * C",
    "A + (B + C) * D",
    "(A + B) * (C + D)",
    "A + B * (C - D) / E"
]

for expr in examples:
    postfix = infix_to_postfix(expr)
    print(f"\nИнфиксная форма: {expr}")
    print(f"Постфиксная форма: {postfix}")

```

    
    Инфиксная форма: A + B * C
    Постфиксная форма: A B C * +
    
    Инфиксная форма: (A + B) * C
    Постфиксная форма: A B + C *
    
    Инфиксная форма: A + (B + C) * D
    Постфиксная форма: A B C + D * +
    
    Инфиксная форма: (A + B) * (C + D)
    Постфиксная форма: A B + C D + *
    
    Инфиксная форма: A + B * (C - D) / E
    Постфиксная форма: A B C D - * E / +

