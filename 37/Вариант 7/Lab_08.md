# Двоичные деревья поиска (Binary Search Tree)
Фомин И.Н.
ИУ10-37
## Задания
### Задание 1
Реализовать программу, выполняющую стандартный набор операций над двоичным деревом поиска:
- формирование бинарного дерева;
- обход (прямой, симметричный, обратный) бинарного дерева;
- удаление заданной вершины из бинарного дерева;
- поиск заданной вершины в бинарном дереве (по значению);
- печать бинарного дерева на экран;
- проверка пустоты бинарного дерева;
- определение высоты бинарного дерева.

Требования:
- дерево должно быть реализовано в виде класса;
- каждая операция должна быть реализована как метод класса;
- добавлению/удалению должна предшествовать проверка возможности выполнения этих операций;


```python
class BSTNode:
    def __init__(self, key):
        self.key = key
        self.left = None
        self.right = None


class BinarySearchTree:
    def __init__(self):
        self.root = None

    # Проверка пустоты дерева
    def is_empty(self):
        return self.root is None

    # Добавление элемента
    def insert(self, key):
        if self.root is None:
            self.root = BSTNode(key)
            return

        current = self.root
        while True:
            if key == current.key:
                print("Ошибка: элемент уже существует в дереве")
                return
            elif key < current.key:
                if current.left is None:
                    current.left = BSTNode(key)
                    return
                current = current.left
            else:
                if current.right is None:
                    current.right = BSTNode(key)
                    return
                current = current.right

    # Поиск элемента
    def search(self, key):
        current = self.root
        while current:
            if key == current.key:
                return True
            elif key < current.key:
                current = current.left
            else:
                current = current.right
        return False

    # Удаление элемента
    def delete(self, key):
        if self.root is None:
            print("Ошибка: дерево пусто")
            return

        self.root = self._delete_recursive(self.root, key)

    def _delete_recursive(self, node, key):
        if node is None:
            print("Ошибка: элемент не найден")
            return None

        if key < node.key:
            node.left = self._delete_recursive(node.left, key)
        elif key > node.key:
            node.right = self._delete_recursive(node.right, key)
        else:
            # Ситуация 1 и 2
            if node.left is None:
                return node.right
            if node.right is None:
                return node.left

            # Ситуация 3: два потомка
            successor = self._find_min(node.right)
            node.key = successor.key
            node.right = self._delete_recursive(node.right, successor.key)

        return node

    def _find_min(self, node):
        while node.left:
            node = node.left
        return node

    # Высота дерева
    def height(self):
        return self._height_recursive(self.root)

    def _height_recursive(self, node):
        if node is None:
            return 0
        return 1 + max(self._height_recursive(node.left),
                       self._height_recursive(node.right))

    # Обходы дерева
    def preorder(self):
        result = []
        self._preorder_recursive(self.root, result)
        return result

    def _preorder_recursive(self, node, result):
        if node:
            result.append(node.key)
            self._preorder_recursive(node.left, result)
            self._preorder_recursive(node.right, result)

    def inorder(self):
        result = []
        self._inorder_recursive(self.root, result)
        return result

    def _inorder_recursive(self, node, result):
        if node:
            self._inorder_recursive(node.left, result)
            result.append(node.key)
            self._inorder_recursive(node.right, result)

    def postorder(self):
        result = []
        self._postorder_recursive(self.root, result)
        return result

    def _postorder_recursive(self, node, result):
        if node:
            self._postorder_recursive(node.left, result)
            self._postorder_recursive(node.right, result)
            result.append(node.key)

    # Печать дерева (в виде структуры)
    def print_tree(self):
        self._print_recursive(self.root, 0)

    def _print_recursive(self, node, level):
        if node:
            self._print_recursive(node.right, level + 1)
            print("   " * level + str(node.key))
            self._print_recursive(node.left, level + 1)


bst = BinarySearchTree()

bst.insert(50)
bst.insert(30)
bst.insert(70)
bst.insert(20)
bst.insert(40)
bst.insert(60)
bst.insert(80)

print("Симметричный обход:", bst.inorder())
print("Прямой обход:", bst.preorder())
print("Обратный обход:", bst.postorder())

print("Высота дерева:", bst.height())

bst.print_tree()

bst.delete(30)
print("После удаления 30:")
bst.print_tree()


```

    Симметричный обход: [20, 30, 40, 50, 60, 70, 80]
    Прямой обход: [50, 30, 20, 40, 70, 60, 80]
    Обратный обход: [20, 40, 30, 60, 80, 70, 50]
    Высота дерева: 3
          80
       70
          60
    50
          40
       30
          20
    После удаления 30:
          80
       70
          60
    50
       40
          20


### Задание 2
Реализовать самобалансирующееся дерево (AVL-дерево для четных вариантов, красно-черное дерево для нечетных вариантов)


```python
class AVLNode:
    def __init__(self, key):
        self.key = key
        self.left = None
        self.right = None
        self.height = 1


class AVLTree:
    def __init__(self):
        self.root = None

    # Проверка пустоты дерева
    def is_empty(self):
        return self.root is None

    # Получение высоты узла
    def _height(self, node):
        return node.height if node else 0

    # Баланс-фактор
    def _balance_factor(self, node):
        return self._height(node.left) - self._height(node.right)

    # Обновление высоты
    def _update_height(self, node):
        node.height = 1 + max(self._height(node.left),
                              self._height(node.right))

    # Правый поворот
    def _rotate_right(self, y):
        x = y.left
        t2 = x.right

        x.right = y
        y.left = t2

        self._update_height(y)
        self._update_height(x)

        return x

    # Левый поворот
    def _rotate_left(self, x):
        y = x.right
        t2 = y.left

        y.left = x
        x.right = t2

        self._update_height(x)
        self._update_height(y)

        return y

    # Вставка элемента
    def insert(self, key):
        self.root = self._insert_recursive(self.root, key)

    def _insert_recursive(self, node, key):
        if not node:
            return AVLNode(key)

        if key == node.key:
            print("Ошибка: элемент уже существует")
            return node
        elif key < node.key:
            node.left = self._insert_recursive(node.left, key)
        else:
            node.right = self._insert_recursive(node.right, key)

        self._update_height(node)
        balance = self._balance_factor(node)

        # LL
        if balance > 1 and key < node.left.key:
            return self._rotate_right(node)

        # RR
        if balance < -1 and key > node.right.key:
            return self._rotate_left(node)

        # LR
        if balance > 1 and key > node.left.key:
            node.left = self._rotate_left(node.left)
            return self._rotate_right(node)

        # RL
        if balance < -1 and key < node.right.key:
            node.right = self._rotate_right(node.right)
            return self._rotate_left(node)

        return node

    # Поиск элемента
    def search(self, key):
        current = self.root
        while current:
            if key == current.key:
                return True
            elif key < current.key:
                current = current.left
            else:
                current = current.right
        return False

    # Поиск минимального узла
    def _min_value_node(self, node):
        current = node
        while current.left:
            current = current.left
        return current

    # Удаление элемента
    def delete(self, key):
        self.root = self._delete_recursive(self.root, key)

    def _delete_recursive(self, node, key):
        if not node:
            print("Ошибка: элемент не найден")
            return node

        if key < node.key:
            node.left = self._delete_recursive(node.left, key)
        elif key > node.key:
            node.right = self._delete_recursive(node.right, key)
        else:
            if not node.left:
                return node.right
            elif not node.right:
                return node.left

            temp = self._min_value_node(node.right)
            node.key = temp.key
            node.right = self._delete_recursive(node.right, temp.key)

        self._update_height(node)
        balance = self._balance_factor(node)

        # LL
        if balance > 1 and self._balance_factor(node.left) >= 0:
            return self._rotate_right(node)

        # LR
        if balance > 1 and self._balance_factor(node.left) < 0:
            node.left = self._rotate_left(node.left)
            return self._rotate_right(node)

        # RR
        if balance < -1 and self._balance_factor(node.right) <= 0:
            return self._rotate_left(node)

        # RL
        if balance < -1 and self._balance_factor(node.right) > 0:
            node.right = self._rotate_right(node.right)
            return self._rotate_left(node)

        return node

    # Симметричный обход
    def inorder(self):
        result = []
        self._inorder_recursive(self.root, result)
        return result

    def _inorder_recursive(self, node, result):
        if node:
            self._inorder_recursive(node.left, result)
            result.append(node.key)
            self._inorder_recursive(node.right, result)

    # Печать дерева
    def print_tree(self):
        self._print_recursive(self.root, 0)

    def _print_recursive(self, node, level):
        if node:
            self._print_recursive(node.right, level + 1)
            print("   " * level + f"{node.key}")
            self._print_recursive(node.left, level + 1)



avl = AVLTree()

for value in [10, 20, 30, 40, 50, 25]:
    avl.insert(value)

print("Симметричный обход:", avl.inorder())
avl.print_tree()

avl.delete(40)
print("После удаления 40:")
avl.print_tree()

```

    Симметричный обход: [10, 20, 25, 30, 40, 50]
          50
       40
    30
          25
       20
          10
    После удаления 40:
       50
    30
          25
       20
          10


### Задание 3
7. Написать функцию, определяющую количество отрицательных элементов бинарного дерева.


```python
def count_negative_elements(node):
    if node is None:
        return 0

    count = 1 if node.key < 0 else 0
    return (count +
            count_negative_elements(node.left) +
            count_negative_elements(node.right))

tree = BinarySearchTree()
tree.insert(10)
tree.insert(-5)
tree.insert(20)
tree.insert(-15)

print(count_negative_elements(tree.root))

tree = AVLTree()
tree.insert(10)
tree.insert(-5)
tree.insert(20)
tree.insert(-15)

print(count_negative_elements(tree.root))


```

    2
    2

