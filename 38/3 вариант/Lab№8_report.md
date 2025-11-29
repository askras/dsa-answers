# Двоичные деревья поиска (Binary Search Tree)
Баскаков Д. С.
ИУ10-38

## Цель работы:
Изучение структуры данных «Двоичное дерево поиска», а также основных операций над ним.
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


### Задание №3 - Найти вершины, для которых высота левого поддерева не равна высоте правого поддерева:
```python
class TreeNode:
    def __init__(self, val):
        self.val = val
        self.left = None
        self.right = None

class BinaryTree:
    def __init__(self):
        self.root = None
    
    def insert(self, val):
        if not self.root:
            self.root = TreeNode(val)
            return True
        
        return self._insert(self.root, val)
    
    def _insert(self, node, val):
        if val < node.val:
            if not node.left:
                node.left = TreeNode(val)
                return True
            else:
                return self._insert(node.left, val)
        elif val > node.val:
            if not node.right:
                node.right = TreeNode(val)
                return True
            else:
                return self._insert(node.right, val)
        else:
            return False
    
    def find_different_height_nodes(self):
        result = []
        self._check_heights(self.root, result)
        return result
    
    def _check_heights(self, node, result):
        if not node:
            return 0
        
        left_h = self._check_heights(node.left, result)
        right_h = self._check_heights(node.right, result)
        
        if left_h != right_h:
            result.append(node.val)
        
        return max(left_h, right_h) + 1
```

