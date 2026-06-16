import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';

class KategoriItem {
  final String label;
  final IconData icon;
  KategoriItem({required this.label, required this.icon});
}

class PemasukanController extends GetxController {
  final amountController = TextEditingController(text: '0');
  final namaInstansiController = TextEditingController();

  final selectedCategory = ''.obs;
  final selectedSimpan = ''.obs; // 'Bank' or 'E-Wallet'
  final selectedDate = Rxn<DateTime>();
  final isPemasukanRutin = false.obs;
  final isLoading = false.obs;

  // Rutin bottom sheet
  final selectedFrekuensi = 'Harian'.obs;
  final batasBulanController = TextEditingController();
  final isNotifikasiAktif = true.obs;

  final List<String> frekuensiOptions = ['Harian', 'Mingguan', 'Bulanan', 'Tahunan'];

  // Edit mode
  Transaction? _editTarget;
  bool get isEditing => _editTarget != null;

  void setEditTarget(Transaction t) {
    _editTarget = t;
    amountController.text = t.amount.toStringAsFixed(0);
    namaInstansiController.text = t.title == t.category ? '' : t.title;
    selectedCategory.value = t.category;
    selectedSimpan.value = t.source;
    selectedDate.value = t.date;
  }

  void clearEditTarget() {
    _editTarget = null;
  }

  final List<KategoriItem> categories = [
    KategoriItem(label: 'Gaji', icon: Icons.account_balance_wallet_outlined),
    KategoriItem(label: 'Bonus', icon: Icons.card_giftcard_outlined),
    KategoriItem(label: 'Bisnis', icon: Icons.storefront_outlined),
    KategoriItem(label: 'Freelance', icon: Icons.laptop_outlined),
    KategoriItem(label: 'Hadiah', icon: Icons.redeem_outlined),
    KategoriItem(label: 'Investasi', icon: Icons.trending_up_outlined),
  ];

  void selectCategory(String cat) => selectedCategory.value = cat;
  void selectSimpan(String val) => selectedSimpan.value = val;
  void toggleRutin(bool val) => isPemasukanRutin.value = val;
  void toggleNotifikasi(bool val) => isNotifikasiAktif.value = val;
  void selectFrekuensi(String val) => selectedFrekuensi.value = val;

  void showCalendarPicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF1A6BFF),
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) selectedDate.value = picked;
  }

  void showRutinSheet(BuildContext context) {
    Get.bottomSheet(
      _PemasukanRutinSheet(controller: this),
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
            amountController.text.replaceAll('.', '').replaceAll(',', '')) ??
        0;
    if (amount <= 0) {
      Get.snackbar('Oops', 'Masukkan jumlah dana',
          snackPosition: SnackPosition.TOP);
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;

    final homeCtrl = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;
    final t = Transaction(
      title: namaInstansiController.text.isEmpty
          ? selectedCategory.value
          : namaInstansiController.text,
      category: selectedCategory.value,
      amount: amount,
      isIncome: true,
      date: selectedDate.value ?? DateTime.now(),
      source: selectedSimpan.value,
    );

    if (isEditing) {
      homeCtrl?.updateTransaction(_editTarget!, t);
      clearEditTarget();
    } else {
      homeCtrl?.addTransaction(t);
    }

    Get.back();
    Get.delete<PemasukanController>();
    Get.snackbar(
      'Berhasil! ✅',
      'Dana masuk berhasil dicatat',
      backgroundColor: const Color(0xFF1A6BFF),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  void onClose() {
    clearEditTarget();
    amountController.dispose();
    namaInstansiController.dispose();
    batasBulanController.dispose();
    super.onClose();
  }
}

// ─── Pemasukan Rutin Bottom Sheet ────────────────────────────────────────────

class _PemasukanRutinSheet extends StatelessWidget {
  final PemasukanController controller;
  const _PemasukanRutinSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: SingleChildScrollView(
        child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Pemasukan Rutin',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1F36),

                ),
              ),
              GestureDetector(
                onTap: Get.back,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 16, color: Color(0xFF1A1F36)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Frekuensi Waktu
          const Text('Frekuensi Waktu',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1F36))),
          const SizedBox(height: 10),
          Obx(() => Row(
                children: controller.frekuensiOptions.map((f) {
                  final isSelected = controller.selectedFrekuensi.value == f;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => controller.selectFrekuensi(f),
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF1A6BFF)
                              : const Color(0xFFF5F7FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          f,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : const Color(0xFF8F95B2),
          
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
          const SizedBox(height: 16),

          // Batas untuk Bulan
          const Text('Batas untuk Bulan',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1F36))),
          const SizedBox(height: 8),
          TextField(
            controller: controller.batasBulanController,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Tanggal',
              hintStyle: const TextStyle(color: Color(0xFF8F95B2), fontSize: 14),
              filled: true,
              fillColor: const Color(0xFFF7F9FC),
              suffixIcon:
                  const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF8F95B2)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE4E9F2))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE4E9F2))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF1A6BFF), width: 1.5)),
            ),
          ),
          const SizedBox(height: 16),

          // Aktifkan Notifikasi
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
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A6BFF).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.notifications_outlined,
                          size: 18, color: Color(0xFF1A6BFF)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Aktifkan Notifikasi',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1A1F36))),
                          const Text('Kirim peringatan 1hari sebelum',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF8F95B2))),
                        ],
                      ),
                    ),
                    Switch(
                      value: controller.isNotifikasiAktif.value,
                      onChanged: controller.toggleNotifikasi,
                      activeThumbColor: const Color(0xFF1A6BFF),
                    ),
                  ],
                )),
          ),
          const SizedBox(height: 24),

          // Simpan button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: Get.back,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A6BFF),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Simpan',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
