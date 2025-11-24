# Алгоритмы на графах
Баскаков Д. С.
ИУ10-38

## Цель работы:
Изучение основных алгоритмов на графах.
### Задание 1

```python
from collections import deque
import heapq

class Graph:
    def __init__(self, directed=False):
        self.vertices = {}
        self.is_directed = directed
    
    def add_vertex(self, i):
        if i not in self.vertices:
            self.vertices[i] = {}
    
    def add_edge(self, i, j, weight=1):
        self.add_vertex(i)
        self.add_vertex(j)
        
        self.vertices[i][j] = weight
        if not self.is_directed:
            self.vertices[j][i] = weight
    
    def remove_edge(self, i, j):
        if i in self.vertices and j in self.vertices[i]:
            del self.vertices[i][j]
            if not self.is_directed:
                if j in self.vertices and i in self.vertices[j]:
                    del self.vertices[j][i]
    
    def remove_vertex(self, i):
        if i in self.vertices:
            for j in list(self.vertices.keys()):
                if i in self.vertices[j]:
                    del self.vertices[j][i]
            del self.vertices[i]
    
    def get_vertices(self):
        return list(self.vertices.keys())
    
    def get_edges(self):
        edges = []
        for i in self.vertices:
            for j, w in self.vertices[i].items():
                if self.is_directed:
                    edges.append((i, j, w))
                else:
                    if i < j:
                        edges.append((i, j, w))
        return edges
    
    def bfs(self, start):
        visited = set()
        queue = deque([start])
        order = []
        while queue:
            i = queue.popleft()
            if i not in visited:
                visited.add(i)
                order.append(i)
                for j in self.vertices[i]:
                    if j not in visited:
                        queue.append(j)
        
        return order
    
    def dfs(self, start):
        visited = set()
        stack = [start]
        order = []
        while stack:
            i = stack.pop()
            if i not in visited:
                visited.add(i)
                order.append(i)
                neighbors = list(self.vertices[i].keys())
                for j in reversed(neighbors):
                    if j not in visited:
                        stack.append(j)
        
        return order
    
    def dijkstra(self, start, end):
    distances = {vertex: float('infinity') for vertex in self.vertices}
    distances[start] = 0
    priority_queue = [(0, start)]
    parents = {vertex: None for vertex in self.vertices}
    while priority_queue:
        current_distance, current_vertex = heapq.heappop(priority_queue)
        if current_distance > distances[current_vertex]:
            continue
        for neighbor, weight in self.vertices[current_vertex].items():
            distance = current_distance + weight
            if distance < distances[neighbor]:
                distances[neighbor] = distance
                parents[neighbor] = current_vertex
                heapq.heappush(priority_queue, (distance, neighbor))
    path = []
    current = end
    while current is not None:
        path.append(current)
        current = parents[current]
    path.reverse()
    return path, distances[end]
    
    def __str__(self):
        result = "Граф:\n"
        for i in self.vertices:
            result += f"{i}: {self.vertices[i]}\n"
        return result
```

### Задание 2

```python
def main():
    g = Graph(directed=False)
    
    while True:
        print("\n=== МЕНЮ ===")
        print("1. Добавить вершину")
        print("2. Добавить ребро")
        print("3. Удалить вершину")
        print("4. Удалить ребро")
        print("5. Показать граф")
        print("6. Обход в ширину (BFS)")
        print("7. Обход в глубину (DFS)")
        print("8. Алгоритм Дейкстры")
        print("0. Выход")
        
        choice = input("Выберите: ")
        
        if choice == '1':
            vertex = input("Введите вершину: ")
            g.add_vertex(vertex)
            
        elif choice == '2':
            v1 = input("Первая вершина: ")
            v2 = input("Вторая вершина: ")
            try:
                weight = float(input("Вес: ") or 1)
            except:
                weight = 1
            g.add_edge(v1, v2, weight)
            
        elif choice == '3':
            vertex = input("Вершина для удаления: ")
            g.remove_vertex(vertex)
            
        elif choice == '4':
            v1 = input("Первая вершина: ")
            v2 = input("Вторая вершина: ")
            g.remove_edge(v1, v2)
            
        elif choice == '5':
            print(g)
            print("Вершины:", g.get_vertices())
            print("Рёбра:", g.get_edges())
            
        elif choice == '6':
            start = input("Стартовая вершина: ")
            result = g.bfs(start)
            print(f"BFS: {result}")
            
        elif choice == '7':
            start = input("Стартовая вершина: ")
            result = g.dfs(start)
            print(f"DFS: {result}")
            
        elif choice == '8':
            start = input("Начало: ")
            end = input("Конец: ")
            path, dist = g.dijkstra(start, end)
            if path:
                print(f"Путь: {' -> '.join(path)}")
                print(f"Длина: {dist}")
            else:
                print("Путь не найден")
                
        elif choice == '0':
            break
```


### Задание 3/4

```python
def task_4():
    g = Graph(directed=True)
    edges = [
        ('1', '2', 8), ('1', '3', 3),
        ('2', '4', 1), ('2', '5', 5),
        ('3', '5', 4), ('3', '6', 12), ('4', '7', 6),
        ('5', '6', 1), ('5', '4', 1),
        ('5', '7', 12), ('6', '7', 7)
    ]
    for v1, v2, w in edges:
        g.add_edge(v1, v2, w)
    print("Задание 4:")
    print(g)
    start, end = '2', '6'
    path, distance = g.dijkstra(start, end)
    print(f"Путь от {start} до {end}: {' -> '.join(path)}")
    print(f"Длина: {distance}")
    return path, distance

def task_5():    
    g = Graph(directed=False)
    edges = [
        ('1', '2', 6), ('1', '5', 2),
        ('2', '5', 1), ('2', '3', 9),
        ('2', '6', 5),
        ('2', '7', 3), ('3', '4', 12),
        ('3', '7', 8), ('4', '7', 3),
        ('4', '8', 4), ('5', '6', 7),
        ('6', '7', 4), ('7', '8', 16)
    ]
    for v1, v2, w in edges:
        g.add_edge(v1, v2, w
    print("Задание 5:")
    print(g)
    start, end = '5', '8'
    path, distance = g.dijkstra(start, end)
    print(f"Путь от {start} до {end}: {' -> '.join(path)}")
    print(f"Длина: {distance}")
    return g, path, distance

task_4()
task_5()
```

