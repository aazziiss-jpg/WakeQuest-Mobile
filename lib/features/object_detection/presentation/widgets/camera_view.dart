import 'dart:io' show Platform;
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/constants/app_colors.dart';

class CameraView extends StatefulWidget {
  final Function(InputImage) onImage;
  final CustomPaint? customPaint;
  final CameraLensDirection initialDirection;

  const CameraView({
    super.key,
    required this.onImage,
    this.customPaint,
    this.initialDirection = CameraLensDirection.back,
  });

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _cameraIndex = -1;
  bool _isPermitted = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _cameraIndex = _cameras.indexWhere((c) => c.lensDirection == widget.initialDirection);
        if (_cameraIndex == -1) _cameraIndex = 0;
        await _startLiveFeed();
        if (mounted) setState(() => _isPermitted = true);
      }
    }
  }

  Future<void> _startLiveFeed() async {
    final camera = _cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );
    
    await _controller?.initialize();
    if (!mounted) return;
    
    _controller?.startImageStream(_processCameraImage);
    setState(() {});
  }

  void _processCameraImage(CameraImage image) {
    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage != null) {
      widget.onImage(inputImage);
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null) return null;
    final camera = _cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;
    
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = _orientationToDegrees(_controller!.value.deviceOrientation);
      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;

    final allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  int _orientationToDegrees(DeviceOrientation orientation) {
    switch (orientation) {
      case DeviceOrientation.portraitUp: return 0;
      case DeviceOrientation.landscapeLeft: return 90;
      case DeviceOrientation.portraitDown: return 180;
      case DeviceOrientation.landscapeRight: return 270;
    }
  }

  @override
  void dispose() {
    _controller?.stopImageStream();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const Scaffold(
        backgroundColor: AppColors.bgLight,
        body: Center(
          child: Text(
            'Google ML Kit tidak didukung di Web.\nHarap gunakan Android Emulator atau Real Device.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
    if (!_isPermitted) {
      return const Scaffold(
        backgroundColor: AppColors.bgLight,
        body: Center(
          child: Text('Memerlukan izin kamera untuk misi', style: TextStyle(color: AppColors.textDark)),
        ),
      );
    }
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: AppColors.bgLight,
        body: Center(child: CircularProgressIndicator(color: AppColors.primaryDark)),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(_controller!),
        if (widget.customPaint != null) widget.customPaint!,
      ],
    );
  }
}