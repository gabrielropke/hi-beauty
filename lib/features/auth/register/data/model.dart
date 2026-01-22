class RegisterRequest {
  final String email;
  final String whatsapp;
  final String password;
  final String emailCode;
  final String name;
  final String howDidYouKnowUs;
  final String referrerPhone;

  RegisterRequest({
    required this.email,
    required this.whatsapp,
    required this.password,
    required this.emailCode,
    required this.name,
    required this.howDidYouKnowUs,
    required this.referrerPhone,
  });
}

class RegisterRequestModel extends RegisterRequest {
  RegisterRequestModel({
    required super.email,
    required super.whatsapp,
    required super.password,
    required super.emailCode,
    required super.name,
    required super.howDidYouKnowUs,
    required super.referrerPhone,
  });

  factory RegisterRequestModel.fromEntity(RegisterRequest e) {
    return RegisterRequestModel(
      email: e.email,
      whatsapp: e.whatsapp,
      password: e.password,
      emailCode: e.emailCode,
      name: e.name,
      howDidYouKnowUs: e.howDidYouKnowUs,
      referrerPhone: e.referrerPhone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "whatsapp": whatsapp,
      "password": password,
      "emailCode": emailCode,
      "name": name,
      "howDidYouKnowUs": howDidYouKnowUs,
      "referrerPhone": referrerPhone,
    };
  }
}

class ReferrerData {
  final String referrerName;
  final String referrerPhone;

  ReferrerData({required this.referrerName, required this.referrerPhone});
}

class ReferrerModel extends ReferrerData {
  ReferrerModel({required super.referrerName, required super.referrerPhone});

  factory ReferrerModel.fromEntity(ReferrerData e) {
    return ReferrerModel(
      referrerName: e.referrerName,
      referrerPhone: e.referrerPhone,
    );
  }

  factory ReferrerModel.fromJson(Map<String, dynamic> json) {
    return ReferrerModel(
      referrerName: json['referrerName'] ?? '',
      referrerPhone: json['referrerPhone'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {"referrerName": referrerName, "referrerPhone": referrerPhone};
  }
}

class ReferrerResponse {
  final bool success;
  final ReferrerModel data;

  ReferrerResponse({required this.success, required this.data});

  factory ReferrerResponse.fromJson(Map<String, dynamic> json) {
    return ReferrerResponse(
      success: json['success'] ?? false,
      data: ReferrerModel.fromJson(json['data'] ?? {}),
    );
  }
}
