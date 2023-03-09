
/// String matching algorithm which is used to find a pattern in a text with O(n) time complexity
int knuthMorrisPratt(String needle, String haystack) {
  final n = haystack.length, m = needle.length;
  if (m > n) return -1;
  if (m == n) return needle == haystack ? 0 : -1;
  if (needle.isEmpty) return 0;

  final lps = _constructLongestProperPrefix(needle);
  var i = 0, j = 0;
  while (i < n && j < m) {
    if (haystack[i] == needle[j]) {
      i++;
      j++;
    } else if (j > 0) {
      j = lps[j - 1];
    } else {
      i++;
    }
  }
  if (j < m) return -1;
  return i - m;
}

// What:
// Constructs an array of indices that point if a sub pattern of [s] next character does not match
// how far back in the pattern we can continue matching. Eg:
// Given the string "aabdcaaabcdb" the computed pattern is
// [a, a, b, d, c, a, a, a, b, c, d, b]
// [0, 1, 0, 0, 0, 1, 2, 2, 3, 0, 0, 0]
//
List<int> _constructLongestProperPrefix(String s) {
  final lps = List.generate(s.length, (_) => 0);
  for (var j = 0, i = 1; i < s.length;) {
    if (s[i] == s[j]) {
      j++;
      lps[i] = j;
      i++;
    } else if (j > 0) {
      j = lps[j - 1];
    } else {
      lps[i] = 0;
      i++;
    }
  }
  return lps;
}
