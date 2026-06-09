import 'package:get/get.dart';
import 'home_controller.dart';

export 'home_controller.dart' show Transaction;

enum RiwayatFilter { semua, pemasukan, pengeluaran }

class RiwayatController extends GetxController {
  final searchQuery = ''.obs;
  final activeFilter = RiwayatFilter.semua.obs;

  HomeController get _home => Get.find<HomeController>();

  List<Transaction> get filteredTransactions {
    var list = _home.transactions.toList();

    // Filter by type
    switch (activeFilter.value) {
      case RiwayatFilter.pemasukan:
        list = list.where((t) => t.isIncome).toList();
        break;
      case RiwayatFilter.pengeluaran:
        list = list.where((t) => !t.isIncome).toList();
        break;
      case RiwayatFilter.semua:
        break;
    }

    // Filter by search
    final q = searchQuery.value.toLowerCase().trim();
    if (q.isNotEmpty) {
      list = list.where((t) =>
          t.title.toLowerCase().contains(q) ||
          t.category.toLowerCase().contains(q) ||
          t.note.toLowerCase().contains(q) ||
          t.source.toLowerCase().contains(q)).toList();
    }

    return list;
  }

  void setFilter(RiwayatFilter f) => activeFilter.value = f;
  void setSearch(String q) => searchQuery.value = q;

  String formatRupiah(double amount) {
    final str = amount.abs().toStringAsFixed(0);
    final buf = StringBuffer();
    int c = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (c > 0 && c % 3 == 0) buf.write('.');
      buf.write(str[i]); c++;
    }
    return 'Rp ${buf.toString().split('').reversed.join('')}';
  }

  String formatDateTime(DateTime dt) {
    final months = ['Jan','Feb','Mar','Apr','Mei','Jun',
                    'Jul','Agu','Sep','Okt','Nov','Des'];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year} • $h:$m WIB';
  }

  String formatDateShort(DateTime dt) {
    final months = ['Jan','Feb','Mar','Apr','Mei','Jun',
                    'Jul','Agu','Sep','Okt','Nov','Des'];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  String formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m WIB';
  }

  // Group transactions by date (for section headers)
  Map<String, List<Transaction>> get groupedTransactions {
    final grouped = <String, List<Transaction>>{};
    for (final t in filteredTransactions) {
      final key = formatDateShort(t.date);
      grouped.putIfAbsent(key, () => []).add(t);
    }
    return grouped;
  }
}
