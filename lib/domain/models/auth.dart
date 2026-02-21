class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

class TokenResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final DateTime expiresAt;

  TokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.expiresAt,
  });

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      tokenType: json['token_type'] as String? ?? 'bearer',
      expiresIn: json['expires_in'] as int,
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
      'expires_at': expiresAt.toIso8601String(),
    };
  }
}

class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() {
    return {'refresh_token': refreshToken};
  }
}

class TokenValidationResponse {
  final bool valid;
  final String? email;
  final DateTime? expiresAt;

  TokenValidationResponse({required this.valid, this.email, this.expiresAt});

  factory TokenValidationResponse.fromJson(Map<String, dynamic> json) {
    return TokenValidationResponse(
      valid: json['valid'] as bool,
      email: json['email'] as String?,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'valid': valid,
      'email': email,
      'expires_at': expiresAt?.toIso8601String(),
    };
  }
}
