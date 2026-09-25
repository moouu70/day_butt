import 'package:drift/drift.dart';

class Todos extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
