# Эмпирический анализ временной сложности алгоритмов
Ломовский Егор ИУ10-37

# Задания

## Задание 1.1


```python
import random, usage_time
import matplotlib.pyplot as plt


def get_by_index(v: list):
    return v[random.randint(0, len(v)) - 1]

elements = range(1, 10**5 * 16, 50000)
function = usage_time.get_usage_time()(get_by_index)
times = [
    function([random.randint(1, 3)
        for _ in range(n)])
        for n in elements
]

fig = plt.plot(elements, times, 'bo-')
ax = plt.gca()

ax.set_title('The execution time of the "get by index algorithm"')
ax.set_xlabel('Amount of elements')
ax.set_ylabel('Time, sec')
plt.show()
```


    
![png](Lab_Files/Untitled1_3_0.png)
    


# Задание 1.4


```python
import random, usage_time
import matplotlib.pyplot as plt

def hor_met(v: list, x):
    res = 0
    for c in v:
        res = res * x + c
    return res

elements = range(1, 10**5 * 16, 50000)
function = usage_time.get_usage_time()(hor_met)
times = [
    function(
        [1 for _ in range(n)],
        0.000001
    )
    for n in elements
]

fig = plt.plot(elements, times, 'bo-')
ax = plt.gca()

ax.set_title('The execution time of the "horner method algorithm"')
ax.set_xlabel('Amount of elements')
ax.set_ylabel('Time, sec')
plt.show()
```


    
![png](Lab_Files/Untitled1_5_0.png)
    


## Задание 1.5


```python
import random, usage_time
import matplotlib.pyplot as plt


def get_max(v: list):
    max_num = 0
    for num in v:
        if num > max_num:
            max_num = num
    return max_num


elements = range(1, 10**5 * 16, 50000)
function = usage_time.get_usage_time()(get_max)
times = [
    sum([
        function([random.randint(1, 10)
            for _ in range(n)])
        for _ in range(10)]) / 10
    for n in elements
]

fig = plt.plot(elements, times, 'bo-')
ax = plt.gca()

ax.set_title('The execution time of the "getting max of list numbers algorithm"')
ax.set_xlabel('Amount of elements')
ax.set_ylabel('Time, sec')
plt.show()
```


    
![png](Lab_Files/Untitled1_7_0.png)
    


## Задание 1.7


```python
import random, usage_time
import matplotlib.pyplot as plt

def arithmetic_mean(v: list):
    summ = 0
    for num in v:
        summ += num
    mean = summ / len(v)
    return mean

elements = range(1, 10**5 * 16, 50000)
function = usage_time.get_usage_time()(arithmetic_mean)
times = [
    sum([
        function([
            random.randint(1, 10)
            for _ in range(n)])
        for _ in range(10)]) / 10
    for n in elements
]

fig = plt.plot(elements, times, 'bo-')
ax = plt.gca()

ax.set_title('The execution time of the "arithmetic mean algorithm"')
ax.set_xlabel('Amount of elements')
ax.set_ylabel('Time, sec')
plt.show()
```


    
![png](Lab_Files/Untitled1_9_0.png)
    


## Задание 2


```python
import random, usage_time
import matplotlib.pyplot as plt

def matrix_product_calculation(mat_A: list, mat_B: list, size: int):
    mat_res = [[0 for _ in range(size)] for _ in range(size)]

    for row in range(size):
        for col in range(size):
            total = 0
            for inner in range(size):
                total += mat_A[row][inner] * mat_B[inner][col]
            mat_res[row][col] = total

    return mat_res

elements = range(1, 500, 25)
function = usage_time.get_usage_time()(matrix_product_calculation)

times = []
for n in elements:
    A = [[random.randint(1, 5) for _ in range(n)] for _ in range(n)]
    B = [[random.randint(1, 5) for _ in range(n)] for _ in range(n)]
    time_taken = function(A, B, n)
    times.append(time_taken)

fig = plt.plot(elements, times, 'bo-')
ax = plt.gca()

ax.set_title('The execution time of the "multiply matrixes algorithm"')
ax.set_xlabel('Amount of elements')
ax.set_ylabel('Time, sec')
plt.show()
```


    
![png](Untitled1_files/Untitled1_11_0.png)
    

