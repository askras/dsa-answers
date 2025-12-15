```python

# Алгоритм 1: Рюкзак с дроблением
def f1(items, vmest):
    items.sort(key=lambda x: x[0]/x[1], reverse=True)
    cena = 0
    for price, weight in items:
        if vmest >= weight:
            value += cena
            vmest -= weight
        else:
            cena += cena * (vmest / weight)
            break
    return cena

# Алгоритм 2: Покрытие отрезками
def f2(otr, target):
    otr.sort()
    res = []
    curr = target[0]
    for start, end in otr:
        if start <= curr:
            res.append((start, end))
            curr = end
            if curr >= target[1]:
                break
    return res

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
    res = [float('inf')] * (amount + 1)
    res[0] = 0
    for i in range(1, amount + 1):
        for coin in coins:
            if i >= coin:
                res[i] = min(res[i], res[i - coin] + 1)
    return res[amount] if res[amount] != float('inf') else -1

# Алгоритм 5: Генерация разбиений множества
def f5(elements):
    if not elements:
        return [[]]
    result = []
    first = elements[0]
    for parti in f5(elements[1:]):
        result.append([[first]] + parti)
        for i in range(len(parti)):
            newparti = [list(s) for s in parti]
            newparti[i] = [first] + newparti[i]
            result.append(newparti)
    return result

# Алгоритм 6: Генетический алгоритм
def f6(func):
    solutions = [random.random() for i in range(50)]
    best = max(solutions, key=func)
    for i in range(100):
        newsolut = []
        for j in range(50):
            p1 = random.choice(solutions)
            p2 = random.choice(solutions)
            child = (p1 + p2) / 2
            if random.random() < 0.2:
                child += random.uniform(-1, 1)
            newsolut.append(child)
        solutions = newsolut
        currentbest = max(solutions, key=func)
        if func(currentbest) > func(best):
            best = currentbest
    return best, func(best)

# Алгоритм 7: Задача коммивояжера
def f7(lens):
    n = len(lens)
    visited = [False] * n
    path = [0]
    visited[0] = True
    total = 0
    for _ in range(n - 1):
        last = path[-1]
        near = -1
        mindist = float('inf')
        for i in range(n):
            if not visited[i] and lens[last][i] < mindist:
                mindist = lens[last][i]
                near = i
        path.append(near)
        visited[near] = True
        total += mindist
    total += lens[path[-1]][0]
    return total, path

# Алгоритм 8: Покрытие множества
def f8(items, groups):
    need = set(items) 
    res = []
    while need:
        bestgroup = None
        bestcover = 0
        for i in groups:
            newcover = len(need & set(i))
            if newcover > bestcover:
                bestcover = newcover
                bestgroup = i
        if not bestgroup:
            break
        res.append(bestgroup)
        need -= set(bestgroup)
    return res
```
