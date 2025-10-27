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
5. Опционально: реализовать один из видов циклов, рассмотренных на лекции.
   
### Индивидуальное задание
Сформировать список целых чисел, вводимых пользователем, в том порядке, в котором вводятся эти числа, но без повторений элементов.


```python
import random
import functools
import timeit
import typing
import matplotlib.pyplot as plt
%matplotlib inline

from typing import Any, Self

import doctest

class Node:
    '''Узел списка'''

    def __init__(self, data:Any=None, next:'Node'=None):
        self.data = data
        self.next = next

    def __repr__(self):
         return f'{self.__class__.__name__}(data={self.data}, next={self.next})'

def print_list(node):
    while node is not None:
        print(node)
        node = node.next

class SingleLinkedList_v1:
    '''Реализация АТД Односвязный линейный список  (SingleLinkedList_v1) '''
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
        '''строковое представление объекта'''
        return f'{self.__class__.__name__}({self._head})'

    def __str__(self):
        ''' получение читаемого представления объекта'''
        node = self._head
        l = []
        while node:
            l.append(str(node.data))
            node = node.next
        return 'LinkedList.head -> ' + ' -> '.join(l) + ' -> None'

    def fill_list(self, n) -> Any:
        '''создать список из n элементов, заполненных случайными целыми числами'''
        self._head = None
        if n>0:
            for i in range (n,0,-1):
                k = random.randint(0,20)
                self._head = Node(k, self._head)

    def fill_sequent_list(self, n) -> Any:
        '''создать список из n элементов, заполненных послед.целыми числами'''
        self._head = None
        if n>0:
            for i in range (n,0,-1):
               self._head = Node(i, self._head)

class SingleLinkedList_v2(SingleLinkedList_v1):
    '''Реализация АТД Односвязный линейный список  (SingleLinkedList_v2) - добавлена длина, поиск по значению, замена и удаление '''           
    def get_size (self) -> int:
        '''Вернуть длину списка'''
        if self._head is None:
            return 0
        else:
            current_node = self._head
            len = 0
            while current_node is not None:
                len += 1
                current_node = current_node.next
            return len        

    def find_node(self, target_value):  
        """Найти первый узел с заданным значением"""  
        current_node = self._head  
        while current_node is not None:  
            if current_node.data == target_value:  
                return current_node  
            current_node = current_node.next  
        return None

    def replace_node (self, old_value, new_value) -> None:  
        """Найти (первый) узел по его значению и заменить его значение новым"""  
        current_node = self.find_node(old_value)
        if current_node is not None: 
            current_node.data = new_value
        return self

    def remove_node (self, target_value):  
        """Найти (первый) узел по его значению и удалить его"""  
        current_node = self._head
        prev_node = None
        while current_node is not None:  
            if current_node.data == target_value:  
                next_node = current_node.next
                if prev_node is not None:
                    prev_node.next = next_node
                else:
                    self._head = next_node
                return self  
            else:
                prev_node = current_node
                current_node = current_node.next  
        return self

class SingleLinkedList_v3(SingleLinkedList_v2):
    '''Реализация АТД Односвязный линейный список  (SingleLinkedList_v3) - сохранение значения длины'''   
    def __init__(self) -> Self:
        '''Возвращает пустой список'''
        self._head = None
        self._size = 0

    def get_size (self) -> int:
        '''Вернуть длину списка'''
        return self._size

    def insert_first_node(self, value:Any) -> None:
        '''Добавить элемент в начало списка'''
        self._head = Node(value, self._head)
        self._size+=1

    def remove_first_node(self) -> Any:
        '''Удалить первый элемент списка'''
        temp = self._head.data
        self._head = self._head.next
        self._size-=1
        return temp

    def insert_last_node(self, value:Any) -> None:
        '''Добавить элемент в конец списка'''
        self._size+=1
        if self._head is None:
            self.insert_first_node(value)
        else:
            current_node = self._head
            while current_node.next is not None:
                current_node = current_node.next
            current_node.next = Node(value)

    def remove_last_node(self) -> Any:
        '''Удалить последний элемент списка'''
        self._size-=1
        if self._head.next is None:
            return self.remove_first_node()
        else:
            current_node = self._head
            while current_node.next.next is not None:
                current_node = current_node.next
            temp = current_node.next.data
            current_node.next = None
            return temp

    def remove_node (self, target_value):  
        """Найти (первый) узел по его значению и удалить его"""  
        current_node = self._head
        prev_node = None
        while current_node is not None:  
            if current_node.data == target_value:  
                next_node = current_node.next
                self._size-=1
                if prev_node is not None:
                    prev_node.next = next_node
                else:
                    self._head = next_node
                return self  
            else:
                prev_node = current_node
                current_node = current_node.next  
        return self

    def fill_list(self, n) -> Any:
        '''создать список из n элементов, заполненных случайными целыми числами'''
        self._head = None
        self._size=0
        if n>0:
            for i in range (n,0,-1):
                k = random.randint(0,20)
                self._head = Node(k, self._head)
                self._size+=1

    def fill_sequent_list(self, n) -> Any:
        '''создать список из n элементов, заполненных послед.целыми числами'''
        self._head = None
        self._size=0
        if n>0:
            for i in range (n,0,-1):
               self._head = Node(i, self._head)
               self._size+=1

class SingleLinkedList_v4(SingleLinkedList_v3):
    '''Реализация АТД Односвязный линейный список  (SingleLinkedList_v4) - изменение / удаление / добавление предыдущих/следующих узлов при поиске'''

    def find_previos_node(self, target_value)  -> None:
        ''' Найти (первый) узел по его значению и вернуть значение из предудущего узла (если такой есть).'''
        current_node = self._head
        prev_node = None
        while current_node is not None:  
            if current_node.data == target_value:  
                if prev_node is not None:
                    return prev_node.data
                else:
                    return None
            prev_node = current_node
            current_node = current_node.next  
        return None

    def find_next_node(self, target_value) -> None :
        ''' Найти (первый) узел по его значению и вернуть значение из следующего узла (если такой есть).'''
        current_node = self.find_node(target_value)
        if current_node is not None: 
            next_node = current_node.next
            if next_node is not None: 
                return next_node.data
        return None

    def insert_before_node(self, target_value, new_node) -> None:
        ''' Найти (первый) узел по его значению и добавить узел перед ним. (Если узел не найден, ничего не делать)'''
        current_node = self._head
        prev_node = None
        while current_node is not None:  
            if current_node.data == target_value:
                new_node.next=current_node
                if prev_node  is  None:                    
                    self._head=new_node
                else:
                    prev_node.next=new_node                    
                self._size+=1                    
                return self  
            prev_node = current_node
            current_node = current_node.next  
        return self

    def insert_after_node(self, target_value, new_node) -> None:
        ''' Найти (первый) узел по его значению и добавить узел после него. (Если узел не найден, ничего не делать)'''
        current_node = self.find_node(target_value)
        if current_node is not None: 
            next_node = current_node.next
            current_node.next = new_node
            new_node.next=next_node
            self._size+=1 
        return self

    def replace_previos_node(self, target_value,  new_value) -> None:
        '''Найти (первый) узел по его значению и заменить значение в предыдущем узле на новое.'''
        current_node = self._head
        prev_node = None
        while current_node is not None:  
            if current_node.data == target_value:  
                if prev_node is not None:
                    prev_node.data = new_value
                    return self
                else:
                    return self
            prev_node = current_node
            current_node = current_node.next  
        return self

    def replace_next_node(self, target_value,  new_value) -> None:
        '''Найти (первый) узел по его значению и заменить значение в следующем узле на новое.'''
        current_node = self.find_node(target_value)
        if current_node is not None: 
            next_node = current_node.next
            if next_node is not None:
                next_node.data = new_value
        return self        

    def remove_previos_node(self, target_value) -> None:
        '''Найти (первый) узел по его значению и удалить предыдущий узел (если такой есть).'''
        current_node = self._head
        prev_node = None
        prev_prev_node = None
        while current_node is not None:  
            if current_node.data == target_value:  
                if prev_node is not None: # найденный элемент не первый
                    self._size-=1
                    if prev_prev_node is not None: # предыдущий элемент не первый
                        prev_prev_node.next = current_node                        
                    else:  # предыдущий элемент первый, теперь первым будет найденный
                        self._head = current_node
                    return self
                else: # найденный элемент первый, ничего не делаем
                    return self
            prev_prev_node = prev_node
            prev_node = current_node
            current_node = current_node.next  
        return self

    def remove_next_node(self, target_value) -> None:
        '''Найти (первый) узел по его значению и удалить следующий узел (если такой есть).'''
        current_node = self.find_node(target_value)
        if current_node is not None: 
            next_node = current_node.next
            if next_node is not None: # есть следующий элемент
                self._size-=1
                if next_node.next is not None: # следующий элемент не последний
                    next_next_node =next_node.next
                    current_node.next = next_next_node                        
                else:  # предыдущий элемент последний, теперь первым будет найденный
                    current_node.next = None
        return self    

class SingleLinkedList_v5(SingleLinkedList_v4):
    '''Реализация АТД Односвязный линейный список  (SingleLinkedList_v5) - добавлена ссылка на последний элемент '''
    def __init__(self) -> Self:
        '''Возвращает пустой список'''
        self._head = None
        self._tail = None
        self._size=0

    def insert_first_node(self, value:Any) -> None:
        '''Добавить элемент в начало списка'''
        self._head = Node(value, self._head)
        self._size+=1
        if self._size==1:
            self._tail =self._head

    def remove_first_node(self) -> Any:
        '''Удалить первый элемент списка'''
        temp = self._head.data
        self._head = self._head.next
        self._size-=1
        if self._size==0:
            self._tail = None
        if self._size==1:
            self._tail =self._head
        return temp

    def insert_last_node(self, value:Any) -> None:
        '''Добавить элемент в конец списка'''
        self._size+=1
        if self._head is None:
            self.insert_first_node(value)
        else:
            current_node = self._tail
            current_node.next = Node(value)
            self._tail =current_node.next

    def remove_last_node(self) -> Any:
        '''Удалить последний элемент списка'''
        self._size-=1
        if self._head.next is None:
            return self.remove_first_node()
        else:
            current_node = self._head
            while current_node.next.next is not None:
                current_node = current_node.next
            temp = current_node.next.data
            current_node.next = None
            self._tail =current_node
            return temp

    def remove_node (self, target_value):  
        """Найти (первый) узел по его значению и удалить его"""  
        current_node = self._head
        prev_node = None
        while current_node is not None:  
            if current_node.data == target_value:  
                next_node = current_node.next
                if next_node is None:
                    self._tail =prev_node
                self._size-=1
                if prev_node is not None:
                    prev_node.next = next_node
                else:
                    self._head = next_node
                return self  
            else:
                prev_node = current_node
                current_node = current_node.next  
        return self

    def fill_list(self, n) -> Any:
        '''создать список из n элементов, заполненных случайными целыми числами'''
        self._head = None
        self._size==0
        if n>0:
            for i in range (n,0,-1): 
                k = random.randint(0,20)
                self._head = Node(k, self._head)
                if i==n:
                    self._tail = self._head
                self._size+=1

    def fill_sequent_list(self, n) -> Any:
        '''создать список из n элементов, заполненных послед.целыми числами'''
        self._head = None
        self._size==0
        if n>0:
            for i in range (n,0,-1):
                self._head = Node(i, self._head)
                if i==n:
                    self._tail = self._head
                self._size+=1

    def insert_after_node(self, target_value, new_node) -> None:
        ''' Найти (первый) узел по его значению и добавить узел после него. (Если узел не найден, ничего не делать)'''
        current_node = self.find_node(target_value)
        if current_node is not None: 
            next_node = current_node.next            
            current_node.next = new_node
            new_node.next=next_node
            self._size+=1 
            if next_node is  None:
                self._tail = new_node
        return self

    def remove_next_node(self, target_value) -> None:
        '''Найти (первый) узел по его значению и удалить следующий узел (если такой есть).'''
        current_node = self.find_node(target_value)
        if current_node is not None: 
            next_node = current_node.next
            if next_node is not None: # есть следующий элемент
                self._size-=1
                if next_node.next is not None: # следующий элемент не последний
                    next_next_node =next_node.next
                    current_node.next = next_next_node                        
                else:  # предыдущий элемент последний, теперь первым будет найденный
                    current_node.next = None
                    self._tail = current_node
        return self  

    def find_node(self, target_value):  
        """Найти первый узел с заданным значением"""  
        tail_node = self._tail
        if tail_node.data == target_value:  
            return tail_node  
        current_node = self._head  
        while current_node is not None:  
            if current_node.data == target_value:  
                return current_node  
            current_node = current_node.next  
        return None

class SingleLinkedList_v6(SingleLinkedList_v5):
    '''Реализация АТД Односвязный линейный список  (SingleLinkedList_v6) - оптимизация вставки / модификации перед текущим '''
    def find_prev_node(self, target_value):  
        """Найти узел, предшествующий первому узлу с заданным значением"""   
        current_node = self._head
        prev_node = None
        while current_node is not None:  
            if current_node.data == target_value:  
                return prev_node  
            prev_node = current_node
            current_node = current_node.next  
        return None

    def find_previos_node(self, target_value)  -> None:
        ''' Найти (первый) узел по его значению и вернуть значение из предудущего узла (если такой есть).'''
        prev_node = self.find_prev_node(target_value)
        if prev_node is not None: 
            return prev_node.data
        else:
            return None

    def insert_before_node(self, target_value, new_node) -> None:
        ''' Найти (первый) узел по его значению и добавить узел перед ним. (Если узел не найден, ничего не делать)'''
        head_node = self._head
        if head_node.data == target_value: # вставка в начало списка
            new_node.next=head_node
            self._head=new_node
            self._size+=1 
        else:
            prev_node = self.find_prev_node(target_value)
            if prev_node is not None:
                current_node = prev_node.next
                prev_node.next=new_node
                new_node.next=current_node 
                self._size+=1
        return self

    def replace_previos_node(self, target_value,  new_value) -> None:
        '''Найти (первый) узел по его значению и заменить значение в предыдущем узле на новое.'''
        prev_node = self.find_prev_node(target_value)
        if prev_node is not None:
            prev_node.data = new_value
        return self

class SingleLinkedList_v7(SingleLinkedList_v6):
    '''Реализация АТД Односвязный линейный список  (SingleLinkedList_v7) - дополнительные функции '''

    def reverse_list(self) -> Any:
        '''Переворот списка'''
        if self._head.next is None:
            return self
        else:
            current_node=self._head
            self._tail=current_node
            prev_node = None
            while current_node.next is not None:
                next_node = current_node.next
                current_node.next=prev_node
                prev_node = current_node
                current_node = next_node
            next_node = current_node.next
            current_node.next=prev_node
            self._head = current_node
            return self

    def sort_list(self) -> Any:
        '''Сортировка списка'''
        if self._head.next is None:
            return self
        else:
            isSorted = False
            while not isSorted:
                isSorted = True
                current_node=self._head
                prev_node = None
                while current_node is not None:
                    if current_node.next is not None and current_node.data > (next_ := current_node.next).data:
                        if current_node is self._head:
                            self._head = current_node.next
                        current_node.next, next_.next = next_.next, current_node
                        if prev_node is not None:
                            prev_node.next = next_
                        isSorted = False
                    prev_node, current_node = current_node, current_node.next
            return self

    def create_unique_list_from_input(self) -> Any:
        '''Индивидуальное задание'''
        self._head = None
        self._tail = None
        self._size = 0
        print("Введите целые числа (для завершения введите 'stop'):")
        while True:
            user_input = input().strip()
            if user_input == 'stop':
                break
            number = int(user_input)
            is_duplicate = False
            current_node = self._head
            while current_node is not None:
                if current_node.data == number:
                    is_duplicate = True
                    break
                current_node = current_node.next
            if not is_duplicate:
                if self._head is None:
                    self._head = Node(number)
                    self._tail = self._head
                else:
                    new_node = Node(number)
                    self._tail.next = new_node
                    self._tail = new_node
                self._size += 1
        return self


doctest.testmod()
print ("ВЕРСИЯ 1")
list1=SingleLinkedList_v1()
list1.fill_sequent_list(10)
print("Список:" , list1)
list1.insert_first_node(0)
print ("Добавить элемент 0 в начало списка: ", list1 )
list1.insert_last_node(11)
print ("Добавить элемент 11 в конец списка: ", list1 )
list1.remove_first_node()
print ("Удалить первый элемент: ", list1 )
list1.remove_last_node()
print ("Удалить последний элемент: ", list1 )

print ("-------------------------------- ")
print ("ВЕРСИЯ 2")
list2=SingleLinkedList_v2()
list2.fill_sequent_list(10)
print("Список:" , list2)
print("Длина списка:" , list2.get_size())
print("Найти (первый) узел по его значению (6) :" , list2.find_node(6))
print("Найти (первый) узел по его значению (5) и заменить его значение новым (15) :" , list2.replace_node(5,15))
print("Найти (первый) узел по его значению (4) и удалить его :" , list2.remove_node(4))

print ("-------------------------------- ")
print ("ВЕРСИЯ 3")
list3=SingleLinkedList_v3()
list3.fill_sequent_list(10)
print("Список:" , list3, " , длина = ", list3.get_size())
list3.insert_first_node(0)
print ("Добавить элемент 0 в начало списка: ", list3, " , длина = ", list3.get_size())
list3.insert_last_node(11)
print ("Добавить элемент 11 в конец списка: ", list3 , " , длина = ", list3.get_size())
list3.remove_first_node()
print ("Удалить первый элемент: ", list3, " , длина = ", list3.get_size() )
list3.remove_last_node()
print ("Удалить последний элемент: ", list3 , " , длина = ", list3.get_size())
print("Найти (первый) узел по его значению (4) и удалить его :" , list3.remove_node(4)," , длина = ", list3.get_size())

print ("-------------------------------- ")
print ("ВЕРСИЯ 4")
list4=SingleLinkedList_v4()
list4.fill_sequent_list(10)
print("Список:" , list4)
print("Найти (первый) узел по его значению (4) и вернуть значение из предудущего узла (если такой есть).:" , list4.find_previos_node(4))
print("Найти (первый) узел по его значению (6) и вернуть значение из следующего узла (если такой есть):" , list4.find_next_node(6))
print("Найти (первый) узел по его значению (2) и добавить узел (22) перед ним. (Если узел не найден, ничего не делать):" , list4.insert_before_node(2,Node(22,None)))
print("Найти (первый) узел по его значению (3) и добавить узел (33) после него. (Если узел не найден, ничего не делать):" , list4.insert_after_node(3,Node(33,None)))
print("Найти (первый) узел по его значению (5) и заменить значение в предыдущем узле на новое (55) :" , list4.replace_previos_node(5,55))
print("Найти (первый) узел по его значению (8) и заменить значение в следующем узле на новое (88):" , list4.replace_next_node(8,88))
print("Найти (первый) узел по его значению (22) и удалить предыдущий узел (если такой есть):" , list4.remove_previos_node(22))
print("Найти (первый) узел по его значению (33) и удалить следующий узел (если такой есть):" , list4.remove_next_node(33))

print ("-------------------------------- ")
print ("ВЕРСИЯ 5")
list5=SingleLinkedList_v5()
list5.fill_sequent_list(10)
print("Список:" , list5)
print("Найти (первый) узел по его значению (4) и вернуть значение из предудущего узла (если такой есть).:" , list5.find_previos_node(4))
print("Найти (первый) узел по его значению (6) и вернуть значение из следующего узла (если такой есть):" , list5.find_next_node(6))
print("Найти (первый) узел по его значению (2) и добавить узел (22) перед ним. (Если узел не найден, ничего не делать):" , list5.insert_before_node(2,Node(22,None)))
print("Найти (первый) узел по его значению (3) и добавить узел (33) после него. (Если узел не найден, ничего не делать):" , list5.insert_after_node(3,Node(33,None)))
print("Найти (первый) узел по его значению (5) и заменить значение в предыдущем узле на новое (55) :" , list5.replace_previos_node(5,55))
print("Найти (первый) узел по его значению (8) и заменить значение в следующем узле на новое (88):" , list5.replace_next_node(8,88))
print("Найти (первый) узел по его значению (22) и удалить предыдущий узел (если такой есть):" , list5.remove_previos_node(22))
print("Найти (первый) узел по его значению (33) и удалить следующий узел (если такой есть):" , list5.remove_next_node(33))

print ("-------------------------------- ")
print ("ВЕРСИЯ 6")
list6=SingleLinkedList_v6()
list6.fill_sequent_list(10)
print("Список:" , list6)
print("Найти узел, предшествующий первому узлу с заданным значением (4):" , list6.find_prev_node(4))
print("Найти (первый) узел по его значению (6) и вернуть значение из предудущего узла (если такой есть).:" , list6.find_previos_node(6))
print("Найти (первый) узел по его значению (8) и добавить узел (77) перед ним. (Если узел не найден, ничего не делать):" , list6.insert_before_node(8,Node(77,None)))
print("Найти (первый) узел по его значению (5) и заменить значение в предыдущем узле на новое (55) :" , list6.replace_previos_node(5,55))

print ("-------------------------------- ")
print ("ПЕРЕВОРОТ СПИСКА")
list7=SingleLinkedList_v7()
list7.fill_list(10)
print("Исходный список:")
print(list7)
list7.reverse_list()
print("Переворот списка:")
print(list7)
print ("-------------------------------- ")
print ("СОРТИРОВКА СПИСКА")
list7.sort_list()
print("Отсортированный список:")
print(list7)
print ("-------------------------------- ")
print("ИНДИВИДУАЛЬНОЕ ЗАДАНИЕ (сформировать список целых чисел, вводимых пользователем, в том порядке, в котором вводятся эти числа, но без повторений элементов)")
list_input = SingleLinkedList_v7()
list_input.create_unique_list_from_input()
print("Список из пользовательского ввода без повторений:")
print(list_input)

```


    
