import 'package:drift/drift.dart';

class Routines extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get icon => text().nullable()();
  TextColumn get preferredTime => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
