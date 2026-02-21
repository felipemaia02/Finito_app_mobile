class UserCreate {
  final String name;
  final String email;
  final String password;
  final DateTime dateBirth;

  UserCreate({
    required this.name,
    required this.email,
    required this.password,
    required this.dateBirth,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'date_birth': dateBirth.toIso8601String().split('T')[0],
    };
  }
}

class UserUpdate {
  final String? name;
  final String? email;
  final DateTime? dateBirth;

  UserUpdate({this.name, this.email, this.dateBirth});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    if (dateBirth != null) {
      data['date_birth'] = dateBirth!.toIso8601String().split('T')[0];
    }

    return data;
  }
}

class UserResponse {
  final String id;
  final String name;
  final String email;
  final DateTime dateBirth;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.dateBirth,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      dateBirth: DateTime.parse(json['date_birth'] as String),
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'date_birth': dateBirth.toIso8601String().split('T')[0],
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
