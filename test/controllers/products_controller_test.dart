import 'package:aqueduct_test/aqueduct_test.dart';
import 'package:store_server/models/products_model.dart';
import 'package:store_server/store_server.dart';
import 'package:test/test.dart';

import '../harness/app.dart';

void main() {
  final harness = Harness()..install();
  final products = {
    "descricao": 'Violão',
    "valor": 800.00,
    "estoque": 15,
    "tipo": "novo",
  };

  test("GET /products returns 200 OK", () async {
    final query = Query<Products>(harness.application.channel.context)
      ..values.descricao = products['descricao'] as String
      ..values.valor = products['valor'] as double
      ..values.estoque = products['estoque'] as int
      ..values.tipo = products['tipo'] as String;

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
      body: products,
    );
    expectResponse(response, 200, body: {
      "id": greaterThan(0),
      "descricao": products['descricao'],
      "valor": products['valor'],
      "estoque": products['estoque'],
      "tipo": products['tipo'],
    });
  });

  test("POST /products returns 409 OK", () async {
    await harness.agent.post(
      "/products",
      body: products,
    );

    final badResponse = await harness.agent.post(
      "/products",
      body: products,
    );
    expectResponse(badResponse, 409);
  });
}
