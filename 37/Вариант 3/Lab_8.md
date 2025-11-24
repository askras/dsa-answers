#### Задание 1


```python
class Node:
    def __init__(self, value):
        self.value = value
        self.left = None
        self.right = None

class BinarySearchTree:

    def __init__(self):
        self.root = None

    def is_empty(self):
        return self.root is None

    def insert(self, value):
        if self._is_valid_value(value):
            self.root = self._insert_recursive(self.root, value)
            return True
        return False

    def _insert_recursive(self, node, value):
        if node is None:
            return Node(value)

        if value < node.value:
            node.left = self._insert_recursive(node.left, value)
        elif value > node.value:
            node.right = self._insert_recursive(node.right, value)

        return node

    def search(self, value):
        if not self._is_valid_value(value):
            return False
        return self._search_recursive(self.root, value)

    def _search_recursive(self, node, value):
        if node is None:
            return False

        if value == node.value:
            return True
        elif value < node.value:
            return self._search_recursive(node.left, value)
        else:
            return self._search_recursive(node.right, value)

    def delete(self, value):
        if not self._is_valid_value(value) or self.is_empty():
            return False

        if not self.search(value):
            return False  

        self.root = self._delete_recursive(self.root, value)
        return True

    def _delete_recursive(self, node, value):
        if node is None:
            return node

        if value < node.value:
            node.left = self._delete_recursive(node.left, value)
        elif value > node.value:
            node.right = self._delete_recursive(node.right, value)
        else:
            if node.left is None:
                return node.right
            elif node.right is None:
                return node.left

            min_node = self._find_min(node.right)
            node.value = min_node.value
            node.right = self._delete_recursive(node.right, min_node.value)

        return node

    def _find_min(self, node):
        current = node
        while current.left is not None:
            current = current.left
        return current

    def preorder_traversal(self):
        result = []
        self._preorder_recursive(self.root, result)
        return result

    def _preorder_recursive(self, node, result):
        if node is not None:
            result.append(node.value)
            self._preorder_recursive(node.left, result)
            self._preorder_recursive(node.right, result)

    def inorder_traversal(self):
        result = []
        self._inorder_recursive(self.root, result)
        return result

    def _inorder_recursive(self, node, result):
        if node is not None:
            self._inorder_recursive(node.left, result)
            result.append(node.value)
            self._inorder_recursive(node.right, result)

    def postorder_traversal(self):
        result = []
        self._postorder_recursive(self.root, result)
        return result

    def _postorder_recursive(self, node, result):
        if node is not None:
            self._postorder_recursive(node.left, result)
            self._postorder_recursive(node.right, result)
            result.append(node.value)

    def height(self):
        return self._height_recursive(self.root)

    def _height_recursive(self, node):
        if node is None:
            return -1 

        left_height = self._height_recursive(node.left)
        right_height = self._height_recursive(node.right)

        return max(left_height, right_height) + 1

    def print_tree(self):
        if self.is_empty():
            print("Дерево пустое")
            return

        lines = self._build_tree_display()
        for line in lines:
            print(line)

    def _build_tree_display(self):
        if self.root is None:
            return []

        def _build_lines(node):
            if node is None:
                return [], 0, 0, 0

            label = str(node.value)

            left_lines, left_pos, left_width, left_height = _build_lines(node.left)
            right_lines, right_pos, right_width, right_height = _build_lines(node.right)

            middle = max(right_pos + left_width - left_pos + 1, len(label), 2)
            pos = left_pos + middle // 2
            width = left_pos + middle + right_width - right_pos

            while len(left_lines) < len(right_lines):
                left_lines.append(' ' * left_width)
            while len(right_lines) < len(left_lines):
                right_lines.append(' ' * right_width)

            if (middle - len(label)) % 2 == 1 and node.left is not None and \
               node.right is not None and len(right_lines) > 0:
                right_lines[0] = ' ' + right_lines[0]

            label = label.center(middle, ' ')

            if label[0] == ' ': label = '|' + label[1:]
            if label[-1] == ' ': label = label[:-1] + '|'

            lines = [' ' * left_pos + label + ' ' * (right_width - right_pos),
                     ' ' * left_pos + '/' + ' ' * (middle-2) + '\\' + ' ' * (right_width - right_pos)] + \
                    [left_line + ' ' * (width - left_width - right_width) + right_line
                     for left_line, right_line in zip(left_lines, right_lines)]

            return lines, pos, width, max(left_height, right_height) + 2

        lines, _, _, _ = _build_lines(self.root)
        return lines

    def _is_valid_value(self, value):
        return value is not None
```

#### Задание 2


```python
class AVLNode:
    def __init__(self, value):
        self.value = value
        self.left = None
        self.right = None
        self.height = 1  

class AVLTree:

    def __init__(self):
        self.root = None

    def is_empty(self):
        return self.root is None

    def _get_height(self, node):
        if node is None:
            return 0
        return node.height

    def _get_balance(self, node):
        if node is None:
            return 0
        return self._get_height(node.left) - self._get_height(node.right)

    def _update_height(self, node):
        if node is not None:
            node.height = 1 + max(self._get_height(node.left), 
                                self._get_height(node.right))

    def _rotate_right(self, y):
        x = y.left
        T2 = x.right

 
        x.right = y
        y.left = T2

        self._update_height(y)
        self._update_height(x)

        return x

    def _rotate_left(self, x):
        y = x.right
        T2 = y.left

        y.left = x
        x.right = T2

        self._update_height(x)
        self._update_height(y)

        return y

    def insert(self, value):
        if self._is_valid_value(value):
            self.root = self._insert_recursive(self.root, value)
            return True
        return False

    def _insert_recursive(self, node, value):
        if node is None:
            return AVLNode(value)

        if value < node.value:
            node.left = self._insert_recursive(node.left, value)
        elif value > node.value:
            node.right = self._insert_recursive(node.right, value)
        else:
            return node  

        self._update_height(node)

        balance = self._get_balance(node)

        if balance > 1 and value < node.left.value:
            return self._rotate_right(node)

        if balance < -1 and value > node.right.value:
            return self._rotate_left(node)

        if balance > 1 and value > node.left.value:
            node.left = self._rotate_left(node.left)
            return self._rotate_right(node)

        if balance < -1 and value < node.right.value:
            node.right = self._rotate_right(node.right)
            return self._rotate_left(node)

        return node

    def delete(self, value):
        if not self._is_valid_value(value) or self.is_empty():
            return False

        if not self.search(value):
            return False  

        self.root = self._delete_recursive(self.root, value)
        return True

    def _delete_recursive(self, node, value):
        if node is None:
            return node

        if value < node.value:
            node.left = self._delete_recursive(node.left, value)
        elif value > node.value:
            node.right = self._delete_recursive(node.right, value)
        else:
            if node.left is None:
                return node.right
            elif node.right is None:
                return node.left

            min_node = self._find_min(node.right)
            node.value = min_node.value
            node.right = self._delete_recursive(node.right, min_node.value)

        if node is None:
            return node

        self._update_height(node)

        balance = self._get_balance(node)

        if balance > 1 and self._get_balance(node.left) >= 0:
            return self._rotate_right(node)

        if balance > 1 and self._get_balance(node.left) < 0:
            node.left = self._rotate_left(node.left)
            return self._rotate_right(node)

        if balance < -1 and self._get_balance(node.right) <= 0:
            return self._rotate_left(node)

        if balance < -1 and self._get_balance(node.right) > 0:
            node.right = self._rotate_right(node.right)
            return self._rotate_left(node)

        return node

    def _find_min(self, node):
        current = node
        while current.left is not None:
            current = current.left
        return current

    def search(self, value):
        if not self._is_valid_value(value):
            return False
        return self._search_recursive(self.root, value)

    def _search_recursive(self, node, value):
        if node is None:
            return False

        if value == node.value:
            return True
        elif value < node.value:
            return self._search_recursive(node.left, value)
        else:
            return self._search_recursive(node.right, value)

    def preorder_traversal(self):
        result = []
        self._preorder_recursive(self.root, result)
        return result

    def _preorder_recursive(self, node, result):
        if node is not None:
            result.append(node.value)
            self._preorder_recursive(node.left, result)
            self._preorder_recursive(node.right, result)

    def inorder_traversal(self):
        result = []
        self._inorder_recursive(self.root, result)
        return result

    def _inorder_recursive(self, node, result):
        if node is not None:
            self._inorder_recursive(node.left, result)
            result.append(node.value)
            self._inorder_recursive(node.right, result)

    def postorder_traversal(self):
        result = []
        self._postorder_recursive(self.root, result)
        return result

    def _postorder_recursive(self, node, result):
        if node is not None:
            self._postorder_recursive(node.left, result)
            self._postorder_recursive(node.right, result)
            result.append(node.value)

    def height(self):
        return self._get_height(self.root)

    def print_tree(self):
        if self.is_empty():
            print("Дерево пустое")
            return

        lines = self._build_tree_display()
        for line in lines:
            print(line)

    def _build_tree_display(self):
        if self.root is None:
            return []

        def _build_lines(node):
            if node is None:
                return [], 0, 0, 0

            label = f"{node.value}({self._get_balance(node)})"

            left_lines, left_pos, left_width, left_height = _build_lines(node.left)
            right_lines, right_pos, right_width, right_height = _build_lines(node.right)

            middle = max(right_pos + left_width - left_pos + 1, len(label), 2)
            pos = left_pos + middle // 2
            width = left_pos + middle + right_width - right_pos

            while len(left_lines) < len(right_lines):
                left_lines.append(' ' * left_width)
            while len(right_lines) < len(left_lines):
                right_lines.append(' ' * right_width)

            if (middle - len(label)) % 2 == 1 and node.left is not None and \
               node.right is not None and len(right_lines) > 0:
                right_lines[0] = ' ' + right_lines[0]

            label = label.center(middle, ' ')

            if label[0] == ' ': label = '|' + label[1:]
            if label[-1] == ' ': label = label[:-1] + '|'

            lines = [' ' * left_pos + label + ' ' * (right_width - right_pos),
                     ' ' * left_pos + '/' + ' ' * (middle-2) + '\\' + ' ' * (right_width - right_pos)] + \
                    [left_line + ' ' * (width - left_width - right_width) + right_line
                     for left_line, right_line in zip(left_lines, right_lines)]

            return lines, pos, width, max(left_height, right_height) + 2

        lines, _, _, _ = _build_lines(self.root)
        return lines

    def _is_valid_value(self, value):
        return value is not None

    def is_avl_tree(self):
        return self._is_avl_recursive(self.root)

    def _is_avl_recursive(self, node):
        if node is None:
            return True

        balance = self._get_balance(node)
        if abs(balance) > 1:
            return False

        left_height = self._get_height(node.left)
        right_height = self._get_height(node.right)
        if node.height != 1 + max(left_height, right_height):
            return False

        return (self._is_avl_recursive(node.left) and 
                self._is_avl_recursive(node.right))
```

#### Задание 3


```python
class Node:
    def __init__(self, value):
        self.value = value
        self.left = None
        self.right = None

def has_duplicates_set(root):
    seen = set()

    def traverse(node):
        if node is None:
            return False

        if node.value in seen:
            return True

        seen.add(node.value)

        return traverse(node.left) or traverse(node.right)

    return traverse(root)

def create_tree(values):
    if not values:
        return None

    root = Node(values[0])
    for value in values[1:]:
        insert_value(root, value)
    return root

def insert_value(root, value):
    from collections import deque
    queue = deque([root])

    while queue:
        node = queue.popleft()

        if node.left is None:
            node.left = Node(value)
            return
        else:
            queue.append(node.left)

        if node.right is None:
            node.right = Node(value)
            return
        else:
            queue.append(node.right)
```
