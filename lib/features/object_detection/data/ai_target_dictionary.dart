class AITargetObject {
  final String id;
  final String displayName;
  final String cocoLabel;

  const AITargetObject({
    required this.id,
    required this.displayName,
    required this.cocoLabel,
  });
}

abstract class AITargetDictionary {
  static const List<AITargetObject> supportedObjects = [
    AITargetObject(id: 'cell_phone', displayName: 'HP / Smartphone', cocoLabel: 'cell phone'),
    AITargetObject(id: 'laptop', displayName: 'Laptop', cocoLabel: 'laptop'),
    AITargetObject(id: 'mouse', displayName: 'Mouse Komputer', cocoLabel: 'mouse'),
    AITargetObject(id: 'keyboard', displayName: 'Keyboard', cocoLabel: 'keyboard'),
    AITargetObject(id: 'book', displayName: 'Buku', cocoLabel: 'book'),
    AITargetObject(id: 'bottle', displayName: 'Botol Minum', cocoLabel: 'bottle'),
    AITargetObject(id: 'cup', displayName: 'Cangkir / Gelas', cocoLabel: 'cup'),
    AITargetObject(id: 'chair', displayName: 'Kursi', cocoLabel: 'chair'),
    AITargetObject(id: 'couch', displayName: 'Sofa / Kasur', cocoLabel: 'couch'),
    AITargetObject(id: 'clock', displayName: 'Jam Dinding / Meja', cocoLabel: 'clock'),
    AITargetObject(id: 'scissors', displayName: 'Gunting', cocoLabel: 'scissors'),
    AITargetObject(id: 'backpack', displayName: 'Tas / Ransel', cocoLabel: 'backpack'),
    AITargetObject(id: 'umbrella', displayName: 'Payung', cocoLabel: 'umbrella'),
    AITargetObject(id: 'bowl', displayName: 'Mangkuk', cocoLabel: 'bowl'),
    AITargetObject(id: 'spoon', displayName: 'Sendok', cocoLabel: 'spoon'),
  ];

  static AITargetObject? findByCocoLabel(String label) {
    try {
      return supportedObjects.firstWhere(
        (obj) => obj.cocoLabel.toLowerCase() == label.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }
}