import "package:dart_algorithms/src/graph/dfs.dart";
import "package:dart_algorithms/src/graph/graph.dart";

class ConnectedComponents<T> {
  final Graph<T> _graph;
  int _count = -1;
  Map<T, int> _componentId = {};

  ConnectedComponents(this._graph) {
    _compute();
  }

  void _compute() {
    _count = 0;
    _componentId = {};
    if (_graph.vertices.isEmpty) return;
    final visited = Map<T, bool>.fromIterable(_graph.vertices, value: (_) => false);

    for (final vertex in _graph.vertices) {
      if (!(visited[vertex] ?? true)) {
        dfs(
          _graph,
          vertex,
          visited: visited,
          onVisited: (n) {
            _componentId[n] = _count;
          },
        );
        _count++;
      }
    }
  }

  int get count => _count;

  int componentId(T vertex) {
    if (_componentId[vertex] != null) {
      return _componentId[vertex]!;
    }
    throw StateError("Vertex $vertex does not exists in graph");
  }

  bool connected(T a, T b) => componentId(a) == componentId(b);
}
