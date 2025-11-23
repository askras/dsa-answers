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
    
    def add_vertex(self, vertex_name):
        if vertex_name not in self.vertices:
            self.vertices[vertex_name] = {}
    
    def add_edge(self, from_vertex, to_vertex, weight=1):
        self.add_vertex(from_vertex)
        self.add_vertex(to_vertex)
        
        self.vertices[from_vertex][to_vertex] = weight
        if not self.is_directed:
            self.vertices[to_vertex][from_vertex] = weight
    
    def remove_edge(self, vertex1, vertex2):
        if vertex1 in self.vertices and vertex2 in self.vertices[vertex1]:
            del self.vertices[vertex1][vertex2]
            if not self.is_directed:
                if vertex2 in self.vertices and vertex1 in self.vertices[vertex2]:
                    del self.vertices[vertex2][vertex1]
    
    def remove_vertex(self, vertex_name):
        if vertex_name in self.vertices:
            for other_vertex in list(self.vertices.keys()):
                if vertex_name in self.vertices[other_vertex]:
                    del self.vertices[other_vertex][vertex_name]
            del self.vertices[vertex_name]
    
    def get_vertices(self):
        return list(self.vertices.keys())
    
    def get_edges(self):
        edges = []
        for vertex in self.vertices:
            for neighbor, w in self.vertices[vertex].items():
                if self.is_directed:
                    edges.append((vertex, neighbor, w))
                else:
                    if vertex < neighbor:
                        edges.append((vertex, neighbor, w))
        return edges
    
    def bfs(self, start_vertex):
        if start_vertex not in self.vertices:
            return []
        
        visited = set()
        queue = deque([start_vertex])
        order = []
        
        while queue:
            current = queue.popleft()
            if current not in visited:
                visited.add(current)
                order.append(current)
                for neighbor in self.vertices[current]:
                    if neighbor not in visited:
                        queue.append(neighbor)
        
        return order
    
    def dfs(self, start_vertex):
        if start_vertex not in self.vertices:
            return []
        
        visited = set()
        stack = [start_vertex]
        order = []
        
        while stack:
            current = stack.pop()
            if current not in visited:
                visited.add(current)
                order.append(current)
                neighbors = list(self.vertices[current].keys())
                for neighbor in reversed(neighbors):
                    if neighbor not in visited:
                        stack.append(neighbor)
        
        return order
    
    def dijkstra(self, start, end):
        if start not in self.vertices or end not in self.vertices:
            return [], 999999
        
        dist = {}
        prev = {}
        for vertex in self.vertices:
            dist[vertex] = 999999
            prev[vertex] = None
        dist[start] = 0
        
        heap = [(0, start)]
        
        while heap:
            current_dist, current_vertex = heapq.heappop(heap)
            
            if current_dist > dist[current_vertex]:
                continue
            
            if current_vertex == end:
                break
            
            for neighbor, weight in self.vertices[current_vertex].items():
                new_dist = current_dist + weight
                if new_dist < dist[neighbor]:
                    dist[neighbor] = new_dist
                    prev[neighbor] = current_vertex
                    heapq.heappush(heap, (new_dist, neighbor))
        
        path = []
        current = end
        while current is not None:
            path.append(current)
            current = prev[current]
        
        path.reverse()
        
        if path[0] != start:
            return [], 999999
        
        return path, dist[end]
    
    def has_eulerian_cycle(self):
        if self.is_directed:
            for vertex in self.vertices:
                incoming = 0
                for other in self.vertices:
                    if vertex in self.vertices[other]:
                        incoming += 1
                outgoing = len(self.vertices[vertex])
                if incoming != outgoing:
                    return False
            return True
        else:
            for vertex in self.vertices:
                if len(self.vertices[vertex]) % 2 != 0:
                    return False
            return True
    
    def find_eulerian_cycle(self):
        if not self.has_eulerian_cycle():
            return []
        
        temp_graph = {}
        for vertex in self.vertices:
            temp_graph[vertex] = dict(self.vertices[vertex])
        
        stack = [next(iter(self.vertices.keys()))]
        cycle = []
        
        while stack:
            current = stack[-1]
            if temp_graph[current]:
                next_vertex = next(iter(temp_graph[current].keys()))
                stack.append(next_vertex)
                del temp_graph[current][next_vertex]
                if not self.is_directed:
                    del temp_graph[next_vertex][current]
            else:
                cycle.append(stack.pop())
        
        return cycle[::-1]
    
    def hamiltonian_cycle_util(self, path, position):
        if position == len(self.vertices):
            last = path[position - 1]
            first = path[0]
            if first in self.vertices[last]:
                return True
            return False
        
        for vertex in self.vertices:
            if vertex not in path:
                if position == 0 or (path[position - 1] in self.vertices and vertex in self.vertices[path[position - 1]]):
                    path[position] = vertex
                    if self.hamiltonian_cycle_util(path, position + 1):
                        return True
                    path[position] = None
        
        return False
    
    def find_hamiltonian_cycle(self):
        if len(self.vertices) == 0:
            return []
        
        path = [None] * len(self.vertices)
        path[0] = next(iter(self.vertices.keys()))
        
        if not self.hamiltonian_cycle_util(path, 1):
            return []
        
        return path + [path[0]]
    
    def __str__(self):
        result = "Граф:\n"
        for vertex in self.vertices:
            result += f"{vertex}: {self.vertices[vertex]}\n"
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
        print("9. Эйлеров цикл")
        print("10. Гамильтонов цикл")
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
                
        elif choice == '9':
            if g.has_eulerian_cycle():
                cycle = g.find_eulerian_cycle()
                print(f"Эйлеров цикл: {' -> '.join(cycle)}")
            else:
                print("Эйлеров цикл не существует")
                
        elif choice == '10':
            cycle = g.find_hamiltonian_cycle()
            if cycle:
                print(f"Гамильтонов цикл: {' -> '.join(cycle)}")
            else:
                print("Гамильтонов цикл не найден")
                
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
    
    if path:
        print(f"Путь от {start} до {end}: {' -> '.join(path)}")
        print(f"Длина: {distance}")
    else:
        print("Путь не найден")
    
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
        g.add_edge(v1, v2, w)
    
    print("Задание 5:")
    print(g)
    
    start, end = '5', '8'
    path, distance = g.dijkstra(start, end)
    
    if path:
        print(f"Путь от {start} до {end}: {' -> '.join(path)}")
        print(f"Длина: {distance}")
    else:
        print("Путь не найден")
    
    return g, path, distance

task_4()
task_5()
```

