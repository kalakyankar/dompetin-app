import 'package:equatable/equatable.dart';
import '../../data/model/response/category_model.dart';

/// STATE = "kondisi UI saat ini" yang di-emit oleh Bloc.
/// Di referensimu ditulis pakai freezed:
///
///   sealed class CategoryState {
///     const factory CategoryState.initial() = _Initial;
///     const factory CategoryState.loading() = _Loading;
///     const factory CategoryState.success(List<CategoryResponseModel> data) = _Success;
///     const factory CategoryState.error(String message) = _Error;
///   }
///
/// Di sini, 4 kondisi yang sama kita tulis sebagai 4 class terpisah.
/// UI nanti cek "lagi di state mana?" pakai `if (state is CategoryLoading) ...`
/// atau pakai BlocBuilder (lihat PENJELASAN_BLOC.md).
abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

/// Setara `_Initial()` — kondisi awal sebelum bloc melakukan apa-apa.
class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

/// Setara `_Loading()` — sedang mengambil data.
class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

/// Setara `_Success(data)` — data berhasil diambil.
class CategorySuccess extends CategoryState {
  final List<CategoryModel> categories;

  const CategorySuccess(this.categories);

  @override
  List<Object?> get props => [categories];
}

/// Setara `_Error(error)` — terjadi kesalahan.
class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}
