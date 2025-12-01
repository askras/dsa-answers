#### Задание 1


```python
from collections import deque, defaultdict
import heapq

class Graph:
    def __init__(self, directed=False):
        self.graph = defaultdict(dict)
        self.directed = directed
        self.vertices = set()

    def add_vertex(self, vertex):
        self.vertices.add(vertex)
        if vertex not in self.graph:
            self.graph[vertex] = {}

    def add_edge(self, u, v, weight=1):
        self.add_vertex(u)
        self.add_vertex(v)
        self.graph[u][v] = weight
        if not self.directed:
            self.graph[v][u] = weight

    def remove_vertex(self, vertex):
        if vertex in self.graph:
            for u in list(self.graph.keys()):
                if vertex in self.graph[u]:
                    del self.graph[u][vertex]
            del self.graph[vertex]
            self.vertices.discard(vertex)

    def remove_edge(self, u, v):
        if u in self.graph and v in self.graph[u]:
            del self.graph[u][v]
        if not self.directed and v in self.graph and u in self.graph[v]:
            del self.graph[v][u]

    def get_vertices(self):
        return list(self.vertices)

    def get_edges(self):
        edges = []
        for u in self.graph:
            for v, weight in self.graph[u].items():
                if self.directed or u <= v:
                    edges.append((u, v, weight))
        return edges

    def get_neighbors(self, vertex):
        if vertex in self.graph:
            return list(self.graph[vertex].keys())
        return []

    def get_degree(self, vertex):
        if vertex not in self.graph:
            return 0
        degree = len(self.graph[vertex])
        if self.directed:
            in_degree = sum(1 for u in self.graph if vertex in self.graph[u])
            return (in_degree, degree)
        return degree

    def has_vertex(self, vertex):
        return vertex in self.graph

    def has_edge(self, u, v):
        return u in self.graph and v in self.graph[u]

    def get_edge_weight(self, u, v):
        if self.has_edge(u, v):
            return self.graph[u][v]
        return None

    def bfs(self, start):
        if start not in self.graph:
            return []
        visited = set()
        queue = deque([start])
        result = []
        while queue:
            vertex = queue.popleft()
            if vertex not in visited:
                visited.add(vertex)
                result.append(vertex)
                for neighbor in self.graph[vertex]:
                    if neighbor not in visited:
                        queue.append(neighbor)
        return result

    def dfs(self, start):
        if start not in self.graph:
            return []
        visited = set()
        stack = [start]
        result = []
        while stack:
            vertex = stack.pop()
            if vertex not in visited:
                visited.add(vertex)
                result.append(vertex)
                for neighbor in reversed(list(self.graph[vertex].keys())):
                    if neighbor not in visited:
                        stack.append(neighbor)
        return result

    def dijkstra(self, start):
        if start not in self.graph:
            return {}
        distances = {vertex: float('infinity') for vertex in self.vertices}
        distances[start] = 0
        priority_queue = [(0, start)]
        while priority_queue:
            current_distance, current_vertex = heapq.heappop(priority_queue)
            if current_distance > distances[current_vertex]:
                continue
            for neighbor, weight in self.graph[current_vertex].items():
                distance = current_distance + weight
                if distance < distances[neighbor]:
                    distances[neighbor] = distance
                    heapq.heappush(priority_queue, (distance, neighbor))
        return distances

    def is_connected(self):
        if self.directed:
            raise NotImplementedError("Для ориентированных графов используйте is_strongly_connected()")
        if not self.vertices:
            return True
        start_vertex = next(iter(self.vertices))
        visited = set(self.bfs(start_vertex))
        return len(visited) == len(self.vertices)

    def is_strongly_connected(self):
        if not self.directed:
            return self.is_connected()
        if not self.vertices:
            return True
        for vertex in self.vertices:
            visited = set(self.bfs(vertex))
            if len(visited) != len(self.vertices):
                return False
        return True

    def topological_sort(self):
        if not self.directed:
            raise ValueError("Топологическая сортировка применима только к ориентированным графам")
        in_degree = {vertex: 0 for vertex in self.vertices}
        for u in self.graph:
            for v in self.graph[u]:
                in_degree[v] += 1
        queue = deque([v for v in self.vertices if in_degree[v] == 0])
        result = []
        while queue:
            vertex = queue.popleft()
            result.append(vertex)
            for neighbor in self.graph[vertex]:
                in_degree[neighbor] -= 1
                if in_degree[neighbor] == 0:
                    queue.append(neighbor)
        if len(result) != len(self.vertices):
            raise ValueError("Граф содержит циклы, топологическая сортировка невозможна")
        return result

    def get_adjacency_matrix(self):
        vertices = sorted(self.vertices)
        n = len(vertices)
        vertex_index = {vertex: i for i, vertex in enumerate(vertices)}
        matrix = [[0] * n for _ in range(n)]
        for u in self.graph:
            for v, weight in self.graph[u].items():
                i, j = vertex_index[u], vertex_index[v]
                matrix[i][j] = weight
        return matrix, vertices

    def find_shortest_path(self, start, end):
        distances = {vertex: float('infinity') for vertex in self.vertices}
        distances[start] = 0
        previous = {vertex: None for vertex in self.vertices}
        priority_queue = [(0, start)]
        while priority_queue:
            current_distance, current_vertex = heapq.heappop(priority_queue)
            if current_distance > distances[current_vertex]:
                continue
            if current_vertex == end:
                break
            for neighbor, weight in self.graph[current_vertex].items():
                distance = current_distance + weight
                if distance < distances[neighbor]:
                    distances[neighbor] = distance
                    previous[neighbor] = current_vertex
                    heapq.heappush(priority_queue, (distance, neighbor))
        if distances[end] == float('infinity'):
            return None, None
        path = []
        current = end
        while current is not None:
            path.append(current)
            current = previous[current]
        path.reverse()
        return path, distances[end]

    def get_connected_components(self):
        if self.directed:
            raise NotImplementedError("Для ориентированных графов используйте get_strongly_connected_components()")
        visited = set()
        components = []
        for vertex in self.vertices:
            if vertex not in visited:
                component = self.bfs(vertex)
                components.append(component)
                visited.update(component)
        return components

    def get_minimum_spanning_tree(self):
        if self.directed:
            raise ValueError("Минимальное остовное дерево определено только для неориентированных графов")
        if not self.is_connected():
            raise ValueError("Граф должен быть связным")
        start_vertex = next(iter(self.vertices))
        visited = {start_vertex}
        mst_edges = []
        edges_heap = []
        for neighbor, weight in self.graph[start_vertex].items():
            heapq.heappush(edges_heap, (weight, start_vertex, neighbor))
        while edges_heap and len(visited) < len(self.vertices):
            weight, u, v = heapq.heappop(edges_heap)
            if v not in visited:
                visited.add(v)
                mst_edges.append((u, v, weight))
                for neighbor, w in self.graph[v].items():
                    if neighbor not in visited:
                        heapq.heappush(edges_heap, (w, v, neighbor))
        mst_graph = Graph(directed=False)
        for u, v, weight in mst_edges:
            mst_graph.add_edge(u, v, weight)
        return mst_graph

    def has_eulerian_cycle(self):
        if self.directed:
            raise NotImplementedError("Для ориентированных графов проверка эйлерова цикла сложнее")
        for vertex in self.vertices:
            if len(self.graph[vertex]) % 2 != 0:
                return False
        return self.is_connected()

    def find_eulerian_cycle(self):
        if not self.has_eulerian_cycle():
            return None
        graph_copy = {u: dict(neighbors) for u, neighbors in self.graph.items()}
        def dfs_count(v, visited):
            count = 1
            visited.add(v)
            for neighbor in graph_copy[v]:
                if neighbor not in visited:
                    count += dfs_count(neighbor, visited)
            return count
        def is_valid_next_edge(u, v):
            if len(graph_copy[u]) == 1:
                return True
            weight = graph_copy[u][v]
            del graph_copy[u][v]
            del graph_copy[v][u]
            visited = set()
            count1 = dfs_count(u, visited)
            graph_copy[u][v] = weight
            graph_copy[v][u] = weight
            return count1 == 0
        current = next(iter(self.vertices))
        stack = [current]
        cycle = []
        while stack:
            current = stack[-1]
            if graph_copy[current]:
                for neighbor in graph_copy[current]:
                    if not is_valid_next_edge(current, neighbor):
                        continue
                    del graph_copy[current][neighbor]
                    del graph_copy[neighbor][current]
                    stack.append(neighbor)
                    break
                else:
                    neighbor = next(iter(graph_copy[current]))
                    del graph_copy[current][neighbor]
                    del graph_copy[neighbor][current]
                    stack.append(neighbor)
            else:
                cycle.append(stack.pop())
        return cycle[::-1]

    def find_hamiltonian_cycle(self):
        if len(self.vertices) < 3:
            return None
        path = [-1] * len(self.vertices)
        visited = {vertex: False for vertex in self.vertices}
        start_vertex = next(iter(self.vertices))
        path[0] = start_vertex
        visited[start_vertex] = True
        def hamiltonian_cycle_util(pos):
            if pos == len(self.vertices):
                if self.has_edge(path[pos-1], path[0]):
                    return True
                return False
            for v in self.vertices:
                if not visited[v] and self.has_edge(path[pos-1], v):
                    path[pos] = v
                    visited[v] = True
                    if hamiltonian_cycle_util(pos+1):
                        return True
                    visited[v] = False
                    path[pos] = -1
            return False
        if not hamiltonian_cycle_util(1):
            return None
        return path + [path[0]]

    def __str__(self):
        result = []
        result.append(f"Graph (directed: {self.directed})")
        result.append("Vertices: " + ", ".join(map(str, sorted(self.vertices))))
        result.append("Edges:")
        for u, v, weight in self.get_edges():
            result.append(f"  {u} -> {v} (weight: {weight})")
        return "\n".join(result)

def main():
    print("Пример использования класса Graph")
    print("=" * 50)
    
    g = Graph(directed=False)
    
    g.add_edge('A', 'B', 4)
    g.add_edge('A', 'C', 2)
    g.add_edge('B', 'C', 1)
    g.add_edge('B', 'D', 5)
    g.add_edge('C', 'D', 8)
    g.add_edge('C', 'E', 10)
    g.add_edge('D', 'E', 2)
    g.add_edge('D', 'F', 6)
    g.add_edge('E', 'F', 3)
    
    print(g)
    print("\nОбход в ширину (BFS) из вершины A:")
    print(g.bfs('A'))
    
    print("\nОбход в глубину (DFS) из вершины A:")
    print(g.dfs('A'))
    
    print("\nКратчайшие расстояния от A (Дейкстра):")
    distances = g.dijkstra('A')
    for vertex, distance in distances.items():
        print(f"  {vertex}: {distance}")
    
    print("\nКратчайший путь от A до F:")
    path, distance = g.find_shortest_path('A', 'F')
    print(f"  Путь: {' -> '.join(path)}")
    print(f"  Расстояние: {distance}")
    
    print("\nКомпоненты связности:")
    components = g.get_connected_components()
    for i, comp in enumerate(components, 1):
        print(f"  Компонента {i}: {comp}")
    
    print("\nМинимальное остовное дерево:")
    mst = g.get_minimum_spanning_tree()
    print(mst)
    
    print("\nГраф связен?", g.is_connected())
    
    directed_g = Graph(directed=True)
    directed_g.add_edge('A', 'B')
    directed_g.add_edge('A', 'C')
    directed_g.add_edge('B', 'D')
    directed_g.add_edge('C', 'D')
    
    print("\nОриентированный граф:")
    print(directed_g)
    
    print("\nТопологическая сортировка:")
    try:
        print(directed_g.topological_sort())
    except ValueError as e:
        print(f"  Ошибка: {e}")

if __name__ == "__main__":
    main()
```

    Пример использования класса Graph
    ==================================================
    Graph (directed: False)
    Vertices: A, B, C, D, E, F
    Edges:
      A -> B (weight: 4)
      A -> C (weight: 2)
      B -> C (weight: 1)
      B -> D (weight: 5)
      C -> D (weight: 8)
      C -> E (weight: 10)
      D -> E (weight: 2)
      D -> F (weight: 6)
      E -> F (weight: 3)
    
    Обход в ширину (BFS) из вершины A:
    ['A', 'B', 'C', 'D', 'E', 'F']
    
    Обход в глубину (DFS) из вершины A:
    ['A', 'B', 'C', 'D', 'E', 'F']
    
    Кратчайшие расстояния от A (Дейкстра):
      C: 2
      E: 10
      D: 8
      B: 3
      A: 0
      F: 13
    
    Кратчайший путь от A до F:
      Путь: A -> C -> B -> D -> E -> F
      Расстояние: 13
    
    Компоненты связности:
      Компонента 1: ['C', 'A', 'B', 'D', 'E', 'F']
    
    Минимальное остовное дерево:
    Graph (directed: False)
    Vertices: A, B, C, D, E, F
    Edges:
      B -> C (weight: 1)
      B -> D (weight: 5)
      A -> C (weight: 2)
      D -> E (weight: 2)
      E -> F (weight: 3)
    
    Граф связен? True
    
    Ориентированный граф:
    Graph (directed: True)
    Vertices: A, B, C, D
    Edges:
      A -> B (weight: 1)
      A -> C (weight: 1)
      B -> D (weight: 1)
      C -> D (weight: 1)
    
    Топологическая сортировка:
    ['A', 'B', 'C', 'D']


#### Задание 2


```python
from collections import deque, defaultdict
import heapq

class Graph:
    def __init__(self, directed=False):
        self.graph = defaultdict(dict)
        self.directed = directed
        self.vertices = set()

    def add_vertex(self, vertex):
        self.vertices.add(vertex)
        if vertex not in self.graph:
            self.graph[vertex] = {}

    def add_edge(self, u, v, weight=1):
        self.add_vertex(u)
        self.add_vertex(v)
        self.graph[u][v] = weight
        if not self.directed:
            self.graph[v][u] = weight

    def remove_vertex(self, vertex):
        if vertex in self.graph:
            for u in list(self.graph.keys()):
                if vertex in self.graph[u]:
                    del self.graph[u][vertex]
            del self.graph[vertex]
            self.vertices.discard(vertex)

    def remove_edge(self, u, v):
        if u in self.graph and v in self.graph[u]:
            del self.graph[u][v]
        if not self.directed and v in self.graph and u in self.graph[v]:
            del self.graph[v][u]

    def get_vertices(self):
        return list(self.vertices)

    def get_edges(self):
        edges = []
        for u in self.graph:
            for v, weight in self.graph[u].items():
                if self.directed or u <= v:
                    edges.append((u, v, weight))
        return edges

    def get_neighbors(self, vertex):
        if vertex in self.graph:
            return list(self.graph[vertex].keys())
        return []

    def get_degree(self, vertex):
        if vertex not in self.graph:
            return 0
        degree = len(self.graph[vertex])
        if self.directed:
            in_degree = sum(1 for u in self.graph if vertex in self.graph[u])
            return (in_degree, degree)
        return degree

    def has_vertex(self, vertex):
        return vertex in self.graph

    def has_edge(self, u, v):
        return u in self.graph and v in self.graph[u]

    def get_edge_weight(self, u, v):
        if self.has_edge(u, v):
            return self.graph[u][v]
        return None

    def bfs(self, start):
        if start not in self.graph:
            return []
        visited = set()
        queue = deque([start])
        result = []
        while queue:
            vertex = queue.popleft()
            if vertex not in visited:
                visited.add(vertex)
                result.append(vertex)
                for neighbor in self.graph[vertex]:
                    if neighbor not in visited:
                        queue.append(neighbor)
        return result

    def dfs(self, start):
        if start not in self.graph:
            return []
        visited = set()
        stack = [start]
        result = []
        while stack:
            vertex = stack.pop()
            if vertex not in visited:
                visited.add(vertex)
                result.append(vertex)
                for neighbor in reversed(list(self.graph[vertex].keys())):
                    if neighbor not in visited:
                        stack.append(neighbor)
        return result

    def dijkstra(self, start):
        if start not in self.graph:
            return {}
        distances = {vertex: float('infinity') for vertex in self.vertices}
        distances[start] = 0
        priority_queue = [(0, start)]
        while priority_queue:
            current_distance, current_vertex = heapq.heappop(priority_queue)
            if current_distance > distances[current_vertex]:
                continue
            for neighbor, weight in self.graph[current_vertex].items():
                distance = current_distance + weight
                if distance < distances[neighbor]:
                    distances[neighbor] = distance
                    heapq.heappush(priority_queue, (distance, neighbor))
        return distances

    def is_connected(self):
        if self.directed:
            raise NotImplementedError("Для ориентированных графов используйте is_strongly_connected()")
        if not self.vertices:
            return True
        start_vertex = next(iter(self.vertices))
        visited = set(self.bfs(start_vertex))
        return len(visited) == len(self.vertices)

    def has_eulerian_cycle(self):
        if self.directed:
            raise NotImplementedError("Для ориентированных графов проверка эйлерова цикла сложнее")
        for vertex in self.vertices:
            if len(self.graph[vertex]) % 2 != 0:
                return False
        return self.is_connected()

    def find_eulerian_cycle(self):
        if not self.has_eulerian_cycle():
            return None
        graph_copy = {u: dict(neighbors) for u, neighbors in self.graph.items()}

        def dfs_count(v, visited):
            count = 1
            visited.add(v)
            for neighbor in graph_copy[v]:
                if neighbor not in visited:
                    count += dfs_count(neighbor, visited)
            return count

        def is_valid_next_edge(u, v):
            if len(graph_copy[u]) == 1:
                return True
            weight = graph_copy[u][v]
            del graph_copy[u][v]
            del graph_copy[v][u]
            visited = set()
            count1 = dfs_count(u, visited)
            graph_copy[u][v] = weight
            graph_copy[v][u] = weight
            return count1 > 0

        current = next(iter(self.vertices))
        stack = [current]
        cycle = []
        while stack:
            current = stack[-1]
            if graph_copy[current]:
                for neighbor in graph_copy[current]:
                    if not is_valid_next_edge(current, neighbor):
                        continue
                    del graph_copy[current][neighbor]
                    del graph_copy[neighbor][current]
                    stack.append(neighbor)
                    break
                else:
                    neighbor = next(iter(graph_copy[current]))
                    del graph_copy[current][neighbor]
                    del graph_copy[neighbor][current]
                    stack.append(neighbor)
            else:
                cycle.append(stack.pop())
        return cycle[::-1]

    def _hamiltonian_cycle_util(self, path, pos, visited):
        if pos == len(self.vertices):
            if self.has_edge(path[pos-1], path[0]):
                return True
            return False
        for v in self.vertices:
            if not visited[v] and self.has_edge(path[pos-1], v):
                path[pos] = v
                visited[v] = True
                if self._hamiltonian_cycle_util(path, pos+1, visited):
                    return True
                visited[v] = False
                path[pos] = -1
        return False

    def find_hamiltonian_cycle(self):
        if len(self.vertices) < 3:
            return None
        path = [-1] * len(self.vertices)
        visited = {vertex: False for vertex in self.vertices}
        start_vertex = next(iter(self.vertices))
        path[0] = start_vertex
        visited[start_vertex] = True
        if not self._hamiltonian_cycle_util(path, 1, visited):
            return None
        return path + [path[0]]

    def __str__(self):
        result = []
        result.append(f"Graph (directed: {self.directed})")
        result.append("Vertices: " + ", ".join(map(str, sorted(self.vertices))))
        result.append("Edges:")
        for u, v, weight in self.get_edges():
            result.append(f"  {u} -> {v} (weight: {weight})")
        return "\n".join(result)


class GraphApplication:
    def __init__(self):
        self.graph = None

    def initialize_graph(self):
        print("\n=== Инициализация графа ===")
        print("Выберите тип графа:")
        print("1. Неориентированный граф")
        print("2. Ориентированный граф")

        choice = input("Ваш выбор (1-2): ").strip()

        if choice == "1":
            self.graph = Graph(directed=False)
            print("Создан неориентированный граф")
        elif choice == "2":
            self.graph = Graph(directed=True)
            print("Создан ориентированный граф")
        else:
            print("Неверный выбор, создан неориентированный граф по умолчанию")
            self.graph = Graph(directed=False)

    def show_menu(self):
        print("\n" + "="*50)
        print("          ПРИЛОЖЕНИЕ ДЛЯ РАБОТЫ С ГРАФАМИ")
        print("="*50)
        print("1.  Добавить вершину")
        print("2.  Добавить ребро")
        print("3.  Удалить вершину")
        print("4.  Удалить ребро")
        print("5.  Показать граф")
        print("6.  Поиск в ширину (BFS)")
        print("7.  Поиск в глубину (DFS)")
        print("8.  Алгоритм Дейкстры")
        print("9.  Проверить связность")
        print("10. Найти эйлеров цикл")
        print("11. Найти гамильтонов цикл")
        print("12. Показать соседей вершины")
        print("13. Показать степень вершины")
        print("14. Инициализировать новый граф")
        print("0.  Выход")
        print("="*50)

    def add_vertex_dialog(self):
        if self.graph is None:
            print("Сначала инициализируйте граф!")
            return

        vertex = input("Введите имя вершины: ").strip()
        if vertex:
            self.graph.add_vertex(vertex)
            print(f"Вершина '{vertex}' добавлена")
        else:
            print("Неверное имя вершины")

    def add_edge_dialog(self):
        if self.graph is None:
            print("Сначала инициализируйте граф!")
            return

        u = input("Введите начальную вершину: ").strip()
        v = input("Введите конечную вершину: ").strip()
        weight_input = input("Введите вес ребра (по умолчанию 1): ").strip()

        try:
            weight = float(weight_input) if weight_input else 1
        except ValueError:
            print("Неверный вес, используется значение по умолчанию 1")
            weight = 1

        if u and v:
            self.graph.add_edge(u, v, weight)
            print(f"Ребро '{u}' -> '{v}' с весом {weight} добавлено")
        else:
            print("Неверные имена вершин")

    def remove_vertex_dialog(self):
        if self.graph is None:
            print("Сначала инициализируйте граф!")
            return

        vertex = input("Введите имя вершины для удаления: ").strip()
        if vertex and self.graph.has_vertex(vertex):
            self.graph.remove_vertex(vertex)
            print(f"Вершина '{vertex}' удалена")
        else:
            print("Вершина не найдена")

    def remove_edge_dialog(self):
        if self.graph is None:
            print("Сначала инициализируйте граф!")
            return

        u = input("Введите начальную вершину: ").strip()
        v = input("Введите конечную вершину: ").strip()

        if u and v and self.graph.has_edge(u, v):
            self.graph.remove_edge(u, v)
            print(f"Ребро '{u}' -> '{v}' удалено")
        else:
            print("Ребро не найдено")

    def show_graph(self):
        if self.graph is None:
            print("Граф не инициализирован!")
            return
        print("\n" + str(self.graph))

    def bfs_dialog(self):
        if self.graph is None:
            print("Сначала инициализируйте граф!")
            return

        start = input("Введите начальную вершину для BFS: ").strip()
        if start and self.graph.has_vertex(start):
            result = self.graph.bfs(start)
            print(f"BFS от вершины '{start}': {result}")
        else:
            print("Вершина не найдена")

    def dfs_dialog(self):
        if self.graph is None:
            print("Сначала инициализируйте граф!")
            return

        start = input("Введите начальную вершину для DFS: ").strip()
        if start and self.graph.has_vertex(start):
            result = self.graph.dfs(start)
            print(f"DFS от вершины '{start}': {result}")
        else:
            print("Вершина не найдена")

    def dijkstra_dialog(self):
        if self.graph is None:
            print("Сначала инициализируйте граф!")
            return

        start = input("Введите начальную вершину для алгоритма Дейкстры: ").strip()
        if start and self.graph.has_vertex(start):
            result = self.graph.dijkstra(start)
            print(f"Кратчайшие пути от вершины '{start}':")
            for vertex, distance in result.items():
                print(f"  {vertex}: {distance}")
        else:
            print("Вершина не найдена")

    def connectivity_dialog(self):
        if self.graph is None:
            print("Сначала инициализируйте граф!")
            return

        if self.graph.directed:
            print("Проверка связности для ориентированных графов не реализована")
        else:
            connected = self.graph.is_connected()
            print(f"Граф {'связный' if connected else 'несвязный'}")

    def eulerian_cycle_dialog(self):
        if self.graph is None:
            print("Сначала инициализируйте граф!")
            return

        if self.graph.directed:
            print("Поиск эйлерова цикла для ориентированных графов не реализован")
            return

        has_cycle = self.graph.has_eulerian_cycle()
        print(f"Эйлеров цикл {'существует' if has_cycle else 'не существует'}")

        if has_cycle:
            cycle = self.graph.find_eulerian_cycle()
            print(f"Эйлеров цикл: {cycle}")

    def hamiltonian_cycle_dialog(self):
        if self.graph is None:
            print("Сначала инициализируйте граф!")
            return

        cycle = self.graph.find_hamiltonian_cycle()
        if cycle:
            print(f"Гамильтонов цикл: {cycle}")
        else:
            print("Гамильтонов цикл не найден")

    def neighbors_dialog(self):
        if self.graph is None:
            print("Сначала инициализируйте граф!")
            return

        vertex = input("Введите вершину: ").strip()
        if vertex and self.graph.has_vertex(vertex):
            neighbors = self.graph.get_neighbors(vertex)
            print(f"Соседи вершины '{vertex}': {neighbors}")
        else:
            print("Вершина не найдена")

    def degree_dialog(self):
        if self.graph is None:
            print("Сначала инициализируйте граф!")
            return

        vertex = input("Введите вершину: ").strip()
        if vertex and self.graph.has_vertex(vertex):
            degree = self.graph.get_degree(vertex)
            if self.graph.directed:
                print(f"Степень вершины '{vertex}': входящая {degree[0]}, исходящая {degree[1]}")
            else:
                print(f"Степень вершины '{vertex}': {degree}")
        else:
            print("Вершина не найдена")

    def run(self):
        print("Добро пожаловать в приложение для работы с графами!")

        self.initialize_graph()

        while True:
            self.show_menu()
            choice = input("Выберите операцию (0-14): ").strip()

            if choice == "0":
                print("Выход из программы...")
                break
            elif choice == "1":
                self.add_vertex_dialog()
            elif choice == "2":
                self.add_edge_dialog()
            elif choice == "3":
                self.remove_vertex_dialog()
            elif choice == "4":
                self.remove_edge_dialog()
            elif choice == "5":
                self.show_graph()
            elif choice == "6":
                self.bfs_dialog()
            elif choice == "7":
                self.dfs_dialog()
            elif choice == "8":
                self.dijkstra_dialog()
            elif choice == "9":
                self.connectivity_dialog()
            elif choice == "10":
                self.eulerian_cycle_dialog()
            elif choice == "11":
                self.hamiltonian_cycle_dialog()
            elif choice == "12":
                self.neighbors_dialog()
            elif choice == "13":
                self.degree_dialog()
            elif choice == "14":
                self.initialize_graph()
            else:
                print("Неверный выбор! Попробуйте снова.")

            input("\nНажмите Enter для продолжения...")

if __name__ == "__main__":
    app = GraphApplication()
    app.run()
```

    Добро пожаловать в приложение для работы с графами!
    
    === Инициализация графа ===
    Выберите тип графа:
    1. Неориентированный граф
    2. Ориентированный граф
    Создан неориентированный граф
    
    ==================================================
              ПРИЛОЖЕНИЕ ДЛЯ РАБОТЫ С ГРАФАМИ
    ==================================================
    1.  Добавить вершину
    2.  Добавить ребро
    3.  Удалить вершину
    4.  Удалить ребро
    5.  Показать граф
    6.  Поиск в ширину (BFS)
    7.  Поиск в глубину (DFS)
    8.  Алгоритм Дейкстры
    9.  Проверить связность
    10. Найти эйлеров цикл
    11. Найти гамильтонов цикл
    12. Показать соседей вершины
    13. Показать степень вершины
    14. Инициализировать новый граф
    0.  Выход
    ==================================================
    Неверное имя вершины
    
    ==================================================
              ПРИЛОЖЕНИЕ ДЛЯ РАБОТЫ С ГРАФАМИ
    ==================================================
    1.  Добавить вершину
    2.  Добавить ребро
    3.  Удалить вершину
    4.  Удалить ребро
    5.  Показать граф
    6.  Поиск в ширину (BFS)
    7.  Поиск в глубину (DFS)
    8.  Алгоритм Дейкстры
    9.  Проверить связность
    10. Найти эйлеров цикл
    11. Найти гамильтонов цикл
    12. Показать соседей вершины
    13. Показать степень вершины
    14. Инициализировать новый граф
    0.  Выход
    ==================================================
    Вершина 'A' добавлена
    
    ==================================================
              ПРИЛОЖЕНИЕ ДЛЯ РАБОТЫ С ГРАФАМИ
    ==================================================
    1.  Добавить вершину
    2.  Добавить ребро
    3.  Удалить вершину
    4.  Удалить ребро
    5.  Показать граф
    6.  Поиск в ширину (BFS)
    7.  Поиск в глубину (DFS)
    8.  Алгоритм Дейкстры
    9.  Проверить связность
    10. Найти эйлеров цикл
    11. Найти гамильтонов цикл
    12. Показать соседей вершины
    13. Показать степень вершины
    14. Инициализировать новый граф
    0.  Выход
    ==================================================
    
    === Инициализация графа ===
    Выберите тип графа:
    1. Неориентированный граф
    2. Ориентированный граф
    Создан ориентированный граф
    
    ==================================================
              ПРИЛОЖЕНИЕ ДЛЯ РАБОТЫ С ГРАФАМИ
    ==================================================
    1.  Добавить вершину
    2.  Добавить ребро
    3.  Удалить вершину
    4.  Удалить ребро
    5.  Показать граф
    6.  Поиск в ширину (BFS)
    7.  Поиск в глубину (DFS)
    8.  Алгоритм Дейкстры
    9.  Проверить связность
    10. Найти эйлеров цикл
    11. Найти гамильтонов цикл
    12. Показать соседей вершины
    13. Показать степень вершины
    14. Инициализировать новый граф
    0.  Выход
    ==================================================
    Неверный выбор! Попробуйте снова.
    
    ==================================================
              ПРИЛОЖЕНИЕ ДЛЯ РАБОТЫ С ГРАФАМИ
    ==================================================
    1.  Добавить вершину
    2.  Добавить ребро
    3.  Удалить вершину
    4.  Удалить ребро
    5.  Показать граф
    6.  Поиск в ширину (BFS)
    7.  Поиск в глубину (DFS)
    8.  Алгоритм Дейкстры
    9.  Проверить связность
    10. Найти эйлеров цикл
    11. Найти гамильтонов цикл
    12. Показать соседей вершины
    13. Показать степень вершины
    14. Инициализировать новый граф
    0.  Выход
    ==================================================
    Неверный выбор! Попробуйте снова.
    
    ==================================================
              ПРИЛОЖЕНИЕ ДЛЯ РАБОТЫ С ГРАФАМИ
    ==================================================
    1.  Добавить вершину
    2.  Добавить ребро
    3.  Удалить вершину
    4.  Удалить ребро
    5.  Показать граф
    6.  Поиск в ширину (BFS)
    7.  Поиск в глубину (DFS)
    8.  Алгоритм Дейкстры
    9.  Проверить связность
    10. Найти эйлеров цикл
    11. Найти гамильтонов цикл
    12. Показать соседей вершины
    13. Показать степень вершины
    14. Инициализировать новый граф
    0.  Выход
    ==================================================
    Неверный выбор! Попробуйте снова.
    
    ==================================================
              ПРИЛОЖЕНИЕ ДЛЯ РАБОТЫ С ГРАФАМИ
    ==================================================
    1.  Добавить вершину
    2.  Добавить ребро
    3.  Удалить вершину
    4.  Удалить ребро
    5.  Показать граф
    6.  Поиск в ширину (BFS)
    7.  Поиск в глубину (DFS)
    8.  Алгоритм Дейкстры
    9.  Проверить связность
    10. Найти эйлеров цикл
    11. Найти гамильтонов цикл
    12. Показать соседей вершины
    13. Показать степень вершины
    14. Инициализировать новый граф
    0.  Выход
    ==================================================
    Неверный выбор! Попробуйте снова.
    
    ==================================================
              ПРИЛОЖЕНИЕ ДЛЯ РАБОТЫ С ГРАФАМИ
    ==================================================
    1.  Добавить вершину
    2.  Добавить ребро
    3.  Удалить вершину
    4.  Удалить ребро
    5.  Показать граф
    6.  Поиск в ширину (BFS)
    7.  Поиск в глубину (DFS)
    8.  Алгоритм Дейкстры
    9.  Проверить связность
    10. Найти эйлеров цикл
    11. Найти гамильтонов цикл
    12. Показать соседей вершины
    13. Показать степень вершины
    14. Инициализировать новый граф
    0.  Выход
    ==================================================
    Неверный выбор! Попробуйте снова.


#### Задание 4


```python
from collections import defaultdict
import heapq

class Graph:
    def __init__(self, directed=True):
        self.graph = defaultdict(dict)
        self.directed = directed
        self.vertices = set()

    def add_vertex(self, vertex):
        self.vertices.add(vertex)
        if vertex not in self.graph:
            self.graph[vertex] = {}

    def add_edge(self, u, v, weight=1):
        self.add_vertex(u)
        self.add_vertex(v)
        self.graph[u][v] = weight
        if not self.directed:
            self.graph[v][u] = weight

    def dijkstra(self, start, end):
        if start not in self.graph or end not in self.vertices:
            return None, float('infinity')

        distances = {vertex: float('infinity') for vertex in self.vertices}
        distances[start] = 0
        previous = {vertex: None for vertex in self.vertices}
        priority_queue = [(0, start)]

        while priority_queue:
            current_distance, current_vertex = heapq.heappop(priority_queue)

            if current_vertex == end:
                break

            if current_distance > distances[current_vertex]:
                continue

            for neighbor, weight in self.graph[current_vertex].items():
                distance = current_distance + weight

                if distance < distances[neighbor]:
                    distances[neighbor] = distance
                    previous[neighbor] = current_vertex
                    heapq.heappush(priority_queue, (distance, neighbor))

        if distances[end] == float('infinity'):
            return None, float('infinity')

        path = []
        current = end
        while current is not None:
            path.append(current)
            current = previous[current]

        path.reverse()
        return path, distances[end]

graph = Graph(directed=True)

edges = [
    (1, 2, 2), (1, 3, 13), (1, 4, 25), (1, 5, 17),
    (2, 4, 3), (2, 5, 5),
    (3, 4, 15), (3, 6, 7),
    (4, 6, 4), (4, 7, 35),
    (5, 4, 12), (5, 7, 20),
    (6, 7, 5)
]

for u, v, weight in edges:
    graph.add_edge(u, v, weight)

path, distance = graph.dijkstra(1, 6)

print("КРАТЧАЙШИЙ ПУТЬ ОТ ВЕРШИНЫ 1 ДО ВЕРШИНЫ 6")
print("=" * 50)

if path:
    print(f"Путь: {' → '.join(map(str, path))}")
    print(f"Длина пути: {distance}")
    print(f"Количество вершин в пути: {len(path)}")
else:
    print("Путь не существует")


print("\n" + "=" * 50)
print("АНАЛИЗ ВОЗМОЖНЫХ МАРШРУТОВ:")
print("=" * 50)

possible_routes = [
    [1, 3, 6],          
    [1, 2, 4, 6],       
    [1, 5, 4, 6],        
    [1, 2, 5, 4, 6],     
    [1, 4, 6],           
    [1, 3, 4, 6]         
]

print("Все возможные маршруты от 1 до 6:")
for i, route in enumerate(possible_routes, 1):
    total_distance = 0
    for j in range(len(route) - 1):
        u, v = route[j], route[j + 1]
        total_distance += graph.graph[u][v]
    print(f"{i}. {route} = {total_distance}")

print("\n" + "=" * 50)
print("ВЫВОД:")
print("=" * 50)
print(f"Кратчайший путь: 1 → 2 → 4 → 6")
print(f"Длина пути: 2 + 3 + 4 = 9")
```

#### Задание 5


```python
from collections import defaultdict
import heapq

class Graph:
    def __init__(self, directed=False):
        self.graph = defaultdict(dict)
        self.directed = directed
        self.vertices = set()

    def add_vertex(self, vertex):
        self.vertices.add(vertex)
        if vertex not in self.graph:
            self.graph[vertex] = {}

    def add_edge(self, u, v, weight=1):
        self.add_vertex(u)
        self.add_vertex(v)
        self.graph[u][v] = weight
        if not self.directed:
            self.graph[v][u] = weight

    def dijkstra(self, start, end):
        if start not in self.graph or end not in self.vertices:
            return None, float('infinity')

        distances = {vertex: float('infinity') for vertex in self.vertices}
        distances[start] = 0
        previous = {vertex: None for vertex in self.vertices}
        priority_queue = [(0, start)]

        while priority_queue:
            current_distance, current_vertex = heapq.heappop(priority_queue)

            # Если дошли до конечной вершины
            if current_vertex == end:
                break

            if current_distance > distances[current_vertex]:
                continue

            for neighbor, weight in self.graph[current_vertex].items():
                distance = current_distance + weight

                if distance < distances[neighbor]:
                    distances[neighbor] = distance
                    previous[neighbor] = current_vertex
                    heapq.heappush(priority_queue, (distance, neighbor))

        if distances[end] == float('infinity'):
            return None, float('infinity')

        path = []
        current = end
        while current is not None:
            path.append(current)
            current = previous[current] 

        path.reverse()
        return path, distances[end]

    def dijkstra_all_paths(self, start):
        """Алгоритм Дейкстры для поиска всех кратчайших путей от start"""
        if start not in self.graph:
            return {}, {}

        distances = {vertex: float('infinity') for vertex in self.vertices}
        distances[start] = 0
        previous = {vertex: None for vertex in self.vertices}
        priority_queue = [(0, start)]

        while priority_queue:
            current_distance, current_vertex = heapq.heappop(priority_queue)

            if current_distance > distances[current_vertex]:
                continue

            for neighbor, weight in self.graph[current_vertex].items():
                distance = current_distance + weight

                if distance < distances[neighbor]:
                    distances[neighbor] = distance
                    previous[neighbor] = current_vertex
                    heapq.heappush(priority_queue, (distance, neighbor))

        return distances, previous

    def print_all_paths_from_start(self, start):
        distances, previous = self.dijkstra_all_paths(start)

        print(f"\nКратчайшие пути от вершины {start}:")
        print("Вершина | Расстояние | Путь")
        print("-" * 40)

        for vertex in sorted(self.vertices):
            if vertex == start:
                continue

            path = []
            current = vertex
            while current is not None:
                path.append(current)
                current = previous[current]  

            path.reverse()

            dist = distances.get(vertex, float('infinity'))
            if dist == float('infinity'):
                path_str = "Нет пути"
            else:
                path_str = ' → '.join(map(str, path))

            print(f"{vertex:7} | {dist:9} | {path_str}")

graph = Graph(directed=False)

edges = [
    (1, 2, 14), (1, 6, 8),
    (2, 6, 2), (2, 4, 10), (2, 5, 2), (2, 3, 5), (2, 8, 9),
    (3, 8, 11),
    (4, 6, 6), (4, 7, 5), (4, 5, 3),
    (5, 7, 8), (5, 8, 1),
    (6, 7, 5),
    (7, 8, 7)
]

for u, v, weight in edges:
    graph.add_edge(u, v, weight)

start_vertex = 3
end_vertex = 8
path, distance = graph.dijkstra(start_vertex, end_vertex)

print("АЛГОРИТМ ДЕЙКСТРЫ - ПОИСК КРАТЧАЙШЕГО ПУТИ")
print("=" * 60)
print(f"Начальная вершина: {start_vertex}")
print(f"Конечная вершина: {end_vertex}")
print("=" * 60)

if path:
    print(f"КРАТЧАЙШИЙ ПУТЬ: {' → '.join(map(str, path))}")
    print(f"ДЛИНА ПУТИ: {distance}")

    print("\nПОДРОБНЫЙ РАСЧЕТ:")
    total = 0
    for i in range(len(path) - 1):
        u, v = path[i], path[i + 1]
        edge_weight = graph.graph[u][v]
        total += edge_weight
        print(f"  {u} → {v} = {edge_weight}")
    print(f"  ИТОГО: {total}")
else:
    print("Путь не существует")

print("\n" + "=" * 60)
print("АНАЛИЗ ВОЗМОЖНЫХ МАРШРУТОВ ОТ 3 ДО 8:")
print("=" * 60)

possible_routes = [
    [3, 8],                    
    [3, 2, 8],                 
    [3, 2, 5, 8],              
    [3, 2, 6, 7, 8],           
    [3, 2, 4, 5, 8],          
    [3, 2, 6, 4, 5, 8]         
]

print("Все возможные маршруты от 3 до 8:")
for i, route in enumerate(possible_routes, 1):
    total_distance = 0
    valid_route = True
    route_details = []

    for j in range(len(route) - 1):
        u, v = route[j], route[j + 1]
        if v in graph.graph[u]:
            edge_weight = graph.graph[u][v]
            total_distance += edge_weight
            route_details.append(f"{u}→{v}({edge_weight})")
        else:
            valid_route = False
            break

    if valid_route:
        status = "✓" if total_distance == distance else ""
        print(f"{i:2}. {route} = {total_distance:2} {status}")
        if route_details:
            print(f"    {' + '.join(route_details)}")

graph.print_all_paths_from_start(3)  

print("\n" + "=" * 60)
print("ОСНОВНОЙ ВЫВОД:")
print("=" * 60)
print(f"Кратчайший путь от {start_vertex} до {end_vertex}: {path}")
print(f"Длина кратчайшего пути: {distance}")
```

#### Задание 6


```python
import heapq

def dijkstra_shortest_path(graph, start, end):
    distances = {vertex: float('infinity') for vertex in graph}
    distances[start] = 0
    previous = {vertex: None for vertex in graph}
    priority_queue = [(0, start)]

    while priority_queue:
        current_distance, current_vertex = heapq.heappop(priority_queue)

        if current_vertex == end:
            break

        if current_distance > distances[current_vertex]:
            continue

        for neighbor, weight in graph[current_vertex].items():
            distance = current_distance + weight
            if distance < distances[neighbor]:
                distances[neighbor] = distance
                previous[neighbor] = current_vertex
                heapq.heappush(priority_queue, (distance, neighbor))
    if distances[end] == float('infinity'):
        return None, float('infinity')

    path = []
    current = end
    while current is not None:
        path.append(current)
        current = previous[current]

    path.reverse()
    return path, distances[end]

def print_detailed_path_analysis(graph, path):
    if not path:
        print("Путь не найден")
        return

    print("\nПОДРОБНЫЙ АНАЛИЗ ПУТИ:")
    print("-" * 30)
    total_distance = 0

    for i in range(len(path) - 1):
        u, v = path[i], path[i + 1]
        edge_weight = graph[u][v]
        total_distance += edge_weight
        print(f"{u} → {v} = {edge_weight}")

    print(f"ОБЩАЯ ДЛИНА ПУТИ: {total_distance}")

def main():
    graph = {
        1: {2: 14, 6: 8},
        2: {1: 14, 3: 5, 4: 10, 5: 2, 6: 2, 8: 9},
        3: {2: 5, 8: 11},
        4: {2: 10, 5: 3, 6: 6, 7: 5},
        5: {2: 2, 4: 3, 7: 8, 8: 1},
        6: {1: 8, 2: 2, 4: 6, 7: 5},
        7: {4: 5, 5: 8, 6: 5, 8: 7},
        8: {2: 9, 3: 11, 5: 1, 7: 7}
    }

    start_vertex = 3
    end_vertex = 8

    print("ПОИСК КРАТЧАЙШЕГО ПУТИ АЛГОРИТМОМ ДЕЙКСТРЫ")
    print("=" * 50)
    print(f"Начальная вершина: {start_vertex}")
    print(f"Конечная вершина: {end_vertex}")
    print("=" * 50)

    # Выполняем поиск кратчайшего пути
    path, distance = dijkstra_shortest_path(graph, start_vertex, end_vertex)

    if path:
        print(f"КРАТЧАЙШИЙ ПУТЬ: {' → '.join(map(str, path))}")
        print(f"ДЛИНА ПУТИ: {distance}")

        # Подробный анализ
        print_detailed_path_analysis(graph, path)

        # Сравнение с другими возможными путями
        print("\n" + "=" * 50)
        print("СРАВНЕНИЕ С ДРУГИМИ ПУТЯМИ:")
        print("=" * 50)

        alternative_paths = [
            ([3, 8], "Прямой путь"),
            ([3, 2, 8], "Через вершину 2"),
            ([3, 2, 5, 8], "Через вершины 2 и 5"),
            ([3, 2, 6, 7, 8], "Через вершины 2, 6, 7"),
            ([3, 2, 4, 5, 8], "Через вершины 2, 4, 5")
        ]

        for alt_path, description in alternative_paths:
            alt_distance = 0
            valid = True

            for i in range(len(alt_path) - 1):
                u, v = alt_path[i], alt_path[i + 1]
                if v in graph.get(u, {}):
                    alt_distance += graph[u][v]
                else:
                    valid = False
                    break

            if valid:
                status = "✓ ЛУЧШИЙ" if alt_path == path else ""
                print(f"{description:20} {alt_path} = {alt_distance:2} {status}")

    else:
        print("Путь между вершинами не существует")

if __name__ == "__main__":
    main()
```

    ПОИСК КРАТЧАЙШЕГО ПУТИ АЛГОРИТМОМ ДЕЙКСТРЫ
    ==================================================
    Начальная вершина: 3
    Конечная вершина: 8
    ==================================================
    КРАТЧАЙШИЙ ПУТЬ: 3 → 2 → 5 → 8
    ДЛИНА ПУТИ: 8
    
    ПОДРОБНЫЙ АНАЛИЗ ПУТИ:
    ------------------------------
    3 → 2 = 5
    2 → 5 = 2
    5 → 8 = 1
    ОБЩАЯ ДЛИНА ПУТИ: 8
    
    ==================================================
    СРАВНЕНИЕ С ДРУГИМИ ПУТЯМИ:
    ==================================================
    Прямой путь          [3, 8] = 11 
    Через вершину 2      [3, 2, 8] = 14 
    Через вершины 2 и 5  [3, 2, 5, 8] =  8 ✓ ЛУЧШИЙ
    Через вершины 2, 6, 7 [3, 2, 6, 7, 8] = 19 
    Через вершины 2, 4, 5 [3, 2, 4, 5, 8] = 19 

