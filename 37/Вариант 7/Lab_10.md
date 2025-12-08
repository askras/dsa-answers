# Динамическое программирование
Фомин И.Н.
ИУ10-37
## Задания
### Задание 1
Реализовать все не реализованные алгоримтмы в лекции 14.
#### Задача о рюкзаке с возможностью дробить предметы


```python
class Item:
    def __init__(self, price, weight):
        self.price = price
        self.weight = weight
        self.ratio = price / weight

    def __repr__(self):
        return f'Item(price={self.price}, weight={self.weight})'


def fractional_knapsack(items, capacity):
    """Вернуть максимальную стоимость рюкзака с дроблением предметов"""
    items.sort(key=lambda x: x.ratio, reverse=True)
    total_value = 0.0

    for item in items:
        if capacity == 0:
            break
        if item.weight <= capacity:
            total_value += item.price
            capacity -= item.weight
        else:
            fraction = capacity / item.weight
            total_value += item.price * fraction
            capacity = 0

    return total_value


# Тесты
items = [Item(60, 15), Item(90, 30), Item(100, 50)]
print(fractional_knapsack(items, 80))

```

    220.0


#### Задача о покрытии отрезками


```python
def segment_cover(segments, target):
    """
    segments: список отрезков [(l, r)]
    target: целевой отрезок (L, R)
    Вернуть минимальный набор отрезков, покрывающих target
    """
    L, R = target
    segments.sort(key=lambda x: x[1])

    result = []
    current = L
    i = 0
    n = len(segments)

    while current < R:
        best_segment = None
        while i < n and segments[i][0] <= current:
            if best_segment is None or segments[i][1] > best_segment[1]:
                best_segment = segments[i]
            i += 1

        if best_segment is None:
            return None  # покрытие невозможно

        result.append(best_segment)
        current = best_segment[1]

    return result


# Тесты
segments = [(0, 3), (2, 5), (4, 7), (6, 10)]
target = (0, 10)

print(segment_cover(segments, target))

```

    [(0, 3), (2, 5), (4, 7), (6, 10)]


#### Задача о нахождении наименьшего пути


```python
from collections import deque
import copy

class Graph:
    def __init__(self, vertices, directed=False):
        self.vertices = vertices + 1
        self.directed = directed
        self.graph = {i: [] for i in range(self.vertices)}

    def add_edge(self, u, v, weight=1):
        self.graph[u].append((v, weight))

        if not self.directed:
            self.graph[v].append((u, weight))
    
    def get_vertex(self, u):
        return (u, 0)

    def wide_search(self, u, v):
        search_queue = deque()
        search_queue.append([u])
        paths = []

        while search_queue:
            path = search_queue.popleft()
            parent = path[-1]

            if parent[0] == v[0]:
                paths.append(path)
            else:
                for child in self.graph[parent[0]]:
                    new_path = path.copy() + [child]
                    search_queue.append(new_path)

        return paths


    def depth_search(self, u, v, path=[], paths=[]):
        path = path.copy() + [u]

        if u[0] == v[0]:
            paths.append(path)

        for child in self.graph[u[0]]:
            if child[0] not in [i[0] for i in path]:
                self.depth_search(child, v, path, paths)

        return paths
    

    def dijkstra(self, u, v):
        def find_lowest_cost_node(costs, processed=[]):
            lowest_cost = float("inf")
            lowest_cost_node = None
            for node in costs.keys():
                cost = costs[node]
                if cost < lowest_cost and node not in processed:
                    lowest_cost = cost
                    lowest_cost_node = node
            return lowest_cost_node
        
        processed = []
        parents = {}
        costs = {vertex[0]: vertex[1] for vertex in self.graph[u[0]]}
        node = find_lowest_cost_node(costs)
        
        while node is not None:
            cost = costs[node]
            neighbors = self.graph[node]
            for n in neighbors:
                new_cost = cost + n[1]
                if costs.get(n[0], float("inf")) > new_cost:
                    costs[n[0]] = new_cost
                    parents[n[0]] = node
            processed.append(node)
            node = find_lowest_cost_node(costs, processed)

        path = [v[0]]
        current = v[0]
        while current in parents:
            current = parents[current]
            path.append(current)
        path.append(u[0])
        path.reverse()

        return (costs[v[0]], path)


    def euler_cycle(self, start=0):
        graph = copy.deepcopy(self.graph)
        stack = [start]
        cycle = []

        while stack:
            v = stack[-1]
            if graph[v]:
                u, _ = graph[v].pop()

                for i, (x, _) in enumerate(graph[u]):
                    if x == v:
                        graph[u].pop(i)
                        break
                stack.append(u)
            else:
                cycle.append(stack.pop())

        return cycle[::-1]
    

    def hamilton_cycle(self):
        path = [0]
        visited = [False] * self.vertices
        visited[0] = True

        def backtrack(v):
            if len(path) == self.vertices:
                for neighbor, _ in self.graph[v]:
                    if neighbor == 0:
                        return True
                return False

            for neighbor, _ in self.vertices[v]:
                if not visited[neighbor]:
                    visited[neighbor] = True
                    path.append(neighbor)

                    if backtrack(neighbor):
                        return True

                    visited[neighbor] = False
                    path.pop()
            return False

        if backtrack(0):
            path.append(0)
            return path
        else:
            return None



graph = Graph(8, False)

graph.add_edge(1, 2, 4)
graph.add_edge(1, 5, 9)
graph.add_edge(1, 6, 10)
graph.add_edge(2, 3, 1)
graph.add_edge(2, 5, 3)
graph.add_edge(2, 7, 2)
graph.add_edge(3, 4, 1)
graph.add_edge(3, 6, 1)
graph.add_edge(3, 8, 7)
graph.add_edge(4, 7, 8)
graph.add_edge(4, 8, 6)
graph.add_edge(5, 6, 4)
graph.add_edge(6, 7, 1)
graph.add_edge(7, 8, 5)

print(graph.dijkstra(graph.get_vertex(8), graph.get_vertex(2)))
```

    (7, [8, 7, 2])


#### Задача о размене монет


```python
def min_coins_dp(coins, amount):
    """
    Вернуть минимальное количество монет для суммы amount
    """
    dp = [float('inf')] * (amount + 1)
    dp[0] = 0

    for i in range(1, amount + 1):
        for coin in coins:
            if i >= coin:
                dp[i] = min(dp[i], dp[i - coin] + 1)

    return dp[amount] if dp[amount] != float('inf') else -1


print(min_coins_dp([1, 3, 4], 6))
print(min_coins_dp([2], 3))

```

    2
    -1


#### Генерация разбиений множества


```python
def partitions(nums):
    """
    Сгенерировать все разбиения множества nums
    """
    result = []

    def backtrack(index, current):
        if index == len(nums):
            result.append([subset[:] for subset in current])
            return

        for i in range(len(current)):
            current[i].append(nums[index])
            backtrack(index + 1, current)
            current[i].pop()

        current.append([nums[index]])
        backtrack(index + 1, current)
        current.pop()

    backtrack(0, [])
    return result


res = partitions([1, 2, 3])
print(res)
print(len(res))

```

    [[[1, 2, 3]], [[1, 2], [3]], [[1, 3], [2]], [[1], [2, 3]], [[1], [2], [3]]]
    5

