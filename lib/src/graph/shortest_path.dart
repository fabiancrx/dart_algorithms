import "dart:collection";

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
  if(graph.hasNegativeWeight) throw Exception("Can't calculate shortest path on a graph with negative weight");

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

ShortestPathResult<T> bellmanFord<T>(WeightedGraph<T> graph, {required T source}) {
  final pq = PriorityQueue<T>();
  final cost = Map<T, num>.fromIterable(graph.vertices, value: (_) => double.infinity);
  final onQ = Map<T, bool>.fromIterable(graph.vertices, value: (_) => false);
  final prev = <T, T>{};
  //
  cost[source] = 0;
  pq.add(source);
  onQ[source] = true;

  bool hasNegativeCycle() {
    for (final edge in graph.allEdges) {
      if (cost[edge.a] != double.infinity && cost[edge.a]! + edge.weight < cost[edge.b]!) {
        return true;
      }
    }
    return false;
  }

  while (pq.isNotEmpty) {
    final v = pq.removeFirst();
    onQ[v] = false;
    for (final e in graph.edges(v)) {
      final w = e.b;
      if (cost[w]! > cost[v]! + e.weight) {
        cost[w] = cost[v]! + e.weight;
        prev[w] = v;
        if (!onQ[w]!) {
          pq.add(w);
          onQ[w] = true;
        }
      }
    }
  }

  if (hasNegativeCycle()) throw Exception("Negative cycle detected");
  return ShortestPathResult(source, cost, prev);
}

/// Run the Bellman Ford algorithm to get the shortest paths from [source] to
/// all vertices.
///
/// Dijkstra’s algorithm is a Greedy algorithm and the time complexity is O((V+E)LogV)
/// (with the use of the Fibonacci heap). Dijkstra doesn’t work for Graphs with negative weights,
/// Bellman-Ford works for such graphs. Bellman-Ford is also simpler than Dijkstra and suites
/// well for distributed systems. But time complexity of Bellman-Ford is O(V * E), which is more than Dijkstra.
HashMap<T, num>? bellmanFord2<T>(WeightedGraph<T> graph, T source) {
  var distances = HashMap<T, num>();
  distances[source] = 0;

  var edges = graph.edges;
  var counter = graph.vertices.length - 1;

  bool shouldUpdate(WeightedEdge<T> edge) {
    if (!distances.containsKey(edge.a)) return false;
    var uValue = distances[edge.a]!;
    var vValue = distances[edge.b] ?? (uValue + edge.weight + 1);

    return uValue + edge.weight < vValue;
  }

  while (counter > 0) {
    for (var edge in graph.allEdges) {
      if (shouldUpdate(edge)) {
        distances[edge.a] = distances[edge.b]! + edge.weight;
      }
    }

    counter--;
  }

  for (var edge in graph.allEdges) {
    if (shouldUpdate(edge)) {
      return null;
    }
  }

  return distances;
}
