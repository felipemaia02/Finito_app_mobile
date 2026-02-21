import 'services/expense_service.dart';
import 'services/auth_service.dart';
import 'services/user_service.dart';
import 'services/storage_service.dart';
import 'services/api_config.dart';
import 'repositories/expense_repository.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();

  late ExpenseService _expenseService;
  late AuthService _authService;
  late UserService _userService;
  late StorageService _storageService;
  late ExpenseRepository _expenseRepository;

  factory ServiceLocator() {
    return _instance;
  }

  ServiceLocator._internal();

  void setupServices() {
    _storageService = StorageService();
    _expenseService = ExpenseService(
      baseUrl: ApiConfig.baseUrl,
      apiKey: ApiConfig.apiKey,
    );
    _authService = AuthService(
      baseUrl: ApiConfig.baseUrl,
      apiKey: ApiConfig.apiKey,
    );
    _userService = UserService(
      baseUrl: ApiConfig.baseUrl,
      apiKey: ApiConfig.apiKey,
    );
    _expenseRepository = ExpenseRepository(_expenseService);
  }

  ExpenseService get expenseService => _expenseService;

  AuthService get authService => _authService;

  UserService get userService => _userService;

  StorageService get storageService => _storageService;

  ExpenseRepository get expenseRepository => _expenseRepository;
}

final serviceLocator = ServiceLocator();
