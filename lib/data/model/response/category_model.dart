import 'package:equatable/equatable.dart';

/// Model kategori transaksi (Pemasukan/Pengeluaran).
/// `iconName` disimpan sebagai String supaya bisa di-serialize (JSON/SharedPreferences),
/// lalu di-mapping ke IconData di sisi UI.
class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String iconName;
  final String type; // 'pemasukan' atau 'pengeluaran'

  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconName,
    required this.type,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      iconName: json['icon_name'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon_name': iconName,
      'type': type,
    };
  }

  @override
  List<Object?> get props => [id, name, iconName, type];
}
