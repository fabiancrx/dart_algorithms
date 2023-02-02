import 'dart:math';

import 'package:dart_algorithms/src/utils.dart';

/// Sorts a list of [elements] using the shell Sort algorithm
/// and if specified a custom [compare] function.
///
/// It's a unstable sorting algorithm with a worst time complexity of O(n*3/2)
/// and a best of O(n*log(n)). The space complexity is O(1)
///
// Its an improvement over insertion sort on large inputs
//
// Shellsort performs more operations than quicksort.
// However, since it can be implemented using little code
// It can be a good alternative for programmers in embedded environments
// or on a rush.
void shellSort<E>(
  List<E> elements, {
  int Function(E, E)? compare,
}) {
  compare ??= defaultCompare;

  final sequence = _tokudaSequence(elements.length);

  while (sequence.isNotEmpty) {
    final h = sequence.removeLast();

    for (var i = h; i < elements.length; i++) {
      for (var j = i; j >= h && compare(elements[j],elements[j - 1], ) < 0; j -= h) {
        elements.swap(j, j - h);
      }
    }
  }
}

// Given [len] which represents the length of a list, it generates
// the gap sequence according to Tokuda's algorithm
// For more sequences refer to https://en.wikipedia.org/wiki/Shellsort#Gap_sequences
@pragma('vm:prefer-inline')
List<int> _tokudaSequence(int len) {
  var h = 1;
  final sequence = [h];
  for (var i = 1; h < len; i++) {
    h = ((9 * pow(9 / 4, i) - 4) / 5).ceil();
    sequence.add(h);
  }
  return sequence;
}
