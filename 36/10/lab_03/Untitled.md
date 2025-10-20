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

# Линейные списки (Linked list)

## Цель работы

изучение структуры данных «Линейные списки», а также основных операций над ними.

## Задания
### 1) Реализация 6 версий односвязного списка:

```{code-cell} ipython3
from typing import Any, Self
```

#### Класс node

```{code-cell} ipython3
class Node:
    def __init__(self, data:Any=None, next:'Node'=None):
        self.data = data
        self.next = next

    def __repr__(self):
         return f'{self.__class__.__name__}(data={self.data}, next={self.next})'
```

#### Линейный односвязный список (Версия 1)

Линейный односвязный список &mdash; абстрактный тип данных, который поддерживает следующие операции:

- **`init() -> SingleLinkedList`**
<br>Возвращает пустой односвязный список.

- **`insert_first_node(ValueType value) -> None`**
<br>Добавить узел в начало списка.
- **`remove_first_node() -> ValueType`**
<br>Удалить первый узел списка и вернуть его значение.

- **`insert_last_node(ValueType value) -> None`**
<br>Добавить узел в конец списка.
- **`remove_last_node() -> ValueType`**
<br>Удалить последний элемент списка.

```{code-cell} ipython3
class SingleLinkedList_v1:
    def __init__(self) -> Self:
        '''Возвращает пустой список'''
        self._head = None

    def insert_first_node(self, value:Any) -> None:
        '''Добавить элемент в начало списка'''
        self._head = Node(value, self._head)

    def remove_first_node(self) -> Any:
        '''Удалить первый элемент списка'''
        temp = self._head.data
        self._head = self._head.next
        return temp

    def insert_last_node(self, value:Any) -> None:
        '''Добавить элемент в конец списка'''
        if self._head is None:
            self.insert_first_node(value)
        else:
            current_node = self._head
            while current_node.next is not None:
                current_node = current_node.next
            current_node.next = Node(value)

    def remove_last_node(self) -> Any:
        '''Удалить последний элемент списка'''
        if self._head.next is None:
            return self.remove_first_node()
        else:
            current_node = self._head
            while current_node.next.next is not None:
                current_node = current_node.next
            temp = current_node.next.data
            current_node.next = None
            return temp

    def __repr__(self) -> str:
        return f'{self.__class__.__name__}({self._head})'

    def __str__(self):
        node = self._head
        l = []
        while node:
            l.append(str(node.data))
            node = node.next
        return 'LinkedList.head -> ' + ' -> '.join(l) + ' -> None'
```

#### Линейный односвязный список (Версия 2). Наследуется от версии 1

- **`get_size() -> Integer`**
<br> Вернуть длину списка

- **`find_node(ValueType value) -> ValueType`**
<br>Найти (первый) узел по его значению и вернуть значение (связанные элементы).

- **`replace_node(ValueType old_value, ValueType new_value) -> None`**
<br>Найти (первый) узел по его значению и заменить его значение новым.

- **`remove_node(ValueType value) -> ValueType`**
<br>Найти (первый) узел по его значению и удалить его.

```{code-cell} ipython3
class SingleLinkedList_v2(SingleLinkedList_v1):
    def get_size(self) -> int:
        '''Вернуть длину списка'''
        count = 0
        current_node = self._head
        while current_node is not None:
            count += 1
            current_node = current_node.next
        return count

    def find_node(self, value: Any) -> Any:
        '''Найти (первый) узел по его значению и вернуть значение'''
        current_node = self._head
        while current_node is not None:
            if current_node.data == value:
                return current_node.data
            current_node = current_node.next
        return None

    def replace_node(self, old_value: Any, new_value: Any) -> None:
        '''Найти (первый) узел по его значению и заменить его значение новым'''
        current_node = self._head
        while current_node is not None:
            if current_node.data == old_value:
                current_node.data = new_value
                return
            current_node = current_node.next

    def remove_node(self, value: Any) -> Any:
        '''Найти (первый) узел по его значению и удалить его'''
        if self._head is None:
            return None

        if self._head.data == value:
            return self.remove_first_node()

        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == value:
                temp = current_node.next.data
                current_node.next = current_node.next.next
                return temp
            current_node = current_node.next
            
        return None
```

#### Линейный односвязный список (Версия 3). Наследуется от версии 
Cохраняем значения длины и обновляем его при выполнении каждой операции

```{code-cell} ipython3
class SingleLinkedList_v3(SingleLinkedList_v2):
    def __init__(self) -> None:
        '''Возвращает пустой список'''
        super().__init__()
        self._size = 0

    def insert_first_node(self, value: Any) -> None:
        '''Добавить элемент в начало списка'''
        super().insert_first_node(value)
        self._size += 1

    def remove_first_node(self) -> Any:
        '''Удалить первый элемент списка'''
        if self._head is None:
            return None
        result = super().remove_first_node()
        self._size -= 1
        return result

    def insert_last_node(self, value: Any) -> None:
        '''Добавить элемент в конец списка'''
        super().insert_last_node(value)
        self._size += 1

    def remove_last_node(self) -> Any:
        '''Удалить последний элемент списка'''
        if self._head is None:
            return None
        result = super().remove_last_node()
        self._size -= 1
        return result

    def remove_node(self, value: Any) -> Any:
        '''Найти (первый) узел по его значению и удалить его'''
        if self._head is None:
            return None

        if self._head.data == value:
            return self.remove_first_node()

        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == value:
                temp = current_node.next.data
                current_node.next = current_node.next.next
                self._size -= 1
                return temp
            current_node = current_node.next
            
        return None

    def get_size(self) -> int:
        '''Вернуть длину списка - O(1)'''
        return self._size

    def __repr__(self) -> str:
        return f'{self.__class__.__name__}(size={self._size}, {self._head})'

    def __str__(self):
        return f'LinkedList(size={self._size}).head -> ' + super().__str__().split(' -> ', 1)[1]
```

#### Линейный односвязный список (Версия 4). Наследуется от версии 3

- **`find_previos_node(ValueType value) -> ValueType`**
<br>Найти (первый) узел по его значению и вернуть значение из предудущего узла (если такой есть).

- **`find_next_node(ValueType value) -> ValueType`**
<br>Найти (первый) узел по его значению и вернуть значение из следующего узла (если такой есть).


- **`insert_before_node(ValueType value) -> None`**
<br>Найти (первый) узел по его значению и добавить узел перед ним. (Если узел не найден, ничего не делать)

- **`insert_after_node(ValueType value) -> None`**
<br>Найти (первый) узел по его значению и добавить узел после него. (Если узел не найден, ничего не делать)


- **`replace_previos_node(ValueType old_value, ValueType new_value) -> None`**
<br>Найти (первый) узел по его значению и заменить значение в предыдущем узле на новое.

- **`replace_next_node(ValueType old_value, ValueType new_value) -> None`**
<br>Найти (первый) узел по его значению и заменить значение в следующем узле на новое.


- **`remove_previos_node(ValueType value) -> ValueType`**
<br>Найти (первый) узел по его значению и удалить предыдущий узел (если такой есть).

- **`remove_next_node(ValueType value) -> ValueType`**
<br>Найти (первый) узел по его значению и удалить следующий узел (если такой есть).

```{code-cell} ipython3
class SingleLinkedList_v4(SingleLinkedList_v3):
    def find_previous_node(self, value: Any) -> Any:
        '''Найти (первый) узел по его значению и вернуть значение из предыдущего узла'''
        if self._head is None or self._head.next is None:
            return None
            
        if self._head.next.data == value:
            return self._head.data
            
        current_node = self._head
        while current_node.next is not None and current_node.next.next is not None:
            if current_node.next.next.data == value:
                return current_node.next.data
            current_node = current_node.next
            
        return None

    def find_next_node(self, value: Any) -> Any:
        '''Найти (первый) узел по его значению и вернуть значение из следующего узла'''
        current_node = self._head
        while current_node is not None:
            if current_node.data == value and current_node.next is not None:
                return current_node.next.data
            current_node = current_node.next
        return None

    def insert_before_node(self, target_value: Any, new_value: Any) -> None:
        '''Найти (первый) узел по его значению и добавить узел перед ним'''
        if self._head is None:
            return

        if self._head.data == target_value:
            self.insert_first_node(new_value)
            return

        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == target_value:
                new_node = Node(new_value, current_node.next)
                current_node.next = new_node
                self._size += 1
                return
            current_node = current_node.next

    def insert_after_node(self, target_value: Any, new_value: Any) -> None:
        '''Найти (первый) узел по его значению и добавить узел после него'''
        current_node = self._head
        while current_node is not None:
            if current_node.data == target_value:
                new_node = Node(new_value, current_node.next)
                current_node.next = new_node
                self._size += 1
                return
            current_node = current_node.next

    def replace_previous_node(self, target_value: Any, new_value: Any) -> None:
        '''Найти (первый) узел по его значению и заменить значение в предыдущем узле'''
        if self._head is None or self._head.next is None:
            return

        if self._head.next.data == target_value:
            self._head.data = new_value
            return
            
        current_node = self._head
        while current_node.next is not None and current_node.next.next is not None:
            if current_node.next.next.data == target_value:
                current_node.next.data = new_value
                return
            current_node = current_node.next

    def replace_next_node(self, target_value: Any, new_value: Any) -> None:
        '''Найти (первый) узел по его значению и заменить значение в следующем узле'''
        current_node = self._head
        while current_node is not None and current_node.next is not None:
            if current_node.data == target_value:
                current_node.next.data = new_value
                return
            current_node = current_node.next

    def remove_previous_node(self, target_value: Any) -> Any:
        '''Найти (первый) узел по его значению и удалить предыдущий узел'''
        if self._head is None or self._head.next is None:
            return None
            
        if self._head.next.data == target_value:
            return self.remove_first_node()
            
        current_node = self._head
        while current_node.next is not None and current_node.next.next is not None:
            if current_node.next.next.data == target_value:
                temp = current_node.next.data
                current_node.next = current_node.next.next
                self._size -= 1
                return temp
            current_node = current_node.next
            
        return None

    def remove_next_node(self, target_value: Any) -> Any:
        '''Найти (первый) узел по его значению и удалить следующий узел'''
        current_node = self._head
        while current_node is not None and current_node.next is not None:
            if current_node.data == target_value:
                temp = current_node.next.data
                current_node.next = current_node.next.next
                self._size -= 1
                return temp
            current_node = current_node.next
        return None
```

#### Линейный односвязный список (Версия 5). Наследуется от версии 4
Дополнительно храним ссылку на последний элемент списка

```{code-cell} ipython3
class SingleLinkedList_v5(SingleLinkedList_v4):
    def __init__(self) -> None:
        '''Возвращает пустой список'''
        super().__init__()
        self._tail = None

    def insert_first_node(self, value: Any) -> None:
        '''Добавить элемент в начало списка'''
        super().insert_first_node(value)
        if self._size == 1:
            self._tail = self._head

    def remove_first_node(self) -> Any:
        '''Удалить первый элемент списка'''
        if self._head is None:
            return None

        if self._head.next is None:
            self._tail = None
            
        result = super().remove_first_node()
        return result

    def insert_last_node(self, value: Any) -> None:
        '''Добавить элемент в конец списка - O(1)'''
        if self._head is None:
            self.insert_first_node(value)
        else:
            new_node = Node(value)
            self._tail.next = new_node
            self._tail = new_node
            self._size += 1

    def remove_last_node(self) -> Any:
        '''Удалить последний элемент списка'''
        if self._head is None:
            return None
            
        if self._head.next is None:
            return self.remove_first_node()
            
        current_node = self._head
        while current_node.next.next is not None:
            current_node = current_node.next
            
        temp = current_node.next.data
        current_node.next = None
        self._tail = current_node
        self._size -= 1
        return temp

    def insert_after_node(self, target_value: Any, new_value: Any) -> None:
        '''Найти (первый) узел по его значению и добавить узел после него'''
        current_node = self._head
        while current_node is not None:
            if current_node.data == target_value:
                new_node = Node(new_value, current_node.next)
                current_node.next = new_node
                self._size += 1
                if current_node == self._tail:
                    self._tail = new_node
                return
            current_node = current_node.next

    def remove_node(self, value: Any) -> Any:
        '''Найти (первый) узел по его значению и удалить его'''
        if self._head is None:
            return None
            
        if self._head.data == value:
            return self.remove_first_node()
            
        current_node = self._head
        while current_node.next is not None:
            if current_node.next.data == value:
                if current_node.next == self._tail:
                    self._tail = current_node
                    
                temp = current_node.next.data
                current_node.next = current_node.next.next
                self._size -= 1
                return temp
            current_node = current_node.next
            
        return None

    def remove_next_node(self, target_value: Any) -> Any:
        '''Найти (первый) узел по его значению и удалить следующий узел'''
        current_node = self._head
        while current_node is not None and current_node.next is not None:
            if current_node.data == target_value:
                if current_node.next == self._tail:
                    self._tail = current_node
                    
                temp = current_node.next.data
                current_node.next = current_node.next.next
                self._size -= 1
                return temp
            current_node = current_node.next
        return None

    def get_tail(self) -> Any:
        '''Получить значение последнего элемента'''
        return self._tail.data if self._tail else None

    def clear(self) -> None:
        '''Очистить весь список'''
        super().clear()
        self._tail = None

    def __repr__(self) -> str:
        tail_value = self._tail.data if self._tail else None
        return f'{self.__class__.__name__}(size={self._size}, head={self._head}, tail={tail_value})'

    def __str__(self):
        tail_info = f", tail={self._tail.data}" if self._tail else ""
        return f'LinkedList(size={self._size}{tail_info}).head -> ' + super().__str__().split(' -> ', 1)[1]
```

#### Линейный односвязный список (Версия 6). Наследуется от версии 5
При необходимости модифицировать (вставить) узел перед текущим, меняем значение в текущем узле

```{code-cell} ipython3
class SingleLinkedList_v6(SingleLinkedList_v5):
    def insert_before_node(self, target_value: Any, new_value: Any) -> None:
        '''Найти (первый) узел по его значению и добавить узел перед ним через замену'''
        current_node = self._head
        while current_node is not None:
            if current_node.data == target_value:
                old_value = current_node.data
                current_node.data = new_value
                new_node = Node(old_value, current_node.next)
                current_node.next = new_node
                self._size += 1
                if current_node == self._tail:
                    self._tail = new_node
                return
            current_node = current_node.next

    def replace_previous_node(self, target_value: Any, new_value: Any) -> None:
        '''Найти (первый) узел по его значению и заменить значение в предыдущем узле'''
        prev_value = self.find_previous_node(target_value)
        if prev_value is not None:
            current_node = self._head
            while current_node is not None:
                if current_node.data == prev_value:
                    current_node.data = new_value
                    return
                current_node = current_node.next

    def remove_previous_node(self, target_value: Any) -> Any:
        '''Найти (первый) узел по его значению и удалить предыдущий узел'''
        if self._head is None or self._head.next is None:
            return None
            
        if self._head.next.data == target_value:
            return self.remove_first_node()
            
        current_node = self._head
        while current_node.next is not None and current_node.next.next is not None:
            if current_node.next.next.data == target_value:
                temp = current_node.next.data
                current_node.next = current_node.next.next
                self._size -= 1
                return temp
            current_node = current_node.next
            
        return None
```

### 2,3) Реализация методов `reverse` для &laquo;переворота&raquo; и `sort` для сортировки линейного списка на месте.

```{code-cell} ipython3
class SingleLinkedList_v7(SingleLinkedList_v6):
    def reverse(self) -> None:
        '''Перевернуть линейный список на месте'''
        if self._head is None or self._head.next is None:
            return  # Пустой список или список с одним элементом
        
        prev_node = None
        current_node = self._head
        self._tail = self._head  # Голова становится хвостом
        
        while current_node is not None:
            next_node = current_node.next  # Сохраняем следующий узел
            current_node.next = prev_node  # Разворачиваем указатель
            prev_node = current_node       # Перемещаем prev на текущий
            current_node = next_node       # Перемещаем current на следующий
        
        self._head = prev_node  # Новая голова - бывший последний элемент

    def sort(self) -> None:
        '''Сортировка линейного списка на месте (пузырьковая сортировка)'''
        if self._head is None or self._head.next is None:
            return  # Пустой список или список с одним элементом
        
        swapped = True
        while swapped:
            swapped = False
            current_node = self._head
            
            while current_node.next is not None:
                if current_node.data > current_node.next.data:
                    # Меняем данные местами
                    current_node.data, current_node.next.data = current_node.next.data, current_node.data
                    swapped = True
                current_node = current_node.next
```

### 4) Индивидуальные задания

```{code-cell} ipython3
class SingleLinkedList_v8(SingleLinkedList_v7):
    
    # 1. Элементы, входящие в L1, но не входящие в L2
    def difference(self, other: 'SingleLinkedList_v8') -> 'SingleLinkedList_v8':
        result = SingleLinkedList_v8()
        current = self._head
        while current:
            if not other.contains(current.data):
                result.insert_last_node(current.data)
            current = current.next
        return result

    # 2. Количество максимальных элементов
    def count_max_elements(self) -> int:
        if self._head is None:
            return 0
        
        max_val = self._head.data
        count = 1
        
        current = self._head.next
        while current:
            if current.data > max_val:
                max_val = current.data
                count = 1
            elif current.data == max_val:
                count += 1
            current = current.next
        
        return count

    # 3. Список без повторений
    def input_unique_numbers(self) -> None:
        """Ввод чисел пользователем без повторений"""
        seen = set()
        
        print("Введите числа (пустая строка для завершения):")
        while True:
            try:
                user_input = input().strip()
                if not user_input:
                    break
                num = int(user_input)
                if num not in seen:
                    seen.add(num)
                    self.insert_last_node(num)
            except ValueError:
                print("Ошибка: введите целое число")

    # 4. Отсортированная копия
    def sorted_copy(self) -> 'SingleLinkedList_v8':
        result = SingleLinkedList_v8()
        current = self._head
        
        # Копируем элементы
        while current:
            result.insert_last_node(current.data)
            current = current.next
        
        # Сортируем
        result.sort()
        return result

    # 5. Оставить только последние вхождения
    def keep_last_occurrences(self) -> None:
        if self._head is None:
            return
        
        seen = set()
        prev = None
        current = self._head
        
        # Проходим с конца (реверсируем, обрабатываем, снова реверсируем)
        self.reverse()
        
        current = self._head
        prev = None
        seen = set()
        
        while current:
            if current.data in seen:
                # Удаляем дубликат
                if prev:
                    prev.next = current.next
                else:
                    self._head = current.next
                self._size -= 1
            else:
                seen.add(current.data)
                prev = current
            current = current.next
        
        self.reverse()

    # 6. Убрать подряд идущие дубликаты
    def remove_consecutive_duplicates(self) -> None:
        if self._head is None:
            return
        
        current = self._head
        while current and current.next:
            if current.data == current.next.data:
                current.next = current.next.next
                self._size -= 1
            else:
                current = current.next

    # 7. Пересечение двух списков
    def intersection(self, other: 'SingleLinkedList_v8') -> 'SingleLinkedList_v8':
        result = SingleLinkedList_v8()
        current = self._head
        seen_in_other = set()
        
        # Собираем элементы из other
        other_current = other._head
        while other_current:
            seen_in_other.add(other_current.data)
            other_current = other_current.next
        
        # Добавляем только те, что есть в обоих
        while current:
            if current.data in seen_in_other:
                result.insert_last_node(current.data)
            current = current.next
        
        return result

    # 8. Разделить на положительные и отрицательные
    def split_positive_negative(self) -> tuple:
        positive = SingleLinkedList_v8()
        negative = SingleLinkedList_v8()
        
        current = self._head
        while current:
            if current.data >= 0:
                positive.insert_last_node(current.data)
            else:
                negative.insert_last_node(current.data)
            current = current.next
        
        return positive, negative

    # 9. Продублировать четные числа
    def duplicate_even_numbers(self) -> None:
        current = self._head
        while current:
            if current.data % 2 == 0:
                new_node = Node(current.data, current.next)
                current.next = new_node
                current = new_node.next
                self._size += 1
            else:
                current = current.next
        
        # Обновляем tail
        self._update_tail()

    # 10. Проверка на упорядоченность по возрастанию
    def is_sorted_ascending(self) -> bool:
        if self._head is None or self._head.next is None:
            return True
        
        current = self._head
        while current.next:
            if current.data > current.next.data:
                return False
            current = current.next
        
        return True

    # 11. Удалить нечетные числа
    def remove_odd_numbers(self) -> None:
        # Удаляем с начала пока голова нечетная
        while self._head and self._head.data % 2 != 0:
            self._head = self._head.next
            self._size -= 1
        
        if self._head is None:
            self._tail = None
            return
        
        # Удаляем нечетные в середине/конце
        current = self._head
        while current and current.next:
            if current.next.data % 2 != 0:
                current.next = current.next.next
                self._size -= 1
            else:
                current = current.next
        
        self._update_tail()

    # 12. Оставить только первые вхождения
    def keep_first_occurrences(self) -> None:
        if self._head is None:
            return
        
        seen = set()
        prev = None
        current = self._head
        
        while current:
            if current.data in seen:
                # Удаляем дубликат
                if prev:
                    prev.next = current.next
                else:
                    self._head = current.next
                self._size -= 1
            else:
                seen.add(current.data)
                prev = current
            current = current.next
        
        self._update_tail()

    # 13. Префиксные суммы
    def prefix_sums(self) -> 'SingleLinkedList_v8':
        result = SingleLinkedList_v8()
        if self._head is None:
            return result
        
        current_sum = 0
        current = self._head
        
        while current:
            current_sum += current.data
            result.insert_last_node(current_sum)
            current = current.next
        
        return result

    # 14. Пересечение (альтернативная реализация)
    def intersection_alt(self, other: 'SingleLinkedList_v8') -> 'SingleLinkedList_v8':
        return self.intersection(other)

    # 15. Удалить уникальные элементы
    def remove_unique_elements(self) -> None:
        if self._head is None:
            return
        
        # Считаем частоты
        frequency = {}
        current = self._head
        while current:
            frequency[current.data] = frequency.get(current.data, 0) + 1
            current = current.next
        
        # Удаляем элементы с частотой 1
        prev = None
        current = self._head
        while current:
            if frequency[current.data] == 1:
                if prev:
                    prev.next = current.next
                else:
                    self._head = current.next
                self._size -= 1
            else:
                prev = current
            current = current.next
        
        self._update_tail()

    # 16. Количество различных в возрастающей последовательности
    def count_distinct_in_sorted(self) -> int:
        if self._head is None:
            return 0
        
        count = 1
        current = self._head
        
        while current.next:
            if current.data != current.next.data:
                count += 1
            current = current.next
        
        return count

    # 17. Удалить четные числа
    def remove_even_numbers(self) -> None:
        # Удаляем с начала пока голова четная
        while self._head and self._head.data % 2 == 0:
            self._head = self._head.next
            self._size -= 1
        
        if self._head is None:
            self._tail = None
            return
        
        # Удаляем четные в середине/конце
        current = self._head
        while current and current.next:
            if current.next.data % 2 == 0:
                current.next = current.next.next
                self._size -= 1
            else:
                current = current.next
        
        self._update_tail()

    # 18. Преобразовать четные/нечетные
    def transform_even_odd(self) -> None:
        current = self._head
        while current:
            if current.data % 2 == 0:
                current.data = current.data // 2
            else:
                current.data = current.data * 2
            current = current.next

    # 19. Есть ли элементы больше суммы всех
    def has_elements_greater_than_sum(self) -> bool:
        if self._head is None:
            return False
        
        total_sum = 0
        current = self._head
        while current:
            total_sum += current.data
            current = current.next
        
        current = self._head
        while current:
            if current.data > total_sum:
                return True
            current = current.next
        
        return False

    # 20. Удалить элементы, входящие более двух раз
    def remove_elements_more_than_twice(self) -> None:
        if self._head is None:
            return
        
        # Считаем частоты
        frequency = {}
        current = self._head
        while current:
            frequency[current.data] = frequency.get(current.data, 0) + 1
            current = current.next
        
        # Удаляем элементы с частотой > 2
        count = {}
        prev = None
        current = self._head
        
        while current:
            count[current.data] = count.get(current.data, 0) + 1
            
            if frequency[current.data] > 2 and count[current.data] > 2:
                # Удаляем лишние вхождения
                if prev:
                    prev.next = current.next
                else:
                    self._head = current.next
                self._size -= 1
            else:
                prev = current
            
            current = current.next
        
        self._update_tail()

    # 21. Среднее арифметическое
    def arithmetic_mean(self) -> float:
        if self._head is None:
            return 0.0
        
        total_sum = 0
        count = 0
        current = self._head
        
        while current:
            total_sum += current.data
            count += 1
            current = current.next
        
        return total_sum / count

    # 22. Слияние двух отсортированных списков
    def merge_sorted(self, other: 'SingleLinkedList_v8') -> 'SingleLinkedList_v8':
        result = SingleLinkedList_v8()
        current1 = self._head
        current2 = other._head
        
        while current1 and current2:
            if current1.data <= current2.data:
                result.insert_last_node(current1.data)
                current1 = current1.next
            else:
                result.insert_last_node(current2.data)
                current2 = current2.next
        
        # Добавляем оставшиеся элементы
        while current1:
            result.insert_last_node(current1.data)
            current1 = current1.next
        
        while current2:
            result.insert_last_node(current2.data)
            current2 = current2.next
        
        return result

    # 23. Удалить каждый третий элемент
    def remove_every_third(self) -> None:
        if self._head is None:
            return
        
        count = 1
        prev = None
        current = self._head
        
        while current:
            if count % 3 == 0:
                if prev:
                    prev.next = current.next
                else:
                    self._head = current.next
                self._size -= 1
            else:
                prev = current
            
            current = current.next
            count += 1
        
        self._update_tail()

    # 24. Простые числа
    def filter_primes(self) -> 'SingleLinkedList_v8':
        def is_prime(n):
            if n < 2:
                return False
            for i in range(2, int(n**0.5) + 1):
                if n % i == 0:
                    return False
            return True
        
        result = SingleLinkedList_v8()
        current = self._head
        
        while current:
            if is_prime(int(current.data)):
                result.insert_last_node(current.data)
            current = current.next
        
        return result

    # 25. Проверка на равенство множеств
    def sets_equal(self, other: 'SingleLinkedList_v8') -> bool:
        set1 = set()
        set2 = set()
        
        current = self._head
        while current:
            set1.add(current.data)
            current = current.next
        
        current = other._head
        while current:
            set2.add(current.data)
            current = current.next
        
        return set1 == set2

    # 26. Среднее арифметическое (дубликат)
    def average(self) -> float:
        return self.arithmetic_mean()

    # 27. Элементы, делящиеся на 3, в порядке убывания
    def divisible_by_three_descending(self) -> 'SingleLinkedList_v8':
        result = SingleLinkedList_v8()
        current = self._head
        
        while current:
            if current.data % 3 == 0:
                result.insert_last_node(current.data)
            current = current.next
        
        result.sort()
        result.reverse()
        return result

    # 28. Удалить все минимальные элементы
    def remove_all_minimal(self) -> None:
        if self._head is None:
            return
        
        # Находим минимум
        min_val = self._head.data
        current = self._head.next
        while current:
            if current.data < min_val:
                min_val = current.data
            current = current.next
        
        # Удаляем все минимальные
        while self._head and self._head.data == min_val:
            self._head = self._head.next
            self._size -= 1
        
        if self._head is None:
            self._tail = None
            return
        
        current = self._head
        while current and current.next:
            if current.next.data == min_val:
                current.next = current.next.next
                self._size -= 1
            else:
                current = current.next
        
        self._update_tail()

    # 29. Среднее геометрическое
    def geometric_mean(self) -> float:
        if self._head is None:
            return 0.0
        
        product = 1
        count = 0
        current = self._head
        
        while current:
            product *= current.data
            count += 1
            current = current.next
        
        return product ** (1 / count)

    # 30. Добавить сумму трех предыдущих после каждого третьего
    def add_sum_of_three_after_every_third(self) -> None:
        if self._size < 3:
            return
        
        count = 1
        current = self._head
        
        while current and current.next and current.next.next:
            if count % 3 == 0:
                # Находим три предыдущих элемента
                prev3 = current
                prev2 = current.next if current.next else None
                prev1 = current.next.next if current.next and current.next.next else None
                
                if prev3 and prev2 and prev1:
                    sum_three = prev3.data + prev2.data + prev1.data
                    new_node = Node(sum_three, current.next)
                    current.next = new_node
                    self._size += 1
                    current = new_node
            
            current = current.next
            count += 1
        
        self._update_tail()

    # 31. Разделить на четные и нечетные
    def split_even_odd(self) -> tuple:
        even = SingleLinkedList_v8()
        odd = SingleLinkedList_v8()
        
        current = self._head
        while current:
            if current.data % 2 == 0:
                even.insert_last_node(current.data)
            else:
                odd.insert_last_node(current.data)
            current = current.next
        
        return even, odd

    # 32. Продублировать простые числа
    def duplicate_primes(self) -> None:
        def is_prime(n):
            if n < 2:
                return False
            for i in range(2, int(n**0.5) + 1):
                if n % i == 0:
                    return False
            return True
        
        current = self._head
        while current:
            if is_prime(int(current.data)):
                new_node = Node(current.data, current.next)
                current.next = new_node
                current = new_node.next
                self._size += 1
            else:
                current = current.next
        
        self._update_tail()

    # 33. Попарные произведения
    def pairwise_product(self, other: 'SingleLinkedList_v8') -> 'SingleLinkedList_v8':
        result = SingleLinkedList_v8()
        current1 = self._head
        current2 = other._head
        
        while current1 and current2:
            result.insert_last_node(current1.data * current2.data)
            current1 = current1.next
            current2 = current2.next
        
        return result

    # 34. Количество различных значений
    def count_distinct(self) -> int:
        distinct = set()
        current = self._head
        
        while current:
            distinct.add(current.data)
            current = current.next
        
        return len(distinct)

    # 35. Удалить все максимальные элементы
    def remove_all_maximal(self) -> None:
        if self._head is None:
            return
        
        # Находим максимум
        max_val = self._head.data
        current = self._head.next
        while current:
            if current.data > max_val:
                max_val = current.data
            current = current.next
        
        # Удаляем все максимальные
        while self._head and self._head.data == max_val:
            self._head = self._head.next
            self._size -= 1
        
        if self._head is None:
            self._tail = None
            return
        
        current = self._head
        while current and current.next:
            if current.next.data == max_val:
                current.next = current.next.next
                self._size -= 1
            else:
                current = current.next
        
        self._update_tail()

    # 36. Проверка на геометрическую прогрессию
    def is_geometric_progression(self) -> bool:
        if self._head is None or self._head.next is None:
            return True
        
        current = self._head
        ratio = None
        
        while current and current.next:
            if current.data == 0:
                return False  # Ноль нарушает прогрессию
            
            current_ratio = current.next.data / current.data
            
            if ratio is None:
                ratio = current_ratio
            elif abs(current_ratio - ratio) > 1e-10:  # Учет погрешности для float
                return False
            
            current = current.next
        
        return True

    # 37. Поменять местами максимальный и минимальный элементы
    def swap_min_max(self) -> None:
        if self._head is None or self._head.next is None:
            return
        
        # Находим min и max узлы
        min_node = max_node = self._head
        current = self._head
        
        while current:
            if current.data < min_node.data:
                min_node = current
            if current.data > max_node.data:
                max_node = current
            current = current.next
        
        # Меняем значения
        min_node.data, max_node.data = max_node.data, min_node.data

    # Вспомогательные методы
    def contains(self, value: Any) -> bool:
        current = self._head
        while current:
            if current.data == value:
                return True
            current = current.next
        return False

    def _update_tail(self) -> None:
        if self._head is None:
            self._tail = None
            return
        
        current = self._head
        while current and current.next:
            current = current.next
        self._tail = current
```

```{code-cell} ipython3

```
