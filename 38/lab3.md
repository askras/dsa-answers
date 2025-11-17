# Лабораторная работа №3
## Акбаев Ахмат Султанович ИУ10-38

```python
from typing import Any, Optional

class Node:
    def __init__(self, data: Any = None, next: Optional['Node'] = None):
        self.data = data
        self.next = next

    def __repr__(self):
        return f"Node(data={self.data}, next={self.next})"
```

```python
class LinkedListv1:
    def __init__(self):
        self._head: Optional[Node] = None

    def insert_first_node(self, value: Any) -> None:
        self._head = Node(value, self._head)

    def remove_first_node(self) -> Any:
        if self._head is None:
            raise IndexError("err: removing from empty list")
        val = self._head.data
        self._head = self._head.next
        return val

    def insert_last_node(self, value: Any) -> None:
        if self._head is None:
            self.insert_first_node(value)
        else:
            curr = self._head
            while curr.next:
                curr = curr.next
            curr.next = Node(value)

    def remove_last_node(self) -> Any:
        if self._head is None:
            raise IndexError("err: removing from empty list")
        if self._head.next is None:
            return self.remove_first_node()
        curr = self._head
        while curr.next.next:
            curr = curr.next
        val = curr.next.data
        curr.next = None
        return val

    def __str__(self):
        vals = []
        curr = self._head
        while curr:
            vals.append(str(curr.data))
            curr = curr.next
        return "LinkedList.head -> " + " -> ".join(vals) + " -> None"
```

```python
class LinkedListv2(LinkedListv1):
    def get_size(self) -> int:
        count = 0
        curr = self._head
        while curr:
            count += 1
            curr = curr.next
        return count

    def find_node(self, value: Any) -> bool:
        curr = self._head
        while curr:
            if curr.data == value:
                return True
            curr = curr.next
        return False

    def replace_node(self, old_value: Any, new_value: Any) -> None:
        curr = self._head
        while curr:
            if curr.data == old_value:
                curr.data = new_value
                return
            curr = curr.next

    def remove_node(self, value: Any) -> Any:
        if self._head is None:
            raise ValueError("value not in list")
        if self._head.data == value:
            return self.remove_first_node()
        curr = self._head
        while curr.next and curr.next.data != value:
            curr = curr.next
        if curr.next is None:
            raise ValueError("value not in list")
        val = curr.next.data
        curr.next = curr.next.next
        return val
```

```python
class LinkedListv3(LinkedListv2):
    def __init__(self):
        super().__init__()
        self._size = 0

    def insert_first_node(self, value: Any) -> None:
        super().insert_first_node(value)
        self._size += 1

    def remove_first_node(self) -> Any:
        val = super().remove_first_node()
        self._size -= 1
        return val

    def insert_last_node(self, value: Any) -> None:
        super().insert_last_node(value)
        self._size += 1

    def remove_last_node(self) -> Any:
        val = super().remove_last_node()
        self._size -= 1
        return val

    def remove_node(self, value: Any) -> Any:
        val = super().remove_node(value)
        self._size -= 1
        return val

    def get_size(self) -> int:
        return self._size
```

```python
class LinkedListv4(LinkedListv3):
    def find_previos_node(self, value: Any) -> Any:
        if self._head is None or self._head.data == value:
            raise ValueError("Нет предыдущего нода")
        curr = self._head
        while curr.next and curr.next.data != value:
            curr = curr.next
        if not curr.next:
            raise ValueError("Значение не в списке")
        return curr.data

    def find_next_node(self, value: Any) -> Any:
        curr = self._head
        while curr and curr.data != value:
            curr = curr.next
        if not curr or not curr.next:
            raise ValueError("Отсуствует следующий нод")
        return curr.next.data

    def insert_before_node(self, target_value: Any, new_value: Any) -> None:
        if self._head and self._head.data == target_value:
            self.insert_first_node(new_value)
            return
        curr = self._head
        while curr and curr.next and curr.next.data != target_value:
            curr = curr.next
        if curr and curr.next:
            new_node = Node(new_value, curr.next)
            curr.next = new_node
            self._size += 1

    def insert_after_node(self, target_value: Any, new_value: Any) -> None:
        curr = self._head
        while curr and curr.data != target_value:
            curr = curr.next
        if curr:
            curr.next = Node(new_value, curr.next)
            self._size += 1

    def replace_previos_node(self, target_value: Any, new_value: Any) -> None:
        if self._head is None or self._head.data == target_value:
            raise ValueError("Нет предыдущего нода для замены")
        curr = self._head
        while curr.next and curr.next.data != target_value:
            curr = curr.next
        if curr.next:
            curr.data = new_value

    def replace_next_node(self, target_value: Any, new_value: Any) -> None:
        curr = self._head
        while curr and curr.data != target_value:
            curr = curr.next
        if curr and curr.next:
            curr.next.data = new_value

    def remove_previos_node(self, target_value: Any) -> Any:
        if self._head is None or self._head.data == target_value:
            raise ValueError("Нет предыдущего нода для замены")
        if self._head.next and self._head.next.data == target_value:
            return self.remove_first_node()
        curr = self._head
        while curr.next.next and curr.next.next.data != target_value:
            curr = curr.next
        val = curr.next.data
        curr.next = curr.next.next
        self._size -= 1
        return val

    def remove_next_node(self, target_value: Any) -> Any:
        curr = self._head
        while curr and curr.data != target_value:
            curr = curr.next
        if not curr or not curr.next:
            raise ValueError("Нет следующего нода для замены")
        val = curr.next.data
        curr.next = curr.next.next
        self._size -= 1
        return val
```

```python
class LinkedListv5(LinkedListv4):
    def __init__(self):
        super().__init__()
        self._tail: Optional[Node] = None

    def insert_first_node(self, value: Any) -> None:
        super().insert_first_node(value)
        if self._tail is None:
            self._tail = self._head

    def insert_last_node(self, value: Any) -> None:
        if self._head is None:
            self.insert_first_node(value)
        else:
            self._tail.next = Node(value)
            self._tail = self._tail.next
        self._size += 1

    def remove_last_node(self) -> Any:
        if self._head is None:
            raise IndexError("remove from empty list")
        if self._head.next is None:
            val = self._head.data
            self._head = self._tail = None
            self._size = 0
            return val
        # Нужно найти предпоследний узел — O(n)
        curr = self._head
        while curr.next != self._tail:
            curr = curr.next
        val = self._tail.data
        curr.next = None
        self._tail = curr
        self._size -= 1
        return val

    def remove_node(self, value: Any) -> Any:
        if self._head is None:
            raise ValueError("Значение не в списке")
        if self._head.data == value:
            return self.remove_first_node()
        curr = self._head
        while curr.next and curr.next.data != value:
            curr = curr.next
        if curr.next is None:
            raise ValueError("Значение не в списке")
        if curr.next == self._tail:
            self._tail = curr
        val = curr.next.data
        curr.next = curr.next.next
        self._size -= 1
        return val
```

```python
class LinkedListv6(LinkedListv5):
    def remove_node_optimized(self, node: Node) -> None:
        if node is None or node.next is None:
            raise NotImplementedError("er")
        next_node = node.next
        node.data = next_node.data
        node.next = next_node.next
        if next_node == self._tail:
            self._tail = node
        self._size -= 1
```

```python
def reverse(self):
    prev = None
    curr = self._head
    while curr:
        next_node = curr.next
        curr.next = prev
        prev = curr
        curr = next_node
    self._head = prev 
    
    if self._head is None:
        self._tail = None
    else:
        curr = self._head
        while curr.next:
            curr = curr.next
        self._tail = curr
```

```python
def sort(head: Node) -> Node:
    if not head or not head.next:
        return head
    slow, fast = head, head.next
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next

    mid = slow.next
    slow.next = None

    left = sort(head)
    right = sort(mid)

    return merge(left, right)

def merge(l1: Node, l2: Node) -> Node:
    dummy = Node(0)
    tail = dummy

    while l1 and l2:
        if l1.data < l2.data:
            tail.next = l1
            l1 = l1.next
        else:
            tail.next = l2
            l2 = l2.next
        tail = tail.next

    tail.next = l1 or l2
    return dummy.next
```

```python
def difference(L1: 'LinkedListv5', L2: 'LinkedListv5') -> 'LinkedListv5':
    l2_values = set()
    curr = L2._head
    while curr is not None:
        l2_values.add(curr.data)
        curr = curr.next

    result = LinkedListv5()
    curr = L1._head
    while curr is not None:
        if curr.data not in l2_values:
            result.insert_last_node(curr.data)
        curr = curr.next

    return result
```

```python
import random

L1 = LinkedListv5()
for x in [random.randint(1, 100) for _ in range(10)]:
    L1.insert_last_node(x)

L2 = LinkedListv5()
for x in [random.randint(1, 100) for _ in range(10)]:
    L2.insert_last_node(x)

L = difference(L1, L2)

print(L)
print(sort(L._head))
```

```python

```
