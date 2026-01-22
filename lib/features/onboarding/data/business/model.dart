class OpeningHour {
  final String day;
  final String startAt;
  final String endAt;
  final bool open;

  OpeningHour({
    required this.day,
    required this.startAt,
    required this.endAt,
    required this.open,
  });

  factory OpeningHour.fromJson(Map<String, dynamic> json) {
    return OpeningHour(
      day: json['day'] as String,
      startAt: json['startAt'] as String,
      endAt: json['endAt'] as String,
      open: json['open'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'startAt': startAt,
      'endAt': endAt,
      'open': open,
    };
  }
}

class BusinessModel {
  final String? id;
  final String name;
  final String slug;
  final String? description;
  final String? email;
  final String? whatsapp;
  final bool? whatsappConnected;
  final String? address;
  final String? neighborhood;
  final String? complement;
  final String? city;
  final String? state;
  final String? number;
  final String? zipCode;
  final String? country;
  final String? segment;
  final String? themeColor;
  final List<String>? subSegments;
  final String? instagram;
  final List<OpeningHour>? openingHours;
  final String? logoUrl;
  final String? coverUrl;

  final String? userId;
  final bool? isActive;
  final bool? verified;
  final bool? onlineBookingEnabled;

  final String? mainObjective;
  final String? teamSize; // agora String, ex: "ONLY_ME"
  final String? timezone;
  final String? currency;

  final String? aiToneOfVoice;
  final String? aiLanguage;
  final String? aiVerbosity;

  final double? rating;
  final int? totalReviews;
  final int? totalClients;

  final List<Map<String, dynamic>>? services;
  final List<Map<String, dynamic>>? teamMembers;
  final List<Map<String, dynamic>>? clients;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  BusinessModel({
    this.id,
    required this.name,
    required this.slug,
    this.description,
    this.email,
    this.whatsapp,
    this.whatsappConnected,
    this.address,
    this.neighborhood,
    this.complement,
    this.number,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.segment,
    this.themeColor,
    this.subSegments,
    this.instagram,
    this.openingHours,
    this.logoUrl,
    this.coverUrl,
    this.userId,
    this.isActive,
    this.verified,
    this.onlineBookingEnabled,
    this.mainObjective,
    this.teamSize,
    this.timezone,
    this.currency,
    this.aiToneOfVoice,
    this.aiLanguage,
    this.aiVerbosity,
    this.rating,
    this.totalReviews,
    this.totalClients,
    this.services,
    this.teamMembers,
    this.clients,
    this.createdAt,
    this.updatedAt,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    try {
      return BusinessModel(
        id: json['id'] as String?,
        name: json['name'] as String? ?? '',
        slug: json['slug'] as String? ?? '',
        description: json['description'] as String?,
        email: json['email'] as String?,
        whatsapp: json['whatsapp'] as String?,
        whatsappConnected: _parseBool(json['whatsappConnected']),
        address: json['address'] as String?,
        neighborhood: json['neighborhood'] as String?,
        complement: json['complement'] as String?,
        number: json['number'] as String?,
        city: json['city'] as String?,
        state: json['state'] as String?,
        zipCode: json['zipCode'] as String?,
        country: json['country'] as String?,
        segment: json['segment'] as String?,
        themeColor: json['themeColor'] as String?,
        subSegments: json['subSegments'] != null
            ? List<String>.from(json['subSegments'] as List)
            : null,
        instagram: json['instagram'] as String?,
        openingHours: json['openingHours'] != null
            ? (json['openingHours'] as List)
                .map((e) => OpeningHour.fromJson(e as Map<String, dynamic>))
                .toList()
            : null,
        logoUrl: json['logoUrl'] as String?,
        coverUrl: json['coverUrl'] as String?,
        userId: json['userId'] as String?,
        isActive: json['isActive'] as bool?,
        verified: json['verified'] as bool?,
        onlineBookingEnabled: json['onlineBookingEnabled'] as bool?,
        mainObjective: json['mainObjective'] as String?,
        teamSize: json['teamSize'] as String?,
        timezone: json['timezone'] as String?,
        currency: json['currency'] as String?,
        aiToneOfVoice: json['aiToneOfVoice'] as String?,
        aiLanguage: json['aiLanguage'] as String?,
        aiVerbosity: json['aiVerbosity'] as String?,
        rating: (json['rating'] is int)
            ? (json['rating'] as int).toDouble()
            : json['rating'] as double?,
        totalReviews: json['totalReviews'] as int?,
        totalClients: json['totalClients'] as int?,
        services: (json['services'] as List?)
            ?.map((e) => Map<String, dynamic>.from(e))
            .toList(),
        teamMembers: (json['teamMembers'] as List?)
            ?.map((e) => Map<String, dynamic>.from(e))
            .toList(),
        clients: (json['clients'] as List?)
            ?.map((e) => Map<String, dynamic>.from(e))
            .toList(),
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'])
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'])
            : null,
      );
    } catch (e) {
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'email': email,
      'whatsapp': whatsapp,
      'whatsappConnected': whatsappConnected,
      'address': address,
      'neighborhood': neighborhood,
      'complement': complement,
      'number': number,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'segment': segment,
      'themeColor': themeColor,
      'subSegments': subSegments,
      'instagram': instagram,
      'openingHours': openingHours?.map((e) => e.toJson()).toList(),
      'logoUrl': logoUrl,
      'coverUrl': coverUrl,
      'userId': userId,
      'isActive': isActive,
      'verified': verified,
      'onlineBookingEnabled': onlineBookingEnabled,
      'mainObjective': mainObjective,
      'teamSize': teamSize,
      'timezone': timezone,
      'currency': currency,
      'aiToneOfVoice': aiToneOfVoice,
      'aiLanguage': aiLanguage,
      'aiVerbosity': aiVerbosity,
      'rating': rating,
      'totalReviews': totalReviews,
      'totalClients': totalClients,
      'services': services,
      'teamMembers': teamMembers,
      'clients': clients,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  BusinessModel copyWith({
    String? id,
    String? name,
    String? slug,
    String? description,
    String? email,
    String? whatsapp,
    bool? whatsappConnected,
    String? address,
    String? neighborhood,
    String? complement,
    String? number,
    String? city,
    String? state,
    String? zipCode,
    String? country,
    String? segment,
    String? themeColor,
    List<String>? subSegments,
    String? instagram,
    List<OpeningHour>? openingHours,
    String? logoUrl,
    String? coverUrl,
    String? userId,
    bool? isActive,
    bool? verified,
    bool? onlineBookingEnabled,
    String? mainObjective,
    String? teamSize,
    String? timezone,
    String? currency,
    String? aiToneOfVoice,
    String? aiLanguage,
    String? aiVerbosity,
    double? rating,
    int? totalReviews,
    int? totalClients,
    List<Map<String, dynamic>>? services,
    List<Map<String, dynamic>>? teamMembers,
    List<Map<String, dynamic>>? clients,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BusinessModel(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      email: email ?? this.email,
      whatsapp: whatsapp ?? this.whatsapp,
      whatsappConnected: whatsappConnected ?? this.whatsappConnected,
      address: address ?? this.address,
      neighborhood: neighborhood ?? this.neighborhood,
      complement: complement ?? this.complement,
      number: number ?? this.number,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
      segment: segment ?? this.segment,
      themeColor: themeColor ?? this.themeColor,
      subSegments: subSegments ?? this.subSegments,
      instagram: instagram ?? this.instagram,
      openingHours: openingHours ?? this.openingHours,
      logoUrl: logoUrl ?? this.logoUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      userId: userId ?? this.userId,
      isActive: isActive ?? this.isActive,
      verified: verified ?? this.verified,
      onlineBookingEnabled:
          onlineBookingEnabled ?? this.onlineBookingEnabled,
      mainObjective: mainObjective ?? this.mainObjective,
      teamSize: teamSize ?? this.teamSize,
      timezone: timezone ?? this.timezone,
      currency: currency ?? this.currency,
      aiToneOfVoice: aiToneOfVoice ?? this.aiToneOfVoice,
      aiLanguage: aiLanguage ?? this.aiLanguage,
      aiVerbosity: aiVerbosity ?? this.aiVerbosity,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      totalClients: totalClients ?? this.totalClients,
      services: services ?? this.services,
      teamMembers: teamMembers ?? this.teamMembers,
      clients: clients ?? this.clients,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper method to safely parse boolean values
  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    if (value is int) {
      return value == 1;
    }
    return null;
  }
}
