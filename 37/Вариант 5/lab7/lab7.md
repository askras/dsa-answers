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
    
    def __str__(self):
        result = []
        result.append(f"Graph (directed: {self.directed})")
        result.append("Vertices: " + ", ".join(map(str, sorted(self.vertices))))
        result.append("Edges:")
        for u, v, weight in self.get_edges():
            result.append(f"  {u} -> {v} (weight: {weight})")
        return "\n".join(result)
    
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

    def hamiltonian_cycle_util(self, path, pos, visited):
        if pos == len(self.vertices):
            if self.has_edge(path[pos-1], path[0]):
                return True
            return False
    
        for v in self.vertices:
            if not visited[v] and self.has_edge(path[pos-1], v):
                path[pos] = v
                visited[v] = True
            
                if self.hamiltonian_cycle_util(path, pos+1, visited):
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
    
        if not self.hamiltonian_cycle_util(path, 1, visited):
            return None
    
        return path + [path[0]]
```


```python
from collections import deque, defaultdict
import heapq

class Graph:
    def __init__(self, directed=False):
        self.adjacency = defaultdict(dict)
        self.is_directed = directed
        self.node_set = set()
    
    def insert_node(self, node):
        self.node_set.add(node)
        if node not in self.adjacency:
            self.adjacency[node] = {}
    
    def connect_nodes(self, node1, node2, cost=1):
        self.insert_node(node1)
        self.insert_node(node2)
        self.adjacency[node1][node2] = cost
        if not self.is_directed:
            self.adjacency[node2][node1] = cost
    
    def delete_node(self, node):
        if node in self.adjacency:
            for other_node in list(self.adjacency.keys()):
                if node in self.adjacency[other_node]:
                    del self.adjacency[other_node][node]
            del self.adjacency[node]
            self.node_set.discard(node)
    
    def disconnect_nodes(self, node1, node2):
        if node1 in self.adjacency and node2 in self.adjacency[node1]:
            del self.adjacency[node1][node2]
        if not self.is_directed and node2 in self.adjacency and node1 in self.adjacency[node2]:
            del self.adjacency[node2][node1]
    
    def get_all_nodes(self):
        return list(self.node_set)
    
    def get_all_connections(self):
        connections = []
        for node1 in self.adjacency:
            for node2, cost in self.adjacency[node1].items():
                if self.is_directed or node1 <= node2:
                    connections.append((node1, node2, cost))
        return connections
    
    def get_adjacent_nodes(self, node):
        if node in self.adjacency:
            return list(self.adjacency[node].keys())
        return []
    
    def calculate_node_degree(self, node):
        if node not in self.adjacency:
            return 0
        degree_count = len(self.adjacency[node])
        if self.is_directed:
            incoming_count = sum(1 for other_node in self.adjacency if node in self.adjacency[other_node])
            return (incoming_count, degree_count)
        return degree_count
    
    def node_exists(self, node):
        return node in self.adjacency
    
    def connection_exists(self, node1, node2):
        return node1 in self.adjacency and node2 in self.adjacency[node1]
    
    def get_connection_cost(self, node1, node2):
        if self.connection_exists(node1, node2):
            return self.adjacency[node1][node2]
        return None
    
    def breadth_first_search(self, start_node):
        if start_node not in self.adjacency:
            return []
        explored = set()
        node_queue = deque([start_node])
        traversal_order = []
        while node_queue:
            current_node = node_queue.popleft()
            if current_node not in explored:
                explored.add(current_node)
                traversal_order.append(current_node)
                for neighbor in self.adjacency[current_node]:
                    if neighbor not in explored:
                        node_queue.append(neighbor)
        return traversal_order
    
    def depth_first_search(self, start_node):
        if start_node not in self.adjacency:
            return []
        explored = set()
        node_stack = [start_node]
        traversal_order = []
        while node_stack:
            current_node = node_stack.pop()
            if current_node not in explored:
                explored.add(current_node)
                traversal_order.append(current_node)
                for neighbor in reversed(list(self.adjacency[current_node].keys())):
                    if neighbor not in explored:
                        node_stack.append(neighbor)
        return traversal_order
    
    def compute_shortest_paths(self, start_node):
        if start_node not in self.adjacency:
            return {}
        path_costs = {node: float('infinity') for node in self.node_set}
        path_costs[start_node] = 0
        min_heap = [(0, start_node)]
        while min_heap:
            current_cost, current_node = heapq.heappop(min_heap)
            if current_cost > path_costs[current_node]:
                continue
            for neighbor, edge_cost in self.adjacency[current_node].items():
                total_cost = current_cost + edge_cost
                if total_cost < path_costs[neighbor]:
                    path_costs[neighbor] = total_cost
                    heapq.heappush(min_heap, (total_cost, neighbor))
        return path_costs
    
    def check_connectivity(self):
        if self.is_directed:
            raise NotImplementedError("Для ориентированных графов эта функция недоступна")
        if not self.node_set:
            return True
        first_node = next(iter(self.node_set))
        explored = set(self.breadth_first_search(first_node))
        return len(explored) == len(self.node_set)
    
    def can_have_euler_cycle(self):
        if self.is_directed:
            raise NotImplementedError("Для ориентированных графов проверка эйлерова цикла не реализована")
        for node in self.node_set:
            if len(self.adjacency[node]) % 2 != 0:
                return False
        return self.check_connectivity()
    
    def locate_euler_cycle(self):
        if not self.can_have_euler_cycle():
            return None
        temp_graph = {node: dict(neighbors) for node, neighbors in self.adjacency.items()}
        
        def count_reachable_nodes(current_node, visited_nodes):
            count = 1
            visited_nodes.add(current_node)
            for adjacent_node in temp_graph[current_node]:
                if adjacent_node not in visited_nodes:
                    count += count_reachable_nodes(adjacent_node, visited_nodes)
            return count
        
        def check_bridge(node_a, node_b):
            if len(temp_graph[node_a]) == 1:
                return True
            connection_cost = temp_graph[node_a][node_b]
            del temp_graph[node_a][node_b]
            del temp_graph[node_b][node_a]
            visited_nodes = set()
            reachable_count = count_reachable_nodes(node_a, visited_nodes)
            temp_graph[node_a][node_b] = connection_cost
            temp_graph[node_b][node_a] = connection_cost
            return reachable_count > 0
        
        current_node = next(iter(self.node_set))
        node_stack = [current_node]
        cycle_path = []
        while node_stack:
            current_node = node_stack[-1]
            if temp_graph[current_node]:
                for neighbor_node in temp_graph[current_node]:
                    if not check_bridge(current_node, neighbor_node):
                        continue
                    del temp_graph[current_node][neighbor_node]
                    del temp_graph[neighbor_node][current_node]
                    node_stack.append(neighbor_node)
                    break
                else:
                    neighbor_node = next(iter(temp_graph[current_node]))
                    del temp_graph[current_node][neighbor_node]
                    del temp_graph[neighbor_node][current_node]
                    node_stack.append(neighbor_node)
            else:
                cycle_path.append(node_stack.pop())
        return cycle_path[::-1]
    
    def _search_hamilton_cycle(self, current_path, position, visited_nodes):
        if position == len(self.node_set):
            if self.connection_exists(current_path[position-1], current_path[0]):
                return True
            return False
        for next_node in self.node_set:
            if not visited_nodes[next_node] and self.connection_exists(current_path[position-1], next_node):
                current_path[position] = next_node
                visited_nodes[next_node] = True
                if self._search_hamilton_cycle(current_path, position+1, visited_nodes):
                    return True
                visited_nodes[next_node] = False
                current_path[position] = -1
        return False
    
    def locate_hamilton_cycle(self):
        if len(self.node_set) < 3:
            return None
        path = [-1] * len(self.node_set)
        visited_nodes = {node: False for node in self.node_set}
        first_node = next(iter(self.node_set))
        path[0] = first_node
        visited_nodes[first_node] = True
        if not self._search_hamilton_cycle(path, 1, visited_nodes):
            return None
        return path + [path[0]]
    
    def __str__(self):
        output_lines = []
        output_lines.append(f"Граф ({'ориентированный' if self.is_directed else 'неориентированный'})")
        output_lines.append("Вершины: " + ", ".join(map(str, sorted(self.node_set))))
        output_lines.append("Рёбра:")
        for node1, node2, cost in self.get_all_connections():
            output_lines.append(f"  {node1} -> {node2} (вес: {cost})")
        return "\n".join(output_lines)


class GraphProgram:
    def __init__(self):
        self.current_graph = None
    
    def setup_graph(self):
        print("\n=== Настройка графа ===")
        print("Выберите тип графа:")
        print("1. Неориентированный")
        print("2. Ориентированный")
        
        user_choice = input("Ваш выбор (1-2): ").strip()
        
        if user_choice == "1":
            self.current_graph = Graph(directed=False)
            print("Создан неориентированный граф")
        elif user_choice == "2":
            self.current_graph = Graph(directed=True)
            print("Создан ориентированный граф")
        else:
            print("Неверный ввод, создан неориентированный граф")
            self.current_graph = Graph(directed=False)
    
    def display_main_menu(self):
        print("\n" + "="*50)
        print("           СИСТЕМА РАБОТЫ С ГРАФАМИ")
        print("="*50)
        print("1.  Добавить вершину")
        print("2.  Создать ребро")
        print("3.  Удалить вершину")
        print("4.  Удалить ребро")
        print("5.  Отобразить граф")
        print("6.  Обход в ширину")
        print("7.  Обход в глубину")
        print("8.  Кратчайшие пути (Дейкстра)")
        print("9.  Проверить связность")
        print("10. Найти цикл Эйлера")
        print("11. Найти цикл Гамильтона")
        print("12. Показать смежные вершины")
        print("13. Показать степень вершины")
        print("14. Создать новый граф")
        print("0.  Завершить работу")
        print("="*50)
    
    def handle_add_node(self):
        if self.current_graph is None:
            print("Сначала создайте граф!")
            return
        node_name = input("Введите название вершины: ").strip()
        if node_name:
            self.current_graph.insert_node(node_name)
            print(f"Вершина '{node_name}' создана")
        else:
            print("Некорректное название")
    
    def handle_add_edge(self):
        if self.current_graph is None:
            print("Сначала создайте граф!")
            return
        node_a = input("Введите первую вершину: ").strip()
        node_b = input("Введите вторую вершину: ").strip()
        weight_input = input("Введите вес ребра (по умолчанию 1): ").strip()
        try:
            edge_weight = float(weight_input) if weight_input else 1
        except ValueError:
            print("Некорректный вес, используется 1")
            edge_weight = 1
        if node_a and node_b:
            self.current_graph.connect_nodes(node_a, node_b, edge_weight)
            print(f"Создано ребро {node_a} - {node_b} с весом {edge_weight}")
        else:
            print("Некорректные вершины")
    
    def handle_remove_node(self):
        if self.current_graph is None:
            print("Сначала создайте граф!")
            return
        node_name = input("Введите вершину для удаления: ").strip()
        if node_name and self.current_graph.node_exists(node_name):
            self.current_graph.delete_node(node_name)
            print(f"Вершина '{node_name}' удалена")
        else:
            print("Вершина не найдена")
    
    def handle_remove_edge(self):
        if self.current_graph is None:
            print("Сначала создайте граф!")
            return
        node_a = input("Введите первую вершину: ").strip()
        node_b = input("Введите вторую вершину: ").strip()
        if node_a and node_b and self.current_graph.connection_exists(node_a, node_b):
            self.current_graph.disconnect_nodes(node_a, node_b)
            print(f"Ребро {node_a} - {node_b} удалено")
        else:
            print("Ребро не найдено")
    
    def display_current_graph(self):
        if self.current_graph is None:
            print("Граф не создан!")
            return
        print("\n" + str(self.current_graph))
    
    def handle_bfs(self):
        if self.current_graph is None:
            print("Сначала создайте граф!")
            return
        start_node = input("Введите стартовую вершину: ").strip()
        if start_node and self.current_graph.node_exists(start_node):
            bfs_result = self.current_graph.breadth_first_search(start_node)
            print(f"BFS от '{start_node}': {bfs_result}")
        else:
            print("Вершина не найдена")
    
    def handle_dfs(self):
        if self.current_graph is None:
            print("Сначала создайте граф!")
            return
        start_node = input("Введите стартовую вершину: ").strip()
        if start_node and self.current_graph.node_exists(start_node):
            dfs_result = self.current_graph.depth_first_search(start_node)
            print(f"DFS от '{start_node}': {dfs_result}")
        else:
            print("Вершина не найдена")
    
    def handle_dijkstra(self):
        if self.current_graph is None:
            print("Сначала создайте граф!")
            return
        start_node = input("Введите стартовую вершину: ").strip()
        if start_node and self.current_graph.node_exists(start_node):
            shortest_paths = self.current_graph.compute_shortest_paths(start_node)
            print(f"Кратчайшие пути от '{start_node}':")
            for node, distance in shortest_paths.items():
                print(f"  {node}: {distance}")
        else:
            print("Вершина не найдена")
    
    def handle_connectivity(self):
        if self.current_graph is None:
            print("Сначала создайте граф!")
            return
        if self.current_graph.is_directed:
            print("Для ориентированных графов не поддерживается")
        else:
            is_connected = self.current_graph.check_connectivity()
            status = "связный" if is_connected else "несвязный"
            print(f"Граф {status}")
    
    def handle_euler_cycle(self):
        if self.current_graph is None:
            print("Сначала создайте граф!")
            return
        if self.current_graph.is_directed:
            print("Для ориентированных графов не поддерживается")
            return
        has_euler = self.current_graph.can_have_euler_cycle()
        print(f"Цикл Эйлера {'существует' if has_euler else 'не существует'}")
        if has_euler:
            euler_cycle = self.current_graph.locate_euler_cycle()
            print(f"Цикл Эйлера: {euler_cycle}")
    
    def handle_hamilton_cycle(self):
        if self.current_graph is None:
            print("Сначала создайте граф!")
            return
        hamilton_cycle = self.current_graph.locate_hamilton_cycle()
        if hamilton_cycle:
            print(f"Цикл Гамильтона: {hamilton_cycle}")
        else:
            print("Цикл Гамильтона не найден")
    
    def handle_show_neighbors(self):
        if self.current_graph is None:
            print("Сначала создайте граф!")
            return
        node_name = input("Введите вершину: ").strip()
        if node_name and self.current_graph.node_exists(node_name):
            neighbors = self.current_graph.get_adjacent_nodes(node_name)
            print(f"Смежные вершины для '{node_name}': {neighbors}")
        else:
            print("Вершина не найдена")
    
    def handle_show_degree(self):
        if self.current_graph is None:
            print("Сначала создайте граф!")
            return
        node_name = input("Введите вершину: ").strip()
        if node_name and self.current_graph.node_exists(node_name):
            degree_info = self.current_graph.calculate_node_degree(node_name)
            if self.current_graph.is_directed:
                print(f"Степень вершины '{node_name}': входящая {degree_info[0]}, исходящая {degree_info[1]}")
            else:
                print(f"Степень вершины '{node_name}': {degree_info}")
        else:
            print("Вершина не найдена")
    
    def start_program(self):
        print("Программа для работы с графами")
        self.setup_graph()
        while True:
            self.display_main_menu()
            user_choice = input("Выберите действие (0-14): ").strip()
            if user_choice == "0":
                print("Завершение работы...")
                break
            elif user_choice == "1":
                self.handle_add_node()
            elif user_choice == "2":
                self.handle_add_edge()
            elif user_choice == "3":
                self.handle_remove_node()
            elif user_choice == "4":
                self.handle_remove_edge()
            elif user_choice == "5":
                self.display_current_graph()
            elif user_choice == "6":
                self.handle_bfs()
            elif user_choice == "7":
                self.handle_dfs()
            elif user_choice == "8":
                self.handle_dijkstra()
            elif user_choice == "9":
                self.handle_connectivity()
            elif user_choice == "10":
                self.handle_euler_cycle()
            elif user_choice == "11":
                self.handle_hamilton_cycle()
            elif user_choice == "12":
                self.handle_show_neighbors()
            elif user_choice == "13":
                self.handle_show_degree()
            elif user_choice == "14":
                self.setup_graph()
            else:
                print("Неверный выбор!")
            input("\nНажмите Enter для продолжения...")


if __name__ == "__main__":
    graph_app = GraphProgram()
    graph_app.start_program()
```

    Программа для работы с графами
    
    === Настройка графа ===
    Выберите тип графа:
    1. Неориентированный
    2. Ориентированный


    Ваш выбор (1-2):  1


    Создан неориентированный граф
    
    ==================================================
               СИСТЕМА РАБОТЫ С ГРАФАМИ
    ==================================================
    1.  Добавить вершину
    2.  Создать ребро
    3.  Удалить вершину
    4.  Удалить ребро
    5.  Отобразить граф
    6.  Обход в ширину
    7.  Обход в глубину
    8.  Кратчайшие пути (Дейкстра)
    9.  Проверить связность
    10. Найти цикл Эйлера
    11. Найти цикл Гамильтона
    12. Показать смежные вершины
    13. Показать степень вершины
    14. Создать новый граф
    0.  Завершить работу
    ==================================================


    Выберите действие (0-14):  5


    
    Граф (неориентированный)
    Вершины: 
    Рёбра:


    
    Нажмите Enter для продолжения... 


    
    ==================================================
               СИСТЕМА РАБОТЫ С ГРАФАМИ
    ==================================================
    1.  Добавить вершину
    2.  Создать ребро
    3.  Удалить вершину
    4.  Удалить ребро
    5.  Отобразить граф
    6.  Обход в ширину
    7.  Обход в глубину
    8.  Кратчайшие пути (Дейкстра)
    9.  Проверить связность
    10. Найти цикл Эйлера
    11. Найти цикл Гамильтона
    12. Показать смежные вершины
    13. Показать степень вершины
    14. Создать новый граф
    0.  Завершить работу
    ==================================================


    Выберите действие (0-14):  


    Неверный выбор!


    
    Нажмите Enter для продолжения... 


    
    ==================================================
               СИСТЕМА РАБОТЫ С ГРАФАМИ
    ==================================================
    1.  Добавить вершину
    2.  Создать ребро
    3.  Удалить вершину
    4.  Удалить ребро
    5.  Отобразить граф
    6.  Обход в ширину
    7.  Обход в глубину
    8.  Кратчайшие пути (Дейкстра)
    9.  Проверить связность
    10. Найти цикл Эйлера
    11. Найти цикл Гамильтона
    12. Показать смежные вершины
    13. Показать степень вершины
    14. Создать новый граф
    0.  Завершить работу
    ==================================================


    Выберите действие (0-14):  


    Неверный выбор!


    
    Нажмите Enter для продолжения... 


    
    ==================================================
               СИСТЕМА РАБОТЫ С ГРАФАМИ
    ==================================================
    1.  Добавить вершину
    2.  Создать ребро
    3.  Удалить вершину
    4.  Удалить ребро
    5.  Отобразить граф
    6.  Обход в ширину
    7.  Обход в глубину
    8.  Кратчайшие пути (Дейкстра)
    9.  Проверить связность
    10. Найти цикл Эйлера
    11. Найти цикл Гамильтона
    12. Показать смежные вершины
    13. Показать степень вершины
    14. Создать новый граф
    0.  Завершить работу
    ==================================================


    Выберите действие (0-14):  


    Неверный выбор!


    
    Нажмите Enter для продолжения... 


    
    ==================================================
               СИСТЕМА РАБОТЫ С ГРАФАМИ
    ==================================================
    1.  Добавить вершину
    2.  Создать ребро
    3.  Удалить вершину
    4.  Удалить ребро
    5.  Отобразить граф
    6.  Обход в ширину
    7.  Обход в глубину
    8.  Кратчайшие пути (Дейкстра)
    9.  Проверить связность
    10. Найти цикл Эйлера
    11. Найти цикл Гамильтона
    12. Показать смежные вершины
    13. Показать степень вершины
    14. Создать новый граф
    0.  Завершить работу
    ==================================================


    Выберите действие (0-14):  


    Неверный выбор!


    
    Нажмите Enter для продолжения... 


    
    ==================================================
               СИСТЕМА РАБОТЫ С ГРАФАМИ
    ==================================================
    1.  Добавить вершину
    2.  Создать ребро
    3.  Удалить вершину
    4.  Удалить ребро
    5.  Отобразить граф
    6.  Обход в ширину
    7.  Обход в глубину
    8.  Кратчайшие пути (Дейкстра)
    9.  Проверить связность
    10. Найти цикл Эйлера
    11. Найти цикл Гамильтона
    12. Показать смежные вершины
    13. Показать степень вершины
    14. Создать новый граф
    0.  Завершить работу
    ==================================================


    Выберите действие (0-14):  


    Неверный выбор!


    
    Нажмите Enter для продолжения... 


    
    ==================================================
               СИСТЕМА РАБОТЫ С ГРАФАМИ
    ==================================================
    1.  Добавить вершину
    2.  Создать ребро
    3.  Удалить вершину
    4.  Удалить ребро
    5.  Отобразить граф
    6.  Обход в ширину
    7.  Обход в глубину
    8.  Кратчайшие пути (Дейкстра)
    9.  Проверить связность
    10. Найти цикл Эйлера
    11. Найти цикл Гамильтона
    12. Показать смежные вершины
    13. Показать степень вершины
    14. Создать новый граф
    0.  Завершить работу
    ==================================================


    Выберите действие (0-14):  


    Неверный выбор!


    
    Нажмите Enter для продолжения... 


    
    ==================================================
               СИСТЕМА РАБОТЫ С ГРАФАМИ
    ==================================================
    1.  Добавить вершину
    2.  Создать ребро
    3.  Удалить вершину
    4.  Удалить ребро
    5.  Отобразить граф
    6.  Обход в ширину
    7.  Обход в глубину
    8.  Кратчайшие пути (Дейкстра)
    9.  Проверить связность
    10. Найти цикл Эйлера
    11. Найти цикл Гамильтона
    12. Показать смежные вершины
    13. Показать степень вершины
    14. Создать новый граф
    0.  Завершить работу
    ==================================================


    Выберите действие (0-14):  


    Неверный выбор!


    
    Нажмите Enter для продолжения... 


    
    ==================================================
               СИСТЕМА РАБОТЫ С ГРАФАМИ
    ==================================================
    1.  Добавить вершину
    2.  Создать ребро
    3.  Удалить вершину
    4.  Удалить ребро
    5.  Отобразить граф
    6.  Обход в ширину
    7.  Обход в глубину
    8.  Кратчайшие пути (Дейкстра)
    9.  Проверить связность
    10. Найти цикл Эйлера
    11. Найти цикл Гамильтона
    12. Показать смежные вершины
    13. Показать степень вершины
    14. Создать новый граф
    0.  Завершить работу
    ==================================================


    Выберите действие (0-14):  


    Неверный выбор!


    
    Нажмите Enter для продолжения... 


    
    ==================================================
               СИСТЕМА РАБОТЫ С ГРАФАМИ
    ==================================================
    1.  Добавить вершину
    2.  Создать ребро
    3.  Удалить вершину
    4.  Удалить ребро
    5.  Отобразить граф
    6.  Обход в ширину
    7.  Обход в глубину
    8.  Кратчайшие пути (Дейкстра)
    9.  Проверить связность
    10. Найти цикл Эйлера
    11. Найти цикл Гамильтона
    12. Показать смежные вершины
    13. Показать степень вершины
    14. Создать новый граф
    0.  Завершить работу
    ==================================================


    Выберите действие (0-14):  0


    Завершение работы...



```python
from collections import deque, defaultdict
import heapq

class Graph:
    def __init__(self, directed=False):
        self.adjacency = defaultdict(dict)
        self.is_directed = directed
        self.node_set = set()
    
    def insert_node(self, node):
        self.node_set.add(node)
        if node not in self.adjacency:
            self.adjacency[node] = {}
    
    def connect_nodes(self, node1, node2, cost=1):
        self.insert_node(node1)
        self.insert_node(node2)
        self.adjacency[node1][node2] = cost
        if not self.is_directed:
            self.adjacency[node2][node1] = cost
    
    def compute_shortest_path(self, start_node, end_node):
        if start_node not in self.adjacency or end_node not in self.adjacency:
            return None, float('infinity')
        
        path_costs = {node: float('infinity') for node in self.node_set}
        previous_nodes = {node: None for node in self.node_set}
        path_costs[start_node] = 0
        min_heap = [(0, start_node)]
        
        while min_heap:
            current_cost, current_node = heapq.heappop(min_heap)
            
            if current_cost > path_costs[current_node]:
                continue
                
            if current_node == end_node:
                break
                
            for neighbor, edge_cost in self.adjacency[current_node].items():
                total_cost = current_cost + edge_cost
                if total_cost < path_costs[neighbor]:
                    path_costs[neighbor] = total_cost
                    previous_nodes[neighbor] = current_node
                    heapq.heappush(min_heap, (total_cost, neighbor))
        
        if path_costs[end_node] == float('infinity'):
            return None, float('infinity')
        
        path = []
        current = end_node
        while current is not None:
            path.append(current)
            current = previous_nodes[current]
        
        return path[::-1], path_costs[end_node]
    
    def get_path_details(self, path):
        if not path or len(path) < 2:
            return "", 0
        
        total_cost = 0
        details = []
        
        for i in range(len(path) - 1):
            u, v = path[i], path[i + 1]
            edge_cost = self.adjacency[u][v]
            total_cost += edge_cost
            details.append(f"{u}→{v}({edge_cost})")
        
        return " → ".join(details), total_cost

def create_weighted_graph():
    graph = Graph(directed=False)
    
    edges_with_weights = [
        (1, 3, 12), (1, 2, 10), (2, 3, 1), (2, 4, 11),
        (2, 5, 3), (5, 7, 9), (4, 6, 1), (6, 7, 2),
        (3, 6, 8), (3, 7, 10)
    ]
    
    for u, v, weight in edges_with_weights:
        graph.connect_nodes(u, v, weight)
    
    return graph

def find_all_paths(graph, start, end, path=None, visited=None):
    if path is None:
        path = []
    if visited is None:
        visited = set()
    
    path = path + [start]
    visited.add(start)
    
    if start == end:
        return [path]
    
    paths = []
    for neighbor in graph.adjacency[start]:
        if neighbor not in visited:
            new_paths = find_all_paths(graph, neighbor, end, path, visited.copy())
            paths.extend(new_paths)
    
    return paths

def main():
    graph = create_weighted_graph()
    
    start_node = 2
    end_node = 6
    
    print("Взвешенный неориентированный граф:")
    print("Вершины:", sorted(graph.node_set))
    print("Рёбра с весами:")
    for node in sorted(graph.adjacency.keys()):
        for neighbor, weight in sorted(graph.adjacency[node].items()):
            if node <= neighbor:
                print(f"  {node} — {neighbor} (вес: {weight})")
    
    print(f"\nПоиск кратчайшего пути от {start_node} до {end_node}:")
    
    path, total_distance = graph.compute_shortest_path(start_node, end_node)
    
    if path:
        path_details, calculated_distance = graph.get_path_details(path)
        print(f"Кратчайший путь: {path_details}")
        print(f"Общая длина пути: {total_distance}")
        print(f"Вершины пути: {' → '.join(map(str, path))}")
    else:
        print("Путь не найден")
    

    print(f"\nАнализ всех возможных путей от {start_node} до {end_node}:")
    all_paths = find_all_paths(graph, start_node, end_node)
    
    paths_with_costs = []
    for path in all_paths:
        details, cost = graph.get_path_details(path)
        paths_with_costs.append((path, cost, details))
    
    paths_with_costs.sort(key=lambda x: x[1])
    
    for i, (path, cost, details) in enumerate(paths_with_costs, 1):
        print(f"{i}. Путь: {details} | Суммарный вес: {cost}")

if __name__ == "__main__":
    main()
```

    Взвешенный неориентированный граф:
    Вершины: [1, 2, 3, 4, 5, 6, 7]
    Рёбра с весами:
      1 — 2 (вес: 10)
      1 — 3 (вес: 12)
      2 — 3 (вес: 1)
      2 — 4 (вес: 11)
      2 — 5 (вес: 3)
      3 — 6 (вес: 8)
      3 — 7 (вес: 10)
      4 — 6 (вес: 1)
      5 — 7 (вес: 9)
      6 — 7 (вес: 2)
    
    Поиск кратчайшего пути от 2 до 6:
    Кратчайший путь: 2→3(1) → 3→6(8)
    Общая длина пути: 9
    Вершины пути: 2 → 3 → 6
    
    Анализ всех возможных путей от 2 до 6:
    1. Путь: 2→3(1) → 3→6(8) | Суммарный вес: 9
    2. Путь: 2→4(11) → 4→6(1) | Суммарный вес: 12
    3. Путь: 2→3(1) → 3→7(10) → 7→6(2) | Суммарный вес: 13
    4. Путь: 2→5(3) → 5→7(9) → 7→6(2) | Суммарный вес: 14
    5. Путь: 2→1(10) → 1→3(12) → 3→6(8) | Суммарный вес: 30
    6. Путь: 2→5(3) → 5→7(9) → 7→3(10) → 3→6(8) | Суммарный вес: 30
    7. Путь: 2→1(10) → 1→3(12) → 3→7(10) → 7→6(2) | Суммарный вес: 34



```python
import heapq
from collections import defaultdict

class Graph:
    def __init__(self):
        self.graph = defaultdict(dict)
    
    def add_edge(self, u, v, weight):
        self.graph[u][v] = weight
        self.graph[v][u] = weight  
    
    def dijkstra(self, start, end):
        distances = {node: float('infinity') for node in self.graph}
        previous_nodes = {node: None for node in self.graph}
        distances[start] = 0
        
        priority_queue = [(0, start)]
        
        while priority_queue:
            current_distance, current_node = heapq.heappop(priority_queue)
            
            if current_node == end:
                break
                
            if current_distance > distances[current_node]:
                continue
                

            for neighbor, weight in self.graph[current_node].items():
                distance = current_distance + weight
                
            
                if distance < distances[neighbor]:
                    distances[neighbor] = distance
                    previous_nodes[neighbor] = current_node
                    heapq.heappush(priority_queue, (distance, neighbor))
        
        path = []
        current = end
        while current is not None:
            path.append(current)
            current = previous_nodes[current]
        path.reverse()
        
        return path, distances[end]

def main():

    graph = Graph()
    

    edges = [
        (1, 2, 2),
        (2, 3, 1),
        (3, 4, 17),
        (1, 5, 3),
        (1, 6, 10),
        (2, 7, 35),
        (4, 7, 13),
        (5, 6, 11),
        (6, 7, 15),
        (5, 8, 20),
        (6, 8, 12),
        (7, 8, 10)
    ]
    
    for u, v, weight in edges:
        graph.add_edge(u, v, weight)
    

    start_node = 1
    end_node = 6
    
    path, total_distance = graph.dijkstra(start_node, end_node)
    
    print("Граф:")
    print("Вершины: 1-8")
    print("Рёбра с весами:")
    for u, v, weight in edges:
        print(f"  {u} - {v}: {weight}")
    
    print(f"\nПоиск кратчайшего пути от {start_node} до {end_node}:")
    
    if path:
        print(f"Кратчайший путь: {' → '.join(map(str, path))}")
        print(f"Длина пути: {total_distance}")
        

        print("\nДетали пути:")
        total = 0
        for i in range(len(path) - 1):
            u, v = path[i], path[i + 1]
            weight = graph.graph[u][v]
            total += weight
            print(f"  {u} → {v}: {weight}")
        print(f"Общая сумма: {total}")
    else:
        print("Путь не найден")
    

    print(f"\nАнализ возможных путей от {start_node} до {end_node}:")
    

    direct_path = [1, 6]
    direct_weight = graph.graph[1][6]
    print(f"Прямой путь 1→6: вес = {direct_weight}")

    path_via_5 = [1, 5, 6]
    weight_via_5 = graph.graph[1][5] + graph.graph[5][6]
    print(f"Путь через 5: 1→5→6: вес = {weight_via_5}")
    

    path_via_2_3 = [1, 2, 3, 4, 7, 6]
    weight_via_2_3 = (graph.graph[1][2] + graph.graph[2][3] + 
                     graph.graph[3][4] + graph.graph[4][7] + 
                     graph.graph[7][6])
    print(f"Путь через 2-3-4-7: 1→2→3→4→7→6: вес = {weight_via_2_3}")

if __name__ == "__main__":
    main()
```

    Граф:
    Вершины: 1-8
    Рёбра с весами:
      1 - 2: 2
      2 - 3: 1
      3 - 4: 17
      1 - 5: 3
      1 - 6: 10
      2 - 7: 35
      4 - 7: 13
      5 - 6: 11
      6 - 7: 15
      5 - 8: 20
      6 - 8: 12
      7 - 8: 10
    
    Поиск кратчайшего пути от 1 до 6:
    Кратчайший путь: 1 → 6
    Длина пути: 10
    
    Детали пути:
      1 → 6: 10
    Общая сумма: 10
    
    Анализ возможных путей от 1 до 6:
    Прямой путь 1→6: вес = 10
    Путь через 5: 1→5→6: вес = 14
    Путь через 2-3-4-7: 1→2→3→4→7→6: вес = 48



```python

```
