import "package:dart_algorithms/src/kmp.dart";
import "package:test/test.dart";

void main() {
  group("String processing", () {
    test("Knuth Morris Pratt", () {
      for (final entry in solutions) {
        expect(knuthMorrisPratt(entry.first, entry.second), entry.third);
      }
    });
  });
}

// We store our test results in tuples, by convention we store the needle, haystack and correct result
const solutions = [
  //needle, haystack, answer(needle starting index)
  _Triple("aaaaabc", "aaaaaabcb", 1),
  _Triple("aabdcaaabcdb", "aabdcaaabdcaaabcdba", 6),
  _Triple("needle", "inahaystackneedleina", 11),
  _Triple("longer than the haystack", "banana", -1),
  _Triple("shortcircuit", "shortcircuit", 0),
  _Triple("", "shortcircuit", 0),
];

class _Triple<T, E, S> {
  final T first;
  final E second;
  final S third;

  const _Triple(this.first, this.second, this.third);
}
