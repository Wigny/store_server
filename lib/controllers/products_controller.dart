import 'package:store_server/models/products_model.dart';
import 'package:store_server/store_server.dart';

class ProductsController extends ResourceController {
  ProductsController(this.context);

  final ManagedContext context;

  Response _response<T>(T res) =>
      (res != null) ? Response.ok(res) : Response.notFound();

  @Operation.get()
  Future<Response> getAllProducts() async {
    final Query<Products> query = Query<Products>(context);

    return Response.ok(
      await query.fetch(),
    );
  }

  @Operation.get('id')
  Future<Response> getProductByID(
    @Bind.path('id') int id,
  ) async {
    final Query<Products> query = Query<Products>(context)
      ..where((Products i) => i.id).equalTo(id);

    return _response<Products>(
      await query.fetchOne(),
    );
  }

  @Operation.post()
  Future<Response> postProduct(
    @Bind.body(ignore: <String>['id']) Products body,
  ) async {
    final Query<Products> query = Query<Products>(context)..values = body;

    return Response.ok(
      await query.insert(),
    );
  }

  @Operation.put('id')
  Future<Response> putProduct(
    @Bind.path('id') int id,
    @Bind.body(ignore: <String>['id']) Products body,
  ) async {
    final Query<Products> query = Query<Products>(context)
      ..where((Products i) => i.id).equalTo(id)
      ..values = body;

    return _response<Products>(
      await query.updateOne(),
    );
  }

  @Operation.delete('id')
  Future<Response> deleteProductByID(
    @Bind.path('id') int id,
  ) async {
    final Query<Products> query = Query<Products>(context)
      ..where((Products i) => i.id).equalTo(id);

    final int deleted = await query.delete();

    return (deleted > 0) ? Response.ok(deleted) : Response.notFound();
  }
}
