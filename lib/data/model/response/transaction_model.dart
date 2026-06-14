import 'package:equatable/equatable.dart';

/// Model transaksi (pemasukan & pengeluaran).
/// Punya `fromJson`/`toJson` karena disimpan di SharedPreferences
/// (lihat TransactionLocalDatasource).
class TransactionModel extends Equatable {
  final String id;
  final String title;
  final String category;
  final double amount;
  final bool isIncome;
  final DateTime date;
  final String source; // 'Dana', 'Cash', 'Bank', dll
  final String note;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.isIncome,
    required this.date,
    this.source = '',
    this.note = '',
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      isIncome: json['is_income'] as bool,
      date: DateTime.parse(json['date'] as String),
      source: json['source'] as String? ?? '',
      note: json['note'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'is_income': isIncome,
      'date': date.toIso8601String(),
      'source': source,
      'note': note,
    };
  }

  @override
  List<Object?> get props => [id, title, category, amount, isIncome, date, source, note];
}
