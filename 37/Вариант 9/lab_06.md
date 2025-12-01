```python
import sys
import time
import math
from functools import lru_cache

def recursive_fixed_point(F, x, eps=1e-6, max_depth=1000, depth=0):
    if depth >= max_depth:
        raise RecursionError(f"Максимальная глубина: {max_depth}")
    
    next_x = F(x)
    
    if abs(next_x - x) < eps:
        return next_x, depth + 1
    
    return recursive_fixed_point(F, next_x, eps, max_depth, depth + 1)

def F_cos(x):
    return math.cos(x)

def F_sqrt2(x):
    return 0.5 * (x + 2 / x)

print("Задание 1: Рекурсивная реализация")
print("=" * 50)

try:
    result1, iterations1 = recursive_fixed_point(F_cos, 0.5, eps=1e-10)
    print(f"cos(x) = x")
    print(f"Начальное: 0.5")
    print(f"Результат: {result1:.10f}")
    print(f"Итераций: {iterations1}")
    print(f"cos({result1:.6f}) = {math.cos(result1):.6f}")
    print("-" * 40)
except RecursionError as e:
    print(f"Ошибка: {e}")

try:
    result2, iterations2 = recursive_fixed_point(F_sqrt2, 1.0, eps=1e-10)
    print(f"sqrt(2)")
    print(f"Начальное: 1.0")
    print(f"Результат: {result2:.10f}")
    print(f"Точное: {math.sqrt(2):.10f}")
    print(f"Итераций: {iterations2}")
    print(f"Разница: {abs(result2 - math.sqrt(2)):.2e}")
except RecursionError as e:
    print(f"Ошибка: {e}")

print("\n" + "=" * 50 + "\n")

def iterative_fixed_point(F, x, eps=1e-6, max_iter=1000):
    for i in range(max_iter):
        next_x = F(x)
        if abs(next_x - x) < eps:
            return next_x, i + 1
        x = next_x
    
    raise Exception(f"Не достигнута точность за {max_iter} итераций")

print("Задание 2: Итеративная реализация")
print("=" * 50)

result1_iter, iter1_iter = iterative_fixed_point(F_cos, 0.5, eps=1e-10)
print(f"cos(x) = x")
print(f"Результат: {result1_iter:.10f}")
print(f"Итераций: {iter1_iter}")
print("-" * 40)

result2_iter, iter2_iter = iterative_fixed_point(F_sqrt2, 1.0, eps=1e-10)
print(f"sqrt(2)")
print(f"Результат: {result2_iter:.10f}")
print(f"Итераций: {iter2_iter}")

print("\n" + "=" * 50 + "\n")

print("Задание 3: Анализ")
print("=" * 50)

print("3.1 Блок-схема:")
print("""
6.png
""")

print("\n3.2 Оценка глубины рекурсии:")
max_depth_default = sys.getrecursionlimit()
print(f"Ограничение в Python: {max_depth_default}")

def F_slow(x):
    return 0.5 * x + 0.5

print("\nТест медленной сходимости:")
try:
    result_slow, iters_slow = recursive_fixed_point(F_slow, 0.0, eps=1e-10, max_depth=5000)
    print(f"Результат: {result_slow:.10f}")
    print(f"Итераций: {iters_slow}")
except RecursionError as e:
    print(f"Ошибка: {e}")

def recursive_fixed_point_with_storage(F, x, eps=1e-6, max_depth=1000, depth=0, storage=None):
    if storage is None:
        storage = []
    
    next_x = F(x)
    storage.append((depth, x, next_x))
    
    if depth >= max_depth:
        raise RecursionError(f"Максимальная глубина: {max_depth}")
    
    if abs(next_x - x) < eps:
        return next_x, depth + 1, storage
    
    return recursive_fixed_point_with_storage(F, next_x, eps, max_depth, depth + 1, storage)

@lru_cache(maxsize=None)
def cached_F(F_func_id, x_value):
    return math.cos(x_value)

def recursive_fixed_point_cached(F, x, eps=1e-6, max_depth=1000, depth=0):
    if depth >= max_depth:
        raise RecursionError(f"Максимальная глубина: {max_depth}")
    
    next_x = cached_F(id(F), x)
    
    if abs(next_x - x) < eps:
        return next_x, depth + 1
    
    return recursive_fixed_point_cached(F, next_x, eps, max_depth, depth + 1)

print("\n3.3 Модернизированные версии:")

print("\nА) С сохранением результатов:")
result, iters, history = recursive_fixed_point_with_storage(F_cos, 0.5, eps=1e-6)
print(f"Результат: {result:.8f}, итераций: {iters}")
print(f"Сохранено значений: {len(history)}")
print("Первые 5 значений:")
for i, (step, x_old, x_new) in enumerate(history[:5]):
    print(f"Шаг {step}: x={x_old:.6f}, F(x)={x_new:.6f}")

print("\nБ) С кэшированием:")
cached_F.cache_clear()
result_cached, iters_cached = recursive_fixed_point_cached(F_cos, 0.5, eps=1e-6)
print(f"Результат: {result_cached:.8f}, итераций: {iters_cached}")
print(f"Размер кэша: {cached_F.cache_info().currsize}")

print("\n3.4 Сравнение производительности:")

import timeit

test_code_recursive = """
def test_recursive():
    recursive_fixed_point(F_cos, 0.5, eps=1e-6)
"""

test_code_iterative = """
def test_iterative():
    iterative_fixed_point(F_cos, 0.5, eps=1e-6)
"""

time_recursive = timeit.timeit(test_code_recursive, globals=globals(), number=10000)
time_iterative = timeit.timeit(test_code_iterative, globals=globals(), number=10000)

print(f"Рекурсивная: {time_recursive:.4f} сек")
print(f"Итеративная: {time_iterative:.4f} сек")
print(f"Отношение: {time_recursive/time_iterative:.2f}")

if time_recursive > time_iterative:
    print("Итеративная версия быстрее")
else:
    print("Рекурсивная версия быстрее")

print("\n" + "=" * 50)
print("Дополнительный анализ:")

functions = [
    ("cos(x)", F_cos),
    ("0.5*(x + 2/x)", F_sqrt2),
    ("0.5*x + 0.5", F_slow)
]

for name, func in functions:
    print(f"\nФункция: {name}")
    
    try:
        start = time.time()
        res_rec, iter_rec = recursive_fixed_point(func, 0.5, eps=1e-6)
        time_rec = time.time() - start
        
        start = time.time()
        res_iter, iter_iter = iterative_fixed_point(func, 0.5, eps=1e-6)
        time_iter = time.time() - start
        
        print(f"Рекурсия: {res_rec:.6f}, {iter_rec} итер., {time_rec:.6f} сек")
        print(f"Итерация: {res_iter:.6f}, {iter_iter} итер., {time_iter:.6f} сек")
        
        if iter_rec != iter_iter:
            print("Разное количество итераций!")
            
    except Exception as e:
        print(f"Ошибка: {e}")

print("\n" + "=" * 50)
```

    Задание 1: Рекурсивная реализация
    ==================================================
    cos(x) = x
    Начальное: 0.5
    Результат: 0.7390851333
    Итераций: 57
    cos(0.739085) = 0.739085
    ----------------------------------------
    sqrt(2)
    Начальное: 1.0
    Результат: 1.4142135624
    Точное: 1.4142135624
    Итераций: 5
    Разница: 2.22e-16
    
    ==================================================
    
    Задание 2: Итеративная реализация
    ==================================================
    cos(x) = x
    Результат: 0.7390851333
    Итераций: 57
    ----------------------------------------
    sqrt(2)
    Результат: 1.4142135624
    Итераций: 5
    
    ==================================================
    
    Задание 3: Анализ
    ==================================================
    3.1 Блок-схема:
    
    НАЧАЛО
      Вход: F, x0, eps, max_depth
      depth = 0
      ЦИКЛ:
        x_new = F(x_old)
        ЕСЛИ |x_new - x_old| < eps:
          ВЕРНУТЬ x_new, depth+1
        ИНАЧЕ:
          ЕСЛИ depth >= max_depth:
            ОШИБКА
          x_old = x_new
          depth = depth + 1
          ПРОДОЛЖИТЬ ЦИКЛ
    
    
    3.2 Оценка глубины рекурсии:
    Ограничение в Python: 3000
    
    Тест медленной сходимости:
    Результат: 0.9999999999
    Итераций: 34
    
    3.3 Модернизированные версии:
    
    А) С сохранением результатов:
    Результат: 0.73908482, итераций: 34
    Сохранено значений: 34
    Первые 5 значений:
    Шаг 0: x=0.500000, F(x)=0.877583
    Шаг 1: x=0.877583, F(x)=0.639012
    Шаг 2: x=0.639012, F(x)=0.802685
    Шаг 3: x=0.802685, F(x)=0.694778
    Шаг 4: x=0.694778, F(x)=0.768196
    
    Б) С кэшированием:
    Результат: 0.73908482, итераций: 34
    Размер кэша: 34
    
    3.4 Сравнение производительности:
    Рекурсивная: 0.0006 сек
    Итеративная: 0.0006 сек
    Отношение: 1.12
    Итеративная версия быстрее
    
    ==================================================
    Дополнительный анализ:
    
    Функция: cos(x)
    Рекурсия: 0.739085, 34 итер., 0.000000 сек
    Итерация: 0.739085, 34 итер., 0.000000 сек
    
    Функция: 0.5*(x + 2/x)
    Рекурсия: 1.414214, 6 итер., 0.000000 сек
    Итерация: 1.414214, 6 итер., 0.000000 сек
    
    Функция: 0.5*x + 0.5
    Рекурсия: 0.999999, 19 итер., 0.000000 сек
    Итерация: 0.999999, 19 итер., 0.000000 сек
    
    ==================================================
    


```python

```
