import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';

class KategoriPengeluaran {
  final String label;
  final IconData icon;
  KategoriPengeluaran({required this.label, required this.icon});
}

class PengeluaranController extends GetxController {
  final amountController = TextEditingController(text: '0');
  final catatanController = TextEditingController();

  final selectedCategory = ''.obs;
  final selectedAsalDana = 'Dana'.obs; // 'Dana' or 'Cash'
  final selectedDate = Rxn<DateTime>();
  final isPengeluaranRutin = false.obs;
  final isLoading = false.obs;

  // Rutin
  final selectedFrekuensi = 'Harian'.obs;
  final batasBulanController = TextEditingController();
  final isNotifikasiAktif = true.obs;
  final rutinSelectedDate = Rxn<DateTime>();

  final List<String> frekuensiOptions = ['Harian', 'Mingguan', 'Bulanan', 'Tahunan'];

  final List<KategoriPengeluaran> categories = [
    KategoriPengeluaran(label: 'Makan & Minum', icon: Icons.restaurant_outlined),
    KategoriPengeluaran(label: 'Sewa', icon: Icons.home_outlined),
    KategoriPengeluaran(label: 'Transportasi', icon: Icons.directions_car_outlined),
    KategoriPengeluaran(label: 'Skincare', icon: Icons.spa_outlined),
    KategoriPengeluaran(label: 'Kesehatan', icon: Icons.medical_services_outlined),
    KategoriPengeluaran(label: 'Hiburan', icon: Icons.movie_outlined),
    KategoriPengeluaran(label: 'Tagihan', icon: Icons.receipt_outlined),
    KategoriPengeluaran(label: 'Jajan', icon: Icons.fastfood_outlined),
    KategoriPengeluaran(label: 'Keluarga', icon: Icons.family_restroom_outlined),
  ];

  void selectCategory(String cat) => selectedCategory.value = cat;
  void selectAsalDana(String val) => selectedAsalDana.value = val;
  void toggleRutin(bool val) => isPengeluaranRutin.value = val;
  void toggleNotifikasi(bool val) => isNotifikasiAktif.value = val;
  void selectFrekuensi(String val) => selectedFrekuensi.value = val;

  void showCalendarPicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF1A6BFF),
              onPrimary: Colors.white),
        ),
        child: child!,
      ),
    );
    if (picked != null) selectedDate.value = picked;
  }

  void showRutinSheet(BuildContext context) {
    Get.bottomSheet(
      _PengeluaranRutinSheet(controller: this),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> simpan() async {
    if (selectedCategory.value.isEmpty) {
      Get.snackbar('Oops', 'Pilih kategori terlebih dahulu',
          snackPosition: SnackPosition.TOP);
      return;
    }
    final amount = double.tryParse(
        amountController.text.replaceAll('.', '').replaceAll(',', '')) ?? 0;
    if (amount <= 0) {
      Get.snackbar('Oops', 'Masukkan jumlah dana',
          snackPosition: SnackPosition.TOP);
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    isLoading.value = false;

    if (Get.isRegistered<HomeController>()) {
      final homeCtrl = Get.find<HomeController>();
      homeCtrl.addTransaction(Transaction(
        title: catatanController.text.isEmpty
            ? selectedCategory.value
            : catatanController.text,
        category: selectedCategory.value,
        amount: amount,
        isIncome: false,
        date: selectedDate.value ?? DateTime.now(),
        source: selectedAsalDana.value,
      ));
    }

    Get.back();
    Get.snackbar(
      'Berhasil! ✅',
      'Pengeluaran berhasil dicatat',
      backgroundColor: const Color(0xFF1A6BFF),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  void onClose() {
    amountController.dispose();
    catatanController.dispose();
    batasBulanController.dispose();
    super.onClose();
  }
}

// ─── Pengeluaran Rutin Bottom Sheet ──────────────────────────────────────────

class _PengeluaranRutinSheet extends StatelessWidget {
  final PengeluaranController controller;
  const _PengeluaranRutinSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
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
              const Text('Pengeluaran Rutin',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1F36), fontFamily: 'Poppins')),
              GestureDetector(
                onTap: Get.back,
                child: Container(
                  width: 32, height: 32,
                  decoration: const BoxDecoration(
                      color: Color(0xFFF5F7FF), shape: BoxShape.circle),
                  child: const Icon(Icons.close, size: 16, color: Color(0xFF1A1F36)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Frekuensi Waktu',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1F36), fontFamily: 'Poppins')),
          const SizedBox(height: 10),
          Obx(() => Row(
                children: controller.frekuensiOptions.map((f) {
                  final isSel = controller.selectedFrekuensi.value == f;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => controller.selectFrekuensi(f),
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSel ? const Color(0xFF1A6BFF) : const Color(0xFFF5F7FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(f,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isSel ? Colors.white : const Color(0xFF8F95B2),
                                fontFamily: 'Poppins')),
                      ),
                    ),
                  );
                }).toList(),
              )),
          const SizedBox(height: 16),
          const Text('Batas untuk Bulan',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1F36), fontFamily: 'Poppins')),
          const SizedBox(height: 8),
          Obx(() => GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: controller.rutinSelectedDate.value ?? DateTime.now(),
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2030),
                    builder: (ctx, child) => Theme(
                      data: Theme.of(ctx).copyWith(
                        colorScheme: const ColorScheme.light(primary: Color(0xFF1A6BFF)),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) controller.rutinSelectedDate.value = picked;
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
                        controller.rutinSelectedDate.value == null
                            ? 'Tanggal'
                            : '${controller.rutinSelectedDate.value!.day}/${controller.rutinSelectedDate.value!.month}/${controller.rutinSelectedDate.value!.year}',
                        style: TextStyle(fontSize: 14, fontFamily: 'Poppins',
                            color: controller.rutinSelectedDate.value == null
                                ? const Color(0xFF8F95B2) : const Color(0xFF1A1F36)),
                      ),
                      const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF8F95B2)),
                    ],
                  ),
                ),
              )),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9FC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE4E9F2)),
            ),
            child: Obx(() => Row(
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A6BFF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.notifications_outlined,
                          size: 18, color: Color(0xFF1A6BFF)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Aktifkan Notifikasi',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1F36), fontFamily: 'Poppins')),
                          Text('Kirim peringatan 1hari sebelum',
                              style: TextStyle(fontSize: 11, color: Color(0xFF8F95B2), fontFamily: 'Poppins')),
                        ],
                      ),
                    ),
                    Switch(
                      value: controller.isNotifikasiAktif.value,
                      onChanged: controller.toggleNotifikasi,
                      activeColor: const Color(0xFF1A6BFF),
                    ),
                  ],
                )),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: Get.back,
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
}
