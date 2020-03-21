import 'package:store_server/store_server.dart';

class Products extends ManagedObject<Produtos> implements Produtos {}

class Produtos {
  @primaryKey
  int id;

  @Column(nullable: false, unique: true)
  String descricao;

  @Column(nullable: false, databaseType: ManagedPropertyType.doublePrecision)
  double valor;

  @Column(nullable: false)
  int estoque;

  @Column(defaultValue: 'novo')
  String tipo;
}
