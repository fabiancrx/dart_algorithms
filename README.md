# Dart Algorithms

[![License: MIT][license_badge]][license_link]

A collection of Algorithms and Data structures implemented in dart.

This repository is intended for educational purposes, you could probably find more optimized implementations of the data
structures and algorithms here described in the standard library or the [collections package][collections_package].

Most of the implementations in this repository can be further studied in the
book [Algorithms 4th edition][algorithms_book] .

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

### Algorithms

- [x] Binary Search
- [x] Quick Select
- [x] Knuth-Morris-Pratt

### Graphs

#### Representations

We represent graphs most commonly either with adjacency matrices or adjacency lists.

For any graph given V vertices and E edges:

| Operation/Representation | Adjacency Matrix | Adjacency List | 
|--------------------------|------------------|----------------|
| Edge between v and w     | O(1)             | O(deg(v))      |
| Neighbours               | O(v)             | O(deg(v))      |
| Space required           | O(v²)            | O(v+e)         |

> Degree(deg): The number of adjacent vertices of a given vertex.

> Note
> Real-world graphs tend to be sparse so an adjacency list is most commonly used.

#### Algorithms

- [x] Depth First Search (DFS)
- [x] Breadth First Search (BFS)
- [x] Topological Sort
- [x] Cycle detection
- [x] Strongly connected components (SCC)
- [x] Dijkstra
- [x] Bellman-Ford
- [x] Edmonds-Karp
- [ ] A*

| Algorithm        | Running time | Extra space | Notes                                           |
|------------------|--------------|-------------|-------------------------------------------------|
| DFS              | O(v+e)       | O(v)        |                                                 |
| BFS              | O(v+e)       | O(v)        |                                                 |
| Topological sort | O(v+e)       | O(v)        | Requires no directed cycles                     |
| SCC              | O(v+e)       | O(v)        |                                                 |
| Cycle detection  | O(v+e)       | O(v)        |                                                 |
| Dijkstra         | O(E*logV)    | O(V)        | Requires no negative weights or negative cycles |
| Bellman-Ford     | O(E*V)       | O(V)        | Requires no negative cycles                     |
| Edmonds-Karp     | O(V*E²)      | O(V)        |                                                 |

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

[algorithms_book]: https://algs4.cs.princeton.edu/home/
[collections_package]: https://pub.dev/packages/collection
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
