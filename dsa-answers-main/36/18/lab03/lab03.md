# Л.Р. 3 - "Линейные списки"

**Цао М.М.**

**ИУ10-36**



### Задания
### 1) Последовательно реализовать 6 версий линейного односвязного списка.

**Версия №1 - Базовая структура**
```python
def __str__(self):
    # Проверка на пустой список
        if self.is_empty():
            return "Пустой список"
        # Сбор всех элементов списка
        elements = []
        current = self.head
        while current:
            elements.append(str(current.data))
            current = current.next
        return " -> ".join(elements) + " -> None" # Формируем строку со стрелками и указываем конец списка
```

**Версия №2 - Операции вставки**
```python
def insert_at_beginning(self, data):
        new_node = Node(data)
        new_node.next = self.head  
        self.head = new_node      
        print(f"Вставлен в начало: {data}")
    
    def insert_at_end(self, data):
        new_node = Node(data)
        
        if self.is_empty():
            self.head = new_node
        else:
            # Ищем последний узел (у которого next = None)
            current = self.head
            while current.next:
                current = current.next
            # Добавляем новый узел после последнего
            current.next = new_node 
        print(f"Вставлен в конец: {data}")
```
**Версия №3 - Операции удаления**
```python
def delete_from_beginning(self):
        if self.is_empty():
            print("Список пуст, удалять нечего")
            return None
        # Сохраняем данные удаляемого элемента
        deleted_data = self.head.data
        self.head = self.head.next # Смещаем голову на следующий элемент
        print(f"Удален из начала: {deleted_data}")
        return deleted_data
    
    def delete_from_end(self):
        if self.is_empty():
            print("Список пуст, удалять нечего")
            return None
            
        # Особый случай: в списке только один элемент
        if self.head.next is None:  
            deleted_data = self.head.data
            self.head = None
            print(f"Удален из конца: {deleted_data}")
            return deleted_data

        current = self.head
        while current.next.next:
            current = current.next
        # Удаляем последний элемент
        deleted_data = current.next.data
        current.next = None  
        print(f"Удален из конца: {deleted_data}")
        return deleted_data
```

**Версия №4 - Поиск**
```python
def search(self, data):
    # Начинаем с головного элемента
        current = self.head
        index = 0
        # Проходим по всем элементам списка
        while current:
            if current.data == data:
                print(f"Элемент {data} найден на позиции {index}")
                return index
            current = current.next
            index += 1
        
        print(f"Элемент {data} не найден")
        return -1
```
**Поиск по индексу**
```python
def get_at_index(self, index):
     # Проверка валидности индекса
        if index < 0:
            print("Индекс должен быть неотрицательным")
            return None
        # Начинаем с головного элемента
        current = self.head
        current_index = 0
         # Перемещаемся до нужного индекса
        while current and current_index < index:
            current = current.next
            current_index += 1
        # Проверка выхода за границы списка
        if current is None:
            print(f"Индекс {index} выходит за границы списка")
            return None
        # Возвращаем данные найденного элемента
        print(f"Элемент на позиции {index}: {current.data}")
        return current.data
```

**Версия №5 - Вставка после узла**
```python 
def insert_after_value(self, target_data, new_data):
        current = self.head
        # Поиск элемента с заданным значением
        while current:
            if current.data == target_data:
                # Создаем новый узел и вставляем после найденного
                new_node = Node(new_data)
                new_node.next = current.next
                current.next = new_node      
                print(f"Вставлен {new_data} после {target_data}")
                return True
            current = current.next
        
        print(f"Элемент {target_data} не найден для вставки после")
        return -1
def get_length(self):
        count = 0
        current = self.head
        # Подсчет элементов через обход всего списка
        while current:
            count += 1
            current = current.next
        return count
```

**Версия №6 - Удаление по значению**
```python 
def delete_by_value(self, data):
        if self.is_empty():
            print("Список пуст, удалять нечего")
            return False
        
        if self.head.data == data:
            self.delete_from_beginning()
            return True

        current = self.head
        while current.next:
            if current.next.data == data:
                # deleted_data = current.next.data
                current.next = current.next.next 
                print(f"Удален элемент: {data}")
                return True
            current = current.next
        
        print(f"Элемент {data} не найден для удаления")
        return -1
    
    def clear(self):
        self.head = None
        print("Список очищен")
```

### 2) Реализовать метод reverse для «переворота» линейного списка.
```python
class LinkedListV7(LinkedListV6):
    def reverse(self):
        # Проверка на пустой список или список с одним элементом
        if self.is_empty() or self.head.next is None:
            return
        
        previous = None # Предыдущий элемент (изначально None)
        current = self.head # Текущий элемент (начинаем с головы)
         # Итеративное разворачивание связей
        while current:
            next_node = current.next
            current.next = previous
            previous = current
            current = next_node
        # Новая голова - последний элемент исходного списка
        self.head = previous
```

### 3) Реализовать метод sort для сортировки линейного списка на месте.
**Поскольку метод был реализован без наследования, то сначала пишем структуру Node**
```python 
class Node:
    def __init__(self, data=None):
        self.data = data
        self.next = None
```
**Реализация метода sort**
```python
class LinkedList:
    def __init__(self):
        self.head = None
    
    def is_empty(self):
        return self.head is None
        
    def insert_at_end(self, data):
        new_node = Node(data)
        if self.is_empty():
            self.head = new_node
        else:
            current = self.head
            while current.next:
                current = current.next
            current.next = new_node
    
    def __str__(self):
        if self.is_empty():
            return "Пустой список"
        elements = []
        current = self.head
        while current:
            elements.append(str(current.data))
            current = current.next
        return " -> ".join(elements) + " -> None"
    
    def sort(self):
        # Проверка на пустой список или список с одним элементом
        if self.is_empty() or self.head.next is None:
            return
        
        sorted_head = None  # Голова отсортированного списка
        current = self.head
        
        # Построение нового отсортированного списка
        while current:
            next_node = current.next  # Сохраняем следующий элемент
            # Вставляем текущий элемент в отсортированный список
            sorted_head = self._insert_sorted(sorted_head, current)
            current = next_node
        
        self.head = sorted_head  # Обновляем голову
    
    def _insert_sorted(self, sorted_head, new_node):
        new_node.next = None  # Отсоединяем узел от исходного списка
        
        # Если отсортированный список пуст
        if sorted_head is None:
            return new_node
        
        # Вставка в начало отсортированного списка
        if new_node.data <= sorted_head.data:
            new_node.next = sorted_head
            return new_node
        
        # Поиск позиции для вставки в середину/конец
        current = sorted_head
        while current.next and current.next.data < new_node.data:
            current = current.next
        
        # Вставка узла в найденную позицию
        new_node.next = current.next
        current.next = new_node
        return sorted_head
```

### 4) Реализовать индивидуальные задание.
**Структура Node**
```python
class Node:
    def __init__(self, data=None):
        self.data = data
        self.next = None
```

**Задание: Имеется список целых чисел. Все нечетные числа в нем умножить на 2, все четные разделить на 2.**
```python
class LinkedList:
    def __init__(self):
        self.head = None
    
    def is_empty(self):
        return self.head is None
    
    def insert_at_end(self, data):
        new_node = Node(data)
        if self.is_empty():
            self.head = new_node
        else:
            current = self.head
            while current.next:
                current = current.next
            current.next = new_node
    
    def transform_even_odd(self):
        # Проход по всем элементам списка
        current = self.head
        while current:
            if current.data % 2 == 0:  
                current.data = current.data // 2 #четные числа
            else: 
                current.data = current.data * 2 #нечетные числа
            current = current.next
    def __str__(self):
        if self.is_empty():
            return "Пустой список"
        elements = []
        current = self.head
        while current:
            elements.append(str(current.data))
            current = current.next
        return " -> ".join(elements) + " -> None"
```

### 5) Опционально: реализовать один из видов циклов, рассмотренных на лекции.
**Реализация цикла со сдвигом вправо**
```python
class ArrayWithShift:
    def __init__(self, capacity=10):
        self.capacity = capacity
        self.size = 0
        self.array = [None] * capacity # Инициализация массива
    
    def insert_with_shift(self, index, element):
        # Проверка переполнения
        if self.size >= self.capacity:
            raise Exception("Массив переполнен")
        # Сдвиг элементов вправо начиная с конца до позиции index
        for i in range(self.size - 1, index - 1, -1):
            self.array[i + 1] = self.array[i]
        
        self.array[index] = element
        self.size += 1
    
    def __str__(self):
        return f"[{', '.join(str(x) for x in self.array[:self.size])}]" # Строковое представление только заполненной части массива
```

### Индивидуальные задания: 
### Задание №1

**Общая структура Линейного списка**
```python
class Node:
    def __init__(self, data=None):
        self.data = data
        self.next = None

class LinkedList:
    def __init__(self):
        self.head = None
    
    def insert_at_end(self, data):
        new_node = Node(data)
        if not self.head:
            self.head = new_node
        else:
            current = self.head
            while current.next:
                current = current.next
            current.next = new_node
    
    def __str__(self):
        elements = []
        current = self.head
        while current:
            elements.append(str(current.data))
            current = current.next
        return " -> ".join(elements) + " -> None"
```

**1. Написать функцию, которая по двум линейным спискам L1 и L2 формирует новый список L, состоящий из элементов, входящих в L1, но не входящих в L2.**
```python
def difference(self, other):
        # Создание нового списка для результата
        result = LinkedList()
        current = self.head
        # Проход по всем элементам текущего списка
        while current:
            if not other.contains(current.data): # Если элемент не содержится в другом списке, добавляем в результат
                result.insert_at_end(current.data)
            current = current.next
        return result
    
    def contains(self, data):
        current = self.head
        while current: # Линейный поиск элемента в списке
            if current.data == data:
                return True
            current = current.next
        return -1
```

**2. Найти количество максимальных элементов списка действительных чисел.**
```python
def count_max_elements(self):
        if not self.head:
            return 0
        max_val = self.head.data
        count = 1
        current = self.head.next
        while current:
            if current.data > max_val:
                max_val = current.data
                count = 1
            elif current.data == max_val:
                count += 1
            current = current.next
        return count
```

**3. Сформировать список целых чисел, вводимых пользователем, в том порядке, в котором вводятся эти числа, но без повторений элементов.**
```python
def create_unique_from_input():
        result = LinkedList()
        seen = set()
        numbers = input("Введите числа через пробел: ").split()
        for num in numbers:
            if num not in seen:
                result.insert_at_end(int(num))
                seen.add(num)
        return result
```

**4. Пусть имеется список L1 действительных чисел. Записать в список L2 все элементы списка L1 в порядке возрастания их значений**
```python
def sorted_copy(self):
        elements = []
        current = self.head
        while current:
            elements.append(current.data)
            current = current.next
        elements.sort()
        result = LinkedList()
        for elem in elements:
            result.insert_at_end(elem)
        return result
```

**5.Написать функцию, которая оставляет в списке L только последние вхождения одинаковых элементов.**
```python
def keep_last_occurrences(self):
        last_occurrence = {}
        current = self.head
        index = 0
        while current:
            last_occurrence[current.data] = index
            current = current.next
            index += 1
        
        current = self.head
        prev = None
        index = 0
        while current:
            if last_occurrence[current.data] != index:
                if prev:
                    prev.next = current.next
                else:
                    self.head = current.next
            else:
                prev = current
            current = current.next
            index += 1
```

**6. Написать функцию, которая в линейном списке из каждой группы подряд идущих одинаковых элементов оставляет только один.**
```python
def remove_consecutive_duplicates(self):
        if not self.head:
            return
        current = self.head
        while current and current.next:
            if current.data == current.next.data:
                current.next = current.next.next
            else:
                current = current.next
```

**7. Написать функцию, которая по двум линейным спискам L1 и L2 формирует новый список L, состоящий из элементов, входящих в оба списка.**
```python
def intersection(self, other):
        result = LinkedList()
        current = self.head
        while current:
            if other.contains(current.data):
                result.insert_at_end(current.data)
            current = current.next
        return result
```

**8.Написать функцию, которая по списку L строит два новых списка: L1 – из положительных элементов и L2 – из отрицательных элементов списка L.**
```python
def split_by_sign(self):
        positive = LinkedList()
        negative = LinkedList()
        current = self.head
        while current:
            if current.data >= 0:
                positive.insert_at_end(current.data)
            else:
                negative.insert_at_end(current.data)
            current = current.next
        return positive, negative
```

**9. Имеется список целых чисел. Продублировать в нем все четные числа.**
```python
def duplicate_even_numbers(self):
        current = self.head
        while current:
            if current.data % 2 == 0:
                new_node = Node(current.data)
                new_node.next = current.next
                current.next = new_node
                current = new_node.next
            else:
                current = current.next
```

**10. Определить, является ли список упорядоченным по возрастанию.**
```python
def is_sorted(self):
        if not self.head:
            return True
        current = self.head
        while current.next:
            if current.data > current.next.data:
                return False
            current = current.next
        return True
```

**11. Имеется список целых чисел. Удалить из него все нечетные числа.**
```python
def remove_odd_numbers(self):
        while self.head and self.head.data % 2 != 0:
            self.head = self.head.next
        
        current = self.head
        while current and current.next:
            if current.next.data % 2 != 0:
                current.next = current.next.next
            else:
                current = current.next
```

**12. Написать функцию, которая оставляет в списке L только первые вхождения одинаковых элементов.**
```python
def keep_first_occurrences(self):
        seen = set()
        current = self.head
        prev = None
        while current:
            if current.data in seen:
                if prev:
                    prev.next = current.next
                else:
                    self.head = current.next
            else:
                seen.add(current.data)
                prev = current
            current = current.next
```

**13. Пусть имеется список действительных чисел a 1 → a 2 → … → a n . Сформировать новый список b 1 → b 2 → … → b n такой же размерности по следующему правилу: элемент b k равен сумме элементов исходного списка с номерами от 1 до k**
```python
def partial_sums(self):
        result = LinkedList()
        current_sum = 0
        current = self.head
        while current:
            current_sum += current.data
            result.insert_at_end(current_sum)
            current = current.next
        return result
```

**14. Написать функцию, которая по двум данным линейным спискам формирует новый список, состоящий из элементов, одновременно входящих в оба данных списка.**
```python
def common_elements(self, other):
        return self.intersection(other)
```

**15. Написать функцию, которая удаляет из списка элементы, входящие в него только один раз.**
```python
def remove_unique_elements(self):
        frequency = {}
        current = self.head
        while current:
            frequency[current.data] = frequency.get(current.data, 0) + 1
            current = current.next
        
        current = self.head
        prev = None
        while current:
            if frequency[current.data] == 1:
                if prev:
                    prev.next = current.next
                else:
                    self.head = current.next
            else:
                prev = current
            current = current.next
```

**16. Определить количество различных элементов списка действительных чисел, если известно, что его элементы образуют возрастающую последовательность.**
```python
def count_distinct_in_sorted(self):
        # Проверка на пустой список
        if not self.head:
            return 0
        count = 1
        current = self.head
        while current.next: # Проход по отсортированному списку
            if current.data != current.next.data: # Сравниваем текущий элемент со следующим
                count += 1
            current = current.next
        return count
```

**17. Имеется список целых чисел. Удалить из него все четные числа.**
```python
def remove_even_numbers(self):
        while self.head and self.head.data % 2 == 0:
            self.head = self.head.next
        
        current = self.head
        while current and current.next:
            if current.next.data % 2 == 0:
                current.next = current.next.next
            else:
                current = current.next
```

**18. Имеется список целых чисел. Все нечетные числа в нем умножить на 2, все четные разделить на 2.**
```python
def transform_even_odd(self):
        current = self.head
        while current:
            if current.data % 2 == 0:
                current.data = current.data // 2
            else:
                current.data = current.data * 2
            current = current.next
```

**19. Определить, есть ли в списке действительных чисел элементы, превосходящие сумму всех элементов списка.**
```python
def elements_exceeding_sum(self):
        total_sum = 0
        current = self.head
        while current:
            total_sum += current.data
            current = current.next
        
        result = LinkedList()
        current = self.head
        while current:
            if current.data > total_sum:
                result.insert_at_end(current.data)
            current = current.next
        return result
```

**20. Написать функцию, которая удаляет из списка элементы, входящие в него только более двух раз.**
```python
def remove_elements_more_than_twice(self):
        frequency = {}
        current = self.head
        while current:
            frequency[current.data] = frequency.get(current.data, 0) + 1
            current = current.next
        
        current = self.head
        prev = None
        while current:
            if frequency[current.data] > 2:
                if prev:
                    prev.next = current.next
                else:
                    self.head = current.next
            else:
                prev = current
            current = current.next
```

**21. Вычислите среднее арифметическое элементов непустого списка.**
```python
def arithmetic_mean(self):
        if not self.head:
            return 0
        total_sum = 0
        count = 0
        current = self.head
        while current:
            total_sum += current.data
            count += 1
            current = current.next
        return total_sum / count
```

**22. Пусть имеются два списка, элементы которых упорядочены по возрастанию. Сформировать новый список из элементов первого и второго списка, элементы которого будут упорядочены.**
```python
@staticmethod
    def merge_sorted(l1, l2):
        result = LinkedList()
        current1 = l1.head
        current2 = l2.head
        
        while current1 and current2:
            if current1.data <= current2.data:
                result.insert_at_end(current1.data)
                current1 = current1.next
            else:
                result.insert_at_end(current2.data)
                current2 = current2.next
        
        while current1:
            result.insert_at_end(current1.data)
            current1 = current1.next
        
        while current2:
            result.insert_at_end(current2.data)
            current2 = current2.next
        
        return result
```

**23. Пусть имеется список L. Удалить из него каждый третий элемент.**
```python
def remove_every_third(self):
        if not self.head:
            return
        
        current = self.head
        prev = None
        index = 1
        
        while current:
            if index % 3 == 0:
                if prev:
                    prev.next = current.next
                else:
                    self.head = current.next
            else:
                prev = current
            current = current.next
            index += 1
```

**24. Пусть имеется список L1 действительных чисел. Сформировать новый список L2, состоящий элемнтов списка L1, которые являются простыми числами.**
```python
def get_primes(self):
        def is_prime(n):
            if n < 2:
                return False
            for i in range(2, int(n**0.5) + 1):
                if n % i == 0:
                    return False
            return True
        
        result = LinkedList()
        current = self.head
        while current:
            if is_prime(int(current.data)):
                result.insert_at_end(current.data)
            current = current.next
        return result
```

**25. Даны два списка. Определите, совпадают ли множества их элементов.**
```python
def have_same_elements(self, other):
        set1 = set()
        set2 = set()
        
        current = self.head
        while current:
            set1.add(current.data)
            current = current.next
        
        current = other.head
        while current:
            set2.add(current.data)
            current = current.next
        
        return set1 == set2
```

**26. Вычислите среднее арифметическое элементов непустого списка.**
```python
def average(self):
        return self.arithmetic_mean()
```

**27. Пусть имеется список L1 действительных чисел. Записать в список L2 все элементы списка L1, делящиеся на 3 в порядке убывания.**
```python
def get_divisible_by_three_descending(self):
        result = LinkedList()
        current = self.head
        while current:
            if current.data % 3 == 0:
                result.insert_at_end(current.data)
            current = current.next
        
        elements = []
        current = result.head
        while current:
            elements.append(current.data)
            current = current.next
        
        elements.sort(reverse=True)
        sorted_result = LinkedList()
        for elem in elements:
            sorted_result.insert_at_end(elem)
        
        return sorted_result
```

**28. Удалить из списка действительных чисел все минимальные элементы.**
```python
def remove_all_minimal(self):
        if not self.head:
            return
        
        min_val = self.head.data
        current = self.head.next
        while current:
            if current.data < min_val:
                min_val = current.data
            current = current.next
        
        while self.head and self.head.data == min_val:
            self.head = self.head.next
        
        current = self.head
        while current and current.next:
            if current.next.data == min_val:
                current.next = current.next.next
            else:
                current = current.next
```

**29. Вычислите среднее геометрическое элементов непустого списка.**
```python
def geometric_mean(self):
        if not self.head:
            return 0
        product = 1
        count = 0
        current = self.head
        while current:
            product *= current.data
            count += 1
            current = current.next
        return product ** (1 / count)
```

**30. Пусть имеется список целых чисел L. Добавьте после каждого третьего элемента новый элемент, равный сумме трех предыдущих.**
```python
def add_sum_of_three_after_every_third(self):
        if not self.head or not self.head.next or not self.head.next.next:
            return
        
        current = self.head.next.next
        index = 3
        
        while current:
            if index % 3 == 0:
                prev1 = self._get_node_at_position(index - 3)
                prev2 = self._get_node_at_position(index - 2)
                prev3 = self._get_node_at_position(index - 1)
                
                if prev1 and prev2 and prev3:
                    sum_value = prev1.data + prev2.data + prev3.data
                    new_node = Node(sum_value)
                    new_node.next = current.next
                    current.next = new_node
                    current = new_node.next
                    index += 2
                else:
                    current = current.next
                    index += 1
            else:
                current = current.next
                index += 1
    
    def _get_node_at_position(self, pos):
        if pos < 1:
            return None
        current = self.head
        count = 1
        while current and count < pos:
            current = current.next
            count += 1
        return current
```

**31. Написать функцию, которая по списку L строит два новых списка: L1 – из четных и L2 – из нечетных элементов списка L.**
```python
def split_even_odd(self):
        even = LinkedList()
        odd = LinkedList()
        current = self.head
        while current:
            if current.data % 2 == 0:
                even.insert_at_end(current.data)
            else:
                odd.insert_at_end(current.data)
            current = current.next
        return even, odd
```

**32. Дан список целых чисел. Продублировать в нем все простые числа.**
```python
def duplicate_primes(self):
        def is_prime(n):
            if n < 2:
                return False
            for i in range(2, int(n**0.5) + 1):
                if n % i == 0:
                    return False
            return True
        
        current = self.head
        while current:
            if is_prime(int(current.data)):
                new_node = Node(current.data)
                new_node.next = current.next
                current.next = new_node
                current = new_node.next
            else:
                current = current.next
```

**33. Написать функцию, которая по двум линейным спискам L1 и L2 формирует новый список L, состоящий из попарных произведений элементов L1 и L2. Длина формируемого списка ограничивается длиной меньшего из списков L1, L2.**
```python

```

**34. Определение, сколько различных значений содержится в списке.**
```python
@staticmethod
    def pairwise_product(l1, l2):
        result = LinkedList()
        current1 = l1.head
        current2 = l2.head
        
        while current1 and current2:
            result.insert_at_end(current1.data * current2.data)
            current1 = current1.next
            current2 = current2.next
        
        return result
```

**35. Удалить из списка действительных чисел все максимальные элементы.**
```python
def remove_all_maximal(self):
        if not self.head:
            return
        
        max_val = self.head.data
        current = self.head.next
        while current:
            if current.data > max_val:
                max_val = current.data
            current = current.next
        
        while self.head and self.head.data == max_val:
            self.head = self.head.next
        
        current = self.head
        while current and current.next:
            if current.next.data == max_val:
                current.next = current.next.next
            else:
                current = current.next
```

**36. Определить, образуют ли элементы списка действительных чисел геометрическую прогрессию.**
```python
def is_geometric_progression(self):
        if not self.head or not self.head.next:
            return True
        
        if self.head.data == 0:
            return False
        
        ratio = self.head.next.data / self.head.data
        current = self.head
        
        while current.next:
            if current.next.data / current.data != ratio:
                return False
            current = current.next
        
        return True
```

**37. Пусть имеется список целых чисел L. Обменяйте местами максимальный и минимальный элемент списка.**
```python
def swap_max_min(self):
        if not self.head or not self.head.next:
            return
        
        min_node = max_node = self.head
        current = self.head.next
        
        while current:
            if current.data < min_node.data:
                min_node = current
            if current.data > max_node.data:
                max_node = current
            current = current.next
        
        min_node.data, max_node.data = max_node.data, min_node.data
```


**Выводы:**
1) Линейные списки обеспечивают эффективное выполнение операций вставки и удаления элементов в начале и середине списка (O(1) при известном узле),что делает их предпочтительными перед массивами для задач с частыми модификациями данных.

2) Динамическая природа списков позволяет легко изменять размер структуры данных во время выполнения программы без необходимости перераспределения памяти, в отличие от статических массивов.

3) Основным недостатком линейных списков является последовательный доступ к элементам (O(n)), что делает их менее эффективными для задач, требующих частого произвольного доступа по индексу.

4) Реализация различных алгоритмов обработки списков (сортировка, поиск, фильтрация) показала важность правильного управления указателями для предотвращения утечек памяти и обеспечения корректности операций.

5) Многообразие практических заданий продемонстрировало широкую применимость линейных списков для решения реальных задач, таких как обработка последовательностей, удаление дубликатов и работа с множествами.