abstract class Graph<T> {
  bool get directed;

  Graph(Iterable<T> vertices);

  /// A list of all the neighbours of [vertex]
  Set<T> neighbours(T vertex);

  /// Returns all the vertices of a given Graph
  Set<T> get vertices;

  /// Whether the graph contains [vertex]
  bool contains(T vertex);

  ///Connects vertices [a] and [b]
  void addEdge(T a, T b);

  /// Adds a new vertex to the graph
  void addVertex(T a);

  /// The degree of a vertex [vertex]. The degree is the amount of edges a vertex has
  /// If the vertex does not exists it returns -1
  int degree(T vertex);
}

class AdjacencyListGraph<T> implements Graph<T> {
  final Map<T, Set<T>> _list = {};
  final bool directed;

  AdjacencyListGraph(Iterable<T> vertices, {this.directed = false}) {
    for (final vertex in vertices) {
      _list[vertex] = {};
    }
  }

  @override
  void addEdge(T a, T b) {
    if (_list[a] == null || _list[b] == null) {
      throw StateError("Can't add edge between two vertices that do not exist");
    }
    _list[a]!.add(b);
    if (!directed) {
      _list[b]!.add(a);
    }
  }

  @override
  void addVertex(T a) {
    _list[a] = {};
  }

  @override
  bool contains(T vertex) => _list[vertex] != null;

  @override
  int degree(T vertex) => _list[vertex]?.length ?? -1;

  @override
  Set<T> neighbours(T vertex) {
    if (contains(vertex)) return _list[vertex]!;
    throw StateError("Error retrieving neighbours of vertex $vertex does not exist");
  }

  @override
  Set<T> get vertices => _list.keys.toSet();

  @override
  String toString(){
    final sb=StringBuffer();
    for(final entry in _list.entries){
      sb.writeln("[${entry.key}] => ${entry.value}");
    }
    return sb.toString();
  }
}
