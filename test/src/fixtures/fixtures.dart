import "dart:io";

import "package:path/path.dart" as p;

const _fixturesDir = "./test/src/fixtures";

String _filePath(String fileName) => p.join(_fixturesDir, fileName);

List<String> loadTestFile(String fileName) => File(_filePath(fileName)).readAsLinesSync();
