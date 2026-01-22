// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class TeamResponseModel {
  final bool ok;
  final String? message;
  final String? error;
  final List<TeamMemberModel> teamMembers;
  final int total;
  final int page;
  final int pageSize;

  TeamResponseModel({
    required this.ok,
    this.message,
    this.error,
    required this.teamMembers,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  factory TeamResponseModel.fromJson(Map<String, dynamic> json) {
    final pagination = json['pagination'] ?? {};

    return TeamResponseModel(
      ok: json['ok'] ?? false,
      message: json['message'],
      error: json['error'],
      teamMembers:
          (json['teamMembers'] as List<dynamic>?)
              ?.map((e) => TeamMemberModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      page: pagination['page'] ?? 1,
      pageSize: pagination['pageSize'] ?? 20,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ok': ok,
      'message': message,
      'error': error,
      'teamMembers': teamMembers.map((e) => e.toJson()).toList(),
      'total': total,
      'pagination': {'page': page, 'pageSize': pageSize},
    };
  }
}

class TeamMemberModel {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String? profileImageUrl;
  final String role;
  final String status;
  final String themeColor;
  final List<WorkingHourModel> workingHours;
  final String businessId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CommissionConfigModel? commissionConfig;

  TeamMemberModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImageUrl,
    required this.role,
    required this.status,
    required this.themeColor,
    required this.workingHours,
    required this.businessId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.commissionConfig,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      role: json['role'] ?? '',
      status: json['status'] ?? '',
      themeColor: json['themeColor'] ?? '',
      workingHours:
          (json['workingHours'] as List<dynamic>?)
              ?.map((e) => WorkingHourModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      businessId: json['businessId'] ?? '',
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      commissionConfig: json['commissionConfig'] != null
          ? CommissionConfigModel.fromJson(json['commissionConfig'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'role': role,
      'status': status,
      'themeColor': themeColor,
      'workingHours': workingHours.map((e) => e.toJson()).toList(),
      'businessId': businessId,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'commissionConfig': commissionConfig?.toJson(),
    };
  }
}

class WorkingHourModel {
  final String day;
  final String startAt;
  final String endAt;
  final bool isWorking;

  WorkingHourModel({
    required this.day,
    required this.startAt,
    required this.endAt,
    required this.isWorking,
  });

  factory WorkingHourModel.fromJson(Map<String, dynamic> json) {
    return WorkingHourModel(
      day: json['day'] ?? '',
      startAt: json['startAt'] ?? '',
      endAt: json['endAt'] ?? '',
      isWorking: json['isWorking'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'startAt': startAt,
      'endAt': endAt,
      'isWorking': isWorking,
    };
  }
}

class CreateTeamModel {
  final String name;
  final String email;
  final String phone;
  final String role;
  final String status;
  final String themeColor;
  final List<Map<String, dynamic>> workingHours;
  final File? profileImage;
  final String? profileImageUrl; // nova propriedade para URL
  final CommissionConfigModel? commissionConfig;

  CreateTeamModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.status,
    required this.themeColor,
    required this.workingHours,
    this.profileImage,
    this.profileImageUrl,
    this.commissionConfig,
  });

  /// Converte URL em File temporário se necessário
  Future<File?> getProfileImageFile() async {
    if (profileImage != null) return profileImage;
    if (profileImageUrl == null || profileImageUrl!.isEmpty) return null;

    try {
      final response = await http.get(Uri.parse(profileImageUrl!));
      if (response.statusCode != 200) return null;

      final tempDir = await getTemporaryDirectory();
      final fileName =
          'temp_profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = File(p.join(tempDir.path, fileName));

      await file.writeAsBytes(response.bodyBytes);
      return file;
    } catch (_) {
      return null;
    }
  }

  Map<String, String> toFields() {
    final fields = {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'status': status,
      'themeColor': themeColor,
      'workingHours': jsonEncode(workingHours),
    };

    // Adicionar configuração de comissão se existir
    if (commissionConfig != null) {
      fields['commissionConfig'] = jsonEncode(commissionConfig!.toJson());
    }

    return fields;
  }

  Map<String, File> toFiles() {
    if (profileImage != null) {
      return {'profileImage': profileImage!};
    }
    return {};
  }
}

class CommissionConfigModel {
  final String type; // PERCENTAGE, FIXED_VALUE, TIERED, HYBRID
  final double? percentage;
  final double? fixedAmount;
  final List<CommissionTierModel>? tiers;
  final bool isActive;

  CommissionConfigModel({
    required this.type,
    this.percentage,
    this.fixedAmount,
    this.tiers,
    required this.isActive,
  });

  factory CommissionConfigModel.fromJson(Map<String, dynamic> json) {
    return CommissionConfigModel(
      type: json['type'] ?? '',
      percentage: json['percentage']?.toDouble(),
      fixedAmount: json['fixedAmount']?.toDouble(),
      tiers: (json['tiers'] as List<dynamic>?)
          ?.map((e) => CommissionTierModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (percentage != null) 'percentage': percentage,
      if (fixedAmount != null) 'fixedAmount': fixedAmount,
      if (tiers != null) 'tiers': tiers!.map((e) => e.toJson()).toList(),
      'isActive': isActive,
    };
  }
}

class CommissionTierModel {
  final double? minAmount;
  final double? maxAmount;
  final double? percentage;
  final double? fixedAmount;

  CommissionTierModel({
    this.minAmount,
    this.maxAmount,
    this.percentage,
    this.fixedAmount,
  });

  factory CommissionTierModel.fromJson(Map<String, dynamic> json) {
    return CommissionTierModel(
      minAmount: json['minAmount']?.toDouble(),
      maxAmount: json['maxAmount']?.toDouble(),
      percentage: json['percentage']?.toDouble(),
      fixedAmount: json['fixedAmount']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (minAmount != null) 'minAmount': minAmount,
      if (maxAmount != null) 'maxAmount': maxAmount,
      if (percentage != null) 'percentage': percentage,
      if (fixedAmount != null) 'fixedAmount': fixedAmount,
    };
  }
}
