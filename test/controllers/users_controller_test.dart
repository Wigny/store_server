import 'package:aqueduct_test/aqueduct_test.dart';
import 'package:store_server/models/users_model.dart';
import 'package:store_server/store_server.dart';
import 'package:test/test.dart';

import '../harness/app.dart';

void main() {
  final harness = Harness()..install();
  final user = {
    "id": 1,
    "nome": 'Wígny',
    "email": 'wignybora@gmail.com',
  };

  test("GET /users/:id returns 200 OK", () async {
    final query = Query<Users>(harness.application.channel.context)
      ..values.id = user['id'] as int
      ..values.nome = user['nome'] as String
      ..values.email = user['email'] as String;

    await query.insert();

    final response = await harness.agent.get("/users/${user["id"]}");

    expectResponse(
      response,
      200,
      body: user,
    );
  });

  test("POST /users returns 200 OK", () async {
    final response = await harness.agent.post(
      "/users",
      body: user,
    );
    expectResponse(response, 200, body: {
      "id": greaterThan(0),
      "nome": user['nome'],
      "email": user['email'],
    });
  });

  test("POST /users returns 409 OK", () async {
    await harness.agent.post(
      "/users",
      body: user,
    );

    final badResponse = await harness.agent.post(
      "/users",
      body: user,
    );
    expectResponse(badResponse, 409);
  });

  test("PUT /users/:id returns 200 OK", () async {
    await harness.agent.post(
      "/users",
      body: user,
    );

    final response = await harness.agent.put(
      "/users/${user["id"]}",
      body: user,
    );
    expectResponse(response, 200);
  });

  test("DELETE /users/:id returns 200 OK", () async {
    await harness.agent.post(
      "/users",
      body: user,
    );

    final response = await harness.agent.delete(
      "/users/${user["id"]}",
      body: user,
    );
    expectResponse(response, 200);
  });
}
