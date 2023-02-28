import 'package:collection/collection.dart';
import "package:dart_algorithms/src/graph/graph.dart";

class ShortestPathResult<T> {
  final Map<T, num> cost;
  final Map<T, T> _previous;
  final T source;

  ShortestPathResult(this.source, this.cost, this._previous);

  Iterable<T> minPath(T end) {
    final output = <T>[end];
    var current = end;
    while (current != source) {
      final previous = _previous[current]!;
      output.insert(0, previous);
      current = previous;
    }
    return output;
  }
}

// E log V
//Nearly linear-time when weights are non-negative
/// Returns the shortest path from [source] to all other edges of a given [graph] with non negative weights.
/// It does so in O(E*log V) time and O(V) space.
ShortestPathResult<T> dijkstra<T>(WeightedGraph<T> graph, {required T source, T? sink}) {
  // Book keeping
  final cost = Map<T, num>.fromIterable(graph.vertices, value: (_) => double.infinity);
  int compareByCost(T a, T b) =>
      (cost[a] ?? double.infinity).compareTo(cost[b] ?? double.infinity);
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
