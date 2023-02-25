import "package:dart_algorithms/src/graph/graph.dart";
import "package:dart_algorithms/src/union_find.dart";

/// Finds a minimum spanning forest of an undirected edge-weighted graph
/// It has a complexity of (E log E) with E being the amount of edges in [graph]
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
