import 'package:store_server/models/products_model.dart';
import 'package:store_server/models/sales_model.dart';
import 'package:store_server/store_server.dart';

class CartRepository {
  Future<Products> updateProduct({
    ManagedContext context,
    int id,
    Products body,
  }) async {
    final Query<Products> updateProducts = Query<Products>(context)
      ..where((Products p) => p.id).equalTo(id)
      ..values = body;

    return await updateProducts.updateOne();
  }

  Future<Sales> putSale({
    ManagedContext context,
    Sales body,
  }) async {
    final Query<Sales> putSales = Query<Sales>(context)..values = body;

    return await putSales.insert();
  }

  Future<Sales> insertSale(
    ManagedContext context,
    Sales body,
  ) async {
    final Query<Sales> putSales = Query<Sales>(context)..values = body;

    return await putSales.insert();
  }
}
