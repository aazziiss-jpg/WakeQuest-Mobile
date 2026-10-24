import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';

class ObjectDetectorService {
  late final ObjectDetector _objectDetector;

  ObjectDetectorService() {
    final options = ObjectDetectorOptions(
      mode: DetectionMode.stream,
      classifyObjects: true,
      multipleObjects: true,
    );
    _objectDetector = ObjectDetector(options: options);
  }

  Future<List<DetectedObject>> processImage(InputImage inputImage) async {
    return await _objectDetector.processImage(inputImage);
  }

  void dispose() {
    _objectDetector.close();
  }
}