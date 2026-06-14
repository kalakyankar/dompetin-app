import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavingTarget {
  final String id;
  String name;
  double targetAmount;
  double currentAmount;
  DateTime targetDate;
  String simpanDi; // 'Dana', 'Bank Jago', 'Cash', dll
  bool notifikasiAktif;

  SavingTarget({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.simpanDi,
    this.notifikasiAktif = true,
  });

  double get progress =>
      targetAmount > 0 ? (currentAmount / targetAmount).clamp(0.0, 1.0) : 0.0;
  double get progressPct => progress * 100;
  bool get isComplete => currentAmount >= targetAmount;

  int get daysLeft => targetDate.difference(DateTime.now()).inDays;

  /// Estimated monthly contribution needed
  double get monthlyNeeded {
    final remaining = targetAmount - currentAmount;
    final months = (daysLeft / 30).ceilToDouble();
    if (months <= 0 || remaining <= 0) return 0;
    return remaining / months;
  }
}

class TargetController extends GetxController {
  final targets = <SavingTarget>[].obs;

  double get totalTabungan =>
      targets.fold(0.0, (s, t) => s + t.currentAmount);

  int get activeTargetCount => targets.where((t) => !t.isComplete).length;

  String formatRupiah(double amount) {
    final abs = amount.abs();
    final str = abs.toStringAsFixed(0);
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
      count++;
    }
    return 'Rp ${buffer.toString().split('').reversed.join('')}';
  }

  // ── Add Target ────────────────────────────────────────────────────────────
  void showAddTargetSheet(BuildContext context) {
    Get.bottomSheet(
      _AddTargetSheet(ctrl: this),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      ignoreSafeArea: false,
    );
  }

  void addTarget({
    required String name,
    required double targetAmount,
    required double saldoAwal,
    required DateTime targetDate,
    required String simpanDi,
    required bool notifikasi,
  }) {
    targets.add(SavingTarget(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      targetAmount: targetAmount,
      currentAmount: saldoAwal,
      targetDate: targetDate,
      simpanDi: simpanDi,
      notifikasiAktif: notifikasi,
    ));
    Get.snackbar('Berhasil! 🎯', 'Target "$name" berhasil ditambahkan',
        backgroundColor: const Color(0xFF1A6BFF),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12);
  }

  // ── Tambah Dana ───────────────────────────────────────────────────────────
  void showTambahSheet(BuildContext context, SavingTarget target) {
    Get.bottomSheet(
      _TambahKurangiSheet(ctrl: this, target: target, isTambah: true),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void showKurangiSheet(BuildContext context, SavingTarget target) {
    Get.bottomSheet(
      _TambahKurangiSheet(ctrl: this, target: target, isTambah: false),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void updateAmount(String id, double delta) {
    final i = targets.indexWhere((t) => t.id == id);
    if (i < 0) return;
    final updated = targets[i];
    final newAmount = (updated.currentAmount + delta).clamp(0.0, double.infinity);
    targets[i] = SavingTarget(
      id: updated.id,
      name: updated.name,
      targetAmount: updated.targetAmount,
      currentAmount: newAmount,
      targetDate: updated.targetDate,
      simpanDi: updated.simpanDi,
      notifikasiAktif: updated.notifikasiAktif,
    );
  }

  // ── Progress Sheet ────────────────────────────────────────────────────────
  void showProgressSheet(BuildContext context, SavingTarget target) {
    Get.bottomSheet(
      _ProgressSheet(ctrl: this, target: target),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // ── Options Popup ─────────────────────────────────────────────────────────
  void showOptionsPopup(BuildContext context, SavingTarget target) {
    Get.bottomSheet(
      _OptionsSheet(ctrl: this, target: target),
      backgroundColor: Colors.transparent,
    );
  }

  // ── Delete ────────────────────────────────────────────────────────────────
  void confirmDelete(BuildContext context, SavingTarget target) {
    Get.back(); // close options sheet
    Get.dialog(
      _DeleteDialog(ctrl: this, target: target),
      barrierDismissible: true,
    );
  }

  void deleteTarget(String id) {
    targets.removeWhere((t) => t.id == id);
    Get.back();
    Get.snackbar('Dihapus', 'Target berhasil dihapus',
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16));
  }

  // ── Edit (simplified — reopen sheet pre-filled) ──────────────────────────
  void showEditSheet(BuildContext context, SavingTarget target) {
    Get.back(); // close options
    Get.bottomSheet(
      _AddTargetSheet(ctrl: this, editTarget: target),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void updateTarget({
    required String id,
    required String name,
    required double targetAmount,
    required DateTime targetDate,
    required String simpanDi,
    required bool notifikasi,
  }) {
    final i = targets.indexWhere((t) => t.id == id);
    if (i < 0) return;
    final old = targets[i];
    targets[i] = SavingTarget(
      id: id,
      name: name,
      targetAmount: targetAmount,
      currentAmount: old.currentAmount,
      targetDate: targetDate,
      simpanDi: simpanDi,
      notifikasiAktif: notifikasi,
    );
    Get.snackbar('Diperbarui', 'Target berhasil diperbarui',
        backgroundColor: const Color(0xFF1A6BFF),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHEETS & DIALOGS (kept in same file for cohesion)
// ─────────────────────────────────────────────────────────────────────────────

// ── Add / Edit Target Sheet ───────────────────────────────────────────────────

class _AddTargetSheet extends StatefulWidget {
  final TargetController ctrl;
  final SavingTarget? editTarget;
  const _AddTargetSheet({required this.ctrl, this.editTarget});

  @override
  State<_AddTargetSheet> createState() => _AddTargetSheetState();
}

class _AddTargetSheetState extends State<_AddTargetSheet> {
  final nameCtrl = TextEditingController();
  final saldoAwalCtrl = TextEditingController(text: '0');
  final jumlahTargetCtrl = TextEditingController(text: '0');
  final simpanCtrl = TextEditingController();
  bool notifikasi = true;
  DateTime? targetDate;

  bool get isEdit => widget.editTarget != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      final t = widget.editTarget!;
      nameCtrl.text = t.name;
      saldoAwalCtrl.text = t.currentAmount.toStringAsFixed(0);
      jumlahTargetCtrl.text = t.targetAmount.toStringAsFixed(0);
      simpanCtrl.text = t.simpanDi;
      notifikasi = t.notifikasiAktif;
      targetDate = t.targetDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 60, 12, 12),
      padding: EdgeInsets.only(
        left: 20, right: 20, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(isEdit ? 'Edit Target' : 'Tambahkan Target Baru',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1F36), fontFamily: 'Poppins')),
            GestureDetector(onTap: Get.back,
                child: Container(width: 28, height: 28,
                    decoration: const BoxDecoration(color: Color(0xFFF5F7FF), shape: BoxShape.circle),
                    child: const Icon(Icons.close, size: 14))),
          ]),
          const SizedBox(height: 20),

          _Label('Nama Target'),
          const SizedBox(height: 6),
          _Field(controller: nameCtrl, hint: 'contoh: BSI'),
          const SizedBox(height: 14),

          _Label('Tanggal Target'),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () async {
              final p = await showDatePicker(
                context: context,
                initialDate: targetDate ?? DateTime.now().add(const Duration(days: 30)),
                firstDate: DateTime.now(),
                lastDate: DateTime(2040),
                builder: (ctx, child) => Theme(
                  data: Theme.of(ctx).copyWith(
                    colorScheme: const ColorScheme.light(primary: Color(0xFF1A6BFF))),
                  child: child!),
              );
              if (p != null) setState(() => targetDate = p);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(color: const Color(0xFFF7F9FC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE4E9F2))),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(targetDate == null ? 'tanggal'
                    : '${targetDate!.day}/${targetDate!.month}/${targetDate!.year}',
                    style: TextStyle(fontSize: 14, fontFamily: 'Poppins',
                        color: targetDate == null ? const Color(0xFF8F95B2) : const Color(0xFF1A1F36))),
                const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF8F95B2)),
              ]),
            ),
          ),
          const SizedBox(height: 14),

          _Label('Saldo Awal'),
          const SizedBox(height: 6),
          _Field(controller: saldoAwalCtrl, hint: 'Rp 0', isNumber: true, prefix: 'Rp'),
          const SizedBox(height: 14),

          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _Label('Jumlah Target'),
              const SizedBox(height: 6),
              _Field(controller: jumlahTargetCtrl, hint: 'Rp 0', isNumber: true, prefix: 'Rp'),
            ])),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _Label('Simpan'),
              const SizedBox(height: 6),
              _Field(controller: simpanCtrl, hint: 'contoh: Dana'),
            ])),
          ]),
          const SizedBox(height: 14),

          // Notifikasi
          Row(children: [
            const Icon(Icons.notifications_outlined, size: 18, color: Color(0xFF1A6BFF)),
            const SizedBox(width: 8),
            const Expanded(child: Text('Aktifkan Notifikasi',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500,
                    color: Color(0xFF1A1F36), fontFamily: 'Poppins'))),
            Switch(value: notifikasi, onChanged: (v) => setState(() => notifikasi = v),
                activeThumbColor: const Color(0xFF1A6BFF)),
          ]),
          const SizedBox(height: 20),

          // Simpan button
          SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A6BFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0),
              child: Text(isEdit ? 'Perbarui' : 'Simpan',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                      color: Colors.white, fontFamily: 'Poppins')),
            ),
          ),
        ]),
      ),
    );
  }

  void _submit() {
    if (nameCtrl.text.trim().isEmpty) {
      Get.snackbar('Oops', 'Nama target tidak boleh kosong',
          snackPosition: SnackPosition.TOP); return;
    }
    if (targetDate == null) {
      Get.snackbar('Oops', 'Pilih tanggal target', snackPosition: SnackPosition.TOP); return;
    }
    final target = double.tryParse(jumlahTargetCtrl.text) ?? 0;
    if (target <= 0) {
      Get.snackbar('Oops', 'Jumlah target harus lebih dari 0',
          snackPosition: SnackPosition.TOP); return;
    }
    Get.back();
    if (isEdit) {
      widget.ctrl.updateTarget(
        id: widget.editTarget!.id,
        name: nameCtrl.text.trim(),
        targetAmount: target,
        targetDate: targetDate!,
        simpanDi: simpanCtrl.text.trim().isEmpty ? 'Dana' : simpanCtrl.text.trim(),
        notifikasi: notifikasi,
      );
    } else {
      widget.ctrl.addTarget(
        name: nameCtrl.text.trim(),
        targetAmount: target,
        saldoAwal: double.tryParse(saldoAwalCtrl.text) ?? 0,
        targetDate: targetDate!,
        simpanDi: simpanCtrl.text.trim().isEmpty ? 'Dana' : simpanCtrl.text.trim(),
        notifikasi: notifikasi,
      );
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose(); saldoAwalCtrl.dispose();
    jumlahTargetCtrl.dispose(); simpanCtrl.dispose();
    super.dispose();
  }
}

// ── Tambah / Kurangi Sheet ────────────────────────────────────────────────────

class _TambahKurangiSheet extends StatefulWidget {
  final TargetController ctrl;
  final SavingTarget target;
  final bool isTambah;
  const _TambahKurangiSheet({required this.ctrl, required this.target, required this.isTambah});

  @override
  State<_TambahKurangiSheet> createState() => _TambahKurangiSheetState();
}

class _TambahKurangiSheetState extends State<_TambahKurangiSheet> {
  final amountCtrl = TextEditingController(text: '0');

  @override
  Widget build(BuildContext context) {
    final t = widget.target;
    final isTambah = widget.isTambah;
    return Container(
      margin: const EdgeInsets.all(12),
      padding: EdgeInsets.only(left: 20, right: 20, top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(isTambah ? 'Tambah Tabungan' : 'Kurangi Tabungan',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1F36), fontFamily: 'Poppins')),
          GestureDetector(onTap: Get.back,
              child: Container(width: 28, height: 28,
                  decoration: const BoxDecoration(color: Color(0xFFF5F7FF), shape: BoxShape.circle),
                  child: const Icon(Icons.close, size: 14))),
        ]),
        const SizedBox(height: 16),

        // Target info card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: const Color(0xFFF5F7FF),
              borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            Container(width: 40, height: 40,
                decoration: BoxDecoration(
                    color: const Color(0xFF1A6BFF).withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.savings_outlined, size: 20, color: Color(0xFF1A6BFF))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1F36), fontFamily: 'Poppins')),
              Text(
                '${widget.ctrl.formatRupiah(t.currentAmount)} / ${widget.ctrl.formatRupiah(t.targetAmount)}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF8F95B2), fontFamily: 'Poppins')),
            ])),
            Text('${t.date.day}/${t.date.month}/${t.date.year}',
                style: const TextStyle(fontSize: 11, color: Color(0xFF8F95B2), fontFamily: 'Poppins')),
          ]),
        ),
        const SizedBox(height: 16),

        Text(isTambah ? 'Tambah Dana' : 'Kurangi Dana',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
                color: Color(0xFF1A1F36), fontFamily: 'Poppins')),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFFF7F9FC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1A6BFF), width: 1.5)),
          child: Row(children: [
            const Text('Rp ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                color: Color(0xFF1A6BFF), fontFamily: 'Poppins')),
            Expanded(child: TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 14, fontFamily: 'Poppins', color: Color(0xFF1A1F36)),
              decoration: const InputDecoration(border: InputBorder.none, isDense: true),
            )),
          ]),
        ),
        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity, height: 52,
          child: ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountCtrl.text) ?? 0;
              if (amount <= 0) { Get.snackbar('Oops', 'Masukkan jumlah dana',
                  snackPosition: SnackPosition.TOP); return; }
              widget.ctrl.updateAmount(t.id, isTambah ? amount : -amount);
              Get.back();
              Get.snackbar(isTambah ? 'Ditambah ✅' : 'Dikurangi ✅',
                  '${widget.ctrl.formatRupiah(amount)} berhasil ${isTambah ? "ditambahkan" : "dikurangi"}',
                  backgroundColor: const Color(0xFF1A6BFF), colorText: Colors.white,
                  snackPosition: SnackPosition.TOP, margin: const EdgeInsets.all(16), borderRadius: 12);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A6BFF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0),
            child: const Text('Simpan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,
                color: Colors.white, fontFamily: 'Poppins')),
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() { amountCtrl.dispose(); super.dispose(); }
}

extension on SavingTarget {
  DateTime get date => targetDate;
}

// ── Progress Sheet ─────────────────────────────────────────────────────────────

class _ProgressSheet extends StatelessWidget {
  final TargetController ctrl;
  final SavingTarget target;
  const _ProgressSheet({required this.ctrl, required this.target});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Obx(() {
        final t = ctrl.targets.firstWhere((x) => x.id == target.id, orElse: () => target);
        return Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Progres Penyimpanan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1F36), fontFamily: 'Poppins')),
            GestureDetector(onTap: Get.back,
                child: Container(width: 28, height: 28,
                    decoration: const BoxDecoration(color: Color(0xFFF5F7FF), shape: BoxShape.circle),
                    child: const Icon(Icons.close, size: 14))),
          ]),
          const SizedBox(height: 24),

          // Arc progress
          SizedBox(
            height: 130,
            child: Stack(alignment: Alignment.center, children: [
              CustomPaint(
                size: const Size(180, 130),
                painter: _ArcPainter(progress: t.progress),
              ),
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                const SizedBox(height: 20),
                Text('${t.progressPct.toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1F36), fontFamily: 'Poppins')),
                const Text('Sesuai Proses',
                    style: TextStyle(fontSize: 11, color: Color(0xFF8F95B2), fontFamily: 'Poppins')),
              ]),
            ]),
          ),
          const SizedBox(height: 16),

          // Terkumpul vs Target
          Row(children: [
            Expanded(child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF1A6BFF),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Terkumpul', style: TextStyle(fontSize: 11, color: Colors.white70,
                    fontFamily: 'Poppins')),
                const SizedBox(height: 4),
                Text(ctrl.formatRupiah(t.currentAmount),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                        color: Colors.white, fontFamily: 'Poppins')),
              ]),
            )),
            const SizedBox(width: 10),
            Expanded(child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF1A6BFF),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Target', style: TextStyle(fontSize: 11, color: Colors.white70,
                    fontFamily: 'Poppins')),
                const SizedBox(height: 4),
                Text(ctrl.formatRupiah(t.targetAmount),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                        color: Colors.white, fontFamily: 'Poppins')),
              ]),
            )),
          ]),
          const SizedBox(height: 14),

          // Prediksi
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFFF5F7FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE4E9F2))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.auto_awesome, size: 16, color: Color(0xFF1A6BFF)),
                const SizedBox(width: 6),
                const Text('Prediksi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                    color: Color(0xFF1A6BFF), fontFamily: 'Poppins')),
              ]),
              const SizedBox(height: 8),
              Text(
                'Berdasarkan kecepatan menabung Anda saat ini, diperkirakan Anda akan mencapai tujuan pada ${_formatDate(t.targetDate)}. '
                'Jika Anda mengkontribusikan bulanan sebesar 20%, Anda akan menyelesaikannya sesuai dengan target Anda.\n\n'
                'Kontribusi bulanan yang disarankan: ${ctrl.formatRupiah(t.monthlyNeeded)}/bulan',
                style: const TextStyle(fontSize: 12, color: Color(0xFF8F95B2),
                    fontFamily: 'Poppins', height: 1.5),
              ),
            ]),
          ),
        ]);
      }),
    );
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';
}

class _ArcPainter extends CustomPainter {
  final double progress;
  _ArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.85;
    final r = size.width * 0.45;
    const sw = 18.0;
    const startAngle = math.pi;
    const sweepFull = math.pi;

    final bg = Paint()
      ..color = const Color(0xFFE4E9F2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r),
        startAngle, sweepFull, false, bg);

    if (progress > 0) {
      final fg = Paint()
        ..color = const Color(0xFF1A6BFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = sw
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r),
          startAngle, sweepFull * progress, false, fg);
    }
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.progress != progress;
}

// ── Options Sheet ─────────────────────────────────────────────────────────────

class _OptionsSheet extends StatelessWidget {
  final TargetController ctrl;
  final SavingTarget target;
  const _OptionsSheet({required this.ctrl, required this.target});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        _OptionItem(icon: Icons.edit_outlined, label: 'Edit Target', color: const Color(0xFF22C55E),
            onTap: () => ctrl.showEditSheet(context, target)),
        const Divider(height: 1, indent: 56),
        _OptionItem(icon: Icons.notifications_outlined, label: 'Pengingat Target',
            color: const Color(0xFF1A6BFF),
            onTap: () { Get.back(); Get.snackbar('Pengingat', 'Fitur segera hadir 🔔',
                snackPosition: SnackPosition.TOP); }),
        const Divider(height: 1, indent: 56),
        _OptionItem(icon: Icons.delete_outline, label: 'Hapus Target',
            color: const Color(0xFFEF4444),
            onTap: () => ctrl.confirmDelete(context, target)),
      ]),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _OptionItem({required this.icon, required this.label,
      required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(width: 36, height: 36,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: Icon(icon, size: 18, color: color)),
      title: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
          color: color == const Color(0xFFEF4444) ? color : const Color(0xFF1A1F36),
          fontFamily: 'Poppins')),
      onTap: onTap,
    );
  }
}

// ── Delete Dialog ─────────────────────────────────────────────────────────────

class _DeleteDialog extends StatelessWidget {
  final TargetController ctrl;
  final SavingTarget target;
  const _DeleteDialog({required this.ctrl, required this.target});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Hapus Target', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
              color: Color(0xFF1A1F36), fontFamily: 'Poppins')),
          const SizedBox(height: 10),
          const Text('Yakin ingin menghapus target ini?\nSemua data tabungan Anda akan hilang.',
              style: TextStyle(fontSize: 13, color: Color(0xFF8F95B2),
                  fontFamily: 'Poppins', height: 1.5)),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            TextButton(onPressed: Get.back,
                child: const Text('Batal', style: TextStyle(color: Color(0xFF8F95B2),
                    fontFamily: 'Poppins', fontWeight: FontWeight.w500))),
            const SizedBox(width: 8),
            TextButton(onPressed: () => ctrl.deleteTarget(target.id),
                child: const Text('Hapus', style: TextStyle(color: Color(0xFFEF4444),
                    fontFamily: 'Poppins', fontWeight: FontWeight.w600))),
          ]),
        ]),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(
      fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1A1F36), fontFamily: 'Poppins'));
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isNumber;
  final String? prefix;
  const _Field({required this.controller, required this.hint,
      this.isNumber = false, this.prefix});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE4E9F2))),
      child: Row(children: [
        if (prefix != null) Text('$prefix ', style: const TextStyle(fontSize: 14,
            color: Color(0xFF8F95B2), fontFamily: 'Poppins')),
        Expanded(child: TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(fontSize: 14, fontFamily: 'Poppins', color: Color(0xFF1A1F36)),
          decoration: InputDecoration(border: InputBorder.none, isDense: true,
              hintText: hint, hintStyle: const TextStyle(color: Color(0xFF8F95B2))),
        )),
      ]),
    );
  }
}
