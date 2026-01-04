#### Задание 1


```python
import math

def sqrt_recursive(N, A, E):
    if N < 0:
        raise ValueError("N должно быть неотрицательным")
    if N == 0:
        return 0.0
    if A <= 0:
        raise ValueError("A должно быть положительным")

    new_A = (A + N / A) / 2

    if abs(new_A - A) < E:
        return new_A

    return sqrt_recursive(N, new_A, E)


print("\n1. Простые квадратные числа:")
tests = [
    (4, 2, 0.001),   
    (9, 3, 0.001),     
    (16, 4, 0.001),  
    (25, 5, 0.001), 
]

for N, A, E in tests:
    result = sqrt_recursive(N, A, E)
    expected = math.sqrt(N)
    print(f"√{N} = {result:.4f} (ожидалось: {expected:.4f})")

print("\n2. Обычные числа:")
ordinary_tests = [
    (2, 1, 0.0001),
    (3, 1, 0.0001),
    (5, 2, 0.0001),
    (10, 3, 0.0001),
]

for N, A, E in ordinary_tests:
    result = sqrt_recursive(N, A, E)
    expected = math.sqrt(N)
    difference = abs(result - expected)
    print(f"√{N} = {result:.6f} (разница: {difference:.8f})")

print("\n3. Проверка обработки ошибок:")
error_tests = [
    (-4, 2, 0.001),   
    (4, -2, 0.001),   
    (4, 0, 0.001),    
]

for N, A, E in error_tests:
    try:
        result = sqrt_recursive(N, A, E)
        print(f"√{N} = {result}")
    except ValueError as e:
        print(f"Ошибка для √{N}: {e}")

print("\n4. Разная точность вычислений:")
precision_tests = [
    (25, 10, 0.1),     
    (25, 10, 0.01),      
    (25, 10, 0.001),   
    (25, 10, 0.0001),  
]

for N, A, E in precision_tests:
    result = sqrt_recursive(N, A, E)
    print(f"√{N} с точностью {E} = {result:.8f}")

```

    
    1. Простые квадратные числа:
    √4 = 2.0000 (ожидалось: 2.0000)
    √9 = 3.0000 (ожидалось: 3.0000)
    √16 = 4.0000 (ожидалось: 4.0000)
    √25 = 5.0000 (ожидалось: 5.0000)
    
    2. Обычные числа:
    √2 = 1.414214 (разница: 0.00000000)
    √3 = 1.732051 (разница: 0.00000000)
    √5 = 2.236068 (разница: 0.00000000)
    √10 = 3.162278 (разница: 0.00000000)
    
    3. Проверка обработки ошибок:
    Ошибка для √-4: N должно быть неотрицательным
    Ошибка для √4: A должно быть положительным
    Ошибка для √4: A должно быть положительным
    
    4. Разная точность вычислений:
    √25 с точностью 0.1 = 5.00000023
    √25 с точностью 0.01 = 5.00000023
    √25 с точностью 0.001 = 5.00000000
    √25 с точностью 0.0001 = 5.00000000
    
    ========================================
    ТЕСТИРОВАНИЕ ЗАВЕРШЕНО!


#### Задание 2


```python
def quick_test():
    """Быстрые тесты за 1 минуту"""
    print("БЫСТРЫЕ ТЕСТЫ")
    print("=" * 30)
    
    # Всего 6 основных тестов
    quick_tests = [
        (4, 2, 0.001),
        (9, 3, 0.001), 
        (2, 1, 0.0001),
        (10, 3, 0.0001),
        (100, 10, 0.0001),
        (0.25, 0.5, 0.0001),
    ]
    
    for N, A, E in quick_tests:
        result = sqrt_iterative(N, A, E)
        print(f"√{N} = {result}")
    
    # Проверка ошибок
    print("\nПроверка ошибок:")
    try:
        sqrt_iterative(-1, 1, 0.001)
    except ValueError as e:
        print(f"✓ Правильно нашла ошибку: {e}")

# Запускаем быстрые тесты
quick_test()
```

    Введите число для извлечения квадратного корня:


#### Задание 3


```python
import sys
import time
from functools import wraps
from typing import List, Dict, Any

class SqrtStats:
    def __init__(self):
        self.iterations = 0
        self.max_stack_depth = 0
        self.execution_time = 0
        self.intermediate_results = []

    def reset(self):
        self.iterations = 0
        self.max_stack_depth = 0
        self.execution_time = 0
        self.intermediate_results = []

stats = SqrtStats()

"""Декоратор для сохранения промежуточных результатов рекурсии"""
def save_intermediate_results(func):
    @wraps(func)
    def wrapper(N, A, E, depth=0):
        stats.iterations += 1
        stats.max_stack_depth = max(stats.max_stack_depth, depth)

        intermediate = {
            'depth': depth,
            'N': N,
            'A': A,
            'E': E,
            'timestamp': time.time()
        }

        result = func(N, A, E, depth)

        intermediate['result'] = result
        stats.intermediate_results.append(intermediate)

        return result
    return wrapper

""" Рекурсивная реализация с ручным сохранением промежуточных результатов"""
def manual_sqrt_recursive_with_storage(N, A, E):
    intermediate_results = []
    stack_depth = 0

    def recursive_helper(n, a, e, depth):
        nonlocal stack_depth
        stack_depth = max(stack_depth, depth)
        stats.iterations += 1

        intermediate_results.append({
            'depth': depth,
            'N': n,
            'A': a,
            'E': e,
            'action': 'before_calculation'
        })

        if n < 0:
            raise ValueError("N должно быть неотрицательным")
        if n == 0:
            result = 0.0
            intermediate_results.append({
                'depth': depth,
                'result': result,
                'action': 'base_case_zero'
            })
            return result
        if a <= 0:
            raise ValueError("A должно быть положительным")

        new_A = (a + n / a) / 2

        intermediate_results.append({
            'depth': depth,
            'current_A': a,
            'new_A': new_A,
            'error': abs(new_A - a),
            'action': 'calculation'
        })

        if abs(new_A - a) < e:
            intermediate_results.append({
                'depth': depth,
                'result': new_A,
                'action': 'base_case_precision'
            })
            return new_A

        recursive_result = recursive_helper(n, new_A, e, depth + 1)

        intermediate_results.append({
            'depth': depth,
            'final_result': recursive_result,
            'action': 'after_recursion'
        })

        return recursive_result

    result = recursive_helper(N, A, E, 0)
    stats.max_stack_depth = stack_depth
    stats.intermediate_results = intermediate_results
    return result

""" Рекурсивный алгоритм с декоратором для сохранения промежуточных результатов"""
@save_intermediate_results
def sqrt_recursive_decorated(N, A, E, depth=0):
    if N < 0:
        raise ValueError("N должно быть неотрицательным")
    if N == 0:
        return 0.0
    if A <= 0:
        raise ValueError("A должно быть положительным")

    new_A = (A + N / A) / 2

    if abs(new_A - A) < E:
        return new_A

    return sqrt_recursive_decorated(N, new_A, E, depth + 1)

"""  Итеративный алгоритм со сбором статистики """ 
def sqrt_iterative_with_stats(N, A, E):
    stats.reset()
    start_time = time.time()

    if N < 0:
        raise ValueError("N должно быть неотрицательным")
    if N == 0:
        stats.execution_time = time.time() - start_time
        return 0.0
    if A <= 0:
        raise ValueError("A должно быть положительным")

    current_A = A
    iteration = 0

    while True:
        iteration += 1
        stats.iterations = iteration

        new_A = (current_A + N / current_A) / 2

        stats.intermediate_results.append({
            'iteration': iteration,
            'current_A': current_A,
            'new_A': new_A,
            'error': abs(new_A - current_A),
            'N': N,
            'E': E
        })

        if abs(new_A - current_A) < E:
            break

        current_A = new_A

    stats.execution_time = time.time() - start_time
    return new_A

""" Анализ максимальной глубины рекурсии """
def analyze_sqrt_stack_limit():
    original_limit = sys.getrecursionlimit()
    print(f"Текущий лимит рекурсии: {original_limit}")

    max_safe_iterations = 0

    for i in range(original_limit - 100):
        try:
            """ Тестируем с очень маленькой точностью для максимального количества итераций"""
            sqrt_recursive_decorated(2, 1, 1e-300)
            max_safe_iterations = i
        except RecursionError:
            break

    return max_safe_iterations, original_limit

""" Сравнение производительности алгоритмов"""
def sqrt_performance_comparison(test_cases):
    results = []

    for N, A, E in test_cases:
        print(f"\nТестирование sqrt({N}) с A={A}, E={E}:")

        """Рекурсивный с декоратором"""
        stats.reset()
        start_time = time.time()
        try:
            result1 = sqrt_recursive_decorated(N, A, E)
            recursive_time = time.time() - start_time
            print(f"Рекурсивный (с декоратором): {result1:.10f}")
            print(f"  Время: {recursive_time:.6f}с, Итерации: {stats.iterations}, Глубина стека: {stats.max_stack_depth}")
        except Exception as e:
            print(f"Рекурсивный (с декоратором): Ошибка - {e}")
            recursive_time = float('inf')

        """ Рекурсивный с ручным сохранением """
        stats.reset()
        start_time = time.time()
        try:
            result2 = manual_sqrt_recursive_with_storage(N, A, E)
            manual_recursive_time = time.time() - start_time
            print(f"Рекурсивный (ручное сохранение): {result2:.10f}")
            print(f"  Время: {manual_recursive_time:.6f}с, Итерации: {stats.iterations}, Глубина стека: {stats.max_stack_depth}")
        except Exception as e:
            print(f"Рекурсивный (ручное сохранение): Ошибка - {e}")
            manual_recursive_time = float('inf')

        """ Итеративный"""
        stats.reset()
        try:
            result3 = sqrt_iterative_with_stats(N, A, E)
            iterative_time = stats.execution_time
            print(f"Итеративный: {result3:.10f}")
            print(f"  Время: {iterative_time:.6f}с, Итерации: {stats.iterations}")
        except Exception as e:
            print(f"Итеративный: Ошибка - {e}")
            iterative_time = float('inf')

        """ Проверка совпадения результатов """
        try:
            if abs(result1 - result2) < E and abs(result2 - result3) < E:
                print(" Все алгоритмы дали одинаковый результат")
            else:
                print(" Ошибка: результаты различаются")
        except:
            print(" Невозможно сравнить результаты из-за ошибок")

        results.append({
            'N': N,
            'A': A,
            'E': E,
            'recursive_time': recursive_time,
            'manual_recursive_time': manual_recursive_time,
            'iterative_time': iterative_time,
            'recursive_iterations': stats.iterations,
            'stack_depth': stats.max_stack_depth
        })

    return results

""" Вывод сохраненных промежуточных результатов """
def print_sqrt_intermediate_results():
    print("\nПромежуточные результаты (последний вызов):")
    for i, result in enumerate(stats.intermediate_results[-10:]):
        print(f"  {i+1}: {result}")

# Итог:
print("=" * 60)
print("АНАЛИЗ АЛГОРИТМОВ ВЫЧИСЛЕНИЯ КВАДРАТНОГО КОРНЯ")
print("=" * 60)

print("\n1. АНАЛИЗ ОГРАНИЧЕНИЙ РЕКУРСИИ")
max_safe_iterations, recursion_limit = analyze_sqrt_stack_limit()
print(f"Максимальное безопасное количество итераций: {max_safe_iterations}")

test_cases = [
    (25, 5, 1e-10),
    (2, 1, 1e-10),
    (100, 10, 1e-12),
    (1000, 30, 1e-8),
    (0.25, 0.5, 1e-10),
    (1, 1, 1e-15)
]

print("\n2. СРАВНЕНИЕ ПРОИЗВОДИТЕЛЬНОСТИ")
results = sqrt_performance_comparison(test_cases)

print("\n3. СВОДНАЯ СТАТИСТИКА")
print("Алгоритм           | Среднее время | Макс. итераций | Макс. глубина")
print("-" * 70)

""" Фильтруем успешные выполнения """
successful_results = [r for r in results if r['recursive_time'] != float('inf')]

if successful_results:
    recursive_times = [r['recursive_time'] for r in successful_results]
    manual_times = [r['manual_recursive_time'] for r in successful_results]
    iterative_times = [r['iterative_time'] for r in successful_results]

    print(f"Рекурсивный        | {sum(recursive_times)/len(recursive_times):.6f}с    | {max(r['recursive_iterations'] for r in successful_results):<13} | {max(r['stack_depth'] for r in successful_results)}")
    print(f"Ручной рекурсивный | {sum(manual_times)/len(manual_times):.6f}с    | {max(r['recursive_iterations'] for r in successful_results):<13} | {max(r['stack_depth'] for r in successful_results)}")
    print(f"Итеративный        | {sum(iterative_times)/len(iterative_times):.6f}с    | {max(r['recursive_iterations'] for r in successful_results):<13} | -")
else:
    print("Нет успешных выполнений для сравнения")

print("\n4. ДЕМОНСТРАЦИЯ ПРОМЕЖУТОЧНЫХ РЕЗУЛЬТАТОВ")
stats.reset()
try:
    sqrt_recursive_decorated(25, 5, 1e-10)
    print_sqrt_intermediate_results()
except Exception as e:
    print(f"Ошибка при демонстрации: {e}")
```

    ============================================================
    АНАЛИЗ АЛГОРИТМОВ ВЫЧИСЛЕНИЯ КВАДРАТНОГО КОРНЯ
    ============================================================
    
    1. АНАЛИЗ ОГРАНИЧЕНИЙ РЕКУРСИИ
    Текущий лимит рекурсии: 3000
    Максимальное безопасное количество итераций: 2899
    
    2. СРАВНЕНИЕ ПРОИЗВОДИТЕЛЬНОСТИ
    
    Тестирование sqrt(25) с A=5, E=1e-10:
    Рекурсивный (с декоратором): 5.0000000000
      Время: 0.000007с, Итерации: 1, Глубина стека: 0
    Рекурсивный (ручное сохранение): 5.0000000000
      Время: 0.000006с, Итерации: 1, Глубина стека: 0
    Итеративный: 5.0000000000
      Время: 0.000002с, Итерации: 1
     Все алгоритмы дали одинаковый результат
    
    Тестирование sqrt(2) с A=1, E=1e-10:
    Рекурсивный (с декоратором): 1.4142135624
      Время: 0.000006с, Итерации: 5, Глубина стека: 4
    Рекурсивный (ручное сохранение): 1.4142135624
      Время: 0.000009с, Итерации: 5, Глубина стека: 4
    Итеративный: 1.4142135624
      Время: 0.000003с, Итерации: 5
     Все алгоритмы дали одинаковый результат
    
    Тестирование sqrt(100) с A=10, E=1e-12:
    Рекурсивный (с декоратором): 10.0000000000
      Время: 0.000001с, Итерации: 1, Глубина стека: 0
    Рекурсивный (ручное сохранение): 10.0000000000
      Время: 0.000002с, Итерации: 1, Глубина стека: 0
    Итеративный: 10.0000000000
      Время: 0.000001с, Итерации: 1
     Все алгоритмы дали одинаковый результат
    
    Тестирование sqrt(1000) с A=30, E=1e-08:
    Рекурсивный (с декоратором): 31.6227766017
      Время: 0.000004с, Итерации: 4, Глубина стека: 3
    Рекурсивный (ручное сохранение): 31.6227766017
      Время: 0.000005с, Итерации: 4, Глубина стека: 3
    Итеративный: 31.6227766017
      Время: 0.000002с, Итерации: 4
     Все алгоритмы дали одинаковый результат
    
    Тестирование sqrt(0.25) с A=0.5, E=1e-10:
    Рекурсивный (с декоратором): 0.5000000000
      Время: 0.000001с, Итерации: 1, Глубина стека: 0
    Рекурсивный (ручное сохранение): 0.5000000000
      Время: 0.000001с, Итерации: 1, Глубина стека: 0
    Итеративный: 0.5000000000
      Время: 0.000000с, Итерации: 1
     Все алгоритмы дали одинаковый результат
    
    Тестирование sqrt(1) с A=1, E=1e-15:
    Рекурсивный (с декоратором): 1.0000000000
      Время: 0.000001с, Итерации: 1, Глубина стека: 0
    Рекурсивный (ручное сохранение): 1.0000000000
      Время: 0.000001с, Итерации: 1, Глубина стека: 0
    Итеративный: 1.0000000000
      Время: 0.000001с, Итерации: 1
     Все алгоритмы дали одинаковый результат
    
    3. СВОДНАЯ СТАТИСТИКА
    Алгоритм           | Среднее время | Макс. итераций | Макс. глубина
    ----------------------------------------------------------------------
    Рекурсивный        | 0.000003с    | 5             | 0
    Ручной рекурсивный | 0.000004с    | 5             | 0
    Итеративный        | 0.000002с    | 5             | -
    
    4. ДЕМОНСТРАЦИЯ ПРОМЕЖУТОЧНЫХ РЕЗУЛЬТАТОВ
    
    Промежуточные результаты (последний вызов):
      1: {'depth': 0, 'N': 25, 'A': 5, 'E': 1e-10, 'timestamp': 1763979099.480004, 'result': 5.0}

