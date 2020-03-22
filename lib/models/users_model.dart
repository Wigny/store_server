import 'package:store_server/store_server.dart';

class Users extends ManagedObject<Usuarios> implements Usuarios {}

class Usuarios {
  @Column(
    primaryKey: true,
    databaseType: ManagedPropertyType.bigInteger,
    autoincrement: true,
  )
  int id;

  @Column(
    nullable: false,
  )
  String nome;

  @Column(
    unique: true,
    nullable: false,
  )
  String email;
}
