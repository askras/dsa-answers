# <Алгоритмы сортировки>


Молчанов Е.А.

ИУ10-38


## Задания

```JavaScript
// Генерация случайного массива
function generateRandomArray(n) {
    const arr = [];
    for (let i = 0; i < n; i++) {
        arr.push(Math.floor(Math.random() * 1000));
    }
    return arr;
}

// Генерация отсортированного массива
function generateSortedArray(n) {
    const arr = [];
    for (let i = 0; i < n; i++) {
        arr.push(i);
    }
    return arr;
}

// Генерация обратно отсортированного массива
function generateReverseSortedArray(n) {
    const arr = [];
    for (let i = n - 1; i >= 0; i--) {
        arr.push(i);
    }
    return arr;
}
```
### Задание 1
```Javascript
function combSort(arr) {
    let n = arr.length;
    let gap = n;
    let swapped = true;

    while (gap > 1 || swapped) {
        gap = Math.floor(gap / 1.3);
        if (gap < 1) gap = 1;

        swapped = false;
        for (let i = 0; i < n - gap; i++) {
            if (arr[i] > arr[i + gap]) {
                [arr[i], arr[i + gap]] = [arr[i + gap], arr[i]];
                swapped = true;
            }
        }
    }
    return arr;
}
```

### Задание 2

```Javascript
function radixSort(arr) {
    const max = Math.max(...arr);
    let exp = 1;

    while (Math.floor(max / exp) > 0) {
        countingSort(arr, exp);
        exp *= 10;
    }
    return arr;
}

function countingSort(arr, exp) {
    const n = arr.length;
    const output = new Array(n).fill(0);
    const count = new Array(10).fill(0);

    // Подсчет элементов
    for (let i = 0; i < n; i++) {
        const digit = Math.floor(arr[i] / exp) % 10;
        count[digit]++;
    }

    // Обновление позиций
    for (let i = 1; i < 10; i++) {
        count[i] += count[i - 1];
    }

    // Формирование отсортированного массива
    for (let i = n - 1; i >= 0; i--) {
        const digit = Math.floor(arr[i] / exp) % 10;
        output[count[digit] - 1] = arr[i];
        count[digit]--;
    }

    // Копирование в исходный массив
    for (let i = 0; i < n; i++) {
        arr[i] = output[i];
    }
```
