---
jupytext:
  formats: ipynb,md:myst
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.17.3
kernelspec:
  name: python3
  display_name: Python 3 (ipykernel)
  language: python
---

# Стек, Очередь, Дек


### Цель работы

Изучение структур данных &laquo;Стек&raquo;, &laquo;Очередь&raquo;, &laquo;Дек&raquo;, а также основных операций над ними.

+++

## Задание 1

### Базовый класс для стека

```{code-cell} ipython3
class StackBase:
    def push(self, item):
        raise NotImplementedError("Метод push должен быть реализован")
    
    def pop(self):
        raise NotImplementedError("Метод pop должен быть реализован")
    
    def peek(self):
        raise NotImplementedError("Метод peek должен быть реализован")
    
    def is_empty(self):
        raise NotImplementedError("Метод is_empty должен быть реализован")
    
    def size(self):
        raise NotImplementedError("Метод size должен быть реализован")
```

### Базовый класс для очереди

```{code-cell} ipython3
class QueueBase:
    def enqueue(self, item):
        raise NotImplementedError("Метод enqueue должен быть реализован")
    
    def dequeue(self):
        raise NotImplementedError("Метод dequeue должен быть реализован")
    
    def front(self):
        raise NotImplementedError("Метод front должен быть реализован")
    
    def is_empty(self):
        raise NotImplementedError("Метод is_empty должен быть реализован")
    
    def size(self):
        raise NotImplementedError("Метод size должен быть реализован")
```

### Базовый класс для дека (двусторонней очереди)

```{code-cell} ipython3
class DequeBase:
    def add_front(self, item):
        raise NotImplementedError("Метод add_front должен быть реализован")
    
    def add_rear(self, item):
        raise NotImplementedError("Метод add_rear должен быть реализован")
    
    def remove_front(self):
        raise NotImplementedError("Метод remove_front должен быть реализован")
    
    def remove_rear(self):
        raise NotImplementedError("Метод remove_rear должен быть реализован")
    
    def peek_front(self):
        raise NotImplementedError("Метод peek_front должен быть реализован")
    
    def peek_rear(self):
        raise NotImplementedError("Метод peek_rear должен быть реализован")
    
    def is_empty(self):
        raise NotImplementedError("Метод is_empty должен быть реализован")
    
    def size(self):
        raise NotImplementedError("Метод size должен быть реализован")
```

### Стек на основе массива

```{code-cell} ipython3
class ArrayStack(StackBase):
    def __init__(self):
        self._items = []
    
    def push(self, item):
        self._items.append(item)
    
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
        return f"ArrayStack({self._items})"
```

### Стек на основе связного списка

```{code-cell} ipython3
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None


class LinkedListStack(StackBase):
    def __init__(self):
        self._top = None
        self._size = 0
    
    def push(self, item):
        new_node = Node(item)
        new_node.next = self._top
        self._top = new_node
        self._size += 1
    
    def pop(self):
        if self.is_empty():
            raise IndexError("Стек пуст")
        
        data = self._top.data
        self._top = self._top.next
        self._size -= 1
        return data
    
    def peek(self):
        if self.is_empty():
            raise IndexError("Стек пуст")
        return self._top.data
    
    def is_empty(self):
        return self._top is None
    
    def size(self):
        return self._size
    
    def __str__(self):
        items = []
        current = self._top
        while current:
            items.append(current.data)
            current = current.next
        return f"LinkedListStack({items})"
```

### Очередь на основе массива

```{code-cell} ipython3
class ArrayQueue(QueueBase):
    def __init__(self):
        self._items = []
    
    def enqueue(self, item):
        self._items.append(item)
    
    def dequeue(self):
        if self.is_empty():
            raise IndexError("Очередь пуста")
        return self._items.pop(0)
    
    def front(self):
        if self.is_empty():
            raise IndexError("Очередь пуста")
        return self._items[0]
    
    def is_empty(self):
        return len(self._items) == 0
    
    def size(self):
        return len(self._items)
    
    def __str__(self):
        return f"ArrayQueue({self._items})"
```

### Очередь на основе связного списка

```{code-cell} ipython3
class LinkedListQueue(QueueBase):
    def __init__(self):
        self._front = None
        self._rear = None
        self._size = 0
    
    def enqueue(self, item):
        new_node = Node(item)
        
        if self.is_empty():
            self._front = self._rear = new_node
        else:
            self._rear.next = new_node
            self._rear = new_node
        
        self._size += 1
    
    def dequeue(self):
        if self.is_empty():
            raise IndexError("Очередь пуста")
        
        data = self._front.data
        self._front = self._front.next
        
        if self._front is None:
            self._rear = None
        
        self._size -= 1
        return data
    
    def front(self):
        if self.is_empty():
            raise IndexError("Очередь пуста")
        return self._front.data
    
    def is_empty(self):
        return self._front is None
    
    def size(self):
        return self._size
    
    def __str__(self):
        items = []
        current = self._front
        while current:
            items.append(current.data)
            current = current.next
        return f"LinkedListQueue({items})"
```

### Дек на основе массива

```{code-cell} ipython3
class ArrayDeque(DequeBase):
    def __init__(self):
        self._items = []
    
    def add_front(self, item):
        self._items.insert(0, item)
    
    def add_rear(self, item):
        self._items.append(item)
    
    def remove_front(self):
        if self.is_empty():
            raise IndexError("Дек пуст")
        return self._items.pop(0)
    
    def remove_rear(self):
        if self.is_empty():
            raise IndexError("Дек пуст")
        return self._items.pop()
    
    def peek_front(self):
        if self.is_empty():
            raise IndexError("Дек пуст")
        return self._items[0]
    
    def peek_rear(self):
        if self.is_empty():
            raise IndexError("Дек пуст")
        return self._items[-1]
    
    def is_empty(self):
        return len(self._items) == 0
    
    def size(self):
        return len(self._items)
    
    def __str__(self):
        return f"ArrayDeque({self._items})"
```

### Дек на основе связного списка

```{code-cell} ipython3
class LinkedListDeque(DequeBase):
    def __init__(self):
        self._front = None
        self._rear = None
        self._size = 0
    
    def add_front(self, item):
        new_node = Node(item)
        
        if self.is_empty():
            self._front = self._rear = new_node
        else:
            new_node.next = self._front
            self._front = new_node
        
        self._size += 1
    
    def add_rear(self, item):
        new_node = Node(item)
        
        if self.is_empty():
            self._front = self._rear = new_node
        else:
            self._rear.next = new_node
            self._rear = new_node
        
        self._size += 1
    
    def remove_front(self):
        if self.is_empty():
            raise IndexError("Дек пуст")
        
        data = self._front.data
        self._front = self._front.next
        
        if self._front is None:
            self._rear = None
        
        self._size -= 1
        return data
    
    def remove_rear(self):
        if self.is_empty():
            raise IndexError("Дек пуст")
        
        if self._front == self._rear:
            data = self._front.data
            self._front = self._rear = None
        else:
            current = self._front
            while current.next != self._rear:
                current = current.next
            
            data = self._rear.data
            current.next = None
            self._rear = current
        
        self._size -= 1
        return data
    
    def peek_front(self):
        if self.is_empty():
            raise IndexError("Дек пуст")
        return self._front.data
    
    def peek_rear(self):
        if self.is_empty():
            raise IndexError("Дек пуст")
        return self._rear.data
    
    def is_empty(self):
        return self._front is None
    
    def size(self):
        return self._size
    
    def __str__(self):
        items = []
        current = self._front
        while current:
            items.append(current.data)
            current = current.next
        return f"LinkedListDeque({items})"
```

## Задание 2

```{code-cell} ipython3
def check_brackets_balance(bracket_string):
    stack = ArrayStack()
    bracket_pairs = {')': '(', ']': '[', '}': '{'}
    opening_brackets = set(bracket_pairs.values())
    closing_brackets = set(bracket_pairs.keys())
    
    for position, char in enumerate(bracket_string, 1):
        if char in opening_brackets:
            # Открывающая скобка - добавляем в стек
            stack.push((char, position))
        
        elif char in closing_brackets:
            # Закрывающая скобка - проверяем соответствие
            if stack.is_empty():
                return False, f"Ошибка: закрывающая скобка '{char}' без соответствующей открывающей на позиции {position}", position
            
            last_opening_bracket, opening_position = stack.pop()
            expected_opening_bracket = bracket_pairs[char]
            
            if last_opening_bracket != expected_opening_bracket:
                return False, f"Ошибка: ожидалась закрывающая скобка для '{last_opening_bracket}', но получена '{char}' на позиции {position}", position
    
    # После обработки всех символов проверяем, не остались ли открытые скобки
    if not stack.is_empty():
        last_opening_bracket, opening_position = stack.pop()
        return False, f"Ошибка: не закрыта скобка '{last_opening_bracket}' на позиции {opening_position}", opening_position
    
    return True, "Скобки расставлены правильно", -1

def bracket_checking():
    print("Введите строку из скобок (, ), [, ], {, } для проверки")
    print("Для выхода введите 'quit'\n")
    
    while True:
        user_input = input("Введите строку скобок: ").strip()
        
        if user_input.lower() == 'quit':
            print("Выход из программы.")
            break
        
        if not all(char in '()[]{}' for char in user_input):
            print("Ошибка: строка должна содержать только скобки (, ), [, ], {, }")
            print()
            continue
        
        is_balanced, message, error_pos = check_brackets_balance(user_input)
        
        print(f"Результат: {message}")
        
        if not is_balanced and error_pos != -1 and user_input:
            pointer = " " * (error_pos - 1) + "^"
            print(f"Строка:    {user_input}")
            print(f"Указатель: {pointer}")
        
        print()


if __name__ == "__main__":
    bracket_checking()
```

## Задание 3

```{code-cell} ipython3
def evaluate_postfix(expression):
    stack = ArrayStack()
    operators = {'+', '-', '*', '/'}
    
    for char in expression:
        if char.isdigit():
            # Цифра - добавляем в стек как число
            stack.push(int(char))
        elif char in operators:
            # Оператор - извлекаем два операнда и выполняем операцию
            if stack.size() < 2:
                raise ValueError(f"Недостаточно операндов для операции '{char}'")
            
            operand2 = stack.pop()
            operand1 = stack.pop()
            
            result = perform_operation(operand1, operand2, char)
            stack.push(result)
        elif char.isspace():
            # Пропускаем пробелы
            continue
        else:
            raise ValueError(f"Недопустимый символ: '{char}'")
    
    # После обработки всех символов в стеке должен остаться один элемент
    if stack.size() != 1:
        raise ValueError("Некорректное выражение: в стеке осталось несколько элементов")
    
    return stack.pop()


def perform_operation(operand1, operand2, operator):
    if operator == '+':
        return operand1 + operand2
    elif operator == '-':
        return operand1 - operand2
    elif operator == '*':
        return operand1 * operand2
    elif operator == '/':
        if operand2 == 0:
            raise ValueError("Деление на ноль")
        return operand1 / operand2
    else:
        raise ValueError(f"Неизвестный оператор: {operator}")


def infix_to_postfix(infix_expression):
    stack = ArrayStack()
    output = []
    precedence = {'+': 1, '-': 1, '*': 2, '/': 2}
    
    for char in infix_expression:
        if char.isdigit():
            output.append(char)
        elif char == '(':
            stack.push(char)
        elif char == ')':
            while not stack.is_empty() and stack.peek() != '(':
                output.append(stack.pop())
            stack.pop()  # Удаляем '('
        elif char in precedence:
            while (not stack.is_empty() and stack.peek() != '(' and 
                   precedence.get(stack.peek(), 0) >= precedence[char]):
                output.append(stack.pop())
            stack.push(char)
        elif char.isspace():
            continue
    
    while not stack.is_empty():
        output.append(stack.pop())
    
    return ''.join(output)

def interactive_calculator():
    print("Введите выражение в обратной польской записи")
    print("(например: '23+5*' для (2+3)*5)")
    print("Для выхода введите 'quit'\n")
    
    while True:
        user_input = input("Введите выражение: ").strip()
        
        if user_input.lower() == 'quit':
            print("Выход из программы.")
            break
        
        if not user_input:
            continue
        
        try:
            result = evaluate_postfix(user_input)
            print(f"Результат: {result}")
            
        except Exception as e:
            print(f"Ошибка: {e}")
        
        print()

if __name__ == "__main__":
    interactive_calculator()
```

## Задание 4

```{code-cell} ipython3
def infix_to_postfix(infix_expression):
    stack = ArrayStack()
    output = []
    precedence = {'+': 1, '-': 1, '*': 2, '/': 2}
    
    for char in infix_expression:
        if char.isdigit():
            output.append(char)
        elif char == '(':
            stack.push(char)
        elif char == ')':
            while not stack.is_empty() and stack.peek() != '(':
                output.append(stack.pop())
            stack.pop()  # Удаляем '('
        elif char in precedence:
            while (not stack.is_empty() and stack.peek() != '(' and 
                   precedence.get(stack.peek(), 0) >= precedence[char]):
                output.append(stack.pop())
            stack.push(char)
        elif char.isspace():
            continue
    
    while not stack.is_empty():
        output.append(stack.pop())
    
    return ''.join(output)

def demonstrate_conversion_and_calculation():
    infix_test_cases = [
        ("(2+3)*5", "(2+3)*5"),
        ("2+3*5", "2+3*5"),
        ("(1+2)*(3+4)", "(1+2)*(3+4)"),
        ("8/2/2", "8/2/2"),
        ("3*2+1", "3*2+1"),
    ]
    
    for infix_expr, description in infix_test_cases:
        try:
            postfix_expr = infix_to_postfix(infix_expr)
            result = evaluate_postfix(postfix_expr)
            
            print(f"Инфикс:   {description}")
            print(f"Постфикс: {postfix_expr}")
            print(f"Результат: {result}")
            print("-" * 40)
        except Exception as e:
            print(f"Ошибка для '{description}': {e}")
            print("-" * 40)

if __name__ == "__main__":
    demonstrate_conversion_and_calculation()
```

```{code-cell} ipython3

```
