import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/riwayat_controller.dart';
import '../../theme/app_theme.dart';

class DetailTransaksiScreen extends StatelessWidget {
  const DetailTransaksiScreen({super.key});

  // Category icon mapping
  static const _iconMap = {
    'Gaji': Icons.account_balance_wallet_outlined,
    'Bonus': Icons.card_giftcard_outlined,
    'Bisnis': Icons.storefront_outlined,
    'Freelance': Icons.laptop_outlined,
    'Hadiah': Icons.redeem_outlined,
    'Investasi': Icons.trending_up_outlined,
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
    // Transaction passed as argument from Riwayat or Success screens
    final Transaction t = Get.arguments as Transaction;
    final ctrl = RiwayatController();

    final isIncome = t.isIncome;
    final color = isIncome ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
    final catIcon = _iconMap[t.category] ??
        (isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded);

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
                borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 16, color: AppTheme.textDark),
          ),
        ),
        title: const Text('Detail Transaksi',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
                fontFamily: 'InterTight')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          // ── Amount hero card ──────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.inputBorder),
            ),
            child: Column(children: [
              Text('Jumlah Transaksi',
                  style: AppTheme.bodySmall.copyWith(
                      letterSpacing: 0.3, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text(
                '${isIncome ? '' : ''}${ctrl.formatRupiah(t.amount)}',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: isIncome ? AppTheme.textDark : AppTheme.textDark,
                  fontFamily: 'InterTight',
                ),
              ),
              const SizedBox(height: 10),
              // Sukses badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: const [
                  Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 14),
                  SizedBox(width: 4),
                  Text('Sukses',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF22C55E),
                          fontFamily: 'InterTight')),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 16),

          // ── Detail info card ──────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.inputBorder),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Kategori
              _DetailSection(
                label: 'Kategori',
                child: Row(children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(catIcon, size: 16, color: color),
                  ),
                  const SizedBox(width: 10),
                  Text(t.category,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textDark,
                          fontFamily: 'InterTight')),
                ]),
              ),
              const Divider(color: AppTheme.divider, height: 24),

              // Catatan / Nama Instansi
              if (isIncome) ...[
                _DetailRow(
                  leftLabel: 'Nama Instansi',
                  rightLabel: 'Tanggal & Waktu',
                  leftValue: t.note.isEmpty ? t.source : t.note,
                  rightValue:
                      '${ctrl.formatDateShort(t.date)} •\n${ctrl.formatTime(t.date)}',
                  leftIcon: Icons.business_outlined,
                ),
              ] else ...[
                _DetailSection(
                  label: 'Catatan',
                  child: Text(
                    t.note.isEmpty ? t.title : t.note,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textDark,
                        fontFamily: 'InterTight'),
                  ),
                ),
                const Divider(color: AppTheme.divider, height: 24),
                _DetailRow(
                  leftLabel: 'Pembayaran',
                  rightLabel: 'Tanggal & Waktu',
                  leftValue: t.source.isEmpty ? 'Dana' : t.source,
                  rightValue:
                      '${ctrl.formatDateShort(t.date)} •\n${ctrl.formatTime(t.date)}',
                  leftIcon: Icons.account_balance_wallet_outlined,
                ),
              ],
            ]),
          ),
          const SizedBox(height: 28),

          // ── Selesai button ────────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: Get.back,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Selesai',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'InterTight')),
            ),
          ),
        ]),
      ),
    );
  }
}

// ── Detail Section (label + child widget) ─────────────────────────────────────

class _DetailSection extends StatelessWidget {
  final String label;
  final Widget child;
  const _DetailSection({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textGrey,
              fontFamily: 'InterTight',
              fontWeight: FontWeight.w400)),
      const SizedBox(height: 8),
      child,
    ]);
  }
}

// ── Two-column detail row ─────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final String leftValue;
  final String rightValue;
  final IconData? leftIcon;

  const _DetailRow({
    required this.leftLabel,
    required this.rightLabel,
    required this.leftValue,
    required this.rightValue,
    this.leftIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Left
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(leftLabel,
            style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textGrey,
                fontFamily: 'InterTight',
                fontWeight: FontWeight.w400)),
        const SizedBox(height: 6),
        Row(children: [
          if (leftIcon != null) ...[
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(leftIcon!, size: 14, color: AppTheme.primaryBlue),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(leftValue,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textDark,
                    fontFamily: 'InterTight')),
          ),
        ]),
      ])),
      const SizedBox(width: 16),

      // Right
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(rightLabel,
            style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textGrey,
                fontFamily: 'InterTight')),
        const SizedBox(height: 6),
        Text(rightValue,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.textDark,
                fontFamily: 'InterTight',
                height: 1.5)),
      ])),
    ]);
  }
}
