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
  group("Graph ", () {
    group("Traversal ", () {
      test("Depth First Search", () {
        expect(dfs(sample, 0), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
        expect(dfs(tinyG, 0), [0, 5, 4, 3, 6, 1, 2]);
        print(tinyG);
      });
      test("Breadth First Search", () {
        expect(bfs(sample, 0), [0, 1, 4, 8, 2, 5, 7, 9, 3, 6]);
        expect(bfs(tinyG, 0), [0, 5, 1, 2, 6, 4, 3]);
      });
    });

    group("Connected components", () {
      test("given a graph with 3 connected components they get correctly identified", () {
        final cc = ConnectedComponents(tinyG);
        expect(cc.count, 3);

        expect(cc.connected(0, 6), true);
        expect(cc.componentId(5), 0);
        expect(cc.component(0), unorderedEquals([0, 1, 2, 3, 4, 5, 6]));
        expect(cc.component(7), unorderedEquals([7, 8]));
        expect(cc.component(12), unorderedEquals([12, 11, 10, 9]));

        expect(cc.connected(0, 8), false);
        expect(cc.connected(7, 11), false);
      });
      test(
          "given a fully connected graph only one connected component gets identified "
          "and all vertices belong to that unique connected component", () {
        final cc = ConnectedComponents(sample);
        expect(cc.count, 1);
        for (final vertex in sample.vertices) {
          expect(sample.vertices, unorderedEquals(cc.component(vertex)));
        }
      });
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
