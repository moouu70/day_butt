import 'package:drift/drift.dart';

class ExpenseEntries extends Table {
  TextColumn get id => text()();
  RealColumn get amount => real()();
  TextColumn get category => text()(); // e.g. Food, Transport, Salary, Freelance, etc.
  TextColumn get note => text().nullable()();
  TextColumn get type => text().withDefault(const Constant('expense'))(); // 'expense' or 'income'
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
