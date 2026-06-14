import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/response/transaction_model.dart';

/// Datasource transaksi — baca/tulis ke SharedPreferences (local storage).
///
/// Sama seperti CategoryLocalDatasource, kalau nanti Dompetin punya backend,
/// cukup ganti isi method-method ini jadi http call. Bloc & UI tidak berubah.
class TransactionLocalDatasource {
  static const _storageKey = 'dompetin_transactions';

  Future<List<TransactionModel>> getTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);

    if (raw == null) {
      // Belum ada data tersimpan → kembalikan dummy data awal
      final dummy = _dummyData();
      await saveTransactions(dummy);
      return dummy;
    }

    final list = jsonDecode(raw) as List;
    return list
        .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveTransactions(List<TransactionModel> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(transactions.map((t) => t.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    final current = await getTransactions();
    current.insert(0, transaction);
    await saveTransactions(current);
  }

  /// Dummy data — sama seperti `seedDummyData()` di HomeController
  List<TransactionModel> _dummyData() {
    final now = DateTime.now();
    return [
      TransactionModel(
        id: 'dummy_1',
        title: 'Pemasukan',
        category: 'Gaji',
        amount: 4000000,
        isIncome: true,
        date: now.subtract(const Duration(days: 5, hours: 17)),
        source: 'Dana',
        note: 'Dana',
      ),
      TransactionModel(
        id: 'dummy_2',
        title: 'Steak House Buffet',
        category: 'Makan & Minum',
        amount: 350000,
        isIncome: false,
        date: now.subtract(const Duration(days: 3, hours: 9, minutes: 40)),
        source: 'Dana',
        note: 'Steak House Buffet',
      ),
      TransactionModel(
        id: 'dummy_3',
        title: 'Jajan',
        category: 'Makan & Minum',
        amount: 51000,
        isIncome: false,
        date: now.subtract(const Duration(days: 1, hours: 8, minutes: 31)),
        source: 'Cash',
        note: 'Mako - 3 Croissant',
      ),
    ];
  }
}
