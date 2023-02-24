import "package:dart_algorithms/src/graph/cycle_detection.dart";
import "package:dart_algorithms/src/graph/graph.dart";

/// Given a directed acyclic graph (DAG) it returns an ordered sequence of vertices
/// such that every edge dependencies are listed before it.
Iterable<T> topologicalSort<T>(Graph<T> graph, {List<T>? stack}) {
  assert(hasCycle(graph), false);
  final visited = Map<T, bool>.fromIterable(graph.vertices, value: (_) => false);
  stack ??= [];
  final output = <T>[];

  void _dfs(T vertex) {
    visited[vertex] = true;
    for (final neighbour in graph.neighbours(vertex)) {
      if (!visited[neighbour]!) {
        _dfs(neighbour);
      }
    }
    output.add(vertex);
  }

  for (final vertex in graph.vertices) {
    if (!visited[vertex]!) _dfs(vertex);
  }

  return output.reversed;
}
