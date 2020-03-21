import 'package:store_server/models/products_model.dart';
import 'package:store_server/store_server.dart';

class ProductsController extends ResourceController {
  ProductsController(this.context);

  final ManagedContext context;

  final _products = [
    {
      'id': 1,
      'descricao': 'Violão',
      'valor': '800',
      'estoque': 50,
      'tipo': 'novo'
    }
  ];

  @Operation.get()
  Future<Response> getAllProducts() async {
    final query = Query<Products>(context);
    final products = await query.fetch();
    return Response.ok(products);
  }

  @Operation.get('id')
  Future<Response> getProductByID(@Bind.path('id') int id) async {
    final product = _products.firstWhere(
      (i) => i['id'] == id,
      orElse: () => null,
    );

    return (product != null) ? Response.ok(product) : Response.notFound();
  }

  @Operation.post()
  Future<Response> postProduct(
    @Bind.body() Map<String, dynamic> product,
  ) async {
    _products.add(product);

    return Response.ok(_products);
  }

  @Operation.put()
  Future<Response> putProduct(@Bind.body() Map<String, dynamic> product) async {
    _products.removeAt(
      _products.indexWhere(
        (i) => i['id'] == product['id'],
      ),
    );
    _products.add(product);

    return Response.ok(_products);
  }

  @Operation.delete('id')
  Future<Response> deleteProductByID(@Bind.path('id') int id) async {
    _products.removeAt(
      _products.indexWhere(
        (i) => i['id'] == id,
      ),
    );

    return Response.ok(_products);
  }
}
