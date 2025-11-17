# Л.Р. 8 - "Двоичные деревья поиска"

**Цао М.М.**
**ИУ10-36**

### Задания
### Задание №1 - Реализовать программу, выполняющую стандартный набор операций над двоичным деревом поиска:
**1) Формирование бинарного дерева:**
```python
def insert(self, value):
        if self._search_node(self.root, value) is not None:
            return False
        
        self.root = self._insert_node(self.root, value)
        return True

def _insert_node(self, node, value):
    if node is None:
        return TreeNode(value)
        
    if value < node.value:
        node.left = self._insert_node(node.left, value)
    elif value > node.value:
        node.right = self._insert_node(node.right, value)
        
    return node
```

**2) Обход (прямой, симметричный, обратный) бинарного дерева:**
```python
# Прямой обход
def _preorder(self, node, result):
        if node:
            result.append(node.value)
            self._preorder(node.left, result)
            self._preorder(node.right, result)
            
#Симметричный обход
def _inorder(self, node, result):
        if node:
            self._inorder(node.left, result)
            result.append(node.value)
            self._inorder(node.right, result)

#Обратный обход
def _postorder(self, node, result):
        if node:
            self._postorder(node.left, result)
            self._postorder(node.right, result)
            result.append(node.value)

```

**3) Удаление заданной вершины из бинарного дерева:**
```python
def delete(self, value):
        if self.is_empty():
            return False
        
        if self._search_node(self.root, value) is None:
            return False
        
        self.root = self._delete_node(self.root, value)
        return True

def _delete_node(self, node, value):
    if node is None:
        return node
    
    if value < node.value:
        node.left = self._delete_node(node.left, value)
    elif value > node.value:
        node.right = self._delete_node(node.right, value)
    else:
        # Случай 1: Нет левого потомка
        if node.left is None:
            return node.right
        # Случай 2: Нет правого потомка  
        elif node.right is None:
            return node.left
        
        # Случай 3: Есть оба потомка
        min_node = self._find_min(node.right)
        node.value = min_node.value
        node.right = self._delete_node(node.right, min_node.value)
    
    return node
    
def _find_min(self, node):
        current = node
        while current and current.left:
            current = current.left
        return current
```

**4) Поиск заданной вершины в бинарном дереве (по значению):**
```python
def search(self, value):
        return self._search_node(self.root, value) is not None

def _search_node(self, node, value):
    if node is None or node.value == value:
        return node
        
    if value < node.value:
        return self._search_node(node.left, value)
    else:
        return self._search_node(node.right, value)
```

**5) Печать бинарного дерева на экран:**
```python
def print_tree(self):
        lines = []
        self._print_tree_recursive(self.root, 0, "Root", lines)
        return "\n".join(lines)

def _print_tree_recursive(self, node, level, prefix, lines):
    if node is not None:
        lines.append(" " * (level * 4) + prefix + ": " + str(node.value))
        if node.left or node.right:
            if node.left:
                self._print_tree_recursive(node.left, level + 1, "L", lines)
            else:
                lines.append(" " * ((level + 1) * 4) + "L: None")
            if node.right:
                self._print_tree_recursive(node.right, level + 1, "R", lines)
            else:
                lines.append(" " * ((level + 1) * 4) + "R: None")
```

**6) Проверка пустоты бинарного дерева:**
```python
def is_empty(self):
    return self.root is None
```

**7) Определение высоты бинарного дерева:**
```python
def _calculate_height(self, node):
        if node is None:
            return 0
        
        left_height = self._calculate_height(node.left)
        right_height = self._calculate_height(node.right)
        
        return max(left_height, right_height) + 1
```


### Задание №2 - Реализовать самобалансирующееся (AVL) дерево:
```python
# Правый поворот
def rotate_right(self, y):  
    x = y.left
    T2 = x.right
    
    x.right = y
    y.left = T2
    
    y.height = 1 + max(self.get_height(y.left), self.get_height(y.right))
    x.height = 1 + max(self.get_height(x.left), self.get_height(x.right))
    
    return x

# Левый поворот
def rotate_left(self, x):  
    y = x.right
    T2 = y.left
    
    y.left = x
    x.right = T2
    
    x.height = 1 + max(self.get_height(x.left), self.get_height(x.right))
    y.height = 1 + max(self.get_height(y.left), self.get_height(y.right))
    
    return y

### Балансировка после вставки

balance = self.get_balance(node)

# LL случай
if balance > 1 and key < node.left.key:    
    return self.rotate_right(node)

 # RR случай  
if balance < -1 and key > node.right.key: 
    return self.rotate_left(node)

# LR случай
if balance > 1 and key > node.left.key:    
    node.left = self.rotate_left(node.left)
    return self.rotate_right(node)

# RL случай
if balance < -1 and key < node.right.key:  
    node.right = self.rotate_right(node.right)
    return self.rotate_left(node)
```


### Задание №3 - Объединить два бинарных дерева поиска:
```python
def merge_trees(root1, root2):
    # Получаем отсортированные массивы из обоих деревьев
    arr1 = get_values(root1)
    arr2 = get_values(root2)
    
    # Сливаем массивы в один отсортированный
    merged = merge(arr1, arr2)
    
    # Строим сбалансированное дерево из отсортированного массива
    return make_tree(merged)

### Слияние двух отсортированных массивов
def merge(arr1, arr2):
    result = []
    i = j = 0
    while i < len(arr1) and j < len(arr2):
        if arr1[i] < arr2[j]:
            result.append(arr1[i])
            i += 1
        else:
            result.append(arr2[j])
            j += 1
    result.extend(arr1[i:])
    result.extend(arr2[j:])
    return result
```


**Выводы:**
1) Большинство операций (обход, поиск, вставка) интуитивно реализуются через рекурсию, что соответствует иерархической природе древовидных структур и значительно упрощает код.
2) Обычное BST может выродиться в связный список с O(n) временем операций, тогда как AVL-дерево гарантирует O(log n) благодаря автоматической балансировке после каждой модификации.
3) Удаление требует обработки трех различных случаев (0, 1 или 2 потомка), особенно сложен случай с двумя потомками, где необходимо найти замену и сохранить свойства дерева.
4) Прямой, симметричный и обратный обходы имеют различные применения - от сериализации данных до вычисления выражений и освобождения памяти.
5) BST и их сбалансированные варианты находят применение в множестве областей - от баз данных и компиляторов до алгоритмов сжатия, обеспечивая эффективный поиск и хранение упорядоченных данных.
6) Эффективное объединение двух BST осуществляется через преобразование в отсортированные массивы с последующим построением сбалансированного дерева, что обеспечивает оптимальную структуру результата.
7) Хотя AVL-дерево гарантирует логарифмическое время операций, это достигается за счет хранения высоты узлов и выполнения поворотов, что увеличивает сложность реализации и потребление памяти.
8) Преобразование AVL-дерева в связный список имеет сложность O(N), так как требует обхода всех узлов дерева. 