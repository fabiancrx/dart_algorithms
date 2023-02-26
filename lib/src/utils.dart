int defaultCompare(Object? value1, Object? value2) =>
    (value1 as Comparable<Object?>).compareTo(value2);

extension IterableSwapX<T> on List<T> {
  void swap(int indexA, int indexB) {
    if (isEmpty || indexA > length || indexB > length || indexA == indexB) {
      return;
    }

    final temp = this[indexA];
    this[indexA] = this[indexB];
    this[indexB] = temp;
  }
}


/// Greatest common divisor
int gcd(int a, int b) => b == 0 ? a : gcd(b, a % b);

/// Least common multiple
int lcm(int a, int b) => a * b ~/ gcd(a, b);
