import 'package:audioplayers/audioplayers.dart';

class AlarmAudioService {
  final AudioPlayer _player = AudioPlayer();
  String? _currentlyPlayingPath;

  bool get isPlaying => _player.state == PlayerState.playing;
  String? get currentlyPlayingPath => _currentlyPlayingPath;

  Future<void> previewSound(String soundPath, {bool isCustom = false}) async {
    if (_currentlyPlayingPath == soundPath && isPlaying) {
      await stopPreview();
      return;
    }

    await stopPreview();
    _currentlyPlayingPath = soundPath;

    if (isCustom) {
      await _player.play(DeviceFileSource(soundPath));
    } else {
      await _player.play(AssetSource('audio/$soundPath'));
    }
  }

  Future<void> stopPreview() async {
    await _player.stop();
    _currentlyPlayingPath = null;
  }

  void dispose() {
    _player.dispose();
  }
}