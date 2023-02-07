import "package:dart_algorithms/src/priority_queue.dart";
import "package:test/test.dart";

void main() {
  setUp(() {});
  group("Check PriorityQueue", () {
    test("Min PriorityQueue inserts and removes", () {
      final heap = PriorityQueue<int>();

      expect(heap.size, 0);

      heap
        ..insert(5)
        ..insert(3)
        ..insert(69)
        ..insert(420)
        ..insert(4)
        ..insert(1)
        ..insert(8)
        ..insert(7);

      expect(heap.size, 8);
      expect(heap.remove(), 1);
      expect(heap.remove(), 3);
      expect(heap.size, 6);
      expect(heap.remove(), 4);
      expect(heap.remove(), 5);
      expect(heap.size, 4);
      expect(heap.remove(), 7);
      expect(heap.remove(), 8);
      expect(heap.remove(), 69);
      expect(heap.remove(), 420);
      expect(heap.size, 0);
    });
    test("Max PriorityQueue inserts and removes", () {
      int maxCompare(int a, int b) => b.compareTo(a);
      final heap = PriorityQueue<int>(maxCompare);

      expect(heap.size, 0);

      heap
        ..insert(5)
        ..insert(3)
        ..insert(69)
        ..insert(420)
        ..insert(4)
        ..insert(1)
        ..insert(8)
        ..insert(7);

      expect(heap.size, 8);
      expect(heap.remove(), 420);
      expect(heap.remove(), 69);
      expect(heap.size, 6);
      expect(heap.remove(), 8);
      expect(heap.remove(), 7);
      expect(heap.size, 4);

      expect(heap.remove(), 5);
      expect(heap.remove(), 4);
      expect(heap.remove(), 3);
      expect(heap.remove(), 1);
      expect(heap.size, 0);
    });
  });
}
