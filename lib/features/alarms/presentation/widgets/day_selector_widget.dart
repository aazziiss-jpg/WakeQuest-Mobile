import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class DaySelectorWidget extends StatelessWidget {
  final List<int> selectedDays;
  final ValueChanged<List<int>> onChanged;

  const DaySelectorWidget({
    super.key,
    required this.selectedDays,
    required this.onChanged,
  });

  static const List<Map<String, dynamic>> _days = [
    {'label': 'S', 'value': 1, 'fullName': 'Senin'},
    {'label': 'S', 'value': 2, 'fullName': 'Selasa'},
    {'label': 'R', 'value': 3, 'fullName': 'Rabu'},
    {'label': 'K', 'value': 4, 'fullName': 'Kamis'},
    {'label': 'J', 'value': 5, 'fullName': 'Jumat'},
    {'label': 'S', 'value': 6, 'fullName': 'Sabtu'},
    {'label': 'M', 'value': 7, 'fullName': 'Minggu'},
  ];

  void _toggleDay(int dayValue) {
    final updatedDays = List<int>.from(selectedDays);
    if (updatedDays.contains(dayValue)) {
      if (updatedDays.length > 1) {
        updatedDays.remove(dayValue);
      }
    } else {
      updatedDays.add(dayValue);
      updatedDays.sort();
    }
    onChanged(updatedDays);
  }

  @override
  Widget build(BuildContext context) {
    final isEveryday = selectedDays.length == 7;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ulangi Hari',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            Text(
              isEveryday ? 'Setiap Hari' : '${selectedDays.length} Hari Terpilih',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _days.map((day) {
            final isSelected = selectedDays.contains(day['value']);
            return GestureDetector(
              onTap: () => _toggleDay(day['value'] as int),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.textDark : AppColors.surfaceLight,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.textDark : AppColors.borderLight,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    day['label'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}