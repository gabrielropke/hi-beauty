class SegmentsModel {
  final String label;
  final String key;

  SegmentsModel({required this.label, required this.key});

  factory SegmentsModel.fromMap(Map<String, dynamic> map) {
    return SegmentsModel(
      label: map['label'] as String,
      key: map['key'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'label': label, 'key': key};
  }

  factory SegmentsModel.fromJson(Map<String, dynamic> json) =>
      SegmentsModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();
}

class SubSegmentsModel {
  final String id;
  final String name;
  final String description;

  SubSegmentsModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory SubSegmentsModel.fromMap(Map<String, dynamic> map) {
    return SubSegmentsModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description,
  };

  factory SubSegmentsModel.fromJson(Map<String, dynamic> json) =>
      SubSegmentsModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();
}

class MainObjectiveModel {
  final String key;
  final String label;

  MainObjectiveModel({required this.key, required this.label});

  factory MainObjectiveModel.fromMap(Map<String, dynamic> map) {
    return MainObjectiveModel(
      key: map['key'] as String,
      label: map['label'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'key': key, 'label': label};
  }

  factory MainObjectiveModel.fromJson(Map<String, dynamic> json) =>
      MainObjectiveModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();
}

class TeamSizeModel {
  final String label;
  final String key;

  TeamSizeModel({required this.label, required this.key});

  factory TeamSizeModel.fromMap(Map<String, dynamic> map) {
    return TeamSizeModel(
      label: map['label'] as String,
      key: map['key'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'label': label, 'key': key};
  }

  factory TeamSizeModel.fromJson(Map<String, dynamic> json) =>
      TeamSizeModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();
}
