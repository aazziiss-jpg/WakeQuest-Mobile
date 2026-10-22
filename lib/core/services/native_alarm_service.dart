// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

// @pragma('vm:entry-point')
// void alarmCallback(int id) {
//   // Callback entry point yang dipanggil oleh Android AlarmManager saat alarm dipicu
// }

// class NativeAlarmService {
//   static Future<void> initialize() async {
//     await AndroidAlarmManager.initialize();
//   }

//   static Future<bool> scheduleAlarm({
//     required int alarmId,
//     required DateTime targetTime,
//   }) async {
//     return await AndroidAlarmManager.oneShotAt(
//       targetTime,
//       alarmId,
//       alarmCallback,
//       exact: true,
//       wakeup: true,
//       alarmClock: true,
//       rescheduleOnReboot: true,
//     );
//   }

//   static Future<bool> cancelAlarm(int alarmId) async {
//     return await AndroidAlarmManager.cancel(alarmId);
//   }
// }

import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
void alarmCallback(int id) {
  // Callback entry point yang dipanggil oleh Android AlarmManager
}

class NativeAlarmService {
  static Future<void> initialize() async {
    if (kIsWeb || !Platform.isAndroid) return;
    await AndroidAlarmManager.initialize();
  }

  static Future<bool> scheduleAlarm({
    required int alarmId,
    required DateTime targetTime,
  }) async {
    if (kIsWeb || !Platform.isAndroid) return true;
    return await AndroidAlarmManager.oneShotAt(
      targetTime,
      alarmId,
      alarmCallback,
      exact: true,
      wakeup: true,
      alarmClock: true,
      rescheduleOnReboot: true,
    );
  }

  static Future<bool> cancelAlarm(int alarmId) async {
    if (kIsWeb || !Platform.isAndroid) return true;
    return await AndroidAlarmManager.cancel(alarmId);
  }
}