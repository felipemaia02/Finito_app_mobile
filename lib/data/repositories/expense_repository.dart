import '../../domain/models/expense.dart';
import '../services/expense_service.dart';

class ExpenseRepository {
  final ExpenseService _expenseService;

  ExpenseRepository(this._expenseService);

  Future<ExpenseResponse> createExpense({
    required String groupId,
    required int amountCents,
    required ExpenseCategory category,
    required ExpenseType typeExpense,
    required String spentBy,
    DateTime? date,
    String? note,
  }) async {
    final expense = ExpenseCreate(
      groupId: groupId,
      amountCents: amountCents,
      category: category,
      typeExpense: typeExpense,
      spentBy: spentBy,
      date: date,
      note: note,
    );

    return _expenseService.createExpense(expense);
  }

  Future<List<ExpenseResponse>> getExpensesByGroup(
    String groupId, {
    int skip = 0,
    int limit = 100,
  }) async {
    return _expenseService.listExpenses(groupId, skip: skip, limit: limit);
  }

  Future<ExpenseResponse> getExpenseDetails(String expenseId) async {
    return _expenseService.getExpenseDetails(expenseId);
  }

  Future<ExpenseResponse> updateExpense(
    String expenseId, {
    int? amountCents,
    ExpenseCategory? category,
    ExpenseType? typeExpense,
    String? spentBy,
    DateTime? date,
    String? note,
  }) async {
    final expenseUpdate = ExpenseUpdate(
      amountCents: amountCents,
      category: category,
      typeExpense: typeExpense,
      spentBy: spentBy,
      date: date,
      note: note,
    );

    return _expenseService.updateExpense(expenseId, expenseUpdate);
  }

  Future<void> deleteExpense(String expenseId) async {
    return _expenseService.deleteExpense(expenseId);
  }

  Future<List<ExpenseAnalytics>> getExpenseAnalytics(String groupId) async {
    return _expenseService.getExpenseAnalytics(groupId);
  }

  Future<Map<ExpenseCategory, double>> getTotalByCategory(
    String groupId,
  ) async {
    final expenses = await getExpensesByGroup(groupId);
    final totals = <ExpenseCategory, double>{};

    for (final expense in expenses) {
      if (!expense.isDeleted) {
        totals[expense.category] =
            (totals[expense.category] ?? 0) + expense.amountInReais;
      }
    }

    return totals;
  }

  Future<Map<String, double>> getTotalByPerson(String groupId) async {
    final expenses = await getExpensesByGroup(groupId);
    final totals = <String, double>{};

    for (final expense in expenses) {
      if (!expense.isDeleted) {
        totals[expense.spentBy] =
            (totals[expense.spentBy] ?? 0) + expense.amountInReais;
      }
    }

    return totals;
  }

  Future<double> getTotalExpenses(String groupId) async {
    final expenses = await getExpensesByGroup(groupId);
    double total = 0;

    for (final expense in expenses) {
      if (!expense.isDeleted) {
        total += expense.amountInReais;
      }
    }

    return total;
  }
}
