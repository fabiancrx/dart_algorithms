import "dart:collection";
import "dart:math";

import "package:dart_algorithms/src/graph/graph.dart";

typedef FlowWeightedGraph<V> = EdgeWeightedGraph<V, FlowEdge<V>>;

class FlowEdge<T> extends WeightedEdge<T> {
  num flow;

  num get capacity => weight;

  FlowEdge(super.a, super.b, {this.flow = 0, num capacity = 0}) : super(weight: capacity);

  num residualCapacityTo(T vertex) {
    if (vertex == a)
      return flow;
    else if (vertex == b)
      return capacity - flow;
    else
      throw Exception("Vertex $vertex does not exists in edge $this");
  }

  void addResidualFlow(T vertex, num delta) {
    if (vertex == a)
      flow -= delta;
    else if (vertex == b)
      flow += delta;
    else
      throw Exception("Vertex $vertex does not exists in edge $this");
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlowEdge &&
          runtimeType == other.runtimeType &&
          flow == other.flow &&
          a == other.a &&
          b == other.b &&
          weight == other.weight;

  @override
  int get hashCode => flow.hashCode ^ a.hashCode ^ b.hashCode ^ weight.hashCode;
}

class MaxFlowMinCutResult<T> {
  final num maxFlow;
  final Map<T, FlowEdge<T>> _previous;

  MaxFlowMinCutResult(this.maxFlow, this._previous);

  List<FlowEdge<T>> edges() => _previous.values.toList();
}
//is an implementation of the Ford–Fulkerson method for computing the maximum flow in a flow network
MaxFlowMinCutResult<T> edmondsKarp<T>(FlowWeightedGraph<T> graph, {required T source, required T sink}) {
  bool _hasAugmentingPathBFS(Map<T, FlowEdge<T>> prev) {
    final visited = Map<T, bool>.fromIterable(graph.vertices, value: (_) => false);
    prev.clear();

    final queue = Queue<T>();
    queue.add(source);
    visited[source] = true;
    while (queue.isNotEmpty) {
      final v = queue.removeFirst();
      for (final e in graph.edges(v)) {
        final w = e.other(v);

        if (e.residualCapacityTo(w) > 0 && !(visited[w] ?? true)) {
          prev[w] = e;
          visited[w] = true;
          queue.addFirst(w);
        }
      }
    }
    return visited[sink]!;
  }

  return _fordFulkerson(graph, source: source, sink: sink, augmentingPath: _hasAugmentingPathBFS);
}

typedef AugmentingPathFunction<T> = bool Function(Map<T, FlowEdge<T>> prev);
//greedy algorithm that computes the maximum flow in a flow network
//It is sometimes called a "method" instead of an "algorithm" as the approach to finding augmenting paths  is not fully specified
MaxFlowMinCutResult<T> _fordFulkerson<T>(FlowWeightedGraph<T> graph,
    {required T source, required T sink, required AugmentingPathFunction<T> augmentingPath}) {
  final prev = <T, FlowEdge<T>>{};

  num value = 0;

  while (augmentingPath(prev)) {
    num bottleneck = double.infinity;
    for (var v = sink; v != source; v = prev[v]!.other(v)) bottleneck = min(bottleneck, prev[v]!.residualCapacityTo(v));
    for (var v = sink; v != source; v = prev[v]!.other(v)) prev[v]!.addResidualFlow(v, bottleneck);
    value += bottleneck;
  }
  return MaxFlowMinCutResult(value, prev);
}

// flow at every vertex is >=0 && <= capacity
// every vertex local equilibrium, inflow= outflow
