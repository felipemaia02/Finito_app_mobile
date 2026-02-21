import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/auth.dart';

class AuthService {
  final String baseUrl;
  final String apiKey;
  final http.Client httpClient;

  AuthService({
    required this.baseUrl,
    required this.apiKey,
    http.Client? httpClient,
  }) : httpClient = httpClient ?? http.Client();

  Map<String, String> _getHeaders({String? accessToken}) {
    final headers = {'Content-Type': 'application/json', 'x-api-key': apiKey};

    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    return headers;
  }

  Future<TokenResponse> login(LoginRequest loginRequest) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _getHeaders(),
        body: jsonEncode(loginRequest.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return TokenResponse.fromJson(data);
      } else if (response.statusCode == 422) {
        final errorMessage = _extractErrorMessage(response.body);
        throw ValidationException(errorMessage);
      } else if (response.statusCode == 401) {
        throw AuthenticationException('Email ou senha incorretos');
      } else {
        throw Exception('Erro ao fazer login: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<TokenResponse> refreshToken(RefreshTokenRequest refreshRequest) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/auth/refresh'),
        headers: _getHeaders(),
        body: jsonEncode(refreshRequest.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return TokenResponse.fromJson(data);
      } else if (response.statusCode == 422) {
        final errorMessage = _extractErrorMessage(response.body);
        throw ValidationException(errorMessage);
      } else if (response.statusCode == 401) {
        throw AuthenticationException('Token de refresh inválido ou expirado');
      } else {
        throw Exception('Erro ao renovar token: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<TokenValidationResponse> validateToken(String accessToken) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/auth/validate'),
        headers: _getHeaders(accessToken: accessToken),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return TokenValidationResponse.fromJson(data);
      } else if (response.statusCode == 422) {
        final errorMessage = _extractErrorMessage(response.body);
        throw ValidationException(errorMessage);
      } else if (response.statusCode == 401) {
        throw AuthenticationException('Token inválido');
      } else {
        throw Exception('Erro ao validar token: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  String _extractErrorMessage(String responseBody) {
    try {
      final json = jsonDecode(responseBody) as Map<String, dynamic>;

      // FastAPI retorna erro em 'detail'
      if (json.containsKey('detail')) {
        final detail = json['detail'];

        // Se detail é uma string, retornar diretamente
        if (detail is String) {
          return detail;
        }

        // Se detail é uma lista (validation errors), extrair mensagens
        if (detail is List && detail.isNotEmpty) {
          final messages = detail
              .map((error) {
                if (error is Map<String, dynamic>) {
                  final field =
                      error['loc'] is List && (error['loc'] as List).length > 1
                      ? error['loc'][1]
                      : '';
                  final msg = error['msg'] ?? 'Erro de validação';
                  return field.isNotEmpty ? '$field: $msg' : msg;
                }
                return error.toString();
              })
              .join('\n');
          return messages;
        }
      }

      // Fallback
      return 'Erro de validação';
    } catch (e) {
      return 'Erro ao processar resposta do servidor';
    }
  }
}

class ValidationException implements Exception {
  final String message;

  ValidationException(this.message);

  @override
  String toString() => 'ValidationException: $message';
}

class AuthenticationException implements Exception {
  final String message;

  AuthenticationException(this.message);

  @override
  String toString() => 'AuthenticationException: $message';
}
