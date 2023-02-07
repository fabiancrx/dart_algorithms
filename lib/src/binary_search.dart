/// Performs a binary search of [item] in [elements].
/// Returns the index of the [item] or -1 if not found.
/// [elements] is required to be sorted.
/// The complexity is O(log(n))

int binarySearch<E extends Comparable<dynamic>>(Iterable<E> elements, E item) {
  assert(_isSortedAscending(elements), "Elements MUST be in sorted order");
  var lo = 0;
  var hi = elements.length - 1;

  while (lo <= hi) {
    final mid = lo + (hi - lo) ~/ 2;
    final compare = item.compareTo(elements.elementAt(mid));

    if (compare < 0) {
      hi = mid - 1;
    } else if (compare > 0) {
      lo = mid + 1;
    } else {
      return mid;
    }
  }
  return -1;
}

bool _isSortedAscending<E extends Comparable<dynamic>>(Iterable<E> elements) {
  for (var i = 1; i < elements.length; i++) {
    if (elements.elementAt(i - 1).compareTo(elements.elementAt(i)) > 0)
      return false;
  }
  return true;
}
