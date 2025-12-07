# Алгоритмы на графах

***

Старшинов Владислав Эдуардович

ИУ10-37

Вариант 6

## Задания

***

### Реализация графа как класса


```python
from collections import deque, defaultdict
import heapq

class Graph:
    def __init__(self, directed=False):
        """
        Инициализация графа
        
        Args:
            directed (bool): True для ориентированного графа, False для неориентированного
        """
        self.graph = defaultdict(dict)
        self.directed = directed
        self.vertices = set()
    
    def add_vertex(self, vertex):
        """Добавление вершины в граф"""
        self.vertices.add(vertex)
        if vertex not in self.graph:
            self.graph[vertex] = {}
    
    def add_edge(self, u, v, weight=1):
        """
        Добавление ребра между вершинами u и v
        
        Args:
            u: начальная вершина
            v: конечная вершина
            weight: вес ребра (по умолчанию 1)
        """
        self.add_vertex(u)
        self.add_vertex(v)
        
        self.graph[u][v] = weight
        
        if not self.directed:
            self.graph[v][u] = weight
    
    def remove_vertex(self, vertex):
        """Удаление вершины и всех связанных с ней ребер"""
        if vertex in self.graph:
            # Удаляем все ребра, ведущие к этой вершине
            for u in list(self.graph.keys()):
                if vertex in self.graph[u]:
                    del self.graph[u][vertex]
            
            # Удаляем саму вершину
            del self.graph[vertex]
            self.vertices.discard(vertex)
    
    def remove_edge(self, u, v):
        """Удаление ребра между вершинами u и v"""
        if u in self.graph and v in self.graph[u]:
            del self.graph[u][v]
            
        if not self.directed and v in self.graph and u in self.graph[v]:
            del self.graph[v][u]
    
    def get_vertices(self):
        """Получение списка всех вершин"""
        return list(self.vertices)
    
    def get_edges(self):
        """Получение списка всех ребер в виде кортежей (u, v, weight)"""
        edges = []
        for u in self.graph:
            for v, weight in self.graph[u].items():
                if self.directed or u <= v:  # Для неориентированного избегаем дублирования
                    edges.append((u, v, weight))
        return edges
    
    def get_neighbors(self, vertex):
        """Получение соседей вершины"""
        if vertex in self.graph:
            return list(self.graph[vertex].keys())
        return []
    
    def get_degree(self, vertex):
        """Получение степени вершины"""
        if vertex not in self.graph:
            return 0
        
        degree = len(self.graph[vertex])
        
        # Для неориентированного графа степень уже правильная
        # Для ориентированного нужно учесть входящие ребра
        if self.directed:
            in_degree = sum(1 for u in self.graph if vertex in self.graph[u])
            return (in_degree, degree)  # (входящая степень, исходящая степень)
        
        return degree
    
    def has_vertex(self, vertex):
        """Проверка наличия вершины в графе"""
        return vertex in self.graph
    
    def has_edge(self, u, v):
        """Проверка наличия ребра между вершинами u и v"""
        return u in self.graph and v in self.graph[u]
    
    def get_edge_weight(self, u, v):
        """Получение веса ребра между вершинами u и v"""
        if self.has_edge(u, v):
            return self.graph[u][v]
        return None
    
    def bfs(self, start):
        """Поиск в ширину (BFS)"""
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
                
                # Добавляем всех непосещенных соседей
                for neighbor in self.graph[vertex]:
                    if neighbor not in visited:
                        queue.append(neighbor)
        
        return result
    
    def dfs(self, start):
        """Поиск в глубину (DFS) - итеративная версия"""
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
                
                # Добавляем соседей в обратном порядке для сохранения порядка обхода
                for neighbor in reversed(list(self.graph[vertex].keys())):
                    if neighbor not in visited:
                        stack.append(neighbor)
        
        return result
    
    def dijkstra(self, start):
        """Алгоритм Дейкстры для поиска кратчайших путей"""
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
        """Проверка связности графа (только для неориентированного)"""
        if self.directed:
            raise NotImplementedError("Для ориентированных графов используйте is_strongly_connected()")
        
        if not self.vertices:
            return True
        
        start_vertex = next(iter(self.vertices))
        visited = set(self.bfs(start_vertex))
        
        return len(visited) == len(self.vertices)
    
    def topological_sort(self):
        """Топологическая сортировка (только для ориентированных ациклических графов)"""
        if not self.directed:
            raise ValueError("Топологическая сортировка применима только к ориентированным графам")
        
        in_degree = {vertex: 0 for vertex in self.vertices}
        
        # Вычисляем полустепень захода для каждой вершины
        for u in self.graph:
            for v in self.graph[u]:
                in_degree[v] += 1
        
        # Очередь вершин с нулевой полустепенью захода
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
        """Получение матрицы смежности"""
        vertices = sorted(self.vertices)
        n = len(vertices)
        vertex_index = {vertex: i for i, vertex in enumerate(vertices)}
        
        matrix = [[0] * n for _ in range(n)]
        
        for u in self.graph:
            for v, weight in self.graph[u].items():
                i, j = vertex_index[u], vertex_index[v]
                matrix[i][j] = weight
        
        return matrix, vertices
    
    def __str__(self):
        """Строковое представление графа"""
        result = []
        result.append(f"Graph (directed: {self.directed})")
        result.append("Vertices: " + ", ".join(map(str, sorted(self.vertices))))
        result.append("Edges:")
        for u, v, weight in self.get_edges():
            result.append(f"  {u} -> {v} (weight: {weight})")
        return "\n".join(result)
    
    def has_eulerian_cycle(self):
        """Проверка наличия эйлерова цикла (для неориентированного графа)"""
        if self.directed:
            raise NotImplementedError("Для ориентированных графов проверка эйлерова цикла сложнее")
    
        # Все вершины должны иметь четную степень
        for vertex in self.vertices:
            if len(self.graph[vertex]) % 2 != 0:
                return False
    
        # Граф должен быть связным
        return self.is_connected()

    def find_eulerian_cycle(self):
        """Нахождение эйлерова цикла (алгоритм Флёри)"""
        if not self.has_eulerian_cycle():
            return None
    
        # Создаем копию графа для работы
        graph_copy = {u: dict(neighbors) for u, neighbors in self.graph.items()}
    
        def dfs_count(v, visited):
            count = 1
            visited.add(v)
            for neighbor in graph_copy[v]:
                if neighbor not in visited:
                    count += dfs_count(neighbor, visited)
            return count
    
        def is_valid_next_edge(u, v):
            """Проверяем, является ли ребро u-v мостом"""
            if len(graph_copy[u]) == 1:
                return True
        
            # Временно удаляем ребро и проверяем связность
            weight = graph_copy[u][v]
            del graph_copy[u][v]
            del graph_copy[v][u]
        
            visited = set()
            count1 = dfs_count(u, visited)
        
            # Возвращаем ребро
            graph_copy[u][v] = weight
            graph_copy[v][u] = weight
        
            return count1 == 0  # Если после удаления количество достижимых вершин не изменилось
    
        # Начинаем с произвольной вершины
        current = next(iter(self.vertices))
        stack = [current]
        cycle = []
    
        while stack:
            current = stack[-1]
        
            if graph_copy[current]:
                # Выбираем следующее ребро
                for neighbor in graph_copy[current]:
                    if not is_valid_next_edge(current, neighbor):
                        continue
                
                    # Удаляем ребро
                    del graph_copy[current][neighbor]
                    del graph_copy[neighbor][current]
                    stack.append(neighbor)
                    break
                else:
                    # Если не нашли подходящее ребро, берем первое
                    neighbor = next(iter(graph_copy[current]))
                    del graph_copy[current][neighbor]
                    del graph_copy[neighbor][current]
                    stack.append(neighbor)
            else:
                # Нет исходящих ребер - добавляем в цикл
                cycle.append(stack.pop())
    
        return cycle[::-1]

    def hamiltonian_cycle_util(self, path, pos, visited):
        """Вспомогательная функция для поиска гамильтонова цикла"""
        if pos == len(self.vertices):
            # Проверяем, есть ли ребро от последней к первой вершине
            if self.has_edge(path[pos-1], path[0]):
                return True
            return False
    
        for v in self.vertices:
            if not visited[v] and self.has_edge(path[pos-1], v):
                path[pos] = v
                visited[v] = True
            
                if self.hamiltonian_cycle_util(path, pos+1, visited):
                    return True
            
                # Откат
                visited[v] = False
                path[pos] = -1
    
        return False

    def find_hamiltonian_cycle(self):
        """Нахождение гамильтонова цикла (метод перебора с возвратом)"""
        if len(self.vertices) < 3:
            return None
    
        path = [-1] * len(self.vertices)
        visited = {vertex: False for vertex in self.vertices}
    
        # Начинаем с первой вершины
        start_vertex = next(iter(self.vertices))
        path[0] = start_vertex
        visited[start_vertex] = True
    
        if not self.hamiltonian_cycle_util(path, 1, visited):
            return None
    
        # Замыкаем цикл
        return path + [path[0]]
```

### Реализация приложения


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
        """Инициализация графа"""
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
        """Показать главное меню"""
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
        """Диалог добавления вершины"""
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
        """Диалог добавления ребра"""
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
        """Диалог удаления вершины"""
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
        """Диалог удаления ребра"""
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
        """Показать текущий граф"""
        if self.graph is None:
            print("Граф не инициализирован!")
            return
        print("\n" + str(self.graph))
    
    def bfs_dialog(self):
        """Диалог поиска в ширину"""
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
        """Диалог поиска в глубину"""
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
        """Диалог алгоритма Дейкстры"""
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
        """Диалог проверки связности"""
        if self.graph is None:
            print("Сначала инициализируйте граф!")
            return
        
        if self.graph.directed:
            print("Проверка связности для ориентированных графов не реализована")
        else:
            connected = self.graph.is_connected()
            print(f"Граф {'связный' if connected else 'несвязный'}")
    
    def eulerian_cycle_dialog(self):
        """Диалог поиска эйлерова цикла"""
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
        """Диалог поиска гамильтонова цикла"""
        if self.graph is None:
            print("Сначала инициализируйте граф!")
            return
        
        cycle = self.graph.find_hamiltonian_cycle()
        if cycle:
            print(f"Гамильтонов цикл: {cycle}")
        else:
            print("Гамильтонов цикл не найден")
    
    def neighbors_dialog(self):
        """Диалог показа соседей вершины"""
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
        """Диалог показа степени вершины"""
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
        """Запуск диалогового цикла приложения"""
        print("Добро пожаловать в приложение для работы с графами!")
        
        # Инициализация графа при старте
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


# Запуск приложения
if __name__ == "__main__":
    app = GraphApplication()
    app.run()
```

### Поиск кратчайшего пути между вершинами 1 и 6

Информация о графе:

Вершины: 1,2,3,4,5,6,7. Связи между вершинами:

1-2 = 2

1-3 = 13

1-4 = 25

1-5 = 17

2-4 = 3

2-5 = 5

3-4 = 15

3-6 = 7

4-6 = 4

4-7 = 35

5-4 = 12

5-7 = 20

6-7 = 5


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
        """Алгоритм Дейкстры для поиска кратчайшего пути от start до end"""
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
        
        # Восстанавливаем путь
        if distances[end] == float('infinity'):
            return None, float('infinity')
        
        path = []
        current = end
        while current is not None:
            path.append(current)
            current = previous[current]
        
        path.reverse()
        return path, distances[end]

# Создаем граф на основе предоставленных данных
graph = Graph(directed=True)

# Добавляем ребра с весами
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

# Находим кратчайший путь от вершины 1 до вершины 6
path, distance = graph.dijkstra(1, 6)

print("КРАТЧАЙШИЙ ПУТЬ ОТ ВЕРШИНЫ 1 ДО ВЕРШИНЫ 6")
print("=" * 50)

if path:
    print(f"Путь: {' → '.join(map(str, path))}")
    print(f"Длина пути: {distance}")
    print(f"Количество вершин в пути: {len(path)}")
else:
    print("Путь не существует")

# Анализ возможных маршрутов
print("\n" + "=" * 50)
print("АНАЛИЗ ВОЗМОЖНЫХ МАРШРУТОВ:")
print("=" * 50)

# Все возможные пути от 1 до 6
possible_routes = [
    [1, 3, 6],           # 1→3→6: 13 + 7 = 20
    [1, 2, 4, 6],        # 1→2→4→6: 2 + 3 + 4 = 9
    [1, 5, 4, 6],        # 1→5→4→6: 17 + 12 + 4 = 33
    [1, 2, 5, 4, 6],     # 1→2→5→4→6: 2 + 5 + 12 + 4 = 23
    [1, 4, 6],           # 1→4→6: 25 + 4 = 29
    [1, 3, 4, 6]         # 1→3→4→6: 13 + 15 + 4 = 32
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

    КРАТЧАЙШИЙ ПУТЬ ОТ ВЕРШИНЫ 1 ДО ВЕРШИНЫ 6
    ==================================================
    Путь: 1 → 2 → 4 → 6
    Длина пути: 9
    Количество вершин в пути: 4
    
    ==================================================
    АНАЛИЗ ВОЗМОЖНЫХ МАРШРУТОВ:
    ==================================================
    Все возможные маршруты от 1 до 6:
    1. [1, 3, 6] = 20
    2. [1, 2, 4, 6] = 9
    3. [1, 5, 4, 6] = 33
    4. [1, 2, 5, 4, 6] = 23
    5. [1, 4, 6] = 29
    6. [1, 3, 4, 6] = 32
    
    ==================================================
    ВЫВОД:
    ==================================================
    Кратчайший путь: 1 → 2 → 4 → 6
    Длина пути: 2 + 3 + 4 = 9


### Реализация алгоритма Дейкстры для поиска кратчайшего пути между вершинами 3 и 8

Информация о графе:

Вершины: 1,2,3,4,5,6,7,8. Связи между вершинами:

1-2 = 14

1-6 = 8

2-6 = 2

2-4 = 10

2-5 = 2

2-3 = 5

2-8 = 9

3-8 = 11

4-6 = 6

4-7 = 5

4-5 = 3

5-7 = 8

5-8 = 1

6-7 = 5

7-8 = 7


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
        """Алгоритм Дейкстры для поиска кратчайшего пути от start до end"""
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
        
        # Восстанавливаем путь
        if distances[end] == float('infinity'):
            return None, float('infinity')
        
        path = []
        current = end
        while current is not None:
            path.append(current)
            current = previous[current]  # Исправлено: используем словарь previous
        
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
        """Вывести все кратчайшие пути от стартовой вершины"""
        distances, previous = self.dijkstra_all_paths(start)  # Исправлено: используем правильный метод
        
        print(f"\nКратчайшие пути от вершины {start}:")
        print("Вершина | Расстояние | Путь")
        print("-" * 40)
        
        for vertex in sorted(self.vertices):
            if vertex == start:
                continue
                
            # Восстанавливаем путь для каждой вершины
            path = []
            current = vertex
            while current is not None:
                path.append(current)
                current = previous[current]  # Исправлено: используем словарь previous
            
            path.reverse()
            
            # Исправлено: правильно обращаемся к distances
            dist = distances.get(vertex, float('infinity'))
            if dist == float('infinity'):
                path_str = "Нет пути"
            else:
                path_str = ' → '.join(map(str, path))
            
            print(f"{vertex:7} | {dist:9} | {path_str}")

# Создаем неориентированный граф на основе предоставленных данных
graph = Graph(directed=False)

# Добавляем ребра с весами
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

# Находим кратчайший путь от вершины 3 до вершины 8
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
    
    # Подробный расчет
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

# Анализ всех возможных маршрутов от 3 до 8
print("\n" + "=" * 60)
print("АНАЛИЗ ВОЗМОЖНЫХ МАРШРУТОВ ОТ 3 ДО 8:")
print("=" * 60)

possible_routes = [
    [3, 8],                    # Прямой путь
    [3, 2, 8],                 # Через вершину 2
    [3, 2, 5, 8],              # Через вершины 2 и 5
    [3, 2, 6, 7, 8],           # Через вершины 2, 6, 7
    [3, 2, 4, 5, 8],           # Через вершины 2, 4, 5
    [3, 2, 6, 4, 5, 8]         # Через вершины 2, 6, 4, 5
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

# Выводим все кратчайшие пути от вершины 3
graph.print_all_paths_from_start(3)  # Исправлено: передаем int, а не список

print("\n" + "=" * 60)
print("ОСНОВНОЙ ВЫВОД:")
print("=" * 60)
print(f"Кратчайший путь от {start_vertex} до {end_vertex}: {path}")
print(f"Длина кратчайшего пути: {distance}")
```

    АЛГОРИТМ ДЕЙКСТРЫ - ПОИСК КРАТЧАЙШЕГО ПУТИ
    ============================================================
    Начальная вершина: 3
    Конечная вершина: 8
    ============================================================
    КРАТЧАЙШИЙ ПУТЬ: 3 → 2 → 5 → 8
    ДЛИНА ПУТИ: 8
    
    ПОДРОБНЫЙ РАСЧЕТ:
      3 → 2 = 5
      2 → 5 = 2
      5 → 8 = 1
      ИТОГО: 8
    
    ============================================================
    АНАЛИЗ ВОЗМОЖНЫХ МАРШРУТОВ ОТ 3 ДО 8:
    ============================================================
    Все возможные маршруты от 3 до 8:
     1. [3, 8] = 11 
        3→8(11)
     2. [3, 2, 8] = 14 
        3→2(5) + 2→8(9)
     3. [3, 2, 5, 8] =  8 ✓
        3→2(5) + 2→5(2) + 5→8(1)
     4. [3, 2, 6, 7, 8] = 19 
        3→2(5) + 2→6(2) + 6→7(5) + 7→8(7)
     5. [3, 2, 4, 5, 8] = 19 
        3→2(5) + 2→4(10) + 4→5(3) + 5→8(1)
     6. [3, 2, 6, 4, 5, 8] = 17 
        3→2(5) + 2→6(2) + 6→4(6) + 4→5(3) + 5→8(1)
    
    Кратчайшие пути от вершины 3:
    Вершина | Расстояние | Путь
    ----------------------------------------
          1 |        15 | 3 → 2 → 6 → 1
          2 |         5 | 3 → 2
          4 |        10 | 3 → 2 → 5 → 4
          5 |         7 | 3 → 2 → 5
          6 |         7 | 3 → 2 → 6
          7 |        12 | 3 → 2 → 6 → 7
          8 |         8 | 3 → 2 → 5 → 8
    
    ============================================================
    ОСНОВНОЙ ВЫВОД:
    ============================================================
    Кратчайший путь от 3 до 8: [3, 2, 5, 8]
    Длина кратчайшего пути: 8


### Программная реализация алгоритма Дейкстры для поиска кратчайшего пути между вершинами 3 и 8


```python
import heapq

def dijkstra_shortest_path(graph, start, end):
    """
    Алгоритм Дейкстры для поиска кратчайшего пути в неориентированном графе
    
    Args:
        graph: словарь, где ключи - вершины, значения - словари соседей с весами
        start: начальная вершина
        end: конечная вершина
    
    Returns:
        tuple: (кратчайший путь, длина пути)
    """
    # Инициализация
    distances = {vertex: float('infinity') for vertex in graph}
    distances[start] = 0
    previous = {vertex: None for vertex in graph}
    priority_queue = [(0, start)]
    
    while priority_queue:
        current_distance, current_vertex = heapq.heappop(priority_queue)
        
        # Если дошли до конечной вершины, можно прерваться
        if current_vertex == end:
            break
            
        # Если текущее расстояние больше найденного, пропускаем
        if current_distance > distances[current_vertex]:
            continue
            
        # Проверяем всех соседей текущей вершины
        for neighbor, weight in graph[current_vertex].items():
            distance = current_distance + weight
            
            # Если нашли более короткий путь
            if distance < distances[neighbor]:
                distances[neighbor] = distance
                previous[neighbor] = current_vertex
                heapq.heappush(priority_queue, (distance, neighbor))
    
    # Восстанавливаем путь
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
    """Подробный анализ пути с вычислением суммы весов"""
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
    # Создаем неориентированный граф на основе данных из задания
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

