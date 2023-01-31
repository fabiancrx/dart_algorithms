// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:dart_algorithms/dart_algorithms.dart';
import 'package:dart_algorithms/src/insertion_sort.dart';
import 'package:dart_algorithms/src/selection_sort.dart';
import 'package:test/test.dart';

int intCompareFn(int a, int b) => a.compareTo(b);

typedef SortFunction = void Function<E>(
  List<E> elements, {
  int Function(E, E)? compare,
});

void main() {
  group('Sort Algorithms are correct', () {
    test('Bubble Sort', () {
      final list = randomList();
      expect(isSorted(list, intCompareFn), false);
      bubbleSort(list);
      expect(isSorted(list, intCompareFn), false);
    });
    test('Selection Sort', () {
      final list = randomList();
      expect(isSorted(list, intCompareFn), false);
      selectionSort(list);
      expect(isSorted(list, intCompareFn), false);
    });
    test('Insertion Sort', () {
      final list = randomList();
      expect(isSorted(list, intCompareFn), false);
      insertionSort(list);
      expect(isSorted(list, intCompareFn), false);
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
    if (compareFn(prev, curr) < 1) return false;
  }
  return true;
}
