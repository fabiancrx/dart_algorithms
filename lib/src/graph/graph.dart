import "dart:collection";

/// Represents a graph data structure
abstract class Graph<T> {
  /// If true the graph edges are directed
  bool get directed;

  Graph(Iterable<T> vertices);

  /// A list of all the neighbours of [vertex]
  Set<T> neighbours(T vertex);

  /// Returns all the vertices of a given Graph
  Set<T> get vertices;

  /// Whether the graph contains [vertex]
  bool contains(T vertex);

  ///Connects vertices [a] and [b]
  /// If the graph is directed only [a] will be connected to [b].
  /// If the graph is not directed [a]->[b] and [b]->[a]
  void addEdge(T a, T b);

  /// Adds a new vertex to the graph
  void addVertex(T a);

  /// The degree of a vertex [vertex]. The degree is the amount of edges a vertex has
  /// If the vertex does not exists it returns -1
  int degree(T vertex);

  /// Returns a reversed representation of a graph.
  /// If the graph is undirected the reverse and original representations are the same.
  /// If it's a digraph then all wdges between a and b are reversed
  Graph<T> reversed();
}

///{@template adj_list}
/// Graph representation backed by an adjacency list. It requires O(v+e) space and is better suited for sparse graphs
///{@endtemplate}
// Most graphs in practice are sparse
class AdjacencyListGraph<T> implements Graph<T> {
  final HashMap<T, Set<T>> _list = HashMap();
  @override
  final bool directed;

  ///  Directed defines if the graph is a Digraph.

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
  String toString() {
    final sb = StringBuffer();
    for (final entry in _list.entries) {
      sb.writeln("[${entry.key}] => ${entry.value}");
    }
    return sb.toString();
  }

  @override
  Graph<T> reversed() {
    assert(directed, "Graph must be directed in order to be reversed");
    if (!directed) return this;

    final R = AdjacencyListGraph(vertices, directed: directed);

    for (final vertex in vertices) {
      for (final w in neighbours(vertex)) {
        R.addEdge(w, vertex);
      }
    }
    return R;
  }
}

/// A graph representation in which edges have weight.
abstract class WeightedGraph<V> {
  /// If true the graph is directed
  bool get directed;

  /// Whether any edge has negative weight.
  bool get hasNegativeWeight;

  /// Returns a set of all edges in the graph
  Set<WeightedEdge<V>> get allEdges;

  /// Set of all vertices in the graph
  Set<V> get vertices;

  /// Given a [vertex] it returns all the its edges  to other vertices
  Set<WeightedEdge<V>> edges(V vertex);

  /// Adds an [edge] to the graph. May throw an exception if any of its vertices do not exist.
  void addEdge(WeightedEdge<V> edge);
}

/// Represents an edge between vertices of a graph that is weighted connecting vertices [a] and [b]
class WeightedEdge<T> implements Comparable<WeightedEdge<T>> {
  /// First vertex connected by the edge. If the graph is directed this is the source vertex.
  final T a;

  /// Second vertex connected by the edge. If the graph is directed this is the target vertex.
  final T b;

  /// Weight of the edge
  final num weight;

  /// Constructs an edge between vertex [a] and [b] with weight [weight](zero if omited)
  WeightedEdge(this.a, this.b, {this.weight = 0});

  @override
  int compareTo(WeightedEdge<T> other) => weight.compareTo(other.weight);

  @override
  String toString() => "$a--[$weight]--$b";

  /// Given a vertex [x] return the other vertex in the edge. If [x] is not part of the edge an exception is thrown
  T other(T x) {
    if (x == a) return b;
    if (x == b) return a;
    throw Exception("Can't return other node in the edge as $x is not $a or $b");
  }
}

///{@macro adj_list}
class AdjacencyListWeightedGraph<T> implements WeightedGraph<T> {
  final HashMap<T, Set<WeightedEdge<T>>> _list = HashMap();
  @override
  final bool directed;
  @override
  bool hasNegativeWeight = false;

  ///  Directed defines if the graph is a Digraph.

  AdjacencyListWeightedGraph(Iterable<T> vertices, {this.directed = false}) {
    for (final vertex in vertices) {
      _list[vertex] = {};
    }
  }

  @override
  void addEdge(WeightedEdge<T> edge) {
    if (_list[edge.a] == null || _list[edge.b] == null) {
      throw StateError("Can't add edge between two vertices that do not exist");
    }
    if (edge.weight <= 0) {
      hasNegativeWeight = true;
    }
    _list[edge.a]!.add(edge);
    if (!directed) {
      _list[edge.b]!.add(edge);
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
  Set<WeightedEdge<T>> edges(T vertex) {
    if (contains(vertex)) return _list[vertex]!;
    throw StateError("Error retrieving neighbours of vertex $vertex does not exist");
  }

  @override
  Set<WeightedEdge<T>> get allEdges => _list.values.fold(<WeightedEdge<T>>{}, (prev, curr) => prev.union(curr));

  @override
  Set<T> get vertices => _list.keys.toSet();

  @override
  String toString() {
    final sb = StringBuffer();
    for (final entry in _list.entries) {
      sb.writeln("[${entry.key}] => ${entry.value}");
    }
    return sb.toString();
  }
}
