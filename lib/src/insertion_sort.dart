import 'package:dart_algorithms/src/utils.dart';

/// Sorts a list of [elements] using the insertion Sort algorithm
/// and if specified a custom [compare] function.
///
/// It's a stable sorting algorithm with a worst time complexity of O(n²)
/// and a best of O(n). The space complexity is O(1)
///
/// Insertion sort is VERY efficient if the amount of [elements] is small
/// or if the array is sorted or partially sorted.
// Because of the above you might see more advanced sorting algorithms switch
// to insertion sort for small amount of elements or for partially sorted lists
void insertionSort<E>(List<E> elements, {
  int Function(E, E)? compare,
}) {
  compare ??= defaultCompare;

  for (var i = 0; i < elements.length; i++) {
    var j = i;
    while (j > 0 && compare( elements[j],elements[j - 1]) <0) {
      elements.swap(j - 1, j);
      j--;
    }
  }
}
