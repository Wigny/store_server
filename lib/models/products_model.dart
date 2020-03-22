import 'package:store_server/models/sales_model.dart';
import 'package:store_server/store_server.dart';

class Products extends ManagedObject<Produtos> implements Produtos {}

class Produtos {
  @Column(
    primaryKey: true,
    databaseType: ManagedPropertyType.bigInteger,
    autoincrement: true,
  )
  int id;

  @Column(
    nullable: false,
    unique: true,
  )
  String descricao;

  @Column(
    databaseType: ManagedPropertyType.doublePrecision,
    nullable: false,
  )
  double valor;

  @Column(nullable: false)
  int estoque;

  @Column(nullable: false)
  String tipo;

  ManagedSet<Sales> vendas;
}
