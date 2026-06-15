import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/pemasukan_controller.dart';
import '../../theme/app_theme.dart';

class PemasukanScreen extends StatelessWidget {
  const PemasukanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(PemasukanController());

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
        title: const Text(
          'Pemasukan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.textDark,
            fontFamily: 'InterTight',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount input card
            _AmountCard(ctrl: ctrl),
            const SizedBox(height: 20),

            // Kategori
            _SectionLabel('Kategori'),
            const SizedBox(height: 12),
            _CategoryGrid(ctrl: ctrl),
            const SizedBox(height: 20),

            // Tanggal
            _SectionLabel('Tanggal'),
            const SizedBox(height: 10),
            _DatePicker(ctrl: ctrl),
            const SizedBox(height: 20),

            // Simpan to
            _SectionLabel('Simpan'),
            const SizedBox(height: 10),
            _SimpanRow(ctrl: ctrl),
            const SizedBox(height: 20),

            // Nama Instansi
            _SectionLabel('Nama Instansi'),
            const SizedBox(height: 10),
            TextField(
              controller: ctrl.namaInstansiController,
              style: AppTheme.label,
              decoration: AppTheme.inputDecoration(hint: 'contoh: Dana'),
            ),
            const SizedBox(height: 20),

            // Pemasukan Rutin toggle row
            _RutinToggleRow(ctrl: ctrl),
            const SizedBox(height: 28),

            // Simpan button
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: ctrl.isLoading.value ? null : ctrl.simpan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: ctrl.isLoading.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white)))
                        : const Text('Simpan',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'InterTight')),
                  ),
                )),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(text, style: AppTheme.label);
}

// ─── Amount Card ──────────────────────────────────────────────────────────────

class _AmountCard extends StatelessWidget {
  final PemasukanController ctrl;
  const _AmountCard({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.inputBorder),
      ),
      child: Column(
        children: [
          Text('Dana Masuk', style: AppTheme.body),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Rp',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textDark,
                  fontFamily: 'InterTight',
                ),
              ),
              const SizedBox(width: 12),
              IntrinsicWidth(
                child: TextField(
                  controller: ctrl.amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textDark,
                    fontFamily: 'InterTight',
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: 120,
            height: 2,
            color: AppTheme.primaryBlue,
          ),
        ],
      ),
    );
  }
}

// ─── Category Grid ────────────────────────────────────────────────────────────

class _CategoryGrid extends StatelessWidget {
  final PemasukanController ctrl;
  const _CategoryGrid({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.0,
          ),
          itemCount: ctrl.categories.length,
          itemBuilder: (context, index) {
            final cat = ctrl.categories[index];
            final isSelected = ctrl.selectedCategory.value == cat.label;
            return GestureDetector(
              onTap: () => ctrl.selectCategory(cat.label),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryBlue.withValues(alpha: 0.08)
                      : AppTheme.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryBlue
                        : AppTheme.inputBorder,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryBlue.withValues(alpha: 0.12)
                            : AppTheme.inputFill,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        cat.icon,
                        size: 22,
                        color: isSelected
                            ? AppTheme.primaryBlue
                            : AppTheme.textGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cat.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected
                            ? AppTheme.primaryBlue
                            : AppTheme.textDark,
                        fontFamily: 'InterTight',
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}

// ─── Date Picker ──────────────────────────────────────────────────────────────

class _DatePicker extends StatelessWidget {
  final PemasukanController ctrl;
  const _DatePicker({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: () => ctrl.showCalendarPicker(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.inputFill,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.inputBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ctrl.selectedDate.value == null
                      ? 'Bulan'
                      : '${ctrl.selectedDate.value!.day}/${ctrl.selectedDate.value!.month}/${ctrl.selectedDate.value!.year}',
                  style: TextStyle(
                    fontSize: 14,
                    color: ctrl.selectedDate.value == null
                        ? AppTheme.textGrey
                        : AppTheme.textDark,
                    fontFamily: 'InterTight',
                  ),
                ),
                const Icon(Icons.calendar_today_outlined,
                    size: 18, color: AppTheme.textGrey),
              ],
            ),
          ),
        ));
  }
}

// ─── Simpan Row ───────────────────────────────────────────────────────────────

class _SimpanRow extends StatelessWidget {
  final PemasukanController ctrl;
  const _SimpanRow({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          children: [
            _SimpanCard(
              label: 'Bank',
              icon: Icons.account_balance_outlined,
              isSelected: ctrl.selectedSimpan.value == 'Bank',
              onTap: () => ctrl.selectSimpan('Bank'),
            ),
            const SizedBox(width: 12),
            _SimpanCard(
              label: 'E-Wallet',
              icon: Icons.account_balance_wallet_outlined,
              isSelected: ctrl.selectedSimpan.value == 'E-Wallet',
              onTap: () => ctrl.selectSimpan('E-Wallet'),
            ),
          ],
        ));
  }
}

class _SimpanCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SimpanCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryBlue.withValues(alpha: 0.08)
                : AppTheme.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppTheme.primaryBlue : AppTheme.inputBorder,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryBlue.withValues(alpha: 0.12)
                      : AppTheme.inputFill,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon,
                    size: 22,
                    color:
                        isSelected ? AppTheme.primaryBlue : AppTheme.textGrey),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppTheme.primaryBlue : AppTheme.textDark,
                  fontFamily: 'InterTight',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Rutin Toggle Row ─────────────────────────────────────────────────────────

class _RutinToggleRow extends StatelessWidget {
  final PemasukanController ctrl;
  const _RutinToggleRow({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.inputBorder),
      ),
      child: Obx(() => Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.repeat_rounded,
                    size: 20, color: AppTheme.primaryBlue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Pemasukan Rutin',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textDark,
                            fontFamily: 'InterTight')),
                    Text('Ulangi setiap bulan', style: AppTheme.bodySmall),
                  ],
                ),
              ),
              Switch(
                value: ctrl.isPemasukanRutin.value,
                onChanged: (v) {
                  ctrl.toggleRutin(v);
                  if (v) ctrl.showRutinSheet(context);
                },
                activeThumbColor: AppTheme.primaryBlue,
              ),
            ],
          )),
    );
  }
}
