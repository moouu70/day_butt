import 'package:drift/drift.dart';

class SavedExpenses extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get amount => real()();
  TextColumn get category => text().withDefault(const Constant('Food'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
