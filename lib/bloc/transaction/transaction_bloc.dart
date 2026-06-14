import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasource/transaction_local_datasource.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionLocalDatasource transactionLocalDatasource;

  TransactionBloc(this.transactionLocalDatasource)
      : super(const TransactionInitial()) {
    on<FetchTransactions>(_onFetch);
    on<FilterTransactions>(_onFilter);
    on<SearchTransactions>(_onSearch);
    on<AddTransaction>(_onAdd);
  }

  // ── FetchTransactions ─────────────────────────────────────────────────────
  Future<void> _onFetch(
    FetchTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());

    try {
      final data = await transactionLocalDatasource.getTransactions();
      emit(TransactionSuccess(allTransactions: data));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  // ── FilterTransactions ────────────────────────────────────────────────────
  // Tidak perlu hit datasource lagi — cukup ganti `activeFilter` di state yang
  // sudah ada. `filteredTransactions` (getter di TransactionSuccess) otomatis
  // ikut berubah.
  void _onFilter(
    FilterTransactions event,
    Emitter<TransactionState> emit,
  ) {
    final current = state;
    if (current is TransactionSuccess) {
      emit(current.copyWith(activeFilter: event.filter));
    }
  }

  // ── SearchTransactions ────────────────────────────────────────────────────
  void _onSearch(
    SearchTransactions event,
    Emitter<TransactionState> emit,
  ) {
    final current = state;
    if (current is TransactionSuccess) {
      emit(current.copyWith(searchQuery: event.query));
    }
  }

  // ── AddTransaction ────────────────────────────────────────────────────────
  // Dipanggil dari halaman Pemasukan / Pengeluaran / Scan Struk setelah
  // user menekan "Simpan".
  Future<void> _onAdd(
    AddTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    final current = state;
    if (current is! TransactionSuccess) return;

    try {
      await transactionLocalDatasource.addTransaction(event.transaction);
      final updated = [event.transaction, ...current.allTransactions];
      emit(current.copyWith(allTransactions: updated));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }
}
