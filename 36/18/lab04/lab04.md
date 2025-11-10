# Л.Р. 4 - "Стек, Очередь, Дек"

**Цао М.М.**

**ИУ10-36**



### Задания
### Задание 1

**Реализовать стек на основе массива.**
```python
class ArrayStack(Stack):
    def __init__(self):
        self._items = []  # Используем список для хранения элементов
    
    def push(self, item):
        self._items.append(item)  # Добавляем в конец - O(1)
    
    def pop(self):
        if self.is_empty():
            raise IndexError("Стек пуст")
        return self._items.pop()  # Удаляем с конца - O(1)
```

**Реализовать стек на основе связного списка.**
```python
class LinkedListStack(Stack):
    def __init__(self):
        self.head = None  # Вершина стека - голова списка
    
    def push(self, item):
        new_node = Node(item)
        new_node.next = self.head  # Новый узел ссылается на старую вершину
        self.head = new_node       # Новый узел становится вершиной
```

**Реализовать очередь на основе массива.**
```python
class ArrayQueue(Queue):
    def enqueue(self, item):
        self._items.append(item)    # Добавляем в конец - O(1)
    
    def dequeue(self):
        if self.is_empty():
            raise IndexError("Очередь пуста")
        return self._items.pop(0)   # Удаляем из начала - O(n)
```

**Реализовать очередь на основе связного списка.**
```python
class LinkedListQueue(Queue):
    def enqueue(self, item):
        new_node = Node(item)
        if self.is_empty():
            self.head = self.tail = new_node  # Первый элемент
        else:
            self.tail.next = new_node  # Добавляем после хвоста
            self.tail = new_node       # Обновляем хвост
```

**Реализовать дек на основе массива.**
```python
class ArrayDeque(Deque):
    def push_front(self, item):
        self._items.insert(0, item)  # Вставляем в начало - O(n)
    
    def push_back(self, item):
        self._items.append(item)     # Добавляем в конец - O(1)
```

**Реализовать дек на основе связного списка.**
```python
class LinkedListDeque(Deque):
    def push_front(self, item):
        new_node = DoublyNode(item)
        if self.is_empty():
            self.head = self.tail = new_node
        else:
            new_node.next = self.head  # Связываем с текущей головой
            self.head.prev = new_node
            self.head = new_node       # Обновляем голову
```


### Задание 2
**Используя операции со стеком, написать программу, проверяющую своевременность закрытия скобок «(, ), [, ] ,{, }» в строке символов (строка состоит из одних скобок этих типов).**

```python
def check_brackets(expression):
    stack = ArrayStack()
    brackets = {'(': ')', '[': ']', '{': '}'}
    
    for char in expression:
        if char in brackets.keys():    # Открывающая скобка
            stack.push(char)           # Кладем в стек
        elif char in brackets.values(): # Закрывающая скобка
            if stack.is_empty():       # Проверка на лишнюю закрывающую
                return False
            top = stack.pop()          # Берем последнюю открывающую
            if brackets[top] != char:  # Проверяем соответствие
                return False
    
    return stack.is_empty()  # Проверяем, все ли скобки закрыты
```

**Алгоритм: Открывающие скобки сохраняются в стеке. При встрече закрывающей скобки проверяется соответствие с последней открывающей. В конце стек должен быть пуст.**

### Задание 3
**Написать программу вычисления значения выражения, представленного в обратной польской записи (в постфиксной записи). Выражение состоит из цифр от 1 до 9 и знаков операции.**

```python
def evaluate_postfix(expression):
    stack = ArrayStack()
    operators = {
        '+': lambda x, y: x + y,
        '-': lambda x, y: x - y, 
        '*': lambda x, y: x * y,
        '/': lambda x, y: x / y
    }
    
    for token in expression.split():
        if token.isdigit():        # Операнд
            stack.push(int(token))
        elif token in operators:   # Оператор
            b = stack.pop()        # Правый операнд
            a = stack.pop()        # Левый операнд
            result = operators[token](a, b)
            stack.push(result)     # Результат обратно в стек
    
    return stack.pop()  # Финальный результат
```

### Задание 4
**Реализовать перевод математических выражений из инфиксной в постфиксную форму записи.**

```python
def infix_to_postfix(expression):
    stack = ArrayStack()
    output = []
    precedence = {'+': 1, '-': 1, '*': 2, '/': 2}  # Приоритеты
    
    i = 0
    while i < len(expression):
        char = expression[i]
        if char == ' ':
            i += 1
            continue
        
        if char.isalnum():          # Операнд
            output.append(char)     # Сразу в выход
        elif char == '(':           # Открывающая скобка
            stack.push(char)        # В стек
        elif char == ')':           # Закрывающая скобка
            while stack.peek() != '(':  # Выталкиваем до открывающей
                output.append(stack.pop())
            stack.pop()             # Удаляем '('
        elif char in precedence:    # Оператор
            # Выталкиваем операторы с высшим приоритетом
            while (not stack.is_empty() and 
                   precedence.get(stack.peek(), 0) >= precedence[char]):
                output.append(stack.pop())
            stack.push(char)        # Текущий оператор в стек
        i += 1
    
    # Выталкиваем оставшиеся операторы
    while not stack.is_empty():
        output.append(stack.pop())
    
    return ' '.join(output)
```
**Алгоритм: Операнды сразу в выходную строку. Операторы помещаются в стек и выталкиваются согласно приоритету. Скобки управляют порядком выталкивания.**

**Выводы:**
1) Структуры данных успешно реализованы в двух вариантах (массивы и списки) с соблюдением принципов ООП
2) Алгоритмы демонстрируют практическое применение стеков для решения реальных задач
3) Эффективность различных реализаций соответствует теоретическим ожиданиям
4) Полученные навыки позволяют решать широкий класс алгоритмических задач

