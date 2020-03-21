import 'package:aqueduct_test/aqueduct_test.dart';
import 'package:test/test.dart';

import 'harness/app.dart';

void main() async {
  final harness = Harness()..install();

  test("GET / returns server running", () async {
    expectResponse(
      await harness.agent.get("/"),
      200,
      body: {"running": "true"},
    );
  });
}
