# <Стэк, Дэк, Очередь>


Молчанов Е.А.

ИУ10-38


## Задания

```

class ArrayStack {
    constructor() {
        this.elements = [];
    }

    push(element) {
        this.elements.push(element);
    }

    pop() {
        if (this.isEmpty()) {
            return null;
        }
        return this.elements.pop();
    }

    peek() {
        if (this.isEmpty()) {
            return null;
        }
        return this.elements[this.elements.length - 1];
    }

    isEmpty() {
        return this.elements.length === 0;
    }

    size() {
        return this.elements.length;
    }

    clear() {
        this.elements = [];
    }

    toString() {
        return "Stack: [" + this.elements.join(", ") + "]";
    }
}


class LinkedListStack {
    constructor() {
        this.topNode = null;
        this.size = 0;
    }

    push(element) {
        const newNode = new Node(element);
        newNode.next = this.topNode;
        this.topNode = newNode;
        this.size++;
    }

    pop() {
        if (this.isEmpty()) {
            return null;
        }
        const temp = this.topNode.data;
        this.topNode = this.topNode.next;
        this.size--;
        return temp;
    }

    peek() {
        if (this.isEmpty()) {
            return null;
        }
        return this.topNode.data;
    }

    isEmpty() {
        return this.size === 0;
    }

    size() {
        return this.size;
    }

    clear() {
        this.topNode = null;
        this.size = 0;
    }

    toString() {
        let result = "Stack: [";
        let current = this.topNode;
        const elements = [];

        while (current) {
            elements.push(current.data);
            current = current.next;
        }

        result += elements.reverse().join(", ") + "]";
        return result;
    }
}

class ArrayQueue {
    constructor() {
        this.elements = [];
    }

    enqueue(element) {
        this.elements.push(element);
    }

    dequeue() {
        if (this.isEmpty()) {
            return null;
        }
        return this.elements.shift();
    }

    peek() {
        if (this.isEmpty()) {
            return null;
        }
        return this.elements[0];
    }

    isEmpty() {
        return this.elements.length === 0;
    }

    size() {
        return this.elements.length;
    }

    clear() {
        this.elements = [];
    }

    toString() {
        return "Queue: [" + this.elements.join(", ") + "]";
    }
}


```
