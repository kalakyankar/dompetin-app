import 'package:equatable/equatable.dart';
import '../../data/model/response/transaction_model.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

/// Kondisi awal, sebelum FetchTransactions dikirim.
class TransactionInitial extends TransactionState {
  const TransactionInitial();
}

/// Sedang mengambil data dari datasource.
class TransactionLoading extends TransactionState {
  const TransactionLoading();
}

/// Data berhasil diambil. Menyimpan SEMUA transaksi + filter/search yang aktif.
///
/// `filteredTransactions` adalah getter (hasil hitungan), bukan disimpan terpisah —
/// jadi setiap kali `allTransactions`, `activeFilter`, atau `searchQuery` berubah,
/// hasil filter otomatis ikut berubah.
class TransactionSuccess extends TransactionState {
  final List<TransactionModel> allTransactions;
  final String activeFilter; // 'semua' | 'pemasukan' | 'pengeluaran'
  final String searchQuery;

  const TransactionSuccess({
    required this.allTransactions,
    this.activeFilter = 'semua',
    this.searchQuery = '',
  });

  List<TransactionModel> get filteredTransactions {
    var list = allTransactions;

    // 1. Filter berdasarkan tipe
    switch (activeFilter) {
      case 'pemasukan':
        list = list.where((t) => t.isIncome).toList();
        break;
      case 'pengeluaran':
        list = list.where((t) => !t.isIncome).toList();
        break;
      default:
        break; // 'semua' → tidak difilter
    }

    // 2. Filter berdasarkan pencarian
    final q = searchQuery.toLowerCase().trim();
    if (q.isNotEmpty) {
      list = list.where((t) =>
          t.title.toLowerCase().contains(q) ||
          t.category.toLowerCase().contains(q) ||
          t.note.toLowerCase().contains(q)).toList();
    }

    return list;
  }

  double get totalIncome =>
      allTransactions.where((t) => t.isIncome).fold(0.0, (s, t) => s + t.amount);

  double get totalExpense =>
      allTransactions.where((t) => !t.isIncome).fold(0.0, (s, t) => s + t.amount);

  double get totalBalance => totalIncome - totalExpense;

  /// Bikin copy state dengan beberapa nilai diganti.
  /// Dipakai supaya tidak perlu re-fetch dari datasource setiap kali
  /// filter/search berubah — cukup ganti nilainya saja.
  TransactionSuccess copyWith({
    List<TransactionModel>? allTransactions,
    String? activeFilter,
    String? searchQuery,
  }) {
    return TransactionSuccess(
      allTransactions: allTransactions ?? this.allTransactions,
      activeFilter: activeFilter ?? this.activeFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [allTransactions, activeFilter, searchQuery];
}

/// Terjadi error saat mengambil/menyimpan data.
class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object?> get props => [message];
}
