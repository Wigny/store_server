import 'package:store_server/store_server.dart';

Future<void> main() async {
  final Application<StoreServerChannel> app = Application<StoreServerChannel>()
    ..options.configurationFilePath = 'config.yaml'
    ..options.port = 8888;

  final int count = Platform.numberOfProcessors ~/ 2;
  await app.start(numberOfInstances: count > 0 ? count : 1);

  print('Application started on port: ${app.options.port}.');
  print('Use Ctrl-C (SIGINT) to stop running the application.');
}
