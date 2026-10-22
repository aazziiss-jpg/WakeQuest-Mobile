import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../alarms/presentation/controllers/alarm_controller.dart';
import '../../../alarms/presentation/widgets/alarm_card.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alarmState = ref.watch(alarmListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('WakeQuest', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: alarmState.when(
        data: (alarms) {
          if (alarms.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada alarm.\nTekan + untuk membuat alarm interaktif.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: alarms.length,
            itemBuilder: (context, index) {
              final alarm = alarms[index];
              return AlarmCard(
                alarm: alarm,
                onToggle: (val) {
                  ref.read(alarmListControllerProvider.notifier).toggleAlarm(alarm.id, val);
                },
                onTap: () => context.push('/add-alarm', extra: alarm),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryRed,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => context.push('/add-alarm'),
      ),
    );
  }
}