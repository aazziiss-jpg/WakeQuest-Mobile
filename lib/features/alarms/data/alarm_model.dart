class AlarmModel {
  final String id;
  final String userId;
  final String title;
  final int hour;
  final int minute;
  final bool isActive;
  final List<int> repeatDays;
  final int targetCount;
  final String soundPath;

  const AlarmModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.hour,
    required this.minute,
    this.isActive = true,
    required this.repeatDays,
    required this.targetCount,
    this.soundPath = 'default_alarm.mp3',
  });

  String get timeFormatted {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get repeatDaysFormatted {
    if (repeatDays.isEmpty) return 'Sekali jalan';
    if (repeatDays.length == 7) return 'Setiap hari';
    
    final sorted = List<int>.from(repeatDays)..sort();
    
    if (sorted.length == 5 && sorted.every((d) => d >= 1 && d <= 5)) {
      return 'Hari kerja (Sen - Jum)';
    }
    if (sorted.length == 2 && sorted.contains(6) && sorted.contains(7)) {
      return 'Akhir pekan (Sab - Min)';
    }

    const dayNames = {
      1: 'Sen',
      2: 'Sel',
      3: 'Rab',
      4: 'Kam',
      5: 'Jum',
      6: 'Sab',
      7: 'Min',
    };

    return sorted.map((d) => dayNames[d] ?? '').where((s) => s.isNotEmpty).join(', ');
  }

  AlarmModel copyWith({
    String? title,
    int? hour,
    int? minute,
    bool? isActive,
    List<int>? repeatDays,
    int? targetCount,
    String? soundPath,
  }) {
    return AlarmModel(
      id: id,
      userId: userId,
      title: title ?? this.title,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      isActive: isActive ?? this.isActive,
      repeatDays: repeatDays ?? this.repeatDays,
      targetCount: targetCount ?? this.targetCount,
      soundPath: soundPath ?? this.soundPath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'hour': hour,
      'minute': minute,
      'is_active': isActive,
      'repeat_days': repeatDays,
      'target_count': targetCount,
      'sound_path': soundPath,
    };
  }

  factory AlarmModel.fromJson(Map<String, dynamic> json) {
    return AlarmModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String? ?? 'Alarm',
      hour: json['hour'] as int,
      minute: json['minute'] as int,
      isActive: json['is_active'] as bool? ?? true,
      repeatDays: List<int>.from(json['repeat_days'] ?? []),
      targetCount: json['target_count'] as int? ?? 1,
      soundPath: json['sound_path'] as String? ?? 'default_alarm.mp3',
    );
  }
}