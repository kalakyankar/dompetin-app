import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Transaction {
  final String id;
  final String title;
  final String category;
  final double amount;
  final bool isIncome;
  final DateTime date;
  final String source; // 'Dana', 'Cash', 'Bank', dll
  final String note;   // catatan / nama instansi

  Transaction({
    String? id,
    required this.title,
    required this.category,
    required this.amount,
    required this.isIncome,
    required this.date,
    this.source = '',
    this.note = '',
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
}

class HomeController extends GetxController {
  final currentTabIndex = 0.obs;
  final activeTransactionTab = 0.obs; // 0=Pemasukan, 1=Pengeluaran
  final totalBalance = 0.0.obs;
  final transactions = <Transaction>[].obs;
  final isBalanceVisible = true.obs;

  // Batas peringatan pengeluaran
  final batasPengeluaran = 0.0.obs;
  final isBatasAktif = false.obs;
  final isWarningDismissed = false.obs;

  double get totalIncome =>
      transactions.where((t) => t.isIncome).fold(0.0, (s, t) => s + t.amount);

  double get totalExpense =>
      transactions.where((t) => !t.isIncome).fold(0.0, (s, t) => s + t.amount);

  bool get isOverBudget =>
      isBatasAktif.value &&
      batasPengeluaran.value > 0 &&
      totalExpense > batasPengeluaran.value;

  double get budgetProgress {
    if (!isBatasAktif.value || batasPengeluaran.value <= 0) return 0;
    return (totalExpense / batasPengeluaran.value).clamp(0.0, 1.0);
  }

  List<Transaction> get recentTransactions => transactions.take(10).toList();

  List<Transaction> get filteredTransactions {
    if (activeTransactionTab.value == 0) {
      return transactions.where((t) => t.isIncome).toList();
    }
    return transactions.where((t) => !t.isIncome).toList();
  }

  void toggleBalanceVisibility() => isBalanceVisible.value = !isBalanceVisible.value;
  void switchTab(int index) => currentTabIndex.value = index;
  void switchTransactionTab(int index) => activeTransactionTab.value = index;

  void setBatasPengeluaran(double amount, bool aktif) {
    batasPengeluaran.value = amount;
    isBatasAktif.value = aktif;
    isWarningDismissed.value = false;
  }

  void dismissWarning() => isWarningDismissed.value = true;

  void addTransaction(Transaction t) {
    transactions.insert(0, t);
    if (t.isIncome) {
      totalBalance.value += t.amount;
    } else {
      totalBalance.value -= t.amount;
    }
    isWarningDismissed.value = false;
  }

  /// Seed realistic dummy data so the app looks filled on first load
  void seedDummyData() {
    if (transactions.isNotEmpty) return; // only once
    final now = DateTime.now();
    final dummies = [
      Transaction(id: 'dummy_1', title: 'Pemasukan', category: 'Gaji',
          amount: 4000000, isIncome: true,
          date: now.subtract(const Duration(days: 5, hours: 17)),
          source: 'Dana', note: 'Dana'),
      Transaction(id: 'dummy_2', title: 'Steak House Buffet', category: 'Makan & Minum',
          amount: 350000, isIncome: false,
          date: now.subtract(const Duration(days: 3, hours: 9, minutes: 40)),
          source: 'Dana', note: 'Steak House Buffet'),
      Transaction(id: 'dummy_3', title: 'Jajan', category: 'Makan & Minum',
          amount: 51000, isIncome: false,
          date: now.subtract(const Duration(days: 1, hours: 8, minutes: 31)),
          source: 'Cash', note: 'Mako - 3 Croissant'),
    ];
    for (final t in dummies) {
      transactions.add(t);
      if (t.isIncome) {
        totalBalance.value += t.amount;
      } else {
        totalBalance.value -= t.amount;
      }
    }
  }

  void showBatasSheet(BuildContext context) {
    Get.bottomSheet(
      _BatasPengeluaranSheet(ctrl: this),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  String formatRupiah(double amount) {
    final abs = amount.abs();
    final str = abs.toStringAsFixed(0);
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
      count++;
    }
    return 'Rp ${buffer.toString().split('').reversed.join('')}';
  }
}

// ─── Batas Pengeluaran Bottom Sheet ──────────────────────────────────────────

class _BatasPengeluaranSheet extends StatefulWidget {
  final HomeController ctrl;
  const _BatasPengeluaranSheet({required this.ctrl});

  @override
  State<_BatasPengeluaranSheet> createState() => _BatasPengeluaranSheetState();
}

class _BatasPengeluaranSheetState extends State<_BatasPengeluaranSheet> {
  final amountController = TextEditingController();
  bool aktifkan = true;
  DateTime? selectedMonth;

  @override
  void initState() {
    super.initState();
    final existing = widget.ctrl.batasPengeluaran.value;
    if (existing > 0) amountController.text = existing.toStringAsFixed(0);
    aktifkan = widget.ctrl.isBatasAktif.value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tetapkan Batas Pengeluaran',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1F36), fontFamily: 'Poppins')),
              GestureDetector(
                onTap: Get.back,
                child: Container(
                  width: 28, height: 28,
                  decoration: const BoxDecoration(
                      color: Color(0xFFF5F7FF), shape: BoxShape.circle),
                  child: const Icon(Icons.close, size: 14, color: Color(0xFF1A1F36)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Batas untuk Bulan
          const Text('Batas untuk Bulan',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1F36), fontFamily: 'Poppins')),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final now = DateTime.now();
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedMonth ?? now,
                firstDate: DateTime(now.year, now.month),
                lastDate: DateTime(now.year + 2),
                builder: (ctx, child) => Theme(
                  data: Theme.of(ctx).copyWith(
                    colorScheme: const ColorScheme.light(primary: Color(0xFF1A6BFF)),
                  ),
                  child: child!,
                ),
              );
              if (picked != null) setState(() => selectedMonth = picked);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F9FC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE4E9F2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedMonth == null
                        ? 'Bulan'
                        : '${selectedMonth!.month}/${selectedMonth!.year}',
                    style: TextStyle(
                      fontSize: 14, fontFamily: 'Poppins',
                      color: selectedMonth == null
                          ? const Color(0xFF8F95B2) : const Color(0xFF1A1F36),
                    ),
                  ),
                  const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF8F95B2)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Batas Dana Maksimal
          const Text('Batas Dana Maksimal',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1F36), fontFamily: 'Poppins')),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Rp ', style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.w700, color: Color(0xFF1A1F36), fontFamily: 'Poppins')),
              Expanded(
                child: TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1F36), fontFamily: 'Poppins'),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                    hintStyle: TextStyle(color: Color(0xFF8F95B2)),
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: Color(0xFF1A6BFF), thickness: 1.5),
          const SizedBox(height: 16),

          // Aktifkan Peringatan
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9FC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE4E9F2)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Aktifkan Peringatan',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1F36), fontFamily: 'Poppins')),
                      SizedBox(height: 2),
                      Text('Beritahu saya sebelum saya melebihi batas anggaran.',
                          style: TextStyle(fontSize: 11, color: Color(0xFF8F95B2), fontFamily: 'Poppins')),
                    ],
                  ),
                ),
                Switch(
                  value: aktifkan,
                  onChanged: (v) => setState(() => aktifkan = v),
                  activeThumbColor: const Color(0xFF1A6BFF),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Simpan
          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(
                  amountController.text.replaceAll('.', '').replaceAll(',', '')) ?? 0;
                widget.ctrl.setBatasPengeluaran(amount, aktifkan);
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A6BFF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Simpan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                      color: Colors.white, fontFamily: 'Poppins')),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }
}

// Extension for insight screen data
extension HomeControllerInsight on HomeController {
  Map<String, double> get incomeByCategory {
    final map = <String, double>{};
    for (final t in transactions.where((t) => t.isIncome)) {
      map[t.category] = (map[t.category] ?? 0) + t.amount;
    }
    return map;
  }

  Map<String, double> get expenseByCategory {
    final map = <String, double>{};
    for (final t in transactions.where((t) => !t.isIncome)) {
      map[t.category] = (map[t.category] ?? 0) + t.amount;
    }
    return map;
  }

  double get savingsRate {
    final total = totalIncome + totalExpense;
    if (total == 0) return 0;
    return ((totalIncome - totalExpense) / totalIncome * 100).clamp(0, 100);
  }
}
