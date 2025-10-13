# Эмпирический анализ временной сложности алгоритмов

## Цель работы

Эмпирический анализ временной сложности алгоритмов.

## Работу выполнил
Цыганков Д.С. ИУ10-37

## Задания 
### Задание 1.2
```python
import random
import time
import matplotlib.pyplot as plt

def sum_elements(v: list):
    total = 0
    for num in v:
        total += num
    return total

student_number = 8 
N = 20 - student_number

items = range(1, 10**5 * N, 50000)
times = []

print(f"Задание 1.2 | Вариант {student_number} | Точек: {len(list(items))}")

for n in items:
    total_time = 0
    
    for _ in range(20):
        vector = [random.randint(1, 10) for _ in range(n)]
        
        start_time = time.perf_counter()
        result = sum_elements(vector)
        end_time = time.perf_counter()
        
        total_time += (end_time - start_time)
    
    avg_time = total_time / 20
    times.append(avg_time)
    print(f"n={n}: {avg_time:.6f} сек")

plt.plot(items, times, 'bo-')
plt.title('The execution time of the sum of list elements algorithm')
plt.xlabel('Number of elements')
plt.ylabel('Time, sec')
plt.grid(True)
plt.show()
```

![png](Img/Num1.2.Image.png)

## Задание 1.5
```python
import random
import time
import matplotlib.pyplot as plt

def find_max(v: list):
    max_num = 0
    for num in v:
        if num > max_num:
            max_num = num
    return max_num

student_number = 8 
N = 20 - student_number

items = range(1, 10**5 * N, 50000)
times = []

print(f"Задание 1.5 | Вариант {student_number} | Точек: {len(list(items))}")

for n in items:
    total_time = 0
    
    for _ in range(20):
        vector = [random.randint(1, 10) for _ in range(n)]
        
        start_time = time.perf_counter()
        result = find_max(vector)
        end_time = time.perf_counter()
        
        total_time += (end_time - start_time)
    
    avg_time = total_time / 20
    times.append(avg_time)
    print(f"n={n}: {avg_time:.6f} сек")

plt.plot(items, times, 'bo-')
plt.title('The execution time of the getting max of list numbers algorithm')
plt.xlabel('Number of elements')
plt.ylabel('Time, sec')
plt.grid(True)
plt.show()
```
![png](Img/Num1.5.Image.png)

## Задание 1.6
```python
import random
import time
import matplotlib.pyplot as plt

def find_min(v: list):
    min_num = float('inf')
    for num in v:
        if num < min_num:
            min_num = num
    return min_num

student_number = 8 
N = 20 - student_number

items = range(1, 10**5 * N, 50000)
times = []

print(f"Задание 1.6 | Вариант {student_number} | Точек: {len(list(items))}")

for n in items:
    total_time = 0
    
    for _ in range(20):
        vector = [random.randint(1, 10) for _ in range(n)]
        
        start_time = time.perf_counter()
        result = find_min(vector)
        end_time = time.perf_counter()
        
        total_time += (end_time - start_time)
    
    avg_time = total_time / 20
    times.append(avg_time)
    print(f"n={n}: {avg_time:.6f} сек")

plt.plot(items, times, 'go-')
plt.title('The execution time of the getting min of list numbers algorithm')
plt.xlabel('Number of elements')
plt.ylabel('Time, sec')
plt.grid(True)
plt.show()
```
![png](Img/Num1.6.Image.png)

## Задание 1.8
```python
import random
import time
import matplotlib.pyplot as plt

def harmonic_mean(v: list):
    total_reciprocal = 0
    for num in v:
        if num == 0:
            return 0
        total_reciprocal += 1 / num
    return len(v) / total_reciprocal

student_number = 8 
N = 20 - student_number

items = range(1, 10**5 * N, 50000)
times = []

print(f"Задание 1.8 | Вариант {student_number} | Точек: {len(list(items))}")

for n in items:
    total_time = 0
    
    for _ in range(20):
        vector = [random.randint(1, 10) for _ in range(n)]  # от 1 чтобы не было 0
        
        start_time = time.perf_counter()
        result = harmonic_mean(vector)
        end_time = time.perf_counter()
        
        total_time += (end_time - start_time)
    
    avg_time = total_time / 20
    times.append(avg_time)
    print(f"n={n}: {avg_time:.6f} сек")

plt.plot(items, times, 'mo-')
plt.title('The execution time of the harmonic mean algorithm')
plt.xlabel('Number of elements')
plt.ylabel('Time, sec')
plt.grid(True)
plt.show()
```
![png](Img/Num1.8.Image.png)

## Задание 2
```import numpy as np
import matplotlib.pyplot as plt
from time import perf_counter
import typing

def matrix(n):  
    random_matrix1 = np.random.randint(0, 100, size=(n, n))
    random_matrix2 = np.random.randint(0, 100, size=(n, n))
    random_matrix3 = np.zeros((n, n), dtype=int) 
    
    for i in range(n):
        for j in range(n):
            product_in_matrix = 0
            for m in range(n):
                product_in_matrix += random_matrix1[i][m] * random_matrix2[m][j]
            random_matrix3[i][j] = product_in_matrix
    
    return random_matrix3

def measure_time(func: typing.Callable, n: int) -> float:
    start_time = perf_counter()
    result = func(n)
    end_time = perf_counter()
    return end_time - start_time

items = range(1, 100, 10) 
times = []

for n in items:
    execution_time = measure_time(matrix, n)
    times.append(execution_time)

plt.plot(items, times, 'bo-')
plt.title('Время выполнения алгоритма умножения матриц')
plt.xlabel('Размер матрицы n×n')
plt.ylabel('Время, сек')
plt.grid(True)
plt.show()

```
![png](Img/Num2.1.Image.png)
