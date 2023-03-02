import "package:collection/collection.dart" show PriorityQueue;
import "package:dart_algorithms/src/graph/graph.dart";

/// Represents the shortest paths from [source] to all other vertices on a graph.
/// You can query it to retrieve an iterable with the shortest path to any vertex.
/// Or the minimum cost.
/// ```
/// final result=dijkstra(graph,source:0);
///
/// result.shortestPath(7);//[0,2,7]
/// result.minimumCost(7);// 0.6
///
/// ```
class ShortestPathResult<T> {
  final Map<T, num> _cost;
  final Map<T, T> _previous;

  /// The starting vertex from which the shortest path was computed.
  final T source;

  /// Creates an object representing the result of running a "Single [source] shortest path" algorithm.
  /// [_cost] is a map between a vertex and the minimum cost to reach it.
  /// [_previous] is a map in which the key is the target vertex and the value the previous vertex in the shortest path
  /// to the key.
  ShortestPathResult(this.source, this._cost, this._previous);

  /// Returns an iterable containing the vertices with the shortest path from [source] to [sink]
  Iterable<T> shortestPath(T sink) {
    final output = <T>[sink];
    var current = sink;
    while (current != source) {
      final previous = _previous[current] as T;
      output.insert(0, previous);
      current = previous;
    }
    return output;
  }

  /// Minimum cost of traversing from [source] to [vertex]
  num cost(T vertex) {
    if (_cost.containsKey(vertex)) return _cost[vertex]!;
    throw Exception("Vertex $vertex is not found ");
  }
}

/// Dijkstra’s algorithm is a Greedy algorithm
/// Returns the shortest path from [source] to all other edges of a given [graph] with non negative weights.
/// It does so in O(E*log V) time and O(V) space.
ShortestPathResult<T> dijkstra<T>(
  WeightedGraph<T> graph, {
  required T source,
}) {
  // pre condition
  if (graph.hasNegativeWeight) throw Exception("Can't calculate shortest path on a graph with negative weight");

  // Book keeping
  final cost = Map<T, num>.fromIterable(graph.vertices, value: (_) => double.infinity);
  int compareByCost(T a, T b) => (cost[a] ?? double.infinity).compareTo(cost[b] ?? double.infinity);
  final pq = PriorityQueue<T>(compareByCost);
  final prev = <T, T>{};

  cost[source] = 0;
  pq.add(source);

  while (pq.isNotEmpty) {
    final vertex = pq.removeFirst();

    for (final edge in graph.edges(vertex)) {
      final previousVertex = edge.a;
      final current = edge.b;
      final newWeight = cost[previousVertex]! + edge.weight;
      if (newWeight < (cost[current] ?? double.infinity)) {
        cost[current] = newWeight;
        prev[current] = previousVertex;
        pq.add(current);
      }
    }
  }

  return ShortestPathResult(source, cost, prev);
}

/// Performs the Bellman Ford algorithm to get the shortest paths from [source] to
/// all vertices. The [graph] is required to not have negative cycles and will raise an exception if one is found.
ShortestPathResult<T> bellmanFord<T>(WeightedGraph<T> graph, {required T source}) {
  // Book keeping
  final cost = Map<T, num>.fromIterable(graph.vertices, value: (_) => double.infinity);
  int compareByCost(T a, T b) => (cost[a] ?? double.infinity).compareTo(cost[b] ?? double.infinity);
  final pq = PriorityQueue<T>(compareByCost);

  final onQ = Map<T, bool>.fromIterable(graph.vertices, value: (_) => false);
  final prev = <T, T>{};

  cost[source] = 0;
  pq.add(source);
  onQ[source] = true;

  bool hasNegativeCycle() {
    for (final edge in graph.allEdges) {
      final previousVertex = edge.a;
      final current = edge.b;
      final newWeight = cost[previousVertex]! + edge.weight;

      if (newWeight < (cost[current] ?? double.infinity)) {
        return true;
      }
    }
    return false;
  }

  final allEdges = graph.allEdges;
  for (var i = 1; i < graph.vertices.length; i++) {
    for (final edge in allEdges) {
      final previousVertex = edge.a;
      final current = edge.b;
      final newWeight = cost[previousVertex]! + edge.weight;

      if (newWeight < (cost[current] ?? double.infinity)) {
        cost[current] = newWeight;
        prev[current] = previousVertex;
      }
    }
  }

  if (hasNegativeCycle()) throw Exception("Negative cycle detected");
  return ShortestPathResult(source, cost, prev);
}
