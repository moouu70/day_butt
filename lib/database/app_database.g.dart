// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UniversityEventsTable extends UniversityEvents
    with TableInfo<$UniversityEventsTable, UniversityEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UniversityEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayOfWeekMeta = const VerificationMeta(
    'dayOfWeek',
  );
  @override
  late final GeneratedColumn<int> dayOfWeek = GeneratedColumn<int>(
    'day_of_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMinutesMeta = const VerificationMeta(
    'startMinutes',
  );
  @override
  late final GeneratedColumn<int> startMinutes = GeneratedColumn<int>(
    'start_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMinutesMeta = const VerificationMeta(
    'endMinutes',
  );
  @override
  late final GeneratedColumn<int> endMinutes = GeneratedColumn<int>(
    'end_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _instructorMeta = const VerificationMeta(
    'instructor',
  );
  @override
  late final GeneratedColumn<String> instructor = GeneratedColumn<String>(
    'instructor',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dayOfWeek,
    startMinutes,
    endMinutes,
    subject,
    type,
    location,
    instructor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'university_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<UniversityEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
        _dayOfWeekMeta,
        dayOfWeek.isAcceptableOrUnknown(data['day_of_week']!, _dayOfWeekMeta),
      );
    } else if (isInserting) {
      context.missing(_dayOfWeekMeta);
    }
    if (data.containsKey('start_minutes')) {
      context.handle(
        _startMinutesMeta,
        startMinutes.isAcceptableOrUnknown(
          data['start_minutes']!,
          _startMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startMinutesMeta);
    }
    if (data.containsKey('end_minutes')) {
      context.handle(
        _endMinutesMeta,
        endMinutes.isAcceptableOrUnknown(data['end_minutes']!, _endMinutesMeta),
      );
    } else if (isInserting) {
      context.missing(_endMinutesMeta);
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('instructor')) {
      context.handle(
        _instructorMeta,
        instructor.isAcceptableOrUnknown(data['instructor']!, _instructorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UniversityEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UniversityEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_week'],
      )!,
      startMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minutes'],
      )!,
      endMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minutes'],
      )!,
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      instructor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instructor'],
      ),
    );
  }

  @override
  $UniversityEventsTable createAlias(String alias) {
    return $UniversityEventsTable(attachedDatabase, alias);
  }
}

class UniversityEvent extends DataClass implements Insertable<UniversityEvent> {
  final String id;
  final int dayOfWeek;
  final int startMinutes;
  final int endMinutes;
  final String subject;
  final String type;
  final String? location;
  final String? instructor;
  const UniversityEvent({
    required this.id,
    required this.dayOfWeek,
    required this.startMinutes,
    required this.endMinutes,
    required this.subject,
    required this.type,
    this.location,
    this.instructor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['day_of_week'] = Variable<int>(dayOfWeek);
    map['start_minutes'] = Variable<int>(startMinutes);
    map['end_minutes'] = Variable<int>(endMinutes);
    map['subject'] = Variable<String>(subject);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    if (!nullToAbsent || instructor != null) {
      map['instructor'] = Variable<String>(instructor);
    }
    return map;
  }

  UniversityEventsCompanion toCompanion(bool nullToAbsent) {
    return UniversityEventsCompanion(
      id: Value(id),
      dayOfWeek: Value(dayOfWeek),
      startMinutes: Value(startMinutes),
      endMinutes: Value(endMinutes),
      subject: Value(subject),
      type: Value(type),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      instructor: instructor == null && nullToAbsent
          ? const Value.absent()
          : Value(instructor),
    );
  }

  factory UniversityEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UniversityEvent(
      id: serializer.fromJson<String>(json['id']),
      dayOfWeek: serializer.fromJson<int>(json['dayOfWeek']),
      startMinutes: serializer.fromJson<int>(json['startMinutes']),
      endMinutes: serializer.fromJson<int>(json['endMinutes']),
      subject: serializer.fromJson<String>(json['subject']),
      type: serializer.fromJson<String>(json['type']),
      location: serializer.fromJson<String?>(json['location']),
      instructor: serializer.fromJson<String?>(json['instructor']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dayOfWeek': serializer.toJson<int>(dayOfWeek),
      'startMinutes': serializer.toJson<int>(startMinutes),
      'endMinutes': serializer.toJson<int>(endMinutes),
      'subject': serializer.toJson<String>(subject),
      'type': serializer.toJson<String>(type),
      'location': serializer.toJson<String?>(location),
      'instructor': serializer.toJson<String?>(instructor),
    };
  }

  UniversityEvent copyWith({
    String? id,
    int? dayOfWeek,
    int? startMinutes,
    int? endMinutes,
    String? subject,
    String? type,
    Value<String?> location = const Value.absent(),
    Value<String?> instructor = const Value.absent(),
  }) => UniversityEvent(
    id: id ?? this.id,
    dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    startMinutes: startMinutes ?? this.startMinutes,
    endMinutes: endMinutes ?? this.endMinutes,
    subject: subject ?? this.subject,
    type: type ?? this.type,
    location: location.present ? location.value : this.location,
    instructor: instructor.present ? instructor.value : this.instructor,
  );
  UniversityEvent copyWithCompanion(UniversityEventsCompanion data) {
    return UniversityEvent(
      id: data.id.present ? data.id.value : this.id,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
      startMinutes: data.startMinutes.present
          ? data.startMinutes.value
          : this.startMinutes,
      endMinutes: data.endMinutes.present
          ? data.endMinutes.value
          : this.endMinutes,
      subject: data.subject.present ? data.subject.value : this.subject,
      type: data.type.present ? data.type.value : this.type,
      location: data.location.present ? data.location.value : this.location,
      instructor: data.instructor.present
          ? data.instructor.value
          : this.instructor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UniversityEvent(')
          ..write('id: $id, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('subject: $subject, ')
          ..write('type: $type, ')
          ..write('location: $location, ')
          ..write('instructor: $instructor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dayOfWeek,
    startMinutes,
    endMinutes,
    subject,
    type,
    location,
    instructor,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UniversityEvent &&
          other.id == this.id &&
          other.dayOfWeek == this.dayOfWeek &&
          other.startMinutes == this.startMinutes &&
          other.endMinutes == this.endMinutes &&
          other.subject == this.subject &&
          other.type == this.type &&
          other.location == this.location &&
          other.instructor == this.instructor);
}

class UniversityEventsCompanion extends UpdateCompanion<UniversityEvent> {
  final Value<String> id;
  final Value<int> dayOfWeek;
  final Value<int> startMinutes;
  final Value<int> endMinutes;
  final Value<String> subject;
  final Value<String> type;
  final Value<String?> location;
  final Value<String?> instructor;
  final Value<int> rowid;
  const UniversityEventsCompanion({
    this.id = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.startMinutes = const Value.absent(),
    this.endMinutes = const Value.absent(),
    this.subject = const Value.absent(),
    this.type = const Value.absent(),
    this.location = const Value.absent(),
    this.instructor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UniversityEventsCompanion.insert({
    required String id,
    required int dayOfWeek,
    required int startMinutes,
    required int endMinutes,
    required String subject,
    required String type,
    this.location = const Value.absent(),
    this.instructor = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       dayOfWeek = Value(dayOfWeek),
       startMinutes = Value(startMinutes),
       endMinutes = Value(endMinutes),
       subject = Value(subject),
       type = Value(type);
  static Insertable<UniversityEvent> custom({
    Expression<String>? id,
    Expression<int>? dayOfWeek,
    Expression<int>? startMinutes,
    Expression<int>? endMinutes,
    Expression<String>? subject,
    Expression<String>? type,
    Expression<String>? location,
    Expression<String>? instructor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (startMinutes != null) 'start_minutes': startMinutes,
      if (endMinutes != null) 'end_minutes': endMinutes,
      if (subject != null) 'subject': subject,
      if (type != null) 'type': type,
      if (location != null) 'location': location,
      if (instructor != null) 'instructor': instructor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UniversityEventsCompanion copyWith({
    Value<String>? id,
    Value<int>? dayOfWeek,
    Value<int>? startMinutes,
    Value<int>? endMinutes,
    Value<String>? subject,
    Value<String>? type,
    Value<String?>? location,
    Value<String?>? instructor,
    Value<int>? rowid,
  }) {
    return UniversityEventsCompanion(
      id: id ?? this.id,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
      subject: subject ?? this.subject,
      type: type ?? this.type,
      location: location ?? this.location,
      instructor: instructor ?? this.instructor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<int>(dayOfWeek.value);
    }
    if (startMinutes.present) {
      map['start_minutes'] = Variable<int>(startMinutes.value);
    }
    if (endMinutes.present) {
      map['end_minutes'] = Variable<int>(endMinutes.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (instructor.present) {
      map['instructor'] = Variable<String>(instructor.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UniversityEventsCompanion(')
          ..write('id: $id, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('subject: $subject, ')
          ..write('type: $type, ')
          ..write('location: $location, ')
          ..write('instructor: $instructor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CalorieEntriesTable extends CalorieEntries
    with TableInfo<$CalorieEntriesTable, CalorieEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalorieEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, calories, note, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calorie_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalorieEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CalorieEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalorieEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CalorieEntriesTable createAlias(String alias) {
    return $CalorieEntriesTable(attachedDatabase, alias);
  }
}

class CalorieEntry extends DataClass implements Insertable<CalorieEntry> {
  final String id;
  final int calories;
  final String? note;
  final DateTime createdAt;
  const CalorieEntry({
    required this.id,
    required this.calories,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['calories'] = Variable<int>(calories);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CalorieEntriesCompanion toCompanion(bool nullToAbsent) {
    return CalorieEntriesCompanion(
      id: Value(id),
      calories: Value(calories),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory CalorieEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalorieEntry(
      id: serializer.fromJson<String>(json['id']),
      calories: serializer.fromJson<int>(json['calories']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'calories': serializer.toJson<int>(calories),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CalorieEntry copyWith({
    String? id,
    int? calories,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => CalorieEntry(
    id: id ?? this.id,
    calories: calories ?? this.calories,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  CalorieEntry copyWithCompanion(CalorieEntriesCompanion data) {
    return CalorieEntry(
      id: data.id.present ? data.id.value : this.id,
      calories: data.calories.present ? data.calories.value : this.calories,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalorieEntry(')
          ..write('id: $id, ')
          ..write('calories: $calories, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, calories, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalorieEntry &&
          other.id == this.id &&
          other.calories == this.calories &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class CalorieEntriesCompanion extends UpdateCompanion<CalorieEntry> {
  final Value<String> id;
  final Value<int> calories;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CalorieEntriesCompanion({
    this.id = const Value.absent(),
    this.calories = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CalorieEntriesCompanion.insert({
    required String id,
    required int calories,
    this.note = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       calories = Value(calories),
       createdAt = Value(createdAt);
  static Insertable<CalorieEntry> custom({
    Expression<String>? id,
    Expression<int>? calories,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (calories != null) 'calories': calories,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CalorieEntriesCompanion copyWith({
    Value<String>? id,
    Value<int>? calories,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CalorieEntriesCompanion(
      id: id ?? this.id,
      calories: calories ?? this.calories,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalorieEntriesCompanion(')
          ..write('id: $id, ')
          ..write('calories: $calories, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpenseEntriesTable extends ExpenseEntries
    with TableInfo<$ExpenseEntriesTable, ExpenseEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('expense'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amount,
    category,
    note,
    type,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ExpenseEntriesTable createAlias(String alias) {
    return $ExpenseEntriesTable(attachedDatabase, alias);
  }
}

class ExpenseEntry extends DataClass implements Insertable<ExpenseEntry> {
  final String id;
  final double amount;
  final String category;
  final String? note;
  final String type;
  final DateTime createdAt;
  const ExpenseEntry({
    required this.id,
    required this.amount,
    required this.category,
    this.note,
    required this.type,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['amount'] = Variable<double>(amount);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['type'] = Variable<String>(type);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpenseEntriesCompanion toCompanion(bool nullToAbsent) {
    return ExpenseEntriesCompanion(
      id: Value(id),
      amount: Value(amount),
      category: Value(category),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      type: Value(type),
      createdAt: Value(createdAt),
    );
  }

  factory ExpenseEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseEntry(
      id: serializer.fromJson<String>(json['id']),
      amount: serializer.fromJson<double>(json['amount']),
      category: serializer.fromJson<String>(json['category']),
      note: serializer.fromJson<String?>(json['note']),
      type: serializer.fromJson<String>(json['type']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'amount': serializer.toJson<double>(amount),
      'category': serializer.toJson<String>(category),
      'note': serializer.toJson<String?>(note),
      'type': serializer.toJson<String>(type),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExpenseEntry copyWith({
    String? id,
    double? amount,
    String? category,
    Value<String?> note = const Value.absent(),
    String? type,
    DateTime? createdAt,
  }) => ExpenseEntry(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    category: category ?? this.category,
    note: note.present ? note.value : this.note,
    type: type ?? this.type,
    createdAt: createdAt ?? this.createdAt,
  );
  ExpenseEntry copyWithCompanion(ExpenseEntriesCompanion data) {
    return ExpenseEntry(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      category: data.category.present ? data.category.value : this.category,
      note: data.note.present ? data.note.value : this.note,
      type: data.type.present ? data.type.value : this.type,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseEntry(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('note: $note, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, amount, category, note, type, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseEntry &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.category == this.category &&
          other.note == this.note &&
          other.type == this.type &&
          other.createdAt == this.createdAt);
}

class ExpenseEntriesCompanion extends UpdateCompanion<ExpenseEntry> {
  final Value<String> id;
  final Value<double> amount;
  final Value<String> category;
  final Value<String?> note;
  final Value<String> type;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ExpenseEntriesCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.category = const Value.absent(),
    this.note = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpenseEntriesCompanion.insert({
    required String id,
    required double amount,
    required String category,
    this.note = const Value.absent(),
    this.type = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       amount = Value(amount),
       category = Value(category),
       createdAt = Value(createdAt);
  static Insertable<ExpenseEntry> custom({
    Expression<String>? id,
    Expression<double>? amount,
    Expression<String>? category,
    Expression<String>? note,
    Expression<String>? type,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category,
      if (note != null) 'note': note,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpenseEntriesCompanion copyWith({
    Value<String>? id,
    Value<double>? amount,
    Value<String>? category,
    Value<String?>? note,
    Value<String>? type,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ExpenseEntriesCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      note: note ?? this.note,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseEntriesCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('note: $note, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutinesTable extends Routines with TableInfo<$RoutinesTable, Routine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preferredTimeMeta = const VerificationMeta(
    'preferredTime',
  );
  @override
  late final GeneratedColumn<String> preferredTime = GeneratedColumn<String>(
    'preferred_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    icon,
    preferredTime,
    isActive,
    sortOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Routine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('preferred_time')) {
      context.handle(
        _preferredTimeMeta,
        preferredTime.isAcceptableOrUnknown(
          data['preferred_time']!,
          _preferredTimeMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Routine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Routine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      preferredTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preferred_time'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RoutinesTable createAlias(String alias) {
    return $RoutinesTable(attachedDatabase, alias);
  }
}

class Routine extends DataClass implements Insertable<Routine> {
  final String id;
  final String name;
  final String? icon;
  final String? preferredTime;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  const Routine({
    required this.id,
    required this.name,
    this.icon,
    this.preferredTime,
    required this.isActive,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || preferredTime != null) {
      map['preferred_time'] = Variable<String>(preferredTime);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RoutinesCompanion toCompanion(bool nullToAbsent) {
    return RoutinesCompanion(
      id: Value(id),
      name: Value(name),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      preferredTime: preferredTime == null && nullToAbsent
          ? const Value.absent()
          : Value(preferredTime),
      isActive: Value(isActive),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory Routine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Routine(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String?>(json['icon']),
      preferredTime: serializer.fromJson<String?>(json['preferredTime']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String?>(icon),
      'preferredTime': serializer.toJson<String?>(preferredTime),
      'isActive': serializer.toJson<bool>(isActive),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Routine copyWith({
    String? id,
    String? name,
    Value<String?> icon = const Value.absent(),
    Value<String?> preferredTime = const Value.absent(),
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
  }) => Routine(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon.present ? icon.value : this.icon,
    preferredTime: preferredTime.present
        ? preferredTime.value
        : this.preferredTime,
    isActive: isActive ?? this.isActive,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  Routine copyWithCompanion(RoutinesCompanion data) {
    return Routine(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      preferredTime: data.preferredTime.present
          ? data.preferredTime.value
          : this.preferredTime,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Routine(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('preferredTime: $preferredTime, ')
          ..write('isActive: $isActive, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    icon,
    preferredTime,
    isActive,
    sortOrder,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Routine &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.preferredTime == this.preferredTime &&
          other.isActive == this.isActive &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class RoutinesCompanion extends UpdateCompanion<Routine> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> icon;
  final Value<String?> preferredTime;
  final Value<bool> isActive;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RoutinesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.preferredTime = const Value.absent(),
    this.isActive = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutinesCompanion.insert({
    required String id,
    required String name,
    this.icon = const Value.absent(),
    this.preferredTime = const Value.absent(),
    this.isActive = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Routine> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<String>? preferredTime,
    Expression<bool>? isActive,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (preferredTime != null) 'preferred_time': preferredTime,
      if (isActive != null) 'is_active': isActive,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutinesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? icon,
    Value<String?>? preferredTime,
    Value<bool>? isActive,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RoutinesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      preferredTime: preferredTime ?? this.preferredTime,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (preferredTime.present) {
      map['preferred_time'] = Variable<String>(preferredTime.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutinesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('preferredTime: $preferredTime, ')
          ..write('isActive: $isActive, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RoutineCompletionsTable extends RoutineCompletions
    with TableInfo<$RoutineCompletionsTable, RoutineCompletion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoutineCompletionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _routineIdMeta = const VerificationMeta(
    'routineId',
  );
  @override
  late final GeneratedColumn<String> routineId = GeneratedColumn<String>(
    'routine_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    routineId,
    date,
    completed,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'routine_completions';
  @override
  VerificationContext validateIntegrity(
    Insertable<RoutineCompletion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('routine_id')) {
      context.handle(
        _routineIdMeta,
        routineId.isAcceptableOrUnknown(data['routine_id']!, _routineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_routineIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RoutineCompletion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RoutineCompletion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      routineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}routine_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
    );
  }

  @override
  $RoutineCompletionsTable createAlias(String alias) {
    return $RoutineCompletionsTable(attachedDatabase, alias);
  }
}

class RoutineCompletion extends DataClass
    implements Insertable<RoutineCompletion> {
  final String id;
  final String routineId;
  final String date;
  final bool completed;
  final DateTime completedAt;
  const RoutineCompletion({
    required this.id,
    required this.routineId,
    required this.date,
    required this.completed,
    required this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['routine_id'] = Variable<String>(routineId);
    map['date'] = Variable<String>(date);
    map['completed'] = Variable<bool>(completed);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  RoutineCompletionsCompanion toCompanion(bool nullToAbsent) {
    return RoutineCompletionsCompanion(
      id: Value(id),
      routineId: Value(routineId),
      date: Value(date),
      completed: Value(completed),
      completedAt: Value(completedAt),
    );
  }

  factory RoutineCompletion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RoutineCompletion(
      id: serializer.fromJson<String>(json['id']),
      routineId: serializer.fromJson<String>(json['routineId']),
      date: serializer.fromJson<String>(json['date']),
      completed: serializer.fromJson<bool>(json['completed']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'routineId': serializer.toJson<String>(routineId),
      'date': serializer.toJson<String>(date),
      'completed': serializer.toJson<bool>(completed),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  RoutineCompletion copyWith({
    String? id,
    String? routineId,
    String? date,
    bool? completed,
    DateTime? completedAt,
  }) => RoutineCompletion(
    id: id ?? this.id,
    routineId: routineId ?? this.routineId,
    date: date ?? this.date,
    completed: completed ?? this.completed,
    completedAt: completedAt ?? this.completedAt,
  );
  RoutineCompletion copyWithCompanion(RoutineCompletionsCompanion data) {
    return RoutineCompletion(
      id: data.id.present ? data.id.value : this.id,
      routineId: data.routineId.present ? data.routineId.value : this.routineId,
      date: data.date.present ? data.date.value : this.date,
      completed: data.completed.present ? data.completed.value : this.completed,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RoutineCompletion(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('date: $date, ')
          ..write('completed: $completed, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, routineId, date, completed, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RoutineCompletion &&
          other.id == this.id &&
          other.routineId == this.routineId &&
          other.date == this.date &&
          other.completed == this.completed &&
          other.completedAt == this.completedAt);
}

class RoutineCompletionsCompanion extends UpdateCompanion<RoutineCompletion> {
  final Value<String> id;
  final Value<String> routineId;
  final Value<String> date;
  final Value<bool> completed;
  final Value<DateTime> completedAt;
  final Value<int> rowid;
  const RoutineCompletionsCompanion({
    this.id = const Value.absent(),
    this.routineId = const Value.absent(),
    this.date = const Value.absent(),
    this.completed = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RoutineCompletionsCompanion.insert({
    required String id,
    required String routineId,
    required String date,
    this.completed = const Value.absent(),
    required DateTime completedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       routineId = Value(routineId),
       date = Value(date),
       completedAt = Value(completedAt);
  static Insertable<RoutineCompletion> custom({
    Expression<String>? id,
    Expression<String>? routineId,
    Expression<String>? date,
    Expression<bool>? completed,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (routineId != null) 'routine_id': routineId,
      if (date != null) 'date': date,
      if (completed != null) 'completed': completed,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RoutineCompletionsCompanion copyWith({
    Value<String>? id,
    Value<String>? routineId,
    Value<String>? date,
    Value<bool>? completed,
    Value<DateTime>? completedAt,
    Value<int>? rowid,
  }) {
    return RoutineCompletionsCompanion(
      id: id ?? this.id,
      routineId: routineId ?? this.routineId,
      date: date ?? this.date,
      completed: completed ?? this.completed,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (routineId.present) {
      map['routine_id'] = Variable<String>(routineId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoutineCompletionsCompanion(')
          ..write('id: $id, ')
          ..write('routineId: $routineId, ')
          ..write('date: $date, ')
          ..write('completed: $completed, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TodosTable extends Todos with TableInfo<$TodosTable, Todo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    completed,
    createdAt,
    completedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Todo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Todo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Todo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
    );
  }

  @override
  $TodosTable createAlias(String alias) {
    return $TodosTable(attachedDatabase, alias);
  }
}

class Todo extends DataClass implements Insertable<Todo> {
  final String id;
  final String title;
  final bool completed;
  final DateTime createdAt;
  final DateTime? completedAt;
  const Todo({
    required this.id,
    required this.title,
    required this.completed,
    required this.createdAt,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['completed'] = Variable<bool>(completed);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    return map;
  }

  TodosCompanion toCompanion(bool nullToAbsent) {
    return TodosCompanion(
      id: Value(id),
      title: Value(title),
      completed: Value(completed),
      createdAt: Value(createdAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
    );
  }

  factory Todo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Todo(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      completed: serializer.fromJson<bool>(json['completed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'completed': serializer.toJson<bool>(completed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
    };
  }

  Todo copyWith({
    String? id,
    String? title,
    bool? completed,
    DateTime? createdAt,
    Value<DateTime?> completedAt = const Value.absent(),
  }) => Todo(
    id: id ?? this.id,
    title: title ?? this.title,
    completed: completed ?? this.completed,
    createdAt: createdAt ?? this.createdAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  Todo copyWithCompanion(TodosCompanion data) {
    return Todo(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      completed: data.completed.present ? data.completed.value : this.completed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Todo(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('completed: $completed, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, completed, createdAt, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Todo &&
          other.id == this.id &&
          other.title == this.title &&
          other.completed == this.completed &&
          other.createdAt == this.createdAt &&
          other.completedAt == this.completedAt);
}

class TodosCompanion extends UpdateCompanion<Todo> {
  final Value<String> id;
  final Value<String> title;
  final Value<bool> completed;
  final Value<DateTime> createdAt;
  final Value<DateTime?> completedAt;
  final Value<int> rowid;
  const TodosCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.completed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TodosCompanion.insert({
    required String id,
    required String title,
    this.completed = const Value.absent(),
    required DateTime createdAt,
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       createdAt = Value(createdAt);
  static Insertable<Todo> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<bool>? completed,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (completed != null) 'completed': completed,
      if (createdAt != null) 'created_at': createdAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TodosCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<bool>? completed,
    Value<DateTime>? createdAt,
    Value<DateTime?>? completedAt,
    Value<int>? rowid,
  }) {
    return TodosCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodosCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('completed: $completed, ')
          ..write('createdAt: $createdAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, Note> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, content, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Note> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Note map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Note(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class Note extends DataClass implements Insertable<Note> {
  final String id;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Note({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      content: Value(content),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Note.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Note(
      id: serializer.fromJson<String>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Note copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Note(
    id: id ?? this.id,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Note copyWithCompanion(NotesCompanion data) {
    return Note(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Note(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, content, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Note &&
          other.id == this.id &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NotesCompanion extends UpdateCompanion<Note> {
  final Value<String> id;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesCompanion.insert({
    required String id,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       content = Value(content),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Note> custom({
    Expression<String>? id,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesCompanion copyWith({
    Value<String>? id,
    Value<String>? content,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return NotesCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavedExpensesTable extends SavedExpenses
    with TableInfo<$SavedExpensesTable, SavedExpense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Food'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, amount, category, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedExpense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedExpense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedExpense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SavedExpensesTable createAlias(String alias) {
    return $SavedExpensesTable(attachedDatabase, alias);
  }
}

class SavedExpense extends DataClass implements Insertable<SavedExpense> {
  final String id;
  final String name;
  final double amount;
  final String category;
  final DateTime createdAt;
  const SavedExpense({
    required this.id,
    required this.name,
    required this.amount,
    required this.category,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<double>(amount);
    map['category'] = Variable<String>(category);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SavedExpensesCompanion toCompanion(bool nullToAbsent) {
    return SavedExpensesCompanion(
      id: Value(id),
      name: Value(name),
      amount: Value(amount),
      category: Value(category),
      createdAt: Value(createdAt),
    );
  }

  factory SavedExpense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedExpense(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
      category: serializer.fromJson<String>(json['category']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
      'category': serializer.toJson<String>(category),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SavedExpense copyWith({
    String? id,
    String? name,
    double? amount,
    String? category,
    DateTime? createdAt,
  }) => SavedExpense(
    id: id ?? this.id,
    name: name ?? this.name,
    amount: amount ?? this.amount,
    category: category ?? this.category,
    createdAt: createdAt ?? this.createdAt,
  );
  SavedExpense copyWithCompanion(SavedExpensesCompanion data) {
    return SavedExpense(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      category: data.category.present ? data.category.value : this.category,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedExpense(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, amount, category, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedExpense &&
          other.id == this.id &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.category == this.category &&
          other.createdAt == this.createdAt);
}

class SavedExpensesCompanion extends UpdateCompanion<SavedExpense> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> amount;
  final Value<String> category;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SavedExpensesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.category = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedExpensesCompanion.insert({
    required String id,
    required String name,
    required double amount,
    this.category = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       amount = Value(amount),
       createdAt = Value(createdAt);
  static Insertable<SavedExpense> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<String>? category,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedExpensesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<double>? amount,
    Value<String>? category,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SavedExpensesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedExpensesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UniversityEventsTable universityEvents = $UniversityEventsTable(
    this,
  );
  late final $CalorieEntriesTable calorieEntries = $CalorieEntriesTable(this);
  late final $ExpenseEntriesTable expenseEntries = $ExpenseEntriesTable(this);
  late final $RoutinesTable routines = $RoutinesTable(this);
  late final $RoutineCompletionsTable routineCompletions =
      $RoutineCompletionsTable(this);
  late final $TodosTable todos = $TodosTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $SavedExpensesTable savedExpenses = $SavedExpensesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    universityEvents,
    calorieEntries,
    expenseEntries,
    routines,
    routineCompletions,
    todos,
    notes,
    savedExpenses,
  ];
}

typedef $$UniversityEventsTableCreateCompanionBuilder =
    UniversityEventsCompanion Function({
      required String id,
      required int dayOfWeek,
      required int startMinutes,
      required int endMinutes,
      required String subject,
      required String type,
      Value<String?> location,
      Value<String?> instructor,
      Value<int> rowid,
    });
typedef $$UniversityEventsTableUpdateCompanionBuilder =
    UniversityEventsCompanion Function({
      Value<String> id,
      Value<int> dayOfWeek,
      Value<int> startMinutes,
      Value<int> endMinutes,
      Value<String> subject,
      Value<String> type,
      Value<String?> location,
      Value<String?> instructor,
      Value<int> rowid,
    });

class $$UniversityEventsTableFilterComposer
    extends Composer<_$AppDatabase, $UniversityEventsTable> {
  $$UniversityEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instructor => $composableBuilder(
    column: $table.instructor,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UniversityEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $UniversityEventsTable> {
  $$UniversityEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instructor => $composableBuilder(
    column: $table.instructor,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UniversityEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UniversityEventsTable> {
  $$UniversityEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  GeneratedColumn<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<String> get instructor => $composableBuilder(
    column: $table.instructor,
    builder: (column) => column,
  );
}

class $$UniversityEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UniversityEventsTable,
          UniversityEvent,
          $$UniversityEventsTableFilterComposer,
          $$UniversityEventsTableOrderingComposer,
          $$UniversityEventsTableAnnotationComposer,
          $$UniversityEventsTableCreateCompanionBuilder,
          $$UniversityEventsTableUpdateCompanionBuilder,
          (
            UniversityEvent,
            BaseReferences<
              _$AppDatabase,
              $UniversityEventsTable,
              UniversityEvent
            >,
          ),
          UniversityEvent,
          PrefetchHooks Function()
        > {
  $$UniversityEventsTableTableManager(
    _$AppDatabase db,
    $UniversityEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UniversityEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UniversityEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UniversityEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> dayOfWeek = const Value.absent(),
                Value<int> startMinutes = const Value.absent(),
                Value<int> endMinutes = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<String?> instructor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UniversityEventsCompanion(
                id: id,
                dayOfWeek: dayOfWeek,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                subject: subject,
                type: type,
                location: location,
                instructor: instructor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int dayOfWeek,
                required int startMinutes,
                required int endMinutes,
                required String subject,
                required String type,
                Value<String?> location = const Value.absent(),
                Value<String?> instructor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UniversityEventsCompanion.insert(
                id: id,
                dayOfWeek: dayOfWeek,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                subject: subject,
                type: type,
                location: location,
                instructor: instructor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UniversityEventsTable, UniversityEvent>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UniversityEventsTable,
                    UniversityEvent
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UniversityEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UniversityEventsTable,
      UniversityEvent,
      $$UniversityEventsTableFilterComposer,
      $$UniversityEventsTableOrderingComposer,
      $$UniversityEventsTableAnnotationComposer,
      $$UniversityEventsTableCreateCompanionBuilder,
      $$UniversityEventsTableUpdateCompanionBuilder,
      (
        UniversityEvent,
        BaseReferences<_$AppDatabase, $UniversityEventsTable, UniversityEvent>,
      ),
      UniversityEvent,
      PrefetchHooks Function()
    >;
typedef $$CalorieEntriesTableCreateCompanionBuilder =
    CalorieEntriesCompanion Function({
      required String id,
      required int calories,
      Value<String?> note,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CalorieEntriesTableUpdateCompanionBuilder =
    CalorieEntriesCompanion Function({
      Value<String> id,
      Value<int> calories,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$CalorieEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CalorieEntriesTable> {
  $$CalorieEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CalorieEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CalorieEntriesTable> {
  $$CalorieEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalorieEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalorieEntriesTable> {
  $$CalorieEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CalorieEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalorieEntriesTable,
          CalorieEntry,
          $$CalorieEntriesTableFilterComposer,
          $$CalorieEntriesTableOrderingComposer,
          $$CalorieEntriesTableAnnotationComposer,
          $$CalorieEntriesTableCreateCompanionBuilder,
          $$CalorieEntriesTableUpdateCompanionBuilder,
          (
            CalorieEntry,
            BaseReferences<_$AppDatabase, $CalorieEntriesTable, CalorieEntry>,
          ),
          CalorieEntry,
          PrefetchHooks Function()
        > {
  $$CalorieEntriesTableTableManager(
    _$AppDatabase db,
    $CalorieEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalorieEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalorieEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalorieEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> calories = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CalorieEntriesCompanion(
                id: id,
                calories: calories,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int calories,
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CalorieEntriesCompanion.insert(
                id: id,
                calories: calories,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CalorieEntriesTable, CalorieEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $CalorieEntriesTable,
                    CalorieEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CalorieEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalorieEntriesTable,
      CalorieEntry,
      $$CalorieEntriesTableFilterComposer,
      $$CalorieEntriesTableOrderingComposer,
      $$CalorieEntriesTableAnnotationComposer,
      $$CalorieEntriesTableCreateCompanionBuilder,
      $$CalorieEntriesTableUpdateCompanionBuilder,
      (
        CalorieEntry,
        BaseReferences<_$AppDatabase, $CalorieEntriesTable, CalorieEntry>,
      ),
      CalorieEntry,
      PrefetchHooks Function()
    >;
typedef $$ExpenseEntriesTableCreateCompanionBuilder =
    ExpenseEntriesCompanion Function({
      required String id,
      required double amount,
      required String category,
      Value<String?> note,
      Value<String> type,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ExpenseEntriesTableUpdateCompanionBuilder =
    ExpenseEntriesCompanion Function({
      Value<String> id,
      Value<double> amount,
      Value<String> category,
      Value<String?> note,
      Value<String> type,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ExpenseEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpenseEntriesTable> {
  $$ExpenseEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpenseEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpenseEntriesTable> {
  $$ExpenseEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpenseEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpenseEntriesTable> {
  $$ExpenseEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ExpenseEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpenseEntriesTable,
          ExpenseEntry,
          $$ExpenseEntriesTableFilterComposer,
          $$ExpenseEntriesTableOrderingComposer,
          $$ExpenseEntriesTableAnnotationComposer,
          $$ExpenseEntriesTableCreateCompanionBuilder,
          $$ExpenseEntriesTableUpdateCompanionBuilder,
          (
            ExpenseEntry,
            BaseReferences<_$AppDatabase, $ExpenseEntriesTable, ExpenseEntry>,
          ),
          ExpenseEntry,
          PrefetchHooks Function()
        > {
  $$ExpenseEntriesTableTableManager(
    _$AppDatabase db,
    $ExpenseEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpenseEntriesCompanion(
                id: id,
                amount: amount,
                category: category,
                note: note,
                type: type,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required double amount,
                required String category,
                Value<String?> note = const Value.absent(),
                Value<String> type = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ExpenseEntriesCompanion.insert(
                id: id,
                amount: amount,
                category: category,
                note: note,
                type: type,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExpenseEntriesTable, ExpenseEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ExpenseEntriesTable,
                    ExpenseEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpenseEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpenseEntriesTable,
      ExpenseEntry,
      $$ExpenseEntriesTableFilterComposer,
      $$ExpenseEntriesTableOrderingComposer,
      $$ExpenseEntriesTableAnnotationComposer,
      $$ExpenseEntriesTableCreateCompanionBuilder,
      $$ExpenseEntriesTableUpdateCompanionBuilder,
      (
        ExpenseEntry,
        BaseReferences<_$AppDatabase, $ExpenseEntriesTable, ExpenseEntry>,
      ),
      ExpenseEntry,
      PrefetchHooks Function()
    >;
typedef $$RoutinesTableCreateCompanionBuilder = RoutinesCompanion Function({
  required String id,
  required String name,
  Value<String?> icon,
  Value<String?> preferredTime,
  Value<bool> isActive,
  Value<int> sortOrder,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$RoutinesTableUpdateCompanionBuilder = RoutinesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> icon,
  Value<String?> preferredTime,
  Value<bool> isActive,
  Value<int> sortOrder,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$RoutinesTableFilterComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preferredTime => $composableBuilder(
    column: $table.preferredTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RoutinesTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredTime => $composableBuilder(
    column: $table.preferredTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoutinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutinesTable> {
  $$RoutinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get preferredTime => $composableBuilder(
    column: $table.preferredTime,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RoutinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutinesTable,
          Routine,
          $$RoutinesTableFilterComposer,
          $$RoutinesTableOrderingComposer,
          $$RoutinesTableAnnotationComposer,
          $$RoutinesTableCreateCompanionBuilder,
          $$RoutinesTableUpdateCompanionBuilder,
          (Routine, BaseReferences<_$AppDatabase, $RoutinesTable, Routine>),
          Routine,
          PrefetchHooks Function()
        > {
  $$RoutinesTableTableManager(_$AppDatabase db, $RoutinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<String?> preferredTime = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutinesCompanion(
                id: id,
                name: name,
                icon: icon,
                preferredTime: preferredTime,
                isActive: isActive,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> icon = const Value.absent(),
                Value<String?> preferredTime = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => RoutinesCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                preferredTime: preferredTime,
                isActive: isActive,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoutinesTable, Routine>(table),
                  BaseReferences<_$AppDatabase, $RoutinesTable, Routine>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RoutinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutinesTable,
      Routine,
      $$RoutinesTableFilterComposer,
      $$RoutinesTableOrderingComposer,
      $$RoutinesTableAnnotationComposer,
      $$RoutinesTableCreateCompanionBuilder,
      $$RoutinesTableUpdateCompanionBuilder,
      (Routine, BaseReferences<_$AppDatabase, $RoutinesTable, Routine>),
      Routine,
      PrefetchHooks Function()
    >;
typedef $$RoutineCompletionsTableCreateCompanionBuilder =
    RoutineCompletionsCompanion Function({
      required String id,
      required String routineId,
      required String date,
      Value<bool> completed,
      required DateTime completedAt,
      Value<int> rowid,
    });
typedef $$RoutineCompletionsTableUpdateCompanionBuilder =
    RoutineCompletionsCompanion Function({
      Value<String> id,
      Value<String> routineId,
      Value<String> date,
      Value<bool> completed,
      Value<DateTime> completedAt,
      Value<int> rowid,
    });

class $$RoutineCompletionsTableFilterComposer
    extends Composer<_$AppDatabase, $RoutineCompletionsTable> {
  $$RoutineCompletionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get routineId => $composableBuilder(
    column: $table.routineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RoutineCompletionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RoutineCompletionsTable> {
  $$RoutineCompletionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get routineId => $composableBuilder(
    column: $table.routineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RoutineCompletionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RoutineCompletionsTable> {
  $$RoutineCompletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get routineId =>
      $composableBuilder(column: $table.routineId, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$RoutineCompletionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RoutineCompletionsTable,
          RoutineCompletion,
          $$RoutineCompletionsTableFilterComposer,
          $$RoutineCompletionsTableOrderingComposer,
          $$RoutineCompletionsTableAnnotationComposer,
          $$RoutineCompletionsTableCreateCompanionBuilder,
          $$RoutineCompletionsTableUpdateCompanionBuilder,
          (
            RoutineCompletion,
            BaseReferences<
              _$AppDatabase,
              $RoutineCompletionsTable,
              RoutineCompletion
            >,
          ),
          RoutineCompletion,
          PrefetchHooks Function()
        > {
  $$RoutineCompletionsTableTableManager(
    _$AppDatabase db,
    $RoutineCompletionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RoutineCompletionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RoutineCompletionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RoutineCompletionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> routineId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RoutineCompletionsCompanion(
                id: id,
                routineId: routineId,
                date: date,
                completed: completed,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String routineId,
                required String date,
                Value<bool> completed = const Value.absent(),
                required DateTime completedAt,
                Value<int> rowid = const Value.absent(),
              }) => RoutineCompletionsCompanion.insert(
                id: id,
                routineId: routineId,
                date: date,
                completed: completed,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RoutineCompletionsTable, RoutineCompletion>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $RoutineCompletionsTable,
                    RoutineCompletion
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RoutineCompletionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RoutineCompletionsTable,
      RoutineCompletion,
      $$RoutineCompletionsTableFilterComposer,
      $$RoutineCompletionsTableOrderingComposer,
      $$RoutineCompletionsTableAnnotationComposer,
      $$RoutineCompletionsTableCreateCompanionBuilder,
      $$RoutineCompletionsTableUpdateCompanionBuilder,
      (
        RoutineCompletion,
        BaseReferences<
          _$AppDatabase,
          $RoutineCompletionsTable,
          RoutineCompletion
        >,
      ),
      RoutineCompletion,
      PrefetchHooks Function()
    >;
typedef $$TodosTableCreateCompanionBuilder = TodosCompanion Function({
  required String id,
  required String title,
  Value<bool> completed,
  required DateTime createdAt,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});
typedef $$TodosTableUpdateCompanionBuilder = TodosCompanion Function({
  Value<String> id,
  Value<String> title,
  Value<bool> completed,
  Value<DateTime> createdAt,
  Value<DateTime?> completedAt,
  Value<int> rowid,
});

class $$TodosTableFilterComposer extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TodosTableOrderingComposer
    extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TodosTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodosTable> {
  $$TodosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$TodosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TodosTable,
          Todo,
          $$TodosTableFilterComposer,
          $$TodosTableOrderingComposer,
          $$TodosTableAnnotationComposer,
          $$TodosTableCreateCompanionBuilder,
          $$TodosTableUpdateCompanionBuilder,
          (Todo, BaseReferences<_$AppDatabase, $TodosTable, Todo>),
          Todo,
          PrefetchHooks Function()
        > {
  $$TodosTableTableManager(_$AppDatabase db, $TodosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TodosCompanion(
                id: id,
                title: title,
                completed: completed,
                createdAt: createdAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<bool> completed = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TodosCompanion.insert(
                id: id,
                title: title,
                completed: completed,
                createdAt: createdAt,
                completedAt: completedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TodosTable, Todo>(table),
                  BaseReferences<_$AppDatabase, $TodosTable, Todo>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TodosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TodosTable,
      Todo,
      $$TodosTableFilterComposer,
      $$TodosTableOrderingComposer,
      $$TodosTableAnnotationComposer,
      $$TodosTableCreateCompanionBuilder,
      $$TodosTableUpdateCompanionBuilder,
      (Todo, BaseReferences<_$AppDatabase, $TodosTable, Todo>),
      Todo,
      PrefetchHooks Function()
    >;
typedef $$NotesTableCreateCompanionBuilder = NotesCompanion Function({
  required String id,
  required String content,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$NotesTableUpdateCompanionBuilder = NotesCompanion Function({
  Value<String> id,
  Value<String> content,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotesTable,
          Note,
          $$NotesTableFilterComposer,
          $$NotesTableOrderingComposer,
          $$NotesTableAnnotationComposer,
          $$NotesTableCreateCompanionBuilder,
          $$NotesTableUpdateCompanionBuilder,
          (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
          Note,
          PrefetchHooks Function()
        > {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion(
                id: id,
                content: content,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String content,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion.insert(
                id: id,
                content: content,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NotesTable, Note>(table),
                  BaseReferences<_$AppDatabase, $NotesTable, Note>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotesTable,
      Note,
      $$NotesTableFilterComposer,
      $$NotesTableOrderingComposer,
      $$NotesTableAnnotationComposer,
      $$NotesTableCreateCompanionBuilder,
      $$NotesTableUpdateCompanionBuilder,
      (Note, BaseReferences<_$AppDatabase, $NotesTable, Note>),
      Note,
      PrefetchHooks Function()
    >;
typedef $$SavedExpensesTableCreateCompanionBuilder =
    SavedExpensesCompanion Function({
      required String id,
      required String name,
      required double amount,
      Value<String> category,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$SavedExpensesTableUpdateCompanionBuilder =
    SavedExpensesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<double> amount,
      Value<String> category,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$SavedExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $SavedExpensesTable> {
  $$SavedExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavedExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedExpensesTable> {
  $$SavedExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavedExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedExpensesTable> {
  $$SavedExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SavedExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedExpensesTable,
          SavedExpense,
          $$SavedExpensesTableFilterComposer,
          $$SavedExpensesTableOrderingComposer,
          $$SavedExpensesTableAnnotationComposer,
          $$SavedExpensesTableCreateCompanionBuilder,
          $$SavedExpensesTableUpdateCompanionBuilder,
          (
            SavedExpense,
            BaseReferences<_$AppDatabase, $SavedExpensesTable, SavedExpense>,
          ),
          SavedExpense,
          PrefetchHooks Function()
        > {
  $$SavedExpensesTableTableManager(_$AppDatabase db, $SavedExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedExpensesCompanion(
                id: id,
                name: name,
                amount: amount,
                category: category,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required double amount,
                Value<String> category = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SavedExpensesCompanion.insert(
                id: id,
                name: name,
                amount: amount,
                category: category,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SavedExpensesTable, SavedExpense>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SavedExpensesTable,
                    SavedExpense
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavedExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedExpensesTable,
      SavedExpense,
      $$SavedExpensesTableFilterComposer,
      $$SavedExpensesTableOrderingComposer,
      $$SavedExpensesTableAnnotationComposer,
      $$SavedExpensesTableCreateCompanionBuilder,
      $$SavedExpensesTableUpdateCompanionBuilder,
      (
        SavedExpense,
        BaseReferences<_$AppDatabase, $SavedExpensesTable, SavedExpense>,
      ),
      SavedExpense,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UniversityEventsTableTableManager get universityEvents =>
      $$UniversityEventsTableTableManager(_db, _db.universityEvents);
  $$CalorieEntriesTableTableManager get calorieEntries =>
      $$CalorieEntriesTableTableManager(_db, _db.calorieEntries);
  $$ExpenseEntriesTableTableManager get expenseEntries =>
      $$ExpenseEntriesTableTableManager(_db, _db.expenseEntries);
  $$RoutinesTableTableManager get routines =>
      $$RoutinesTableTableManager(_db, _db.routines);
  $$RoutineCompletionsTableTableManager get routineCompletions =>
      $$RoutineCompletionsTableTableManager(_db, _db.routineCompletions);
  $$TodosTableTableManager get todos =>
      $$TodosTableTableManager(_db, _db.todos);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$SavedExpensesTableTableManager get savedExpenses =>
      $$SavedExpensesTableTableManager(_db, _db.savedExpenses);
}
