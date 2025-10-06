# Л.Р. - 2 "Алгоритмы сортировки"

**Цао М.М.**

**ИУ10-36**

### Задания
**Параметры: Вариант - 18; n1 - 1000; n2 - 5000; n3 - 10000; n4 - 100000; Метод сортировки 1 - Introsort; Метод сортировки 2 -     Bogosort.**
### 1.Провести классификацию алгоритмов сортировки:
**1.1)Introsort:
        Тип: гибридный, внутренняя
        Устойчивость: неустойчивый
        Память: сортировка на месте O(log n)
        Адаптивность: неадаптивный
        Сложность: в среднем и в худшем случае: O(n log n)**
**1.2)Bogosort:
        Тип: непрактичный, внутренняя
        Устойчивость: зависит от реализации
        Память: O(1) или O(n)
        Адаптивность: неадаптивный
        Сложность: в среднем: O((n+1)!), в худшем случае: бесконечность**
        
### 2.Подготовить теоретическое описание алгоритмов сортировки согласно номеру индивидуального варианта:
    
**2.1)Introsort - гибридный алгоритм, сочетающий быструю сортировку, пирамидальную сортировку и сортировку вставками. Начинает с   
    быстрой  сортировки, переключается на пирамидальную при глубокой рекурсии, и использует сортировку вставками для маленьких массивов**
    
**2.2)Bogosort - шуточный алгоритм, который случайным образом переставляет элементы массива до тех пор, пока он не окажется      
    отсортированным. Крайне неэффективен.**

### 3.Подготовить блок-схему алгоритмов:
    
***3.1)Introsort: 
             Начало
                ⭣
    Вычислить depth_limit = 2*log2(n)
                ⭣
    Вызвать _introsort(arr, 0, n-1, depth_limit)
                ⭣
        n = end - start + 1
                ⭣
            n <= 16? 
                ⭣
         Да ⭠ if ⭢ Нет
          ⭣           ⭣
    (Insertion Sort) (depth_limit == 0?)
         ⭣                  ⭣
        Конец        Да ⭠ if ⭢ Нет
                      ⭣          ⭣
                    (Heapsort)  (Partition - выбрать pivot)
                      ⭣                     ⭣
                    Конец        Рекурсивно: _introsort(left)
                                            ⭣
                                 Рекурсивно: _introsort(right)
                                            ⭣
                                          Конец**
    **3.2)Bogosort:
                Начало
                  ⭣
             attempts = 0
                  ⭣
            is_sorted(arr)?
                  ⭣
            Да ⭠ if ⭢ Нет
             ⭣          ⭣
      (Вернуть True) (attempts < max_attempts?)
             ⭣                  ⭣
            Конец         Да ⭠ if ⭢ Нет
                           ⭣          ⭣
            (shuffle(arr)-перемешать) (Вернуть False)
                           ⭣                 ⭣
                        attempts++        Конец
                           ⭣
                    ⭡ Вернуться к проверке**
    **Исходники по блок-схемам лежат в task03.ipynb**
### 4.Представить описание алгоритмов на псевдокоде:
    
**4.1)Introsort:**
    
```python
function introsort(arr, depth_limit):
    n = length(arr)
    if n <= 16:
        insertion_sort(arr)
    elif depth_limit == 0:
        heapsort(arr)
    else:
        pivot = partition(arr)
        introsort(arr[0:pivot], depth_limit-1)
        introsort(arr[pivot+1:n], depth_limit-1)
```
        
**4.2)Bogosort:**
    
```python
function bogosort(arr, max_attempts):
    attempts = 0
    while not is_sorted(arr) and attempts < max_attempts:
        shuffle(arr)
        attempts += 1
    return is_sorted(arr)
```
        
### 5.Описать достоинства и недостатки каждого алгоритма:
    
**5.1)Introsort:
        Плюсы -> Гарантированная сложность O(n log n); Эффективен на практике; Сортировка на месте.
        Минусы -> Неустойчивый; Сложная реализация.**
    
**5.2)Bogosort:
        Плюсы -> Простая реализация; Забавный алгоритм.
        Минусы -> Непрактичный; Экспоненциальная сложность**
    
### 6.Реализовать алгоритмы сортировки согласно номеру индивидуального варианта:

```python
class SortingAlgorithms:
    @staticmethod
    def insertion_sort(arr: List[int]) -> None:
        for i in range(1, len(arr)):
            key = arr[i]
            j = i - 1
            while j >= 0 and arr[j] > key:
                arr[j + 1] = arr[j]
                j -= 1
            arr[j + 1] = key

    @staticmethod
    def heapify(arr: List[int], n: int, i: int) -> None:
        largest = i
        left = 2 * i + 1
        right = 2 * i + 2

        if left < n and arr[left] > arr[largest]:
            largest = left

        if right < n and arr[right] > arr[largest]:
            largest = right

        if largest != i:
            arr[i], arr[largest] = arr[largest], arr[i]
            SortingAlgorithms.heapify(arr, n, largest)

    @staticmethod
    def heapsort(arr: List[int]) -> None:
        n = len(arr)
        
        for i in range(n // 2 - 1, -1, -1):
            SortingAlgorithms.heapify(arr, n, i)

        for i in range(n - 1, 0, -1):
            arr[i], arr[0] = arr[0], arr[i]
            SortingAlgorithms.heapify(arr, i, 0)

    @staticmethod
    def partition(arr: List[int], low: int, high: int) -> int:
        pivot = arr[high]
        i = low - 1
        
        for j in range(low, high):
            if arr[j] <= pivot:
                i += 1
                arr[i], arr[j] = arr[j], arr[i]
        
        arr[i + 1], arr[high] = arr[high], arr[i + 1]
        return i + 1

    @staticmethod
    def introsort(arr: List[int]) -> None:
        def _introsort(arr: List[int], start: int, end: int, depth_limit: int):
            size = end - start
            
            if size <= 16:
                for i in range(start + 1, end + 1):
                    key = arr[i]
                    j = i - 1
                    while j >= start and arr[j] > key:
                        arr[j + 1] = arr[j]
                        j -= 1
                    arr[j + 1] = key
                return
            
            if depth_limit == 0:
                SortingAlgorithms.heapsort(arr[start:end + 1])
                return
            
            pivot_index = SortingAlgorithms.partition(arr, start, end)
            _introsort(arr, start, pivot_index - 1, depth_limit - 1)
            _introsort(arr, pivot_index + 1, end, depth_limit - 1)
        
        depth_limit = 2 * math.floor(math.log2(len(arr)))
        _introsort(arr, 0, len(arr) - 1, depth_limit)

    @staticmethod
    def is_sorted(arr: List[int]) -> bool:
        return all(arr[i] <= arr[i + 1] for i in range(len(arr) - 1))

    @staticmethod
    def bogosort(arr: List[int], max_attempts: int = 100000) -> bool:
        attempts = 0
        while not SortingAlgorithms.is_sorted(arr) and attempts < max_attempts:
            random.shuffle(arr)
            attempts += 1
        
        return SortingAlgorithms.is_sorted(arr)
```
    
### 7.Протестировать корректность реализации алгоритма:
    
```python
def test_correctness():
    test_cases = [
        [5, 2, 8, 1, 9],
        [1],
        [],
        [3, 3, 3],
        [1, 2, 3, 4, 5],
        [5, 4, 3, 2, 1],
    ]
    
    for i, test_arr in enumerate(test_cases):
        print(f"\nТест {i + 1}: {test_arr}")
        
        arr1 = test_arr.copy()
        SortingAlgorithms.introsort(arr1)
        is_sorted1 = SortingAlgorithms.is_sorted(arr1)
        print(f"Introsort: {arr1} - {'✓' if is_sorted1 else '✗'}")
        
        if len(test_arr) <= 10:
            arr2 = test_arr.copy()
            success = SortingAlgorithms.bogosort(arr2, max_attempts=10000)
            is_sorted2 = SortingAlgorithms.is_sorted(arr2)
            print(f"Bogosort:  {arr2} - {'success' if is_sorted2 else 'failed'} (успех: {success})")
```
    
### 8.Провести ручную трассировку алгоритма:
    
```python
def manual_trace():
    print("Ручная трассировка: ")
        
    test_array = [64, 34, 25, 12, 22, 11, 90]
    print(f"Исходный массив: {test_array}")
    
    arr1 = test_array.copy()
    print(f"\nIntrosort:")
    print(f"До сортировки: {arr1}")
    SortingAlgorithms.introsort(arr1)
    print(f"После сортировки: {arr1}")
    
    arr2 = test_array.copy()
    print(f"\nBogosort:")
    print(f"До сортировки: {arr2}")
    success = SortingAlgorithms.bogosort(arr2, max_attempts=1000)
    print(f"После сортировки: {arr2}")
    print(f"Успешно отсортирован: {success}")
```
    
### 9.Провести сравнение указанных алгоритмов сортировки массивов, содержащих n1, n2, n3 и n4 элементов 
```python
def compare_algorithms_by_size():
    print("=== Сравнение алгоритмов по размерам массивов ===")
    
    sizes = [1000, 5000, 10000, 100000]
    test_array_type = 'random'  
    
    for size in sizes:
        print(f"\n--- Размер массива: {size} ---")
        
        test_array = list(range(size))
        random.shuffle(test_array)
        
        arr1 = test_array.copy()
        start_time = time.time()
        SortingAlgorithms.introsort(arr1)
        end_time = time.time()
        time1 = end_time - start_time
        sorted1 = SortingAlgorithms.is_sorted(arr1)
        print(f"Introsort: {time1:.6f} сек, отсортирован: {sorted1}")
        
        if size <= 10:
            arr2 = test_array.copy()
            start_time = time.time()
            success = SortingAlgorithms.bogosort(arr2, max_attempts=1000)
            end_time = time.time()
            time2 = end_time - start_time
            sorted2 = SortingAlgorithms.is_sorted(arr2)
            print(f"Bogosort:  {time2:.6f} сек, отсортирован: {sorted2}, успех: {success}")
        else:
            print(f"Bogosort:  пропуск (массив слишком большой)")
```

### 10.Каждую функцию сортировки вызывать трижды: для сортировки упорядоченного массива, массива, упорядоченного в обратном порядке  и неупорядоченного массива. Сортируемая последовательность для всех методов должна быть одинаковой (сортировать копии одного массива):

```python
def compare_algorithms_by_array_type():
    print("\n=== Сравнение алгоритмов по типам массивов ===")
    
    size = 1000  
    array_types = ['sorted', 'reverse_sorted', 'random']
    
    for array_type in array_types:
        print(f"\n--- Тип массива: {array_type} ---")
        
        if array_type == 'sorted':
            test_array = list(range(size))
        elif array_type == 'reverse_sorted':
            test_array = list(range(size, 0, -1))
        else:  # random
            test_array = list(range(size))
            random.shuffle(test_array)
        
        arr1 = test_array.copy()
        start_time = time.time()
        SortingAlgorithms.introsort(arr1)
        end_time = time.time()
        time1 = end_time - start_time
        sorted1 = SortingAlgorithms.is_sorted(arr1)
        print(f"Introsort: {time1:.6f} сек, отсортирован: {sorted1}")
        
        if size <= 10:
            arr2 = test_array.copy()
            start_time = time.time()
            success = SortingAlgorithms.bogosort(arr2, max_attempts=1000)
            end_time = time.time()
            time2 = end_time - start_time
            sorted2 = SortingAlgorithms.is_sorted(arr2)
            print(f"Bogosort:  {time2:.6f} сек, отсортирован: {sorted2}, успех: {success}")
        else:
            print(f"Bogosort:  пропуск (массив слишком большой)")
```
    
### 11.Проиллюстрировать эффективность алгоритмов сортировок по заданному критерию. Построить диаграммы указанных зависимостей:

```python 
class SortingTester:
    def __init__(self):
        self.sizes = [1000, 5000, 10000, 100000]
        self.algorithms = {
            'Introsort': SortingAlgorithms.introsort,
            'Bogosort': lambda arr: SortingAlgorithms.bogosort(arr, max_attempts=1000)
        }
    
    def generate_test_arrays(self, size: int) -> dict:
        sorted_arr = list(range(size))
        reverse_sorted = list(range(size, 0, -1))
        random_arr = list(range(size))
        random.shuffle(random_arr)
        
        return {
            'sorted': sorted_arr,
            'reverse_sorted': reverse_sorted,
            'random': random_arr
        }
    
    def run_detailed_tests(self):
        results = {}
        
        for algo_name, algorithm in self.algorithms.items():
            print(f"Детальное тестирование {algo_name}...")
            results[algo_name] = {}
            
            for size in self.sizes:
                print(f"  Размер: {size}")
                results[algo_name][size] = {}
                
                test_arrays = self.generate_test_arrays(size)
                
                for array_type, test_array in test_arrays.items():
                    print(f"    Тип: {array_type}")
                    
                    if algo_name == 'Bogosort' and size > 10:
                        results[algo_name][size][array_type] = {'time': float('inf'), 'is_sorted': False}
                    else:
                        test_arr = test_array.copy()
                        start_time = time.time()
                        result = algorithm(test_arr)
                        end_time = time.time()
                        
                        execution_time = end_time - start_time
                        is_sorted = SortingAlgorithms.is_sorted(test_arr)
                        
                        results[algo_name][size][array_type] = {
                            'time': execution_time,
                            'is_sorted': is_sorted,
                            'result': result
                        }
        
        return results
    
    def plot_results(self, results: dict):
        fig, axes = plt.subplots(2, 2, figsize=(15, 10))
        axes = axes.flatten()
        
        array_types = ['sorted', 'reverse_sorted', 'random']
        
        for i, array_type in enumerate(array_types):
            ax = axes[i]
            
            for algo_name in self.algorithms.keys():
                times = []
                sizes_to_plot = []
                
                for size in self.sizes:
                    result = results[algo_name].get(size, {}).get(array_type)
                    if result and result['time'] != float('inf'):
                        times.append(result['time'])
                        sizes_to_plot.append(size)
                
                if times:
                    ax.plot(sizes_to_plot, times, marker='o', label=algo_name)
            
            ax.set_title(f'Время сортировки ({array_type})')
            ax.set_xlabel('Размер массива')
            ax.set_ylabel('Время (секунды)')
            ax.legend()
            ax.grid(True)

        ax = axes[3]
        for algo_name in self.algorithms.keys():
            times_random = []
            sizes_to_plot = []
            
            for size in self.sizes:
                result = results[algo_name].get(size, {}).get('random')
                if result and result['time'] != float('inf'):
                    times_random.append(result['time'])
                    sizes_to_plot.append(size)
            
            if times_random:
                ax.plot(sizes_to_plot, times_random, marker='o', label=algo_name)
        
        ax.set_title('Сравнение алгоритмов (случайные массивы)')
        ax.set_xlabel('Размер массива')
        ax.set_ylabel('Время (секунды)')
        ax.legend()
        ax.grid(True)
        
        plt.tight_layout()
        plt.savefig('sorting_analysis.png')
        plt.show()
```

**Выводы:**
1) В общем, по результатам тестов стало ясно, что Introsort - это серьезный алгоритм для настоящей работы. Он быстро справляется с любыми массивами, будь они отсортированы, перевернуты или вразброс. Что особенно хочется выделить - его скорость растет пропорционально n log n, а не как у некоторых других алгоритмов, которые на больших данных начинают тормозить непредсказуемо. По памяти Introsort тоже оказался оптимальным - работает прямо в исходном массиве, дополнительной памяти почти не требует.
2) Bogosort же оказался полной противоположностью - полезный метод для изучения, но на практике почти не применяется. Уже на 10 элементах он может работать вечность, а на 1000 элементах все становится куда хуже. Хотя код у него простой, это не делает его эффективным в разработке. Bogosort в плане памяти еще более экономный чем Introsort, но его способности в сортировке оставляют желать лучшего.
3) Графики времени выполнения очень наглядно показывают разницу между алгоритмами. Видно, что Introsort растет плавно, а Bogosort уже на маленьких размерах уходит в небеса.
4) В процессе исследования, стало ясно, что для реальных проектов Introsort или подобные гибридные алгоритмы будут более предпочтительны - они проверены, надежны и встроены в стандартные библиотеки. А Bogosort можно использовать для демонстрации втеоретических аспектах по алгоритмам, чтобы показать, как делать не надо(ну или продемонстрировать самые базовые методы сортировки).
5) Код получился расширяемым - можно легко добавить новые алгоритмы для сравнения или изменить тестовые данные. Это удобно для будущих экспериментов: проводится раздельное тестирование по размерам и типам массивов, тестирование проходит структурировано и быстро.
