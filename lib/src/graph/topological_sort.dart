import "package:dart_algorithms/src/graph/graph.dart";

Iterable<T> topologicalSort<T>(Graph<T> graph, {List<T>? stack}) {
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
