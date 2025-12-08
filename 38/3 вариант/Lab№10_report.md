```python

# Алгоритм 1: Рюкзак с дроблением
def f1(items, capacity):
    items.sort(key=lambda x: x[0]/x[1], reverse=True)
    value = 0
    for price, weight in items:
        if capacity >= weight:
            value += price
            capacity -= weight
        else:
            value += price * (capacity / weight)
            break
    return value

# Алгоритм 2: Покрытие отрезками
def f2(segments, target):
    segments.sort()
    result = []
    current = target[0]
    for start, end in segments:
        if start <= current:
            result.append((start, end))
            current = end
            if current >= target[1]:
                break
    return result

# Алгоритм 3: Поиск кратчайших путей
def f3(graph):
    n = len(graph)
    dist = [[float('inf')]*n for _ in range(n)]
    for i in range(n):
        for j in range(n):
            dist[i][j] = graph[i][j]
    for k in range(n):
        for i in range(n):
            for j in range(n):
                if dist[i][j] > dist[i][k] + dist[k][j]:
                    dist[i][j] = dist[i][k] + dist[k][j]
    return dist

# Алгоритм 4: Размен монет
def f4(coins, amount):
    dp = [float('inf')] * (amount + 1)
    dp[0] = 0
    for i in range(1, amount + 1):
        for coin in coins:
            if i >= coin:
                dp[i] = min(dp[i], dp[i - coin] + 1)
    return dp[amount] if dp[amount] != float('inf') else -1

# Алгоритм 5: Генерация разбиений множества
def f5(elements):
    if not elements:
        return [[]]
    result = []
    first = elements[0]
    for partition in set_partitions(elements[1:]):
        result.append([[first]] + partition)
        for i in range(len(partition)):
            new_partition = [list(s) for s in partition]
            new_partition[i] = [first] + new_partition[i]
            result.append(new_partition)
    return result

# Алгоритм 6: Генетический алгоритм
def f6(func):
    solutions = [random.random() for _ in range(50)]
    best = max(solutions, key=func)
    for _ in range(100):
        new_solutions = []
        for _ in range(50):
            p1 = random.choice(solutions)
            p2 = random.choice(solutions)
            child = (p1 + p2) / 2
            if random.random() < 0.2:
                child += random.uniform(-1, 1)
            new_solutions.append(child)
        solutions = new_solutions
        current_best = max(solutions, key=func)
        if func(current_best) > func(best):
            best = current_best
    return best, func(best)

# Алгоритм 7: Задача коммивояжера
def f7(distances):
    n = len(distances)
    visited = [False] * n
    path = [0]
    visited[0] = True
    total = 0
    for _ in range(n - 1):
        last = path[-1]
        nearest = -1
        min_dist = float('inf')
        for i in range(n):
            if not visited[i] and distances[last][i] < min_dist:
                min_dist = distances[last][i]
                nearest = i
        path.append(nearest)
        visited[nearest] = True
        total += min_dist
    total += distances[path[-1]][0]
    return total, path

# Алгоритм 8: Покрытие множества
def f8(all_items, groups):
    need = set(all_items) 
    answer = []
    while need:
        best_group = None
        best_cover = 0
        for group in groups:
            new_cover = len(need & set(group))
            if new_cover > best_cover:
                best_cover = new_cover
                best_group = group
        if not best_group:
            break
        answer.append(best_group)
        need -= set(best_group)
    return answer
```
