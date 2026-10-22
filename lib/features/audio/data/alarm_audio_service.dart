import 'package:audioplayers/audioplayers.dart';

class AlarmAudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  bool get isPlaying => _isPlaying;

  Future<void> playAlarmSound(String soundPath) async {
    if (_isPlaying) return;
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource('audio/$soundPath'));
      _isPlaying = true;
    } catch (_) {
      await _audioPlayer.play(AssetSource('audio/default_alarm.mp3'));
      _isPlaying = true;
    }
  }

  Future<void> stopAlarmSound() async {
    if (!_isPlaying) return;
    await _audioPlayer.stop();
    _isPlaying = false;
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}