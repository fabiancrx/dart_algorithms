//Mark v as visited.
// Recursively visit all unmarked
// vertices w adjacent to v.
// Applications:
// - Find all vertices connected to a given source vertex.
// - Find a path between two vertices
// - Topological Sort
// Time complexity: O(e)

import "package:dart_algorithms/src/graph/graph.dart";

Set<T> dfs<T>(Graph<T> graph, T start, {Map<T, bool>? visited, Function(T node)? onVisited}) {
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
