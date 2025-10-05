---
jupyter:
  jupytext:
    text_representation:
      extension: .md
      format_name: markdown
      format_version: '1.3'
      jupytext_version: 1.17.3
  kernelspec:
    display_name: Python 3 (ipykernel)
    language: python
    name: python3
---

# Лабораторная работа 2 "Алгоритмы сортировки"
# Токмаков А.Ю.
# ИУ10-38


__Цель работы__: изучение основных алгоритмов на сортировки.


__Задание:__                                                         
1) Провести классификацию алгоритмов сортировки.                              
2) Подготовить теоретическое описание алгоритмов сортировки согласно номеру индивидуального варианта.           
3) Подготовить блок-схему алгоритмов.                           
4) Представить описание алгоритмов на псевдокоде.                           
5) Описать достоинства и недостатки каждого алгоритма.                                         
6) Реализовать алгоритмы сортировки согласно номеру индивидуального варианта.                                  
7) Протестировать корректность реализации алгоритма.                                 
8) Провести ручную трассировку алгоритма.                                                   
9) Провести сравнение указанных алгоритмов сортировки массивов, содержащих n1, n2, n3 и n4 элементов.                            
10) Каждую функцию сортировки вызывать трижды: для сортировки упорядоченного массива, массива, упорядоченного в обратном порядке и неупорядоченного массива. Сортируемая последовательность для всех методов должна быть одинаковой (сортировать копии одного массива).          
11) Проиллюстрировать эффективность алгоритмов сортировок по заданному критерию. Построить диаграммы указанных зависимостей.


Метод сортировки __Bogosort__                                             
Средняя временная сложность — O(n × n!). Это связано с тем, что существует n! возможных перестановок элементов массива (при условии, что все они различны), и сортируется только одна из них. 
В лучшем случае (массив отсортирован) — O(n).
Худший случай — O(∞), так как нет гарантии, что случайная перестановка всегда приведёт к отсортированной последовательности.

__Алгоритм__: проверить, отсортирован ли массив. Если да, вернуть отсортированный массив, иначе cгенерировать случайную перестановку массива (не обязательно отличающуюся от ранее сгенерированной) и проверить снова, отсортирован ли массив.

__Достоинства и недостатки__:
Bogosort - неэффективный алгоритм сортировки. Он будет выполняться быстро только для уже отсортированного массива.

```python
import random
import functools
import timeit
import typing
import matplotlib.pyplot as plt
%matplotlib inline

# Декоратор для измерения времени (секунд)
def get_usage_time(*, number: int = 1, setup: str = 'pass', ndigits: int = 3) -> typing.Callable:
    def decorator(func: typing.Callable) -> typing.Callable:
        @functools.wraps(func)
        def wrapper(*args, **kwargs) -> float:
            usage_time = timeit.timeit(
                lambda: func(*args, **kwargs),
                setup=setup,
                number=number,
            )
            return round(usage_time / number, ndigits)
        return wrapper
    return decorator

def bogoSort(a):
    """
    Cортировка массива методом BogoSort
    """
    n = len(a)
    while (is_sorted(a)== False):
        shuffle(a)

def is_sorted(a):
    """
    Проверка, что массив отсортирован
    """
    n = len(a)
    for i in range(0, n-1):
        if (a[i] > a[i+1] ):
            return False
    return True

def shuffle(a):
    """
    меняем местами 2 элемента случайным образом
    """
    n = len(a)
    for i in range (0,n):
        r = random.randint(0,n-1)
        a[i], a[r] = a[r], a[i]

# Параметры
n_massive= [7,8,9,10] # количество элементов (берем меньшее из-за большого времени исполнения)
qty = len(n_massive)

# Время выполнения
times1 = []
times2 = []
times3 = []

for k in range(qty): 
    n = n_massive[k]
    print ("---------- n = ", n, "----------")
    
    # Генерация неотсортированного массива с неотрицательными элементами
    b1 = [random.randint(0, 700) for _ in range(n)]
    print ("Исходный массив (неупорядоченный) :", b1)
    b2=b1
    bogoSort(b2)
    print ("Исходный массив (упорядоченный) :", b2)  
    step = n // 2
    b3=b2
    for l in range (0,step):
        b3[l], b3[n-l-1] = b3[n-l-1], b3[l]
    print ("Исходный массив (упорядоченный в обратном порядке) :", b3)  

    # Декорируем функцию для измерения времени
    timed_func = get_usage_time(ndigits=6)(bogoSort)
    
    # Измеряем время 5 раз и берем среднее
    total_time1 = 0
    total_time2 = 0
    total_time3 = 0
    for _ in range(5):
        a1=b1
        a2=b2
        a3=b3
        total_time1 += timed_func(a1)
        total_time2 += timed_func(a2)
        total_time3 += timed_func(a3)
    avg_time1 = round(total_time1 / 5,6)
    avg_time2 = round(total_time2 / 5,6)
    avg_time3 = round(total_time3 / 5,6)
    times1.append(avg_time1)
    times2.append(avg_time2)
    times3.append(avg_time3)
    print ("Время = ", avg_time1, avg_time2, avg_time3)
  
# График времени выполнения
plt.figure(figsize=(10, 6))
plt.plot(n_massive,times1,'b--',n_massive,times2,'g-',n_massive,times3,'r-.') 
#,n_massive,times3,'r--'
#plt.plot(n_massive, times1, color='r', label='случайный', markersize=3)
#plt.plot(n_massive, times2, color='g', label='отсорт.',  markersize=3)
#plt.plot(n_massive, times3, color='b', label='обратн.',  markersize=3)
plt.title('Сортировка массива методом BogoSort')
plt.xlabel('Число элементов (n)')
plt.ylabel('Время выполнения (секунды)')
plt.legend(['Неупорядоченный','Упорядоченный','Упорядоченный в обратном порядке'], loc=2)
plt.grid(True, alpha=0.3)
plt.show()
```

Метод сортировки __Шелла__                                                                         
__Идея__ метода заключается в сравнение разделенных на группы элементов последовательности, находящихся друг от друга на некотором расстоянии.                                                                 
Изначально это расстояние равно d или N/2, где N — общее число элементов.                                      
На первом шаге каждая группа включает в себя два элемента, расположенных друг от друга на расстоянии N/2; 
они сравниваются между собой, и, в случае необходимости, меняются местами. 
На последующих шагах также происходят проверка и обмен, но расстояние d сокращается на d/2, и количество групп, соответственно, уменьшается. 
Постепенно расстояние между элементами уменьшается, и на d=1 проход по массиву происходит в последний раз

__Временная сложность__ алгоритма сортировки методом Шелла — O(n²). Это происходит, когда последовательность интервалов определена как 2^k — 1, где k — количество элементов в массиве.

__Достоинства и недостатки__: алгоритм сортировки Шелла - усовершенствованный вариант сортировки вставками. Идея — сравнивать элементы, стоящие не только рядом, но и на определённом расстоянии друг от друга, и постепенно уменьшать промежуток между ними.                                                          
__Достоинства__: алгоритм эффективен для массивов большого размера, так как позволяет элементам перемещаться на большие расстояния на ранних стадиях, что уменьшает количество перемещений, необходимых на поздних стадиях.   
__Недостатки__: алгоритм не является самым быстрым алгоритмом сортировки, существуют более сложные методы, такие как сортировка слиянием и быстрая сортировка, которые обладают более высокой производительностью в среднем случае.

```python
import random
import functools
import timeit
import typing
import matplotlib.pyplot as plt
%matplotlib inline

# Декоратор для измерения времени (секунд)
def get_usage_time(*, number: int = 1, setup: str = 'pass', ndigits: int = 3) -> typing.Callable:
    def decorator(func: typing.Callable) -> typing.Callable:
        @functools.wraps(func)
        def wrapper(*args, **kwargs) -> float:
            usage_time = timeit.timeit(
                lambda: func(*args, **kwargs),
                setup=setup,
                number=number,
            )
            return round(usage_time / (number), ndigits)
        return wrapper
    return decorator

def ShellaSort(a):
    """
    Сортировка методом Шелла
    """
    n = len(a)
    step = n // 2
    while step > 0:
        for i in range (step, n, 1):
            j = i
            delta = j - step
            while delta  >= 0 and a[delta] > a[j]:
                a[delta], a[j] = a[j], a[delta]
                j=delta
                delta = j - step
        step //= 2
    return a

# Параметры
n_massive= [1000,5000,10000,100000] # количество элементов
qty = len(n_massive)

# Время выполнения
# Время выполнения
times1 = []
times2 = []
times3 = []

for k in range(qty): 
    n = n_massive[k]
    print ("---------- n = ", n, "----------")
    
    # Генерация неотсортированного массива с неотрицательными элементами
    b1 = [random.randint(0, 700) for _ in range(n)]
    #print ("Исходный массив (неупорядоченный) :", b1)
    b2=b1
    ShellaSort(b2)
    #print ("Исходный массив (упорядоченный) :", b2)  
    step = n // 2
    b3=b2
    for l in range (0,step):
        b3[l], b3[n-l-1] = b3[n-l-1], b3[l]
    #print ("Исходный массив (упорядоченный в обратном порядке) :", b3)   

    # Декорируем функцию для измерения времени
    timed_func = get_usage_time(ndigits=6)(ShellaSort)
    
    # Измеряем время 5 раз и берем среднее
    total_time1 = 0
    total_time2 = 0
    total_time3 = 0
    for _ in range(5):
        a1=b1
        a2=b2
        a3=b3
        total_time1 += timed_func(a1)
        total_time2 += timed_func(a2)
        total_time3 += timed_func(a3)
    avg_time1 = round(total_time1 / 5,6)
    avg_time2 = round(total_time2 / 5,6)
    avg_time3 = round(total_time3 / 5,6)
    times1.append(avg_time1)
    times2.append(avg_time2)
    times3.append(avg_time3)
    print ("Время = ", avg_time1, avg_time2, avg_time3)
  
# График времени выполнения
plt.figure(figsize=(10, 6))
plt.plot(n_massive,times1,'b--',n_massive,times2,'g-',n_massive,times3,'r-.') 
plt.title('Сортировка массива методом Шелла')
plt.xlabel('Число элементов (n)')
plt.ylabel('Время выполнения (секунды)')
plt.legend(['Неупорядоченный','Упорядоченный','Упорядоченный в обратном порядке'], loc=0)
plt.grid(True, alpha=0.3)
plt.show()
```

```python

```
