import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:wakequest/features/object_detection/data/ai_target_dictionary.dart';
import 'package:wakequest/features/object_detection/domain/target_selector_service.dart';

void main() {
  group('TargetSelectorService Unit Tests', () {
    late TargetSelectorService service;

    setUp(() {
      service = TargetSelectorService(Random(42)); // Seed tetap untuk deterministik
    });

    test('Harus menghasilkan jumlah target acak yang sesuai batas (1 sampai 5)', () {
      for (int count = 1; count <= 5; count++) {
        final targets = service.generateRandomTargets(count);
        expect(targets.length, equals(count));
      }
    });

    test('Tidak boleh ada target objek yang duplikat dalam satu sesi misi', () {
      final targets = service.generateRandomTargets(5);
      final uniqueIds = targets.map((e) => e.id).toSet();
      expect(uniqueIds.length, equals(targets.length));
    });

    test('Seluruh objek tergenerasi harus terdaftar di AITargetDictionary', () {
      final targets = service.generateRandomTargets(5);
      for (final target in targets) {
        final found = AITargetDictionary.findByCocoLabel(target.cocoLabel);
        expect(found, isNotNull);
        expect(found!.id, equals(target.id));
      }
    });
  });
}