import 'package:store_server/controllers/products_controller.dart';

import 'store_server.dart';

class StoreServerChannel extends ApplicationChannel {
  ManagedContext context;

  @override
  Future prepare() async {
    logger.onRecord.listen(
      (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"),
    );

    context = ManagedContext(
      ManagedDataModel.fromCurrentMirrorSystem(),
      PostgreSQLPersistentStore.fromConnectionInfo(
        'projectuser',
        'password',
        'localhost',
        5432,
        'mydatabase',
      ),
    );

    // PostgreSQLPersistentStore.fromConnectionInfo(
    //     "puaoapzybnkhvt",
    //     "ee92da3f60b76d0ebdf7278c028ce55e13f22a73531d410a78d993b6b8437332",
    //     "ec2-54-152-175-141.compute-1.amazonaws.com",
    //     5432,
    //     "d976jk2g8fs84a",
    //     useSSL: true,
    //   ),
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router.route("/").linkFunction(
      (request) async {
        return Response.ok({"running": "true"});
      },
    );

    router.route('/products/[:id]').link(
          () => ProductsController(context),
        );

    return router;
  }
}
