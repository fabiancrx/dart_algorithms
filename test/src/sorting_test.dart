import "dart:math";

import "package:dart_algorithms/dart_algorithms.dart";
import "package:test/test.dart";

int intCompareFn(int a, int b) => a.compareTo(b);

int boxedIntCompareFn(BoxedInt a, BoxedInt b) => a.value.compareTo(b.value);

typedef SortFunction = void Function<E>(
  List<E> elements, {
  int Function(E, E)? compare,
});
// TODO (croxx5f): Add stability
void main() {
  final datasets = [
    randomList,
    mostlySorted,
    sortedList,
    reverseOrderedList,
  ];
  final sortingAlgorithms = {
    "Bubble Sort": bubbleSort,
    "Insertion Sort": insertionSort,
    "Selection Sort": selectionSort,
    "Shell Sort": shellSort,
    "Merge Sort": mergeSort,
    "Merge Sort Iterative": mergeSortIterative,
    "Quick Sort": quickSort,
    "Quick Sort Simple implementation": quickSortSimple,
    "Heap Sort": heapSort
  };
  test("isSorted helper function", () {
    final list = randomList();
    expect(isSorted(list, intCompareFn), false);
    list.sort();
    expect(isSorted(list, intCompareFn), true);
  });

  group("Sort Algorithms are correct", () {
    for (final sort in sortingAlgorithms.entries) {
      test(sort.key, () {
        for (final dataset in datasets) {
          final list = dataset();
          sort.value(list);
          expect(isSorted(list, intCompareFn), true);
        }
      });
    }
  });
}

class BoxedInt {
  final int id;
  final int value;

  BoxedInt(this.value, {required this.id});

  static List<BoxedInt> intToBoxed(List<int> ints) {
    return List.generate(ints.length, (index) => BoxedInt(ints[index], id: index));
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is BoxedInt && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

List<int> randomList([int size = 1000]) {
  final random = Random();
  return [for (var i = 0; i < size; i++) random.nextInt(42)];
}

List<int> mostlySorted([int size = 1000]) {
  final random = Random();
  final list = sortedList(size);
  for (var i = 0; i < size ~/ 10; i++) {
    list.insert((i * 10) % size, random.nextInt(42));
  }
  return randomList(size)..sort();
}

List<int> sortedList([int size = 1000]) => randomList(size)..sort();

List<int> reverseOrderedList([int size = 1000]) => sortedList(size).reversed.toList();

bool isSorted<T>(Iterable<T> elements, int Function(T a, T b) compareFn) {
  for (var i = 1; i < elements.length; i++) {
    final prev = elements.elementAt(i - 1);
    final curr = elements.elementAt(i);
    if (compareFn(prev, curr) > 0) return false;
  }
  return true;
}
