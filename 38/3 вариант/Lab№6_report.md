# Итеративные и рекурсивные алгоритмы
Баскаков Д. С.
ИУ10-38

## Цель работы:
Изучить рекурсивные алгоритмы и рекурсивные структуры данных; научиться проводить анализ итеративных и рекурсивных процедур; исследовать эффективность итеративных и рекурсивных процедур при реализации на ПЭВМ.


```python
# Задание 1.

def ackermann(x, y, m=None):
    if x == 0:
        result = y + 1
    elif y == 0:
        result = ackermann(x - 1, 1, m)
    else:
        inner = ackermann(x, y - 1, m)
        result = ackermann(x - 1, inner, m)
    
    if m is not None:
        return result % m
    return result

def create_table(x_max, y_max, m=None):
    table = []
    for i in range(x_max + 1):
        row = []
        for j in range(y_max + 1):
            try:
                value = ackermann(i, j, m)
                row.append(value)
        table.append(row)
    return table
```


```python
# Задание 2.

def ackermann_iter(x, y, mod=None):
    stack = []
    stack.append((x, y))
    while stack:
        current = stack[-1]
        a = current[0]
        b = current[1]
        if a == 0:
            res = b + 1
            stack.pop()
            if stack:
                prev = stack.pop()
                if prev[1] == -1:
                    stack.append((prev[0] - 1, res))
                else:
                    stack.append((prev[0] - 1, 1))
            else:
                result = res
                break 
        elif b == 0:
            stack[-1] = (a - 1, 1)
        else:
            stack[-1] = (a, -1)
            stack.append((a, b - 1))
    if mod is not None:
        return result % mod
    return result

def make_table(x_max, y_max, mod=None):
    table = []
    for i in range(x_max + 1):
        row = []
        for j in range(y_max + 1):
            val = ackermann_iter(i, j, mod)
            row.append(val)
        table.append(row)
    return table
```


```python
# Задание 3.

def test_stack():
    tests = [(2, 3), (3, 2), (3, 3), (4, 0), (4, 1)]
    for x, y in tests:
        try:
            res = ackermann(x, y)
            print(f"A({x},{y}) = {res}")
        except:
            print(f"A({x},{y}) = переполнение!")
            break

# 2. Мемоизация вручную
cache = {}
def ackermann_memo(x, y, mod=None):
    key = (x, y)
    if key in cache:
        return cache[key]
    if x == 0:
        res = y + 1
    elif y == 0:
        res = ackermann_memo(x - 1, 1, mod)
    else:
        temp = ackermann_memo(x, y - 1, mod)
        res = ackermann_memo(x - 1, temp, mod)
    if mod is not None:
        res = res % mod
    cache[key] = res
    return res

# 3. Мемоизация с декоратором
def simple_memo(func):
    cache = {}
    def wrapper(x, y, mod=None):
        key = (x, y, mod)
        if key in cache:
            return cache[key]
        res = func(x, y, mod)
        cache[key] = res
        return res
    return wrapper
```

    
