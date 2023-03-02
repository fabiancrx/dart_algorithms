import "package:dart_algorithms/src/graph/bfs.dart";
import "package:dart_algorithms/src/graph/connected_components.dart";
import "package:dart_algorithms/src/graph/cycle_detection.dart";
import "package:dart_algorithms/src/graph/dfs.dart";
import "package:dart_algorithms/src/graph/graph.dart";
import "package:dart_algorithms/src/graph/max_flow.dart";
import "package:dart_algorithms/src/graph/minimum_spanning_tree.dart";
import "package:dart_algorithms/src/graph/shortest_path.dart";
import "package:dart_algorithms/src/graph/topological_sort.dart";
import "package:test/test.dart";
import "fixtures/fixtures.dart";

void main() {
  late final tinyG = fromInput(loadTestFile("tinyG.txt"));
  late final sample = fromInput(loadTestFile("sample.txt"));
  late final tinyDirectedG = fromInput(loadTestFile("tinyDG.txt"), directed: true);
  late final tinyDirectedG2 = fromInput(loadTestFile("tinyDG2.txt"), directed: true);
  late final tinyDirectedG3 = fromInput(loadTestFile("tinyDG3.txt"), directed: true);
  late final tinyEWG = fromInputWeighted(loadTestFile("tinyEWG.txt"));

  group("Graph ", () {
    test(" is correctly constructed when directed", () {
      expect(tinyDirectedG.degree(7), 2);

      expect(tinyDirectedG2.toString().isNotEmpty, true);

      expect(tinyDirectedG.neighbours(7).contains(9), true);
      expect(tinyDirectedG.neighbours(9).contains(7), false);
      expect(dfs(tinyDirectedG, 7), unorderedEquals(tinyDirectedG.vertices));
      expect(dfs(tinyDirectedG, 0), unorderedEquals([0, 1, 2, 3, 4, 5]));
    });

    group("Cycle ", () {
      test("is correctly detected in case of existence", () {
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

      test("first cycle found is correctly listed", () {
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
      test("Kruskal", () {
        // ignore: prefer_int_literals
        expect(kruskal(tinyEWG).fold(0.0, (a, b) => a + b.weight), 1.81);
      });
      test("Prim", () {
        // ignore: prefer_int_literals
        expect(prim(tinyEWG).fold(0.0, (a, b) => a + b.weight), 1.81);
      });
    });

    group("Single source shortest Path", () {
      final tinyEWDG = fromInputWeighted(loadTestFile("tinyEWDG.txt"));
      final tinyEWDGnc = fromInputWeighted(loadTestFile("tinyEWDGnc.txt"));
      final tinyEWDGnw = fromInputWeighted(loadTestFile("tinyEWDGnw.txt"));

      final pathWeights = [0, 1.05, 0.26, 0.99, 0.38, 0.73, 1.51, 0.60];
      final shortestPaths = <int, List<int>>{
        0: [0],
        1: [0, 4, 5, 1],
        2: [0, 2],
        3: [0, 2, 7, 3],
        4: [0, 4],
        5: [0, 4, 5],
        6: [0, 2, 7, 3, 6],
        7: [0, 2, 7],
      };
      test("Dijkstra calculates the single source shortest path correctly", () {
        final sp = dijkstra(tinyEWDG, source: 0);
        for (final vertex in tinyEWDG.vertices) {
          expect(sp.cost(vertex), closeTo(pathWeights[vertex], 0.01));
          expect(sp.shortestPath(vertex), shortestPaths[vertex]);
        }
      });

      test("Dijkstra throws exception when graph has negative weight", () {
        final tinyEWDG = fromInputWeighted(loadTestFile("tinyEWDG.txt"))..addEdge(WeightedEdge(0, 1, weight: -3));

        expect(() => dijkstra(tinyEWDG, source: 0), throwsException);
        expect(() => dijkstra(tinyEWDGnc, source: 0), throwsException);
      });
      test("Bellman-Ford calculates the single source shortest path correctly", () {
        final sp = bellmanFord(tinyEWDG, source: 0);
        for (final vertex in tinyEWDG.vertices) {
          expect(sp.cost(vertex), closeTo(pathWeights[vertex], 0.01));
          expect(sp.shortestPath(vertex), shortestPaths[vertex]);
        }
      });

      test("Bellman-Ford calculates the shortest path when a graph has negative weights", () {
        final pathWeights = [0, -1, 2, -2, 1];
        final sp = bellmanFord(tinyEWDGnw, source: 0);
        for (final vertex in tinyEWDGnw.vertices) {
          expect(sp.cost(vertex), pathWeights[vertex]);
        }
      });
      test("Bellman-Ford throws exception when graph has negative cycle", () {
        expect(() => bellmanFord(tinyEWDGnc, source: 0), throwsException);
      });
    });
    test("Ford Fulkerson", () {
      final tinyFN = fromInputFlow(loadTestFile("tinyFN.txt"));
      final tinyFN2 = fromInputFlow(loadTestFile("tinyFN2.txt"));
      final flowEdges = <FlowEdge<int>>[
        FlowEdge(0, 2, capacity: 3, flow: 2),
        FlowEdge(0, 1, capacity: 2, flow: 2),
        FlowEdge(1, 4, capacity: 1, flow: 1),
        FlowEdge(1, 3, capacity: 3, flow: 1),
        FlowEdge(2, 3, capacity: 1, flow: 1),
        FlowEdge(2, 4, capacity: 1, flow: 1),
        FlowEdge(3, 5, capacity: 2, flow: 2),
        FlowEdge(4, 5, capacity: 3, flow: 2),
      ];
      final result = edmondsKarp(tinyFN, source: 0, sink: 5);

      expect(result.maxFlow, 4);
      expect(tinyFN.allEdges, unorderedEquals(flowEdges));

      expect(edmondsKarp(tinyFN2, source: 0, sink: 3).maxFlow, 200);
    });
  });
}

WeightedGraph<int> fromInputWeighted(List<String> input, {bool directed = false}) {
  final vertices = int.parse(input.removeAt(0));
  final edges = input.removeAt(0);
  final graph =
      AdjacencyListWeightedGraph<int, WeightedEdge<int>>(List.generate(vertices, (i) => i), directed: directed);

  for (final edge in input) {
    final s = edge.split(" ");
    final a = int.parse(s.first);
    final b = int.parse(s[1]);
    final weight = num.parse(s.last);
    graph.addEdge(WeightedEdge(a, b, weight: weight));
  }
  return graph;
}

FlowWeightedGraph<int> fromInputFlow(List<String> input, {bool directed = false}) {
  final vertices = int.parse(input.removeAt(0));
  final edges = input.removeAt(0);
  final graph = AdjacencyListWeightedGraph<int, FlowEdge<int>>(List.generate(vertices, (i) => i), directed: directed);

  for (final edge in input) {
    final s = edge.split(" ");
    final a = int.parse(s.first);
    final b = int.parse(s[1]);
    final weight = num.parse(s.last);
    graph.addEdge(FlowEdge(a, b, capacity: weight));
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
