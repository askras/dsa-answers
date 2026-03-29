# Двоичные деревья поиска (Binary Search Tree)
Баскаков Д. С.
ИУ10-38

## Цель работы:
Изучение структуры данных «Двоичное дерево поиска», а также основных операций над ним.
### Задание №1 - Реализовать программу, выполняющую стандартный набор операций над двоичным деревом поиска:
```python
def add(self, v):
    if self._find(self.root, v):
        return False
    def ins(n, val):
        if not n: return Node(val)
        if val < n.val: n.left = ins(n.left, val)
        elif val > n.val: n.right = ins(n.right, val)
        return n
    self.root = ins(self.root, v)
    return True

# 2) Обходы
def pre(self, n, r):  # Прямой
    r.append(n.val)
    self.pre(n.left, r)
    self.pre(n.right, r)

def ino(self, n, r):  # Симметричный
    self.ino(n.left, r)
    r.append(n.val)
    self.ino(n.right, r)

def post(self, n, r):  # Обратный
    self.post(n.left, r)
    self.post(n.right, r)
    r.append(n.val)

# 3) Удаление
def rem(self, v):
    if not self.root or not self._find(self.root, v):
        return False
    def del_node(n, val):
        if not n: return n
        if val < n.val: n.left = del_node(n.left, val)
        elif val > n.val: n.right = del_node(n.right, val)
        else:
            if not n.left: return n.right
            if not n.right: return n.left
            m = n.right
            while m and m.left: m = m.left
            n.val = m.val
            n.right = del_node(n.right, m.val)
        return n
    self.root = del_node(self.root, v)
    return True

# 4) Поиск
def find(self, v):
    def f(n, val):
        if not n or n.val == val:
            return n
        else:
            if val < n.val:
                return f(n.left, val)
            else:
                return f(n.right, val)
    return bool(f(self.root, v))

# 5) Печать дерева
def show(self):
    lines = []
    def pr(n, lvl, p):
        if n:
            lines.append("  " * lvl + f"{p}: {n.val}")
            pr(n.left, lvl+1, "L")
            pr(n.right, lvl+1, "R")
    pr(self.root, 0, "R")
    return "\n".join(lines)

# 6) Проверка пустоты
def empty(self): return not self.root

# 7) Высота дерева
def h(self, n):
    return max(self.h(n.left), self.h(n.right)) + 1
```

### Задание №2 - Реализовать самобалансирующееся (AVL) дерево:
```python
def right_rot(self, y):
    x = y.left
    t = x.right
    x.right = y
    y.left = t
    return x

def left_rot(self, x):
    y = x.right
    t = y.left
    y.left = x
    x.right = t
    return y

def get_balance(self, n):
        return self.h(n.left) - self.h(n.right)

# Балансировка
def bal(self, n, v):
    b = self.get_balance(n)  
    if b > 1: 
        if v < n.left.val: return self.right_rot(n)  # LL
        n.left = self.left_rot(n.left)  # LR
        return self.right_rot(n)
    if b < -1: 
        if v > n.right.val: return self.left_rot(n)  # RR
        n.right = self.right_rot(n.right)  # RL
        return self.left_rot(n)
    return n
```


### Задание №3 - Найти вершины, для которых высота левого поддерева не равна высоте правого поддерева:
```python
def task3(self):
    r = []
    def f(n):
        lh = self.h(n.left)
        rh = self.h(n.right)
        if lh != rh: r.append(n.val)
        f(n.left)
        f(n.right)
        return max(lh, rh) + 1
    f(self.root)
    return r
```

