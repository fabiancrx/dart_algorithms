import "package:dart_algorithms/src/utils.dart";
/// {@template heap_sort}
/// Sorts a list of [elements] using the Heap Sort algorithm
/// and if specified a custom [compare] function.
///
/// Heap Sort is one of the most performant sort algorithms.
/// It's unstable with a worst/best/average time complexity of O(n*log(n))
/// The space complexity is O(1).
/// {@endtemplate}
// It might be useful for embedded devices as its very compact to implement
// Although is not very used in modern systems because poor cache performance.

void heapSort<E>(List<E> elements, {
  int Function(E, E)? compare,
}) {
  if (elements.isEmpty) return;

  final len = elements.length;
// We construct the heap, as we are bubbling down/sink we need to start from the last parent
  // at index (len ~/ 2) - 1 up to the root, this way we ensure we are constructing a max heap.
  for (var i = (len ~/ 2) - 1; i >= 0; i--) {
    _sink(elements, i, len - 1);
  }
// We swap the maximum element which is at the current root to the last position
// of the array. And then we "shrink" the array by 1 by reducing [end].
// This way we effectively move the larger elements to the end of the array.
// And keep calling sink to maintain the heap invariant.
// See https://algs4.cs.princeton.edu/25applications/ for a more graphical explanation.
  for (var end = len - 1; end > 0; end--) {
    elements.swap(0, end);
    _sink(elements, 0, end, compare: compare);
  }
}

void _sink<E>(List<E> arr,
    int index,
    int len, {
      int Function(E, E)? compare,
    }) {
  compare ??= defaultCompare;

  E elementAt(int index) => arr[index] ?? (null as E);

  // Helper method to check if the index is not out of bounds.
  // Note that we don't check with the length of the array but the len
  // variable passed int the parameters.

  bool indexExists(int n) => n < len;

  // For a parent index n, the left child will be found at index 2*i+1
  int getLeftChildIndex(int i) => 2 * i + 1;

  // The right child will be found at index 2*i+2
  int getRightChildIndex(int i) => 2 * i + 2;

  final li = getLeftChildIndex(index);
  final ri = getRightChildIndex(index);

  var swapIndex = index;

  if (indexExists(li) && compare(elementAt(li), elementAt(swapIndex)) > 0) {
    swapIndex = li;
  }

  if (indexExists(ri) && compare(elementAt(ri), elementAt(swapIndex)) > 0) {
    swapIndex = ri;
  }

  if (swapIndex != index) {
    arr.swap(index, swapIndex);
    _sink(arr, swapIndex, len, compare: compare);
  }
}
