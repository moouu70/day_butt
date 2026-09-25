import 'dart:convert';
import '../../../core/utils/date_utils.dart';
import '../../../database/app_database.dart';

class ParsedUniversityInfo {
  final String name;
  final String? group;
  final String? semester;
  final String timezone;

  const ParsedUniversityInfo({
    required this.name,
    this.group,
    this.semester,
    this.timezone = 'Africa/Cairo',
  });
}

class ParsedTimetableEvent {
  final String id;
  final int dayOfWeek; // 1 = Monday, 7 = Sunday
  final String dayName;
  final String startTime; // "08:30"
  final String endTime;   // "10:30"
  final int startMinutes;
  final int endMinutes;
  final String subject;
  final String type;
  final String? location;
  final String? instructor;

  const ParsedTimetableEvent({
    required this.id,
    required this.dayOfWeek,
    required this.dayName,
    required this.startTime,
    required this.endTime,
    required this.startMinutes,
    required this.endMinutes,
    required this.subject,
    required this.type,
    this.location,
    this.instructor,
  });
}

class TimetableParseResult {
  final ParsedUniversityInfo university;
  final List<ParsedTimetableEvent> events;

  const TimetableParseResult({
    required this.university,
    required this.events,
  });
}

class TimetableParseException implements Exception {
  final String message;
  const TimetableParseException(this.message);

  @override
  String toString() => message;
}

class TimetableParser {
  static const String sampleJson = '''{
  "type": "timetable",
  "version": 1,
  "timezone": "Africa/Cairo",
  "university": {
    "name": "Faculty of Engineering",
    "group": "G1-3"
  },
  "events": [
    {
      "day": "Monday",
      "start": "08:30",
      "end": "10:30",
      "subject": "Data Structures",
      "type": "Lecture",
      "location": "Room A1"
    },
    {
      "day": "Monday",
      "start": "11:00",
      "end": "12:30",
      "subject": "Mathematics",
      "type": "Lecture",
      "location": "Room B2"
    },
    {
      "day": "Tuesday",
      "start": "08:30",
      "end": "10:30",
      "subject": "Data Structures",
      "type": "Lecture",
      "location": "Room A1"
    },
    {
      "day": "Tuesday",
      "start": "11:00",
      "end": "12:30",
      "subject": "Mathematics",
      "type": "Lecture",
      "location": "Room B2"
    },
    {
      "day": "Tuesday",
      "start": "13:00",
      "end": "15:00",
      "subject": "Computer Networks",
      "type": "Lab",
      "location": "Room C3"
    },
    {
      "day": "Tuesday",
      "start": "15:30",
      "end": "17:00",
      "subject": "Operating Systems",
      "type": "Lecture",
      "location": "Room A1"
    }
  ]
}''';

  static String exportEventsToJson(List<UniversityEvent> events, {String uniName = 'Faculty of Engineering'}) {
    final Map<String, dynamic> data = {
      'type': 'timetable',
      'version': 1,
      'timezone': 'Africa/Cairo',
      'university': {
        'name': uniName,
      },
      'events': events.map((e) {
        final startH = (e.startMinutes ~/ 60).toString().padLeft(2, '0');
        final startM = (e.startMinutes % 60).toString().padLeft(2, '0');
        final endH = (e.endMinutes ~/ 60).toString().padLeft(2, '0');
        final endM = (e.endMinutes % 60).toString().padLeft(2, '0');
        return {
          'id': e.id,
          'day': AppDateUtils.dayName(e.dayOfWeek),
          'start': '$startH:$startM',
          'end': '$endH:$endM',
          'subject': e.subject,
          'type': e.type,
          if (e.location != null && e.location!.isNotEmpty) 'location': e.location,
          if (e.instructor != null && e.instructor!.isNotEmpty) 'instructor': e.instructor,
        };
      }).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(data);
  }

  static TimetableParseResult parse(String jsonString) {
    if (jsonString.trim().isEmpty) {
      throw const TimetableParseException('JSON content is empty.');
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(jsonString);
    } catch (e) {
      throw TimetableParseException('Invalid JSON syntax: ${e.toString()}');
    }

    if (decoded is! Map<String, dynamic>) {
      throw const TimetableParseException('Expected a JSON object at root.');
    }

    final rawEvents = decoded['events'];
    if (rawEvents is! List) {
      throw const TimetableParseException("Missing 'events' array in timetable JSON.");
    }

    // University info
    String uniName = 'University';
    String? group;
    String? semester;
    String timezone = decoded['timezone'] as String? ?? 'Africa/Cairo';

    if (decoded['university'] is Map<String, dynamic>) {
      final uniMap = decoded['university'] as Map<String, dynamic>;
      uniName = uniMap['name'] as String? ?? 'University';
      group = uniMap['group'] as String?;
      semester = uniMap['semester'] as String?;
    }

    final university = ParsedUniversityInfo(
      name: uniName,
      group: group,
      semester: semester,
      timezone: timezone,
    );

    final List<ParsedTimetableEvent> events = [];

    for (int i = 0; i < rawEvents.length; i++) {
      final item = rawEvents[i];
      final itemIndex = i + 1;
      if (item is! Map<String, dynamic>) {
        throw TimetableParseException('Event #$itemIndex must be a JSON object.');
      }

      // Check required fields
      final dayRaw = item['day'];
      if (dayRaw == null || dayRaw.toString().trim().isEmpty) {
        throw TimetableParseException("Event #$itemIndex is missing required field 'day'.");
      }
      final dayStr = dayRaw.toString().trim();
      final dayOfWeek = AppDateUtils.dayNameToWeekday(dayStr);
      final normalizedDayName = AppDateUtils.dayName(dayOfWeek);

      final startStr = item['start']?.toString().trim();
      if (startStr == null || startStr.isEmpty) {
        throw TimetableParseException("Event #$itemIndex ($dayStr) is missing 'start' time.");
      }

      final endStr = item['end']?.toString().trim();
      if (endStr == null || endStr.isEmpty) {
        throw TimetableParseException("Event #$itemIndex ($dayStr) is missing 'end' time.");
      }

      final startMinutes = AppDateUtils.parseTimeToMinutes(startStr);
      final endMinutes = AppDateUtils.parseTimeToMinutes(endStr);

      if (!_isValidTimeFormat(startStr)) {
        throw TimetableParseException("Event #$itemIndex has invalid start time format '$startStr'. Expected HH:mm (e.g. 08:30).");
      }
      if (!_isValidTimeFormat(endStr)) {
        throw TimetableParseException("Event #$itemIndex has invalid end time format '$endStr'. Expected HH:mm (e.g. 10:30).");
      }

      if (startMinutes >= endMinutes) {
        throw TimetableParseException(
          "Event #$itemIndex ($dayStr $startStr-$endStr) error: start time must be earlier than end time.",
        );
      }

      final subject = item['subject']?.toString().trim();
      if (subject == null || subject.isEmpty) {
        throw TimetableParseException("Event #$itemIndex is missing required field 'subject'.");
      }

      final type = item['type']?.toString().trim() ?? 'Class';
      final location = item['location']?.toString().trim();
      final instructor = item['instructor']?.toString().trim();

      events.add(
        ParsedTimetableEvent(
          id: item['id']?.toString() ?? 'event_${dayOfWeek}_${startMinutes}_$i',
          dayOfWeek: dayOfWeek,
          dayName: normalizedDayName,
          startTime: startStr,
          endTime: endStr,
          startMinutes: startMinutes,
          endMinutes: endMinutes,
          subject: subject,
          type: type,
          location: location,
          instructor: instructor,
        ),
      );
    }

    return TimetableParseResult(
      university: university,
      events: events,
    );
  }

  static bool _isValidTimeFormat(String time) {
    final regex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
    return regex.hasMatch(time);
  }
}
