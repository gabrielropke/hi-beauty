class LoginRequest {
  final String? email;
  final String? phoneNumber;
  final String password;

  LoginRequest({
    this.email,
    this.phoneNumber,
    required this.password,
  });
}

class LoginRequestModel extends LoginRequest {
  LoginRequestModel({
    super.email,
    super.phoneNumber,
    required super.password,
  });

  factory LoginRequestModel.fromEntity(LoginRequest e) {
    return LoginRequestModel(
      email: e.email,
      phoneNumber: e.phoneNumber,
      password: e.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (email != null) "email": email,
      if (phoneNumber != null) "phoneNumber": phoneNumber,
      "password": password,
    };
  }
}