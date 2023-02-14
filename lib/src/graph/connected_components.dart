import "package:dart_algorithms/src/graph/dfs.dart";
import "package:dart_algorithms/src/graph/graph.dart";

/// {@template connected_component}
/// Pre processes a graph to answer connectivity questions in o(1)
/// Vertices v and w are strongly connected if there is both a directed path
/// from v to w and a directed path from w to v
/// {@endtemplate}
class ConnectedComponents<T> {
  final Graph<T> _graph;
  int _count = -1;
  Map<T, int> _componentId = {};

  /// {@macro connected_component}
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

  /// The amount of connected components the graph has
  int get count => _count;

  /// Given a [vertex] it returns the identifier (int) of the connected component it belongs to.
  int componentId(T vertex) {
    if (_componentId[vertex] != null) {
      return _componentId[vertex]!;
    }
    throw StateError("Vertex $vertex does not exists in graph");
  }

  ///Given a [vertex] it returns all the reachable vertices in its connected component.
  ///If the graph is connected, then it displays the complete graph.
  List<T> component(T vertex) {
    final id = componentId(vertex);
    return _componentId.entries.where((element) => element.value == id).map((e) => e.key).toList();
  }

  /// Whether there is a path between vertices [a] and [b].
  /// Which implies they both belong to the same connected component.
  bool connected(T a, T b) => componentId(a) == componentId(b);
}
