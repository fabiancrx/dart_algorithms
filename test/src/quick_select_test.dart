import "package:dart_algorithms/dart_algorithms.dart";
import 'package:test/test.dart';

void main() {
  setUp(() {});
  group('Check ', () {
    test('', () {
      expect(quickSelect([3, 2, 1, 5, 6, 4], 2), 5);
      expect(quickSelect([3, 2, 3, 1, 2, 4, 5, 5, 6], 4), 4);
      expect(
          quickSelect(
              [3, 2, 1, 5, 6, 4, 0], compare: (a, b) => b.compareTo(a), 2),
          1);
    });
  });
}
