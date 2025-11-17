# Л.Р. 7 - "Алгоритмы на графах"

**Цао М.М.**
**ИУ10-36**

### Задания
### Задание №1 - реализовать программу, выполняющую описанный набор операций на графах:

```python
class Graph:
def __init__(self):
        self.connections = {}
    
    def depth_first_search(self, start_node): pass
    def breadth_first_search(self, start_node): pass
    def find_euler_cycle(self): pass
    def find_hamilton_cycles(self): pass
    def find_shortest_paths(self, start_node): pass
```

**Пояснение - было реализовано 5 алгоритмов:**
1) Обход в глубину - ```python def depth_first_search(self, start_node)```
2) Обход в ширину - ``` python def breadth_first_search(self, start_node)```
3) Поиск Эйлерова цикла - ```python def find_euler_cycle(self) ```
4) Поиск Гамильтоновых циклов - ```python def find_hamilton_cycles(self)```
5) Алгоритм Дейкстры - ```python def find_shortest_paths(self, start_node)```

**Примечание: Алгоритм Дейкстры реализован без взвешенных графов**

### Задание №2 - Реализовать приложение, для работы с графом:

```python 
class Graph:
    def __init__(self): pass
    def initialize(self, directed=False): pass
    def clear(self): pass
    def add_vertex(self, vertex): pass
    def add_edge(self, vertex1, vertex2): pass
    def remove_vertex(self, vertex): pass
    def remove_edge(self, vertex1, vertex2): pass
    def display(self): pass
    def path(self, start, end, path=None, visited=None): pass
    def degree(self, vertex): pass
    def info(self): pass 
```

**Пояснение - в данной задаче было реализовано приложение для работы с графом, которое:**
1) ```python def __init__(self)``` - инициализация пустого графа
2) ```python def initialize(self, directed=False):``` - полностью пересоздает граф с нуля
3) ```python  def clear(self):``` - очистка, причем тип графа остается таким же
4) ```python def add_vertex/remove_vertex(self, vertex)``` - добавление/удаление вершины
5) ```python def add_edge/remove_edge(self, vertex1, vertex2)``` - добавление/удаление ребра
6) ```python def display(self)``` - вывод информации о состоянии графа
7) ```python def path(self, start, end, path=None, visited=None)``` - нахождение пути между двумя вершинами
8) ```python def degree(self, vertex)``` - вычисление степень вершины
9) ```python def info(self)``` - вывод подробной информации и предложение рекомендаций по текущему графу

### Задание №3 - индивидуальное задание(Топологическая сортировка):

```python
class Graph:
    def __init__(self, directed=True):
        self.graph = defaultdict(list)
        self.directed = directed
        self.vertices = set()
        
    def add_edge(self, u, v):
        self.graph[u].append(v)
        self.vertices.add(u)
        self.vertices.add(v)
        if not self.directed:
            self.graph[v].append(u)
    
    def add_vertex(self, v):
        self.vertices.add(v)
        if v not in self.graph:
            self.graph[v] = []
    
    def get_neighbors(self, v):
        return self.graph.get(v, [])
    
    def topological_sort_dfs(self):
        # if not self.directed:
        #     raise ValueError("Топологическая сортировка применима только к ориентированным графам")
        
        visited = set()
        stack = []
        recursion_stack = set()
        
        def dfs(vertex):
            if vertex in recursion_stack:
                raise ValueError(f"Граф содержит цикл, обнаружен на вершине {vertex}")
            if vertex in visited:
                return
            
            visited.add(vertex)
            recursion_stack.add(vertex)
            
            for neighbor in self.get_neighbors(vertex):
                dfs(neighbor)
            
            recursion_stack.remove(vertex)
            stack.append(vertex)
        
        for vertex in self.vertices:
            if vertex not in visited:
                dfs(vertex)
        
        return stack[::-1]
    
    def topological_sort_kahn(self):
        # if not self.directed:
        #     raise ValueError("Топологическая сортировка применима только к ориентированным графам")
        
        in_degree = {vertex: 0 for vertex in self.vertices}
        for vertex in self.vertices:
            for neighbor in self.get_neighbors(vertex):
                in_degree[neighbor] += 1
        
        queue = deque([v for v in self.vertices if in_degree[v] == 0])
        top_order = []
        
        while queue:
            vertex = queue.popleft()
            top_order.append(vertex)
            
            for neighbor in self.get_neighbors(vertex):
                in_degree[neighbor] -= 1
                if in_degree[neighbor] == 0:
                    queue.append(neighbor)
        
        # if len(top_order) != len(self.vertices):
        #     raise ValueError("Граф содержит цикл, топологическая сортировка невозможна")
        
        return top_order
    
    def has_cycle(self):
        if not self.directed:
            return False
            
        visited = set()
        recursion_stack = set()
        
        def dfs(vertex):
            if vertex in recursion_stack:
                return True
            if vertex in visited:
                return False
                
            visited.add(vertex)
            recursion_stack.add(vertex)
            
            for neighbor in self.get_neighbors(vertex):
                if dfs(neighbor):
                    return True
            
            recursion_stack.remove(vertex)
            return False
        
        for vertex in self.vertices:
            if vertex not in visited:
                if dfs(vertex):
                    return True
        return False
```
**Пояснение - в классе ддля работы с графами, реализована топологическая сортировка в качестве индвидуального задания, которая упорядочивает вершины так, чтобы все зависимости соблюдались.**

### Задание №4 - Найти кратчайший путь на графе между парами вершин(1,6) ориентированного графа:

**By hand:**
**Из 1->2:8; 2->6:9; 1->6 = 8 + 9 = 17 - кратчайший путь
Из 6->1  нету путей, поскольку это ориентированный граф**

![png](imgs/04.png)

**Code:**
```python
while queue:
    current_distance, current_vertex = heapq.heappop(queue)

    #если текущее расстояние больше известного - пропускаем
    if current_distance > distances[current_vertex]:
        continue

    #проверка всех соседей
    for neighbor, weight in graph[current_vertex]:
        distance = current_distance + weight

        #если нашли более короткий путь - обновляем инфу о его длине(и откуда пришли)
        if distance < distances[neighbor]:
            distances[neighbor] = distance
            previous[neighbor] = current_vertex
            heapq.heappush(queue, (distance, neighbor))
```

**Пояснение - алогритм работает через поиск кратчайших путей и обновления расстояний до вершин**

### Задание №5 - реализовать алгоритм Дейкстры поиска кратчайшего пути на графе между парами вершин (1,6):

```python
# edges_raw = [
#     (1, 2, 1),
#     (1, 3, 5),
#     (1, 4, 6),
#     (1, 6, 11),
#     (1, 7, 15),
#     (2, 3, 5),
#     (2, 4, 5),
#     (2, 5, 1),
#     (3, 8, 19),
#     (4, 5, 3),
#     (4, 6, 2),
#     (5, 6, 8),
#     (5, 8, 12),
#     (6, 7, 3),
#     (7, 8, 1)
# ]

edges = []
for u, v, w in edges_raw:
    edges.append((u, v, w))
    edges.append((v, u, w))

def dijkstra(edges, source):
    graph = defaultdict(list)
    nodes = set()
    for u, v, w in edges:
        graph[u].append((v, w))
        nodes.add(u)
        nodes.add(v)

    dist = {n: float('inf') for n in nodes}
    prev = {n: None for n in nodes}
    dist[source] = 0
    pq = [(0, source)]

    while pq:
        d, u = heapq.heappop(pq)
        if d != dist[u]:
            continue
        for v, w in graph[u]:
            nd = d + w
            if nd < dist[v]:
                dist[v] = nd
                prev[v] = u
                heapq.heappush(pq, (nd, v))
    return dist, prev

def reconstruct_path(prev, source, target):
    path = []
    cur = target
    while cur is not None:
        path.append(cur)
        if cur == source:
            break
        cur = prev[cur]
    path.reverse()
    if path[0] != source:
        return None
    return path

# source = 1
# target = 6

dist, prev = dijkstra(edges, source)
path = reconstruct_path(prev, source, target)

```
**Пояснение - алгоритм каждый раз выбирает вершину с самым коротким найденным путём, проверяет все её соседние вершины, если через текущую вершину путь короче — обновляет dist и prev.**

![Граф№2](imgs/05.png)

### Задание №6 - Программно реализовать алгоритм нахождения кратчайшего пути на графе из 5-ой задачи:

```python
# edges = [
#     (1, 2, 1),
#     (1, 3, 5),
#     (1, 4, 6),
#     (1, 6, 11),
#     (1, 7, 15),
#     (2, 4, 5),
#     (2, 3, 5),
#     (2, 5, 1),
#     (4, 5, 3),
#     (4, 6, 2),
#     (5, 6, 8),
#     (6, 7, 3),
#     (5, 8, 12),
#     (7, 8, 1),
#     (3, 8, 19)
# ]

undirected_edges = []
for u, v, w in edges:
    undirected_edges.append((u, v, w))
    undirected_edges.append((v, u, w))

# V = 8 
# start = 1 

dist = {v: float('inf') for v in range(1, V + 1)}
dist[start] = 0

for _ in range(V - 1):
    for u, v, w in undirected_edges:
        if dist[u] + w < dist[v]:
            dist[v] = dist[u] + w

for u, v, w in undirected_edges:
    if dist[u] + w < dist[v]:
        print("Обнаружен отрицательный цикл!")

print(f"Кратчайшие расстояния от вершины {start}:")
for v in range(1, V + 1):
    print(f"до {v}: {dist[v]}")
```

**Пояснение - данный код реализует алгоритм Беллмана–Форда для поиска кратчайших путей от заданной вершины до всех остальных в неориентированном графе.На каждом шаге происходит релаксация рёбер — проверка, можно ли улучшить текущее расстояние до вершины через другую. После выполнения всех итераций программа выводит минимальные расстояния от исходной вершины до каждой вершины графа.**


**Выводы**
1) В ходе лабораторной работы были изучены основные типы графов (ориентированные и неориентированные, взвешенные и невзвешенные) и способы их представления — в виде списков смежности и матриц смежности.
2) Ознакомились с базовыми алгоритмами обхода графов — поиском в глубину (DFS) и поиском в ширину (BFS), что позволило понять различия между стратегиями систематического просмотра вершин.
3) Были реализованы и исследованы алгоритмы поиска кратчайших путей — Дейкстры и Беллмана–Форда, что дало возможность сравнить их принципы работы и область применения.
4) При выполнении работы освоены способы построения и анализа графов, а также принципы определения связности и нахождения кратчайших маршрутов.
5) В результате работы получено понимание, как алгоритмы на графах применяются для решения практических задач оптимизации и анализа сетевых структур.


