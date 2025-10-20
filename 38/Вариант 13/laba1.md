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

# Лабораторная работа 1 "Эмпирический анализ временной сложности алгоритмов"
# Токмаков А.Ю.
# ИУ10-38


__Для $n$ от 1 до $10^5 \cdot N$ c шагом $100 \cdot N$, где $N = (20 - \text{номер студента в списке группе})$, произведите для пяти запусков замер среднего машинного времени исполнения программ, реализующих нижеуказанные алгоритмы и функции. 
Изобразите на графике полученные данные, отражающие зависимость среднего времени исполнения от $n$.  
Проведите теоретический анализ временной сложности рассматриваемых алгоритмов и сравните эмпирическую и теоретическую временные сложности.__


 __Задание 1: Сгенерировать $n$-мерный случайный вектор $v = [v_1, v_2, ..., v_n]$ с неотрицательными элементами. Для полученного вектора $v$ осуществить подсчет функций и реализацию алгоритмов__

 доступ к элементу по индексу          $f_1(i) = v(i)$                

```python
import random
import functools
import timeit
import typing
import matplotlib.pyplot as plt
%matplotlib inline

# Декоратор для измерения времени
def get_usage_time(*, number: int = 1, setup: str = 'pass', ndigits: int = 3) -> typing.Callable:
    def decorator(func: typing.Callable) -> typing.Callable:
        @functools.wraps(func)
        def wrapper(*args, **kwargs) -> float:
            usage_time = timeit.timeit(
                lambda: func(*args, **kwargs),
                setup=setup,
                number=number,
            )
            return round(usage_time / number * 1000, ndigits)
        return wrapper
    return decorator

def element_by_index(massive, ind):
    """1.1. доступ к элементу по индексу"""
    return massive[ind-1]

# Параметры
N = 7  # 20 - 13 = 7
step = 100 * N  # 700
max_n = 100000 * N  # 700000

# Массив n для n в интервале от 1 до 700000 с шагом 700
n_massive = list(range(1, max_n + 1, step))
qty = len(n_massive)

# Время выполнения
times1 = []

for k in range(qty): 
    n = n_massive[k]
    
    # Генерация вектора с неотрицательными элементами
    mass = [random.randint(0, 700) for _ in range(n)]
    
    # Случайный индекс
    ind = random.randint(1, n)
    
    # Декорируем функцию для измерения времени
    timed_func = get_usage_time(ndigits=6)(element_by_index)
    
    # Измеряем время 5 раз и берем среднее
    total_time = 0
    for _ in range(5):
        total_time += timed_func(mass, ind)
    
    avg_time = total_time / 5
    times1.append(avg_time)

# График времени выполнения
plt.figure(figsize=(10, 6))
plt.plot(n_massive, times1, 'bo-', markersize=3)
plt.title('Доступ к элементу по индексу')
plt.xlabel('Число элементов (n)')
plt.ylabel('Время выполнения (миллисекунды)')
plt.grid(True, alpha=0.3)
plt.show()

# Теоретический анализ
print("Теоретическая сложность: O(1) - постоянное время")
print("Эмпирическая сложность: должна быть близка к постоянной")
```

вычисление полинома методом Горнера    $f_4(v) = v_1 + x (v_2 + x(v_3+ \ldots))$            

```python
#!/usr/bin/env python
# -*- coding: UTF-8 -*-
import random
import functools
import timeit
import typing
import matplotlib.pyplot as plt
%matplotlib inline

# Декоратор для измерения времени
def get_usage_time(*, number: int = 1, setup: str = 'pass', ndigits: int = 3) -> typing.Callable:
    def decorator(func: typing.Callable) -> typing.Callable:
        @functools.wraps(func)
        def wrapper(*args, **kwargs) -> float:
            usage_time = timeit.timeit(
                lambda: func(*args, **kwargs),
                setup=setup,
                number=number,
            )
            return round(usage_time / number * 1000, ndigits)
        return wrapper
    return decorator

def polynome_horner(massive, x):
    """
    1.4. вычисление полинома методом Горнера	   
    """
    b = massive[-1]
    for i in range (len(massive)-2,-1,-1):
        b = b * x + massive[i]
    return b

# Параметры
N = 7  # 20 - 13 = 7
step = 100 * N  # 700
max_n = 100000 * N  # 700000

print ("Начало работы...")
# Массив n для n в интервале от 1 до 700000 с шагом 700
n_massive = list(range(1, max_n + 1, step))
qty = len(n_massive)

# Время выполнения
times1 = []

x = random.randint(1,4) # Х для полинома

for k in range(qty): 
    n = n_massive[k]
    
    # Генерация вектора с неотрицательными элементами
    mass = [random.randint(0, 700) for _ in range(n)]
    
    # Декорируем функцию для измерения времени
    timed_func = get_usage_time(ndigits=6)(polynome_horner)
    
    # Измеряем время 5 раз и берем среднее
    total_time = 0
    for _ in range(5):
        total_time += timed_func(mass, x)
    
    avg_time = total_time / 5
    times1.append(avg_time)

# График времени выполнения
plt.figure(figsize=(10, 6))
plt.plot(n_massive, times1, 'bo-', markersize=3)
plt.title('Вычисление полинома методом Горнера')
plt.xlabel('Число элементов (n)')
plt.ylabel('Время выполнения (миллисекунды)')
plt.grid(True, alpha=0.3)
plt.show()

# Теоретический анализ
print("Теоретическая сложность: O(n)")
print("Эмпирическая сложность: должна быть близка к линейной")
```

поиск минимума простым перебором         $f_6(v) = \min(v)$                       

```python
#!/usr/bin/env python
# -*- coding: UTF-8 -*-
import random
import functools
import timeit
import typing
import matplotlib.pyplot as plt
%matplotlib inline

# Декоратор для измерения времени
def get_usage_time(*, number: int = 1, setup: str = 'pass', ndigits: int = 3) -> typing.Callable:
    def decorator(func: typing.Callable) -> typing.Callable:
        @functools.wraps(func)
        def wrapper(*args, **kwargs) -> float:
            usage_time = timeit.timeit(
                lambda: func(*args, **kwargs),
                setup=setup,
                number=number,
            )
            return round(usage_time / number * 1000, ndigits)
        return wrapper
    return decorator

def min_simple (massive):
    """
    1.6. поиск минимума простым перебором	   
    """
    min=massive[0]
    for i in range (1,len(massive)):
        if massive[i]<min:
            min=massive[i]
    return min

# Параметры
N = 7  # 20 - 13 = 7
step = 100 * N  # 700
max_n = 100000 * N  # 700000

print ("Начало работы...")
# Массив n для n в интервале от 1 до 700000 с шагом 700
n_massive = list(range(1, max_n + 1, step))
qty = len(n_massive)

# Время выполнения
times1 = []

for k in range(qty): 
    n = n_massive[k]
    
    # Генерация вектора с неотрицательными элементами
    mass = [random.randint(0, 700) for _ in range(n)]
    
    # Декорируем функцию для измерения времени
    timed_func = get_usage_time(ndigits=6)(min_simple)
    
    # Измеряем время 5 раз и берем среднее
    total_time = 0
    for _ in range(5):
        total_time += timed_func(mass)
    
    avg_time = total_time / 5
    times1.append(avg_time)

# График времени выполнения
plt.figure(figsize=(10, 6))
plt.plot(n_massive, times1, 'bo-', markersize=3)
plt.title('Вычисление минимума простым перебором')
plt.xlabel('Число элементов (n)')
plt.ylabel('Время выполнения (миллисекунды)')
plt.grid(True, alpha=0.3)
plt.show()

# Теоретический анализ
print("Теоретическая сложность: O(n)")
print("Эмпирическая сложность: должна быть близка к линейной")
```

среднее арифметическое                   $f_7(v) = \cfrac{1}{n} \cdot \sum\limits_{k=1}^{n} {v_k}$ 

```python
#!/usr/bin/env python
# -*- coding: UTF-8 -*-
import random
import functools
import timeit
import typing
import matplotlib.pyplot as plt
%matplotlib inline

# Декоратор для измерения времени
def get_usage_time(*, number: int = 1, setup: str = 'pass', ndigits: int = 3) -> typing.Callable:
    def decorator(func: typing.Callable) -> typing.Callable:
        @functools.wraps(func)
        def wrapper(*args, **kwargs) -> float:
            usage_time = timeit.timeit(
                lambda: func(*args, **kwargs),
                setup=setup,
                number=number,
            )
            return round(usage_time / number * 1000, ndigits)
        return wrapper
    return decorator

def average_arithmetic (massive):
    """
    1.7. среднее арифметическое	   
    """
    avg1=0
    for i in range (0,len(massive)):
        avg1=avg1+massive[i]
    avg1=avg1/len(massive)
    return avg1

# Параметры
N = 7  # 20 - 13 = 7
step = 100 * N  # 700
max_n = 100000 * N  # 700000

print ("Начало работы...")
# Массив n для n в интервале от 1 до 700000 с шагом 700
n_massive = list(range(1, max_n + 1, step))
qty = len(n_massive)

# Время выполнения
times1 = []

for k in range(qty): 
    n = n_massive[k]
    
    # Генерация вектора с неотрицательными элементами
    mass = [random.randint(0, 700) for _ in range(n)]
    
    # Декорируем функцию для измерения времени
    timed_func = get_usage_time(ndigits=6)(average_arithmetic)
    
    # Измеряем время 5 раз и берем среднее
    total_time = 0
    for _ in range(5):
        total_time += timed_func(mass)
    
    avg_time = total_time / 5
    times1.append(avg_time)

# График времени выполнения
plt.figure(figsize=(10, 6))
plt.plot(n_massive, times1, 'bo-', markersize=3)
plt.title('Вычисление среднего арифметического')
plt.xlabel('Число элементов (n)')
plt.ylabel('Время выполнения (миллисекунды)')
plt.grid(True, alpha=0.3)
plt.show()

# Теоретический анализ
print("Теоретическая сложность: O(n)")
print("Эмпирическая сложность: должна быть близка к линейной")
```

__Вывод__: 
Сложность алгоритма нахождения элемента по индексу O(1), она не зависит от количества элементов.
Сложность алгоритма вычисления полинома методом Горнера O(n), т.к. выполняется n умножений и n-1 сложений.
Сложность алгоритмов нахождения минимума методом простого перебора и нахождения среднего арифметического предполагает цикл по всем элементам списка, их сложность O(n).



__Задание 2: Сгенерировать случайные матрицы $A$ и $B$ размером $n × n$ с неотрицательными элементами. Найти обычное матричное произведение матриц $A$ и $B$.__

```python
#!/usr/bin/env python
# -*- coding: UTF-8 -*-
import random
import functools
import timeit
import typing
import matplotlib.pyplot as plt
import numpy as np
from itertools import product

%matplotlib inline

# Декоратор для измерения времени, минут
def get_usage_time(*, number: int = 1, setup: str = 'pass', ndigits: int = 3) -> typing.Callable:
    def decorator(func: typing.Callable) -> typing.Callable:
        @functools.wraps(func)        
        def wrapper(*args, **kwargs) -> float:
            usage_time = timeit.timeit(
                lambda: func(*args, **kwargs),
                setup=setup,
                number=number,
            )
            return round(usage_time / (number * 60), ndigits)
        return wrapper
    return decorator

def matrix_multiply(A, B):
    """
    Простое умножение матриц 
    """
    n = A.shape[0]
    C = np.zeros((n, n))
    for i in range(n):
        for j in range(n):
            for k in range(n):
                C[i, j] += A[i, k] * B[k, j]
    return C  # O(n^3)

def matrix_generation(n):
    """
    Генерация матрицы размером n x n	   
    """
    C = np.random.randint(low =0, high =70, size=(n,n))
    return C

# Параметры
N = 7  # 20 - 13 = 7
step = 10 * N  # 70
max_n = 100 * N  # 700

print ("Начало работы...")
# Массив n для n в интервале от 1 до 700 с шагом 70
n_massive = list(range(1, max_n + 1, step))
qty = len(n_massive)

# Время выполнения
times1 = []

for k in range(qty): 
    n = n_massive[k]
    print ("n=",n)
    
    # Генерация матриц с неотрицательными элементами
    A = matrix_generation(n)
    B = matrix_generation(n)
    
    # Декорируем функцию для измерения времени
    timed_func = get_usage_time(ndigits=6)(matrix_multiply)
    
    # Измеряем время 3 раза и берем среднее
    total_time = 0
    for _ in range(3):
        total_time += timed_func(A,B)
    
    avg_time = total_time / 3
    times1.append(avg_time)

# График времени выполнения
plt.figure(figsize=(10, 6))
plt.plot(n_massive, times1, 'bo-', markersize=3)
plt.title('Вычисление обычного матричного произведения матриц А и В')
plt.xlabel('Число элементов (n)')
plt.ylabel('Время выполнения (минут)')
plt.grid(True, alpha=0.3)
plt.show()

# Теоретический анализ
print("Теоретическая сложность: O(n^3)")
print("Эмпирическая сложность: должна быть близка к кубической")
```

__Вывод__: Сложность алгоритма простого произведения матриц размерностью n х n равна O(n^3), т.к. при вычислении есть 3 вложенных цикла размерностью n.

```python

```
