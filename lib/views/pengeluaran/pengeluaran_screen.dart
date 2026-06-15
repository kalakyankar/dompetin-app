import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../controllers/pengeluaran_controller.dart';
import '../../theme/app_theme.dart';

class PengeluaranScreen extends StatelessWidget {
  const PengeluaranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(PengeluaranController());

    return Scaffold(
      backgroundColor: AppTheme.white,
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
        title: const Text('Pengeluaran',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
                fontFamily: 'InterTight')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount
            _AmountCard(ctrl: ctrl),
            const SizedBox(height: 20),

            // Kategori
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Kategori',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textDark,
                        fontFamily: 'InterTight')),
                Icon(Icons.add, color: AppTheme.primaryBlue, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            _CategoryGrid(ctrl: ctrl),
            const SizedBox(height: 20),

            // Tanggal
            const Text('Tanggal',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textDark,
                    fontFamily: 'InterTight')),
            const SizedBox(height: 10),
            _DatePicker(ctrl: ctrl),
            const SizedBox(height: 20),

            // Catatan
            const Text('Catatan',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textDark,
                    fontFamily: 'InterTight')),
            const SizedBox(height: 10),
            TextField(
              controller: ctrl.catatanController,
              style: AppTheme.label,
              decoration: AppTheme.inputDecoration(hint: 'tulis disini'),
            ),
            const SizedBox(height: 20),

            // Asal Dana
            const Text('Asal Dana',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textDark,
                    fontFamily: 'InterTight')),
            const SizedBox(height: 10),
            _AsalDanaRow(ctrl: ctrl),
            const SizedBox(height: 20),

            // Pengeluaran Rutin toggle
            _RutinToggleRow(ctrl: ctrl),
            const SizedBox(height: 28),

            // Simpan
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

class _AmountCard extends StatelessWidget {
  final PengeluaranController ctrl;
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
          Text('Dana Keluar', style: AppTheme.body),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Rp',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark,
                      fontFamily: 'InterTight')),
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
                      fontFamily: 'InterTight'),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(width: 120, height: 2, color: AppTheme.primaryBlue),
        ],
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final PengeluaranController ctrl;
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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryBlue.withValues(alpha: 0.12)
                            : AppTheme.inputFill,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(cat.icon,
                          size: 20,
                          color: isSelected
                              ? AppTheme.primaryBlue
                              : AppTheme.textGrey),
                    ),
                    const SizedBox(height: 6),
                    Text(cat.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                            color: isSelected
                                ? AppTheme.primaryBlue
                                : AppTheme.textDark,
                            fontFamily: 'InterTight')),
                  ],
                ),
              ),
            );
          },
        ));
  }
}

class _DatePicker extends StatelessWidget {
  final PengeluaranController ctrl;
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
                      ? 'Tanggal'
                      : '${ctrl.selectedDate.value!.day}/${ctrl.selectedDate.value!.month}/${ctrl.selectedDate.value!.year}',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'InterTight',
                      color: ctrl.selectedDate.value == null
                          ? AppTheme.textGrey
                          : AppTheme.textDark),
                ),
                const Icon(Icons.calendar_today_outlined,
                    size: 18, color: AppTheme.textGrey),
              ],
            ),
          ),
        ));
  }
}

class _AsalDanaRow extends StatelessWidget {
  final PengeluaranController ctrl;
  const _AsalDanaRow({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Source options with balance
      final options = [
        {
          'label': 'Dana',
          'icon': Icons.account_balance_wallet_outlined,
          'sub': 'Rp 4.000.000'
        },
        {'label': 'Cash', 'icon': Icons.payments_outlined, 'sub': 'Rp 0'},
      ];
      return Row(
        children: options.map((opt) {
          final isSelected = ctrl.selectedAsalDana.value == opt['label'];
          return Expanded(
            child: GestureDetector(
              onTap: () => ctrl.selectAsalDana(opt['label'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: EdgeInsets.only(right: opt['label'] == 'Dana' ? 10 : 0),
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryBlue.withValues(alpha: 0.06)
                      : AppTheme.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryBlue
                        : AppTheme.inputBorder,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryBlue.withValues(alpha: 0.1)
                            : AppTheme.inputFill,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(opt['icon'] as IconData,
                          size: 18,
                          color: isSelected
                              ? AppTheme.primaryBlue
                              : AppTheme.textGrey),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(opt['label'] as String,
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? AppTheme.primaryBlue
                                      : AppTheme.textDark,
                                  fontFamily: 'InterTight')),
                          Text(opt['sub'] as String,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.textGrey,
                                  fontFamily: 'InterTight')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}

class _RutinToggleRow extends StatelessWidget {
  final PengeluaranController ctrl;
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
                    const Text('Pengeluaran Rutin',
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
                value: ctrl.isPengeluaranRutin.value,
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
