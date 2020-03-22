import 'package:store_server/store_server.dart';
import 'package:aqueduct_test/aqueduct_test.dart';
export 'package:test/test.dart';

class Harness extends TestHarness<StoreServerChannel> with TestHarnessORMMixin {
  @override
  ManagedContext get context => channel.context;

  @override
  Future<void> onSetUp() async {
    await resetData();
  }
}
