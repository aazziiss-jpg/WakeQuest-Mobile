import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../object_detection/data/object_detector_service.dart';
import '../../../object_detection/presentation/widgets/camera_overlay_painter.dart';
import '../../../object_detection/presentation/widgets/camera_view.dart';

class MissionCameraScreen extends StatefulWidget {
  final String targetObject;

  const MissionCameraScreen({
    super.key,
    required this.targetObject,
  });

  @override
  State<MissionCameraScreen> createState() => _MissionCameraScreenState();
}

class _MissionCameraScreenState extends State<MissionCameraScreen> {
  final ObjectDetectorService _objectDetectorService = ObjectDetectorService();
  bool _isProcessing = false;
  bool _isMissionSuccess = false;
  CustomPaint? _customPaint;

  @override
  void dispose() {
    _objectDetectorService.dispose();
    super.dispose();
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (_isProcessing || _isMissionSuccess) return;
    _isProcessing = true;

    final objects = await _objectDetectorService.processImage(inputImage);
    
    bool foundTarget = false;
    for (final object in objects) {
      for (final label in object.labels) {
        // Memeriksa apakah teks label AI cocok dengan target
        if (label.text.toLowerCase() == widget.targetObject.toLowerCase() && label.confidence > 0.65) {
          foundTarget = true;
          break;
        }
      }
    }

    if (foundTarget && mounted) {
      _isMissionSuccess = true;
      _showSuccessDialog();
    } else if (mounted) {
      final painter = CameraOverlayPainter(
        objects: objects,
        imageSize: inputImage.metadata!.size,
        rotation: inputImage.metadata!.rotation,
      );
      setState(() => _customPaint = CustomPaint(painter: painter));
    }

    _isProcessing = false;
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Memaksa pengguna menekan tombol "Kembali"
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Misi Berhasil!',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        content: Text(
          'Kamu berhasil menemukan ${widget.targetObject}. Alarm telah dimatikan.',
          style: const TextStyle(color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop(); 
              context.go('/dashboard');
            },
            child: const Text('Kembali', style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan WillPopScope/PopScope agar tidak bisa kembali dengan tombol back fisik perangkat
      body: PopScope(
        canPop: false,
        child: Stack(
          children: [
            CameraView(
              onImage: _processImage,
              customPaint: _customPaint,
            ),
            Positioned(
              top: 60,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderLight),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Misi: Cari & Sorot',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.targetObject.toUpperCase(),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textDark),
                    ),
                  ],
                ),
              ),
            ),
            // Tombol "X" telah dihapus dari sini sesuai permintaan.
          ],
        ),
      ),
    );
  }
}