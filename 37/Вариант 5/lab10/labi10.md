```python
def fractional_knapsack(capacity, items):
    sorted_items = sorted(items, key=lambda x: x[0]/x[1], reverse=True)
    
    total_value = 0.0
    current_weight = 0.0
    selected_items = []
    
    for value, weight, *rest in sorted_items:
        if current_weight + weight <= capacity:
            total_value += value
            current_weight += weight
            selected_items.append((value, weight, 1.0))
        else:
            remaining_capacity = capacity - current_weight
            fraction = remaining_capacity / weight
            total_value += value * fraction
            selected_items.append((value, weight, fraction))
            break
    
    return total_value, selected_items

def fractional_knapsack_with_quantities(capacity, items):
    expanded_items = []
    for value, weight, quantity in items:
        expanded_items.extend([(value, weight)] * quantity)
    
    sorted_items = sorted(expanded_items, key=lambda x: x[0]/x[1], reverse=True)
    
    total_value = 0.0
    current_weight = 0.0
    selected_items = []
    
    for value, weight in sorted_items:
        if current_weight >= capacity:
            break
            
        if current_weight + weight <= capacity:
            total_value += value
            current_weight += weight
            selected_items.append((value, weight, 1.0))
        else:
            remaining_capacity = capacity - current_weight
            fraction = remaining_capacity / weight
            total_value += value * fraction
            selected_items.append((value, weight, fraction))
            break
    
    return total_value, selected_items
```


```python
def segment_cover(target_segment, segments):
    target_start, target_end = target_segment
    
    valid_segments = []
    for seg in segments:
        seg_start, seg_end = seg
        if seg_end >= target_start and seg_start <= target_end:
            valid_segments.append(seg)
    
    valid_segments.sort(key=lambda x: x[1])
    
    selected_segments = []
    current_position = target_start
    i = 0
    n = len(valid_segments)
    
    while current_position < target_end and i < n:
        best_segment = None
        while i < n and valid_segments[i][0] <= current_position:
            if best_segment is None or valid_segments[i][1] > best_segment[1]:
                best_segment = valid_segments[i]
            i += 1
        
        if best_segment is None:
            return float('inf'), []
        
        selected_segments.append(best_segment)
        current_position = best_segment[1]
    
    if current_position < target_end:
        return float('inf'), []
    
    return len(selected_segments), selected_segments
```


```python
import sys
from typing import List, Tuple, Dict

def floyd_warshall(graph: List[List[int]]) -> Tuple[List[List[int]], List[List[int]]]:
    n = len(graph)
    
    dist = [[0] * n for _ in range(n)]
    next_vertex = [[-1] * n for _ in range(n)]
    
    for i in range(n):
        for j in range(n):
            dist[i][j] = graph[i][j]
            if graph[i][j] != float('inf') and i != j:
                next_vertex[i][j] = j
            elif i == j:
                next_vertex[i][j] = i
    
    for k in range(n):
        for i in range(n):
            for j in range(n):
                if dist[i][k] != float('inf') and dist[k][j] != float('inf'):
                    if dist[i][j] > dist[i][k] + dist[k][j]:
                        dist[i][j] = dist[i][k] + dist[k][j]
                        next_vertex[i][j] = next_vertex[i][k]
    
    return dist, next_vertex

def reconstruct_path(start: int, end: int, next_vertex: List[List[int]]) -> List[int]:
    if next_vertex[start][end] == -1:
        return []
    
    path = [start]
    current = start
    
    while current != end:
        current = next_vertex[current][end]
        path.append(current)
    
    return path

def print_all_pairs_shortest_paths(dist: List[List[int]], next_vertex: List[List[int]]):
    n = len(dist)
    
    print("Матрица кратчайших расстояний:")
    print("    " + "   ".join(f"{i:2}" for i in range(n)))
    print("   " + "-" * (4 * n))
    
    for i in range(n):
        print(f"{i:2}|", end=" ")
        for j in range(n):
            if dist[i][j] == float('inf'):
                print(" INF", end=" ")
            else:
                print(f"{dist[i][j]:4.1f}", end=" ")
        print()
    
    print("\nКратчайшие пути:")
    for i in range(n):
        for j in range(n):
            if i != j:
                path = reconstruct_path(i, j, next_vertex)
                if path:
                    path_str = " -> ".join(map(str, path))
                    print(f"{i} -> {j}: {path_str} (расстояние: {dist[i][j]})")
                else:
                    print(f"{i} -> {j}: пути не существует")

def detect_negative_cycles(dist: List[List[int]]) -> bool:
    n = len(dist)
    for i in range(n):
        if dist[i][i] < 0:
            return True
    return False
```


```python
def coin_change_min_coins(coins, amount):
    dp = [float('inf')] * (amount + 1)
    dp[0] = 0
    
    for i in range(1, amount + 1):
        for coin in coins:
            if i >= coin:
                dp[i] = min(dp[i], dp[i - coin] + 1)
    
    return dp[amount] if dp[amount] != float('inf') else -1

def coin_change_with_reconstruction(coins, amount):
    dp = [float('inf')] * (amount + 1)
    coin_used = [-1] * (amount + 1)
    dp[0] = 0
    
    for i in range(1, amount + 1):
        for coin in coins:
            if i >= coin and dp[i - coin] + 1 < dp[i]:
                dp[i] = dp[i - coin] + 1
                coin_used[i] = coin
    
    if dp[amount] == float('inf'):
        return -1, []
    
    combination = []
    current_amount = amount
    while current_amount > 0:
        coin = coin_used[current_amount]
        combination.append(coin)
        current_amount -= coin
    
    return dp[amount], combination

def coin_change_all_combinations(coins, amount):
    dp = [0] * (amount + 1)
    dp[0] = 1
    
    for coin in coins:
        for i in range(coin, amount + 1):
            dp[i] += dp[i - coin]
    
    return dp[amount]
```


```python
from typing import List, Set, Any

def generate_set_partitions(elements: List[Any]) -> List[List[List[Any]]]:
    if not elements:
        return [[]]
    
    result = []
    first_element = elements[0]
    remaining_elements = elements[1:]
    
    smaller_partitions = generate_set_partitions(remaining_elements)
    
    for partition in smaller_partitions:
        result.append([[first_element]] + partition)
        
        for i in range(len(partition)):
            new_partition = [subset.copy() for subset in partition]
            new_partition[i] = [first_element] + new_partition[i]
            result.append(new_partition)
    
    return result

def bell_number(n: int) -> int:
    if n == 0:
        return 1
    
    bell = [[0] * (n + 1) for _ in range(n + 1)]
    bell[0][0] = 1
    
    for i in range(1, n + 1):
        bell[i][0] = bell[i - 1][i - 1]
        for j in range(1, i + 1):
            bell[i][j] = bell[i - 1][j - 1] + bell[i][j - 1]
    
    return bell[n][0]

def generate_partitions_by_size(elements: List[Any], k: int = 0) -> List[List[List[Any]]]:
    all_partitions = generate_set_partitions(elements)
    
    if k is None:
        return all_partitions
    
    return [partition for partition in all_partitions if len(partition) == k]

def stirling_number_second_kind(n: int, k: int) -> int:
    if k == 0 or n == 0:
        return 0
    if k == 1 or k == n:
        return 1
    if k > n:
        return 0
    
    dp = [[0] * (k + 1) for _ in range(n + 1)]
    
    for i in range(1, n + 1):
        for j in range(1, min(i, k) + 1):
            if j == 1 or i == j:
                dp[i][j] = 1
            else:
                dp[i][j] = dp[i - 1][j - 1] + j * dp[i - 1][j]
    
    return dp[n][k]

def validate_partition(elements: List[Any], partition: List[List[Any]]) -> bool:
    all_elements = [item for subset in partition for item in subset]
    
    if set(all_elements) != set(elements):
        return False
    
    if len(all_elements) != len(elements):
        return False
    
    total_size = sum(len(subset) for subset in partition)
    if total_size != len(elements):
        return False
    
    return True

```


```python

```
