class SetupBasicModel {
  final String name;
  final String slug;
  final String whatsapp;
  final String segment;
  final List<String> subSegments;
  final String mainObjective;
  final String teamSize;
  final String instagram;
  final String description;

  SetupBasicModel({
    required this.name,
    required this.slug,
    required this.whatsapp,
    required this.segment,
    required this.subSegments,
    required this.mainObjective,
    required this.teamSize,
    required this.instagram,
    required this.description,
  });

  factory SetupBasicModel.fromJson(Map<String, dynamic> json) {
    return SetupBasicModel(
      name: json['name'] as String,
      slug: json['slug'] as String,
      whatsapp: json['whatsapp'] as String,
      segment: json['segment'] as String,
      subSegments: List<String>.from(json['subSegments'] ?? []),
      mainObjective: json['mainObjective'] as String,
      teamSize: json['teamSize'] as String,
      instagram: json['instagram'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
      'whatsapp': whatsapp,
      'segment': segment,
      'subSegments': subSegments,
      'mainObjective': mainObjective,
      'teamSize': teamSize,
      'instagram': instagram,
      'description': description,
    };
  }
}
