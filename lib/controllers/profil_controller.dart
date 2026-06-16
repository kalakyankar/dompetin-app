import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/app_routes.dart';

class ProfilController extends GetxController {
  // ── User data ──────────────────────────────────────────────────────────────
  final nama = 'Bintang Ramadhan'.obs;
  final email = 'Bintangramadhan@gmail.com'.obs;
  final telepon = '+62 819 3354 432'.obs;
  final jenisKelamin = 'Laki-Laki'.obs;

  // ── Edit form controllers ──────────────────────────────────────────────────
  late TextEditingController namaCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController teleponCtrl;

  // ── Notification toggles ───────────────────────────────────────────────────
  final pengingatTarget = true.obs;
  final pengingatPemasukan = true.obs;
  final batasAnggaran = true.obs;
  final laporanMingguan = false.obs;

  // ── Change password ────────────────────────────────────────────────────────
  late TextEditingController kataSandiCtrl;
  late TextEditingController konfirmasiCtrl;
  final isKataSandiVisible = false.obs;
  final isKonfirmasiVisible = false.obs;
  final isSavingPassword = false.obs;

  @override
  void onInit() {
    super.onInit();
    namaCtrl = TextEditingController(text: nama.value);
    emailCtrl = TextEditingController(text: email.value);
    teleponCtrl = TextEditingController(text: telepon.value);
    kataSandiCtrl = TextEditingController();
    konfirmasiCtrl = TextEditingController();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    nama.value = prefs.getString('nama') ?? nama.value;
    email.value = prefs.getString('email') ?? email.value;
    telepon.value = prefs.getString('telepon') ?? telepon.value;
    jenisKelamin.value = prefs.getString('jenisKelamin') ?? jenisKelamin.value;
    pengingatTarget.value = prefs.getBool('pengingatTarget') ?? true;
    pengingatPemasukan.value = prefs.getBool('pengingatPemasukan') ?? true;
    batasAnggaran.value = prefs.getBool('batasAnggaran') ?? true;
    laporanMingguan.value = prefs.getBool('laporanMingguan') ?? false;
    namaCtrl.text = nama.value;
    emailCtrl.text = email.value;
    teleponCtrl.text = telepon.value;
  }

  Future<void> saveProfilEdit() async {
    if (namaCtrl.text.trim().isEmpty) {
      Get.snackbar('Oops', 'Nama tidak boleh kosong',
          snackPosition: SnackPosition.TOP); return;
    }
    nama.value = namaCtrl.text.trim();
    email.value = emailCtrl.text.trim();
    telepon.value = teleponCtrl.text.trim();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nama', nama.value);
    await prefs.setString('email', email.value);
    await prefs.setString('telepon', telepon.value);
    await prefs.setString('jenisKelamin', jenisKelamin.value);

    Get.back();
    Get.snackbar('Tersimpan ✅', 'Profil berhasil diperbarui',
        backgroundColor: const Color(0xFF1A6BFF), colorText: Colors.white,
        snackPosition: SnackPosition.TOP, margin: const EdgeInsets.all(16),
        borderRadius: 12);
  }

  // ── Toggle reminders ───────────────────────────────────────────────────────
  Future<void> togglePengingatTarget(bool v) async {
    pengingatTarget.value = v;
    final p = await SharedPreferences.getInstance();
    await p.setBool('pengingatTarget', v);
  }

  Future<void> togglePengingatPemasukan(bool v) async {
    pengingatPemasukan.value = v;
    final p = await SharedPreferences.getInstance();
    await p.setBool('pengingatPemasukan', v);
  }

  Future<void> toggleBatasAnggaran(bool v) async {
    batasAnggaran.value = v;
    final p = await SharedPreferences.getInstance();
    await p.setBool('batasAnggaran', v);
  }

  Future<void> toggleLaporanMingguan(bool v) async {
    laporanMingguan.value = v;
    final p = await SharedPreferences.getInstance();
    await p.setBool('laporanMingguan', v);
  }

  // ── Change password ────────────────────────────────────────────────────────
  void toggleKataSandi() => isKataSandiVisible.value = !isKataSandiVisible.value;
  void toggleKonfirmasi() => isKonfirmasiVisible.value = !isKonfirmasiVisible.value;

  Future<void> gantiKataSandi() async {
    if (kataSandiCtrl.text.isEmpty || kataSandiCtrl.text.length < 6) {
      Get.snackbar('Oops', 'Kata sandi minimal 6 karakter',
          snackPosition: SnackPosition.TOP); return;
    }
    if (kataSandiCtrl.text != konfirmasiCtrl.text) {
      Get.snackbar('Oops', 'Kata sandi tidak sama',
          snackPosition: SnackPosition.TOP); return;
    }
    isSavingPassword.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isSavingPassword.value = false;
    kataSandiCtrl.clear(); konfirmasiCtrl.clear();
    Get.back(); // close screen
    _showPasswordSuccessDialog();
  }

  void _showPasswordSuccessDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 64, height: 64,
                decoration: BoxDecoration(
                    color: const Color(0xFF22C55E).withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.lock_outlined, color: Color(0xFF22C55E), size: 32)),
            const SizedBox(height: 16),
            const Text('Kata sandi baru berhasil dibuat!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1F36))),
            const SizedBox(height: 8),
            const Text('Kata sandi akunmu telah berhasil diperbarui. Gunakan kata sandi baru dan masuk ke akunmu.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0xFF8F95B2),
                    height: 1.5)),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, height: 46,
                child: ElevatedButton(
                  onPressed: Get.back,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A6BFF),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0),
                  child: const Text('Mengerti', style: TextStyle(fontSize: 14,
                      fontWeight: FontWeight.w600, color: Colors.white)),
                )),
          ]),
        ),
      ),
    );
  }

  // ── Logout ─────────────────────────────────────────────────────────────────
  void showLogoutDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 56, height: 56,
                decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 28)),
            const SizedBox(height: 14),
            const Text('Keluar dari Akun?',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1F36))),
            const SizedBox(height: 8),
            const Text('Apakah Anda yakin ingin Keluar?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Color(0xFF8F95B2))),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, height: 46,
                child: ElevatedButton(
                  onPressed: _doLogout,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0),
                  child: const Text('Ya, Keluar', style: TextStyle(fontSize: 14,
                      fontWeight: FontWeight.w600, color: Colors.white)),
                )),
            const SizedBox(height: 10),
            SizedBox(width: double.infinity, height: 46,
                child: OutlinedButton(
                  onPressed: Get.back,
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE4E9F2)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('Batal', style: TextStyle(fontSize: 14,
                      fontWeight: FontWeight.w500, color: Color(0xFF8F95B2))),
                )),
          ]),
        ),
      ),
    );
  }

  Future<void> _doLogout() async {
    Get.back(); // close dialog
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    Get.offAllNamed(AppRoutes.login);
  }

  // ── Delete account ─────────────────────────────────────────────────────────
  void showHapusAkunDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Hapus Akun', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                color: Color(0xFF1A1F36))),
            const SizedBox(height: 10),
            const Text('Semua data akan dihapus permanen tidak bisa dipulihkan. Yakin menghapus akun?',
                style: TextStyle(fontSize: 13, color: Color(0xFF8F95B2),
                    height: 1.5)),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(onPressed: Get.back,
                  child: const Text('Batal', style: TextStyle(color: Color(0xFF8F95B2),
                      fontWeight: FontWeight.w500))),
              const SizedBox(width: 8),
              TextButton(
                  onPressed: () async {
                    Get.back();
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    Get.offAllNamed(AppRoutes.login);
                  },
                  child: const Text('Hapus Akun', style: TextStyle(color: Color(0xFFEF4444),
                      fontWeight: FontWeight.w700))),
            ]),
          ]),
        ),
      ),
    );
  }

  @override
  void onClose() {
    namaCtrl.dispose();
    emailCtrl.dispose();
    teleponCtrl.dispose();
    kataSandiCtrl.dispose();
    konfirmasiCtrl.dispose();
    super.onClose();
  }
}
