// The BFS tree is useful for computing distances
// between pairs of vertices.
// Bipartite:
//Color the levels of the BFS tree in
// alternating colors.
// • If you never color two connected
// nodes the same color, then it is
// bipartite.
// • Otherwise, it’s not.

import "dart:collection";

import "package:dart_algorithms/src/graph/graph.dart";

Set<T> bfs<T>(Graph<T> graph, T start) {
  final q = Queue<T>();
  final visited = Map<T, bool>.fromIterable(graph.vertices, value: (_) => false);
  final output = <T>{};

  q.add(start);

  while (q.isNotEmpty) {
    final node = q.removeFirst();
    visited[node] = true;
    output.add(node);
    q.addAll(graph.neighbours(node).where((element) => !(visited[element] ?? true)));
  }
  return output;
}
