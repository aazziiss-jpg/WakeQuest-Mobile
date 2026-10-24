import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

import '../../../../core/constants/app_colors.dart';

class CameraOverlayPainter extends CustomPainter {
  final List<DetectedObject> objects;
  final Size imageSize;
  final InputImageRotation rotation;
  final CameraLensDirection cameraLensDirection;

  CameraOverlayPainter({
    required this.objects,
    required this.imageSize,
    required this.rotation,
    this.cameraLensDirection = CameraLensDirection.back,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = AppColors.primaryDark;

    final background = Paint()..color = AppColors.surfaceLight.withValues(alpha: 0.9);

    for (final detectedObject in objects) {
      final rect = _scaleRect(
        rect: detectedObject.boundingBox,
        imageSize: imageSize,
        widgetSize: size,
        rotation: rotation,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(12)),
        paint,
      );

      if (detectedObject.labels.isNotEmpty) {
        final label = detectedObject.labels.first;
        final text = '${label.text} ${(label.confidence * 100).toStringAsFixed(0)}%';

        final textSpan = TextSpan(
          text: text,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        );

        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        final labelRect = RRect.fromLTRBAndCorners(
          rect.left,
          rect.top - textPainter.height - 12,
          rect.left + textPainter.width + 16,
          rect.top,
          topLeft: const Radius.circular(8),
          topRight: const Radius.circular(8),
        );

        canvas.drawRRect(labelRect, background);
        textPainter.paint(
          canvas,
          Offset(rect.left + 8, rect.top - textPainter.height - 6),
        );
      }
    }
  }

  Rect _scaleRect({
    required Rect rect,
    required Size imageSize,
    required Size widgetSize,
    required InputImageRotation rotation,
  }) {
    final isPortrait = rotation == InputImageRotation.rotation90deg ||
        rotation == InputImageRotation.rotation270deg;

    final absoluteImageSize = isPortrait
        ? Size(imageSize.height, imageSize.width)
        : Size(imageSize.width, imageSize.height);

    final scaleX = widgetSize.width / absoluteImageSize.width;
    final scaleY = widgetSize.height / absoluteImageSize.height;

    double left = rect.left * scaleX;
    double top = rect.top * scaleY;
    double right = rect.right * scaleX;
    double bottom = rect.bottom * scaleY;

    if (cameraLensDirection == CameraLensDirection.front) {
      left = widgetSize.width - right;
      right = widgetSize.width - left;
    }

    return Rect.fromLTRB(left, top, right, bottom);
  }

  @override
  bool shouldRepaint(covariant CameraOverlayPainter oldDelegate) {
    return oldDelegate.objects != objects ||
        oldDelegate.imageSize != imageSize ||
        oldDelegate.rotation != rotation;
  }
}