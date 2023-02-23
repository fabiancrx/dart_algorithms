# Dart Algorithms

[![License: MIT][license_badge]][license_link]

A collection of Algorithms and Data structures implemented in dart.

This repository is intended for educational purposes, you could probably find more optimized implementations of the data
structures and algorithms here described in the standard library or in
the [collections][https://pub.dev/packages/collection] package.

Most of the implementations in this repository can be further studied in the
book [Algorithms 4th edition][https://algs4.cs.princeton.edu/home/] .

### Sorting

- [x] Bubble Sort
- [x] Selection Sort
- [x] Insertion Sort
- [x] Shell Sort
- [x] Merge Sort
- [x] Quick Sort
- [x] Heap Sort

| Algorithm        | Stable | In Place | Running time      | Extra space | Notes                            |
|------------------|--------|----------|-------------------|-------------|----------------------------------|
| Selection Sort   | no     | yes      | n²                | 1           |                                  |
| Insertion sort   | yes    | yes      | n - n²            | 1           | Performs well if input is sorted |
| Shell Sort       | no     | yes      | n*log(n)- n^(3/2) | 1           |                                  |
| Quick Sort       | no     | yes      | n*log(n) - n²     | log(n)      | Unlikely to hit worst case       |
| 3 Way Quick sort | no     | yes      | n - n*log(n)      | log(n)      | Depends on distribution of keys  |
| Merge Sort       | yes    | no       | n*log(n)          | n           |                                  |
| Heap Sort        | no     | yes      | n*log(n)          | 1           |                                  |

### Data Structures

- [x] Priority Queue
- [x] Union Find
- [ ] Binary Search Tree

### Algorithms

- [x] Binary Search
- [x] Quick Select

### Graphs

#### Representations

We represent graphs most commonly either with adjacency matrices or adjacency lists.

For any graph given v vertices and e edges:

| Operation/Representation | Adjacency Matrix | Adjacency List | 
|--------------------------|------------------|----------------|
| Edge between v and w     | O(1)             | O(deg(v))      |
| Neighbours               | O(v)             | O(deg(v))      |
| Space required           | O(v²)            | O(v+e)         |

>Degree(deg): The number of adjacent vertices of a given vertex.

> Note
> Real-world graphs tend to be sparse so an adjacency list is most commonly used.

#### Algorithms

- [x] Depth First Search (DFS)
- [x] Breadth First Search (BFS)
- [x] Topological Sort
- [x] Cycle detection
- [x] Strongly connected components (SCC)

| Algorithm        | Running time | Extra space | 
|------------------|--------------|-------------|
| DFS              | O(v+e)       | O(v)        |
| BFS              | O(v+e)       | O(v)        |
| Topological sort | O(v+e)       | O(v)        |
| SCC              | O(v+e)       | O(v)        |
| Cycle detection  | O(v+e)       | O(v)        |

---

## Running Tests 🧪

To run all unit tests:

```sh
dart pub global activate very_good_cli 
very_good test --coverage
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```


[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg

[license_link]: https://opensource.org/licenses/MIT
