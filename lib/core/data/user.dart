import 'package:equatable/equatable.dart';
import 'package:hibeauty/core/data/secure_storage.dart';

class UserData {
  static String get id => UserService().currentUser?.id ?? '';
  static String get name => UserService().currentUser?.name ?? '';
  static String get email => UserService().currentUser?.email ?? '';
  static String get profileImageUrl =>
      UserService().currentUser?.profileImageUrl ?? '';
  static String get whatsapp => UserService().currentUser?.whatsapp ?? '';
  static String get userSessionToken =>
      UserService().currentUser?.userSessionToken ?? '';
  static bool get setupCompleted =>
      UserService().currentUser?.setupCompleted ?? false;

  static bool get isLogged {
    final user = UserService().currentUser;
    return user != null && user.userSessionToken.isNotEmpty;
  }
}

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  User? _currentUser;
  bool _loaded = false;

  User? get currentUser => _currentUser;

  Future<void> initialize() async {
    if (_loaded) return;
    _currentUser = await SecureStorage.getUser();
    _loaded = true;
  }

  void setUser(User user) {
    _currentUser = user;
  }

  void clearUser() {
    _currentUser = null;
    _loaded = false;
  }

  /// Método seguro para atualizar propriedades do usuário
  void updateUser(User Function(User) updateFn) {
    final current = _currentUser;
    if (current != null) {
      _currentUser = updateFn(current);
    }
  }

  bool get setupCompleted => _currentUser?.setupCompleted ?? false;
  void setSetupCompleted(bool value) {
    updateUser((user) => user.copyWith(setupCompleted: value));
  }
}

class User extends Equatable {
  const User({
    required this.userSessionToken,
    this.id,
    this.name,
    this.email,
    this.whatsapp,
    this.profileImageUrl,
    this.setupCompleted = false,
  });

  final String userSessionToken;
  final String? id;
  final String? name;
  final String? email;
  final String? whatsapp;
  final String? profileImageUrl;
  final bool setupCompleted;

  static const empty = User(
    userSessionToken: '',
    id: '',
    name: '',
    email: '',
    whatsapp: null,
    profileImageUrl: null,
    setupCompleted: false,
  );

  bool get isEmpty => this == User.empty;
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [
    userSessionToken,
    id,
    name,
    email,
    whatsapp,
    profileImageUrl,
    setupCompleted,
  ];

  Map<String, dynamic> toJson() => {
    'userSessionToken': userSessionToken,
    'id': id,
    'name': name,
    'email': email,
    'whatsapp': whatsapp,
    'profileImageUrl': profileImageUrl,
    'setupCompleted': setupCompleted,
  };

  Map<String, dynamic> toMap() => {
    'userSessionToken': userSessionToken,
    'id': id,
    'name': name,
    'email': email,
    'whatsapp': whatsapp,
    'profileImageUrl': profileImageUrl,
    'setupCompleted': setupCompleted,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    userSessionToken: json['userSessionToken'] ?? '',
    id: json['id'] as String?,
    name: json['name'] as String?,
    email: json['email'] as String?,
    whatsapp: json['whatsapp'] as String?,
    profileImageUrl: json['profileImageUrl'] as String?,
    setupCompleted: json['setupCompleted'] as bool? ?? false,
  );

  factory User.fromMap(Map<String, dynamic> map) => User(
    userSessionToken: map['userSessionToken'] ?? '',
    id: map['id'] as String?,
    name: map['name'] as String?,
    email: map['email'] as String?,
    whatsapp: map['whatsapp'] as String?,
    profileImageUrl: map['profileImageUrl'] as String?,
    setupCompleted: map['setupCompleted'] as bool? ?? false,
  );

  User copyWith({
    String? userSessionToken,
    String? id,
    String? name,
    String? email,
    String? whatsapp,
    String? profileImageUrl,
    bool? setupCompleted,
  }) => User(
    userSessionToken: userSessionToken ?? this.userSessionToken,
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    whatsapp: whatsapp ?? this.whatsapp,
    profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    setupCompleted: setupCompleted ?? this.setupCompleted,
  );
}
