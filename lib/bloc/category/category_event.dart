import 'package:equatable/equatable.dart';

/// EVENT = "aksi" yang dikirim dari UI ke Bloc.
/// Di referensimu, event ditulis pakai `freezed` dengan sintaks:
///
///   sealed class CategoryEvent { const factory CategoryEvent.fetch() = _Fetch; }
///
/// Di sini kita tulis manual pakai class biasa + Equatable.
/// Hasilnya SAMA: setiap "jenis aksi" jadi satu class turunan dari CategoryEvent.
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

/// Setara dengan `_Fetch` di referensimu.
/// Dikirim saat UI butuh ambil daftar kategori.
///
/// `type` opsional: 'pemasukan' / 'pengeluaran' / null (= semua).
class FetchCategories extends CategoryEvent {
  final String? type;

  const FetchCategories({this.type});

  @override
  List<Object?> get props => [type];
}
