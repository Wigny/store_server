import 'package:store_server/models/users_model.dart';
import 'package:store_server/store_server.dart';

class UsersController extends ResourceController {
  UsersController(this.context);

  final ManagedContext context;

  Response _response<T>(T res) =>
      (res != null) ? Response.ok(res) : Response.notFound();

  @Operation.get('id')
  Future<Response> getUserByID(
    @Bind.path('id') int id,
  ) async {
    final Query<Users> query = Query<Users>(context)
      ..where((Users i) => i.id).equalTo(id);

    return _response<Users>(
      await query.fetchOne(),
    );
  }

  @Operation.post()
  Future<Response> postUser(
    @Bind.body(ignore: <String>['id']) Users body,
  ) async {
    final Query<Users> query = Query<Users>(context)..values = body;

    return Response.ok(
      await query.insert(),
    );
  }

  @Operation.put('id')
  Future<Response> putUser(
    @Bind.path('id') int id,
    @Bind.body(ignore: <String>['id']) Users body,
  ) async {
    final Query<Users> query = Query<Users>(context)
      ..where((Users i) => i.id).equalTo(id)
      ..values = body;

    return _response<Users>(
      await query.updateOne(),
    );
  }

  @Operation.delete('id')
  Future<Response> deleteUserByID(
    @Bind.path('id') int id,
  ) async {
    final Query<Users> query = Query<Users>(context)
      ..where((Users i) => i.id).equalTo(id);
    final int deleted = await query.delete();

    return (deleted > 0) ? Response.ok(deleted) : Response.notFound();
  }
}
