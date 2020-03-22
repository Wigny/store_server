import 'package:aqueduct_test/aqueduct_test.dart';
import 'package:store_server/models/products_model.dart';
import 'package:store_server/store_server.dart';
import 'package:test/test.dart';

import '../harness/app.dart';

void main() {
  final harness = Harness()..install();
  final product = {
    "id": 1,
    "descricao": 'Violão',
    "valor": 800.00,
    "estoque": 15,
    "tipo": "novo",
  };

  test("GET /products returns 200 OK", () async {
    final query = Query<Products>(harness.application.channel.context)
      ..values.descricao = product['descricao'] as String
      ..values.valor = product['valor'] as double
      ..values.estoque = product['estoque'] as int
      ..values.tipo = product['tipo'] as String;

    await query.insert();

    final response = await harness.agent.get("/products");

    expectResponse(
      response,
      200,
      body: everyElement({
        "id": greaterThan(0),
        "descricao": isString,
        "valor": isDouble,
        "estoque": isInteger,
        "tipo": isString,
      }),
    );
  });

  test("POST /products returns 200 OK", () async {
    final response = await harness.agent.post(
      "/products",
      body: product,
    );
    expectResponse(
      response,
      200,
      body: product,
    );
  });

  test("POST /products returns 409 OK", () async {
    await harness.agent.post(
      "/products",
      body: product,
    );

    final badResponse = await harness.agent.post(
      "/products",
      body: product,
    );
    expectResponse(badResponse, 409);
  });

  test("PUT /products/:id returns 200 OK", () async {
    await harness.agent.post(
      "/products",
      body: product,
    );

    final response = await harness.agent.put(
      "/products/${product["id"]}",
      body: product,
    );
    expectResponse(response, 200);
  });

  test("DELETE /products/:id returns 200 OK", () async {
    await harness.agent.post(
      "/products",
      body: product,
    );

    final response = await harness.agent.delete(
      "/products/${product["id"]}",
      body: product,
    );
    expectResponse(response, 200);
  });
}
