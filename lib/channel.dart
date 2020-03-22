import 'package:store_server/controllers/cart_controller.dart';
import 'package:store_server/controllers/products_controller.dart';
import 'package:store_server/controllers/users_controller.dart';
import 'package:store_server/store_server.dart';

class StoreServerChannel extends ApplicationChannel {
  ManagedContext context;

  @override
  Future<void> prepare() async {
    logger.onRecord.listen(
      (LogRecord rec) =>
          print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"),
    );

    final StoreConfig config = StoreConfig(options.configurationFilePath);

    context = ManagedContext(
      ManagedDataModel.fromCurrentMirrorSystem(),
      PostgreSQLPersistentStore.fromConnectionInfo(
        config.database.username,
        config.database.password,
        config.database.host,
        config.database.port,
        config.database.databaseName,
        useSSL: config.useSSL,
      ),
    );
  }

  @override
  Controller get entryPoint {
    final Router router = Router();

    router.route('/').linkFunction(
      (Request request) async {
        return Response.ok({
          'running': true,
        });
      },
    );

    router.route('/products/[:id]').link(
          () => ProductsController(context),
        );

    router.route('/users/[:id]').link(
          () => UsersController(context),
        );

    router.route('/users/:user/cart').link(
          () => CartController(context),
        );

    return router;
  }
}

class StoreConfig extends Configuration {
  StoreConfig(String path) : super.fromFile(File(path));

  DatabaseConfiguration database;
  bool useSSL;
}
