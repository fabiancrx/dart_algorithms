import "package:dart_algorithms/src/graph/bfs.dart";
import "package:dart_algorithms/src/graph/connected_components.dart";
import "package:dart_algorithms/src/graph/cycle_detection.dart";
import "package:dart_algorithms/src/graph/dfs.dart";
import "package:dart_algorithms/src/graph/graph.dart";
import "package:dart_algorithms/src/graph/minimum_spanning_tree.dart";
import "package:dart_algorithms/src/graph/topological_sort.dart";
import "package:test/test.dart";
import "fixtures/fixtures.dart";

void main() {
  late final Graph<int> tinyG;
  late final Graph<int> tinyDirectedG;
  late final Graph<int> tinyDirectedG2;
  late final Graph<int> tinyDirectedG3;
  late final Graph<int> sample;

  setUpAll(() {
    tinyG = fromInput(loadTestFile("tinyG.txt"));
    sample = fromInput(loadTestFile("sample.txt"));
    tinyDirectedG = fromInput(loadTestFile("tinyDG.txt"), directed: true);
    tinyDirectedG2 = fromInput(loadTestFile("tinyDG2.txt"), directed: true);
    tinyDirectedG3 = fromInput(loadTestFile("tinyDG3.txt"), directed: true);
  });
  group("Graph ", () {
    test(" is correctly constructed when directed", () {
      expect(tinyDirectedG.degree(7), 2);

      expect(tinyDirectedG2.toString().isNotEmpty, true);

      expect(tinyDirectedG.neighbours(7).contains(9), true);
      expect(tinyDirectedG.neighbours(9).contains(7), false);
      expect(dfs(tinyDirectedG, 7), unorderedEquals(tinyDirectedG.vertices));
      expect(dfs(tinyDirectedG, 0), unorderedEquals([0, 1, 2, 3, 4, 5]));
    });

    group("cycle ", () {
      test("detection", () {
        expect(hasCycle(tinyDirectedG), true);
        expect(hasCycle(tinyDirectedG2), true);
        expect(hasCycle(tinyDirectedG3), false);

        final tinyGD = fromInput(loadTestFile("tinyG.txt"), directed: true);
        final sampleD = fromInput(loadTestFile("sample.txt"), directed: true);
        final selfLoop = fromInput(loadTestFile("selfLoop.txt"), directed: true);

        expect(hasCycle(tinyGD), false);
        expect(hasCycle(sampleD), false);
        expect(hasCycle(selfLoop), true);
      });

      test("listing", () {
        final selfLoop = fromInput(loadTestFile("selfLoop.txt"), directed: true);
        expect(findCycle(selfLoop), [0, 0]);
        expect(
          findCycle(tinyDirectedG),
          anyOf([
            [2, 3, 2],
            [5, 4, 2, 3, 5],
            [0, 5, 4, 2, 0],
            [6, 8, 6],
            [9, 10, 12, 9],
            [9, 11, 12, 9],
          ]),
        );
      });
    });

    group("Traversal ", () {
      test("Depth First Search", () {
        expect(dfs(sample, 0), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
        expect(dfs(tinyG, 0), [0, 5, 4, 3, 6, 1, 2]);
      });
      test("Breadth First Search", () {
        expect(bfs(sample, 0), [0, 1, 4, 8, 2, 5, 7, 9, 3, 6]);
        expect(bfs(tinyG, 0), [0, 5, 1, 2, 6, 4, 3]);
        expect(bfs(tinyDirectedG2, 0), [0, 1, 2, 4, 3, 5]);
      });
      test("Topological sort", () {
        expect(topologicalSort(tinyDirectedG3), [3, 6, 0, 5, 2, 1, 4]);
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
      test("given a disconnected graph each connected component gets identified", () {
        final cc = ConnectedComponents(tinyDirectedG);
        expect(tinyDirectedG.directed, true);
        expect(cc.count, 5);

        final groups = [
          [1],
          [0, 2, 3, 4, 5],
          [9, 10, 11, 12],
          [6, 8],
          [7]
        ];
        for (final group in groups) {
          final componentId = cc.componentId(group.first);
          for (final vertex in group) {
            expect(cc.componentId(vertex), componentId);
          }
        }
      });
    });

    group("Minimum Spanning Trees", () {
      final tinyEWG = fromInputWeighted(loadTestFile("tinyEWG.txt"));

      test("Kruskal", () {
        // ignore: prefer_int_literals
        expect(kruskal(tinyEWG).fold(0.0, (a, b) => a + b.weight), 1.81);
      });
      test("Prim", () {
        // ignore: prefer_int_literals
        expect(prim(tinyEWG).fold(0.0, (a, b) => a + b.weight), 1.81);
      });
    });
  });
}

WeightedGraph<int> fromInputWeighted(List<String> input, {bool directed = false}) {
  final vertices = int.parse(input.removeAt(0));
  final edges = input.removeAt(0);
  final graph = AdjacencyListWeightedGraph(List.generate(vertices, (i) => i), directed: directed);

  for (final edge in input) {
    final s = edge.split(" ");
    final a = int.parse(s.first);
    final b = int.parse(s[1]);
    final weight = num.parse(s.last);
    graph.addEdge(WeightedEdge(a, b, weight: weight));
  }
  return graph;
}

Graph<int> fromInput(List<String> input, {bool directed = false}) {
  final vertices = int.parse(input.removeAt(0));
  final edges = input.removeAt(0);
  final graph = AdjacencyListGraph(List.generate(vertices, (i) => i), directed: directed);

  for (final edge in input) {
    final s = edge.split(" ");
    final a = int.parse(s.first);
    final b = int.parse(s.last);
    graph.addEdge(a, b);
  }
  return graph;
}