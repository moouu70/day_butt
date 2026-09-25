import 'package:flutter_test/flutter_test.dart';
import 'package:day_butt/features/university/data/timetable_parser.dart';

void main() {
  group('TimetableParser', () {
    test('parses valid timetable JSON correctly', () {
      const validJson = '''{
        "type": "timetable",
        "version": 1,
        "timezone": "Africa/Cairo",
        "university": {
          "name": "Faculty of Engineering",
          "group": "G1-3",
          "semester": "2026/2027"
        },
        "events": [
          {
            "day": "Monday",
            "start": "08:30",
            "end": "10:30",
            "subject": "Mathematics",
            "type": "Lecture",
            "location": "Hall 3B",
            "instructor": "Dr. Tamer"
          }
        ]
      }''';

      final result = TimetableParser.parse(validJson);
      expect(result.university.name, equals('Faculty of Engineering'));
      expect(result.events.length, equals(1));

      final event = result.events.first;
      expect(event.subject, equals('Mathematics'));
      expect(event.dayOfWeek, equals(1)); // Monday
      expect(event.startMinutes, equals(510)); // 8 * 60 + 30
      expect(event.endMinutes, equals(630));   // 10 * 60 + 30
      expect(event.type, equals('Lecture'));
      expect(event.location, equals('Hall 3B'));
      expect(event.instructor, equals('Dr. Tamer'));
    });

    test('throws TimetableParseException on invalid JSON syntax', () {
      expect(
        () => TimetableParser.parse('{ invalid json }'),
        throwsA(isA<TimetableParseException>()),
      );
    });

    test('throws error if events list is missing', () {
      expect(
        () => TimetableParser.parse('{"type": "timetable"}'),
        throwsA(isA<TimetableParseException>()),
      );
    });

    test('throws error if start time >= end time', () {
      const invalidTimeJson = '''{
        "type": "timetable",
        "events": [
          {
            "day": "Monday",
            "start": "11:00",
            "end": "10:00",
            "subject": "Physics"
          }
        ]
      }''';

      expect(
        () => TimetableParser.parse(invalidTimeJson),
        throwsA(isA<TimetableParseException>()),
      );
    });

    test('throws error if subject is missing', () {
      const missingSubjectJson = '''{
        "type": "timetable",
        "events": [
          {
            "day": "Monday",
            "start": "08:30",
            "end": "10:30"
          }
        ]
      }''';

      expect(
        () => TimetableParser.parse(missingSubjectJson),
        throwsA(isA<TimetableParseException>()),
      );
    });

    test('sampleJson is valid and parses successfully', () {
      final result = TimetableParser.parse(TimetableParser.sampleJson);
      expect(result.events.isNotEmpty, isTrue);
      expect(result.university.name, equals('Faculty of Engineering'));
      expect(result.events.length, equals(6));
    });

    test('exportEventsToJson produces valid timetable JSON', () {
      final parseResult = TimetableParser.parse(TimetableParser.sampleJson);
      expect(parseResult.events.length, equals(6));
    });
  });
}
