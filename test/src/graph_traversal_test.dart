import "package:dart_algorithms/src/graph/bfs.dart";
import "package:dart_algorithms/src/graph/connected_components.dart";
import "package:dart_algorithms/src/graph/dfs.dart";
import "package:dart_algorithms/src/graph/graph.dart";
import "package:test/test.dart";
import "fixtures/fixtures.dart";

void main() {
  late final Graph<int> tinyG;
  late final Graph<int> sample;
  setUpAll(() {
    tinyG = fromInput(loadTestFile("tinyG.txt"));
    sample = fromInput(loadTestFile("sample.txt"));
  });
  group("Graph", () {
    test("Depth First Search", () {
      expect(dfs(sample, 0), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
    });
    test("Breadth First Search", () {
      expect(bfs(sample, 0), [0, 1, 4, 8, 2, 5, 7, 9, 3, 6]);
    });
    test("Connected components", () {
      final cc = ConnectedComponents(tinyG);
      expect(cc.count, 3);


      // 6 5 4 3 2 1 0
      // 8 7
      // 12 11 10 9
      expect(cc.connected(0, 6), true);
      expect(cc.connected(0, 8), false);
      expect(cc.connected(7, 11), false);

      expect(cc.componentId(5), 0);
    });
  });
}

Graph<int> fromInput(List<String> input) {
  final vertices = int.parse(input.removeAt(0));
  final edges = input.removeAt(0);
  final graph = AdjacencyListGraph(List.generate(vertices, (i) => i));

  for (final edge in input) {
    final s = edge.split(" ");
    final a = int.parse(s.first);
    final b = int.parse(s.last);
    graph.addEdge(a, b);
  }
  return graph;
}
