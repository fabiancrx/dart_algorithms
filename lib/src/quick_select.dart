// ignore_for_file: require_trailing_commas

part of "sorting/quick_sort.dart";

/// Selection Algorithm that finds the [k]th element on an unsorted [arr].
/// With average o(n) complexity.
// Quick select works like quicksort as it takes advantage of partitioning
// the input thus, reducing a portion of the array after each partitioning.
E? quickSelect<E>(
  List<E> arr,
  int k, {
  int lo = 0,
  int? hi,
  int Function(E, E)? compare,
  Random? random,
}) {
  if (k > arr.length) return null;
  hi ??= arr.length - 1;

  random ??= Random();

  final partitionIndex = _partition(arr, lo, hi, compare: compare);

  final target = arr.length - k;
  if (partitionIndex == target) {
    return arr[target];
  } else if (partitionIndex > target) {
    return quickSelect(arr, k,
        lo: lo, hi: partitionIndex - 1, compare: compare);
  } else if (partitionIndex < target) {
    return quickSelect(arr, k,
        lo: partitionIndex + 1, hi: hi, compare: compare);
  }
  return null;
}
