import 'package:store_server/models/products_model.dart';
import 'package:store_server/models/sales_model.dart';
import 'package:store_server/store_server.dart';

class CartController extends ResourceController {
  CartController(this.context);

  final ManagedContext context;

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
          final Query<Products> updateProducts = Query<Products>(transaction)
            ..where((Products p) => p.id).equalTo(produto)
            ..values.estoque = estoque - quantidade;
          await updateProducts.updateOne();

          final Query<Sales> putSales = Query<Sales>(transaction)
            ..values.usuario.id = user
            ..values.produto.id = produto
            ..values.finalizada = false
            ..values.quantidade = quantidade
            ..values.data = DateTime.now();
          return await putSales.insert();
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
