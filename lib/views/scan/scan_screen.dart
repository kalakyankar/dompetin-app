import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/scan_controller.dart';
import '../../theme/app_theme.dart';
import '../../routes/app_routes.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ScanController());
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Obx(() {
        switch (ctrl.currentStep.value) {
          case ScanStep.permission:
            return _PermissionStep(ctrl: ctrl);
          case ScanStep.intro:
            return _IntroStep(ctrl: ctrl);
          case ScanStep.camera:
            return _CameraStep(ctrl: ctrl);
          case ScanStep.analyzing:
            return _AnalyzingStep(ctrl: ctrl);
          case ScanStep.result:
            return _ResultStep(ctrl: ctrl);
          case ScanStep.success:
            return _SuccessStep(ctrl: ctrl);
        }
      }),
    );
  }
}

// ─── Step 1: Permission ───────────────────────────────────────────────────────
class _PermissionStep extends StatelessWidget {
  final ScanController ctrl;
  const _PermissionStep({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(children: [
        const SizedBox(height: 60),
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                AppTheme.primaryBlue.withValues(alpha: 0.15),
                AppTheme.primaryBlue.withValues(alpha: 0.03)
              ])),
          child: Center(
              child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                    colors: [Color(0xFF3A8EFF), Color(0xFF1A6BFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                boxShadow: [
                  BoxShadow(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.4),
                      blurRadius: 24,
                      offset: const Offset(0, 10))
                ]),
            child: const Icon(Icons.camera_alt_rounded,
                color: Colors.white, size: 46),
          )),
        ),
        const SizedBox(height: 32),
        Text('Aktifkan Kamera', style: AppTheme.heading2),
        const SizedBox(height: 12),
        Text(
            'Gunakan kamera Anda untuk memindai struk belanja dan mengelola anggaran secara otomatis.',
            style: AppTheme.body,
            textAlign: TextAlign.center),
        const SizedBox(height: 28),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
              color: const Color(0xFFF0FFF4),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.3))),
          child: Row(children: [
            Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                    shape: BoxShape.circle),
                child: const Icon(Icons.shield_outlined,
                    color: Color(0xFF22C55E), size: 18)),
            const SizedBox(width: 12),
            const Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('Privasi Terjamin',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF22C55E),
                          fontFamily: 'InterTight')),
                  Text('Keamanan data Anda adalah prioritas kami.',
                      style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF8F95B2),
                          fontFamily: 'InterTight')),
                ])),
          ]),
        ),
        const Spacer(),
        _Btn(label: 'Izinkan', onTap: ctrl.requestPermission),
        const SizedBox(height: 12),
        _OutBtn(label: 'Nanti Saja', onTap: ctrl.skipPermission),
        const SizedBox(height: 32),
      ]),
    ));
  }
}

// ─── Step 2: Intro ────────────────────────────────────────────────────────────
class _IntroStep extends StatelessWidget {
  final ScanController ctrl;
  const _IntroStep({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(children: [
        const SizedBox(height: 60),
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                AppTheme.primaryBlue.withValues(alpha: 0.22),
                AppTheme.primaryBlue.withValues(alpha: 0.04)
              ])),
          child: Center(
              child: Stack(alignment: Alignment.center, children: [
            Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.primaryBlue.withValues(alpha: 0.7),
                    boxShadow: [
                      BoxShadow(
                          color: AppTheme.primaryBlue.withValues(alpha: 0.5),
                          blurRadius: 40,
                          spreadRadius: 8)
                    ])),
            const Icon(Icons.document_scanner_outlined,
                color: Colors.white, size: 52),
          ])),
        ),
        const SizedBox(height: 36),
        Text('Scan struk dan pencatatan\notomatis',
            style: AppTheme.heading2.copyWith(fontSize: 22),
            textAlign: TextAlign.center),
        const SizedBox(height: 16),
        Text(
            'Kelola keuangan Anda tanpa repot. Cukup foto struk, dan biar AI kami yang merapikannya untuk Anda.',
            style: AppTheme.body,
            textAlign: TextAlign.center),
        const Spacer(),
        _Btn(label: 'Mulai Scan', onTap: ctrl.startScan),
        const SizedBox(height: 12),
        _OutBtn(label: 'Nanti Saja', onTap: ctrl.skipIntro),
        const SizedBox(height: 32),
      ]),
    ));
  }
}

// ─── Step 3: Camera ───────────────────────────────────────────────────────────
class _CameraStep extends StatelessWidget {
  final ScanController ctrl;
  const _CameraStep({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        final ready = ctrl.isCameraReady.value;
        final cam = ctrl.cameraController;
        return Stack(children: [
          if (ready && cam != null)
            Positioned.fill(child: CameraPreview(cam))
          else
            Positioned.fill(
                child: Container(
                    color: Colors.black87,
                    child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          const CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                          const SizedBox(height: 14),
                          Text('Memuat kamera...',
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 14,
                                  fontFamily: 'InterTight')),
                        ])))),

          // Top bar
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleBtn(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => ctrl.currentStep.value = ScanStep.intro),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Text('Scan Struk',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'InterTight'))),
                  _CircleBtn(
                      icon: Icons.photo_library_outlined,
                      onTap: ctrl.pickFromGallery),
                ]),
          )),

          // Viewfinder
          Center(child: _Viewfinder()),

          // Hint
          Center(
              child: Transform.translate(
                  offset: const Offset(0, 145),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.document_scanner_outlined,
                          color: Colors.white, size: 13),
                      SizedBox(width: 6),
                      Text('Arahkan ke struk belanja',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'InterTight')),
                    ]),
                  ))),

          // Capture button
          Positioned(
              bottom: 48,
              left: 0,
              right: 0,
              child: Column(children: [
                GestureDetector(
                  onTap: ctrl.capturePhoto,
                  child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 12)
                          ]),
                      child: Center(
                          child: Container(
                              width: 56,
                              height: 56,
                              decoration: const BoxDecoration(
                                  color: AppTheme.primaryBlue,
                                  shape: BoxShape.circle),
                              child: const Icon(Icons.camera_alt_rounded,
                                  color: Colors.white, size: 26)))),
                ),
                const SizedBox(height: 12),
                const Text('Foto Struk',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'InterTight')),
              ])),
        ]);
      }),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Colors.black.withValues(alpha: 0.4)),
            child: Icon(icon, color: Colors.white, size: 18)),
      );
}

class _Viewfinder extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SizedBox(
      width: 260, height: 380, child: CustomPaint(painter: _VfPainter()));
}

class _VfPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const r = 12.0;
    const L = 40.0;
    final w = s.width;
    final h = s.height;
    // corners
    void corner(double cx, double cy, double startAngle) {
      canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r),
          startAngle, 3.14159 / 2, false, p);
    }

    // TL
    canvas.drawLine(Offset(r, 0), Offset(L, 0), p);
    canvas.drawLine(Offset(0, r), Offset(0, L), p);
    corner(r, r, 3.14159);
    // TR
    canvas.drawLine(Offset(w - L, 0), Offset(w - r, 0), p);
    canvas.drawLine(Offset(w, r), Offset(w, L), p);
    corner(w - r, r, -3.14159 / 2);
    // BL
    canvas.drawLine(Offset(0, h - L), Offset(0, h - r), p);
    canvas.drawLine(Offset(r, h), Offset(L, h), p);
    corner(r, h - r, 3.14159 / 2);
    // BR
    canvas.drawLine(Offset(w, h - L), Offset(w, h - r), p);
    canvas.drawLine(Offset(w - L, h), Offset(w - r, h), p);
    corner(w - r, h - r, 0);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── Step 4: Analyzing ────────────────────────────────────────────────────────
class _AnalyzingStep extends StatelessWidget {
  final ScanController ctrl;
  const _AnalyzingStep({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      if (ctrl.scannedImagePath.value.isNotEmpty)
        Positioned.fill(
            child: Image.file(File(ctrl.scannedImagePath.value),
                fit: BoxFit.cover))
      else
        Container(color: Colors.black87),
      Positioned.fill(child: Container(color: Colors.black.withValues(alpha: 0.55))),

      // Viewfinder with scan line
      Center(
          child: SizedBox(
              width: 260,
              height: 380,
              child: Stack(children: [
                SizedBox(
                    width: 260,
                    height: 380,
                    child: CustomPaint(painter: _VfPainter())),
                Obx(() => Positioned(
                      top: ctrl.analysisProgress.value * 360,
                      left: 0,
                      right: 0,
                      child: Container(
                          height: 2,
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(colors: [
                            Colors.transparent,
                            AppTheme.primaryBlue,
                            Colors.transparent
                          ]))),
                    )),
              ]))),

      // Status
      Positioned(
          bottom: 60,
          left: 0,
          right: 0,
          child: Column(children: [
            Obx(() => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      color: AppTheme.primaryBlue,
                      borderRadius: BorderRadius.circular(24)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white)),
                    const SizedBox(width: 10),
                    Text(ctrl.analysisStatus.value,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'InterTight')),
                  ]),
                )),
            const SizedBox(height: 14),
            Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                          value: ctrl.analysisProgress.value,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor:
                              const AlwaysStoppedAnimation(Colors.white),
                          minHeight: 4)),
                )),
            const SizedBox(height: 8),
            Obx(() => Text('${(ctrl.analysisProgress.value * 100).toInt()}%',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                    fontFamily: 'InterTight'))),
          ])),
    ]);
  }
}

// ─── Step 5: Result (Scan 4) ──────────────────────────────────────────────────
class _ResultStep extends StatelessWidget {
  final ScanController ctrl;
  const _ResultStep({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: ctrl.retake,
          child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.inputBorder),
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 16, color: AppTheme.textDark)),
        ),
        title: const Text('Detail Transaksi',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
                fontFamily: 'InterTight')),
        centerTitle: true,
      ),
      body: Obx(() {
        final r = ctrl.parsedReceipt.value;
        if (r == null) return const Center(child: CircularProgressIndicator());
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // AI banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.25))),
              child: Row(children: [
                Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.auto_awesome,
                        color: AppTheme.primaryBlue, size: 18)),
                const SizedBox(width: 12),
                const Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Tentang analisis lengkap',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryBlue,
                              fontFamily: 'InterTight')),
                      Text(
                          'Dompetin telah memindai struk Anda dengan akurat. Mohon verifikasi detail dibawah ini.',
                          style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.textGrey,
                              fontFamily: 'InterTight')),
                    ])),
              ]),
            ),
            const SizedBox(height: 16),

            // Form card
            _Card(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  // Nama
                  _FormLabel('Nama'),
                  const SizedBox(height: 6),
                  TextField(
                      controller: ctrl.nameController,
                      style: AppTheme.label,
                      decoration: AppTheme.inputDecoration(hint: 'Nama toko')),
                  const SizedBox(height: 14),

                  // Kategori chips
                  _FormLabel('Kategori yang disarankan'),
                  const SizedBox(height: 8),
                  Obx(() => Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: ctrl.categories.take(6).map((c) {
                        final sel = ctrl.selectedCategory.value == c;
                        return GestureDetector(
                          onTap: () => ctrl.selectedCategory.value = c,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: sel
                                  ? AppTheme.primaryBlue
                                  : AppTheme.inputFill,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: sel
                                      ? AppTheme.primaryBlue
                                      : AppTheme.inputBorder),
                            ),
                            child: Text(c,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'InterTight',
                                    color: sel
                                        ? Colors.white
                                        : AppTheme.textGrey)),
                          ),
                        );
                      }).toList())),
                  const SizedBox(height: 14),

                  // Tanggal + Waktu row
                  Row(children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          _FormLabel('Tanggal'),
                          const SizedBox(height: 6),
                          Obx(() => GestureDetector(
                                onTap: () async {
                                  final p = await showDatePicker(
                                    context: context,
                                    initialDate: ctrl.selectedDate.value ??
                                        DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2030),
                                    builder: (ctx, child) => Theme(
                                        data: Theme.of(ctx).copyWith(
                                            colorScheme:
                                                const ColorScheme.light(
                                                    primary:
                                                        AppTheme.primaryBlue)),
                                        child: child!),
                                  );
                                  if (p != null) ctrl.selectedDate.value = p;
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                      color: AppTheme.inputFill,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: AppTheme.inputBorder)),
                                  child: Row(children: [
                                    const Icon(Icons.calendar_today_outlined,
                                        size: 14, color: AppTheme.textGrey),
                                    const SizedBox(width: 6),
                                    Text(
                                        ctrl.selectedDate.value == null
                                            ? 'Tanggal'
                                            : '${ctrl.selectedDate.value!.day} Mei ${ctrl.selectedDate.value!.year}',
                                        style: AppTheme.bodySmall.copyWith(
                                            color: AppTheme.textDark,
                                            fontSize: 12)),
                                  ]),
                                ),
                              )),
                        ])),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          _FormLabel('Waktu'),
                          const SizedBox(height: 6),
                          Obx(() => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                    color: AppTheme.inputFill,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: AppTheme.inputBorder)),
                                child: Row(children: [
                                  const Icon(Icons.access_time,
                                      size: 14, color: AppTheme.textGrey),
                                  const SizedBox(width: 6),
                                  Text(
                                      ctrl.selectedTime.value.isEmpty
                                          ? '--:-- WIB'
                                          : ctrl.selectedTime.value,
                                      style: AppTheme.bodySmall.copyWith(
                                          color: AppTheme.textDark,
                                          fontSize: 12)),
                                ]),
                              )),
                        ])),
                  ]),
                  const SizedBox(height: 14),

                  // Metode Pembayaran
                  _FormLabel('Metode Pembayaran'),
                  const SizedBox(height: 6),
                  Obx(() => DropdownButtonFormField<String>(
                        initialValue: ctrl.selectedPaymentMethod.value,
                        items: ctrl.paymentMethods
                            .map((m) => DropdownMenuItem(
                                value: m,
                                child: Row(children: [
                                  const Icon(
                                      Icons.account_balance_wallet_outlined,
                                      size: 16,
                                      color: AppTheme.textGrey),
                                  const SizedBox(width: 8),
                                  Text(m, style: AppTheme.label),
                                ])))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) ctrl.selectedPaymentMethod.value = v;
                        },
                        decoration: AppTheme.inputDecoration(hint: ''),
                      )),
                ])),
            const SizedBox(height: 14),

            // Items breakdown
            if (ctrl.editableItems.isNotEmpty)
              _Card(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    _FormLabel('Metode Pembayaran'),
                    const SizedBox(height: 10),
                    ...ctrl.editableItems.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(children: [
                          Expanded(
                              child: Text('${item.qty}x ${item.name}',
                                  style: AppTheme.body
                                      .copyWith(color: AppTheme.textDark))),
                          Text(ctrl.formatRupiah(item.total),
                              style: AppTheme.label),
                        ]))),
                    if (ctrl.parsedReceipt.value?.cashGiven != null &&
                        ctrl.parsedReceipt.value!.cashGiven > 0) ...[
                      const Divider(color: AppTheme.divider, height: 16),
                      _SummaryRow(
                          'Tunai',
                          ctrl.formatRupiah(
                              ctrl.parsedReceipt.value!.cashGiven)),
                    ],
                    const Divider(color: AppTheme.divider, height: 16),
                    _SummaryRow('Total', ctrl.formatRupiah(ctrl.effectiveTotal),
                        bold: true),
                    if (ctrl.parsedReceipt.value?.change != null &&
                        ctrl.parsedReceipt.value!.change > 0)
                      _SummaryRow('Kembalian',
                          ctrl.formatRupiah(ctrl.parsedReceipt.value!.change)),
                  ])),
            const SizedBox(height: 24),

            Obx(() => _Btn(
                  label: ctrl.isSaving.value ? 'Menyimpan...' : 'Lanjutkan',
                  onTap: ctrl.isSaving.value ? () {} : ctrl.lanjutkan,
                  isLoading: ctrl.isSaving.value,
                )),
            const SizedBox(height: 12),
            _OutBtn(label: 'Batalkan', onTap: ctrl.batalkan),
            const SizedBox(height: 32),
          ]),
        );
      }),
    );
  }
}

// ─── Step 6: Success (Scan 5) ─────────────────────────────────────────────────
class _SuccessStep extends StatelessWidget {
  final ScanController ctrl;
  const _SuccessStep({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(child: Obx(() {
        final r = ctrl.parsedReceipt.value;
        if (r == null) return const SizedBox();
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(height: 48),
            // Success icon
            Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF22C55E).withValues(alpha: 0.1)),
                child: const Icon(Icons.check_circle,
                    color: Color(0xFF22C55E), size: 56)),
            const SizedBox(height: 20),
            Text('Pengeluaran berhasil dicatat',
                style: AppTheme.heading2.copyWith(fontSize: 20),
                textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text(
                'Dan telah aman disimpan pada pencatatan riwayat keuangan Anda.',
                style: AppTheme.body,
                textAlign: TextAlign.center),
            const SizedBox(height: 28),

            // Total card
            _Card(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textGrey,
                                fontFamily: 'InterTight')),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                                color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20)),
                            child: const Text('Sukses',
                                style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF22C55E),
                                    fontFamily: 'InterTight'))),
                      ]),
                  const SizedBox(height: 6),
                  Text(ctrl.formatRupiah(ctrl.effectiveTotal),
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                          fontFamily: 'InterTight')),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(
                        child: _InfoChip(
                            label: 'Item', value: '${r.itemCount} Item')),
                    const SizedBox(width: 10),
                    Expanded(
                        child: _InfoChip(
                            label: 'Kategori',
                            value: ctrl.selectedCategory.value)),
                  ]),
                  const SizedBox(height: 12),
                  // Asal Saldo
                  const Text('Asal Saldo',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textGrey,
                          fontFamily: 'InterTight')),
                  const SizedBox(height: 8),
                  Obx(() => Row(
                          children: ctrl.asalSaldoOptions.map((opt) {
                        final isSel = ctrl.selectedAsalSaldo.value == opt;
                        return GestureDetector(
                          onTap: () => ctrl.selectedAsalSaldo.value = opt,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel
                                  ? AppTheme.primaryBlue
                                  : AppTheme.inputFill,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: isSel
                                      ? AppTheme.primaryBlue
                                      : AppTheme.inputBorder),
                            ),
                            child: Text(opt,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'InterTight',
                                    color: isSel
                                        ? Colors.white
                                        : AppTheme.textGrey)),
                          ),
                        );
                      }).toList())),
                ])),
            const SizedBox(height: 20),

            // Detail card
            _Card(
                child: Column(children: [
              _DetailRow(
                  'Jumlah Transaksi', ctrl.formatRupiah(ctrl.effectiveTotal),
                  valueColor: AppTheme.primaryBlue, large: true),
              const Divider(color: AppTheme.divider, height: 20),
              _DetailRow('Kategori', ctrl.selectedCategory.value,
                  icon: Icons.restaurant_outlined),
              _DetailRow('Nama Toko', r.storeName),
              _DetailRow(
                  'Catatan', r.items.isNotEmpty ? r.items.first.name : '-'),
              _DetailRow('Pembayaran', ctrl.selectedPaymentMethod.value,
                  icon: Icons.account_balance_wallet_outlined),
              _DetailRow(
                  'Tanggal & Waktu',
                  ctrl.selectedDate.value == null
                      ? '-'
                      : '${ctrl.selectedDate.value!.day} Mei ${ctrl.selectedDate.value!.year}\n${ctrl.selectedTime.value}'),
              const SizedBox(height: 4),
            ])),
            const SizedBox(height: 24),

            _Btn(label: 'Simpan', onTap: ctrl.selesai),
            const SizedBox(height: 12),
            _OutBtn(
              label: 'Lihat Detail',
              onTap: () {
                final t = ctrl.lastSavedTransaction.value;
                Get.back();
                if (t != null) {
                  Get.toNamed(AppRoutes.detailTransaksi, arguments: t);
                }
              },
            ),
            const SizedBox(height: 36),
          ]),
        );
      })),
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.inputBorder)),
        child: child,
      );
}

class _FormLabel extends StatelessWidget {
  final String text;
  const _FormLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppTheme.textDark,
          fontFamily: 'InterTight'));
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _SummaryRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'InterTight',
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
                  color: bold ? AppTheme.textDark : AppTheme.textGrey)),
          Text(value,
              style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'InterTight',
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
                  color: bold ? AppTheme.textDark : AppTheme.textDark)),
        ],
      );
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  const _InfoChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: AppTheme.inputFill, borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: AppTheme.bodySmall),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark,
                  fontFamily: 'InterTight')),
        ]),
      );
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final IconData? icon;
  final bool large;
  const _DetailRow(this.label, this.value,
      {this.valueColor, this.icon, this.large = false});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
              child: Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textGrey,
                      fontFamily: 'InterTight'))),
          Row(children: [
            if (icon != null) ...[
              Icon(icon!, size: 14, color: AppTheme.textGrey),
              const SizedBox(width: 4),
            ],
            Text(value,
                style: TextStyle(
                    fontSize: large ? 15 : 13,
                    fontWeight: large ? FontWeight.w700 : FontWeight.w500,
                    color: valueColor ?? AppTheme.textDark,
                    fontFamily: 'InterTight')),
          ]),
        ]),
      );
}

class _Btn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isLoading;
  const _Btn(
      {required this.label, required this.onTap, this.isLoading = false});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 0),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.5, color: Colors.white))
              : Text(label,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'InterTight')),
        ),
      );
}

class _OutBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _OutBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppTheme.inputBorder, width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textGrey,
                  fontFamily: 'InterTight')),
        ),
      );
}
