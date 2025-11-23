# Итеративные и рекурсивные алгоритмы
Баскаков Д. С.
ИУ10-38

## Цель работы:
Изучить рекурсивные алгоритмы и рекурсивные структуры данных; научиться проводить анализ итеративных и рекурсивных процедур; исследовать эффективность итеративных и рекурсивных процедур при реализации на ПЭВМ.


```python
# Задание 1.

def ackermann(x, y, m):
    if x == 0:
        result = y + 1
    elif y == 0:
        result = ackermann(x - 1, 1, m)
    else:
        inn = ackermann(x, y - 1, m)
        result = ackermann(x - 1, inn, m)
    return result % m

def sozd_table(xmax, ymax, m):
    table = []
    for i in range(xmax + 1):
        row = []
        for j in range(ymax + 1):
            row.append(ackermann(i, j, m))
        table.append(row)
    return table
```


```python
# Задание 2.

def ackermann_it(x, y, m):
    stack = []
    stack.append((x, y))
    while stack:
        cur = stack[-1]
        a = cur[0]
        b = cur[1]
        if a == 0:
            res = b + 1
            stack.pop()
            if stack:
                pred = stack.pop()
                stack.append((pred[0] - 1, res))
            else:
                result = res
                break 
        elif b == 0:
            stack[-1] = (a - 1, 1)
        else:
            stack[-1] = (a, -1)
            stack.append((a, b - 1))
    return result % m

def sozd_table(xmax, ymax, m):
    table = []
    for i in range(xmax + 1):
        row = []
        for j in range(ymax + 1):
            row.append(ackermann(i, j, m))
        table.append(row)
    return table
```


```python
# Задание 3.

cache = {}
def ackermann_mem(x, y, m):
    k = (x, y)
    if k in cache:
        return cache[k]
    if x == 0:
        result = y + 1
    elif y == 0:
        result = ackermann_mem(x - 1, 1, m)
    else:
        inn = ackermann_mem(x, y - 1, m)
        result = ackermann_mem(x - 1, inn, m)
    cache[k] = res
    return res % m

# 3. Мемоизация с декоратором
from functools import lru_cache

@lru_cache(maxsize=None)
def ackermann_lru(x, y, m):
    if x == 0:
        result = y + 1
    elif y == 0:
        result = ackermann_lru(x - 1, 1, m)
    else:
        inn = ackermann_lru(x, y - 1, m)
        result = ackermann_lru(x - 1, inn, m)
    return result % m
```

    
