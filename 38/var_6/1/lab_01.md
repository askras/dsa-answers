# <Эмпирический анализ временной сложности алгоритмов>


Молчанов Е.А.

ИУ10-38


## Задания


### Задание 1
```Javascript
// Задание 1.2: Сумма элементов вектора
function sumVector(v) {
    let sum = 0;
    for (let i = 0; i < v.length; i++) {
        sum += v[i];
    }
    return sum;
}

// Задание 1.3: Произведение элементов вектора
function productVector(v) {
    let product = 1;
    for (let i = 0; i < v.length; i++) {
        product *= v[i];
    }
    return product;
}

// Задание 1.4: Вычисление полинома методом Горнера
function hornerMethod(v, x) {
    if (v.length === 0) return 0;
    let result = v[0];
    for (let i = 1; i < v.length; i++) {
        result = result * x + v[i];
    }
    return result;
}

// Задание 1.6: Поиск минимума простым перебором
function findMin(v) {
    if (v.length === 0) return undefined;
    let min = v[0];
    for (let i = 1; i < v.length; i++) {
        if (v[i] < min) {
            min = v[i];
        }
    }
    return min;
}
```

### Задание 2

```Javascript
function multiplyMatrices(A, B) {
    const n = A.length;
    // Создаем результирующую матрицу, заполненную нулями
    let C = [];
    for (let i = 0; i < n; i++) {
        C[i] = [];
        for (let j = 0; j < n; j++) {
            C[i][j] = 0;
        }
    }

    for (let i = 0; i < n; i++) {
        for (let j = 0; j < n; j++) {
            for (let k = 0; k < n; k++) {
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }
    return C;
}
```
