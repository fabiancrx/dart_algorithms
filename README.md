# Dart Algorithms

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
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





We represent graphs (most commonly) with adjacency matrices or adjacency lists.
For any graph given v vertices and e edges:

| Operation/Representation | Adjacency Matrix | Adjacency List | 
|--------------------------|------------------|----------------|
| Edge between v and w     | O(1)             | O(deg(v))      |
| Neighbours               | O(v)             | O(deg(v))      |
| Space required           | O(v²)            | O(v+e)         |
| 3 Way Quick sort         | no               | yes            |
| Merge Sort               | yes              | no             |
| Heap Sort                | no               | yes            |

Real-world graphs tend to be sparse

- [ ] Depth First Search
- [ ] Breadth First Search

Path. Is there a path between s and t ?
Shortest path. What is the shortest path between s and t ?
Cycle. Is there a cycle in the graph?
Euler tour. Is there a cycle that uses each edge exactly once?
Hamilton tour. Is there a cycle that uses each vertex exactly once.
Connectivity. Is there a way to connect all of the vertices?
MST. What is the best way to connect all of the vertices?
Biconnectivity. Is there a vertex whose removal disconnects the graph?
Planarity. Can you draw the graph in the plane with no crossing edges
Graph isomorphism. Do two adjacency lists represent the same graph?


---

## Running Tests 🧪

To run all unit tests:

```sh
dart pub global activate coverage 1.2.0
dart test --coverage=coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
open coverage/index.html
```

[dart_install_link]: https://dart.dev/get-dart

[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg

[license_link]: https://opensource.org/licenses/MIT

[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only

[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only

[mason_link]: https://github.com/felangel/mason

[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg

[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis

[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage

[very_good_ventures_link]: https://verygood.ventures

[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only

[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only

[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
