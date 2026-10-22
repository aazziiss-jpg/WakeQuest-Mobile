import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/alarm_model.dart';

class AlarmCard extends StatelessWidget {
  final AlarmModel alarm;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTap;

  const AlarmCard({
    super.key,
    required this.alarm,
    required this.onToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.borderLight),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          alarm.timeFormatted,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: alarm.isActive ? AppColors.textDark : AppColors.textMuted,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(alarm.title, style: const TextStyle(color: AppColors.textMuted)),
            const SizedBox(height: 4),
            Text(
              '${alarm.targetCount} Target Tersembunyi ("Apa Hayo")',
              style: const TextStyle(fontSize: 12, color: AppColors.primaryRed),
            ),
          ],
        ),
        trailing: Switch(
          value: alarm.isActive,
          activeTrackColor: AppColors.primaryRed,
          onChanged: onToggle,
        ),
      ),
    );
  }
}