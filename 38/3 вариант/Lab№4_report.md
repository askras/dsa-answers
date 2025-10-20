```python
class StackBase:
    """Базовый класс для стека"""
    def push(self, item):
        """Добавляет элемент на вершину стека"""
        raise NotImplementedError
    
    def pop(self):
        """Удаляет и возвращает элемент с вершины стека"""
        raise NotImplementedError
    
    def peek(self):
        """Возвращает элемент с вершины стека без удаления"""
        raise NotImplementedError
    
    def is_empty(self):
        """Проверяет, пуст ли стек"""
        raise NotImplementedError
    
    def size(self):
        """Возвращает количество элементов в стеке"""
        raise NotImplementedError
    
    def clear(self):
        """Очищает стек"""
        raise NotImplementedError


class QueueBase:
    """Базовый класс для очереди"""
    def enqueue(self, item):
        """Добавляет элемент в конец очереди"""
        raise NotImplementedError
    
    def dequeue(self):
        """Удаляет и возвращает элемент из начала очереди"""
        raise NotImplementedError
    
    def front(self):
        """Возвращает элемент из начала очереди без удаления"""
        raise NotImplementedError
    
    def is_empty(self):
        """Проверяет, пуста ли очередь"""
        raise NotImplementedError
    
    def size(self):
        """Возвращает количество элементов в очереди"""
        raise NotImplementedError
    
    def clear(self):
        """Очищает очередь"""
        raise NotImplementedError


class DequeBase:
    """Базовый класс для дека"""
    def add_front(self, item):
        """Добавляет элемент в начало дека"""
        raise NotImplementedError
    
    def add_rear(self, item):
        """Добавляет элемент в конец дека"""
        raise NotImplementedError
    
    def remove_front(self):
        """Удаляет и возвращает элемент из начала дека"""
        raise NotImplementedError
    
    def remove_rear(self):
        """Удаляет и возвращает элемент из конца дека"""
        raise NotImplementedError
    
    def front(self):
        """Возвращает элемент из начала дека без удаления"""
        raise NotImplementedError
    
    def rear(self):
        """Возвращает элемент из конца дека без удаления"""
        raise NotImplementedError
    
    def is_empty(self):
        """Проверяет, пуст ли дек"""
        raise NotImplementedError
    
    def size(self):
        """Возвращает количество элементов в деке"""
        raise NotImplementedError
    
    def clear(self):
        """Очищает дек"""
        raise NotImplementedError


# 1. Стек на основе массива
class ArrayStack(StackBase):
    def __init__(self):
        self._items = []
    
    def push(self, item):
        """Добавляет элемент на вершину стека"""
        self._items.append(item)
    
    def pop(self):
        """Удаляет и возвращает элемент с вершины стека"""
        if self.is_empty():
            raise IndexError("Stack is empty")
        return self._items.pop()
    
    def peek(self):
        """Возвращает элемент с вершины стека без удаления"""
        if self.is_empty():
            raise IndexError("Stack is empty")
        return self._items[-1]
    
    def is_empty(self):
        """Проверяет, пуст ли стек"""
        return len(self._items) == 0
    
    def size(self):
        """Возвращает количество элементов в стеке"""
        return len(self._items)
    
    def clear(self):
        """Очищает стек"""
        self._items = []
    
    def __str__(self):
        return str(self._items)
    
    def __repr__(self):
        return f"ArrayStack({self._items})"
    
    def __contains__(self, item):
        """Проверяет, содержится ли элемент в стеке"""
        return item in self._items


# 2. Стек на основе связного списка
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None


class LinkedListStack(StackBase):
    def __init__(self):
        self._top = None
        self._size = 0
    
    def push(self, item):
        """Добавляет элемент на вершину стека"""
        new_node = Node(item)
        new_node.next = self._top
        self._top = new_node
        self._size += 1
    
    def pop(self):
        """Удаляет и возвращает элемент с вершины стека"""
        if self.is_empty():
            raise IndexError("Stack is empty")
        data = self._top.data
        self._top = self._top.next
        self._size -= 1
        return data
    
    def peek(self):
        """Возвращает элемент с вершины стека без удаления"""
        if self.is_empty():
            raise IndexError("Stack is empty")
        return self._top.data
    
    def is_empty(self):
        """Проверяет, пуст ли стек"""
        return self._top is None
    
    def size(self):
        """Возвращает количество элементов в стеке"""
        return self._size
    
    def clear(self):
        """Очищает стек"""
        self._top = None
        self._size = 0
    
    def __str__(self):
        items = []
        current = self._top
        while current:
            items.append(current.data)
            current = current.next
        return str(items[::-1])
    
    def __repr__(self):
        return f"LinkedListStack({str(self)})"
    
    def __contains__(self, item):
        """Проверяет, содержится ли элемент в стеке"""
        current = self._top
        while current:
            if current.data == item:
                return True
            current = current.next
        return False


# 3. Очередь на основе массива
class ArrayQueue(QueueBase):
    def __init__(self):
        self._items = []
    
    def enqueue(self, item):
        """Добавляет элемент в конец очереди"""
        self._items.append(item)
    
    def dequeue(self):
        """Удаляет и возвращает элемент из начала очереди"""
        if self.is_empty():
            raise IndexError("Queue is empty")
        return self._items.pop(0)
    
    def front(self):
        """Возвращает элемент из начала очереди без удаления"""
        if self.is_empty():
            raise IndexError("Queue is empty")
        return self._items[0]
    
    def is_empty(self):
        """Проверяет, пуста ли очередь"""
        return len(self._items) == 0
    
    def size(self):
        """Возвращает количество элементов в очереди"""
        return len(self._items)
    
    def clear(self):
        """Очищает очередь"""
        self._items = []
    
    def __str__(self):
        return str(self._items)
    
    def __repr__(self):
        return f"ArrayQueue({self._items})"
    
    def __contains__(self, item):
        """Проверяет, содержится ли элемент в очереди"""
        return item in self._items


# 4. Очередь на основе связного списка
class LinkedListQueue(QueueBase):
    def __init__(self):
        self._front = None
        self._rear = None
        self._size = 0
    
    def enqueue(self, item):
        """Добавляет элемент в конец очереди"""
        new_node = Node(item)
        if self.is_empty():
            self._front = self._rear = new_node
        else:
            self._rear.next = new_node
            self._rear = new_node
        self._size += 1
    
    def dequeue(self):
        """Удаляет и возвращает элемент из начала очереди"""
        if self.is_empty():
            raise IndexError("Queue is empty")
        data = self._front.data
        self._front = self._front.next
        if self._front is None:
            self._rear = None
        self._size -= 1
        return data
    
    def front(self):
        """Возвращает элемент из начала очереди без удаления"""
        if self.is_empty():
            raise IndexError("Queue is empty")
        return self._front.data
    
    def is_empty(self):
        """Проверяет, пуста ли очередь"""
        return self._front is None
    
    def size(self):
        """Возвращает количество элементов в очереди"""
        return self._size
    
    def clear(self):
        """Очищает очередь"""
        self._front = None
        self._rear = None
        self._size = 0
    
    def __str__(self):
        items = []
        current = self._front
        while current:
            items.append(current.data)
            current = current.next
        return str(items)
    
    def __repr__(self):
        return f"LinkedListQueue({str(self)})"
    
    def __contains__(self, item):
        """Проверяет, содержится ли элемент в очереди"""
        current = self._front
        while current:
            if current.data == item:
                return True
            current = current.next
        return False


# 5. Дек на основе массива
class ArrayDeque(DequeBase):
    def __init__(self):
        self._items = []
    
    def add_front(self, item):
        """Добавляет элемент в начало дека"""
        self._items.insert(0, item)
    
    def add_rear(self, item):
        """Добавляет элемент в конец дека"""
        self._items.append(item)
    
    def remove_front(self):
        """Удаляет и возвращает элемент из начала дека"""
        if self.is_empty():
            raise IndexError("Deque is empty")
        return self._items.pop(0)
    
    def remove_rear(self):
        """Удаляет и возвращает элемент из конца дека"""
        if self.is_empty():
            raise IndexError("Deque is empty")
        return self._items.pop()
    
    def front(self):
        """Возвращает элемент из начала дека без удаления"""
        if self.is_empty():
            raise IndexError("Deque is empty")
        return self._items[0]
    
    def rear(self):
        """Возвращает элемент из конца дека без удаления"""
        if self.is_empty():
            raise IndexError("Deque is empty")
        return self._items[-1]
    
    def is_empty(self):
        """Проверяет, пуст ли дек"""
        return len(self._items) == 0
    
    def size(self):
        """Возвращает количество элементов в деке"""
        return len(self._items)
    
    def clear(self):
        """Очищает дек"""
        self._items = []
    
    def __str__(self):
        return str(self._items)
    
    def __repr__(self):
        return f"ArrayDeque({self._items})"
    
    def __contains__(self, item):
        """Проверяет, содержится ли элемент в деке"""
        return item in self._items


# 6. Дек на основе связного списка
class LinkedListDeque(DequeBase):
    def __init__(self):
        self._front = None
        self._rear = None
        self._size = 0
    
    def add_front(self, item):
        """Добавляет элемент в начало дека"""
        new_node = Node(item)
        if self.is_empty():
            self._front = self._rear = new_node
        else:
            new_node.next = self._front
            self._front = new_node
        self._size += 1
    
    def add_rear(self, item):
        """Добавляет элемент в конец дека"""
        new_node = Node(item)
        if self.is_empty():
            self._front = self._rear = new_node
        else:
            self._rear.next = new_node
            self._rear = new_node
        self._size += 1
    
    def remove_front(self):
        """Удаляет и возвращает элемент из начала дека"""
        if self.is_empty():
            raise IndexError("Deque is empty")
        data = self._front.data
        self._front = self._front.next
        if self._front is None:
            self._rear = None
        self._size -= 1
        return data
    
    def remove_rear(self):
        """Удаляет и возвращает элемент из конца дека"""
        if self.is_empty():
            raise IndexError("Deque is empty")
        
        if self._front == self._rear:
            data = self._front.data
            self._front = self._rear = None
            self._size -= 1
            return data
        
        # Находим предпоследний элемент
        current = self._front
        while current.next != self._rear:
            current = current.next
        
        data = self._rear.data
        current.next = None
        self._rear = current
        self._size -= 1
        return data
    
    def front(self):
        """Возвращает элемент из начала дека без удаления"""
        if self.is_empty():
            raise IndexError("Deque is empty")
        return self._front.data
    
    def rear(self):
        """Возвращает элемент из конца дека без удаления"""
        if self.is_empty():
            raise IndexError("Deque is empty")
        return self._rear.data
    
    def is_empty(self):
        """Проверяет, пуст ли дек"""
        return self._front is None
    
    def size(self):
        """Возвращает количество элементов в деке"""
        return self._size
    
    def clear(self):
        """Очищает дек"""
        self._front = None
        self._rear = None
        self._size = 0
    
    def __str__(self):
        items = []
        current = self._front
        while current:
            items.append(current.data)
            current = current.next
        return str(items)
    
    def __repr__(self):
        return f"LinkedListDeque({str(self)})"
    
    def __contains__(self, item):
        """Проверяет, содержится ли элемент в деке"""
        current = self._front
        while current:
            if current.data == item:
                return True
            current = current.next
        return False


# Задание 2: Проверка скобок
def check_brackets_balance(bracket_string):
    stack = ArrayStack()
    bracket_pairs = {')': '(', ']': '[', '}': '{'}
    
    for char in bracket_string:
        if char in '([{': 
            stack.push(char)
        elif char in ')]}': 
            if stack.is_empty():
                return False
            top = stack.pop()
            if top != bracket_pairs[char]:
                return False
    return stack.is_empty()  


def check_brackets_with_details(bracket_string):
    stack = ArrayStack()
    bracket_pairs = {')': '(', ']': '[', '}': '{'}
    error_found = False
    print(f"Проверка строки: {bracket_string}")
    
    for i, char in enumerate(bracket_string):
        if char in '([{':
            stack.push((char, i))  
        elif char in ')]}':
            if stack.is_empty():
                error_found = True
                break
            
            top_bracket, top_position = stack.pop()
            if top_bracket != bracket_pairs[char]:
                error_found = True
                break
            else:
                print(f"Позиция {i}: Закрывающая скобка '{char}' соответствует открывающей '{top_bracket}' на позиции {top_position}")
    
    if not error_found and not stack.is_empty():
        error_found = True
        unclosed_brackets = [bracket for bracket, pos in stack._items]
        print(f"ОШИБКА! Не закрыты скобки: {unclosed_brackets}")
    
    if not error_found:
        print("Все скобки закрыты правильно!")
    
    return not error_found

```

