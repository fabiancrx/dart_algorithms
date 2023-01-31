int defaultCompare(Object? value1, Object? value2) => (value1 as Comparable<Object?>).compareTo(value2);

extension IterableSwapX on List {
  void swap(int indexA, int indexB) {
    if (isEmpty || indexA > length || indexB > length || indexA == indexB) return;

    final temp = this[indexA];
    this[indexA] = this[indexB];
    this[indexB] = temp;
  }
}
