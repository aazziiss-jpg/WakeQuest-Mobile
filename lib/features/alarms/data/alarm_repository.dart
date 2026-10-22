import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/errors/failure.dart';
import 'alarm_model.dart';

class AlarmRepository {
  final SupabaseClient _client;

  AlarmRepository(this._client);

  Future<List<AlarmModel>> getAlarms(String userId) async {
    try {
      final response = await _client
          .from('alarms')
          .select()
          .eq('user_id', userId)
          .order('hour', ascending: true);
      return (response as List).map((json) => AlarmModel.fromJson(json)).toList();
    } catch (e) {
      throw Failure('Gagal mengambil daftar alarm: $e');
    }
  }

  Future<void> saveAlarm(AlarmModel alarm) async {
    try {
      await _client.from('alarms').upsert(alarm.toJson());
    } catch (e) {
      throw Failure('Gagal menyimpan alarm: $e');
    }
  }

  Future<void> deleteAlarm(String alarmId) async {
    try {
      await _client.from('alarms').delete().eq('id', alarmId);
    } catch (e) {
      throw Failure('Gagal menghapus alarm: $e');
    }
  }

  Future<void> toggleAlarm(String alarmId, bool isActive) async {
    try {
      await _client.from('alarms').update({'is_active': isActive}).eq('id', alarmId);
    } catch (e) {
      throw Failure('Gagal memperbarui status alarm: $e');
    }
  }
}