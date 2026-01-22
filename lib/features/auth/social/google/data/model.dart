class GoogleAccount {
  final String? displayName;
  final String email;
  final String? photoUrl;
  final String? idToken;

  GoogleAccount({
    required this.email,
    this.displayName,
    this.photoUrl,
    this.idToken,
  });
}

class GoogleAccountModel extends GoogleAccount {
  GoogleAccountModel({
    required super.email,
    super.displayName,
    super.photoUrl,
    super.idToken,
  });
}

class GoogleRequest {
  final String? accessToken;
  final String? provider;

  GoogleRequest({
    required this.accessToken,
    required this.provider,
  });
}

class GoogleRequestModel extends GoogleRequest {
  GoogleRequestModel({
    required super.accessToken,
    required super.provider,
  });
}
