import 'package:store_server/models/users_model.dart';
import 'package:store_server/store_server.dart';

class UsersController extends ResourceController {
  UsersController(this.context);

  final ManagedContext context;

  @Operation.get('id')
  Future<Response> getUserByID(
    @Bind.path('id') int id,
  ) async {
    final query = Query<Users>(context)..where((i) => i.id).equalTo(id);
    final user = await query.fetchOne();

    return (user != null) ? Response.ok(user) : Response.notFound();
  }

  @Operation.post()
  Future<Response> postUser(
    @Bind.body(ignore: ["id"]) Users body,
  ) async {
    final query = Query<Users>(context)..values = body;
    final user = await query.insert();

    return Response.ok(user);
  }

  @Operation.put('id')
  Future<Response> putUser(
    @Bind.path('id') int id,
    @Bind.body(ignore: ["id"]) Users body,
  ) async {
    final query = Query<Users>(context)
      ..where((i) => i.id).equalTo(id)
      ..values = body;
    final user = await query.updateOne();

    return (user != null) ? Response.ok(user) : Response.notFound();
  }

  @Operation.delete('id')
  Future<Response> deleteUserByID(
    @Bind.path('id') int id,
  ) async {
    final query = Query<Users>(context)..where((i) => i.id).equalTo(id);
    final deleted = await query.delete();

    return (deleted > 0)
        ? Response.ok({'msg': 'Delete successfull'})
        : Response.notFound();
  }
}
