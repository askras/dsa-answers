# Линейные списки (Linked list)
Баскаков Д. С.
ИУ10-38

## Цель работы:
изучение структуры данных «Линейные списки», а также основных операций над ними.

Линейный список — это структура данных, представляющая собой конечный, упорядоченный набор элементов, называемых узлами (нодами). Порядок элементов определяется не их физическим расположением в памяти, а explicit ссылочными связями между ними.                                                                            
Основное преимущество списков перед массивами — динамичность: размер списка может легко изменяться во время выполнения программы без необходимости выделения непрерывной области памяти и копирования данных.

## Задания
1. Последовательно реализовать 6 версий линейного односвязного списка.               
2. Реализовать метод reverse для «переворота» линейного списка.              
3. Реализовать метод sort для сортировки линейного списка на месте.                                      
4. Реализовать индивидуальные задание.                                 
   
### Индивидуальное задание
Сформировать список целых чисел, вводимых пользователем, в том порядке, в котором вводятся эти числа, но без повторений элементов.


```python
class Node:
    def __init__(self, data=None, next=None):
        self.data = data
        self.next = next

    def __repr__(self):
        return f'Node({self.data}, {self.next})'


class LinkedList:
    def __init__(self):
        self.head = None

    def insert_first(self, val):
        self.head = Node(val, self.head)

    def insert_last(self, val):
        if self.head is None:
            self.insert_first(val)
        else:
            cur = self.head
            while cur.next is not None:
                cur = cur.next
            cur.next = Node(val)

    def print_list(self):
        cur = self.head
        while cur:
            print(cur.data, end=' ')
            cur = cur.next
        print()

    def reverse(self):
        prev = None
        cur = self.head
        while cur:
            next_node = cur.next
            cur.next = prev
            prev = cur
            cur = next_node
        self.head = prev

    def sort(self):
        vals = []
        cur = self.head
        while cur:
            vals.append(cur.data)
            cur = cur.next
        vals.sort()
        self.head = None
        for v in vals:
            self.insert_last(v)

    def has(self, val):
        cur = self.head
        while cur:
            if cur.data == val:
                return True
            cur = cur.next
        return False


# Задание 3
def f:
    lst = LinkedList()
    while True:
        s = input()
        x = int(s)
        if not lst.has(x):
            lst.insert_last(x)
    lst.print_list()

```


    
