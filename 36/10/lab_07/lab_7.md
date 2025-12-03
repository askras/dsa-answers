---
jupytext:
  formats: ipynb,md:myst
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.17.3
kernelspec:
  name: python3
  display_name: Python 3 (ipykernel)
  language: python
---

# Алгоритмы на графах


## Цель работы

Изучение основных алгоритмов на графах.

## Задания

### Задание 1

```{code-cell} ipython3
from collections import deque
import heapq

class Graph:
    def __init__(self, directed=False):
        self.vertices = {}
        self.directed = directed
    
    def add_vertex(self, vertex):
        if vertex not in self.vertices:
            self.vertices[vertex] = {}
    
    def add_edge(self, vertex1, vertex2, weight=1):
        self.add_vertex(vertex1)
        self.add_vertex(vertex2)
        
        self.vertices[vertex1][vertex2] = weight
        if not self.directed:
            self.vertices[vertex2][vertex1] = weight
    
    def remove_edge(self, vertex1, vertex2):
        if vertex1 in self.vertices and vertex2 in self.vertices[vertex1]:
            del self.vertices[vertex1][vertex2]
            if not self.directed and vertex2 in self.vertices and vertex1 in self.vertices[vertex2]:
                del self.vertices[vertex2][vertex1]
    
    def remove_vertex(self, vertex):
        if vertex in self.vertices:
            for neighbor in list(self.vertices[vertex].keys()):
                self.remove_edge(vertex, neighbor)
            del self.vertices[vertex]
    
    def get_vertices(self):
        return list(self.vertices.keys())
    
    def get_edges(self):
        edges = []
        for vertex in self.vertices:
            for neighbor, weight in self.vertices[vertex].items():
                if self.directed:
                    edges.append((vertex, neighbor, weight))
                else:
                    if vertex < neighbor:
                        edges.append((vertex, neighbor, weight))
        return edges
    
    def bfs(self, start_vertex):
        """Поиск в ширину"""
        if start_vertex not in self.vertices:
            return []
        
        visited = set()
        queue = deque([start_vertex])
        result = []
        
        while queue:
            vertex = queue.popleft()
            if vertex not in visited:
                visited.add(vertex)
                result.append(vertex)
                for neighbor in self.vertices[vertex]:
                    if neighbor not in visited:
                        queue.append(neighbor)
        
        return result
    
    def dfs(self, start_vertex):
        """Поиск в глубину (итеративный)"""
        if start_vertex not in self.vertices:
            return []
        
        visited = set()
        stack = [start_vertex]
        result = []
        
        while stack:
            vertex = stack.pop()
            if vertex not in visited:
                visited.add(vertex)
                result.append(vertex)
                for neighbor in reversed(list(self.vertices[vertex].keys())):
                    if neighbor not in visited:
                        stack.append(neighbor)
        
        return result
    
    def dijkstra(self, start_vertex, end_vertex):
        """Алгоритм Дейкстры для поиска кратчайшего пути"""
        if start_vertex not in self.vertices or end_vertex not in self.vertices:
            return [], float('inf')
        
        distances = {vertex: float('inf') for vertex in self.vertices}
        previous = {vertex: None for vertex in self.vertices}
        distances[start_vertex] = 0
        
        pq = [(0, start_vertex)]
        
        while pq:
            current_distance, current_vertex = heapq.heappop(pq)
            
            if current_distance > distances[current_vertex]:
                continue
            
            if current_vertex == end_vertex:
                break
            
            for neighbor, weight in self.vertices[current_vertex].items():
                distance = current_distance + weight
                if distance < distances[neighbor]:
                    distances[neighbor] = distance
                    previous[neighbor] = current_vertex
                    heapq.heappush(pq, (distance, neighbor))
        
        path = []
        current = end_vertex
        while current is not None:
            path.append(current)
            current = previous[current]
        
        path.reverse()
        
        if path[0] != start_vertex:
            return [], float('inf')
        
        return path, distances[end_vertex]
    
    def has_eulerian_cycle(self):
        """Проверка наличия эйлерова цикла"""
        if self.directed:
            for vertex in self.vertices:
                in_degree = sum(1 for v in self.vertices if vertex in self.vertices[v])
                out_degree = len(self.vertices[vertex])
                if in_degree != out_degree:
                    return False
            return True
        else:
            for vertex in self.vertices:
                if len(self.vertices[vertex]) % 2 != 0:
                    return False
            return True
    
    def find_eulerian_cycle(self):
        """Поиск эйлерова цикла (алгоритм Флёри)"""
        if not self.has_eulerian_cycle():
            return []
        
        graph_copy = {v: dict(neighbors) for v, neighbors in self.vertices.items()}
        
        start_vertex = next(iter(self.vertices.keys()))
        stack = [start_vertex]
        cycle = []
        
        while stack:
            current_vertex = stack[-1]
            
            if graph_copy[current_vertex]:
                next_vertex = next(iter(graph_copy[current_vertex].keys()))
                stack.append(next_vertex)
                del graph_copy[current_vertex][next_vertex]
                if not self.directed:
                    del graph_copy[next_vertex][current_vertex]
            else:
                cycle.append(stack.pop())
        
        return cycle[::-1]
    
    def hamiltonian_cycle_util(self, path, pos):
        """Вспомогательная функция для поиска гамильтонова цикла"""
        if pos == len(self.vertices):
            last_vertex = path[pos - 1]
            first_vertex = path[0]
            if first_vertex in self.vertices[last_vertex]:
                return True
            else:
                return False
        
        for v in self.vertices:
            if v not in path:
                if pos == 0 or path[pos - 1] in self.vertices and v in self.vertices[path[pos - 1]]:
                    path[pos] = v
                    if self.hamiltonian_cycle_util(path, pos + 1):
                        return True
                    path[pos] = -1
        
        return False
    
    def find_hamiltonian_cycle(self):
        """Поиск гамильтонова цикла"""
        if len(self.vertices) == 0:
            return []
        
        path = [-1] * len(self.vertices)
        path[0] = next(iter(self.vertices.keys()))
        
        if not self.hamiltonian_cycle_util(path, 1):
            return []
        
        return path
    
    def __str__(self):
        result = "Граф:\n"
        for vertex in self.vertices:
            result += f"{vertex}: {self.vertices[vertex]}\n"
        return result
```

### Задание 2

```{code-cell} ipython3
def main():
    """Диалоговое приложение для работы с графом"""
    graph = Graph(directed=False)
    
    while True:
        print("\n=== МЕНЮ РАБОТЫ С ГРАФОМ ===")
        print("1. Добавить вершину")
        print("2. Добавить ребро")
        print("3. Удалить вершину")
        print("4. Удалить ребро")
        print("5. Показать граф")
        print("6. Обход в ширину (BFS)")
        print("7. Обход в глубину (DFS)")
        print("8. Алгоритм Дейкстры")
        print("9. Поиск эйлерова цикла")
        print("10. Поиск гамильтонова цикла")
        print("0. Выход")
        
        choice = input("\nВыберите действие: ").strip()
        
        if choice == '1':
            vertex = input("Введите название вершины: ").strip()
            graph.add_vertex(vertex)
            print(f"Вершина '{vertex}' добавлена")
        
        elif choice == '2':
            v1 = input("Введите первую вершину: ").strip()
            v2 = input("Введите вторую вершину: ").strip()
            try:
                weight = float(input("Введите вес ребра (по умолчанию 1): ").strip() or 1)
            except ValueError:
                weight = 1
            graph.add_edge(v1, v2, weight)
            print(f"Ребро '{v1}' - '{v2}' с весом {weight} добавлено")
        
        elif choice == '3':
            vertex = input("Введите вершину для удаления: ").strip()
            graph.remove_vertex(vertex)
            print(f"Вершина '{vertex}' удалена")
        
        elif choice == '4':
            v1 = input("Введите первую вершину: ").strip()
            v2 = input("Введите вторую вершину: ").strip()
            graph.remove_edge(v1, v2)
            print(f"Ребро '{v1}' - '{v2}' удалено")
        
        elif choice == '5':
            print("\nТекущий граф:")
            print(graph)
            print("Вершины:", graph.get_vertices())
            print("Рёбра:", graph.get_edges())
        
        elif choice == '6':
            start = input("Введите начальную вершину для BFS: ").strip()
            result = graph.bfs(start)
            print(f"BFS обход: {result}")
        
        elif choice == '7':
            start = input("Введите начальную вершину для DFS: ").strip()
            result = graph.dfs(start)
            print(f"DFS обход: {result}")
        
        elif choice == '8':
            start = input("Введите начальную вершину: ").strip()
            end = input("Введите конечную вершину: ").strip()
            path, distance = graph.dijkstra(start, end)
            if path:
                print(f"Кратчайший путь: {' -> '.join(path)}")
                print(f"Длина пути: {distance}")
            else:
                print("Путь не найден")
        
        elif choice == '9':
            if graph.has_eulerian_cycle():
                cycle = graph.find_eulerian_cycle()
                print(f"Эйлеров цикл: {' -> '.join(cycle)}")
            else:
                print("Эйлеров цикл не существует")
        
        elif choice == '10':
            cycle = graph.find_hamiltonian_cycle()
            if cycle:
                print(f"Гамильтонов цикл: {' -> '.join(cycle)}")
            else:
                print("Гамильтонов цикл не найден")
        
        elif choice == '0':
            print("Выход из программы")
            break
        
        else:
            print("Неверный выбор. Попробуйте снова.")


if __name__ == "__main__":
    print("=== ДЕМОНСТРАЦИЯ РАБОТЫ ГРАФА ===")
    
    g = Graph(directed=True)
    
    edges = [
        ('1', '2', 4), ('1', '3', 2),
        ('2', '3', 1), ('2', '4', 5),
        ('3', '2', 1), ('3', '4', 8), ('3', '5', 10),
        ('4', '5', 2), ('4', '6', 6),
        ('5', '6', 2)
    ]
    
    for v1, v2, w in edges:
        g.add_edge(v1, v2, w)
    
    print("Граф для задания 4:")
    print(g)
    
    path, distance = g.dijkstra('1', '6')
    print(f"Кратчайший путь от 1 до 6: {' -> '.join(path)}")
    print(f"Длина пути: {distance}")
    
    print("\n=== ЗАПУСК ДИАЛОГОВОГО ПРИЛОЖЕНИЯ ===")
    main()
```

### Задание 3

### Задание 4

```{code-cell} ipython3
def task_4():
    g = Graph(directed=True)
    
    edges = [
        ('1', '2', 4), ('1', '3', 2),
        ('2', '3', 1), ('2', '4', 5),
        ('3', '2', 1), ('3', '4', 8), ('3', '5', 10),
        ('4', '5', 2), ('4', '6', 6),
        ('5', '6', 2)
    ]
    
    for v1, v2, w in edges:
        g.add_edge(v1, v2, w)
    
    print("Граф для задания 4:")
    print(g)
    
    start, end = '1', '6'
    path, distance = g.dijkstra(start, end)
    
    print(f"\nКратчайший путь от {start} до {end}:")
    if path:
        print(f"Путь: {' -> '.join(path)}")
        print(f"Длина пути: {distance}")
        
        print("\nВсе рёбра графа:")
        for edge in g.get_edges():
            print(f"{edge[0]} -> {edge[1]} (вес: {edge[2]})")
    else:
        print("Путь не найден")
    
    return path, distance

print(task_4())
```

### Задание 5

```{code-cell} ipython3
def task_5():    
    g = Graph(directed=False)
    
    edges = [
        ('1', '2', 2), ('1', '3', 4),
        ('2', '3', 1), ('2', '4', 7),
        ('3', '5', 3),
        ('4', '5', 2), ('4', '6', 1),
        ('5', '6', 5), ('5', '7', 6),
        ('6', '7', 3), ('6', '8', 2),
        ('7', '8', 4)
    ]
    
    for v1, v2, w in edges:
        g.add_edge(v1, v2, w)
    
    print("Граф для задания 5:")
    print(g)
    
    start, end = '5', '8'
    path, distance = g.dijkstra(start, end)
    
    print(f"\nКратчайший путь от {start} до {end}:")
    if path:
        print(f"Путь: {' -> '.join(path)}")
        print(f"Длина пути: {distance}")
        
        print("\nДетали пути:")
        total_weight = 0
        for i in range(len(path) - 1):
            weight = g.vertices[path[i]][path[i + 1]]
            total_weight += weight
            print(f"{path[i]} -> {path[i + 1]} (вес: {weight})")
        print(f"Общий вес: {total_weight}")
    else:
        print("Путь не найден")
    
    return g, path, distance

print(task_5())
```

### Задание 6

```{code-cell} ipython3
def task_6():
    g, path, distance = task_5()
    
    print("\n=== ПРОВЕРКА АЛГОРИТМА ДЕЙКСТРЫ ===")
    
    start, end = '5', '8'
    
    print(f"Поиск кратчайшего пути от {start} до {end} с помощью алгоритма Дейкстры:")
    
    print("\nАнализ альтернативных путей:")
    
    path1 = ['5', '4', '6', '8']
    weight1 = g.vertices['5']['4'] + g.vertices['4']['6'] + g.vertices['6']['8']
    print(f"Путь 1: {' -> '.join(path1)} = {weight1}")
    
    path2 = ['5', '6', '8']
    weight2 = g.vertices['5']['6'] + g.vertices['6']['8']
    print(f"Путь 2: {' -> '.join(path2)} = {weight2}")
    
    path3 = ['5', '3', '2', '1']
    print(f"Путь 3: {' -> '.join(path3)} = ... (не ведет к целевой вершине)")
    
    print(f"\nОптимальный путь: {' -> '.join(path)} с весом {distance}")
    
    print(f"\nBFS обход от вершины 5: {g.bfs('5')}")
    print(f"DFS обход от вершины 5: {g.dfs('5')}")

print(task_6())
```

```{code-cell} ipython3

```
