import "package:dart_algorithms/dart_algorithms.dart";
import "package:dart_algorithms/src/graph/graph.dart";
import "package:dart_algorithms/src/union_find.dart";

///{@template mst}
/// Finds a minimum spanning forest of an undirected edge-weighted graph
/// It has a complexity of (E log E) with E being the amount of edges in [graph]
///{@endtemplate}
List<WeightedEdge<T>> kruskal<T>(WeightedGraph<T> graph) {
  // Sort edges in ascending order of weight
  // Iterate edges and add to MST if the edge does not create a cycle
  // until MST is V-1 in length or we run out of edges(in which case we will have a minimum spanning forest)
  final sortedEdges = graph.allEdges.toList()..sort();

  final uf = UnionFind(graph.vertices);
  final mst = <WeightedEdge<T>>[];
  while (sortedEdges.isNotEmpty && mst.length < graph.vertices.length - 1) {
    final lightestEdge = sortedEdges.removeAt(0);
    if (!uf.connected(lightestEdge.a, lightestEdge.b)) {
      uf.union(lightestEdge.a, lightestEdge.b);
      mst.add(lightestEdge);
    }
  }
  return mst;
}

/// {@macro mst}
List<WeightedEdge<T>> prim<T>(WeightedGraph<T> graph) {
  final pq = PriorityQueue<WeightedEdge<T>>();
  final mst = <WeightedEdge<T>>[];
  final visited = Map<T, bool>.fromIterable(graph.vertices, value: (_) => false);

  void visit(T vertex) {
    visited[vertex] = true;
    for (final edge in graph.edges(vertex)) {
      if (!visited[edge.other(vertex)]!) {
        pq.insert(edge);
      }
    }
  }

  visit(graph.vertices.first);

  while (!pq.isEmpty) {
    final lightestEdge = pq.remove();
    if (visited[lightestEdge.a]! && visited[lightestEdge.b]!) continue;

    mst.add(lightestEdge);
    if (!visited[lightestEdge.a]!) visit(lightestEdge.a);
    if (!visited[lightestEdge.b]!) visit(lightestEdge.b);
  }
  return mst;
}
