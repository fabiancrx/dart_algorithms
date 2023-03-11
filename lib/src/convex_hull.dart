import "dart:math";

/// A list containing two ints, the first the x coordinate and the second the y coordinate
typedef Point = List<num>;

/// Checks the orientation of three points by calculating its slope.
/// If the orientation > 0  its counter clockwise
/// if the orientation < 0 its clockwise
/// and if it is 0 the points are collinear (form a straight line)
num _orientation(Point p, Point q, Point r) {
  return (r[1] - q[1]) * (q[0] - p[0]) - ((q[1] - p[1]) * (r[0] - q[0]));
}

/// Calculates the polar angle formed between point [anchor] nad point [b].
// In this case we calculate the hypotenuse using the arc-tangent. deltaX is the base and deltaY is the height of the ◣
num _polarAngle(Point anchor, Point b) {
  final deltaX = b[0] - anchor[0];
  final deltaY = b[1] - anchor[1];
  return atan2(deltaY, deltaX);
}

// Calculates the manhattan distance between two points in the cartesian plane
num _manhattanDistance(Point a, Point b) {
  return (a[0] - b[0]).abs() + (a[1] - b[1]).abs();
}

/// Given a list of [points] on a plane generates the convex hull (smallest convex polygon)
/// that contains all given points.
/// This particular implementation uses Graham's scan algorithm and has a complexity of O(n log n)
List<Point> convexHull(List<Point> points) {
  var startIndex = 0;
  // Select the starting point O(n)
  for (var i = 0; i < points.length; i++) {
    final current = points[i];
    // Select the point with the lowest y
    if (current[1] < points[startIndex][1]) {
      startIndex = i;
    } else if (current[1] == points[startIndex][1] && current[0] < points[startIndex][0]) {
      // if two points have the same y coordinate, select the one with the smallest x
      startIndex = i;
    }
  }
  final startPoint = points[startIndex];
  points
    ..removeAt(startIndex)
    ..sort((a, b) {
      final polarAngle = _polarAngle(startPoint, a).toInt() - _polarAngle(startPoint, b).toInt();
      if (polarAngle != 0) return polarAngle;
      // if points are collinear sort by distance
      return _manhattanDistance(a, b).toInt();
    });
  final stack = [startPoint, points.removeAt(0)];

  for (final point in points) {
    while (_orientation(stack[stack.length - 2], stack[stack.length - 1], point) < 0) {
      stack.removeLast();
    }
    stack.add(point);
  }
  return stack;
}
