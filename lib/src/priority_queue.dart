import "package:dart_algorithms/src/utils.dart";

/// A Heap based priority queue.
///
/// It efficiently retrieves the smallest element of a collection (Min heap).
/// You can supply a custom [comparator] to change that behavior
/// and make it retrieve tha largest value.
//
// This Priority Queue implementation is based on a Binary Heap.
// Certain invariants must be maintained:
// - The key in each node is larger/smaller than or equal to the keys in that node’s two children (if any)
// - The largest/smallest key in a heap-ordered binary tree is found at the root.
// A heap is a complete binary tree:
// This means all levels are totally filled (except maybe the last level),
//
// If we limit the size of the heap to N, we could ob
class PriorityQueue<E> {
  /// Creates a Priority Queue with a custom [comparator] function
  PriorityQueue([this.comparator = defaultCompare]);

  /// Function used to compare objects in the priority queue
  final Comparator<E> comparator;
  final List<E?> _data = [];

  /// Is the priority Queue empty
  bool get isEmpty => _data.isEmpty;

  /// Number of elements in the priority Queue
  int get size => _data.length;

  E _elementAt(int index) => _data[index] ?? (null as E);

  /// Inserts an item into the priority Queue in O(log*n).
  /// It makes sure the invariants on the data structure are maintained.
  void insert(E item) {
    _data.add(item);
    if (size > 1) _bubbleUp(size - 1);
  }

  /// Returns the smallest/largest element without removing it in O(1)
  E get peek {
    if (_data.isEmpty) throw StateError("No element");
    return _data[0]!;
  }

  /// Removes the largest/smallest key off the top of the priority Queue in O(log*n).
  /// It makes sure the invariants on the data structure are maintained.
  E remove() {
    if (!isEmpty) {
      // Swap first and last item
      _data.swap(0, size - 1);
      final item = _data.removeLast() as E;
      if (!isEmpty) _bubbleDown(0);
      return item;
    } else {
      throw StateError("No element");
    }
  }

// Also known as heapify/bottomUp/swim
  void _bubbleUp(int index) {
    var currentIndex = index;
    while (currentIndex > 0 &&
        comparator(
              _elementAt(currentIndex),
              _elementAt(_getParentIndex(currentIndex)),
            ) <
            0) {
      _data.swap(currentIndex, _getParentIndex(currentIndex));
      currentIndex = _getParentIndex(currentIndex);
    }
  }

// Also known as topDown/sink
  void _bubbleDown(int index) {
    final li = _getLeftChildIndex(index);
    final ri = _getRightChildIndex(index);

    var swap = index;

    if (_indexExists(li) && comparator(_elementAt(li), _elementAt(swap)) < 0) {
      swap = li;
    }

    if (_indexExists(ri) && comparator(_elementAt(ri), _elementAt(swap)) < 0) {
      swap = ri;
    }

    if (swap != index) {
      _data.swap(index, swap);
      _bubbleDown(swap);
    }
  }

  // Helper method to check if the index is not out of bounds.
  bool _indexExists(int n) => n < size;

  //For a child at index i, its parent can be found at index (i-1)/2.
  int _getParentIndex(int i) => (i - 1) ~/ 2;

  // For a parent index n, the left child will be found at index 2*i+1
  int _getLeftChildIndex(int i) => 2 * i + 1;

  // The right child will be found at index 2*i+2
  int _getRightChildIndex(int i) => 2 * i + 2;
}
