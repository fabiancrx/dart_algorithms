import "package:dart_algorithms/src/graph/bfs.dart";
import "package:dart_algorithms/src/graph/connected_components.dart";
import "package:dart_algorithms/src/graph/dfs.dart";
import "package:dart_algorithms/src/graph/graph.dart";
import "package:test/test.dart";
import "fixtures/fixtures.dart";

void main() {
  late final Graph<int> tinyG;
  setUpAll(() {
    tinyG = fromInput(loadTestFile("tinyG.txt"));
  });
  group("Check DFS", () {
    test("", () {
      tinyG.vertices.forEach((element) {
        print("$element ${tinyG.neighbours(element)}");
      });
    });
    test("dfs", () {
      final sample = """10
9
0 1
0 4
0 8
1 2
2 3
4 5
5 6
4 7
0 8
8 9"""
          .split("\n");
      final graph = fromInput(sample);
      print("dfs(${dfs(graph, 0)})");
      print("bfs(${bfs(graph, 0)})");
    });
    test("Connected components", () {
      final cc = ConnectedComponents(tinyG);
      expect(cc.count, 3);
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
