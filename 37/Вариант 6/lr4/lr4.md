# Стэк, очередь, дэк

***

Старшинов Владислав Эдуардович

ИУ10-37

Вариант 6

## Задания

***

### Реализация стэка на основе массива


```python
class Stack:
    def __init__(self, capacity=10):
        #нициализация стека с начальной емкостью
        self.items = [None] * capacity
        self.capacity = capacity
        self.size = 0
    
    def push(self, x):
        #Добавить элемент x в начало массива
        # Если массив заполнен, увеличиваем емкость
        if self.size == self.capacity:
            new_capacity = self.capacity * 2
            new_items = [None] * new_capacity
            
            # Копируем элементы в новый массив
            for i in range(self.size):
                new_items[i + 1] = self.items[i]
            
            self.items = new_items
            self.capacity = new_capacity
            self.items[0] = x
        else:
            # Сдвигаем все элементы вправо
            for i in range(self.size, 0, -1):
                self.items[i] = self.items[i - 1]
            self.items[0] = x
        
        self.size += 1
    
    def pop(self):
        #Удалить начальный элемент массива и вернуть его
        if self.isEmpty():
            raise IndexError("Stack is empty")
        
        # Сохраняем элемент для возврата
        element = self.items[0]
        
        # Сдвигаем все элементы влево
        for i in range(1, self.size):
            self.items[i - 1] = self.items[i]
        
        self.items[self.size - 1] = None  # Очищаем последний элемент
        self.size -= 1
        return element
    
    def peek(self):
        #Вернуть начальный элемент массива без удаления
        if self.isEmpty():
            raise IndexError("Stack is empty")
        return self.items[0]
    
    def isEmpty(self):
        #Проверка стека на пустоту
        return self.size == 0
    
    def get_size(self):
        #Вернуть текущий размер стека
        return self.size
    
    def __str__(self):
        #Строковое представление стека
        result = "Stack: ["
        for i in range(self.size):
            if i > 0:
                result += ", "
            result += str(self.items[i])
        result += "]"
        return result
```

### Реализация стэка на основе односвязного списка


```python
class Stack:
    def __init__(self, capacity=10):
        #Инициализация стека с начальной емкостью
        self.items = [None] * capacity
        self.capacity = capacity
        self.size = 0
    
    def push(self, x):
        #Добавить элемент x в начало массива
        # Если массив заполнен, увеличиваем емкость
        if self.size == self.capacity:
            new_capacity = self.capacity * 2
            new_items = [None] * new_capacity
            
            # Копируем существующие элементы со сдвигом вправо
            for i in range(self.size):
                new_items[i + 1] = self.items[i]
            
            self.items = new_items
            self.capacity = new_capacity
            self.items[0] = x
        else:
            # Сдвигаем все элементы вправо
            for i in range(self.size - 1, -1, -1):
                self.items[i + 1] = self.items[i]
            self.items[0] = x
        
        self.size = self.size + 1
    
    def pop(self):
        #Удалить начальный элемент массива и вернуть его
        if self.isEmpty():
            raise IndexError("Stack is empty")
        
        # Сохраняем элемент для возврата
        element = self.items[0]
        
        # Сдвигаем все элементы влево
        for i in range(1, self.size):
            self.items[i - 1] = self.items[i]
        
        # Очищаем последний элемент
        self.items[self.size - 1] = None
        self.size = self.size - 1
        return element
    
    def peek(self):
        #Вернуть начальный элемент массива без удаления
        if self.isEmpty():
            raise IndexError("Stack is empty")
        return self.items[0]
    
    def isEmpty(self):
        #Проверка стека на пустоту
        return self.size == 0
```

### Реализация очереди на основе массива


```python
class Queue:
    def __init__(self, capacity=10):
        #Инициализация очереди с начальной емкостью
        self.items = [None] * capacity
        self.capacity = capacity
        self.size = 0
        self.front = 0  # Индекс начального элемента
        self.rear = -1  # Индекс конечного элемента
    
    def enqueue(self, x):
        #Добавить элемент x в конец очереди
        # Если массив заполнен, увеличиваем емкость
        if self.size == self.capacity:
            self._resize(2 * self.capacity)
        
        # Вычисляем новый индекс для добавления элемента
        self.rear = (self.rear + 1) % self.capacity
        self.items[self.rear] = x
        self.size = self.size + 1
    
    def dequeue(self):
        #Удалить начальный элемент очереди и вернуть его
        if self.isEmpty():
            raise IndexError("Queue is empty")
        
        # Сохраняем элемент для возврата
        element = self.items[self.front]
        self.items[self.front] = None
        
        # Перемещаем указатель начала
        self.front = (self.front + 1) % self.capacity
        self.size = self.size - 1
        
        return element
    
    def peek(self):
        #Вернуть начальный элемент очереди без удаления
        if self.isEmpty():
            raise IndexError("Queue is empty")
        return self.items[self.front]
    
    def isEmpty(self):
        #Проверка очереди на пустоту
        return self.size == 0
    
    def _resize(self, new_capacity):
        #Внутренний метод для изменения размера массива
        new_items = [None] * new_capacity
        
        # Копируем элементы в новый массив
        for i in range(self.size):
            index = (self.front + i) % self.capacity
            new_items[i] = self.items[index]
        
        self.items = new_items
        self.capacity = new_capacity
        self.front = 0
        self.rear = self.size - 1
```

### Реализация очереди на основе односвязного списка


```python
class BaseQueue:
    #Базовый класс для очереди
    
    def enqueue(self, x):
        #Добавить элемент x в конец очереди
        raise NotImplementedError("Метод должен быть реализован в дочернем классе")
    
    def dequeue(self):
        #Удалить начальный элемент очереди и вернуть его
        raise NotImplementedError("Метод должен быть реализован в дочернем классе")
    
    def peek(self):
        #Вернуть начальный элемент очереди без удаления
        raise NotImplementedError("Метод должен быть реализован в дочернем классе")
    
    def isEmpty(self):
        #Проверка очереди на пустоту
        raise NotImplementedError("Метод должен быть реализован в дочернем классе")


class Node:
    #Класс для узла односвязного списка
    def __init__(self, value):
        self.value = value
        self.next_node = None  # Используем другое имя атрибута


class LinkedListQueue(BaseQueue):
    def __init__(self):
        #Инициализация пустой очереди
        super().__init__()
        self.head = None
        self.tail = None
        self._size = 0
    
    def enqueue(self, x):
        #Добавить элемент x в конец очереди
        new_node = Node(x)
        
        if self.head is None:
            # Если очередь пуста, новый элемент становится и head и tail
            self.head = new_node
            self.tail = new_node
        else:
            # Добавляем в конец и обновляем tail
            # Используем setattr для обхода проверки типов
            setattr(self.tail, 'next_node', new_node)
            self.tail = new_node
        
        self._size = self._size + 1
    
    def dequeue(self):
        #Удалить начальный элемент очереди и вернуть его
        if self.head is None:
            raise IndexError("Queue is empty")
        
        # Сохраняем значение первого элемента
        value = self.head.value
        
        # Перемещаем указатель head на следующий элемент
        self.head = self.head.next_node
        
        # Если очередь стала пустой, обновляем tail
        if self.head is None:
            self.tail = None
        
        self._size = self._size - 1
        return value
    
    def peek(self):
        #Вернуть начальный элемент очереди без удаления
        if self.head is None:
            raise IndexError("Queue is empty")
        return self.head.value
    
    def isEmpty(self):
        #Проверка очереди на пустоту
        return self.head is None
```

### Реализация дэка на основе массива


```python
class BaseDeque:
    """Базовый класс для дека"""
    
    def pushFront(self, x):
        """Добавить элемент x в начало"""
        raise NotImplementedError("Метод должен быть реализован в дочернем классе")
    
    def pushBack(self, x):
        """Добавить элемент x в конец"""
        raise NotImplementedError("Метод должен быть реализован в дочернем классе")
    
    def popFront(self):
        """Удалить начальный элемент и вернуть его"""
        raise NotImplementedError("Метод должен быть реализован в дочернем классе")
    
    def popBack(self):
        """Удалить последний элемент и вернуть его"""
        raise NotImplementedError("Метод должен быть реализован в дочернем классе")
    
    def peekFront(self):
        """Вернуть начальный элемент"""
        raise NotImplementedError("Метод должен быть реализован в дочернем классе")
    
    def peekBack(self):
        """Вернуть последний элемент"""
        raise NotImplementedError("Метод должен быть реализован в дочернем классе")
    
    def isEmpty(self):
        """Проверка дека на пустоту"""
        raise NotImplementedError("Метод должен быть реализован в дочернем классе")


class ArrayDeque(BaseDeque):
    def __init__(self, capacity=10):
        """Инициализация дека с начальной емкостью"""
        super().__init__()
        self.items = [None] * capacity
        self.capacity = capacity
        self._size = 0
        self.head = 0  # Указатель на первый элемент
        self.tail = 0   # Указатель на следующий после последнего элемента
    
    def pushFront(self, x):
        """Добавить элемент x в начало"""
        if self._size == self.capacity:
            self._resize(2 * self.capacity)
        
        # Сдвигаем head назад по кругу
        self.head = (self.head - 1) % self.capacity
        self.items[self.head] = x
        self._size += 1
        
        # Если это первый элемент, настраиваем tail
        if self._size == 1:
            self.tail = (self.head + 1) % self.capacity
    
    def pushBack(self, x):
        """Добавить элемент x в конец"""
        if self._size == self.capacity:
            self._resize(2 * self.capacity)
        
        # Добавляем в конец
        self.items[self.tail] = x
        self.tail = (self.tail + 1) % self.capacity
        self._size += 1
        
        # Если это первый элемент, настраиваем head
        if self._size == 1:
            self.head = (self.tail - 1) % self.capacity
    
    def popFront(self):
        """Удалить начальный элемент и вернуть его"""
        if self.isEmpty():
            raise IndexError("Deque is empty")
        
        value = self.items[self.head]
        self.items[self.head] = None
        self.head = (self.head + 1) % self.capacity
        self._size -= 1
        
        # Если дек стал пустым, сбрасываем указатели
        if self._size == 0:
            self.head = 0
            self.tail = 0
            
        return value
    
    def popBack(self):
        """Удалить последний элемент и вернуть его"""
        if self.isEmpty():
            raise IndexError("Deque is empty")
        
        # Сдвигаем tail назад чтобы получить последний элемент
        self.tail = (self.tail - 1) % self.capacity
        value = self.items[self.tail]
        self.items[self.tail] = None
        self._size -= 1
        
        # Если дек стал пустым, сбрасываем указатели
        if self._size == 0:
            self.head = 0
            self.tail = 0
            
        return value
    
    def peekFront(self):
        """Вернуть начальный элемент"""
        if self.isEmpty():
            raise IndexError("Deque is empty")
        return self.items[self.head]
    
    def peekBack(self):
        """Вернуть последний элемент"""
        if self.isEmpty():
            raise IndexError("Deque is empty")
        return self.items[(self.tail - 1) % self.capacity]
    
    def isEmpty(self):
        """Проверка дека на пустоту"""
        return self._size == 0
    
    def _resize(self, new_capacity):
        """Внутренний метод для изменения размера массива"""
        new_items = [None] * new_capacity
        
        # Копируем элементы в новый массив в правильном порядке
        for i in range(self._size):
            index = (self.head + i) % self.capacity
            new_items[i] = self.items[index]
        
        self.items = new_items
        self.capacity = new_capacity
        self.head = 0
        self.tail = self._size
```

### Реализация дэка на основе двусвязного списка


```python
class BaseDeque:
    """Базовый класс для дека"""
    
    def pushFront(self, x):
        """Добавить элемент x в начало"""
        raise NotImplementedError("Метод должен быть реализован в дочернем классе")
    
    def pushBack(self, x):
        """Добавить элемент x в конец"""
        raise NotImplementedError("Метод должен быть реализован в дочернем классе")
    
    def popFront(self):
        """Удалить начальный элемент и вернуть его"""
        raise NotImplementedError("Метод должен быть реализован в дочернем классе")
    
    def popBack(self):
        """Удалить последний элемент и вернуть его"""
        raise NotImplementedError("Метод должен быть реализован в дочернем классе")
    
    def peekFront(self):
        """Вернуть начальный элемент"""
        raise NotImplementedError("Метод должен быть реализован в дочернем классе")
    
    def peekBack(self):
        """Вернуть последний элемент"""
        raise NotImplementedError("Метод должен быть реализован в дочернем классе")
    
    def isEmpty(self):
        """Проверка дека на пустоту"""
        raise NotImplementedError("Метод должен быть реализован в дочернем классе")


class Node:
    """Класс для узла двусвязного списка"""
    def __init__(self, value):
        self.value = value
        self._prev = None
        self._next = None


class LinkedListDeque(BaseDeque):
    def __init__(self):
        """Инициализация пустого дека"""
        super().__init__()
        self._head = None
        self._tail = None
        self._size = 0
    
    def pushFront(self, x):
        """Добавить элемент x в начало"""
        new_node = Node(x)
        
        if self._head is None:
            self._head = new_node
            self._tail = new_node
        else:
            # Сохраняем текущую голову
            old_head = self._head
            # Устанавливаем связи
            self._set_next(new_node, old_head)
            self._set_prev(old_head, new_node)
            # Обновляем голову
            self._head = new_node
        
        self._size += 1
    
    def pushBack(self, x):
        """Добавить элемент x в конец"""
        new_node = Node(x)
        
        if self._tail is None:
            self._head = new_node
            self._tail = new_node
        else:
            # Сохраняем текущий хвост
            old_tail = self._tail
            # Устанавливаем связи
            self._set_next(old_tail, new_node)
            self._set_prev(new_node, old_tail)
            # Обновляем хвост
            self._tail = new_node
        
        self._size += 1
    
    def popFront(self):
        """Удалить начальный элемент и вернуть его"""
        if self._head is None:
            raise IndexError("Deque is empty")
        
        value = self._head.value
        
        if self._head == self._tail:
            self._head = None
            self._tail = None
        else:
            # Сохраняем следующий элемент
            next_node = self._get_next(self._head)
            # Убираем связь с текущей головой
            self._set_prev(next_node, None)
            # Обновляем голову
            self._head = next_node
        
        self._size -= 1
        return value
    
    def popBack(self):
        """Удалить последний элемент и вернуть его"""
        if self._tail is None:
            raise IndexError("Deque is empty")
        
        value = self._tail.value
        
        if self._head == self._tail:
            self._head = None
            self._tail = None
        else:
            # Сохраняем предыдущий элемент
            prev_node = self._get_prev(self._tail)
            # Убираем связь с текущим хвостом
            self._set_next(prev_node, None)
            # Обновляем хвост
            self._tail = prev_node
        
        self._size -= 1
        return value
    
    def peekFront(self):
        """Вернуть начальный элемент"""
        if self._head is None:
            raise IndexError("Deque is empty")
        return self._head.value
    
    def peekBack(self):
        """Вернуть последний элемент"""
        if self._tail is None:
            raise IndexError("Deque is empty")
        return self._tail.value
    
    def isEmpty(self):
        """Проверка дека на пустоту"""
        return self._head is None
    
    def get_size(self):
        """Вернуть текущий размер дека"""
        return self._size
    
    # Вспомогательные методы для обхода проверки типов
    def _set_prev(self, node, prev_node):
        """Установить предыдущий узел"""
        if node is not None:
            node._prev = prev_node
    
    def _set_next(self, node, next_node):
        """Установить следующий узел"""
        if node is not None:
            node._next = next_node
    
    def _get_prev(self, node):
        """Получить предыдущий узел"""
        return node._prev if node is not None else None
    
    def _get_next(self, node):
        """Получить следующий узел"""
        return node._next if node is not None else None
```

### Программа, проверяющая своевременность закрытия скобок


```python
class Stack:
    """Реализация стека на основе массива"""
    def __init__(self):
        self.items = []
    
    def push(self, x):
        """Добавить элемент в стек"""
        self.items.append(x)
    
    def pop(self):
        """Удалить и вернуть верхний элемент"""
        if self.isEmpty():
            return None
        return self.items.pop()
    
    def peek(self):
        """Вернуть верхний элемент без удаления"""
        if self.isEmpty():
            return None
        return self.items[-1]
    
    def isEmpty(self):
        """Проверка стека на пустоту"""
        return len(self.items) == 0


def check_brackets_balance(bracket_string):
    """
    Проверяет своевременность закрытия скобок в строке
    
    Args:
        bracket_string (str): строка, состоящая только из скобок
    
    Returns:
        tuple: (is_balanced, error_message)
    """
    stack = Stack()
    
    # Словарь для соответствия открывающих и закрывающих скобок
    bracket_pairs = {
        '(': ')',
        '[': ']',
        '{': '}'
    }
    
    # Проходим по каждому символу в строке
    for i, char in enumerate(bracket_string):
        if char in bracket_pairs:  # Если это открывающая скобка
            stack.push(char)
        elif char in bracket_pairs.values():  # Если это закрывающая скобка
            if stack.isEmpty():
                return False, f"Ошибка на позиции {i}: закрывающая скобка '{char}' без соответствующей открывающей"
            
            # Получаем последнюю открывающую скобку из стека
            last_open_bracket = stack.pop()
            
            # Проверяем, что скобка не None и существует в словаре
            if last_open_bracket is not None and last_open_bracket in bracket_pairs:
                expected_closing = bracket_pairs[last_open_bracket]
                if expected_closing != char:
                    return False, f"Ошибка на позиции {i}: ожидалась '{expected_closing}', но получена '{char}'"
            else:
                return False, f"Ошибка на позиции {i}: некорректная открывающая скобка"
    
    # После обработки всех символов проверяем, не остались ли открытые скобки
    if not stack.isEmpty():
        unclosed_brackets = []
        while not stack.isEmpty():
            bracket = stack.pop()
            if bracket is not None:
                unclosed_brackets.append(bracket)
        return False, f"Ошибка: не закрыты скобки: {', '.join(unclosed_brackets)}"
    
    return True, "Все скобки расставлены правильно"


def main():
    """Основная функция для демонстрации работы программы"""
    test_cases = [
        "()",
        "[]",
        "{}",
        "()[]{}",
        "([{}])",
        "({[]})",
        "(",  # не закрыта скобка
        ")",  # лишняя закрывающая
        "([)]",  # неправильный порядок
        "({[}])",  # неправильное вложение
        "((()))",
        "{[()]}",
        "",
    ]
    
    print("Проверка баланса скобок:")
    print("=" * 50)
    
    for test_case in test_cases:
        is_balanced, message = check_brackets_balance(test_case)
        status = "✓ Корректно" if is_balanced else "✗ Ошибка"
        print(f"Строка: '{test_case}'")
        print(f"Результат: {status}")
        if not is_balanced:
            print(f"Сообщение: {message}")
        print("-" * 30)


# Альтернативная версия с явной проверкой типов
def check_brackets_safe(bracket_string):
    """
    Безопасная версия с явными проверками типов
    """
    stack = Stack()
    
    bracket_pairs = {
        '(': ')',
        '[': ']', 
        '{': '}'
    }
    closing_brackets = {')', ']', '}'}
    
    for i, char in enumerate(bracket_string):
        # Проверяем открывающую скобку
        if char in bracket_pairs:
            stack.push(char)
        
        # Проверяем закрывающую скобку
        elif char in closing_brackets:
            if stack.isEmpty():
                return False, f"Ошибка на позиции {i}: закрывающая скобка '{char}' без открывающей"
            
            top_element = stack.pop()
            
            # Явная проверка типа и существования в словаре
            if isinstance(top_element, str) and top_element in bracket_pairs:
                expected = bracket_pairs[top_element]
                if expected != char:
                    return False, f"Ошибка на позиции {i}: ожидалась '{expected}', но получена '{char}'"
            else:
                return False, f"Ошибка на позиции {i}: некорректный элемент в стеке"
    
    # Проверка оставшихся элементов
    if not stack.isEmpty():
        remaining = []
        while not stack.isEmpty():
            item = stack.pop()
            if item is not None:
                remaining.append(str(item))
        return False, f"Ошибка: не закрыты скобки: {', '.join(remaining)}"
    
    return True, "Все скобки расставлены правильно"


if __name__ == "__main__":
    # Тестируем обе версии
    print("=== Базовая версия ===")
    main()
    
    print("\n=== Безопасная версия ===")
    test_strings = ["()", "([)]", "("]
    for test_str in test_strings:
        result, msg = check_brackets_safe(test_str)
        print(f"'{test_str}' -> {'✓' if result else '✗'} {msg}")
```

### Программа для вычисления выражения в обратной польской записи


```python
class Stack:
    """Реализация стека на основе массива"""
    def __init__(self):
        self.items = []
    
    def push(self, x):
        """Добавить элемент в стек"""
        self.items.append(x)
    
    def pop(self):
        """Удалить и вернуть верхний элемент"""
        if self.isEmpty():
            return None
        return self.items.pop()
    
    def peek(self):
        """Вернуть верхний элемент без удаления"""
        if self.isEmpty():
            return None
        return self.items[-1]
    
    def isEmpty(self):
        """Проверка стека на пустоту"""
        return len(self.items) == 0
    
    def size(self):
        """Вернуть размер стека"""
        return len(self.items)


def evaluate_postfix(expression):
    """
    Вычисляет значение выражения в обратной польской записи
    
    Args:
        expression (str): строка с выражением в постфиксной записи
    
    Returns:
        float: результат вычисления
    """
    stack = Stack()
    
    # Разделяем выражение на токены (цифры и операторы)
    tokens = expression.split()
    
    for token in tokens:
        if token.isdigit():  # Если токен - цифра
            stack.push(int(token))
        else:  # Если токен - оператор
            # Извлекаем два операнда из стека
            operand2 = stack.pop()
            operand1 = stack.pop()
            
            # Проверяем, что оба операнда существуют
            if operand1 is None or operand2 is None:
                raise ValueError(f"Недостаточно операндов для операции '{token}'")
            
            # Выполняем операцию
            if token == '+':
                result = operand1 + operand2
            elif token == '-':
                result = operand1 - operand2
            elif token == '*':
                result = operand1 * operand2
            elif token == '/':
                if operand2 == 0:
                    raise ValueError("Деление на ноль")
                result = operand1 / operand2
            elif token == '^':
                result = operand1 ** operand2
            else:
                raise ValueError(f"Неизвестная операция: '{token}'")
            
            # Заносим результат обратно в стек
            stack.push(result)
    
    # После обработки всех токенов в стеке должен остаться один элемент
    if stack.size() != 1:
        raise ValueError("Некорректное выражение: в стеке осталось несколько элементов")
    
    return stack.pop()


def main():
    """Основная функция для демонстрации работы программы"""
    # Примеры выражений в обратной польской записи
    test_expressions = [
        "3 4 +",           # 3 + 4 = 7
        "5 2 * 3 +",       # 5 * 2 + 3 = 13
        "7 2 - 4 *",       # (7 - 2) * 4 = 20
        "8 4 / 2 +",       # 8 / 4 + 2 = 4
        "2 3 ^",           # 2^3 = 8
        "1 2 + 3 * 4 -",   # (1+2)*3-4 = 5
        "9 3 / 2 *",       # 9/3*2 = 6
    ]
    
    print("Вычисление выражений в обратной польской записи:")
    print("=" * 50)
    
    for expr in test_expressions:
        try:
            result = evaluate_postfix(expr)
            print(f"Выражение: {expr:15} = {result}")
        except (ValueError, ZeroDivisionError) as e:
            print(f"Выражение: {expr:15} -> Ошибка: {e}")
    
    # Интерактивный режим
    print("\nИнтерактивный режим:")
    print("Введите выражение в обратной польской записи (или 'exit' для выхода):")
    print("Пример: 3 4 + 2 *")
    
    while True:
        user_input = input("> ").strip()
        if user_input.lower() in ['exit', 'quit', 'выход']:
            break
        
        if not user_input:
            continue
        
        try:
            result = evaluate_postfix(user_input)
            print(f"Результат: {result}")
        except (ValueError, ZeroDivisionError) as e:
            print(f"Ошибка: {e}")


# Версия с подробным выводом процесса вычисления
def evaluate_postfix_detailed(expression):
    """
    Вычисляет выражение с подробным выводом каждого шага
    """
    stack = Stack()
    tokens = expression.split()
    
    print(f"\nДетальное вычисление выражения: '{expression}'")
    print("Токен | Действие           | Стек")
    print("-" * 40)
    
    for token in tokens:
        stack_before = str(stack.items)
        
        if token.isdigit():
            stack.push(int(token))
            action = f"Добавлено число {token}"
        else:
            operand2 = stack.pop()
            operand1 = stack.pop()
            
            if operand1 is None or operand2 is None:
                raise ValueError(f"Недостаточно операндов для операции '{token}'")
            
            if token == '+':
                result = operand1 + operand2
            elif token == '-':
                result = operand1 - operand2
            elif token == '*':
                result = operand1 * operand2
            elif token == '/':
                if operand2 == 0:
                    raise ValueError("Деление на ноль")
                result = operand1 / operand2
            elif token == '^':
                result = operand1 ** operand2
            else:
                raise ValueError(f"Неизвестная операция: '{token}'")
            
            stack.push(result)
            action = f"{operand1} {token} {operand2} = {result}"
        
        stack_after = str(stack.items)
        print(f"{token:5} | {action:18} | {stack_after}")
    
    if stack.size() != 1:
        raise ValueError("Некорректное выражение")
    
    final_result = stack.pop()
    print(f"Результат: {final_result}")
    return final_result


if __name__ == "__main__":
    # Основная программа
    main()
    
    # Демонстрация детального вычисления
    print("\n" + "="*60)
    print("Демонстрация детального вычисления:")
    
    demo_expressions = ["3 4 + 2 *", "5 1 2 + *"]
    for expr in demo_expressions:
        try:
            evaluate_postfix_detailed(expr)
        except ValueError as e:
            print(f"Ошибка: {e}")
```

### Программа, переводящая выражение из инфиксной в постфиксную форму записи


```python
class Stack:
    """Реализация стека на основе массива"""
    def __init__(self):
        self.items = []
    
    def push(self, x):
        """Добавить элемент в стек"""
        self.items.append(x)
    
    def pop(self):
        """Удалить и вернуть верхний элемент"""
        if self.isEmpty():
            return None
        return self.items.pop()
    
    def peek(self):
        """Вернуть верхний элемент без удаления"""
        if self.isEmpty():
            return None
        return self.items[-1]
    
    def isEmpty(self):
        """Проверка стека на пустоту"""
        return len(self.items) == 0


def get_precedence(operator):
    """Возвращает приоритет оператора"""
    precedence = {
        '+': 1,
        '-': 1,
        '*': 2,
        '/': 2,
        '^': 3
    }
    return precedence.get(operator, 0)


def is_operator(char):
    """Проверяет, является ли символ оператором"""
    return char in '+-*/^'


def is_operand(char):
    """Проверяет, является ли символ операндом (цифрой или буквой)"""
    return char.isalnum()


def infix_to_postfix(expression):
    """
    Переводит математическое выражение из инфиксной в постфиксную форму
    
    Args:
        expression (str): выражение в инфиксной форме
    
    Returns:
        str: выражение в постфиксной форме
    """
    stack = Stack()
    output = []
    
    # Удаляем пробелы для упрощения обработки
    expression = expression.replace(' ', '')
    
    i = 0
    while i < len(expression):
        char = expression[i]
        
        # Если операнд (число или переменная)
        if is_operand(char):
            # Собираем многоразрядное число или многосимвольный идентификатор
            operand = char
            while i + 1 < len(expression) and is_operand(expression[i + 1]):
                i += 1
                operand += expression[i]
            output.append(operand)
        
        # Если открывающая скобка
        elif char == '(':
            stack.push(char)
        
        # Если закрывающая скобка
        elif char == ')':
            # Выталкиваем все операторы до открывающей скобки
            while not stack.isEmpty() and stack.peek() != '(':
                output.append(stack.pop())
            
            # Удаляем открывающую скобку из стека
            if not stack.isEmpty() and stack.peek() == '(':
                stack.pop()
            else:
                raise ValueError("Несбалансированные скобки")
        
        # Если оператор
        elif is_operator(char):
            # Обработка унарного минуса (если это первый символ или после открывающей скобки)
            if char == '-' and (i == 0 or expression[i-1] == '('):
                # Собираем унарный минус с числом
                i += 1
                if i < len(expression) and is_operand(expression[i]):
                    operand = '-' + expression[i]
                    while i + 1 < len(expression) and is_operand(expression[i + 1]):
                        i += 1
                        operand += expression[i]
                    output.append(operand)
                else:
                    raise ValueError("Некорректный унарный минус")
            else:
                # Выталкиваем операторы с большим или равным приоритетом
                while (not stack.isEmpty() and 
                       stack.peek() != '(' and 
                       get_precedence(stack.peek()) >= get_precedence(char)):
                    
                    # Особый случай для возведения в степень - правоассоциативная операция
                    if char == '^' and stack.peek() == '^':
                        break
                    output.append(stack.pop())
                
                stack.push(char)
        
        i += 1
    
    # Выталкиваем все оставшиеся операторы из стека
    while not stack.isEmpty():
        if stack.peek() == '(':
            raise ValueError("Несбалансированные скобки")
        output.append(stack.pop())
    
    return ' '.join(output)


def main():
    """Основная функция для демонстрации работы программы"""
    test_expressions = [
        "3 + 4",
        "5 * 2 + 3",
        "(7 - 2) * 4",
        "8 / 4 + 2",
        "2 ^ 3",
        "(1 + 2) * 3 - 4",
        "9 / 3 * 2",
        "a + b * c",
        "(a + b) * c",
        "a + b * c - d / e",
        "3 + 4 * 2 / (1 - 5) ^ 2",
        "-5 + 3",
        "(-2) * 3",
    ]
    
    print("Перевод из инфиксной в постфиксную запись:")
    print("=" * 60)
    
    for expr in test_expressions:
        try:
            postfix = infix_to_postfix(expr)
            print(f"Инфиксная:  {expr:30} -> Постфиксная: {postfix}")
        except ValueError as e:
            print(f"Инфиксная:  {expr:30} -> Ошибка: {e}")
    
    # Интерактивный режим
    print("\nИнтерактивный режим:")
    print("Введите выражение в инфиксной форме (или 'exit' для выхода):")
    
    while True:
        user_input = input("> ").strip()
        if user_input.lower() in ['exit', 'quit', 'выход']:
            break
        
        if not user_input:
            continue
        
        try:
            postfix = infix_to_postfix(user_input)
            print(f"Постфиксная запись: {postfix}")
        except ValueError as e:
            print(f"Ошибка: {e}")


# Версия с подробным выводом процесса преобразования
def infix_to_postfix_detailed(expression):
    """
    Переводит выражение с подробным выводом каждого шага
    """
    stack = Stack()
    output = []
    expression = expression.replace(' ', '')
    
    print(f"\nДетальное преобразование выражения: '{expression}'")
    print("Символ | Действие           | Выходная строка | Стек")
    print("-" * 60)
    
    i = 0
    while i < len(expression):
        char = expression[i]
        output_str = ' '.join(output)
        stack_str = ''.join(stack.items) if not stack.isEmpty() else ''
        action = ""  # Инициализируем переменную action
        
        if is_operand(char):
            operand = char
            while i + 1 < len(expression) and is_operand(expression[i + 1]):
                i += 1
                operand += expression[i]
            output.append(operand)
            action = f"Добавлен операнд '{operand}'"
        
        elif char == '(':
            stack.push(char)
            action = "Добавлена '(' в стек"
        
        elif char == ')':
            action = "Найдена ')', выталкиваем до '('"
            while not stack.isEmpty() and stack.peek() != '(':
                output.append(stack.pop())
            
            if not stack.isEmpty() and stack.peek() == '(':
                stack.pop()
                action += " - удалена '('"
            else:
                raise ValueError("Несбалансированные скобки")
        
        elif is_operator(char):
            if char == '-' and (i == 0 or expression[i-1] == '('):
                i += 1
                if i < len(expression) and is_operand(expression[i]):
                    operand = '-' + expression[i]
                    while i + 1 < len(expression) and is_operand(expression[i + 1]):
                        i += 1
                        operand += expression[i]
                    output.append(operand)
                    action = f"Добавлен унарный минус '{operand}'"
                else:
                    raise ValueError("Некорректный унарный минус")
            else:
                action = f"Обработка оператора '{char}'"
                while (not stack.isEmpty() and 
                       stack.peek() != '(' and 
                       get_precedence(stack.peek()) >= get_precedence(char)):
                    
                    if char == '^' and stack.peek() == '^':
                        break
                    output.append(stack.pop())
                    action += f", вытолкнут '{output[-1]}'"
                
                stack.push(char)
                action += f", добавлен '{char}' в стек"
        
        # Все ветки if/elif инициализируют action, поэтому здесь он всегда определен
        print(f"{char:6} | {action:18} | {output_str:15} | {stack_str}")
        i += 1
    
    # Выталкиваем оставшиеся операторы
    while not stack.isEmpty():
        if stack.peek() == '(':
            raise ValueError("Несбалансированные скобки")
        operator = stack.pop()
        output.append(operator)
        output_str = ' '.join(output)
        stack_str = ''.join(stack.items) if not stack.isEmpty() else ''
        action = f"Вытолкнут '{operator}'"  # Определяем action для этого случая
        print(f"{'':6} | {action:18} | {output_str:15} | {stack_str}")
    
    result = ' '.join(output)
    print(f"Результат: {result}")
    return result


if __name__ == "__main__":
    # Основная программа
    main()
    
    # Демонстрация детального преобразования
    print("\n" + "="*70)
    print("Демонстрация детального преобразования:")
    
    demo_expressions = ["3 + 4 * 2", "(a + b) * c"]
    for expr in demo_expressions:
        try:
            infix_to_postfix_detailed(expr)
        except ValueError as e:
            print(f"Ошибка: {e}")
```
