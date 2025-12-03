# Лабораторная работа 6 Самойлов Даниил ИУ10-38
# Итеративные и рекурсивные алгоритмы
## Цель работы
Изучение хеш-функций и хеш-таблиц, а также основных операций над ними.
## Задачи лабораторной работы
1. Реализуйте рекурсивный алгоритм решения уравнений вида  методом простых итераций.
2. Реализуйте алгоритм не используя рекурсию.
3. Cоставить блок-схему.
4. Оценить верхнюю границу размерности задачи, для которой при рекурсивной реализации не происходит переполнение стека вызовов.
5. Модернизируйте рекурсивную реализацию так, чтобы сохранялись промежуточные результаты вызова рекурсии.
## Словесная постановка задачи
1. Изучить теоретический материал по хеш функциям и таблицам.
2. Реализовать хеш-таблицы на основе метода цепочек и на основе открытой адресации .
3. Написать задания, использующие реализованные ранее структуры.

# Задачи
### 1. Рекурсивный алгоритм решения уравнений вида $F(x) = x$ методом простых итераций.
```python
def F(x):
    return  (0.5 * (x + 2 / x))
def simple_iteration(x0, E=1e-6, count_iter=0):
    x1 = F(x0)
    if abs(x1 - x0) <= E:
        return x1
    return simple_iteration(x1, E, count_iter+ 1)    
```

### 3. Hекурсивная реализация для сохранения промежуточных результатов вызова рекурсии.
```python
def simple_iteration_iterative(x0, E=1e-6, max_iter=1000):
    x = x0
    count_iter = 0
    while count_iter <= max_iter:
        x1 = F(x)
        count_iter += 1 
        if abs(x1 - x) <= E:
            print(f"x = {x1}")
            return x1
        x = x1
    return x
```

```python
def recursive_history(original_func):
    def wrapped(*args, **kwargs):
        history = kwargs.get('_history', None)
        if history is None:
            history = []
            kwargs['_history'] = history
        result = original_func(*args, **kwargs)

        if not kwargs.get('_is_recursive', False):
            if isinstance(result, tuple):
                return (*result, history)
            else:
                return result, history, kwargs.get('count_iter', 0)
        
        return result
    
    return wrapped

@recursive_history
def simple_iteration_universal(x0, E=1e-12, count_iter=0, _history=None, _is_recursive=False):
    x1 = F(x0)
    
    _history.append({
        'iteration': count_iter,
        'x_prev': x0,
        'x_current': x1,
        'difference': abs(x1 - x0)
    })
    
    if abs(x1 - x0) <= E:
        return x1, count_iter
    
    return simple_iteration_universal(
        x1, E, count_iter + 1, 
        _history=_history, 
        _is_recursive=True
    )

result, history, iterations = simple_iteration_universal(1.0)
print(f"\nРезультат (универсальный декоратор): {result}")
print(f"Количество итераций: {iterations}")
```