import "dart:collection";
import "dart:math";

import "package:dart_algorithms/src/graph/graph.dart";

/// Graph that represents a flow network, in which edges have a capacity/weight and a flow.
typedef FlowWeightedGraph<V> = EdgeWeightedGraph<V, FlowEdge<V>>;

/// Specific type of weighted edge used in flow networks,apart from having a weight/capacity
/// they also have a flow value associated with them
class FlowEdge<T> extends WeightedEdge<T> {
  /// The current flow passing through this edge.
  /// As an invariant its value MUST always be =< than its [capacity]
  num flow;

  /// The maximum amount of throughput the edge has
  num get capacity => weight;

  FlowEdge(super.a, super.b, {this.flow = 0, num capacity = 0}) : super(weight: capacity);

  /// Residual capacity relative to [vertex]. If [vertex] is the source the residual capacity is the current [flow].
  /// Else the residual capacity is the difference between the edges maximum [capacity] and its current flow
  /// (capacity-flow) also known as the back edge.
  num residualCapacityTo(T vertex) {
    if (vertex == a) {
      return flow;
    } else if (vertex == b) {
      return capacity - flow;
    } else {
      throw Exception("Vertex $vertex does not exists in edge $this");
    }
  }

  /// Increases the flow by [delta] relative to [vertex]. If [vertex] is the source of the edge the flow is reduced.
  /// Else the flow is increased by [delta]
  void addResidualFlow(T vertex, num delta) {
    if (vertex == a) {
      flow -= delta;
    } else if (vertex == b) {
      flow += delta;
    } else {
      throw Exception("Vertex $vertex does not exists in edge $this");
    }
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

/// Represents the max flow result in a graph started at [source] and finishing at [sink]
class MaxFlowMinCutResult<T> {
  /// The maximum flow in the network
  final num maxFlow;
  final Map<T, FlowEdge<T>> _previous;

  /// Vertex from which the maximum flow started
  final T source;

  /// Vertex to which the maximum flow is directed
  final T sink;

  MaxFlowMinCutResult(this.maxFlow, this._previous, this.source, this.sink);

  List<FlowEdge<T>> edges() => _previous.values.toList();
}

///{@macro maxflow}
/// Implementation of the Ford–Fulkerson method with O(V*E²) worst time complexity
// Other more performant implementations exist like push relabel, goldberg rao or more recently electrical flow
//https://www.youtube.com/watch?v=RppuJYwlcI8
MaxFlowMinCutResult<T> edmondsKarp<T>(FlowWeightedGraph<T> graph, {required T source, required T sink}) {
  bool hasAugmentingPathBFS(
    FlowWeightedGraph<T> graph,
    Map<T, FlowEdge<T>> prev, {
    required T source,
    required T sink,
  }) {
    final visited = Map<T, bool>.fromIterable(graph.vertices, value: (_) => false);
    prev.clear();

    final queue = Queue<T>()..add(source);
    visited[source] = true;

    while (queue.isNotEmpty && !visited[sink]!) {
      final v = queue.removeFirst();
      for (final e in graph.edges(v)) {
        final w = e.other(v);
        // Explore only nodes that have remaining capacity and have not been visited yet
        if (e.residualCapacityTo(w) > 0 && !(visited[w] ?? true)) {
          prev[w] = e;
          visited[w] = true;
          queue.addFirst(w);
        }
      }
    }
    // If any node made it to the sink we still have an augmenting path
    // In the prev map we can retrace the augmenting path from source to sink
    // By using BFS we guarantee we have a shortest length augmented path
    return visited[sink]!;
  }

  return _fordFulkerson(graph, source: source, sink: sink, hasAugmentingPath: hasAugmentingPathBFS);
}

/// Function that computes whether a [graph] has an augmenting path.
typedef AugmentingPathFunction<T> = bool Function(
  FlowWeightedGraph<T> graph,
  Map<T, FlowEdge<T>> prev, {
  required T source,
  required T sink,
});

/// {@template maxflow}
/// Greedy algorithm that computes the maximum flow/minimum cut in a flow network
/// {@endtemplate}
/// It is sometimes called a "method" instead of an "algorithm" as the approach to finding augmenting paths
/// is not fully specified. In this implementation it is provided via [hasAugmentingPath] parameter.
MaxFlowMinCutResult<T> _fordFulkerson<T>(FlowWeightedGraph<T> graph,
    {required T source, required T sink, required AugmentingPathFunction<T> hasAugmentingPath}) {
  final prev = <T, FlowEdge<T>>{};

  num value = 0;
// flow at every vertex is >=0 && <= edge capacity
// every vertex has local equilibrium: inflow = outflow
  while (hasAugmentingPath(graph, prev, source: source, sink: sink)) {
    num bottleneck = double.infinity;
    // Reconstruct path and find the edge with the lowest capacity aka the bottleneck
    for (var v = sink; v != source; v = prev[v]!.other(v)) {
      bottleneck = min(bottleneck, prev[v]!.residualCapacityTo(v));
    }
    // Augment the values along the path by the bottleneck
    for (var v = sink; v != source; v = prev[v]!.other(v)) {
      prev[v]!.addResidualFlow(v, bottleneck);
    }
    // We have effectively augmented the flow in the graph by bottleneck
    value += bottleneck;
  }
  return MaxFlowMinCutResult(value, prev, source, sink);
}
