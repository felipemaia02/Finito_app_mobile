enum ExpenseCategory {
  transportation('transportation'),
  entertainment('entertainment'),
  utilities('utilities'),
  healthcare('healthcare'),
  education('education'),
  shopping('shopping'),
  subscriptions('subscriptions'),
  personalCare('personal_care'),
  home('home'),
  bills('bills'),
  work('work'),
  gifts('gifts'),
  insurance('insurance'),
  savings('savings'),
  investments('investments'),
  pet('pet'),
  groceries('groceries'),
  restaurants('restaurants'),
  gas('gas'),
  car('car'),
  other('other');

  final String value;
  const ExpenseCategory(this.value);

  static ExpenseCategory fromString(String value) {
    return ExpenseCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ExpenseCategory.other,
    );
  }

  @override
  String toString() => value;
}

enum ExpenseType {
  creditCard('credit_card'),
  debitCard('debit_card'),
  pixTransfer('pix_transfer'),
  cash('cash');

  final String value;
  const ExpenseType(this.value);

  static ExpenseType fromString(String value) {
    return ExpenseType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ExpenseType.cash,
    );
  }

  @override
  String toString() => value;
}

class ExpenseCreate {
  final String groupId;
  final int amountCents;
  final ExpenseCategory category;
  final ExpenseType typeExpense;
  final String spentBy;
  final DateTime? date;
  final String? note;

  ExpenseCreate({
    required this.groupId,
    required this.amountCents,
    required this.category,
    required this.typeExpense,
    required this.spentBy,
    this.date,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'amount_cents': amountCents,
      'category': category.value,
      'type_expense': typeExpense.value,
      'spent_by': spentBy,
      'date': date?.toIso8601String(),
      'note': note,
    };
  }
}

class ExpenseUpdate {
  final int? amountCents;
  final ExpenseCategory? category;
  final ExpenseType? typeExpense;
  final String? spentBy;
  final DateTime? date;
  final String? note;

  ExpenseUpdate({
    this.amountCents,
    this.category,
    this.typeExpense,
    this.spentBy,
    this.date,
    this.note,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (amountCents != null) json['amount_cents'] = amountCents;
    if (category != null) json['category'] = category!.value;
    if (typeExpense != null) json['type_expense'] = typeExpense!.value;
    if (spentBy != null) json['spent_by'] = spentBy;
    if (date != null) json['date'] = date!.toIso8601String();
    if (note != null) json['note'] = note;
    return json;
  }
}

class ExpenseResponse {
  final String id;
  final String groupId;
  final int amountCents;
  final ExpenseCategory category;
  final ExpenseType typeExpense;
  final String spentBy;
  final DateTime date;
  final String? note;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExpenseResponse({
    required this.id,
    required this.groupId,
    required this.amountCents,
    required this.category,
    required this.typeExpense,
    required this.spentBy,
    required this.date,
    this.note,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExpenseResponse.fromJson(Map<String, dynamic> json) {
    return ExpenseResponse(
      id: json['id'] as String,
      groupId: json['group_id'] as String,
      amountCents: json['amount_cents'] as int,
      category: ExpenseCategory.fromString(json['category'] as String),
      typeExpense: ExpenseType.fromString(json['type_expense'] as String),
      spentBy: json['spent_by'] as String,
      date: DateTime.parse(json['date'] as String),
      note: json['note'] as String?,
      isDeleted: json['is_deleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'group_id': groupId,
      'amount_cents': amountCents,
      'category': category.value,
      'type_expense': typeExpense.value,
      'spent_by': spentBy,
      'date': date.toIso8601String(),
      'note': note,
      'is_deleted': isDeleted,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  double get amountInReais => amountCents / 100;
}

class ExpenseAnalytics {
  final int amountCents;
  final String typeExpense;

  ExpenseAnalytics({required this.amountCents, required this.typeExpense});

  factory ExpenseAnalytics.fromJson(Map<String, dynamic> json) {
    return ExpenseAnalytics(
      amountCents: json['amount_cents'] as int,
      typeExpense: json['type_expense'] as String? ?? 'other',
    );
  }

  double get amountInReais => amountCents / 100;
}
