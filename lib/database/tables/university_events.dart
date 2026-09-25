import 'package:drift/drift.dart';

class UniversityEvents extends Table {
  TextColumn get id => text()();
  IntColumn get dayOfWeek => integer()(); // 1 = Monday, 7 = Sunday
  IntColumn get startMinutes => integer()(); // minutes from midnight (e.g. 510 for 08:30)
  IntColumn get endMinutes => integer()();   // minutes from midnight (e.g. 630 for 10:30)
  TextColumn get subject => text()();
  TextColumn get type => text()(); // Lecture, Lab, Tutorial, etc.
  TextColumn get location => text().nullable()();
  TextColumn get instructor => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
