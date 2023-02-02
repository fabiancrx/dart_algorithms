import "package:dart_algorithms/src/utils.dart";

/// Sorts a list of [elements] using the selection Sort algorithm
/// and if specified a custom [compare] function.
///
/// It's a unstable sorting algorithm with a worst and best
/// time complexity of O(n²). The space complexity is O(1).
///
/// It performs (N²/2) compares and N exchanges to sort an array of length N.
void selectionSort<E>(
  List<E> elements, {
  int Function(E, E)? compare,
}) {
  compare ??= defaultCompare;

  for (var i = 0; i < elements.length; i++) {
    var smallestIndex = i;

    for (var j = i + 1; j < elements.length; j++) {
      final smallest = elements[smallestIndex];
      final current = elements[j];
      if (compare(current, smallest) < 0) {
        smallestIndex = j;
      }
    }
    elements.swap(i, smallestIndex);
  }
}
