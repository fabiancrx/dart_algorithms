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

ShortestPathResult<T> dijkstra<T>(WeightedGraph<T> graph, {required T from, T? to}) {
  final pq = PriorityQueue<T>();
  final cost = Map<T, num>.fromIterable(graph.vertices, value: (_) => double.infinity);
  final prev = <T, T>{};
  //
  cost[from] = 0;
  pq.add(from);

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

  return ShortestPathResult(from, cost, prev);
}
