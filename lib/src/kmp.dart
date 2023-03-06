const samples = {
  "aaaaabc": "aaaaaabcb",
  "aabdcaaabcdb": "aabdcaaabdcaaabcdba",
  "needle": "inahaystackneedleina",
  "longer than the haystack": "banana",
  "shortcircuit": "shortcircuit",
  "": "shortcircuit",
};

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

int rabinKarp(String pattern, String text, {int prime=911}) {
  // Initializations
  const d = 256;
  final m = pattern.length;
  final n = text.length;
  var p = 0, t = 0, h = 1;
  // Hash value calculation for pattern
  for (var i = 0; i < m - 1; i++) {
    h = (h * d) % prime;
  }
  // Hash value calculation for first substring in the text
  for (var i = 0; i < m; i++) {
    p = (d * p + pattern.codeUnitAt(i)) % prime;
    t = (d * t + text.codeUnitAt(i)) % prime;
  }

  int j;
  // Checking for matches in the text
  for (var i = 0; i <= n - m; i++) {
    if (p == t) {
      for (j = 0; j < m; j++) {
        if (text.codeUnitAt(i + j) != pattern.codeUnitAt(j)) {
          break;
        }
      }
      // Match found
      if (j == m) {
return i;
      }
    }
    if (i < n - m) {
      t = (d * (t - text.codeUnitAt(i) * h) + text.codeUnitAt(i + m)) % prime;
      if (t < 0) {
        t = t + prime;
      }
    }
  }
  return -1;
}

void main() {

  for (final sample in samples.entries) {
    print(knuthMorrisPratt(sample.key, sample.value));
  }
}
