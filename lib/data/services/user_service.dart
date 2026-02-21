import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/user.dart';

class UserService {
  final String baseUrl;
  final String apiKey;
  final http.Client httpClient;
  String? _accessToken;

  UserService({
    required this.baseUrl,
    required this.apiKey,
    http.Client? httpClient,
    String? accessToken,
  }) : httpClient = httpClient ?? http.Client(),
       _accessToken = accessToken;

  void setAccessToken(String? token) {
    _accessToken = token;
  }

  Map<String, String> _getHeaders({bool requireAuth = true}) {
    final headers = {'Content-Type': 'application/json', 'x-api-key': apiKey};

    if (requireAuth && _accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }

    return headers;
  }

  Future<UserResponse> registerUser(UserCreate userData) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/users/register'),
        headers: _getHeaders(requireAuth: false),
        body: jsonEncode(userData.toJson()),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return UserResponse.fromJson(data);
      } else if (response.statusCode == 422) {
        throw ValidationException(response.body);
      } else if (response.statusCode == 409) {
        throw UserAlreadyExistsException('Email já cadastrado');
      } else {
        throw Exception('Erro ao registrar usuário: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserResponse>> getAllUsers({
    int skip = 0,
    int limit = 100,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/users/').replace(
        queryParameters: {'skip': skip.toString(), 'limit': limit.toString()},
      );

      final response = await httpClient.get(uri, headers: _getHeaders());

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => UserResponse.fromJson(item as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 422) {
        throw ValidationException(response.body);
      } else if (response.statusCode == 401) {
        throw AuthenticationException('Token inválido ou expirado');
      } else {
        throw Exception('Erro ao buscar usuários: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserResponse> getUserById(String userId) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/users/$userId'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return UserResponse.fromJson(data);
      } else if (response.statusCode == 404) {
        throw UserNotFoundException('Usuário não encontrado');
      } else if (response.statusCode == 422) {
        throw ValidationException(response.body);
      } else if (response.statusCode == 401) {
        throw AuthenticationException('Token inválido ou expirado');
      } else {
        throw Exception('Erro ao buscar usuário: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserResponse> getUserByEmail(String email) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/users/email/$email'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return UserResponse.fromJson(data);
      } else if (response.statusCode == 404) {
        throw UserNotFoundException('Usuário não encontrado');
      } else if (response.statusCode == 422) {
        throw ValidationException(response.body);
      } else if (response.statusCode == 401) {
        throw AuthenticationException('Token inválido ou expirado');
      } else {
        throw Exception(
          'Erro ao buscar usuário por email: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserResponse> updateUser(String userId, UserUpdate userData) async {
    try {
      final response = await httpClient.put(
        Uri.parse('$baseUrl/users/$userId'),
        headers: _getHeaders(),
        body: jsonEncode(userData.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return UserResponse.fromJson(data);
      } else if (response.statusCode == 404) {
        throw UserNotFoundException('Usuário não encontrado');
      } else if (response.statusCode == 409) {
        throw UserAlreadyExistsException('Email já cadastrado');
      } else if (response.statusCode == 422) {
        throw ValidationException(response.body);
      } else if (response.statusCode == 401) {
        throw AuthenticationException('Token inválido ou expirado');
      } else {
        throw Exception('Erro ao atualizar usuário: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      final response = await httpClient.delete(
        Uri.parse('$baseUrl/users/$userId'),
        headers: _getHeaders(),
      );

      if (response.statusCode != 204) {
        if (response.statusCode == 404) {
          throw UserNotFoundException('Usuário não encontrado');
        } else if (response.statusCode == 422) {
          throw ValidationException(response.body);
        } else if (response.statusCode == 401) {
          throw AuthenticationException('Token inválido ou expirado');
        } else {
          throw Exception('Erro ao deletar usuário: ${response.statusCode}');
        }
      }
    } catch (e) {
      rethrow;
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

class UserNotFoundException implements Exception {
  final String message;

  UserNotFoundException(this.message);

  @override
  String toString() => 'UserNotFoundException: $message';
}

class UserAlreadyExistsException implements Exception {
  final String message;

  UserAlreadyExistsException(this.message);

  @override
  String toString() => 'UserAlreadyExistsException: $message';
}
