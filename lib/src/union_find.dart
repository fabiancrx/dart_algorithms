// Also called Disjoint Set
/// Union Find Data structure
/// Performs union and find in O(α(n))
class UnionFind<T> {
  final Map<T, T> _components;
  int _numberOfComponents = 0;

  /// Creates a UnionFind object given [nodes].
  /// Initially there are as many components as [nodes].
  UnionFind(Iterable<T> nodes)
      : _components = Map.fromIterable(nodes),
        _numberOfComponents = nodes.length;

  /// Join [first] and [second] in the same component
// to unify two elements, first we find which are the
// root nodes of each component.
// and if the root nodes are different make one of the
// root nodes be the parent of the other
  void union(T first, T second) {
    final firstRoot = find(first);
    final secondRoot = find(second);

    // If both elements belong to the same component we return early
    if (firstRoot == secondRoot) return;

    // Merge the smaller group into the larger one
    if (componentSize(firstRoot) < componentSize(secondRoot)) {
      _components[firstRoot] = secondRoot;
    } else {
      _components[secondRoot] = firstRoot;
    }
    _numberOfComponents--;
  }

  /// Finds to which component a particular element belongs
// to find the root of that component by following the parent nodes
// until a self loop is reached to node who's parent is itself)
  T find(T node) {
    var root = node;
    final transient = <T>[];

    // While a node is not its own parent, travel upwards
    while (root != _components[root]) {
      transient.add(root);
      root = _components[root] as T;
    }
    // Now we compress the paths by making each node a direct child
    // of the root node. We iterate from 0 to length-1 because the last node
    // is already a direct child of the root node
    for (var i = 0; i < transient.length; i++) {
      _components[node] = root;
    }

    return root;
  }

  /// Number of components associated with [node] found in O(n)
  int componentSize(T node) {
    return _components.entries.where((element) => element.value == node).length;
  }

  /// Whether [first] and [second] are connected
  bool connected(T first, T second) {
    return find(first) == find(second);
  }

  /// The number of components is also equal to the number of roots remaining
  int get components => _numberOfComponents;
}
