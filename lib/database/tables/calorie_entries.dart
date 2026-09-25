import 'package:drift/drift.dart';

class CalorieEntries extends Table {
  TextColumn get id => text()();
  IntColumn get calories => integer()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
