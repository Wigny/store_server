import 'package:store_server/models/products_model.dart';
import 'package:store_server/store_server.dart';

class ProductsController extends ResourceController {
  ProductsController(this.context);

  final ManagedContext context;

  @Operation.get()
  Future<Response> getAllProducts() async {
    final query = Query<Products>(context);
    final products = await query.fetch();

    return Response.ok(products);
  }

  @Operation.get('id')
  Future<Response> getProductByID(
    @Bind.path('id') int id,
  ) async {
    final query = Query<Products>(context)..where((i) => i.id).equalTo(id);
    final product = await query.fetchOne();

    return (product != null) ? Response.ok(product) : Response.notFound();
  }

  @Operation.post()
  Future<Response> postProduct(
    @Bind.body(ignore: ["id"]) Products body,
  ) async {
    final query = Query<Products>(context)..values = body;
    final product = await query.insert();

    return Response.ok(product);
  }

  @Operation.put('id')
  Future<Response> putProduct(
    @Bind.path('id') int id,
    @Bind.body(ignore: ["id"]) Products body,
  ) async {
    final query = Query<Products>(context)
      ..where((i) => i.id).equalTo(id)
      ..values = body;
    final product = await query.updateOne();

    return (product != null) ? Response.ok(product) : Response.notFound();
  }

  @Operation.delete('id')
  Future<Response> deleteProductByID(
    @Bind.path('id') int id,
  ) async {
    final query = Query<Products>(context)..where((i) => i.id).equalTo(id);
    final deleted = await query.delete();

    return (deleted > 0)
        ? Response.ok({'msg': 'Delete successfull'})
        : Response.notFound();
  }
}
