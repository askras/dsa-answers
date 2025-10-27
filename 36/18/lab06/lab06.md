# Л.Р. 6 - "Итеративные и рекурсивные алгоритмы"

**Цао М.М.**
**ИУ10-36**

### Задания
### Задание №1 - Реализовать рекурсивный алгоритм вычисления определителя заданной матрицы, пользуясь формулой разложения по первой строке.

**Базовые случаи**
```python 
if n == 1: return matrix[0][0]
if n == 2: return a*d - b*c
```
**Рекурсивный шаг**
```python
for j in range(n):
    minor = создать_минор(matrix, j) 
    det += (-1)**j * matrix[0][j] * determinant_recursive(minor)
```

### Задание №2 - Алгоритм без использования рекурсии
**Метод Гаусса: приведение матрицы к треугольному виду, определитель = произведению диагональных элементов.**

**Приведение у треугольному виду**
```python
for i in range(n):
    # Поиск ведущего элемента
    max_row = i
    for k in range(i+1, n):
        if abs(mat[k][i]) > abs(mat[max_row][i]):
            max_row = k
    
    # Перестановка строк
    if max_row != i:
        mat[i], mat[max_row] = mat[max_row], mat[i]
        det *= -1
    
    # Обнуление элементов под диагональю
    pivot = mat[i][i]
    det *= pivot
    for k in range(i+1, n):
        factor = mat[k][i] / pivot
        for j in range(i+1, n):
            mat[k][j] -= factor * mat[i][j]
```

**Проверка на вырожденность**
```python
if abs(mat[max_row][i]) < 1e-12:
    return 0  
```

### Задача №3

**1) Блок схема**
```Latex
\documentclass{article}
\usepackage{tikz}
\usetikzlibrary{shapes.geometric, arrows}
\usepackage[utf8]{inputenc}
\usepackage[russian]{babel}

\title{Lab06, Вариант 18}
\author{Блок-схема алгоритма вычисления определителя матрицы \\ разложением по первой строке}

\tikzstyle{startstop} = [rectangle, rounded corners, 
minimum width=3cm, 
minimum height=1cm,
text centered, 
draw=black, 
fill=red!30]

\tikzstyle{io} = [trapezium, 
trapezium stretches=true, 
trapezium left angle=70, 
trapezium right angle=110, 
minimum width=3cm, 
minimum height=1cm, 
text centered, 
draw=black, 
fill=blue!30]

\tikzstyle{process} = [rectangle, 
minimum width=3cm, 
minimum height=1cm, 
text centered, 
text width=3cm,
draw=black, 
fill=orange!30]

\tikzstyle{decision} = [diamond, 
minimum width=3cm, 
minimum height=1cm, 
text centered, 
draw=black, 
fill=green!30]

\tikzstyle{arrow} = [thick,->,>=stealth]

\begin{document}

\maketitle

\begin{tikzpicture}[node distance=1.7cm]

\node (start) [startstop] {Начало};
\node (input) [io, below of=start] {Матрица $A$};
\node (check1) [decision, below of=input, yshift=-0.3cm] {$n = 1$?};
\node (det1) [process, left of=check1, xshift=-3.5cm] {$\det = a_{11}$};

\node (check2) [decision, below of=check1, yshift=-0.3cm] {$n = 2$?};
\node (det2) [process, left of=check2, xshift=-3.5cm] {$\det = a_{11}a_{22} - a_{12}a_{21}$};

\node (init) [process, below of=check2, yshift=-0.3cm] {$\det = 0$, $j = 1$};
\node (loop) [decision, below of=init, yshift=-0.3cm] {$j \leq n$?};

\node (minor) [process, right of=loop, xshift=2.7cm] {Создать $M_{1j}$};
\node (detmin) [process, below of=minor, yshift=0cm] {$d_{min} = \det(M_{1j})$};
\node (update) [process, below of=detmin, yshift=0cm] {$\det = \det + (-1)^j a_{1j} d_{min}$};
\node (inc) [process, below of=update, yshift=0cm] {$j = j + 1$};

\node (output) [io, below of=loop, yshift=-1.7cm] {$\det(A)$};
\node (stop) [startstop, below of=output] {Конец};

\draw [arrow] (start) -- (input);
\draw [arrow] (input) -- (check1);

\draw [arrow] (check1) -- node[anchor=south] {да} (det1);
\draw [arrow] (check1) -- node[anchor=east] {нет} (check2);

\draw [arrow] (check2) -- node[anchor=south] {да} (det2);
\draw [arrow] (check2) -- node[anchor=east] {нет} (init);

\draw [arrow] (det1.west) -- ++(-0.8,0) |- (stop.west);
\draw [arrow] (det2.west) -- ++(-0.8,0) |- (stop.west);

\draw [arrow] (init) -- (loop);
\draw [arrow] (minor) -- (detmin);
\draw [arrow] (detmin) -- (update);
\draw [arrow] (update) -- (inc);
\draw [arrow] (loop.east) -- (minor.west);
% \draw [arrow] (inc.west) |- (loop);

\draw [arrow] (loop) -- node[anchor=east] {нет} (output);
\draw [arrow] (output) -- (stop);

\draw [arrow] (inc.west) -- (stop.east);

\end{tikzpicture}

\end{document}
```

**2) Оценка верхней границы размерности**
```python
def test_recursion_depth():
    import sys
    sys.setrecursionlimit(30) 
    print(f"Current recursion limit: {sys.getrecursionlimit()}")
    
    for n in range(1, 15):
        try:
            test_matrix = [[1 if i == j else 0 for j in range(n)] for i in range(n)]
            result = determinant_recursive(test_matrix)
            print(f"Matrix {n}x{n}: ОК")
        except RecursionError:
            print(f"Matrix {n}x{n}: STACK OVERFLOW")
            print(f"Maximum matrix size for recursion: {n-1}x{n-1}")
            break
        except Exception as e:
            print(f"Matrix {n}x{n}: Error - {e}")
            break
```

**3) Сохранение промежуточных результатов**

**В ручную**
```python
def determinant_recursive_manual(matrix, man=None):
    if man is None: man = {}
    matrix_key = tuple(tuple(row) for row in matrix)
    if matrix_key in man: return man[matrix_key]  # Возврат из кэша
    # ... вычисления ...
    man[matrix_key] = det  # Сохранение в кэш
    return det
```

**С декоратором**
```python
@memoize
def det_recursive(matrix_tuple):
    mat = [list(row) for row in matrix_tuple]
    n = len(mat)
    
    if n == 1: return mat[0][0]
    if n == 2: return mat[0][0]*mat[1][1] - mat[0][1]*mat[1][0]
    
    determinant = 0
    for j in range(n):
        # Создание минора удалением 1-й строки и j-го столбца
        minor = [[mat[i][k] for k in range(n) if k != j] for i in range(1, n)]
        minor_tuple = tuple(tuple(row) for row in minor)
        
        # Рекурсивный вызов для минора с чередующимся знаком
        determinant += ((-1) ** j) * mat[0][j] * det_recursive(minor_tuple)
    
    return determinant
```

**4) Сравнение производительности**
```python
def compare_recursion_calls():
    test_matrices = [
        [[2, 1, 3], [1, 0, 1], [1, 2, 1]],                    #
        [[1, 2, 3, 4], [0, 1, 0, 1], [2, 3, 1, 0], [1, 0, 2, 1]],  
        [[1, 2, 3, 4, 5], [0, 1, 0, 1, 2], ...]              
    ]
    
    for matrix in test_matrices:
        # Обычная рекурсия
        counter_normal = [0]
        result_normal = determinant_recursive_with_count(matrix, counter_normal)
        
        # С мемоизацией
        counter_memo = [0]
        result_memo = determinant_recursive_manual_with_count(matrix, counter=counter_memo)
        
        efficiency = counter_normal[0] / counter_memo[0]
```

**Выводы**
1) Итеративный метод вычисления определителя показал значительно лучшую производительность по сравнению с рекурсивным, особенно для матриц размером более 5×5. Рекурсивный алгоритм страдает от экспоненциального роста времени выполнения.
2) Рекурсивная реализация требует O(n) памяти в стеке вызовов, тогда как итеративная использует O(1) дополнительной памяти. Мемоизация позволяет сократить количество вычислений, но увеличивает потребление памяти для хранения промежуточных результатов.
3) Для реальных задач с матрицами большого размера итеративные методы предпочтительнее. Рекурсивные подходы стоит использовать только для небольших матриц или когда читаемость кода важнее производительности.
4) Использование мемоизации позволяет значительно ускорить рекурсивные вычисления за счет дополнительного расхода памяти, что демонстрирует классический компромисс между временем и памятью в алгоритмах.
5)  Рекурсивная реализация более наглядно отражает математическую формулу разложения определителя, что упрощает понимание алгоритма по сравнению с итеративными методами.


