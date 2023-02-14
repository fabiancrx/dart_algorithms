import "package:dart_algorithms/src/graph/graph.dart";

/// Graph traversal algorithm that explores the longest path from [start] possible.
/// before going back and visit other unvisited nodes.
/// It is useful for:
/// Discovering connected components.
/// Topological sort
/// Path between edges

Set<T> dfs<T>(Graph<T> graph, T start, {Map<T, bool>? visited, void Function(T node)? onVisited}) {
  final _visited = visited ?? Map<T, bool>.fromIterable(graph.vertices, value: (_) => false);
  final output = <T>{};
  void _dfs(T vertex) {
    _visited[vertex] = true;
    onVisited?.call(vertex);
    output.add(vertex);
    for (final neighbour in graph.neighbours(vertex)) {
      if (!_visited[neighbour]!) {
        _dfs(neighbour);
      }
    }
  }

  _dfs(start);
  return output;
}
