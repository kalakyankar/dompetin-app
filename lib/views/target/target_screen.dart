import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/target_controller.dart';
import '../../theme/app_theme.dart';

class TargetScreen extends StatelessWidget {
  const TargetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(TargetController());

    return SafeArea(
      child: Obx(() => ctrl.targets.isEmpty
          ? _EmptyState(ctrl: ctrl)
          : _FilledState(ctrl: ctrl)),
    );
  }
}

// ─── Empty State (Target 1) ───────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final TargetController ctrl;
  const _EmptyState({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // AppBar area
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Target', style: AppTheme.heading2),
          const SizedBox(width: 40),
        ]),
      ),

      Expanded(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // Money bag illustration
          Container(
            width: 180,
            height: 180,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0xFFE8F0FF), Color(0xFFF5F8FF)],
                radius: 0.8,
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('💰', style: TextStyle(fontSize: 80)),
            ),
          ),
          const SizedBox(height: 24),
          Text('Tentukan targetmu, mulai menabung\nsekarang.',
              style: AppTheme.body.copyWith(fontSize: 14),
              textAlign: TextAlign.center),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: () => ctrl.showAddTargetSheet(context),
            icon: const Icon(Icons.add, size: 18, color: Colors.white),
            label: const Text('Tambah Target',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                    color: Colors.white, fontFamily: 'Poppins')),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ]),
      ),
    ]);
  }
}

// ─── Filled State (Target 2 / 3) ─────────────────────────────────────────────

class _FilledState extends StatelessWidget {
  final TargetController ctrl;
  const _FilledState({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Balance card (blue)
      _TargetBalanceCard(ctrl: ctrl),
      const SizedBox(height: 20),

      // Target Tabungan header
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Target Tabungan', style: AppTheme.heading3),
          GestureDetector(
            onTap: () => ctrl.showAddTargetSheet(context),
            child: Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.add, color: AppTheme.primaryBlue, size: 18),
            ),
          ),
        ]),
      ),
      const SizedBox(height: 12),

      // Target list
      Expanded(
        child: Obx(() => ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: ctrl.targets.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _TargetCard(ctrl: ctrl, target: ctrl.targets[i]),
            )),
      ),
      const SizedBox(height: 12),
    ]);
  }
}

// ─── Target Balance Card ──────────────────────────────────────────────────────

class _TargetBalanceCard extends StatelessWidget {
  final TargetController ctrl;
  const _TargetBalanceCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A6BFF), Color(0xFF0A3FCC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppTheme.primaryBlue.withOpacity(0.35),
            blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Stack(children: [
        Positioned(right: -10, top: -10,
            child: Container(width: 100, height: 100,
                decoration: BoxDecoration(shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.07)))),
        // Piggy bank icon
        Positioned(right: 16, bottom: 0,
            child: Text('🐷', style: TextStyle(fontSize: 48,
                shadows: [Shadow(color: Colors.black.withOpacity(0.2), blurRadius: 8)]))),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Total Tabungan',
              style: TextStyle(color: Colors.white.withOpacity(0.8),
                  fontSize: 12, fontFamily: 'Poppins')),
          const SizedBox(height: 6),
          Obx(() => Text(ctrl.formatRupiah(ctrl.totalTabungan),
              style: const TextStyle(color: Colors.white, fontSize: 26,
                  fontWeight: FontWeight.w700, fontFamily: 'Poppins'))),
          const SizedBox(height: 12),
          Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(20)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(Icons.show_chart_rounded, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text('${ctrl.activeTargetCount} Target aktif',
                      style: const TextStyle(color: Colors.white, fontSize: 11,
                          fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                ]),
              )),
          const SizedBox(height: 4),
        ]),
      ]),
    );
  }
}

// ─── Target Card ─────────────────────────────────────────────────────────────

class _TargetCard extends StatelessWidget {
  final TargetController ctrl;
  final SavingTarget target;
  const _TargetCard({required this.ctrl, required this.target});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Re-find so Obx reacts to changes
      final t = ctrl.targets.firstWhere((x) => x.id == target.id, orElse: () => target);
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.inputBorder)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header row
          Row(children: [
            Container(width: 40, height: 40,
                decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.savings_outlined, size: 20, color: AppTheme.primaryBlue)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(t.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                  color: AppTheme.textDark, fontFamily: 'Poppins')),
              Row(children: [
                const Icon(Icons.calendar_today_outlined, size: 11, color: AppTheme.textGrey),
                const SizedBox(width: 3),
                Text('${t.targetDate.day}/${t.targetDate.month}/${t.targetDate.year}',
                    style: AppTheme.bodySmall.copyWith(fontSize: 11)),
              ]),
            ])),
            // Options menu
            GestureDetector(
              onTap: () => ctrl.showOptionsPopup(context, t),
              child: const Icon(Icons.more_vert, color: AppTheme.textGrey, size: 20),
            ),
          ]),
          const SizedBox(height: 6),

          // Bank label
          if (t.simpanDi.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(t.simpanDi,
                  style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.primaryBlue, fontWeight: FontWeight.w500)),
            ),

          // Progress bar + pct
          Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('${ctrl.formatRupiah(t.currentAmount)} / ${ctrl.formatRupiah(t.targetAmount)}',
                    style: AppTheme.bodySmall),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: t.progress,
                    backgroundColor: const Color(0xFFE4E9F2),
                    valueColor: AlwaysStoppedAnimation(
                        t.isComplete ? const Color(0xFF22C55E) : AppTheme.primaryBlue),
                    minHeight: 8,
                  ),
                ),
              ]),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => ctrl.showProgressSheet(context, t),
              child: Text('${t.progressPct.toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                      color: AppTheme.primaryBlue, fontFamily: 'Poppins')),
            ),
          ]),
          const SizedBox(height: 12),

          // Tambah / Tarik buttons
          Row(children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => ctrl.showTambahSheet(context, t),
                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                label: const Text('Tambah',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                        color: Colors.white, fontFamily: 'Poppins')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => ctrl.showKurangiSheet(context, t),
                icon: const Icon(Icons.remove, size: 16, color: AppTheme.textGrey),
                label: const Text('Tarik',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                        color: AppTheme.textGrey, fontFamily: 'Poppins')),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.inputBorder),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ]),
        ]),
      );
    });
  }
}
