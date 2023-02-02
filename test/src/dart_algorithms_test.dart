import "dart:math";

import "package:dart_algorithms/dart_algorithms.dart";
import "package:dart_algorithms/src/insertion_sort.dart";
import "package:dart_algorithms/src/merge_sort.dart";
import "package:dart_algorithms/src/selection_sort.dart";
import "package:dart_algorithms/src/shell_sort.dart";
import "package:test/test.dart";

int intCompareFn(int a, int b) => a.compareTo(b);

typedef SortFunction = void Function<E>(
  List<E> elements, {
  int Function(E, E)? compare,
});

void main() {
  test("isSorted helper function", () {
    final list = randomList();
    expect(isSorted(list, intCompareFn), false);
    list.sort();
    expect(isSorted(list, intCompareFn), true);
  });

  group("Sort Algorithms are correct", () {
    test("Bubble Sort", () {
      final list = randomList();
      expect(isSorted(list, intCompareFn), false);
      bubbleSort(list);
      expect(isSorted(list, intCompareFn), true);
    });
    test("Selection Sort", () {
      final list = randomList();
      expect(isSorted(list, intCompareFn), false);
      selectionSort(list);
      expect(isSorted(list, intCompareFn), true);
    });
    test("Insertion Sort", () {
      final list = randomList();
      expect(isSorted(list, intCompareFn), false);
      insertionSort(list);
      expect(isSorted(list, intCompareFn), true);
    });
    test("Shell Sort", () {
      final list = randomList();
      expect(isSorted(list, intCompareFn), false);
      shellSort(list);
      expect(isSorted(list, intCompareFn), true);
    });
    test("Merge Sort", () {
      final list = randomList();
      expect(isSorted(list, intCompareFn), false);
      mergeSort(list);
      expect(isSorted(list, intCompareFn), true);
    });
    test("Merge Sort Iterative", () {
      final list = randomList();
      expect(isSorted(list, intCompareFn), false);
      mergeSortIterative(list);
      expect(isSorted(list, intCompareFn), true);
    });
  });
}

List<int> randomList([int size = 1000]) {
  final random = Random();
  return [for (var i = 0; i < size; i++) random.nextInt(42)];
}

bool isSorted<T>(Iterable<T> elements, int Function(T a, T b) compareFn) {
  for (var i = 1; i < elements.length; i++) {
    final prev = elements.elementAt(i - 1);
    final curr = elements.elementAt(i);
    if (compareFn(prev, curr) > 0) return false;
  }
  return true;
}
