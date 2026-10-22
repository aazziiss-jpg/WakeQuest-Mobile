import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../data/alarm_model.dart';
import '../controllers/alarm_controller.dart';
import '../widgets/day_selector_widget.dart';
import '../widgets/target_box_widget.dart';

class AddAlarmScreen extends ConsumerStatefulWidget {
  final AlarmModel? alarmToEdit;

  const AddAlarmScreen({super.key, this.alarmToEdit});

  @override
  ConsumerState<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends ConsumerState<AddAlarmScreen> {
  late TimeOfDay _selectedTime;
  late TextEditingController _titleController;
  late int _targetCount;
  late List<int> _selectedDays;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.alarmToEdit != null
        ? TimeOfDay(hour: widget.alarmToEdit!.hour, minute: widget.alarmToEdit!.minute)
        : TimeOfDay.now();
    _titleController = TextEditingController(text: widget.alarmToEdit?.title ?? 'Bangun Pagi');
    _targetCount = widget.alarmToEdit?.targetCount ?? (Random().nextInt(5) + 1);
    
    // Default repeat-days: [1, 2, 3, 4, 5, 6, 7] (Setiap Hari)
    _selectedDays = widget.alarmToEdit?.repeatDays.isNotEmpty == true
        ? List<int>.from(widget.alarmToEdit!.repeatDays)
        : [1, 2, 3, 4, 5, 6, 7];
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _save() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final alarm = AlarmModel(
      id: widget.alarmToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      userId: user.id,
      title: _titleController.text.trim().isEmpty ? 'Alarm' : _titleController.text.trim(),
      hour: _selectedTime.hour,
      minute: _selectedTime.minute,
      repeatDays: _selectedDays,
      targetCount: _targetCount,
    );

    await ref.read(alarmListControllerProvider.notifier).addOrUpdateAlarm(alarm);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.alarmToEdit == null ? 'Tambah Alarm' : 'Edit Alarm'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () async {
                final time = await showTimePicker(context: context, initialTime: _selectedTime);
                if (time != null) setState(() => _selectedTime = time);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: AppColors.bgLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Center(
                  child: Text(
                    _selectedTime.format(context),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryRed,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Nama Alarm',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            DaySelectorWidget(
              selectedDays: _selectedDays,
              onChanged: (days) => setState(() => _selectedDays = days),
            ),
            const SizedBox(height: 24),
            const TargetBoxWidget(),
            const SizedBox(height: 32),
            AppButton(
              label: 'Simpan Alarm',
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}