import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/alarm_model.dart';
import '../../data/alarm_repository.dart';

final alarmRepositoryProvider = Provider<AlarmRepository>((ref) {
  return AlarmRepository(Supabase.instance.client);
});

final alarmListControllerProvider =
    AsyncNotifierProvider<AlarmListController, List<AlarmModel>>(
        AlarmListController.new);

class AlarmListController extends AsyncNotifier<List<AlarmModel>> {
  @override
  Future<List<AlarmModel>> build() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return [];
    return ref.read(alarmRepositoryProvider).getAlarms(user.id);
  }

  Future<void> addOrUpdateAlarm(AlarmModel alarm) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(alarmRepositoryProvider).saveAlarm(alarm);
      final user = Supabase.instance.client.auth.currentUser;
      return ref.read(alarmRepositoryProvider).getAlarms(user!.id);
    });
  }

  Future<void> toggleAlarm(String alarmId, bool isActive) async {
    final previousState = state.value ?? [];
    state = AsyncValue.data(
      previousState.map((a) => a.id == alarmId ? a.copyWith(isActive: isActive) : a).toList(),
    );
    try {
      await ref.read(alarmRepositoryProvider).toggleAlarm(alarmId, isActive);
    } catch (_) {
      state = AsyncValue.data(previousState);
    }
  }

  Future<void> deleteAlarm(String alarmId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(alarmRepositoryProvider).deleteAlarm(alarmId);
      final user = Supabase.instance.client.auth.currentUser;
      return ref.read(alarmRepositoryProvider).getAlarms(user!.id);
    });
  }
}