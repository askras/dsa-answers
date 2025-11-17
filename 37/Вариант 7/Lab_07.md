# Алгоритмы на графах
Фомин И.Н.
ИУ10-37
## Задания
### Задание 1
Реализовать программу, выполняющую описанный набор операций на графах:

Требования:
 - граф должен быть реализован в виде класса;
 - каждая операция должна быть реализована как метод класса.


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


```

### Задание 2
Реализовать приложение, для работы с графом, которое реализует следующий набор действий:  
а) инициализация графа;  
б) организация диалогового цикла с пользователем;


```python
def menu():
    print("""
========= МЕНЮ =========
1 - Добавить ребро
2 - Поиск в глубину
3 - Поиск в ширину
4 - Эйлеров цикл
5 - Гамильтонов цикл
6 - Алгоритм Дейкстры
0 - Выход
========================
""")


def main():
    print("Приложение для работы с графом")

    n = int(input("Введите количество вершин графа: "))
    directed = input("Ориентированный граф? (y/n): ").lower() == 'y'

    graph = Graph(n, directed)

    while True:
        menu()
        choice = input("Выберите действие: ")

        if choice == "1":
            u = int(input("Откуда: "))
            v = int(input("Куда: "))
            w = int(input("Вес ребра: "))
            graph.add_edge(u, v, w)
            print("Ребро добавлено")

        elif choice == "2":
            start = int(input("Начальная вершина: "))
            end = int(input("Конечная вершина: "))
            print("Depth search:", graph.depth_search(graph.get_vertex(start), graph.get_vertex(end)))

        elif choice == "3":
            start = int(input("Начальная вершина: "))
            end = int(input("Конечная вершина: "))
            print("Wide seach:", graph.wide_search(graph.get_vertex(start), graph.get_vertex(end)))

        elif choice == "4":
            start = int(input("Начальная вершина: "))
            cycle = graph.euler_cycle(start)
            if cycle:
                print("Эйлеров цикл:", cycle)
            else:
                print("Эйлеров цикл не существует")

        elif choice == "5":
            cycle = graph.hamilton_cycle()
            if cycle:
                print("Гамильтонов цикл:", cycle)
            else:
                print("Гамильтонов цикл не существует")

        elif choice == "6":
            start = int(input("Начальная вершина: "))
            end = int(input("Конечная вершина: "))
            dist = graph.dijkstra(graph.get_vertex(start), graph.get_vertex(end))
            print("Кратчайший путь от вершины", start, "до", end)
            print("Длина пути: ", dist[0], "Путь: ", dist[1])

        elif choice == "0":
            print("Работа программы завершена")
            break

        else:
            print("Неверный пункт меню!")


if __name__ == "__main__":
    main()

```

    Приложение для работы с графом
    
    ========= МЕНЮ =========
    1 - Добавить ребро
    2 - Поиск в глубину
    3 - Поиск в ширину
    4 - Эйлеров цикл
    5 - Гамильтонов цикл
    6 - Алгоритм Дейкстры
    0 - Выход
    ========================
    
    Работа программы завершена


### Задание 3
Реализовать индивидуальные задание.

### Задание 4 (по вариантам)
Найти кратчайший путь на графе между парами вершин ориентированного графа:


```python
graph = Graph(7, True)

graph.add_edge(1, 2, 1)
graph.add_edge(1, 3, 2)
graph.add_edge(2, 3, 3)
graph.add_edge(3, 4, 6)
graph.add_edge(2, 4, 14)
graph.add_edge(4, 5, 4)
graph.add_edge(4, 6, 10)
graph.add_edge(3, 5, 9)
graph.add_edge(5, 6, 7)
graph.add_edge(5, 7, 12)
graph.add_edge(6, 7, 2)

paths = graph.wide_search(graph.get_vertex(1), graph.get_vertex(6))

minimum = (float("inf"), [])
for path in paths:
    path_len = 0
    for vertex in path:
        path_len += vertex[1]
    minimum = (path_len, [i[0] for i in path]) if min(path_len, minimum[0]) == path_len else minimum
print(minimum)

```

    (18, [1, 3, 5, 6])


### Задание 5 (по вариантам)
Реализовать алгоритм Дейкстры поиска кратчайшего пути на графе между парами вершин:


```python
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


### Задание 6 (по вариантам)
Реализовать прогрммно один из алгоритмов поиска кратчайшего пути на графе между парами вершин из задания 5:


```python
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

paths = graph.depth_search(graph.get_vertex(8), graph.get_vertex(2))

minimum = (float("inf"), [])
for path in paths:
    path_len = 0
    for vertex in path:
        path_len += vertex[1]
    minimum = (path_len, [i[0] for i in path]) if min(path_len, minimum[0]) == path_len else minimum
print(minimum)
```

    (7, [8, 7, 2])

