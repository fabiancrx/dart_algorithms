import "dart:collection";

import "package:dart_algorithms/src/graph/graph.dart";

/// Returns true if a graph has any cycle
bool hasCycle<T>(Graph<T> graph) => findCycle(graph).isNotEmpty;

/// Finds a cycle in a digraph if any
/// It returns an empty list if no cycle is found
/// It returns the path to the first cycle found
List<T> findCycle<T>(Graph<T> graph) {
  if (!graph.directed) throw Exception("Can't find cycle in undirected graphs");
  final visited = Map<T, bool>.fromIterable(graph.vertices, value: (_) => false);
  final onStack = HashSet<T>();
  List<T>? dfs(T vertex) {
    onStack.add(vertex);
    visited[vertex] = true;
    for (final neighbour in graph.neighbours(vertex)) {
      if (onStack.contains(neighbour)) {
        final cycle = [...onStack, neighbour];
        while (cycle.first != neighbour) {
          // Remove vertices in the path that precede the cycle found
          cycle.removeAt(0);
        }
        return cycle;
      }
      if (!visited[neighbour]!) {
        return dfs(neighbour);
      }
      onStack.remove(neighbour);
    }
    return null;
  }

  for (final vertex in graph.vertices) {
    if (!visited[vertex]!) {
      final hasCycle = dfs(vertex);
      if (hasCycle != null) return hasCycle;
    }
    // Clear stack when moving to another connected component
    onStack.clear();
  }
  return [];
}
