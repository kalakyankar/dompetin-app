import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/dompetin_logo.dart';
import '../target/target_screen.dart';
import '../riwayat/riwayat_screen.dart';
import '../profil/profil_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(HomeController(), permanent: false);
    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      body: Obx(() => _buildBody(ctrl)),
      floatingActionButton: _QrFab(ctrl: ctrl),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(() =>
          _BottomNav(ctrl: ctrl, currentIndex: ctrl.currentTabIndex.value)),
    );
  }

  Widget _buildBody(HomeController ctrl) {
    switch (ctrl.currentTabIndex.value) {
      case 0:
        return _HomeTab(ctrl: ctrl);
      case 1:
        return const TargetScreen();
      case 2:
        return const RiwayatScreen();
      case 3:
        return const ProfilScreen();
      default:
        return _HomeTab(ctrl: ctrl);
    }
  }
}

// ─── Home Tab ─────────────────────────────────────────────────────────────────

class _HomeTab extends StatelessWidget {
  final HomeController ctrl;
  const _HomeTab({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const DompetinLogo(),
                  GestureDetector(
                    onTap: () {},
                    child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: AppTheme.primaryBlue,
                        child: Icon(Icons.person_outline,
                            color: Colors.white, size: 20)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _BalanceCard(ctrl: ctrl)),
            const SizedBox(height: 16),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _TransactionTabBar(ctrl: ctrl)),
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Dompet Digital', style: AppTheme.heading3)),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Obx(() => ctrl.transactions.isEmpty
                  ? _WalletEmpty(ctrl: ctrl)
                  : _WalletFilled(ctrl: ctrl)),
            ),
            const SizedBox(height: 20),

            // Chart (only when has transactions)
            _ChartSection(ctrl: ctrl),

            // Warning banner
            _WarningBanner(ctrl: ctrl),

            // Transaksi Terbaru
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text('Transaksi Terbaru', style: AppTheme.heading3)),
            const SizedBox(height: 12),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _TransactionList(ctrl: ctrl)),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

// ─── Balance Card ─────────────────────────────────────────────────────────────

class _BalanceCard extends StatelessWidget {
  final HomeController ctrl;
  const _BalanceCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A6BFF), Color(0xFF0A3FCC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: AppTheme.primaryBlue.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 8))
        ],
      ),
      child: Stack(children: [
        Positioned(
            right: -20,
            top: -20,
            child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.06)))),
        Positioned(
            right: 10,
            top: 10,
            child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.09)))),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Total Saldo Utama',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 13)),
            Row(children: [
              Icon(Icons.credit_card,
                  color: Colors.white.withValues(alpha: 0.7), size: 20),
              const SizedBox(width: 8),
              Icon(Icons.account_balance_wallet_outlined,
                  color: Colors.white.withValues(alpha: 0.7), size: 20),
            ]),
          ]),
          const SizedBox(height: 8),
          Obx(() => Row(children: [
                Flexible(
                  child: Text(
                    ctrl.isBalanceVisible.value
                        ? ctrl.formatRupiah(ctrl.totalBalance.value)
                        : 'Rp ••••••',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: ctrl.toggleBalanceVisibility,
                  child: Icon(
                    ctrl.isBalanceVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: Colors.white.withValues(alpha: 0.7),
                    size: 18,
                  ),
                ),
              ])),
          const SizedBox(height: 12),
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20)),
              child: Row(children: [
                const Icon(Icons.trending_up,
                    color: Colors.greenAccent, size: 14),
                const SizedBox(width: 4),
                const Text('+10%',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,

                        fontWeight: FontWeight.w600)),
              ]),
            ),
            const SizedBox(width: 8),
            Text('Bulan ini',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 11)),
          ]),
        ]),
      ]),
    );
  }
}

// ─── Transaction Tab Bar ──────────────────────────────────────────────────────

class _TransactionTabBar extends StatelessWidget {
  final HomeController ctrl;
  const _TransactionTabBar({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(children: [
          _TabChip(
              label: 'Pemasukan',
              icon: Icons.arrow_downward_rounded,
              isActive: ctrl.activeTransactionTab.value == 0,
              activeColor: const Color(0xFF22C55E),
              onTap: () => ctrl.switchTransactionTab(0)),
          const SizedBox(width: 12),
          _TabChip(
              label: 'Pengeluaran',
              icon: Icons.arrow_upward_rounded,
              isActive: ctrl.activeTransactionTab.value == 1,
              activeColor: const Color(0xFFEF4444),
              onTap: () => ctrl.switchTransactionTab(1)),
        ]));
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;
  const _TabChip(
      {required this.label,
      required this.icon,
      required this.isActive,
      required this.activeColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color:
                isActive ? activeColor.withValues(alpha: 0.1) : AppTheme.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: isActive ? activeColor : AppTheme.inputBorder,
                width: 1.5),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                    color: isActive ? activeColor : AppTheme.inputBorder,
                    shape: BoxShape.circle),
                child: Icon(icon, size: 14, color: Colors.white)),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isActive ? activeColor : AppTheme.textGrey)),
          ]),
        ),
      ),
    );
  }
}

// ─── Wallet Empty State ───────────────────────────────────────────────────────

class _WalletEmpty extends StatelessWidget {
  final HomeController ctrl;
  const _WalletEmpty({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.inputBorder)),
      child: Column(children: [
        Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
                color: AppTheme.inputFill, shape: BoxShape.circle),
            child: const Icon(Icons.add_outlined,
                size: 28, color: AppTheme.primaryBlue)),
        const SizedBox(height: 16),
        Text('Mulai Perjalananmu', style: AppTheme.heading3),
        const SizedBox(height: 8),
        Text(
            'Masukkan saldo awal untuk memulai pencatatan dan raih kendali penuh atas finansialmu',
            style: AppTheme.body,
            textAlign: TextAlign.center),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => Get.toNamed(AppRoutes.pemasukan),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0),
            child: const Text('Tambah saldo',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ),
        ),
      ]),
    );
  }
}

// ─── Wallet Filled (Home 2 / 4) ───────────────────────────────────────────────

class _WalletFilled extends StatelessWidget {
  final HomeController ctrl;
  const _WalletFilled({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.insight),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.inputBorder)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                              color:
                                  AppTheme.primaryBlue.withValues(alpha: 0.1),
                              shape: BoxShape.circle),
                          child: const Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 16,
                              color: AppTheme.primaryBlue)),
                      const SizedBox(width: 8),
                      const Text('Dana',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textGrey)),
                    ]),
                    const SizedBox(height: 8),
                    Obx(() => Text(ctrl.formatRupiah(ctrl.totalBalance.value),
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark))),
                  ]),
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => _showAddMenu(context),
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.3))),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, color: AppTheme.primaryBlue, size: 22),
                  Text('Tambahkan',
                      style: TextStyle(
                          fontSize: 8,
                          color: AppTheme.primaryBlue,
  
                          fontWeight: FontWeight.w500)),
                ]),
          ),
        ),
      ]),
      const SizedBox(height: 12),
      GestureDetector(
        onTap: () => ctrl.showBatasSheet(context),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.inputBorder)),
          child: Obx(() {
            final hasBatas = ctrl.batasPengeluaran.value > 0;
            return Row(children: [
              Icon(Icons.shield_outlined,
                  color: ctrl.isOverBudget
                      ? const Color(0xFFEF4444)
                      : AppTheme.primaryBlue,
                  size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  hasBatas
                      ? 'Batas: ${ctrl.formatRupiah(ctrl.batasPengeluaran.value)}'
                      : 'Tetapkan Batas Pengeluaran',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: ctrl.isOverBudget
                          ? const Color(0xFFEF4444)
                          : AppTheme.textDark),
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: AppTheme.textGrey, size: 18),
            ]);
          }),
        ),
      ),
    ]);
  }

  void _showAddMenu(BuildContext context) {
    Get.bottomSheet(
      Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Tambah Transaksi',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark)),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.pemasukan);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                      color: const Color(0xFF22C55E).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: const Color(0xFF22C55E).withValues(alpha: 0.4))),
                  child: Column(children: const [
                    Icon(Icons.arrow_downward_rounded,
                        color: Color(0xFF22C55E), size: 28),
                    SizedBox(height: 6),
                    Text('Pemasukan',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF22C55E))),
                  ]),
                ),
              )),
              const SizedBox(width: 12),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.pengeluaran);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.4))),
                  child: Column(children: const [
                    Icon(Icons.arrow_upward_rounded,
                        color: Color(0xFFEF4444), size: 28),
                    SizedBox(height: 6),
                    Text('Pengeluaran',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFEF4444))),
                  ]),
                ),
              )),
            ]),
          ]),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}

// ─── Chart Section ────────────────────────────────────────────────────────────

class _ChartSection extends StatelessWidget {
  final HomeController ctrl;
  const _ChartSection({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.transactions.isEmpty) return const SizedBox();
      final list = ctrl.transactions.toList();
      final income = ctrl.totalIncome;
      final expense = ctrl.totalExpense;
      final isOver = ctrl.isOverBudget;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _ChartContent(
          ctrl: ctrl,
          transactions: list,
          totalIncome: income,
          totalExpense: expense,
          isOverBudget: isOver,
        ),
      );
    });
  }
}

class _ChartContent extends StatelessWidget {
  final HomeController ctrl;
  final List<Transaction> transactions;
  final double totalIncome;
  final double totalExpense;
  final bool isOverBudget;
  const _ChartContent({
    required this.ctrl,
    required this.transactions,
    required this.totalIncome,
    required this.totalExpense,
    required this.isOverBudget,
  });

  @override
  Widget build(BuildContext context) {
    final income = totalIncome;
    final expense = totalExpense;
    final maxVal = income > expense ? income : expense;
    final incomeH = maxVal > 0 ? (income / maxVal) * 90 : 8.0;
    final expenseH = maxVal > 0 ? (expense / maxVal) * 90 : 8.0;
    final isOver = isOverBudget;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.inputBorder)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Pemasukan vs Pengeluaran', style: AppTheme.label),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.insight),
            child:
                const Icon(Icons.more_vert, color: AppTheme.textGrey, size: 20),
          ),
        ]),
        Text('Bulan ini', style: AppTheme.bodySmall),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    height: incomeH.clamp(8.0, 100.0),
                    decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ])),
            const SizedBox(width: 16),
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 600),
                    height: expenseH.clamp(8.0, 100.0),
                    decoration: BoxDecoration(
                        color: isOver
                            ? const Color(0xFFEF4444)
                            : const Color(0xFFFFB3C1),
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ])),
          ]),
        ),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(
              child: Center(
                  child: Text(ctrl.formatRupiah(income),
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF22C55E))))),
          Expanded(
              child: Center(
                  child: Text(ctrl.formatRupiah(expense),
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isOver
                              ? const Color(0xFFEF4444)
                              : const Color(0xFFFFB3C1))))),
        ]),
        const SizedBox(height: 2),
        const Row(children: [
          Expanded(
              child: Center(
                  child: Text('Masuk',
                      style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.textGrey)))),
          Expanded(
              child: Center(
                  child: Text('Keluar',
                      style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.textGrey)))),
        ]),
      ]),
    );
  }
}

// ─── Warning Banner ───────────────────────────────────────────────────────────

class _WarningBanner extends StatelessWidget {
  final HomeController ctrl;
  const _WarningBanner({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!ctrl.isOverBudget || ctrl.isWarningDismissed.value) {
        return const SizedBox();
      }
      final limit = ctrl.batasPengeluaran.value;
      final expense = ctrl.totalExpense;
      final isOver = ctrl.isOverBudget;
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: _WarningContent(
          ctrl: ctrl,
          limit: limit,
          expense: expense,
          isOverBudget: isOver,
        ),
      );
    });
  }
}

class _WarningContent extends StatelessWidget {
  final HomeController ctrl;
  final double limit;
  final double expense;
  final bool isOverBudget;
  const _WarningContent({
    required this.ctrl,
    required this.limit,
    required this.expense,
    required this.isOverBudget,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (expense / limit).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: const Color(0xFFFFF1F1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: const Color(0xFFEF4444).withValues(alpha: 0.4))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.warning_amber_rounded,
              color: Color(0xFFEF4444), size: 18),
          const SizedBox(width: 8),
          const Expanded(
              child: Text('Maksimal Pengeluaran',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFEF4444)))),
          GestureDetector(
              onTap: ctrl.dismissWarning,
              child:
                  const Icon(Icons.close, size: 16, color: Color(0xFFEF4444))),
        ]),
        const SizedBox(height: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Rp 0',
                    style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFFEF4444))),
                Text('Limit: ${ctrl.formatRupiah(limit)}',
                    style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFFEF4444))),
              ]),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFFFD5D5),
              valueColor: const AlwaysStoppedAnimation(Color(0xFFEF4444)),
              minHeight: 8,
            ),
          ),
        ]),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: const Color(0xFFFFE8E8),
              borderRadius: BorderRadius.circular(8)),
          child: Row(children: [
            const Icon(Icons.info_outline, size: 14, color: Color(0xFFEF4444)),
            const SizedBox(width: 6),
            Expanded(
                child: Text(
              'Pengeluaran ${ctrl.formatRupiah(expense)} melebihi batas ${ctrl.formatRupiah(limit)}. Harap kurangi pengeluaran untuk bulan ini.',
              style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFFEF4444)),
            )),
          ]),
        ),
      ]),
    );
  }
}

// ─── Transaction List ─────────────────────────────────────────────────────────

class _TransactionList extends StatelessWidget {
  final HomeController ctrl;
  const _TransactionList({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = ctrl.recentTransactions;
      if (list.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.inputBorder)),
          child: Column(children: [
            const Icon(Icons.history_rounded,
                size: 36, color: AppTheme.textGrey),
            const SizedBox(height: 8),
            Text('Belum ada transaksi', style: AppTheme.body),
          ]),
        );
      }

      return Container(
        decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.inputBorder)),
        child: Column(
          children: list.asMap().entries.map((entry) {
            final i = entry.key;
            final t = entry.value;
            return Column(children: [
              ListTile(
                onTap: () =>
                    Get.toNamed(AppRoutes.detailTransaksi, arguments: t),
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                      color: t.isIncome
                          ? const Color(0xFF22C55E).withValues(alpha: 0.1)
                          : const Color(0xFFEF4444).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(
                    t.isIncome
                        ? Icons.arrow_downward_rounded
                        : Icons.arrow_upward_rounded,
                    color: t.isIncome
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFEF4444),
                    size: 20,
                  ),
                ),
                title: Text(t.title,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,

                        color: AppTheme.textDark)),
                subtitle: Text('${t.category} • ${t.date.day}/${t.date.month}',
                    style: AppTheme.bodySmall),
                trailing: Text(
                  '${t.isIncome ? '+' : '-'}${ctrl.formatRupiah(t.amount)}',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: t.isIncome
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFEF4444)),
                ),
              ),
              if (i < list.length - 1)
                const Divider(
                    height: 1,
                    color: AppTheme.divider,
                    indent: 16,
                    endIndent: 16),
            ]);
          }).toList(),
        ),
      );
    });
  }
}

// ─── Bottom Nav ───────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final HomeController ctrl;
  final int currentIndex;
  const _BottomNav({required this.ctrl, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppTheme.white,
      elevation: 8,
      notchMargin: 6,
      shape: const CircularNotchedRectangle(),
      child: SizedBox(
        height: 64,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _NavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              isActive: currentIndex == 0,
              onTap: () => ctrl.switchTab(0)),
          _NavItem(
              icon: Icons.flag_outlined,
              label: 'Target',
              isActive: currentIndex == 1,
              onTap: () => ctrl.switchTab(1)),
          const SizedBox(width: 48),
          _NavItem(
              icon: Icons.history_rounded,
              label: 'Riwayat',
              isActive: currentIndex == 2,
              onTap: () => ctrl.switchTab(2)),
          _NavItem(
              icon: Icons.person_outline_rounded,
              label: 'Profil',
              isActive: currentIndex == 3,
              onTap: () => ctrl.switchTab(3)),
        ]),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _NavItem(
      {required this.icon,
      required this.label,
      required this.isActive,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon,
              size: 22,
              color: isActive ? AppTheme.primaryBlue : AppTheme.textGrey),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? AppTheme.primaryBlue : AppTheme.textGrey)),
        ]),
      ),
    );
  }
}

// ─── QR FAB ───────────────────────────────────────────────────────────────────

class _QrFab extends StatelessWidget {
  final HomeController ctrl;
  const _QrFab({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showAddMenu(context),
      backgroundColor: AppTheme.primaryBlue,
      elevation: 4,
      child: const Icon(Icons.qr_code_scanner_rounded,
          color: Colors.white, size: 26),
    );
  }

  void _showAddMenu(BuildContext context) {
    Get.bottomSheet(
      Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Tambah Transaksi',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark)),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.pemasukan);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                      color: const Color(0xFF22C55E).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: const Color(0xFF22C55E).withValues(alpha: 0.4))),
                  child: Column(children: const [
                    Icon(Icons.arrow_downward_rounded,
                        color: Color(0xFF22C55E), size: 28),
                    SizedBox(height: 6),
                    Text('Pemasukan',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF22C55E))),
                  ]),
                ),
              )),
              const SizedBox(width: 12),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.pengeluaran);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.4))),
                  child: Column(children: const [
                    Icon(Icons.arrow_upward_rounded,
                        color: Color(0xFFEF4444), size: 28),
                    SizedBox(height: 6),
                    Text('Pengeluaran',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFEF4444))),
                  ]),
                ),
              )),
            ]),
            const SizedBox(height: 12),
            // Scan Struk button
            GestureDetector(
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.scan);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.3))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.document_scanner_outlined,
                          color: AppTheme.primaryBlue, size: 22),
                      SizedBox(width: 8),
                      Text('Scan Struk',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryBlue)),
                    ]),
              ),
            ),
          ]),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
