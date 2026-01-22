import 'dart:convert';

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

class SetupAddressModel {
  final String address;
  final String neighborhood;
  final String city;
  final String number;
  final String complement;
  final String state;
  final String zipCode;
  final String country;

  const SetupAddressModel({
    required this.address,
    required this.neighborhood,
    required this.city,
    required this.number,
    required this.complement,
    required this.state,
    required this.zipCode,
    required this.country,
  });

  factory SetupAddressModel.fromJson(Map<String, dynamic> json) {
    return SetupAddressModel(
      address: json['address'] as String? ?? '',
      neighborhood: json['neighborhood'] as String? ?? '',
      city: json['city'] as String? ?? '',
      number: json['number'] as String? ?? '',
      complement: json['complement'] as String? ?? '',
      state: json['state'] as String? ?? '',
      zipCode: json['zipCode'] as String? ?? '',
      country: json['country'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'address': address,
        'neighborhood': neighborhood,
        'city': city,
        'number': number,
        'complement': complement,
        'state': state,
        'zipCode': zipCode,
        'country': country,
      };

  SetupAddressModel copyWith({
    String? address,
    String? neighborhood,
    String? city,
    String? number,
    String? complement,
    String? state,
    String? zipCode,
    String? country,
  }) {
    return SetupAddressModel(
      address: address ?? this.address,
      neighborhood: neighborhood ?? this.neighborhood,
      city: city ?? this.city,
      number: number ?? this.number,
      complement: complement ?? this.complement,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      country: country ?? this.country,
    );
  }
}

class BusinessRulesResponseModel {
  final bool ok;
  final String message;
  final BusinessRulesModel businessRules;

  BusinessRulesResponseModel({
    required this.ok,
    required this.message,
    required this.businessRules,
  });

  factory BusinessRulesResponseModel.fromMap(Map<String, dynamic> map) {
    return BusinessRulesResponseModel(
      ok: map['ok'] as bool? ?? false,
      message: map['message'] as String? ?? '',
      businessRules: BusinessRulesModel.fromMap(map['businessRules'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ok': ok,
      'message': message,
      'businessRules': businessRules.toMap(),
    };
  }

  factory BusinessRulesResponseModel.fromJson(Map<String, dynamic> json) =>
      BusinessRulesResponseModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();
}

class BusinessRulesModel {
  final String id;
  final int timeSlotIncrement;
  final int bookingWindow;
  final int minimumAdvanceBooking;
  final int preServiceBuffer;
  final int postServiceBuffer;
  final bool requiresTermsAcceptance;
  final String? termsAndConditions;
  final bool requiresConfirmation;
  final int? confirmationTimeLimit;
  final int cancellationTimeLimit;
  final bool allowsRescheduling;
  final bool allowsCancellation;
  final bool allowsMultipleBookingsPerDay;
  final int? maxBookingsPerClientPerDay;
  final bool allowsHolidayBookings;
  final String businessId;
  final String createdAt;
  final String updatedAt;

  BusinessRulesModel({
    required this.id,
    required this.timeSlotIncrement,
    required this.bookingWindow,
    required this.minimumAdvanceBooking,
    required this.preServiceBuffer,
    required this.postServiceBuffer,
    required this.requiresTermsAcceptance,
    this.termsAndConditions,
    required this.requiresConfirmation,
    this.confirmationTimeLimit,
    required this.cancellationTimeLimit,
    required this.allowsRescheduling,
    required this.allowsCancellation,
    required this.allowsMultipleBookingsPerDay,
    this.maxBookingsPerClientPerDay,
    required this.allowsHolidayBookings,
    required this.businessId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BusinessRulesModel.fromMap(Map<String, dynamic> map) {
    return BusinessRulesModel(
      id: map['id'] as String? ?? '',
      timeSlotIncrement: map['timeSlotIncrement'] as int? ?? 0,
      bookingWindow: map['bookingWindow'] as int? ?? 0,
      minimumAdvanceBooking: map['minimumAdvanceBooking'] as int? ?? 0,
      preServiceBuffer: map['preServiceBuffer'] as int? ?? 0,
      postServiceBuffer: map['postServiceBuffer'] as int? ?? 0,
      requiresTermsAcceptance: map['requiresTermsAcceptance'] as bool? ?? false,
      termsAndConditions: map['termsAndConditions'] as String?,
      requiresConfirmation: map['requiresConfirmation'] as bool? ?? false,
      confirmationTimeLimit: map['confirmationTimeLimit'] as int?,
      cancellationTimeLimit: map['cancellationTimeLimit'] as int? ?? 0,
      allowsRescheduling: map['allowsRescheduling'] as bool? ?? false,
      allowsCancellation: map['allowsCancellation'] as bool? ?? false,
      allowsMultipleBookingsPerDay:
          map['allowsMultipleBookingsPerDay'] as bool? ?? false,
      maxBookingsPerClientPerDay: map['maxBookingsPerClientPerDay'] as int?,
      allowsHolidayBookings: map['allowsHolidayBookings'] as bool? ?? false,
      businessId: map['businessId'] as String? ?? '',
      createdAt: map['createdAt'] as String? ?? '',
      updatedAt: map['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timeSlotIncrement': timeSlotIncrement,
      'bookingWindow': bookingWindow,
      'minimumAdvanceBooking': minimumAdvanceBooking,
      'preServiceBuffer': preServiceBuffer,
      'postServiceBuffer': postServiceBuffer,
      'requiresTermsAcceptance': requiresTermsAcceptance,
      'termsAndConditions': termsAndConditions,
      'requiresConfirmation': requiresConfirmation,
      'confirmationTimeLimit': confirmationTimeLimit,
      'cancellationTimeLimit': cancellationTimeLimit,
      'allowsRescheduling': allowsRescheduling,
      'allowsCancellation': allowsCancellation,
      'allowsMultipleBookingsPerDay': allowsMultipleBookingsPerDay,
      'maxBookingsPerClientPerDay': maxBookingsPerClientPerDay,
      'allowsHolidayBookings': allowsHolidayBookings,
      'businessId': businessId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory BusinessRulesModel.fromJson(Map<String, dynamic> json) =>
      BusinessRulesModel.fromMap(json);

  Map<String, dynamic> toJson() => toMap();
}

class WhatsAppPairingResponse {
  final bool ok;
  final String message;
  final String pairingCode;

  WhatsAppPairingResponse({
    required this.ok,
    required this.message,
    required this.pairingCode,
  });

  factory WhatsAppPairingResponse.fromMap(Map<String, dynamic> map) {
    return WhatsAppPairingResponse(
      ok: map['ok'] ?? false,
      message: map['message'] ?? '',
      pairingCode: map['pairingCode'] ?? '',
    );
  }

  factory WhatsAppPairingResponse.fromJson(String source) =>
      WhatsAppPairingResponse.fromMap(json.decode(source));
}
