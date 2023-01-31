import 'package:dart_algorithms/src/utils.dart';

/// Sorts a list of [elements] using the bubble Sort algorithm
/// and if specified a custom [compare] function.
///
/// It's a stable sorting algorithm with a Time complexity of O(n²)
/// A space complexity of O(1)
///
void bubbleSort<E>(
  List<E> elements, {
  int Function(E, E)? compare,
}) {
  compare ??= defaultCompare;

  for (var i = 0; i < elements.length; i++) {
    // Little optimization, so if the list is sorted before we finishes all
    // the comparisons the function returns early
    // We assume the list is already sorted unless
    // there is a swap in the inner loop
    var isListSorted = true;

    for (var j = 0; j < elements.length - i - 1; j++) {
      final curr = elements[j];
      final next = elements[j + 1];
      if (compare(next, curr) < 0) {
        elements.swap(j, j + 1);
        // If there is a swap that means the list is not sorted
        isListSorted = false;
      }
    }
    if (isListSorted) break;
  }
}
