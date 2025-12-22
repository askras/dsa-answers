# ОТЧЕТ ПО ЛАБОРАТОРНОЙ РАБОТЕ
## «Лабораторная работа №7. Алгоритмы на графах

### Цель работы:Изучение основных алгоритмов на графах.

### Работу выполнил: Цыганков Д.С 

## Задание 1 - Реализовать программу, выполняющую описанный набор операций на графах:
## Требования:

## 1. Граф должен быть реализован в виде класса;
## 2. Каждая операция должна быть реализована как метод класса.

```python 
from collections import deque, defaultdict
import heapq
import sys

class Graph:
    def __init__(self, directed=False):
        """
        Инициализация графа.
        directed: True - ориентированный, False - неориентированный (по умолчанию)
        """
        self.graph = defaultdict(list)
        self.weights = {}
        self.directed = directed
        self.vertices = set()
    
    def add_vertex(self, v):
        """Добавление вершины"""
        self.vertices.add(v)
        if v not in self.graph:
            self.graph[v] = []
    
    def add_edge(self, u, v, weight=1):
        """Добавление ребра между вершинами u и v с весом weight"""
        self.add_vertex(u)
        self.add_vertex(v)
        
        self.graph[u].append(v)
        self.weights[(u, v)] = weight
        
        if not self.directed:
            self.graph[v].append(u)
            self.weights[(v, u)] = weight
    
    def remove_edge(self, u, v):
        """Удаление ребра между вершинами u и v"""
        if u in self.graph and v in self.graph[u]:
            self.graph[u].remove(v)
            if (u, v) in self.weights:
                del self.weights[(u, v)]
            
            if not self.directed:
                self.graph[v].remove(u)
                if (v, u) in self.weights:
                    del self.weights[(v, u)]
    
    def get_vertices(self):
        """Возвращает список всех вершин"""
        return list(self.vertices)
    
    def get_edges(self):
        """Возвращает список всех рёбер в формате (u, v, weight)"""
        edges = []
        for u in self.graph:
            for v in self.graph[u]:
                weight = self.weights.get((u, v), 1)
                if not self.directed:
                    if (u, v) in self.weights and (v, u) not in [(x[0], x[1]) for x in edges]:
                        edges.append((u, v, weight))
                else:
                    edges.append((u, v, weight))
        return edges
    
    def get_neighbors(self, v):
        """Возвращает соседей вершины v"""
        return self.graph.get(v, [])
    
    def dfs(self, start, visited=None):
        """Обход в глубину (Depth-First Search)"""
        if visited is None:
            visited = set()
        
        result = []
        stack = [start]
        
        while stack:
            vertex = stack.pop()
            if vertex not in visited:
                visited.add(vertex)
                result.append(vertex)
                neighbors = self.get_neighbors(vertex)
                for neighbor in reversed(neighbors):
                    if neighbor not in visited:
                        stack.append(neighbor)
        
        return result
    
    def bfs(self, start):
        """Обход в ширину (Breadth-First Search)"""
        visited = set([start])
        result = []
        queue = deque([start])
        
        while queue:
            vertex = queue.popleft()
            result.append(vertex)
            
            for neighbor in self.get_neighbors(vertex):
                if neighbor not in visited:
                    visited.add(neighbor)
                    queue.append(neighbor)
        
        return result
    
    def _eulerian_cycle_util(self, v, circuit, edge_count):
        """Вспомогательная функция для поиска эйлерова цикла"""
        while self.graph[v]:
            u = self.graph[v].pop()
            if not self.directed:
                self.graph[u].remove(v)
            self._eulerian_cycle_util(u, circuit, edge_count)
        circuit.append(v)
    
    def eulerian_cycle(self):
        """Нахождение эйлерова цикла (если существует)"""
        temp_graph = defaultdict(list)
        for v in self.graph:
            temp_graph[v] = self.graph[v].copy()
        
        original_graph = self.graph
        self.graph = temp_graph
        
        # Проверяем условия существования эйлерова цикла
        if not self._has_eulerian_cycle():
            self.graph = original_graph
            return None
        
        # Находим вершину с нечетной степенью для начала (если есть)
        start_vertex = list(self.graph.keys())[0]
        for v in self.graph:
            if len(self.graph[v]) % 2 != 0:
                start_vertex = v
                break
        
        circuit = []
        self._eulerian_cycle_util(start_vertex, circuit, {})
        circuit.reverse()
        
        self.graph = original_graph
        return circuit if len(circuit) > 1 else None
    
    def _has_eulerian_cycle(self):
        """Проверка существования эйлерова цикла"""
        if self.directed:
            # Для ориентированного графа
            in_degree = defaultdict(int)
            out_degree = defaultdict(int)
            
            for u in self.graph:
                out_degree[u] = len(self.graph[u])
                for v in self.graph[u]:
                    in_degree[v] += 1
            
            for v in self.vertices:
                if in_degree[v] != out_degree[v]:
                    return False
        else:
            # Для неориентированного графа
            for v in self.graph:
                if len(self.graph[v]) % 2 != 0:
                    return False
        
        # Проверка связности
        if self.vertices:
            start = list(self.vertices)[0]
            visited = set(self.dfs(start))
            return len(visited) == len(self.vertices)
        
        return False
    
    def _hamiltonian_cycle_util(self, v, path, visited, cycles):
        """Вспомогательная функция для поиска гамильтоновых циклов"""
        path.append(v)
        visited.add(v)
        
        if len(path) == len(self.vertices):
            # Проверяем, есть ли ребро от последней к первой вершине
            if path[0] in self.graph[path[-1]]:
                cycles.append(path.copy() + [path[0]])
        else:
            for neighbor in self.graph[v]:
                if neighbor not in visited:
                    self._hamiltonian_cycle_util(neighbor, path, visited, cycles)
        
        # Backtracking
        path.pop()
        visited.remove(v)
    
    def hamiltonian_cycles(self):
        """Нахождение всех гамильтоновых циклов"""
        cycles = []
        
        if not self.vertices:
            return cycles
        
        for start in self.vertices:
            self._hamiltonian_cycle_util(start, [], set(), cycles)
        
        return cycles
    
    def dijkstra(self, start):
        """
        Алгоритм Дейкстры для нахождения кратчайших путей от вершины start.
        Возвращает словари distances и predecessors.
        """
        if start not in self.vertices:
            return {}, {}
        
        # Инициализация
        distances = {v: float('inf') for v in self.vertices}
        predecessors = {v: None for v in self.vertices}
        distances[start] = 0
        
        # Приоритетная очередь
        pq = [(0, start)]
        
        while pq:
            current_dist, current_vertex = heapq.heappop(pq)
            
            if current_dist > distances[current_vertex]:
                continue
            
            for neighbor in self.graph[current_vertex]:
                weight = self.weights.get((current_vertex, neighbor), 1)
                distance = current_dist + weight
                
                if distance < distances[neighbor]:
                    distances[neighbor] = distance
                    predecessors[neighbor] = current_vertex
                    heapq.heappush(pq, (distance, neighbor))
        
        return distances, predecessors
    
    def get_shortest_path(self, start, end):
        distances, predecessors = self.dijkstra(start)
        
        if distances[end] == float('inf'):
            return None, float('inf')
        
        # Восстановление пути
        path = []
        current = end
        
        while current is not None:
            path.append(current)
            current = predecessors[current]
        
        path.reverse()
        return path, distances[end]

```

## Задание 2 - Реализовать приложение, для работы с графом, которое реализует следующий набор действий:

## а) инициализация графа;
## б) организация диалогового цикла с пользователем;

```python 
def print_menu():
    """Вывод меню"""
    print("\n" + "="*50)
    print("МЕНЮ РАБОТЫ С ГРАФОМ")
    print("="*50)
    print("1. Инициализация графа")
    print("2. Добавить вершину")
    print("3. Добавить ребро")
    print("4. Удалить ребро")
    print("5. Показать граф")
    print("6. Обход в глубину (DFS)")
    print("7. Обход в ширину (BFS)")
    print("8. Найти эйлеров цикл")
    print("9. Найти гамильтоновы циклы")
    print("10. Найти кратчайшие пути (Дейкстра)")
    print("11. Найти кратчайший путь между двумя вершинами")
    print("0. Выход")
    print("="*50)

def initialize_graph():
    """Инициализация графа"""
    print("\n--- Инициализация графа ---")
    directed = input("Граф ориентированный? (y/n): ").lower() == 'y'
    graph = Graph(directed)
    
    vertices_input = input("Введите вершины через пробел (например: A B C D): ")
    vertices = vertices_input.split()
    for v in vertices:
        graph.add_vertex(v)
    
    print("\nДобавление рёбер (введите 'stop' для завершения):")
    while True:
        edge_input = input("Введите ребро в формате 'u v вес' (вес по умолчанию 1): ")
        if edge_input.lower() == 'stop':
            break
        
        parts = edge_input.split()
        if len(parts) >= 2:
            u = parts[0]
            v = parts[1]
            weight = float(parts[2]) if len(parts) >= 3 else 1
            graph.add_edge(u, v, weight)
            print(f"Добавлено ребро: {u} - {v} (вес: {weight})")
    
    return graph

def main()

    graph = None
    
    while True:
        print_menu()
        choice = input("\nВыберите действие (0-11): ")
        
        if choice == '0':
            print("Выход из программы.")
            break
        
        elif choice == '1':
            graph = initialize_graph()
            print("Граф успешно инициализирован!")
        
        elif choice == '2':
            if graph is None:
                print("Сначала инициализируйте граф!")
                continue
            
            v = input("Введите вершину для добавления: ")
            graph.add_vertex(v)
            print(f"Вершина '{v}' добавлена.")
        
        elif choice == '3':
            if graph is None:
                print("Сначала инициализируйте граф!")
                continue
            
            u = input("Введите первую вершину: ")
            v = input("Введите вторую вершину: ")
            weight_input = input("Введите вес ребра (по умолчанию 1): ")
            weight = float(weight_input) if weight_input else 1
            
            graph.add_edge(u, v, weight)
            print(f"Ребро '{u} - {v}' (вес: {weight}) добавлено.")
        
        elif choice == '4':
            if graph is None:
                print("Сначала инициализируйте граф!")
                continue
            
            u = input("Введите первую вершину: ")
            v = input("Введите вторую вершину: ")
            graph.remove_edge(u, v)
            print(f"Ребро '{u} - {v}' удалено.")
        
        elif choice == '5':
            if graph is None:
                print("Сначала инициализируйте граф!")
                continue
            
            print("\n" + "="*50)
            print("ТЕКУЩИЙ ГРАФ")
            print("="*50)
            print(f"Вершины: {graph.get_vertices()}")
            print("Рёбра:")
            edges = graph.get_edges()
            for edge in edges:
                print(f"  {edge[0]} -- {edge[1]} (вес: {edge[2]})")
            
            print("\nСписки смежности:")
            for vertex in graph.graph:
                neighbors = graph.get_neighbors(vertex)
                weights = [f"{n}({graph.weights.get((vertex, n), 1)})" for n in neighbors]
                print(f"  {vertex}: {weights}")
        
        elif choice == '6':
            if graph is None:
                print("Сначала инициализируйте граф!")
                continue
            
            start = input("Введите стартовую вершину для DFS: ")
            if start not in graph.get_vertices():
                print("Вершина не найдена в графе!")
                continue
            
            result = graph.dfs(start)
            print(f"DFS от вершины '{start}': {result}")
        
        elif choice == '7':
            if graph is None:
                print("Сначала инициализируйте граф!")
                continue
            
            start = input("Введите стартовую вершину для BFS: ")
            if start not in graph.get_vertices():
                print("Вершина не найдена в графе!")
                continue
            
            result = graph.bfs(start)
            print(f"BFS от вершины '{start}': {result}")
        
        elif choice == '8':
            if graph is None:
                print("Сначала инициализируйте граф!")
                continue
            
            cycle = graph.eulerian_cycle()
            if cycle:
                print(f"Эйлеров цикл найден: {' -> '.join(cycle)}")
            else:
                print("Эйлеров цикл не существует!")
        
        elif choice == '9':
            if graph is None:
                print("Сначала инициализируйте граф!")
                continue
            
            cycles = graph.hamiltonian_cycles()
            if cycles:
                print(f"Найдено {len(cycles)} гамильтоновых циклов:")
                for i, cycle in enumerate(cycles, 1):
                    print(f"  Цикл {i}: {' -> '.join(cycle)}")
            else:
                print("Гамильтоновы циклы не найдены!")
        
        elif choice == '10':
            if graph is None:
                print("Сначала инициализируйте граф!")
                continue
            
            start = input("Введите стартовую вершину для алгоритма Дейкстры: ")
            if start not in graph.get_vertices():
                print("Вершина не найдена в графе!")
                continue
            
            distances, predecessors = graph.dijkstra(start)
            
            print(f"\nКратчайшие расстояния от вершины '{start}':")
            print("-"*40)
            for vertex in sorted(distances.keys()):
                if distances[vertex] == float('inf'):
                    print(f"  {vertex}: недостижима")
                else:
                    path = []
                    current = vertex
                    while current is not None:
                        path.append(current)
                        current = predecessors[current]
                    path.reverse()
                    print(f"  {vertex}: {distances[vertex]} (путь: {' -> '.join(path)})")
        
        elif choice == '11':
            if graph is None:
                print("Сначала инициализируйте граф!")
                continue
            
            start = input("Введите начальную вершину: ")
            end = input("Введите конечную вершину: ")
            
            if start not in graph.get_vertices() or end not in graph.get_vertices():
                print("Одна или обе вершины не найдены в графе!")
                continue
            
            path, distance = graph.get_shortest_path(start, end)
            
            if path:
                print(f"Кратчайший путь от '{start}' до '{end}':")
                print(f"  Путь: {' -> '.join(path)}")
                print(f"  Длина: {distance}")
            else:
                print(f"Путь от '{start}' до '{end}' не существует!")
        
        else:
            print("Неверный выбор! Попробуйте снова.")

if __name__ == "__main__":
    main()
```

## Задание 3 - Реализовать индивидуальные задание.
## Ниже 

## Задание 4 - Найти кратчайший путь на графе между парами вершин ориентированного графа. Вершины 5 и 7 

```python 
import heapq

#граф 
graph = {
    1: [(2, 8), (5, 11)],
    2: [(3, 15), (5, 3), (6, 11)],
    3: [(4, 2), (6, 9), (7, 1)],
    4: [(7, 6)],
    5: [(6, 10)],
    6: [(7, 3)],
    7: []
}

def dijkstra(graph, start, target):
    distances = {v: float('inf') for v in graph}
    distances[start] = 0
    pq = [(0, start)]
    parent = {v: None for v in graph}

    while pq:
        dist, node = heapq.heappop(pq)

        if node == target:
            break

        for neighbor, weight in graph[node]:
            new_dist = dist + weight
            if new_dist < distances[neighbor]:
                distances[neighbor] = new_dist
                parent[neighbor] = node
                heapq.heappush(pq, (new_dist, neighbor))
                
    path = []
    cur = target
    while cur is not None:
        path.append(cur)
        cur = parent[cur]
    path.reverse()

    return distances[target], path


distance, path = dijkstra(graph, 5, 7)
print("Кратчайшее расстояние:", distance)
print("Путь:", path)
```

## Задание 5 - Реализовать алгоритм Дейкстры поиска кратчайшего пути на графе между парами вершин: 7 и 3 

```python 

import heapq

graph = {
    1: [(2, 1), (4, 6), (6, 11)],
    2: [(1, 1), (4, 5), (3, 5), (5, 13)],
    3: [(2, 5), (5, 1), (8, 19)],
    4: [(1, 6), (2, 5), (5, 3), (6, 2)],
    5: [(2, 13), (3, 1), (4, 3), (6, 8), (7, 15), (8, 12)],
    6: [(1, 11), (4, 2), (5, 8), (7, 3)],
    7: [(6, 3), (5, 15), (8, 1)],
    8: [(3, 19), (5, 12), (7, 1)]
}

def dijkstra(graph, start, target):
    distances = {v: float('inf') for v in graph}
    distances[start] = 0
    pq = [(0, start)]
    parent = {v: None for v in graph}

    while pq:
        dist, node = heapq.heappop(pq)

        if node == target:
            break

        for neighbor, weight in graph[node]:
            new_dist = dist + weight
            if new_dist < distances[neighbor]:
                distances[neighbor] = new_dist
                parent[neighbor] = node
                heapq.heappush(pq, (new_dist, neighbor))

    path = []
    cur = target
    while cur is not None:
        path.append(cur)
        cur = parent[cur]
    path.reverse()

    return distances[target], path


distance, path = dijkstra(graph, 7, 3)
print("Кратчайшее расстояние:", distance)
print("Путь:", path)

```
