import "package:dart_algorithms/src/convex_hull.dart";
import "package:test/test.dart";

void main() {
  setUp(() {});
  group("Convex Hull ", () {
    test("Graham Scan finds the correct set of minimal points to create a convex hull", () {
      var points = [
        [1, 1],
        [2, 2],
        [2, 0],
        [2, 4],
        [3, 3],
        [4, 2]
      ];
      expect(
          convexHull(points),
          unorderedEquals([
            [3, 3],
            [4, 2],
            [2, 4],
            [2, 0],
            [1, 1]
          ]));
      points = [
        [1, 2],
        [2, 2],
        [4, 2]
      ];
      expect(
          convexHull(points),
          unorderedEquals([
            [1, 2],
            [4, 2],
            [2, 2]
          ]));
      points = [
        [41, -6],
        [-24, -74],
        [-51, -6],
        [73, 17],
        [-30, -34]
      ];
      expect(
          convexHull(points),
          unorderedEquals([
            [-24, -74],
            [-51, -6],
            [73, 17],
          ]));
    });
  });
}
