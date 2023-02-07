import "package:dart_algorithms/src/binary_search.dart";
import "package:test/test.dart";

void main() {

  test("Binary Search", () {
    final arr = [1, 2, 3, 4, 5,5,5, 99, 101];

    expect(binarySearch(arr, 5), 4);
    expect(binarySearch(arr, 99), 7);
    expect(binarySearch(arr, 101), 8);
    expect(binarySearch(arr, 1), 0);
    expect(binarySearch(arr, 0), -1);
    expect(binarySearch(<int>[], 42), -1);

    expect(() => binarySearch([1, 3, 9, 0], 42), throwsA(isA<AssertionError>()));
  });
}
