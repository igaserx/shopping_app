class UserProfileModel {
  final String email;
  final DateTime? createdAt;

  UserProfileModel({
    required this.email,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      email: map['email'] ?? '',
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : null,
    );
  }

  UserProfileModel copyWith({
    String? email,
    DateTime? createdAt,
  }) {
    return UserProfileModel(
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get initials {
    return email[0].toUpperCase();
  }
}