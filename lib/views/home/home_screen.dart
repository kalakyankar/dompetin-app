import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_theme.dart';
import '../../widgets/dompetin_logo.dart';
import '../target/target_screen.dart';
import '../riwayat/riwayat_screen.dart';
import '../profil/profil_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeController ctrl;

  @override
  void initState() {
    super.initState();
    ctrl = Get.find<HomeController>();
    ctrl.seedDummyData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.offWhite,
      body: Obx(() => IndexedStack(
        index: ctrl.currentTabIndex.value,
        children: [
          _HomeTab(ctrl: ctrl),
          const TargetScreen(),
          const RiwayatScreen(),
          const ProfilScreen(),
        ],
      )),
      floatingActionButton: _QrFab(ctrl: ctrl),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(() =>
          _BottomNav(ctrl: ctrl, currentIndex: ctrl.currentTabIndex.value)),
    );
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
                child: _ActionButtons(ctrl: ctrl)),
            const SizedBox(height: 24),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _SectionHeader(title: 'Dompet Digital')),
            const SizedBox(height: 12),
            _WalletSection(ctrl: ctrl),
            const SizedBox(height: 24),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _ChartCard(ctrl: ctrl)),
            const SizedBox(height: 16),
            _WarningBanner(ctrl: ctrl),
            const SizedBox(height: 16),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _SectionHeader(title: 'Transaksi Terbaru')),
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

// ─── Section Header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTheme.heading3);
  }
}

// ─── Balance Card ──────────────────────────────────────────────────────────────

class _BalanceCard extends StatelessWidget {
  final HomeController ctrl;
  const _BalanceCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A6BFF), Color(0xFF0A3FCC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
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
                        ? ctrl.formatRupiah(ctrl.totalBalance)
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

// ─── Action Buttons (Pemasukan / Pengeluaran) ────────────────────────────────

class _ActionButtons extends StatelessWidget {
  final HomeController ctrl;
  const _ActionButtons({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: _ActionChip(
          label: 'Pemasukan',
          icon: Icons.arrow_downward_rounded,
          color: const Color(0xFF22C55E),
          onTap: () => Get.toNamed(AppRoutes.pemasukan),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: _ActionChip(
          label: 'Pengeluaran',
          icon: Icons.arrow_upward_rounded,
          color: const Color(0xFFEF4444),
          onTap: () => Get.toNamed(AppRoutes.pengeluaran),
        ),
      ),
    ]);
  }
}

class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionChip(
      {required this.label,
      required this.icon,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.inputBorder),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, size: 16, color: color)),
          const SizedBox(width: 8),
          Text(label,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color)),
        ]),
      ),
    );
  }
}

// ─── Wallet Section ────────────────────────────────────────────────────────────

class _WalletSection extends StatelessWidget {
  final HomeController ctrl;
  const _WalletSection({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const horizontalPadding = 20.0;
    final availableWidth = screenWidth - horizontalPadding * 2;
    // 3 columns on phones, 4 on larger screens
    final crossAxisCount = screenWidth > 600 ? 4 : 3;
    const spacing = 10.0;
    final totalSpacing = spacing * (crossAxisCount - 1);
    final childWidth = (availableWidth - totalSpacing) / crossAxisCount;

    return Obx(() {
      final list = ctrl.wallets.toList();
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            ...list.map((w) => _WalletCard(
                  width: childWidth,
                  name: w.name,
                  balance: w.balance,
                  icon: w.icon,
                  color: w.color,
                  formatRupiah: ctrl.formatRupiah,
                  onTap: () {},
                )),
            _WalletAddCard(
              width: childWidth,
              onTap: () => _showAddWalletSheet(context, ctrl),
            ),
          ],
        ),
      );
    });
  }

  void _showAddWalletSheet(BuildContext context, HomeController ctrl) {
    Get.bottomSheet(
      _AddWalletSheet(ctrl: ctrl),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

class _WalletCard extends StatelessWidget {
  final double width;
  final String name;
  final double balance;
  final IconData icon;
  final Color color;
  final String Function(double) formatRupiah;
  final VoidCallback onTap;
  const _WalletCard({
    required this.width,
    required this.name,
    required this.balance,
    required this.icon,
    required this.color,
    required this.formatRupiah,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.inputBorder),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 8),
          Text(name,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textDark),
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(formatRupiah(balance),
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color),
              overflow: TextOverflow.ellipsis),
        ]),
      ),
    );
  }
}

class _WalletAddCard extends StatelessWidget {
  final double width;
  final VoidCallback onTap;
  const _WalletAddCard({required this.width, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: AppTheme.primaryBlue.withValues(alpha: 0.25),
              style: BorderStyle.solid),
        ),
        child: Column(children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                const Icon(Icons.add, size: 22, color: AppTheme.primaryBlue),
          ),
          const SizedBox(height: 8),
          const Text('Tambahkan',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryBlue)),
          const SizedBox(height: 4),
          const Text('Dompet',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textGrey)),
        ]),
      ),
    );
  }
}

// ─── Add Wallet Bottom Sheet ──────────────────────────────────────────────────

class _AddWalletSheet extends StatefulWidget {
  final HomeController ctrl;
  const _AddWalletSheet({required this.ctrl});

  @override
  State<_AddWalletSheet> createState() => _AddWalletSheetState();
}

class _AddWalletSheetState extends State<_AddWalletSheet> {
  final nameController = TextEditingController();
  final balanceController = TextEditingController();
  IconData selectedIcon = Icons.account_balance_wallet_outlined;
  Color selectedColor = AppTheme.primaryBlue;
  bool isCustom = false;

  @override
  void dispose() {
    nameController.dispose();
    balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Tambah Dompet Digital',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark)),
              GestureDetector(
                onTap: Get.back,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                      color: Color(0xFFF5F7FF), shape: BoxShape.circle),
                  child: const Icon(Icons.close, size: 14, color: AppTheme.textDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Quick select presets
          const Text('Pilih Dompet',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textDark)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: walletPresets.map((preset) {
              final pName = preset['name'] as String;
              final pIcon = preset['icon'] as IconData;
              final pColor = preset['color'] as Color;
              final isSelected = nameController.text == pName;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    nameController.text = pName;
                    selectedIcon = pIcon;
                    selectedColor = pColor;
                    isCustom = false;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? pColor.withValues(alpha: 0.1)
                        : const Color(0xFFF7F9FC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? pColor : const Color(0xFFE4E9F2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(pIcon, size: 16, color: pColor),
                      const SizedBox(width: 6),
                      Text(pName,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color:
                                  isSelected ? pColor : AppTheme.textDark)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          // Custom name
          GestureDetector(
            onTap: () => setState(() => isCustom = true),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isCustom
                    ? AppTheme.primaryBlue.withValues(alpha: 0.06)
                    : const Color(0xFFF7F9FC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCustom
                      ? AppTheme.primaryBlue
                      : const Color(0xFFE4E9F2),
                ),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.edit_outlined,
                        size: 16, color: AppTheme.primaryBlue),
                    SizedBox(width: 6),
                    Text('Kustom',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryBlue)),
                  ]),
            ),
          ),

          if (isCustom) ...[
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              style: const TextStyle(fontSize: 14),
              decoration: AppTheme.inputDecoration(
                hint: 'Nama dompet',
                prefixIcon: Icon(selectedIcon, size: 18, color: selectedColor),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Saldo Awal
          const Text('Saldo Awal (opsional)',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textDark)),
          const SizedBox(height: 8),
          Row(children: [
            const Text('Rp ',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark)),
            Expanded(
              child: TextField(
                controller: balanceController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: '0',
                  hintStyle: TextStyle(color: Color(0xFF8F95B2)),
                ),
              ),
            ),
          ]),
          const Divider(color: AppTheme.primaryBlue, thickness: 1.5),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isEmpty) {
                  Get.snackbar('Oops', 'Masukkan nama dompet',
                      snackPosition: SnackPosition.TOP);
                  return;
                }
                final balance = double.tryParse(
                        balanceController.text
                            .replaceAll('.', '')
                            .replaceAll(',', '')) ??
                    0;
                widget.ctrl.addWallet(DigitalWallet(
                  name: name,
                  balance: balance,
                  icon: selectedIcon,
                  color: selectedColor,
                ));
                Get.back();
                Get.snackbar(
                  'Berhasil!',
                  'Dompet $name berhasil ditambahkan',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: AppTheme.primaryBlue,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Tambah Dompet',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
            ),
          ),
        ]),
      ),
    );
  }
}

// ─── Chart Card (Income vs Expense) ───────────────────────────────────────────

class _ChartCard extends StatelessWidget {
  final HomeController ctrl;
  const _ChartCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ctrl.transactions.isEmpty) return const SizedBox();
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.inputBorder),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Pemasukan vs Pengeluaran', style: AppTheme.label),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.insight),
              child: const Icon(Icons.more_vert,
                  color: AppTheme.textGrey, size: 20),
            ),
          ]),
          Text('Bulan ini', style: AppTheme.bodySmall),
          const SizedBox(height: 16),
          _buildChartBars(ctrl),
        ]),
      );
    });
  }

  Widget _buildChartBars(HomeController ctrl) {
    final income = ctrl.totalIncome;
    final expense = ctrl.totalExpense;
    final maxVal = income > expense ? income : expense;
    final incomeH = maxVal > 0 ? (income / maxVal) * 90 : 8.0;
    final expenseH = maxVal > 0 ? (expense / maxVal) * 90 : 8.0;

    return Column(children: [
      SizedBox(
        height: 100,
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  width: 40,
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
                  width: 40,
                  height: expenseH.clamp(8.0, 100.0),
                  decoration: BoxDecoration(
                      color: income > expense
                          ? const Color(0xFFFFB3C1)
                          : const Color(0xFFEF4444),
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
                        color: income > expense
                            ? const Color(0xFFFFB3C1)
                            : const Color(0xFFEF4444))))),
      ]),
      const SizedBox(height: 2),
      const Row(children: [
        Expanded(
            child: Center(
                child: Text('Masuk',
                    style: TextStyle(
                        fontSize: 10, color: AppTheme.textGrey)))),
        Expanded(
            child: Center(
                child: Text('Keluar',
                    style: TextStyle(
                        fontSize: 10, color: AppTheme.textGrey)))),
      ]),
    ]);
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
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: _buildWarning(ctrl),
      );
    });
  }

  Widget _buildWarning(HomeController ctrl) {
    final limit = ctrl.batasPengeluaran.value;
    final expense = ctrl.totalExpense;
    final progress = (expense / limit).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFFEF4444).withValues(alpha: 0.4)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.warning_amber_rounded,
              color: Color(0xFFEF4444), size: 20),
          const SizedBox(width: 8),
          const Expanded(
              child: Text('Maksimal Pengeluaran',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFEF4444)))),
          GestureDetector(
              onTap: ctrl.dismissWarning,
              child: const Icon(Icons.close,
                  size: 18, color: Color(0xFFEF4444))),
        ]),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(ctrl.formatRupiah(expense),
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFEF4444))),
          Text('Limit: ${ctrl.formatRupiah(limit)}',
              style: const TextStyle(
                  fontSize: 12, color: Color(0xFFEF4444))),
        ]),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFFFD5D5),
            valueColor: const AlwaysStoppedAnimation(Color(0xFFEF4444)),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: const Color(0xFFFFE8E8),
              borderRadius: BorderRadius.circular(8)),
          child: Row(children: [
            const Icon(Icons.info_outline,
                size: 14, color: Color(0xFFEF4444)),
            const SizedBox(width: 6),
            Expanded(
                child: Text(
              'Pengeluaran ${ctrl.formatRupiah(expense)} melebihi batas ${ctrl.formatRupiah(limit)}. Harap kurangi pengeluaran untuk bulan ini.',
              style: const TextStyle(fontSize: 11, color: Color(0xFFEF4444)),
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
          padding: const EdgeInsets.symmetric(vertical: 32),
          decoration: BoxDecoration(
              color: Colors.white,
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.inputBorder),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4)),
          ],
        ),
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
                subtitle: Text(t.category,
                    style: AppTheme.bodySmall),
                trailing: Text(
                  '${t.isIncome ? '+' : '-'}${ctrl.formatRupiah(t.amount)}',
                  style: TextStyle(
                      fontSize: 13,
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
      color: Colors.white,
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
