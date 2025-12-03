# Лабораторная работа 7 Самойлов Даниил ИУ10-38
# Алгоритмы на графах
## Цель работы
Изучение основных алгоритмов на графах.
## Задачи лабораторной работы
1. Реализовать граф в виде класса, где каждая операция должна быть реализована как метод класса.
2. Реализовать приложение, для работы с графом, которое реализует инициализацию графа и организацию диалогового цикла с пользователем.
3. Реализовать алгоритм Дейкстры для поиска кратчайшего пути на графе между парами вершин.
## Словесная постановка задачи
1. Изучить теоретический материал по алгоритмам на графах.
2. Реализовать граф в виде класса и методы класса.
3. Сделать индивидуальыне задания.

# Задачи
### 1. Реализовать программу, выполняющую описанный набор операций на графах - граф и его методы в классе;
```python
  from collections import deque, defaultdict
import heapq
from typing import List, Tuple, Optional, Dict, Set

class Graph:
    def __init__(self, directed: bool = False, weighted: bool = False):
        self.graph: Dict[int, Dict[int, float]] = defaultdict(dict)
        self.directed = directed
        self.weighted = weighted
        self.vertices: Set[int] = set()
    
    def add_vertex(self, vertex: int) -> None:
        self.vertices.add(vertex)
        if vertex not in self.graph:
            self.graph[vertex] = {}
    
    def add_edge(self, u: int, v: int, weight: float = 1) -> None:
        self.add_vertex(u)
        self.add_vertex(v)
        
        self.graph[u][v] = weight
        
        if not self.directed:
            self.graph[v][u] = weight
    
    def remove_vertex(self, vertex: int) -> None:
        if vertex in self.vertices:
            self.vertices.remove(vertex)
            
        if vertex in self.graph:
            del self.graph[vertex]
        
        for u in list(self.graph.keys()):
            if vertex in self.graph[u]:
                del self.graph[u][vertex]
    
    def remove_edge(self, u: int, v: int) -> None:
        if u in self.graph and v in self.graph[u]:
            del self.graph[u][v]
            
        if not self.directed and v in self.graph and u in self.graph[v]:
            del self.graph[v][u]
    
    def get_vertices(self) -> List[int]:
        return sorted(list(self.vertices))
    
    def get_edges(self) -> List[Tuple[int, int, float]]:
        edges = []
        for u in self.graph:
            for v, weight in self.graph[u].items():
                edges.append((u, v, weight))
        return edges
    
    def get_neighbors(self, vertex: int) -> List[int]:
        if vertex in self.graph:
            return list(self.graph[vertex].keys())
        return []
    
    def get_degree(self, vertex: int) -> int:
        if vertex in self.graph:
            return len(self.graph[vertex])
        return 0
    
    def has_vertex(self, vertex: int) -> bool:
        return vertex in self.vertices
    
    def has_edge(self, u: int, v: int) -> bool:
        return u in self.graph and v in self.graph[u]
    
    def get_edge_weight(self, u: int, v: int) -> Optional[float]:
        if self.has_edge(u, v):
            return self.graph[u][v]
        return None
    
    def dfs(self, start: int) -> List[int]:

        if start not in self.vertices:
            return []
        
        visited = set()
        stack = [start]
        result = []
        
        while stack:
            vertex = stack.pop()
            if vertex not in visited:
                visited.add(vertex)
                result.append(vertex)
                neighbors = sorted(self.get_neighbors(vertex), reverse=True)
                stack.extend(neighbors)
        
        return result
    
    def bfs(self, start: int) -> List[int]:

        if start not in self.vertices:
            return []
        
        visited = set()
        queue = deque([start])
        result = []
        
        visited.add(start)
        
        while queue:
            vertex = queue.popleft()
            result.append(vertex)
            
            for neighbor in sorted(self.get_neighbors(vertex)):
                if neighbor not in visited:
                    visited.add(neighbor)
                    queue.append(neighbor)
        
        return result
    
    def is_connected(self) -> bool:
        if not self.vertices:
            return True
        
        start_vertex = next(iter(self.vertices))
        visited = set(self.dfs(start_vertex))
        
        return len(visited) == len(self.vertices)
    
    def eulerian_cycle(self) -> Optional[List[int]]:
        if self.directed:
            in_degree = defaultdict(int)
            out_degree = defaultdict(int)
            
            for u in self.graph:
                for v in self.graph[u]:
                    out_degree[u] += 1
                    in_degree[v] += 1
            
            for v in self.vertices:
                if in_degree[v] != out_degree[v]:
                    return None
        else:
            for v in self.vertices:
                if self.get_degree(v) % 2 != 0:
                    return None
        
        graph_copy = defaultdict(dict)
        for u in self.graph:
            for v, weight in self.graph[u].items():
                graph_copy[u][v] = weight
        
        def dfs_euler(u: int, path: List[int]) -> None:
            for v in list(graph_copy[u].keys()):
                if v in graph_copy[u]:
                    del graph_copy[u][v]
                    if not self.directed and u in graph_copy[v]:
                        del graph_copy[v][u]
                    dfs_euler(v, path)
            path.append(u)
        
        start_vertex = next(iter(self.vertices))
        path = []
        dfs_euler(start_vertex, path)
        
        return path[::-1] if path else None
    
    def hamiltonian_cycle(self) -> Optional[List[int]]:
        if not self.vertices:
            return None
        
        vertices_list = sorted(list(self.vertices))
        
        def is_valid(v: int, pos: int, path: List[int]) -> bool:
            if v in path:
                return False
            
            if pos == 0:
                return True
            
            if not self.has_edge(path[pos-1], v):
                return False
            
            return True
        
        def hamiltonian_util(path: List[int], pos: int) -> bool:
            if pos == len(vertices_list):
                return self.has_edge(path[-1], path[0])
            
            for v in vertices_list:
                if is_valid(v, pos, path):
                    path[pos] = v
                    
                    if hamiltonian_util(path, pos + 1):
                        return True
                    
                    path[pos] = -1
            
            return False
        
        path = [-1] * len(vertices_list)
        path[0] = vertices_list[0] 
        
        if hamiltonian_util(path, 1):
            return path + [path[0]]
        else:
            return None
    
    def dijkstra(self, start: int, end: int) -> Tuple[Optional[List[int]], float]:
        if start not in self.vertices or end not in self.vertices:
            return None, float('inf')
        
        distances = {vertex: float('inf') for vertex in self.vertices}
        previous = {vertex: None for vertex in self.vertices}
        distances[start] = 0
        
        pq = [(0, start)]
        
        while pq:
            current_distance, current_vertex = heapq.heappop(pq)
            
            if current_vertex == end:
                break
         
            if current_distance > distances[current_vertex]:
                continue
            
            for neighbor, weight in self.graph[current_vertex].items():
                distance = current_distance + weight

                if distance < distances[neighbor]:
                    distances[neighbor] = distance
                    previous[neighbor] = current_vertex
                    heapq.heappush(pq, (distance, neighbor))
        
        path = []
        current = end
        
        while current is not None:
            path.append(current)
            current = previous[current]
        
        path = path[::-1]
        
        if not path or path[0] != start:
            return None, float('inf')
        
        return path, distances[end]
    
    def topological_sort(self) -> Optional[List[int]]:
        if not self.directed:
            return None
        
        in_degree = defaultdict(int)
        for u in self.graph:
            for v in self.graph[u]:
                in_degree[v] += 1
        
        # Вершины с нулевой входящей степенью
        queue = deque([v for v in self.vertices if in_degree[v] == 0])
        result = []
        
        while queue:
            u = queue.popleft()
            result.append(u)
            
            for v in self.graph[u]:
                in_degree[v] -= 1
                if in_degree[v] == 0:
                    queue.append(v)
        
        if len(result) != len(self.vertices):
            return None  
        
        return result
    def display(self) -> None:
        print(f"Граф ({'ориентированный' if self.directed else 'неориентированный'}, "
              f"{'взвешенный' if self.weighted else 'невзвешенный'}):")
        print(f"Вершины: {sorted(list(self.vertices))}")
        print("Рёбра:")
        
        edges_displayed = set()
        for u in sorted(self.graph.keys()):
            neighbors = []
            for v, weight in sorted(self.graph[u].items()):
                if self.directed or (u, v) not in edges_displayed:
                    if self.weighted:
                        neighbors.append(f"{v}({weight})")
                    else:
                        neighbors.append(str(v))
                    if not self.directed:
                        edges_displayed.add((v, u))
            if neighbors:
                print(f"  {u} -> {', '.join(neighbors)}")

```


