import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../theme/app_theme.dart';

class InsightScreen extends StatelessWidget {
  const InsightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: Get.back,
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.inputBorder),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: AppTheme.textDark),
          ),
        ),
        title: const Text('Insight',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700,
                color: AppTheme.textDark, fontFamily: 'Poppins')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TotalBalanceCard(ctrl: ctrl),
                const SizedBox(height: 20),
                _DonutChartCard(ctrl: ctrl),
                const SizedBox(height: 20),
                _IncomeSources(ctrl: ctrl),
                const SizedBox(height: 20),
                _ExpenseBreakdown(ctrl: ctrl),
                const SizedBox(height: 20),
                _EmptyInsightWrapper(ctrl: ctrl),
              ],
            ),
          ),
    );
  }
}

// ─── Total Balance Card ───────────────────────────────────────────────────────

class _TotalBalanceCard extends StatelessWidget {
  final HomeController ctrl;
  const _TotalBalanceCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TOTAL BALANCE', style: AppTheme.bodySmall.copyWith(
              letterSpacing: 1.2, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Obx(() => Text(ctrl.formatRupiah(ctrl.totalBalance.value),
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700,
                  color: AppTheme.textDark, fontFamily: 'Poppins'))),
        ],
      ),
    );
  }
}

// ─── Donut Chart Card ─────────────────────────────────────────────────────────

class _DonutChartCard extends StatelessWidget {
  final HomeController ctrl;
  const _DonutChartCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final rate = ctrl.savingsRate;
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.inputBorder),
        ),
        child: Column(
          children: [
            SizedBox(
              width: 180,
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(180, 180),
                    painter: _DonutPainter(
                      progress: rate / 100,
                      color: rate >= 50
                          ? const Color(0xFF22C55E)
                          : rate >= 20
                              ? const Color(0xFFFFCC00)
                              : const Color(0xFFEF4444),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${rate.toStringAsFixed(2)}%',
                          style: const TextStyle(fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textDark, fontFamily: 'Poppins')),
                      Text('tabungan', style: AppTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.3)),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Container(width: 10, height: 10,
                          decoration: const BoxDecoration(
                              color: Color(0xFF22C55E), shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      const Text('Penghasilan', style: TextStyle(fontSize: 11,
                          color: AppTheme.textGrey, fontFamily: 'Poppins')),
                    ]),
                    const SizedBox(height: 4),
                    Text(ctrl.formatRupiah(ctrl.totalIncome),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                            color: Color(0xFF22C55E), fontFamily: 'Poppins')),
                  ]),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Container(width: 10, height: 10,
                          decoration: const BoxDecoration(
                              color: Color(0xFFEF4444), shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      const Text('Pengeluaran', style: TextStyle(fontSize: 11,
                          color: AppTheme.textGrey, fontFamily: 'Poppins')),
                    ]),
                    const SizedBox(height: 4),
                    Text(ctrl.formatRupiah(ctrl.totalExpense),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                            color: Color(0xFFEF4444), fontFamily: 'Poppins')),
                  ]),
                ),
              ),
            ]),
          ],
        ),
      );
    });
  }
}

class _DonutPainter extends CustomPainter {
  final double progress;
  final Color color;
  _DonutPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 16;
    const strokeWidth = 22.0;

    // Background track
    final bgPaint = Paint()
      ..color = const Color(0xFFE4E9F2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) =>
      old.progress != progress || old.color != color;
}

// ─── Income Sources ───────────────────────────────────────────────────────────

class _IncomeSources extends StatelessWidget {
  final HomeController ctrl;
  const _IncomeSources({required this.ctrl});

  static const _categoryIcons = {
    'Gaji': Icons.account_balance_wallet_outlined,
    'Bonus': Icons.card_giftcard_outlined,
    'Bisnis': Icons.storefront_outlined,
    'Freelance': Icons.laptop_outlined,
    'Hadiah': Icons.redeem_outlined,
    'Investasi': Icons.trending_up_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final byCategory = ctrl.incomeByCategory;
      final total = ctrl.totalIncome;
      if (byCategory.isEmpty) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.inputBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Income Sources',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                    color: AppTheme.textDark, fontFamily: 'Poppins')),
            const SizedBox(height: 14),
            ...byCategory.entries.map((e) {
              final pct = total > 0 ? e.value / total : 0.0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(children: [
                  Container(
                    width: 36, height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_categoryIcons[e.key] ?? Icons.attach_money,
                        size: 18, color: const Color(0xFF22C55E)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.key, style: const TextStyle(fontSize: 13,
                              fontWeight: FontWeight.w500, color: AppTheme.textDark,
                              fontFamily: 'Poppins')),
                          Text(ctrl.formatRupiah(e.value),
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                                  color: Color(0xFF22C55E), fontFamily: 'Poppins')),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: pct,
                              backgroundColor: const Color(0xFFE4E9F2),
                              valueColor: const AlwaysStoppedAnimation(Color(0xFF22C55E)),
                              minHeight: 5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('${(pct * 100).toStringAsFixed(0)}%',
                            style: AppTheme.bodySmall.copyWith(fontSize: 10)),
                      ]),
                    ]),
                  ),
                ]),
              );
            }),
          ],
        ),
      );
    });
  }
}

// ─── Expense Breakdown ────────────────────────────────────────────────────────

class _ExpenseBreakdown extends StatelessWidget {
  final HomeController ctrl;
  const _ExpenseBreakdown({required this.ctrl});

  static const _categoryIcons = {
    'Makan & Minum': Icons.restaurant_outlined,
    'Sewa': Icons.home_outlined,
    'Transportasi': Icons.directions_car_outlined,
    'Skincare': Icons.spa_outlined,
    'Kesehatan': Icons.medical_services_outlined,
    'Hiburan': Icons.movie_outlined,
    'Tagihan': Icons.receipt_outlined,
    'Jajan': Icons.fastfood_outlined,
    'Keluarga': Icons.family_restroom_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final byCategory = ctrl.expenseByCategory;
      if (byCategory.isEmpty) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.inputBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Rincian Pengeluaran',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700,
                    color: AppTheme.textDark, fontFamily: 'Poppins')),
            const SizedBox(height: 14),
            ...byCategory.entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(_categoryIcons[e.key] ?? Icons.payments_outlined,
                          size: 18, color: const Color(0xFFEF4444)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(e.key, style: const TextStyle(fontSize: 13,
                              fontWeight: FontWeight.w500, color: AppTheme.textDark,
                              fontFamily: 'Poppins')),
                          Text(ctrl.formatRupiah(e.value),
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                                  color: Color(0xFFEF4444), fontFamily: 'Poppins')),
                        ],
                      ),
                    ),
                  ]),
                )),
          ],
        ),
      );
    });
  }
}

// ─── Empty Insight ────────────────────────────────────────────────────────────

class _EmptyInsightWrapper extends StatelessWidget {
  final HomeController ctrl;
  const _EmptyInsightWrapper({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.transactions.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 40),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.inputBorder),
          ),
          child: Column(children: [
            const Icon(Icons.bar_chart_rounded, size: 56, color: AppTheme.textGrey),
            const SizedBox(height: 12),
            Text('Belum ada data insight', style: AppTheme.heading3),
            const SizedBox(height: 8),
            Text('Mulai catat transaksi untuk melihat\nanalisis keuanganmu',
                style: AppTheme.body, textAlign: TextAlign.center),
          ]),
        );
      }
      return const SizedBox.shrink();
    });
  }
}


