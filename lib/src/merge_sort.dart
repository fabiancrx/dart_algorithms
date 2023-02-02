import "dart:math";
import "package:dart_algorithms/src/utils.dart";
/// Sorts a list of [elements] using the insertion Merge algorithm
/// and if specified a custom [compare] function.
///
/// Merge sort is one of the most performant sort algorithms.
/// It's stable with a worst/best/average time complexity of O(n+log(n))
/// The space complexity is O(n).
///
void mergeSort<E>(
  List<E> elements, {
  int Function(E, E)? compare,
  int lo = 0,
  int? hi,
}) {
  hi ??= elements.length - 1;
  if (hi <= lo) return;
  final mid = lo + (hi - lo) ~/ 2;

  mergeSort(elements, lo: lo, hi: mid, compare: compare);
  mergeSort(elements, lo: mid + 1, hi: hi, compare: compare);
  _merge(elements, lo, mid, hi, compare: compare);
}

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
  List<E> elements,
  int lo,
  int mid,
  int hi, {
  int Function(E, E)? compare,
}) {
  compare ??= defaultCompare;

  if (compare(elements[mid], elements[mid + 1]) < 0) return;

  final leftSize = mid - lo + 1;
  final rightSize = hi - mid;

  final leftArray = List.generate(leftSize, (index) => elements[index + lo]);
  final rightArray = List.generate(rightSize, (index) => elements[index + mid + 1]);

  for (var i = 0, j = 0, k = lo; k <= hi; k++) {
    if ((i < leftSize) && (j >= rightSize || compare(leftArray[i], rightArray[j]) < 0)) {
      elements[k] = leftArray[i];
      i++;
    } else {
      elements[k] = rightArray[j];
      j++;
    }
  }
}
