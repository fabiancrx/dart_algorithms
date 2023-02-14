import "dart:collection";

import "package:dart_algorithms/src/graph/graph.dart";

/// Graph traversal algorithm that explores all nodes at the present depth
/// before to the next level of depth.
/// It is useful for:
/// Discovering connected components.
/// Shortest path on unweighted graphs.
/// Testing if a graph is bipartite.
//https://upload.wikimedia.org/wikipedia/commons/4/46/Animated_BFS.gif

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
