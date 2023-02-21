import "dart:convert";

import "dart:io";

import "package:test/test.dart";

import "fixtures/fixtures.dart";

/// Transforms graphs stored at /test/fixtures from "Algorithms 4th edition" format to "graphviz"
String transformGraphFormat(List<String> lines, {required bool directed, String filename = ""}) {
  final edgeOp = directed ? " -> " : " -- ";
  final type = directed ? "digraph" : "graph";

  //Remove unneeded lines
  lines
    ..removeAt(0) // Number of vertices
    ..removeAt(0); // Number of edges

  final dotFormat = """ $type $filename { ${lines.map((e) => e.split(RegExp(r"\s+")).join(edgeOp)).join("\n")} }""";

  return dotFormat;
}

// Generates a svg of a graph using the "graphviz" package. So its required to have this package installed.
// Given a file name it matches it to the fixtures inside ./test/src/fixtures and generates an svg at ./test/[fileName]
Future<int> plotTestFile(String fileName) async {
  try {
    final fileNameWithoutExtension = fileName.split(".").first;

    final dotFormat = transformGraphFormat(loadTestFile(fileName), directed: true, filename: fileNameWithoutExtension);

    final process = await Process.start("dot", ["-Tsvg", "-o", "./test/$fileNameWithoutExtension.svg"]);
    final resultStdoutFuture = process.stdout.transform(const Utf8Decoder()).transform(const LineSplitter()).toList();
    final resultStderrFuture = process.stderr.transform(const Utf8Decoder()).transform(const LineSplitter()).toList();

    await Stream.value(const Utf8Codec().encode(dotFormat)).pipe(process.stdin);

    await process.stdin.close();

    print("Process stopped with exit code: ${await process.exitCode}");
    print("Returned stderr:");
    (await resultStderrFuture).forEach((logLine) => print("\t$logLine"));
    print("Returned stdout:");
    (await resultStdoutFuture).forEach((logLine) => print("\t$logLine"));

    return await process.exitCode;
  } catch (e, st) {
    print("Error converting $fileName to svg $e $st");
  }
  return -1;
}

void main(){
  test("",()async{
   await plotTestFile("selfLoop.txt");
  });

}