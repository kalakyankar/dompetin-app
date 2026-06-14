import 'package:equatable/equatable.dart';
import '../../data/model/response/transaction_model.dart';

/// 4 jenis "aksi" yang bisa dikirim UI ke TransactionBloc.
/// Setiap kali user melakukan sesuatu (buka halaman, tap filter, ketik di search,
/// simpan transaksi baru), UI mengirim salah satu event ini lewat:
///
///   context.read<TransactionBloc>().add(FetchTransactions());
abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

/// Dikirim saat halaman Riwayat dibuka pertama kali.
class FetchTransactions extends TransactionEvent {
  const FetchTransactions();
}

/// Dikirim saat user pilih chip "Semua" / "Pemasukan" / "Pengeluaran".
class FilterTransactions extends TransactionEvent {
  final String filter; // 'semua' | 'pemasukan' | 'pengeluaran'

  const FilterTransactions(this.filter);

  @override
  List<Object?> get props => [filter];
}

/// Dikirim setiap kali user mengetik di search bar.
class SearchTransactions extends TransactionEvent {
  final String query;

  const SearchTransactions(this.query);

  @override
  List<Object?> get props => [query];
}

/// Dikirim saat user menyimpan transaksi baru (dari Pemasukan/Pengeluaran/Scan).
class AddTransaction extends TransactionEvent {
  final TransactionModel transaction;

  const AddTransaction(this.transaction);

  @override
  List<Object?> get props => [transaction];
}
