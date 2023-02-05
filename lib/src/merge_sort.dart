import "dart:math";
import "package:dart_algorithms/src/insertion_sort.dart";
import "package:dart_algorithms/src/utils.dart";

/// {@template merge_sort}
/// Sorts a list of [elements] using the MergeSort algorithm
/// and if specified a custom [compare] function.
///
/// Merge sort is one of the most performant sort algorithms.
/// It's stable with a worst/best/average time complexity of O(n*log(n))
/// The space complexity is O(n).
/// {@endtemplate}
void mergeSort<E>(
  List<E> elements, {
  int Function(E, E)? compare,
  int lo = 0,
  int? hi,
}) {
  hi ??= elements.length - 1;
  if (hi <= lo + 7) {
    // We fallback to insertion sort for small arrays, because:
    // 1. Insertion sort is more efficient for small arrays.
    // 2. Insertion sort is stable.
    insertionSort(elements, compare: compare, lo: lo, hi: hi+1);
    return;
  } else {
    final mid = lo + (hi - lo) ~/ 2;

    mergeSort(elements, lo: lo, hi: mid, compare: compare);
    mergeSort(elements, lo: mid + 1, hi: hi, compare: compare);
    _merge(elements, lo, mid, hi, compare: compare);
  }
}

/// Iterative implementation of the Merge sort Algorithm
/// {@macro dart_algorithms}
void mergeSortIterative<E>(
  List<E> elements, {
  int Function(E, E)? compare,
  int lo = 0,
  int? hi,
}) {
  compare ??= defaultCompare;

  final n = elements.length;

  for (var len = 1; len < n; len = len + len) {
    // len:subarray size
    for (var lo = 0; lo < n - len; lo += len + len) {
      // lo: subarray index
      _merge(
        elements,
        lo,
        lo + len - 1,
        min(lo + len + len - 1, n - 1),
        compare: compare,
      );
    }
  }
}

void _merge<E>(
  List<E> arr,
  int lo,
  int mid,
  int hi, {
  int Function(E, E)? compare,
}) {
  compare ??= defaultCompare;
  // If the last element of the left array is smaller than the first element of
  // the right array then the two sub-arrays are sorted.

  if (compare(arr[mid], arr[mid + 1]) < 0) return;

  final leftSize = mid - lo + 1;
  final rightSize = hi - mid;

  final leftArray = List.generate(leftSize, (i) => arr[i + lo]);
  final rightArray = List.generate(rightSize, (i) => arr[i + mid + 1]);

  for (var i = 0, j = 0, k = lo; k <= hi; k++) {
    if ((i < leftSize) && (j >= rightSize || compare(leftArray[i], rightArray[j]) < 0)) {
      arr[k] = leftArray[i];
      i++;
    } else {
      arr[k] = rightArray[j];
      j++;
    }
  }
}
