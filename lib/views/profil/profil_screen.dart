import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/profil_controller.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ProfilController());
    return SafeArea(
        child: SingleChildScrollView(
            child: Column(children: [
      Container(
          color: AppTheme.white,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Obx(() => Row(children: [
                Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            colors: [AppTheme.primaryBlue, AppTheme.deepBlue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight)),
                    child: Center(
                        child: Text(
                            ctrl.nama.value.isNotEmpty
                                ? ctrl.nama.value[0].toUpperCase()
                                : 'U',
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)))),
                const SizedBox(width: 14),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(ctrl.nama.value,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textDark)),
                      Text(ctrl.email.value, style: AppTheme.bodySmall),
                      Text(ctrl.telepon.value, style: AppTheme.bodySmall),
                    ])),
                GestureDetector(
                  onTap: () => Get.to(() => const EditProfilScreen()),
                  child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          color: AppTheme.inputFill,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.inputBorder)),
                      child: const Icon(Icons.edit_outlined,
                          size: 16, color: AppTheme.textGrey)),
                ),
              ]))),
      const SizedBox(height: 12),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            _MenuCard(items: [
              _MI(
                  Icons.security_outlined,
                  AppTheme.primaryBlue,
                  'Keamanan Akun',
                  () => Get.to(() => const KeamananAkunScreen())),
              _MI(Icons.bar_chart_rounded, const Color(0xFF8B5CF6), 'Insight',
                  () => Get.toNamed(AppRoutes.insight)),
              _MI(Icons.notifications_outlined, const Color(0xFFF59E0B),
                  'Pengingat', () => Get.to(() => const PengingatScreen())),
              _MI(
                  Icons.help_outline_rounded,
                  const Color(0xFF22C55E),
                  'Pusat Bantuan',
                  () => Get.to(() => const PusatBantuanScreen())),
              _MI(
                  Icons.support_agent_rounded,
                  const Color(0xFF06B6D4),
                  'Customer Services',
                  () => Get.to(() => const CustomerServicesScreen())),
            ]),
            const SizedBox(height: 12),
            _MenuCard(items: [
              _MI(Icons.logout_rounded, const Color(0xFFEF4444), 'Keluar Akun',
                  () => Get.find<ProfilController>().showLogoutDialog(),
                  destructive: true),
            ]),
            const SizedBox(height: 32),
          ])),
    ])));
  }
}

class _MI {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;
  final bool destructive;
  _MI(this.icon, this.color, this.label, this.onTap,
      {this.destructive = false});
}

class _MenuCard extends StatelessWidget {
  final List<_MI> items;
  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.inputBorder)),
      child: Column(
          children: items.asMap().entries.map((e) {
        final i = e.key;
        final item = e.value;
        return Column(children: [
          ListTile(
            onTap: item.onTap,
            leading: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(item.icon, size: 18, color: item.color)),
            title: Text(item.label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: item.destructive
                        ? const Color(0xFFEF4444)
                        : AppTheme.textDark)),
            trailing: item.destructive
                ? null
                : const Icon(Icons.chevron_right,
                    color: AppTheme.textGrey, size: 20),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          ),
          if (i < items.length - 1)
            const Divider(height: 1, color: AppTheme.divider, indent: 68),
        ]);
      }).toList()),
    );
  }
}

// ─── Edit Profil ──────────────────────────────────────────────────────────────
class EditProfilScreen extends StatelessWidget {
  const EditProfilScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProfilController>();
    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      appBar: _appBar('Edit Profile'),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Center(
                child: Stack(children: [
              Obx(() => Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          colors: [AppTheme.primaryBlue, AppTheme.deepBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight)),
                  child: Center(
                      child: Text(
                          ctrl.nama.value.isNotEmpty
                              ? ctrl.nama.value[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white))))),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                          color: AppTheme.primaryBlue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2)),
                      child: const Icon(Icons.camera_alt_rounded,
                          size: 14, color: Colors.white))),
            ])),
            const SizedBox(height: 8),
            Obx(() => Text(ctrl.email.value, style: AppTheme.bodySmall)),
            const SizedBox(height: 24),
            _card([
              _field('Nama', ctrl.namaCtrl, 'Nama lengkap'),
              _field('Email', ctrl.emailCtrl, 'Email',
                  kb: TextInputType.emailAddress),
              _field('Nomor Telepon', ctrl.teleponCtrl, '+62 xxx',
                  kb: TextInputType.phone),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Jenis Kelamin',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textDark)),
                const SizedBox(height: 6),
                Obx(() => DropdownButtonFormField<String>(
                      initialValue: ctrl.jenisKelamin.value,
                      items: ['Laki-Laki', 'Perempuan', 'Lainnya']
                          .map((v) => DropdownMenuItem(
                              value: v, child: Text(v, style: AppTheme.label)))
                          .toList(),
                      onChanged: (v) => ctrl.jenisKelamin.value =
                          v ?? ctrl.jenisKelamin.value,
                      decoration: AppTheme.inputDecoration(hint: ''),
                    )),
              ]),
            ]),
            const SizedBox(height: 24),
            SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: ctrl.saveProfilEdit,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0),
                  child: const Text('Simpan',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                )),
          ])),
    );
  }
}

// ─── Pusat Bantuan ────────────────────────────────────────────────────────────
class PusatBantuanScreen extends StatelessWidget {
  const PusatBantuanScreen({super.key});
  static const _faqs = [
    (
      'Bagaimana cara menambahkan Dana yang ingin di simpan?',
      'Buka halaman Pemasukan, pilih kategori dan masukkan jumlah dana yang ingin dicatat. Anda bisa menentukan sumber dana (Bank/E-Wallet/Cash).'
    ),
    (
      'Bagaimana cara mengetahui progres target tabungan?',
      'Progres tabungan dapat dilihat melalui menu Target. Di sana terdapat bar progress yang menampilkan progres tabungan Anda setiap harinya.'
    ),
    (
      'Bagaimana jika hasil scan tidak terbaca?',
      'Pastikan pencahayaan cukup dan posisi kamera stabil. Anda bisa mencoba scan ulang atau memasukkan data secara manual.'
    ),
    (
      'Bagaimana cara mengatur anggaran bulanan?',
      'Buka halaman Home, lalu klik "Tetapkan Batas Pengeluaran". Masukkan jumlah batas maksimal pengeluaran bulanan Anda.'
    ),
    (
      'Apakah data saya aman di aplikasi ini?',
      'Ya, data Anda dilindungi dengan sistem keamanan terkini dan enkripsi. Kami tidak pernah menjual data Anda kepada pihak ketiga.'
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.offWhite,
        appBar: _appBar('Pusat Bantuan'),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Pertanyaan Umum',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textDark)),
              const SizedBox(height: 12),
              Container(
                  decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.inputBorder)),
                  child: Column(
                      children: _faqs
                          .asMap()
                          .entries
                          .map((e) => Column(children: [
                                _FaqTile(q: e.value.$1, a: e.value.$2),
                                if (e.key < _faqs.length - 1)
                                  const Divider(
                                      height: 1, color: AppTheme.divider),
                              ]))
                          .toList())),
            ])));
  }
}

class _FaqTile extends StatefulWidget {
  final String q;
  final String a;
  const _FaqTile({required this.q, required this.a});
  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _open = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
        duration: const Duration(milliseconds: 230),
        child: GestureDetector(
            onTap: () => setState(() => _open = !_open),
            behavior: HitTestBehavior.opaque,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                            child: Text(widget.q,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: _open
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: AppTheme.textDark))),
                        const SizedBox(width: 8),
                        AnimatedRotation(
                            duration: const Duration(milliseconds: 200),
                            turns: _open ? 0.5 : 0,
                            child: const Icon(Icons.keyboard_arrow_down_rounded,
                                color: AppTheme.textGrey, size: 20)),
                      ]),
                      if (_open) ...[
                        const SizedBox(height: 10),
                        Text(widget.a,
                            style: AppTheme.body
                                .copyWith(fontSize: 12, height: 1.6))
                      ],
                    ]))));
  }
}

// ─── Pengingat ────────────────────────────────────────────────────────────────
class PengingatScreen extends StatelessWidget {
  const PengingatScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProfilController>();
    return Scaffold(
        backgroundColor: AppTheme.offWhite,
        appBar: _appBar('Pengingat'),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _sh('Pengingat keuangan'),
              const SizedBox(height: 8),
              _toggleCard([
                (
                  Icons.savings_outlined,
                  AppTheme.primaryBlue,
                  'Pengingat Target',
                  'Notifikasi Pencapaian Target',
                  ctrl.pengingatTarget,
                  ctrl.togglePengingatTarget
                ),
                (
                  Icons.notifications_outlined,
                  const Color(0xFF22C55E),
                  'Pengingat Pemasukan',
                  'Notifikasi per bulan',
                  ctrl.pengingatPemasukan,
                  ctrl.togglePengingatPemasukan
                ),
              ]),
              const SizedBox(height: 16),
              _sh('Pelacakan Tujuan'),
              const SizedBox(height: 8),
              _toggleCard([
                (
                  Icons.shield_outlined,
                  const Color(0xFFEF4444),
                  'Batas Anggaran',
                  'Peringatan batas pengeluaran',
                  ctrl.batasAnggaran,
                  ctrl.toggleBatasAnggaran
                ),
                (
                  Icons.bar_chart_rounded,
                  const Color(0xFF8B5CF6),
                  'Laporan Mingguan',
                  'Rangkuman pengeluaran Anda',
                  ctrl.laporanMingguan,
                  ctrl.toggleLaporanMingguan
                ),
              ]),
            ])));
  }

  Widget _sh(String t) => Text(t,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppTheme.textGrey));

  Widget _toggleCard(
      List<(IconData, Color, String, String, RxBool, Function(bool))> items) {
    return Container(
        decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.inputBorder)),
        child: Column(
            children: items.asMap().entries.map((e) {
          final i = e.key;
          final it = e.value;
          return Column(children: [
            Obx(() => SwitchListTile(
                  value: it.$5.value,
                  onChanged: it.$6,
                  activeThumbColor: AppTheme.primaryBlue,
                  secondary: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                          color: it.$2.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Icon(it.$1, size: 18, color: it.$2)),
                  title: Text(it.$3,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textDark)),
                  subtitle: Text(it.$4, style: AppTheme.bodySmall),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                )),
            if (i < items.length - 1)
              const Divider(height: 1, color: AppTheme.divider, indent: 66),
          ]);
        }).toList()));
  }
}

// ─── Customer Services ────────────────────────────────────────────────────────
class CustomerServicesScreen extends StatelessWidget {
  const CustomerServicesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.offWhite,
        appBar: _appBar('Customer Services'),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: _MenuCard(items: [
              _MI(Icons.chat_bubble_outline_rounded, const Color(0xFF22C55E),
                  'Hubungi Admin', () {
                Get.snackbar('WhatsApp', 'Menghubungi Admin Dompetin...',
                    backgroundColor: const Color(0xFF22C55E),
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                    margin: const EdgeInsets.all(16));
              }),
              _MI(Icons.info_outline_rounded, AppTheme.primaryBlue,
                  'Salinan Dompetin', () {
                Get.snackbar(
                    'Dompetin', 'Versi 1.0.0 - Personal Finance Manager',
                    snackPosition: SnackPosition.TOP,
                    margin: const EdgeInsets.all(16));
              }),
            ])));
  }
}

// ─── Keamanan Akun ────────────────────────────────────────────────────────────
class KeamananAkunScreen extends StatelessWidget {
  const KeamananAkunScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProfilController>();
    return Scaffold(
        backgroundColor: AppTheme.offWhite,
        appBar: _appBar('Keamanan Akun'),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: _MenuCard(items: [
              _MI(
                  Icons.lock_outline_rounded,
                  AppTheme.primaryBlue,
                  'Ganti Kata Sandi',
                  () => Get.to(() => const GantiKataSandiScreen())),
              _MI(Icons.delete_outline_rounded, const Color(0xFFEF4444),
                  'Hapus Akun', ctrl.showHapusAkunDialog,
                  destructive: true),
            ])));
  }
}

// ─── Ganti Kata Sandi ─────────────────────────────────────────────────────────
class GantiKataSandiScreen extends StatelessWidget {
  const GantiKataSandiScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProfilController>();
    return Scaffold(
        backgroundColor: AppTheme.offWhite,
        appBar: _appBar('Ganti Kata Sandi'),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              _card([
                _pwField('Kata Sandi', ctrl.kataSandiCtrl, 'Kata Sandi',
                    ctrl.isKataSandiVisible, ctrl.toggleKataSandi),
                const SizedBox(height: 14),
                _pwField(
                    'Konfirmasi Kata Sandi',
                    ctrl.konfirmasiCtrl,
                    'Ulangi Kata Sandi',
                    ctrl.isKonfirmasiVisible,
                    ctrl.toggleKonfirmasi),
              ]),
              const SizedBox(height: 24),
              Obx(() => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: ctrl.isSavingPassword.value
                        ? null
                        : ctrl.gantiKataSandi,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0),
                    child: ctrl.isSavingPassword.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.5, color: Colors.white))
                        : const Text('Perbaru Kata Sandi',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                  ))),
            ])));
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

PreferredSizeWidget _appBar(String title) => AppBar(
      backgroundColor: AppTheme.white,
      elevation: 0,
      leading: GestureDetector(
          onTap: Get.back,
          child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.inputBorder),
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 16, color: AppTheme.textDark))),
      title: Text(title,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.textDark)),
      centerTitle: true,
    );

Widget _card(List<Widget> children) => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.inputBorder)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );

Widget _field(String label, TextEditingController ctrl, String hint,
        {TextInputType kb = TextInputType.text}) =>
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.textDark)),
      const SizedBox(height: 6),
      TextField(
          controller: ctrl,
          keyboardType: kb,
          style: AppTheme.label,
          decoration: AppTheme.inputDecoration(hint: hint)),
      const SizedBox(height: 14),
    ]);

Widget _pwField(String label, TextEditingController ctrl, String hint,
        RxBool visible, VoidCallback toggle) =>
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.textDark)),
      const SizedBox(height: 6),
      Obx(() => TextField(
            controller: ctrl,
            obscureText: !visible.value,
            style: AppTheme.label,
            decoration: AppTheme.inputDecoration(
                hint: hint,
                suffixIcon: IconButton(
                    icon: Icon(
                        visible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppTheme.textGrey,
                        size: 20),
                    onPressed: toggle)),
          )),
    ]);
