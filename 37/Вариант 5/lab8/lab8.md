```python
import random
import matplotlib.pyplot as plt
from usage_time import get_usage_time
import sys

class Node:
    def __init__(self, data):
        self.data = data
        self.left = self.right = None

class Tree:
    def __init__(self):
        self.root = None
    
    def __find(self, node, parent, value):
        if node is None:
            return None, parent, False
        if value == node.data:
            return node, parent, True
        if value < node.data:
            if node.left:
                return self.__find(node.left, node, value)
        if value > node.data:
            if node.right:
                return self.__find(node.right, node, value)
        return node, parent, False
    
    def is_empty(self):
        return self.root is None
    
    def append(self, obj):
        if not isinstance(obj, Node):
            obj = Node(obj)
            
        if self.root is None:
            self.root = obj
            return obj
            
        s, p, fl_find = self.__find(self.root, None, obj.data)
        if not fl_find and s:
            if obj.data < s.data:
                s.left = obj
            else:
                s.right = obj
        return obj
    
    
    def search(self, value):
        if self.is_empty():
            return None
            
        node, parent, found = self.__find(self.root, None, value)
        return node if found else None
    
    
    def delete(self, value):
        if self.is_empty():
            return False
            
        node, parent, found = self.__find(self.root, None, value)
        if not found:
            return False
        
        if node.left is None and node.right is None:
            if parent is None:
                self.root = None
            elif parent.left == node:
                parent.left = None
            else:
                parent.right = None
        
        elif node.left is None or node.right is None:
            child = node.left if node.left else node.right
            if parent is None: 
                self.root = child
            elif parent.left == node:
                parent.left = child
            else:
                parent.right = child
        
    
        return True
    
    def preorder_traversal(self, node=None, result=None):
        if result is None:
            result = []
        if node is None:
            node = self.root
            if node is None:
                return result
        
        result.append(node.data) 
        if node.left:
            self.preorder_traversal(node.left, result) 
        if node.right:
            self.preorder_traversal(node.right, result) 
        
        return result
    
    def inorder_traversal(self, node=None, result=None):
        if result is None:
            result = []
        if node is None:
            node = self.root
            if node is None:
                return result
        
        if node.left:
            self.inorder_traversal(node.left, result)  
        result.append(node.data) 
        if node.right:
            self.inorder_traversal(node.right, result) 
        return result
    
    def postorder_traversal(self, node=None, result=None):
        if result is None:
            result = []
        if node is None:
            node = self.root
            if node is None:
                return result
        
        if node.left:
            self.postorder_traversal(node.left, result)
        if node.right:
            self.postorder_traversal(node.right, result)
        result.append(node.data) 
        
        return result
    
    def height(self, node=None):   
        if node is None:
            node = self.root
            if node is None:
                return 0
        
        left_height = self.height(node.left) if node.left else 0
        right_height = self.height(node.right) if node.right else 0
        
        return max(left_height, right_height) + 1
    
    def __print_tree(self, node, level=0, prefix="Root: "):
        if node is not None:
            print(" " * (level * 4) + prefix + str(node.data))
            if node.left is not None or node.right is not None:
                if node.left:
                    self.__print_tree(node.left, level + 1, "L--- ")
                else:
                    print(" " * ((level + 1) * 4) + "L--- None")
                if node.right:
                    self.__print_tree(node.right, level + 1, "R--- ")
                else:
                    print(" " * ((level + 1) * 4) + "R--- None")
    
    def print_tree(self):
        if self.is_empty():
            print("Дерево пустое")
            return
        
        print("Бинарное дерево:")
        self.__print_tree(self.root)
    



```


```python
import random

class RBNode:
    def __init__(self, data, color='RED'):
        self.data = data
        self.color = color
        self.left = self.right = self.parent = None

class RedBlackTree:
    def __init__(self):
        self.NIL = RBNode(None, 'BLACK')
        self.root = self.NIL
    
    def is_empty(self):
        return self.root == self.NIL
    
    def left_rotate(self, x):
        y = x.right
        x.right = y.left
        
        if y.left != self.NIL:
            y.left.parent = x
        
        y.parent = x.parent
        
        if x.parent == self.NIL:
            self.root = y
        elif x == x.parent.left:
            x.parent.left = y
        else:
            x.parent.right = y
        
        y.left = x
        x.parent = y
    
    def right_rotate(self, y):
        x = y.left
        y.left = x.right
        
        if x.right != self.NIL:
            x.right.parent = y
        
        x.parent = y.parent
        
        if y.parent == self.NIL:
            self.root = x
        elif y == y.parent.right:
            y.parent.right = x
        else:
            y.parent.left = x
        
        x.right = y
        y.parent = x
    
    def insert_fixup(self, z):
        while z.parent.color == 'RED':
            if z.parent == z.parent.parent.left:
                y = z.parent.parent.right
                if y.color == 'RED':
                    z.parent.color = 'BLACK'
                    y.color = 'BLACK'
                    z.parent.parent.color = 'RED'
                    z = z.parent.parent
                else:
                    if z == z.parent.right:
                        z = z.parent
                        self.left_rotate(z)
                    z.parent.color = 'BLACK'
                    z.parent.parent.color = 'RED'
                    self.right_rotate(z.parent.parent)
            else:
                y = z.parent.parent.left
                if y.color == 'RED':
                    z.parent.color = 'BLACK'
                    y.color = 'BLACK'
                    z.parent.parent.color = 'RED'
                    z = z.parent.parent
                else:
                    if z == z.parent.left:
                        z = z.parent
                        self.right_rotate(z)
                    z.parent.color = 'BLACK'
                    z.parent.parent.color = 'RED'
                    self.left_rotate(z.parent.parent)
        
        self.root.color = 'BLACK'
    
    def insert(self, value):
        if self.search(value) != self.NIL:
            return False
        
        z = RBNode(value)
        z.left = self.NIL
        z.right = self.NIL
        z.parent = self.NIL
        
        y = self.NIL
        x = self.root
        
        while x != self.NIL:
            y = x
            if z.data < x.data:
                x = x.left
            else:
                x = x.right
        
        z.parent = y
        
        if y == self.NIL:
            self.root = z
        elif z.data < y.data:
            y.left = z
        else:
            y.right = z
        
        z.color = 'RED'
        self.insert_fixup(z)
        return True
    
    def search(self, value):
        return self.__search(self.root, value)
    
    def __search(self, node, value):
        if node == self.NIL or value == node.data:
            return node
        
        if value < node.data:
            return self.__search(node.left, value)
        else:
            return self.__search(node.right, value)
    
    def transplant(self, u, v):
        if u.parent == self.NIL:
            self.root = v
        elif u == u.parent.left:
            u.parent.left = v
        else:
            u.parent.right = v
        v.parent = u.parent
    
    def delete_fixup(self, x):
        while x != self.root and x.color == 'BLACK':
            if x == x.parent.left:
                w = x.parent.right
                if w.color == 'RED':
                    w.color = 'BLACK'
                    x.parent.color = 'RED'
                    self.left_rotate(x.parent)
                    w = x.parent.right
                
                if w.left.color == 'BLACK' and w.right.color == 'BLACK':
                    w.color = 'RED'
                    x = x.parent
                else:
                    if w.right.color == 'BLACK':
                        w.left.color = 'BLACK'
                        w.color = 'RED'
                        self.right_rotate(w)
                        w = x.parent.right
                    
                    w.color = x.parent.color
                    x.parent.color = 'BLACK'
                    w.right.color = 'BLACK'
                    self.left_rotate(x.parent)
                    x = self.root
            else:
                w = x.parent.left
                if w.color == 'RED':
                    w.color = 'BLACK'
                    x.parent.color = 'RED'
                    self.right_rotate(x.parent)
                    w = x.parent.left
                
                if w.right.color == 'BLACK' and w.left.color == 'BLACK':
                    w.color = 'RED'
                    x = x.parent
                else:
                    if w.left.color == 'BLACK':
                        w.right.color = 'BLACK'
                        w.color = 'RED'
                        self.left_rotate(w)
                        w = x.parent.left
                    
                    w.color = x.parent.color
                    x.parent.color = 'BLACK'
                    w.left.color = 'BLACK'
                    self.right_rotate(x.parent)
                    x = self.root
        
        x.color = 'BLACK'
    
    def delete(self, value):
        z = self.search(value)
        if z == self.NIL:
            return False
        
        y = z
        y_original_color = y.color
        if z.left == self.NIL:
            x = z.right
            self.transplant(z, z.right)
        elif z.right == self.NIL:
            x = z.left
            self.transplant(z, z.left)
        else:
            y = self.__find_min(z.right)
            y_original_color = y.color
            x = y.right
            if y.parent == z:
                x.parent = y
            else:
                self.transplant(y, y.right)
                y.right = z.right
                y.right.parent = y
            
            self.transplant(z, y)
            y.left = z.left
            y.left.parent = y
            y.color = z.color
        
        if y_original_color == 'BLACK':
            self.delete_fixup(x)
        
        return True
    
    def __find_min(self, node):
        while node.left != self.NIL:
            node = node.left
        return node
    
    def find_max(self):
        if self.is_empty():
            return None
        
        node = self.root
        while node.right != self.NIL:
            node = node.right
        return node.data
    
    def preorder_traversal(self, node=None, result=None):
        if result is None:
            result = []
        if node is None:
            node = self.root
            if node == self.NIL:
                return result
        
        result.append(node.data)
        if node.left != self.NIL:
            self.preorder_traversal(node.left, result)
        if node.right != self.NIL:
            self.preorder_traversal(node.right, result)
        
        return result
    
    
    def height(self, node=None):
        if node is None:
            node = self.root
            if node == self.NIL:
                return 0
        
        left_height = self.height(node.left) if node.left != self.NIL else 0
        right_height = self.height(node.right) if node.right != self.NIL else 0
        
        return max(left_height, right_height) + 1
```
