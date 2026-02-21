import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/models/expense.dart';

class ExpenseService {
  final String baseUrl;
  final String apiKey;
  final http.Client httpClient;
  String? _accessToken;

  ExpenseService({
    required this.baseUrl,
    required this.apiKey,
    http.Client? httpClient,
    String? accessToken,
  }) : httpClient = httpClient ?? http.Client(),
       _accessToken = accessToken;

  void setAccessToken(String? token) {
    _accessToken = token;
  }

  Map<String, String> _getHeaders() {
    final headers = {'Content-Type': 'application/json', 'x-api-key': apiKey};

    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }

    return headers;
  }

  Future<ExpenseResponse> createExpense(ExpenseCreate expense) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/expenses'),
        headers: _getHeaders(),
        body: jsonEncode(expense.toJson()),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return ExpenseResponse.fromJson(data);
      } else if (response.statusCode == 422) {
        throw ValidationException(response.body);
      } else {
        throw Exception('Erro ao criar despesa: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ExpenseResponse>> listExpenses(
    String groupId, {
    int skip = 0,
    int limit = 100,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/expenses/$groupId').replace(
        queryParameters: {'skip': skip.toString(), 'limit': limit.toString()},
      );

      final response = await httpClient.get(uri, headers: _getHeaders());

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map(
              (item) => ExpenseResponse.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      } else if (response.statusCode == 422) {
        throw ValidationException(response.body);
      } else {
        throw Exception('Erro ao listar despesas: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ExpenseResponse> getExpenseDetails(String expenseId) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/expenses/$expenseId/details'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return ExpenseResponse.fromJson(data);
      } else if (response.statusCode == 422) {
        throw ValidationException(response.body);
      } else {
        throw Exception(
          'Erro ao obter detalhes da despesa: ${response.statusCode}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ExpenseResponse> updateExpense(
    String expenseId,
    ExpenseUpdate expenseUpdate,
  ) async {
    try {
      final response = await httpClient.patch(
        Uri.parse('$baseUrl/expenses/$expenseId'),
        headers: _getHeaders(),
        body: jsonEncode(expenseUpdate.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return ExpenseResponse.fromJson(data);
      } else if (response.statusCode == 422) {
        throw ValidationException(response.body);
      } else {
        throw Exception('Erro ao atualizar despesa: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteExpense(String expenseId) async {
    try {
      final response = await httpClient.delete(
        Uri.parse('$baseUrl/expenses/$expenseId'),
        headers: _getHeaders(),
      );

      if (response.statusCode != 204) {
        if (response.statusCode == 422) {
          throw ValidationException(response.body);
        } else {
          throw Exception('Erro ao deletar despesa: ${response.statusCode}');
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ExpenseAnalytics>> getExpenseAnalytics(String groupId) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/expenses/$groupId/analytics'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map(
              (item) => ExpenseAnalytics.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      } else if (response.statusCode == 422) {
        throw ValidationException(response.body);
      } else {
        throw Exception('Erro ao obter analytics: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> healthCheck() async {
    try {
      final response = await httpClient
          .get(Uri.parse('$baseUrl/health'))
          .timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

class ValidationException implements Exception {
  final String message;

  ValidationException(this.message);

  @override
  String toString() => 'ValidationException: $message';
}
