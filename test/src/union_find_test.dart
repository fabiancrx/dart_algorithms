import "package:dart_algorithms/src/union_find.dart";
import "package:test/test.dart";

void main() {
  final components = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"];

  test("Union find", () {
    final uf = UnionFind(components);
    expect(uf.components, components.length);

    uf.union("A", "B");
    expect(uf.components, components.length - 1);
    expect(uf.find("A"), uf.find("B"));

    uf.union("C", "D");
    expect(uf.components, components.length - 2);
    uf.union("E", "F");
    expect(uf.components, components.length - 3);

    uf.union("G", "H");
    expect(uf.components, components.length - 4);

    uf.union("I", "J");
    expect(uf.components, components.length - 5);
    uf.union("J", "G");
    expect(uf.components, components.length - 6);
    expect(uf.find("J"), uf.find("H"));
    uf.union("H", "F");
    expect(uf.components, components.length - 7);
    uf
      ..union("A", "C")
      ..union("D", "E");
    expect(uf.components, 1);

    uf
      ..union("G", "B")
      ..union("I", "J");
    expect(uf.components, 1);
  });
}
