import "dart:math";

import "package:dart_algorithms/src/sorting/insertion_sort.dart";
import "package:dart_algorithms/src/utils.dart";

part "../quick_select.dart";

//Naive and easier to implement version of quicksort, with no optimizations applied for the sake of simplicity
/// {@macro quick_sort}
void quickSortSimple<E>(
  List<E> elements, {
  int lo = 0,
  int? hi,
  int Function(E, E)? compare,
}) {
  hi ??= elements.length - 1;
  if (lo >= hi) return;

  compare ??= defaultCompare;

  final pivot = _partition(elements, lo, hi, compare: compare);
  quickSortSimple(elements, lo: lo, hi: pivot - 1, compare: compare);
  quickSortSimple(elements, lo: pivot + 1, hi: hi, compare: compare);
}

int _partition<E>(
  List<E> elements,
  int lo,
  int hi, {
  int Function(E, E)? compare,
  Random? random,
}) {
  compare ??= defaultCompare;
  var p = random != null ? random.nextInt(hi - lo) + lo : hi;
  elements.swap(p, hi);
  p = hi;
  final pValue = elements[p];

  for (var i = lo; i < p; i++) {
    if (compare(elements[i], pValue) >= 0) {
      elements
        ..swap(i, p - 1)
        ..swap(p, p - 1);
      i--;
      p--;
    }
  }
  return p;
}

/// {@template quick_sort}
/// Sorts a list of [elements] using the QuickSort algorithm
/// and if specified a custom [compare] function.
///
/// QuickSort is one of the most performant sort algorithms.
/// It's unstable with a best/average time complexity of O(n*log(n))
/// and a worst case of O(n²) (although highly unlikely).
/// The space complexity is O(1).
/// {@endtemplate}

// This particular implementation of quicksort has 3 common optimizations.
// It uses insertion sort for small arrays. It uses a random pivot. and
// it uses 3 way merge so it performs better with repeated data.
//
// See _quickSortSimple for an easier to remember implementation.
// If curious about further optimizations to quicksort see head to:
// https://cs.fit.edu/~pkc/classes/writing/samples/bentley93engineering.pdf
void quickSort<E>(
  List<E> elements, {
  int lo = 0,
  int? hi,
  int Function(E, E)? compare,
  Random? random,
}) {
  hi ??= elements.length - 1;
// Cutoff to insertion sort for smaller arrays
  if (hi <= lo + 7) {
    insertionSort(elements, lo: lo, hi: hi + 1, compare: compare);
    return;
  }
  compare ??= defaultCompare;
  random ??= Random();

  var lt = lo;
  var i = lo + 1;
  var gt = hi;

  final p = random.nextInt(hi - lo) + lo;
  elements.swap(p, lo);

  final pValue = elements[lo];

  while (i <= gt) {
    final cmp = compare(elements[i], pValue);
    if (cmp < 0) {
      elements.swap(lt++, i++);
    } else if (cmp > 0) {
      elements.swap(i, gt--);
    } else {
      i++;
    }
  }
  quickSort(elements, lo: lo, hi: lt - 1, compare: compare, random: random);
  quickSort(elements, lo: gt + 1, hi: hi, compare: compare, random: random);
}
