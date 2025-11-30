# ОТЧЕТ ПО ЛАБОРАТОРНОЙ РАБОТЕ
## «Лабораторная работа №6. Итеративные и рекурсивные алгоритмы

### Цель работы: Изучить рекурсивные алгоритмы и рекурсивные структуры данных; научиться проводить анализ итеративных и рекурсивных процедур; исследовать эффективность итеративных и рекурсивных процедур при реализации на ПЭВМ.

### Работу выполнил: Цыганков Д.С 

## Задание 1 - Реализуйте рекурсивный алгоритм подсчета Q(M, N) — числа способов, с помощью которых можно представить целое число M в виде суммы натуральных слагаемых, каждое из которых не превосходит N. Воспользуйтесь следующим определением: Q(M, N) =
## · 1, если M = 1 (при любом N)
## · 1, если N = 1 (при любом M)
## · Q(M, M), если M < N
## · 1 + Q(M, M-1), если M = N
## · Q(M, N-1) + Q(M-N, N), если M > N

```python 

def count_ways(M, N):

    if M == 1:
        return 1
    if N == 1:
        return 1
    if M < N:
        return count_ways(M, M)
    if M == N:
        return 1 + count_ways(M, M-1)
        
    return count_ways(M, N-1) + count_ways(M-N, N)

def test_recursive():
    test_cases = [(5, 3), (4, 2), (6, 4)]
    
    for M, N in test_cases:
        result = count_ways(M, N)
        print(f"Q({M},{N}) = {result}")

test_recursive()

```

## Задание 2 - Реализуйте алгоритмы из задания 1 не используя рекурсию.

```python
def count_ways(M, N):
    
    dp = [[0] * (N + 1) for _ in range(M + 1)]
    
    for i in range(1, M + 1):
        dp[i][1] = 1  
    for j in range(1, N + 1):
        dp[1][j] = 1 
    
    for i in range(2, M + 1):
        for j in range(2, N + 1):
            if i < j:
                dp[i][j] = dp[i][i]
            elif i == j:
                dp[i][j] = 1 + dp[i][j-1]
            else:  # i > j
                dp[i][j] = dp[i][j-1] + dp[i-j][j]
    
    return dp[M][N]

def test_iterative():
    test_cases = [(5, 3), (4, 2), (6, 4), (100, 100)]
    
    for M, N in test_cases:
        result = count_ways(M, N)
        print(f"Q({M},{N}) = {result}")

test_iterative()

```
## Задание 3 - Для каждого реализованного алгоритма:

## 3.1 Составьте блок-схему;

## 3.2 Оцените верхнюю границу размерности задачи, для которой при рекурсивной реализации не происходит переполнение стека вызовов;

## 3.3 Модернизируйте рекурсивную реализацию так, чтобы сохранялись промежуточные результаты вызова рекурсии (реализуйте подобный механизм вручную, а также, с помощью декоратора);

## 3.4 Сравните производительность реализованных алгоритмов (количество итераций (соответственно вызовов рекурсии) подбирайте исходя из условий задачи).

```python
import time

def cache_results(func):
    cache = {}
    def wrapper(M, N):
        if (M, N) not in cache:
            cache[(M, N)] = func(M, N)
        return cache[(M, N)]
    return wrapper

@cache_results
def count_ways_memo(M, N):
    if M == 1 or N == 1:
        return 1
    if M < N:
        return count_ways_memo(M, M)
    if M == N:
        return 1 + count_ways_memo(M, M-1)
    return count_ways_memo(M, N-1) + count_ways_memo(M-N, N)

def count_ways_recursive(M, N):
    if M == 1 or N == 1:
        return 1
    if M < N:
        return count_ways_recursive(M, M)
    if M == N:
        return 1 + count_ways_recursive(M, M-1)
    return count_ways_recursive(M, N-1) + count_ways_recursive(M-N, N)

def count_ways_iterative(M, N):
    dp = [[0] * (N + 1) for _ in range(M + 1)]
    
    for i in range(1, M + 1):
        dp[i][1] = 1
    for j in range(1, N + 1):
        dp[1][j] = 1
    
    for i in range(2, M + 1):
        for j in range(2, N + 1):
            if i < j:
                dp[i][j] = dp[i][i]
            elif i == j:
                dp[i][j] = 1 + dp[i][j-1]
            else:
                dp[i][j] = dp[i][j-1] + dp[i-j][j]
    
    return dp[M][N]

def compare_speed():

    test_cases = [(10, 5), (15, 8), (20, 10)]
    
    for M, N in test_cases:
        print(f"\nQ({M},{N}):")
        
        start = time.time()
        result1 = count_ways_recursive(M, N)
        time1 = time.time() - start
        print(f"Рекурсия: {result1} ({time1:.4f} сек)")
        
        start = time.time()
        result2 = count_ways_memo(M, N)
        time2 = time.time() - start
        print(f"Мемоизация: {result2} ({time2:.4f} сек)")
        
        start = time.time()
        result3 = count_ways_iterative(M, N)
        time3 = time.time() - start
        print(f"Итерация: {result3} ({time3:.4f} сек)")

compare_speed()

```
