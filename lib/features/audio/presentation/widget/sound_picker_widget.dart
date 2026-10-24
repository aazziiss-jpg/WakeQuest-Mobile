import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/alarm_audio_service.dart';

class SoundOption {
  final String title;
  final String path;
  final bool isCustom;

  const SoundOption({
    required this.title,
    required this.path,
    this.isCustom = false,
  });
}

class SoundPickerWidget extends StatefulWidget {
  final String selectedSoundPath;
  final ValueChanged<SoundOption> onSoundSelected;

  const SoundPickerWidget({
    super.key,
    required this.selectedSoundPath,
    required this.onSoundSelected,
  });

  @override
  State<SoundPickerWidget> createState() => _SoundPickerWidgetState();
}

class _SoundPickerWidgetState extends State<SoundPickerWidget> {
  final AlarmAudioService _audioService = AlarmAudioService();

  final List<SoundOption> _defaultSounds = const [
    SoundOption(title: 'Default Alarm', path: 'default_alarm.mp3'),
    SoundOption(title: 'Digital Beacon', path: 'digital_beacon.mp3'),
    SoundOption(title: 'Morning Breeze', path: 'morning_breeze.mp3'),
  ];

  SoundOption? _customSound;

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }

  Future<void> _pickCustomFile() async {
    final dynamic result = await FilePicker.pickFiles(type: FileType.audio);

    if (!mounted) return;

    final List files = (result is List) ? result : (result?.files ?? []);

    if (files.isNotEmpty) {
      final file = files.first;
      final String? filePath = file.path;
      final String fileName = file.name;

      if (filePath != null) {
        final customOption = SoundOption(
          title: fileName,
          path: filePath,
          isCustom: true,
        );

        setState(() => _customSound = customOption);
        widget.onSoundSelected(customOption);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final allSounds = [
      ..._defaultSounds,
      ...?(_customSound != null ? [_customSound!] : null),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Lagu Alarm',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            TextButton.icon(
              onPressed: _pickCustomFile,
              icon: const Icon(Icons.upload_file, size: 16, color: AppColors.primaryRed),
              label: const Text(
                'Upload Lagu',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primaryRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Material(
          color: AppColors.surfaceLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.borderLight),
          ),
          clipBehavior: Clip.antiAlias,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allSounds.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.borderLight),
            itemBuilder: (context, index) {
              final sound = allSounds[index];
              final isSelected = widget.selectedSoundPath == sound.path;
              final isPlaying = _audioService.currentlyPlayingPath == sound.path &&
                  _audioService.isPlaying;

              return ListTile(
                onTap: () => widget.onSoundSelected(sound),
                leading: Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: isSelected ? AppColors.textDark : AppColors.textMuted,
                ),
                title: Text(
                  sound.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: AppColors.textDark,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                    color: isPlaying ? AppColors.textDark : AppColors.textMuted,
                  ),
                  onPressed: () async {
                    await _audioService.previewSound(
                      sound.path,
                      isCustom: sound.isCustom,
                    );
                    if (!mounted) return;
                    setState(() {});
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}