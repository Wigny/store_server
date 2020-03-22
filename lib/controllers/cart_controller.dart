import 'package:store_server/models/products_model.dart';
import 'package:store_server/models/sales_model.dart';
import 'package:store_server/repositories/cart_repository.dart';

import 'package:store_server/store_server.dart';

class CartController extends ResourceController {
  CartController(this.context) {
    repository = CartRepository();
  }

  final ManagedContext context;
  CartRepository repository;

  Response _response<T>(T res) =>
      (res != null) ? Response.ok(res) : Response.notFound();

  @Operation.get('user')
  Future<Response> getAllProducts(
    @Bind.path('user') int user,
  ) async {
    final Query<Sales> query = Query<Sales>(context)
      ..where((Sales i) => i.usuario.id).equalTo(user)
      ..join(object: (Sales i) => i.produto);

    return _response<List<Sales>>(
      await query.fetch(),
    );
  }

  @Operation.post('user')
  Future<Response> postProduct(
    @Bind.path('user') int user,
    @Bind.body() Map<String, int> body,
  ) async {
    final int quantidade = body['quantidade'];
    final int produto = body['produto'];

    final Query<Products> queryProduto = Query<Products>(context)
      ..where((Products p) => p.id).equalTo(produto);

    final Products resultProduto = await queryProduto.fetchOne();
    final int estoque = resultProduto.asMap()['estoque'] as int;

    if (estoque >= quantidade) {
      final Sales sale = await context.transaction<Sales>(
        (ManagedContext transaction) async {
          await repository.updateProduct(
            context: transaction,
            id: produto,
            body: Products()..id = produto,
          );

          return await repository.putSale(
            context: transaction,
            body: Sales()
              ..usuario.id = user
              ..produto.id = produto
              ..finalizada = false
              ..quantidade = quantidade
              ..data = DateTime.now(),
          );
        },
      );

      return Response.ok(sale);
    } else {
      return Response.forbidden();
    }
  }

  @Operation.put('user', 'cart')
  Future<Response> putProduct(
    @Bind.path('user') int user,
    @Bind.path('cart') int cart,
    @Bind.body() Map<String, int> body,
  ) async {
    final Query<Sales> query = Query<Sales>(context)
      ..where((Sales i) => i.id).equalTo(cart)
      ..values.usuario.id = user
      ..values.produto.id = body['produto']
      ..values.finalizada = false
      ..values.quantidade = body['quantidade'];

    return _response<Sales>(
      await query.updateOne(),
    );
  }
}
