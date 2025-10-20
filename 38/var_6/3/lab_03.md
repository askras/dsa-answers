# <Линейные списки>


Молчанов Е.А.

ИУ10-38


## Задания

### Задание 1
```Javascript
// Версия 1: Базовая реализация односвязного списка
class SingleLinkedList_v1 {
    constructor() {
        this._head = null;
        this._size = 0;
    }

    // Вставка элемента в начало списка
    insertFirstNode(value) {
        this._head = new Node(value, this._head);
        this._size++;
    }

    // Удаление первого элемента списка
    removeFirstNode() {
        if (!this._head) return null;
        const temp = this._head.data;
        this._head = this._head.next;
        this._size--;
        return temp;
    }

    // Вставка элемента в конец списка
    insertLastNode(value) {
        if (!this._head) {
            this.insertFirstNode(value);
        } else {
            let current = this._head;
            while (current.next) {
                current = current.next;
            }
            current.next = new Node(value);
            this._size++;
        }
    }

    // Удаление последнего элемента списка
    removeLastNode() {
        if (!this._head) return null;
        if (!this._head.next) {
            return this.removeFirstNode();
        }

        let current = this._head;
        while (current.next && current.next.next) {
            current = current.next;
        }
        const temp = current.next.data;
        current.next = null;
        this._size--;
        return temp;
    }

    // Строковое представление списка
    toString() {
        let result = 'LinkedList.head -> ';
        let current = this._head;
        while (current) {
            result += current.data + ' -> ';
            current = current.next;
        }
        return result + 'None';
    }

    // Получить размер списка
    getSize() {
        return this._size;
    }
}// Версия 2: Наследуется от версии 1 и добавляет операции поиска и замены
class SingleLinkedList_v2 extends SingleLinkedList_v1 {
    // Найти узел по значению
    findNode(value) {
        let current = this._head;
        while (current) {
            if (current.data === value) {
                return current;
            }
            current = current.next;
        }
        return null;
    }

    // Заменить значение узла
    replaceNode(oldValue, newValue) {
        const node = this.findNode(oldValue);
        if (node) {
            node.data = newValue;
            return true;
        }
        return false;
    }

    // Удалить узел по значению
    removeNode(value) {
        if (!this._head) return null;

        // Случай удаления первого элемента
        if (this._head.data === value) {
            return this.removeFirstNode();
        }

        // Поиск узла для удаления
        let current = this._head;
        while (current.next && current.next.data !== value) {
            current = current.next;
        }

        // Удаление найденного узла
        if (current.next) {
            const temp = current.next.data;
            current.next = current.next.next;
            this._size--;
            return temp;
        }

        return null;
    }
}

// Версия 3: Наследуется от версии 2 и добавляет хранение ссылки на последний элемент
class SingleLinkedList_v3 extends SingleLinkedList_v2 {
    constructor() {
        super();
        this._tail = null;
    }

    // Улучшенный метод вставки в конец
    insertLastNode(value) {
        if (!this._head) {
            super.insertFirstNode(value);
            this._tail = this._head;
        } else {
            this._tail.next = new Node(value);
            this._tail = this._tail.next;
        }
        this._size++;
    }

    // Улучшенный метод удаления последнего элемента
    removeLastNode() {
        const temp = super.removeLastNode();
        if (temp !== null && this._head) {
            // Обновляем хвост, если он был удален
            let current = this._head;
            while (current.next) {
                current = current.next;
            }
            this._tail = current;
        }
        return temp;
    }
}

// Версия 4: Наследуется от версии 3 и оптимизирует операции
class SingleLinkedList_v4 extends SingleLinkedList_v3 {
    // Оптимизированная вставка перед узлом
    insertBeforeNode(targetValue, newValue) {
        if (!this._head) return false;

        // Специальный случай для первого элемента
        if (this._head.data === targetValue) {
            this.insertFirstNode(newValue);
            return true;
        }

        // Пытаемся найти предыдущий узел
        let current = this._head;
        while (current.next && current.next.data !== targetValue) {
            current = current.next;
        }

        if (current.next) {
            // Оптимизация: вместо создания нового узла, меняем значения
            const temp = current.data;
            current.data = newValue;
            current.next = new Node(temp, current.next.next);
            this._size++;
            return true;
        }

        return false;
    }

    // Оптимизированная вставка после узла
    insertAfterNode(targetValue, newValue) {
        const node = this.findNode(targetValue);
        if (node) {
            // Оптимизация: вместо создания нового узла, меняем значения
            const temp = node.next ? node.next.data : null;
            node.next = new Node(newValue, node.next);
            if (temp !== null) {
                node.next.next = new Node(temp, node.next.next);
            }
            this._size++;
            return true;
        }
        return false;
    }

    // Оптимизированное удаление предыдущего узла
    removePreviousNode(targetValue) {
        if (!this._head || this._head.data === targetValue) {
            return null;
        }

        // Специальный случай для второго элемента
        if (this._head.next && this._head.next.data === targetValue) {
            return this.removeFirstNode();
        }

        // Пытаемся найти узел перед предыдущим
        let current = this._head;
        while (current.next && current.next.next && current.next.next.data !== targetValue) {
            current = current.next;
        }

        if (current.next && current.next.next) {
            // Оптимизация: вместо удаления, меняем значения
            const temp = current.next.data;
            current.next.data = current.next.next.data;
            current.next.next = current.next.next.next;
            this._size--;
            return temp;
        }

        return null;
    }

    // Оптимизированное удаление следующего узла
    removeNextNode(targetValue) {
        const node = this.findNode(targetValue);
        if (node && node.next) {
            // Оптимизация: вместо удаления, меняем значения
            const temp = node.next.data;
            if (node.next.next) {
                node.next.data = node.next.next.data;
                node.next.next = node.next.next.next;
            } else {
                node.next = null;
                this._tail = node;
            }
            this._size--;
            return temp;
        }
        return null;
    }
}

// Версия 5: Наследуется от версии 4 и добавляет метод reverse
class SingleLinkedList_v5 extends SingleLinkedList_v4 {
    // Метод переворота списка (reverse)
    reverse() {
        if (!this._head || !this._head.next) {
            return;
        }

        let prev = null;
        let current = this._head;
        this._tail = this._head; // Новый хвост - старая голова

        while (current) {
            const next = current.next;
            current.next = prev;
            prev = current;
            current = next;
        }

        this._head = prev;
    }
}

// Версия 6: Наследуется от версии 5 и добавляет метод sort
class SingleLinkedList_v6 extends SingleLinkedList_v5 {
    // Метод сортировки списка на месте (sort)
    sort() {
        if (!this._head || !this._head.next) {
            return;
        }

        let sorted = false;
        while (!sorted) {
            sorted = true;
            let current = this._head;
            while (current.next) {
                if (current.data > current.next.data) {
                    // Меняем значения местами
                    const temp = current.data;
                    current.data = current.next.data;
                    current.next.data = temp;
                    sorted = false;
                }
                current = current.next;
            }
        }
    }
}
```

### Задание 2

```Javascript
// Индивидуальное задание: Удаление последовательных дубликатов
function removeConsecutiveDuplicates_6(list) {
    if (!list._head) return;

    let current = list._head;
    while (current && current.next) {
        if (current.data === current.next.data) {
            current.next = current.next.next;
            list._size--;
            // Не сдвигаем указатель, т.к. следующий элемент может быть таким же
        } else {
            current = current.next;
        }
    }

    // Обновляем хвост, если список изменился
    if (list._tail && list._head) {
        let temp = list._head;
        while (temp.next) {
            temp = temp.next;
        }
        list._tail = temp;
    }
}
```
