import 'package:dompetin_app/app/routes/app_routes.dart';
import 'package:dompetin_app/app/themes/app_theme.dart';
import 'package:dompetin_app/modules/home/home_controller.dart';
import 'package:dompetin_app/widgets/dompetinlogo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(HomeController());

    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      body: Obx(() => _buildBody(ctrl)),
      floatingActionButton: _QrFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _BottomNav(ctrl: ctrl),
    );
  }

  Widget _buildBody(HomeController ctrl) {
    switch (ctrl.currentTabIndex.value) {
      case 0:
        return _HomeTab(ctrl: ctrl);
      case 1:
        return _PlaceholderTab(title: 'Target', icon: Icons.flag_outlined);
      case 2:
        return _PlaceholderTab(title: 'Riwayat', icon: Icons.history_rounded);
      case 3:
        return _PlaceholderTab(
          title: 'Profil',
          icon: Icons.person_outline_rounded,
        );
      default:
        return _HomeTab(ctrl: ctrl);
    }
  }
}

// ─── Home Tab ────────────────────────────────────────────────────────────────

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
            // Top bar
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
                      child: Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Balance card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _BalanceCard(ctrl: ctrl),
            ),
            const SizedBox(height: 16),

            // Pemasukan / Pengeluaran toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _TransactionTabBar(ctrl: ctrl),
            ),
            const SizedBox(height: 20),

            // Dompet Digital section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Dompet Digital', style: AppTheme.heading3),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _WalletCard(ctrl: ctrl),
            ),
            const SizedBox(height: 20),

            // Transaksi Terakhir
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Transaksi Terakhir', style: AppTheme.heading3),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _TransactionList(ctrl: ctrl),
            ),
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
            color: AppTheme.primaryBlue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Globe decoration
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            right: 10,
            top: 10,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Saldo Utama',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                      fontFamily: 'Inter ',
                    ),
                  ),
                  // Card icons
                  Row(
                    children: [
                      Icon(
                        Icons.credit_card,
                        color: Colors.white.withOpacity(0.7),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        color: Colors.white.withOpacity(0.7),
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Obx(
                () => Row(
                  children: [
                    Text(
                      ctrl.isBalanceVisible.value
                          ? ctrl.formatRupiah(ctrl.totalBalance.value)
                          : 'Rp ••••••',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: ctrl.toggleBalanceVisibility,
                      child: Icon(
                        ctrl.isBalanceVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.white.withOpacity(0.7),
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.trending_up,
                          color: Colors.greenAccent,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '+10%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Bulan ini',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 11,
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Transaction Tab Bar ──────────────────────────────────────────────────────

class _TransactionTabBar extends StatelessWidget {
  final HomeController ctrl;
  const _TransactionTabBar({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: [
          _TabChip(
            label: 'Pemasukan',
            icon: Icons.arrow_downward_rounded,
            isActive: ctrl.activeTransactionTab.value == 0,
            activeColor: const Color(0xFF22C55E),
            onTap: () => ctrl.switchTransactionTab(0),
          ),
          const SizedBox(width: 12),
          _TabChip(
            label: 'Pengeluaran',
            icon: Icons.arrow_upward_rounded,
            isActive: ctrl.activeTransactionTab.value == 1,
            activeColor: const Color(0xFFEF4444),
            onTap: () => ctrl.switchTransactionTab(1),
          ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? activeColor.withOpacity(0.1) : AppTheme.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? activeColor : AppTheme.inputBorder,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isActive ? activeColor : AppTheme.inputBorder,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? activeColor : AppTheme.textGrey,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Wallet Card ──────────────────────────────────────────────────────────────

class _WalletCard extends StatelessWidget {
  final HomeController ctrl;
  const _WalletCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasTransactions = ctrl.transactions.isNotEmpty;
      if (!hasTransactions) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.inputBorder),
          ),
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.inputFill,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_outlined,
                  size: 28,
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: 16),
              Text('Mulai Perjalananmu', style: AppTheme.heading3),
              const SizedBox(height: 8),
              Text(
                'Masukkan saldo awal untuk memulai pencatatan dan raih kendali penuh atas finansialmu',
                style: AppTheme.body,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(AppRoutes.pemasukan),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Tambah saldo',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      // Has transactions - show balance summary
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.inputBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: _WalletStat(
                label: 'Pemasukan',
                amount: ctrl.formatRupiah(ctrl.totalIncome),
                color: const Color(0xFF22C55E),
                icon: Icons.arrow_downward_rounded,
              ),
            ),
            Container(width: 1, height: 48, color: AppTheme.divider),
            Expanded(
              child: _WalletStat(
                label: 'Pengeluaran',
                amount: ctrl.formatRupiah(ctrl.totalExpense),
                color: const Color(0xFFEF4444),
                icon: Icons.arrow_upward_rounded,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _WalletStat extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;
  final IconData icon;

  const _WalletStat({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(height: 6),
        Text(label, style: AppTheme.bodySmall),
        const SizedBox(height: 2),
        Text(
          amount,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color,
            fontFamily: 'Inter',
          ),
        ),
      ],
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
      final list = ctrl.filteredTransactions;
      if (list.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.inputBorder),
          ),
          child: Column(
            children: [
              const Icon(
                Icons.history_rounded,
                size: 36,
                color: AppTheme.textGrey,
              ),
              const SizedBox(height: 8),
              Text('Belum ada transaksi', style: AppTheme.body),
            ],
          ),
        );
      }

      return Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.inputBorder),
        ),
        child: Column(
          children: list.asMap().entries.map((entry) {
            final i = entry.key;
            final t = entry.value;
            return Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: t.isIncome
                          ? const Color(0xFF22C55E).withOpacity(0.1)
                          : const Color(0xFFEF4444).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                  title: Text(
                    t.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                      color: AppTheme.textDark,
                    ),
                  ),
                  subtitle: Text(t.category, style: AppTheme.bodySmall),
                  trailing: Text(
                    '${t.isIncome ? '+' : '-'}${ctrl.formatRupiah(t.amount)}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: t.isIncome
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFEF4444),
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
                if (i < list.length - 1)
                  const Divider(
                    height: 1,
                    color: AppTheme.divider,
                    indent: 16,
                    endIndent: 16,
                  ),
              ],
            );
          }).toList(),
        ),
      );
    });
  }
}

// ─── Placeholder Tabs ─────────────────────────────────────────────────────────

class _PlaceholderTab extends StatelessWidget {
  final String title;
  final IconData icon;
  const _PlaceholderTab({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: AppTheme.textGrey),
          const SizedBox(height: 16),
          Text(title, style: AppTheme.heading2),
          const SizedBox(height: 8),
          Text('Segera hadir', style: AppTheme.body),
        ],
      ),
    );
  }
}

// ─── Bottom Nav ───────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  final HomeController ctrl;
  const _BottomNav({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BottomAppBar(
        color: AppTheme.white,
        elevation: 8,
        notchMargin: 6,
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isActive: ctrl.currentTabIndex.value == 0,
                onTap: () => ctrl.switchTab(0),
              ),
              _NavItem(
                icon: Icons.flag_outlined,
                label: 'Target',
                isActive: ctrl.currentTabIndex.value == 1,
                onTap: () => ctrl.switchTab(1),
              ),
              const SizedBox(width: 48), // FAB gap
              _NavItem(
                icon: Icons.history_rounded,
                label: 'Riwayat',
                isActive: ctrl.currentTabIndex.value == 2,
                onTap: () => ctrl.switchTab(2),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                label: 'Profil',
                isActive: ctrl.currentTabIndex.value == 3,
                onTap: () => ctrl.switchTab(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive ? AppTheme.primaryBlue : AppTheme.textGrey,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppTheme.primaryBlue : AppTheme.textGrey,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── QR FAB ───────────────────────────────────────────────────────────────────

class _QrFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: AppTheme.primaryBlue,
      elevation: 4,
      child: const Icon(
        Icons.qr_code_scanner_rounded,
        color: Colors.white,
        size: 26,
      ),
    );
  }
}
