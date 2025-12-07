# Л.Р. 10 - "Динамическое программирование"

**Цао М.М.**
**ИУ10-36**
### Теоретические сведения
**Принцип декомпозиции сложных задач - руководствовался фундаментальным положением теории алгоритмов о необходимости разбиения сложных задач на более простые подзадачи.**

**Теория вычислительной сложности - при выборе методов решения учитывались положения теории сложности вычислений:
классификация задач по классам P, NP; оценка временной и пространственной сложности; баланс между точностью и эффективностью**

**Принцип "разделяй и властвуй" с мемоизацией - разделение на независимые подзадачи; запоминание промежуточных результатов; комбинирование решений**

**Теория жадных алгоритмов и локальной оптимальности - при сравнении методов учитывались:критерии применимости жадных 
стратегий; cвойство матроидов для жадных алгоритмов; ограничения локальной оптимальности**

**Анализ асимптотического поведения - O-нотация для верхних оценок; (Омега-нотация) - нотация для нижних оценок; анализ предельного поведения при росте n**

### Задания
### Алгоритм №1 - рюкзак с дроблением:
```python
class Item:
    def __init__(self, price, weight):
        self.price = price
        self.weight = weight
        self.ratio = price / weight 

def fractional_knapsack(items, capacity): # Сортируем предметы по убыванию удельной стоимости
    items.sort(key=lambda x: x.ratio, reverse=True)
    total_value = 0.0
    remaining_capacity = capacity
    
    for item in items:
        if remaining_capacity >= item.weight:
            # Берем предмет целиком
            total_value += item.price
            remaining_capacity -= item.weight
        else:
            # Берем часть предмета
            fraction = remaining_capacity / item.weight
            total_value += item.price * fraction
            break
    
    return total_value
```

### Алгоритм №2 - Покрытие отрезками:
```python
 def segment_cover(segments, target_segment):
    segments.sort()  # Сортируем по левому концу
    result = []
    current_end = target_segment[0]
    
    for seg in segments:
        if seg[0] <= current_end and seg[1] > current_end:
            # Выбираем отрезок, расширяющий покрытие
            result.append(seg)
            current_end = seg[1]
            if current_end >= target_segment[1]:
                break
    
    return result if current_end >= target_segment[1] else []
```

### Алгоритм №3 - поиск кратчайших путей:
```python
def shortest_paths(graph):
    n = len(graph)
    dist = [row[:] for row in graph]  # Копируем исходную матрицу
    
    for k in range(n):
        for i in range(n):
            for j in range(n):
                # Релаксация пути через вершину k
                if dist[i][j] > dist[i][k] + dist[k][j]:
                    dist[i][j] = dist[i][k] + dist[k][j]
    
    return dist
```

### Алгоритм №4 - Размен монет:
```python
def coin_change_dp(coins, amount):
    # dp[i] - минимальное количество монет для суммы i
    dp = [float('inf')] * (amount + 1)
    dp[0] = 0  # Базовый случай
    
    for coin in coins:
        for i in range(coin, amount + 1):
            # Выбираем минимум между текущим и новым путем
            dp[i] = min(dp[i], dp[i - coin] + 1)
    
    return dp[amount] if dp[amount] != float('inf') else -1
```

### Алгоритм №5 - Генерация разбиений множества:
```python
def set_partitions(elements):
    if not elements:
        return [[]]  
    
    result = []
    first = elements[0]
    
    # Рекурсивно генерируем разбиения для оставшихся элементов
    for smaller in set_partitions(elements[1:]):
        # Добавляем первый элемент в каждое существующее подмножество
        for i, subset in enumerate(smaller):
            new_part = [list(s) for s in smaller]
            new_part[i] = [first] + new_part[i]
            result.append(new_part)
        
        result.append([[first]] + [list(s) for s in smaller])
    
    return result
```

### Алгоритм №6 - Оптимизация многомерной функции генетическим алгоритмом:
```python
# Основной цикл эволюции
population = initialize_population()
best_solution = max(population, key=objective_func)
    
for _ in range(generations):
    new_population = []
    for _ in range(pop_size // 2):
        # Селекция и скрещивание
        parent1 = tournament_selection(population)
        parent2 = tournament_selection(population)
        child = crossover(parent1, parent2)
        new_population.append(mutate(child))
        
    population = new_population
    # Обновление лучшего решения
    current_best = max(population, key=objective_func)
    if objective_func(current_best) > objective_func(best_solution):
        best_solution = current_best
return best_solution, objective_func(best_solution)
```

### Алгоритм №7 - Задача коммивояжера:
```python
def tsp_dp(distances):
    n = len(distances)
    # dp[mask][i] - минимальная стоимость посещения городов из mask, заканчивая в i
    dp = [[float('inf')] * n for _ in range(1 << n)]
    dp[1][0] = 0  # Начинаем с города 0
    
    for mask in range(1 << n):
        for i in range(n):
            if dp[mask][i] == float('inf'):
                continue
            # Переход к следующему городу
            for j in range(n):
                if not (mask & (1 << j)):
                    new_mask = mask | (1 << j)
                    dp[new_mask][j] = min(dp[new_mask][j], dp[mask][i] + distances[i][j])
    
    # Находим минимальный цикл, возвращающийся в город 0
    return min(dp[(1 << n) - 1][i] + distances[i][0] for i in range(n))
```

### Алгоритм №8 - покрытие множества:
```python
def set_cover_greedy(universe, subsets):
    uncovered = set(universe)
    result = []
    
    while uncovered:
        # Выбираем подмножество, покрывающее наибольшее число непокрытых элементов
        best_subset = max(subsets, key=lambda s: len(uncovered.intersection(s)))
        result.append(best_subset)
        uncovered -= set(best_subset)
    
    return result
```

**Упрощенный алгоритм:**
```python
def set_cover_optimized(universe, subsets): # жадный алгоритм покрытия множества
    uncovered = set(universe)
    selected_subsets = []

    indexed_subsets = [(i, set(subset)) for i, subset in enumerate(subsets)]
    indexed_subsets.sort(key=lambda x: len(x[1]), reverse=True)

    while uncovered: #поиск лучшего подмножества
        best_subset = None
        best_cover = 0
        best_index = -1

        for i, subset in indexed_subsets:
            cover_count = len(uncovered & subset)
            if cover_count > best_cover:
                best_cover = cover_count
                best_subset = subset
                best_index = i

        if best_subset is None:
            break

        selected_subsets.append(subsets[best_index])
        uncovered -= best_subset

    return selected_subsets


def verify_cover(universe, selected_subsets): # Валидатор (верификатор покрытия)
    covered = set()
    for subset in selected_subsets:
        covered.update(subset)
    return covered == universe
```
**Тесты для проверки:**
```python
try:
    universe1 = {1, 2, 3, 4, 5}
    subsets1 = [{1, 2, 3}, {2, 4}, {3, 4, 5}, {4, 5}]
    result1 = set_cover_optimized(universe1, subsets1)
    assert verify_cover(universe1, result1) and len(result1) == 2
    print("TEST 1: PASSED")
except:
    print("TEST 1: FAILED")

try:
    universe2 = {1, 2, 3, 4}
    subsets2 = [{1}, {2}, {3}, {4}, {1, 2, 3, 4}]
    result2 = set_cover_optimized(universe2, subsets2)
    assert verify_cover(universe2, result2) and len(result2) == 1
    print("TEST 2: PASSED")
except:
    print("TEST 2: FAILED")

try:
    universe3 = {1, 2, 3, 4, 5, 6, 7}
    subsets3 = [{1, 2, 3}, {4, 5, 6}, {3, 4, 7}, {1, 7}, {2, 5}]
    result3 = set_cover_optimized(universe3, subsets3)
    assert verify_cover(universe3, result3) and len(result3) <= 4
    print("TEST 3: PASSED")
except:
    print("TEST 3: FAILED")
```


**Выводы:**
1)  Практическая реализация алгоритмов ДП подтвердила, что оптимальное решение строится из оптимальных подрешений:
```python
dp[i] = min(dp[i], dp[i - coin] + 1)
```

2) Восходящий метод показал преимущества в эффективности использования памяти и отсутствии рекурсивных накладных расходов:
```python
for k in range(n):
    for i in range(n):
        for j in range(n):
            if dist[i][j] > dist[i][k] + dist[k][j]:
                dist[i][j] = dist[i][k] + dist[k][j]
```

3) ДП гарантирует глобальный оптимум, в отличие от жадных алгоритмов, что подтверждено на примере задач о рюкзаке.

4) Успешное применение к разнородным задачам (оптимизационным, комбинаторным, графовым) демонстрирует широкую применимость метода.

5) Применение ДП для задачи коммивояжера сократило сложность с O(n!) до O(n^2·2^n):
```python
dp = [[float('inf')] * n for _ in range(1 << n)]
```

6) Реализованные алгоритмы имеют непосредственное применение в логистике, финансах и управлении ресурсами.
   
7) Метод пошагового заполнения таблицы состояний доказал свою эффективность для задач средней размерности.

8) Экспериментально установлено наличие множественных повторных вычислений в задачах, решаемых ДП.

9) Практика подтвердила эффективность стандартной последовательности: определение состояния → базовые случаи → рекуррентные соотношения.

10) Применение ДП позволяет получать точные решения за полиномиальное время для широкого класса задач.
