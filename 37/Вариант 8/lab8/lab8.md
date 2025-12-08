# ОТЧЕТ ПО ЛАБОРАТОРНОЙ РАБОТЕ
## «Лабораторная работа №8. Двоичные деревья поиска (Binary Search Tree)

### Цель работы: Изучение структуры данных «Двоичное дерево поиска», а также основных операций над ним.

### Работу выполнил: Цыганков Д.С 

## Задание 1 - Реализовать программу, выполняющую стандартный набор операций над двоичным деревом поиска:

## 1. Формирование бинарного дерева;
## 2. Обход (прямой, симметричный, обратный) бинарного дерева;
## 3. Удаление заданной вершины из бинарного дерева;
## 4. Поиск заданной вершины в бинарном дереве (по значению);
## 5. Печать бинарного дерева на экран;
## 6. Проверка пустоты бинарного дерева;
## 7. Определение высоты бинарного дерева.

```python 

class TreeNode:
    """Класс узла бинарного дерева"""
    def __init__(self, value):
        self.value = value
        self.left = None
        self.right = None
        self.parent = None
    
    def __str__(self):
        return str(self.value)

class BinarySearchTree:
    """Класс бинарного дерева поиска"""
    def __init__(self):
        self.root = None
        self.size = 0
    
    def is_empty(self):
        """Проверка пустоты дерева"""
        return self.root is None
    
    def insert(self, value):
        """Добавление элемента в дерево"""
        if self._contains(value):
            return False  # Дубликаты не допускаются
        
        new_node = TreeNode(value)
        
        if self.is_empty():
            self.root = new_node
        else:
            self._insert_recursive(self.root, new_node)
        
        self.size += 1
        return True
    
    def _insert_recursive(self, current, new_node):
        """Рекурсивное добавление узла"""
        if new_node.value < current.value:
            if current.left is None:
                current.left = new_node
                new_node.parent = current
            else:
                self._insert_recursive(current.left, new_node)
        else:
            if current.right is None:
                current.right = new_node
                new_node.parent = current
            else:
                self._insert_recursive(current.right, new_node)
    
    def contains(self, value):
        """Поиск элемента в дереве"""
        return self._contains(value)
    
    def _contains(self, value):
        """Внутренний метод поиска"""
        return self._find_node(value) is not None
    
    def _find_node(self, value):
        """Поиск узла по значению"""
        current = self.root
        while current is not None:
            if value == current.value:
                return current
            elif value < current.value:
                current = current.left
            else:
                current = current.right
        return None
    
    def delete(self, value):
        """Удаление элемента из дерева"""
        node_to_delete = self._find_node(value)
        if node_to_delete is None:
            return False
        
        self._delete_node(node_to_delete)
        self.size -= 1
        return True
    
    def _delete_node(self, node):
        """Удаление конкретного узла"""
        # Ситуация 1: Узел является листом (нет потомков)
        if node.left is None and node.right is None:
            self._replace_node(node, None)
        
        # Ситуация 2: Узел имеет только одного потомка
        elif node.left is None:
            self._replace_node(node, node.right)
        elif node.right is None:
            self._replace_node(node, node.left)
        
        # Ситуация 3: Узел имеет двух потомков
        else:
            # Находим наименьший элемент в правом поддереве
            successor = self._find_min(node.right)
            # Копируем значение преемника в удаляемый узел
            node.value = successor.value
            # Удаляем преемника (у него не может быть левого потомка)
            self._delete_node(successor)
    
    def _replace_node(self, old_node, new_node):
        """Замена одного узла другим"""
        if old_node.parent is None:
            self.root = new_node
        elif old_node == old_node.parent.left:
            old_node.parent.left = new_node
        else:
            old_node.parent.right = new_node
        
        if new_node is not None:
            new_node.parent = old_node.parent
    
    def _find_min(self, node):
        """Поиск минимального элемента в поддереве"""
        current = node
        while current.left is not None:
            current = current.left
        return current
    
    def height(self):
        """Определение высоты дерева"""
        return self._height_recursive(self.root)
    
    def _height_recursive(self, node):
        """Рекурсивный расчет высоты"""
        if node is None:
            return 0
        left_height = self._height_recursive(node.left)
        right_height = self._height_recursive(node.right)
        return max(left_height, right_height) + 1
    
    def preorder_traversal(self):
        """Прямой обход (Pre-order)"""
        result = []
        self._preorder_recursive(self.root, result)
        return result
    
    def _preorder_recursive(self, node, result):
        """Рекурсивный прямой обход"""
        if node is not None:
            result.append(node.value)
            self._preorder_recursive(node.left, result)
            self._preorder_recursive(node.right, result)
    
    def inorder_traversal(self):
        """Симметричный обход (In-order)"""
        result = []
        self._inorder_recursive(self.root, result)
        return result
    
    def _inorder_recursive(self, node, result):
        """Рекурсивный симметричный обход"""
        if node is not None:
            self._inorder_recursive(node.left, result)
            result.append(node.value)
            self._inorder_recursive(node.right, result)
    
    def postorder_traversal(self):
        """Обратный обход (Post-order)"""
        result = []
        self._postorder_recursive(self.root, result)
        return result
    
    def _postorder_recursive(self, node, result):
        """Рекурсивный обратный обход"""
        if node is not None:
            self._postorder_recursive(node.left, result)
            self._postorder_recursive(node.right, result)
            result.append(node.value)
    
    def print_tree(self):
        """Печать дерева в виде структуры"""
        if self.is_empty():
            print("Дерево пусто")
        else:
            lines = self._build_tree_string(self.root, "", "", "")
            print("\n".join(lines))
    
    def _build_tree_string(self, node, prefix, children_prefix, result=None):
        """Построение строкового представления дерева"""
        if result is None:
            result = []
        
        if node is not None:
            result.append(prefix + str(node.value))
            
            if node.left is not None or node.right is not None:
                if node.right is not None:
                    self._build_tree_string(node.right, 
                                          children_prefix + "├── ", 
                                          children_prefix + "│   ", 
                                          result)
                else:
                    result.append(children_prefix + "├── ")
                
                if node.left is not None:
                    self._build_tree_string(node.left, 
                                          children_prefix + "└── ", 
                                          children_prefix + "    ", 
                                          result)
                else:
                    result.append(children_prefix + "└── ")
        
        return result
    
    def level_order_traversal(self):
        """Обход в ширину (по уровням)"""
        if self.is_empty():
            return []
        
        result = []
        queue = [self.root]
        
        while queue:
            level_size = len(queue)
            level = []
            
            for _ in range(level_size):
                node = queue.pop(0)
                level.append(node.value)
                
                if node.left:
                    queue.append(node.left)
                if node.right:
                    queue.append(node.right)
            
            result.append(level)
        
        return result
    
    def get_size(self):
        """Получение размера дерева"""
        return self.size
        
```

## Задание 2 - Реализовать самобалансирующееся дерево (AVL-дерево для четных вариантов, красно-черное дерево для нечетных вариантов)

```python

class AVLTreeNode(TreeNode):
    """Узел AVL-дерева с информацией о высоте"""
    def __init__(self, value):
        super().__init__(value)
        self.height = 1

class AVLTree(BinarySearchTree):
    """AVL-дерево (самобалансирующееся бинарное дерево поиска)"""
    def __init__(self):
        super().__init__()
    
    def _get_height(self, node):
        """Получение высоты узла"""
        if node is None:
            return 0
        return node.height
    
    def _get_balance(self, node):
        """Получение баланс-фактора узла"""
        if node is None:
            return 0
        return self._get_height(node.left) - self._get_height(node.right)
    
    def _update_height(self, node):
        """Обновление высоты узла"""
        if node is not None:
            node.height = 1 + max(self._get_height(node.left), 
                                 self._get_height(node.right))
    
    def _rotate_right(self, y):
        """Правый поворот"""
        x = y.left
        T2 = x.right
        
        # Выполняем поворот
        x.right = y
        y.left = T2
        
        # Обновляем родителей
        if T2 is not None:
            T2.parent = y
        x.parent = y.parent
        y.parent = x
        
        # Обновляем высоты
        self._update_height(y)
        self._update_height(x)
        
        return x
    
    def _rotate_left(self, x):
        """Левый поворот"""
        y = x.right
        T2 = y.left
        
        # Выполняем поворот
        y.left = x
        x.right = T2
        
        # Обновляем родителей
        if T2 is not None:
            T2.parent = x
        y.parent = x.parent
        x.parent = y
        
        # Обновляем высоты
        self._update_height(x)
        self._update_height(y)
        
        return y
    
    def insert(self, value):
        """Вставка с балансировкой"""
        new_node = AVLTreeNode(value)
        
        if self.is_empty():
            self.root = new_node
            self.size += 1
            return True
        
        # Обычная вставка BST
        self._insert_avl(self.root, new_node)
        self.size += 1
        
        # Балансировка
        self.root = self._balance_tree(new_node)
        return True
    
    def _insert_avl(self, current, new_node):
        """Рекурсивная вставка для AVL"""
        if new_node.value < current.value:
            if current.left is None:
                current.left = new_node
                new_node.parent = current
            else:
                self._insert_avl(current.left, new_node)
        elif new_node.value > current.value:
            if current.right is None:
                current.right = new_node
                new_node.parent = current
            else:
                self._insert_avl(current.right, new_node)
        else:
            # Дубликаты не допускаются
            return False
        return True
    
    def delete(self, value):
        """Удаление с балансировкой"""
        node_to_delete = self._find_node(value)
        if node_to_delete is None:
            return False
        
        parent = node_to_delete.parent
        self._delete_node(node_to_delete)
        self.size -= 1
        
        # Балансировка от родителя удаленного узла
        if parent is not None:
            self.root = self._balance_tree(parent)
        
        return True
    
    def _balance_tree(self, node):
        """Балансировка дерева от узла до корня"""
        current = node
        while current is not None:
            self._update_height(current)
            balance = self._get_balance(current)
            
            # Left Left Case
            if balance > 1 and self._get_balance(current.left) >= 0:
                current = self._rotate_right(current)
            
            # Right Right Case
            elif balance < -1 and self._get_balance(current.right) <= 0:
                current = self._rotate_left(current)
            
            # Left Right Case
            elif balance > 1 and self._get_balance(current.left) < 0:
                current.left = self._rotate_left(current.left)
                current = self._rotate_right(current)
            
            # Right Left Case
            elif balance < -1 and self._get_balance(current.right) > 0:
                current.right = self._rotate_right(current.right)
                current = self._rotate_left(current)
            
            # Обновляем корень, если нужно
            if current.parent is None:
                self.root = current
                break
            
            # Обновляем ссылки родителя
            if current.parent.left == current.parent_node:
                current.parent.left = current
            else:
                current.parent.right = current
            
            current = current.parent
        
        return self.root
    
    @property
    def current_parent_node(self):

        return None 
    
    def is_balanced(self):
       
        return self._check_balanced(self.root)
    
    def _check_balanced(self, node):
        
        if node is None:
            return True
        
        balance = self._get_balance(node)
        if abs(balance) > 1:
            return False
        
        return (self._check_balanced(node.left) and 
                self._check_balanced(node.right))
                
```

## Задание 3 - Написать функцию, которая определяет, является ли бинарное дерево симметричным.

```python

def is_symmetric(tree):
    if isinstance(tree, BinarySearchTree):
        root = tree.root
    elif isinstance(tree, AVLTree):
        root = tree.root
    else:
        root = tree
    
    if root is None:
        return True
    
    return _is_mirror(root.left, root.right)

def _is_mirror(left, right):
    if left is None and right is None:
        return True
    
    if left is None or right is None:
        return False
    
    if left.value != right.value:
        return False
    
    return (_is_mirror(left.left, right.right) and 
            _is_mirror(left.right, right.left))
            
```


