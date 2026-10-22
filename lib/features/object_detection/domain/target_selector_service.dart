import 'dart:math';
import '../data/ai_target_dictionary.dart';

class TargetSelectorService {
  final Random _random;

  TargetSelectorService([Random? random]) : _random = random ?? Random();

  List<AITargetObject> generateRandomTargets(int count) {
    final available = List<AITargetObject>.from(AITargetDictionary.supportedObjects);
    available.shuffle(_random);
    final clampedCount = count.clamp(1, available.length);
    return available.take(clampedCount).toList();
  }
}