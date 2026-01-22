class ForgotPassword {
  final String email;
  final String password;
  final String emailCode;

  ForgotPassword({
    required this.email,
    required this.password,
    required this.emailCode,
  });
}

class ForgotPasswordModel extends ForgotPassword {
  ForgotPasswordModel({
    required super.email,
    required super.password,
    required super.emailCode,
  });

  factory ForgotPasswordModel.fromEntity(ForgotPassword e) {
    return ForgotPasswordModel(
      email: e.email,
      password: e.password,
      emailCode: e.emailCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "password": password,
      "emailCode": emailCode,
    };
  }
}
