import 'package:flutter_test/flutter_test.dart';
import 'package:wakequest/features/alarms/data/alarm_model.dart';

void main() {
  group('AlarmModel Unit Tests', () {
    test('Format waktu jam dan menit harus berformat 2 digit (HH:mm)', () {
      const alarm = AlarmModel(
        id: '1',
        userId: 'user_123',
        title: 'Bangun Subuh',
        hour: 4,
        minute: 5,
        repeatDays: [1, 2, 3, 4, 5],
        targetCount: 3,
      );

      expect(alarm.timeFormatted, equals('04:05'));
    });

    test('Serialisasi JSON & Deserialisasi dari Supabase harus presisi', () {
      final jsonMap = {
        'id': 'alarm_99',
        'user_id': 'usr_abc',
        'title': 'Olahraga Pagi',
        'hour': 6,
        'minute': 30,
        'is_active': true,
        'repeat_days': [1, 3, 5],
        'target_count': 2,
        'sound_path': 'alarm_rock.mp3',
      };

      final alarm = AlarmModel.fromJson(jsonMap);
      expect(alarm.id, equals('alarm_99'));
      expect(alarm.repeatDays, equals([1, 3, 5]));
      expect(alarm.targetCount, equals(2));
      expect(alarm.toJson(), equals(jsonMap));
    });
  });
}