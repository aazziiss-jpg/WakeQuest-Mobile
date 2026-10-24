import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../alarms/presentation/controllers/alarm_controller.dart';
import '../../../alarms/presentation/widgets/alarm_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  Timer? _alarmWatcher;

  @override
  void initState() {
    super.initState();
    _startAlarmWatcher();
  }

  void _startAlarmWatcher() {
    _alarmWatcher = Timer.periodic(const Duration(seconds: 3), (timer) {
      final alarmsAsync = ref.read(alarmListControllerProvider);
      
      alarmsAsync.whenData((alarms) {
        final now = DateTime.now();

        for (final alarm in alarms) {
          // Membandingkan variabel hour dan minute dari model secara langsung
          if (alarm.isActive && alarm.hour == now.hour && alarm.minute == now.minute) {
            
            final updatedAlarm = alarm.copyWith(isActive: false);
            ref.read(alarmListControllerProvider.notifier).addOrUpdateAlarm(updatedAlarm);

            context.push('/mission');
            break; 
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _alarmWatcher?.cancel();
    super.dispose();
  }

  Future<void> _handleMenuSelection(String value) async {
    switch (value) {
      case 'profile':
      case 'history':
      case 'settings':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Menu $value segera hadir!'),
            backgroundColor: AppColors.textDark,
            behavior: SnackBarBehavior.floating,
          ),
        );
        break;
      case 'logout':
        await Supabase.instance.client.auth.signOut();
        if (mounted) context.go('/login');
        break;
    }
  }

  PopupMenuItem<String> _buildMenuItem(String value, IconData icon, String label, {bool isDestructive = false}) {
    final color = isDestructive ? const Color(0xFFEF4444) : AppColors.textDark;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: isDestructive ? FontWeight.w600 : FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alarmsAsync = ref.watch(alarmListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WakeQuest',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        backgroundColor: AppColors.bgLight,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              icon: const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.borderLight,
                child: Icon(Icons.person, color: AppColors.textDark, size: 20),
              ),
              offset: const Offset(0, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppColors.borderLight),
              ),
              color: AppColors.bgLight,
              elevation: 2,
              onSelected: _handleMenuSelection,
              itemBuilder: (BuildContext context) => [
                _buildMenuItem('profile', Icons.person_outline, 'Profile'),
                _buildMenuItem('history', Icons.history, 'History'),
                _buildMenuItem('settings', Icons.settings_outlined, 'Settings'),
                const PopupMenuDivider(height: 16),
                _buildMenuItem('logout', Icons.logout, 'Logout', isDestructive: true),
              ],
            ),
          ),
        ],
      ),
      body: alarmsAsync.when(
        data: (alarms) {
          if (alarms.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada alarm.\nTap + untuk membuat misi bangun pagimu!',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 14),
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
                  final updated = alarm.copyWith(isActive: val);
                  ref.read(alarmListControllerProvider.notifier).addOrUpdateAlarm(updated);
                },
                onTap: () => context.push('/add-alarm', extra: alarm),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.textDark)),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.textDark,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => context.push('/add-alarm'),
        child: const Icon(Icons.add),
      ),
    );
  }
}