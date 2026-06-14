import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasource/category_local_datasource.dart';
import 'category_event.dart';
import 'category_state.dart';

/// Ini versi "terjemahan" dari CategoryBloc di referensimu, baris per baris:
///
/// REFERENSI (pakai freezed + dartz):
/// ```dart
/// class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
///   final CategoryRemoteDatasource categoryRemoteDatasource;
///
///   CategoryBloc(this.categoryRemoteDatasource) : super(_Initial()) {
///     on<_Fetch>((event, emit) async {
///       emit(_Loading());
///       final response = await categoryRemoteDatasource.getCategories();
///       response.fold(
///         (error) => emit(_Error(error)),
///         (data) => emit(_Success(data.data ?? [])),
///       );
///     });
///   }
/// }
/// ```
///
/// VERSI INI (pakai equatable + try-catch):
/// - `_Initial()`        → `CategoryInitial()`
/// - `_Loading()`         → `CategoryLoading()`
/// - `response.fold(...)` → `try { ... success } catch { ... error }`
///   (fold itu cuma "cara lain" nulis try-catch, biar ga pakai exception.
///    Tujuannya sama: handle 2 kemungkinan hasil — sukses atau gagal.)
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryLocalDatasource categoryLocalDatasource;

  CategoryBloc(this.categoryLocalDatasource) : super(const CategoryInitial()) {
    on<FetchCategories>((event, emit) async {
      emit(const CategoryLoading());

      try {
        final data = await categoryLocalDatasource.getCategories(type: event.type);
        emit(CategorySuccess(data));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });
  }
}
