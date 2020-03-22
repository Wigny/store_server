import 'package:store_server/models/products_model.dart';
import 'package:store_server/models/users_model.dart';
import 'package:store_server/store_server.dart';

class Sales extends ManagedObject<Vendas> implements Vendas {}

class Vendas {
  @Column(
    primaryKey: true,
    databaseType: ManagedPropertyType.bigInteger,
    autoincrement: true,
  )
  int id;

  @Relate(#vendas)
  Users usuario;

  @Relate(#vendas)
  Products produto;

  @Column(
    nullable: false,
  )
  int quantidade;

  @Column(
    databaseType: ManagedPropertyType.datetime,
  )
  DateTime data;

  @Column(nullable: false)
  bool finalizada;
}
