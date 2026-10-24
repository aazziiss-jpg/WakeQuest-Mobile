import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../alarms/presentation/controllers/alarm_controller.dart';
import '../../../alarms/presentation/widgets/alarm_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  Future<void> _handleMenuSelection(BuildContext context, String value) async {
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
        if (context.mounted) {
          context.go('/login');
        }
        break;
    }
  }

  PopupMenuItem<String> _buildMenuItem(String value, IconData icon, String label, {bool isDestructive = false}) {
    final color = isDestructive ? AppColors.primaryRed : AppColors.textDark;
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
  Widget build(BuildContext context, WidgetRef ref) {
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
          PopupMenuButton<String>(
            icon: const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.surfaceLight,
              child: Icon(Icons.person, color: AppColors.textDark, size: 20),
            ),
            offset: const Offset(0, 45),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.borderLight),
            ),
            color: AppColors.bgLight,
            elevation: 2,
            onSelected: (value) => _handleMenuSelection(context, value),
            itemBuilder: (BuildContext context) => [
              _buildMenuItem('profile', Icons.person_outline, 'Profile'),
              _buildMenuItem('history', Icons.history, 'History'),
              _buildMenuItem('settings', Icons.settings_outlined, 'Settings'),
              const PopupMenuDivider(height: 16),
              _buildMenuItem('logout', Icons.logout, 'Logout', isDestructive: true),
            ],
          ),
          const SizedBox(width: 12),
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
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryRed)),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => context.push('/add-alarm'),
        child: const Icon(Icons.add),
      ),
    );
  }
}