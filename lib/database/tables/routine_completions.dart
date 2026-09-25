import 'package:drift/drift.dart';

class RoutineCompletions extends Table {
  TextColumn get id => text()();
  TextColumn get routineId => text()();
  TextColumn get date => text()(); // Format: YYYY-MM-DD
  BoolColumn get completed => boolean().withDefault(const Constant(true))();
  DateTimeColumn get completedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
