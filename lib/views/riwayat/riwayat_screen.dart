import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/riwayat_controller.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';

class RiwayatScreen extends StatelessWidget {
  const RiwayatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // RiwayatController needs HomeController already registered
    final ctrl = Get.put(RiwayatController());

    return SafeArea(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── Search bar ───────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: TextField(
            onChanged: ctrl.setSearch,
            style: AppTheme.label,
            decoration: InputDecoration(
              hintText: 'Cari transaksi...',
              hintStyle: AppTheme.body.copyWith(fontSize: 13),
              prefixIcon: const Icon(Icons.search_rounded,
                  color: AppTheme.textGrey, size: 20),
              filled: true,
              fillColor: AppTheme.inputFill,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.inputBorder)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.inputBorder)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                      color: AppTheme.primaryBlue, width: 1.5)),
            ),
          ),
        ),

        // ── Filter chips ─────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() => Row(children: [
                _FilterChip(
                  label: 'Semua',
                  isActive: ctrl.activeFilter.value == RiwayatFilter.semua,
                  onTap: () => ctrl.setFilter(RiwayatFilter.semua),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Pemasukan',
                  isActive: ctrl.activeFilter.value == RiwayatFilter.pemasukan,
                  onTap: () => ctrl.setFilter(RiwayatFilter.pemasukan),
                  activeColor: const Color(0xFF22C55E),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Pengeluaran',
                  isActive:
                      ctrl.activeFilter.value == RiwayatFilter.pengeluaran,
                  onTap: () => ctrl.setFilter(RiwayatFilter.pengeluaran),
                  activeColor: const Color(0xFFEF4444),
                ),
              ])),
        ),
        const SizedBox(height: 16),

        // ── Transaction list ─────────────────────────────────────────────────
        Expanded(
          child: Obx(() {
            final transactions = ctrl.filteredTransactions;

            if (transactions.isEmpty) {
              return _EmptyState(
                  filter: ctrl.activeFilter.value,
                  query: ctrl.searchQuery.value);
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: transactions.length + 1, // +1 for header
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text('Transaksi Terakhir', style: AppTheme.heading3),
                  );
                }
                final t = transactions[index - 1];
                return _TransactionTile(
                  transaction: t,
                  ctrl: ctrl,
                  onTap: () => Get.toNamed(
                    AppRoutes.detailTransaksi,
                    arguments: t,
                  ),
                );
              },
            );
          }),
        ),
      ]),
    );
  }
}

// ─── Filter Chip ──────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color activeColor;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.activeColor = AppTheme.primaryBlue,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? activeColor : AppTheme.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? activeColor : AppTheme.inputBorder,
            width: 1.5,
          ),
        ),
        child: Text(label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'InterTight',
              color: isActive ? Colors.white : AppTheme.textGrey,
            )),
      ),
    );
  }
}

// ─── Transaction Tile ─────────────────────────────────────────────────────────

class _TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final RiwayatController ctrl;
  final VoidCallback onTap;

  const _TransactionTile({
    required this.transaction,
    required this.ctrl,
    required this.onTap,
  });

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
    final t = transaction;
    final isIncome = t.isIncome;
    final color = isIncome ? const Color(0xFF22C55E) : const Color(0xFFEF4444);
    final icon = _iconMap[t.category] ??
        (isIncome ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded);

    final h = t.date.hour.toString().padLeft(2, '0');
    final m = t.date.minute.toString().padLeft(2, '0');
    final subtitle = '${t.category} • $h:$m';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.inputBorder),
        ),
        child: Row(children: [
          // Icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),

          // Title + subtitle
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textDark,
                    fontFamily: 'InterTight',
                  )),
              const SizedBox(height: 2),
              Text(subtitle, style: AppTheme.bodySmall),
            ],
          )),

          // Amount
          Text(
            '${isIncome ? '+' : '-'}${ctrl.formatRupiah(t.amount)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
              fontFamily: 'InterTight',
            ),
          ),
        ]),
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final RiwayatFilter filter;
  final String query;
  const _EmptyState({required this.filter, required this.query});

  @override
  Widget build(BuildContext context) {
    final isSearch = query.isNotEmpty;
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(
          isSearch ? Icons.search_off_rounded : Icons.receipt_long_outlined,
          size: 64,
          color: AppTheme.textGrey,
        ),
        const SizedBox(height: 14),
        Text(
          isSearch ? 'Tidak ditemukan' : 'Belum ada transaksi',
          style: AppTheme.heading3,
        ),
        const SizedBox(height: 8),
        Text(
          isSearch
              ? 'Coba kata kunci lain'
              : 'Mulai catat pemasukan atau pengeluaran',
          style: AppTheme.body,
          textAlign: TextAlign.center,
        ),
      ]),
    );
  }
}
