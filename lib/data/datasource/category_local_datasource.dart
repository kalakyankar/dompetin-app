import '../model/response/category_model.dart';

/// Datasource untuk kategori transaksi.
///
/// Di referensimu ini namanya "CategoryRemoteDatasource" karena ambil data dari API.
/// Di Dompetin, kategori masih berupa data lokal (belum ada backend), jadi
/// kita pakai "LocalDatasource". Kalau nanti Dompetin punya API,
/// cukup ganti isi method `getCategories()` ini jadi http call —
/// Bloc & UI di atasnya TIDAK PERLU diubah sama sekali. Itu inti dari BLoC pattern:
/// memisahkan "dari mana data berasal" dari "bagaimana data dipakai di UI".
class CategoryLocalDatasource {
  Future<List<CategoryModel>> getCategories({String? type}) async {
    // Simulasi delay network/database
    await Future.delayed(const Duration(milliseconds: 300));

    final all = _defaultCategories();
    if (type == null) return all;
    return all.where((c) => c.type == type).toList();
  }

  List<CategoryModel> _defaultCategories() => const [
        // ── Kategori Pemasukan ──────────────────────────────────────────────
        CategoryModel(id: 'in_1', name: 'Gaji', iconName: 'account_balance_wallet_outlined', type: 'pemasukan'),
        CategoryModel(id: 'in_2', name: 'Bonus', iconName: 'card_giftcard_outlined', type: 'pemasukan'),
        CategoryModel(id: 'in_3', name: 'Bisnis', iconName: 'storefront_outlined', type: 'pemasukan'),
        CategoryModel(id: 'in_4', name: 'Freelance', iconName: 'laptop_outlined', type: 'pemasukan'),
        CategoryModel(id: 'in_5', name: 'Hadiah', iconName: 'redeem_outlined', type: 'pemasukan'),
        CategoryModel(id: 'in_6', name: 'Investasi', iconName: 'trending_up_outlined', type: 'pemasukan'),

        // ── Kategori Pengeluaran ────────────────────────────────────────────
        CategoryModel(id: 'out_1', name: 'Makan & Minum', iconName: 'restaurant_outlined', type: 'pengeluaran'),
        CategoryModel(id: 'out_2', name: 'Sewa', iconName: 'home_outlined', type: 'pengeluaran'),
        CategoryModel(id: 'out_3', name: 'Transportasi', iconName: 'directions_car_outlined', type: 'pengeluaran'),
        CategoryModel(id: 'out_4', name: 'Skincare', iconName: 'spa_outlined', type: 'pengeluaran'),
        CategoryModel(id: 'out_5', name: 'Kesehatan', iconName: 'medical_services_outlined', type: 'pengeluaran'),
        CategoryModel(id: 'out_6', name: 'Hiburan', iconName: 'movie_outlined', type: 'pengeluaran'),
        CategoryModel(id: 'out_7', name: 'Tagihan', iconName: 'receipt_outlined', type: 'pengeluaran'),
        CategoryModel(id: 'out_8', name: 'Jajan', iconName: 'fastfood_outlined', type: 'pengeluaran'),
        CategoryModel(id: 'out_9', name: 'Keluarga', iconName: 'family_restroom_outlined', type: 'pengeluaran'),
      ];
}
