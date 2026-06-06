import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Transaction {
  final String title;
  final String category;
  final double amount;
  final bool isIncome;
  final DateTime date;
  final String iconPath;

  Transaction({
    required this.title,
    required this.category,
    required this.amount,
    required this.isIncome,
    required this.date,
    required this.iconPath,
  });
}

class HomeController extends GetxController {
  final currentTabIndex = 0.obs; // 0=Home,1=Target,2=Riwayat,3=Profil
  final activeTransactionTab = 0.obs; // 0=Pemasukan, 1=Pengeluaran
  final totalBalance = 0.0.obs;
  final transactions = <Transaction>[].obs;
  final isBalanceVisible = true.obs;

  double get totalIncome =>
      transactions.where((t) => t.isIncome).fold(0, (s, t) => s + t.amount);
  double get totalExpense =>
      transactions.where((t) => !t.isIncome).fold(0, (s, t) => s + t.amount);

  List<Transaction> get filteredTransactions {
    if (activeTransactionTab.value == 0) {
      return transactions.where((t) => t.isIncome).toList();
    }
    return transactions.where((t) => !t.isIncome).toList();
  }

  void toggleBalanceVisibility() {
    isBalanceVisible.value = !isBalanceVisible.value;
  }

  void switchTab(int index) {
    currentTabIndex.value = index;
  }

  void switchTransactionTab(int index) {
    activeTransactionTab.value = index;
  }

  void addTransaction(Transaction t) {
    transactions.insert(0, t);
    if (t.isIncome) {
      totalBalance.value += t.amount;
    } else {
      totalBalance.value -= t.amount;
    }
  }

  String formatRupiah(double amount) {
    final abs = amount.abs();
    if (abs >= 1000000000) {
      return 'Rp ${(abs / 1000000000).toStringAsFixed(1)}M';
    } else if (abs >= 1000000) {
      return 'Rp ${(abs / 1000000).toStringAsFixed(1)}Jt';
    } else if (abs >= 1000) {
      return 'Rp ${abs.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
    }
    return 'Rp ${abs.toStringAsFixed(0)}';
  }
}
