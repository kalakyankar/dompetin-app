// receipt_ocr_engine.dart
// Parses raw text from MLKit Text Recognition into structured receipt data.
// Works with Indonesian receipts (Struk Belanja).

class ReceiptOcrEngine {
  /// Run OCR on recognized text blocks from MLKit
  static ParsedReceipt parse(String rawText) {
    final lines = rawText
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    return ParsedReceipt(
      storeName: _extractStoreName(lines),
      date: _extractDate(rawText),
      time: _extractTime(rawText),
      items: _extractItems(lines),
      total: _extractTotal(lines),
      subtotal: _extractSubtotal(lines),
      tax: _extractTax(lines),
      discount: _extractDiscount(lines),
      cashGiven: _extractCash(lines),
      change: _extractChange(lines),
      paymentMethod: _extractPaymentMethod(rawText),
      rawText: rawText,
    );
  }

  // ── Store Name ─────────────────────────────────────────────────────────────
  // Usually first 1-3 non-numeric lines at top
  static String _extractStoreName(List<String> lines) {
    for (final line in lines.take(5)) {
      final clean = line.trim();
      if (clean.length < 3) continue;
      if (_isMoneyLine(clean)) continue;
      if (_isDateLine(clean)) continue;
      if (_looksLikeLabel(clean)) continue;
      if (RegExp(r'^\d').hasMatch(clean)) continue;
      return _toTitleCase(clean);
    }
    return 'Tidak Terdeteksi';
  }

  // ── Date ───────────────────────────────────────────────────────────────────
  // Matches: 2/5/2026, 02-05-2026, 2 Mei 2026, 02/05/26
  static DateTime? _extractDate(String text) {
    final patterns = [
      // DD/MM/YYYY or DD-MM-YYYY
      RegExp(r'(\d{1,2})[\/\-\.](\d{1,2})[\/\-\.](\d{2,4})'),
      // DD Mon YYYY (Indonesian months)
      RegExp(r'(\d{1,2})\s+(Jan|Feb|Mar|Apr|Mei|Jun|Jul|Agu|Sep|Okt|Nov|Des)\w*\s+(\d{4})',
          caseSensitive: false),
    ];

    for (final pat in patterns) {
      final m = pat.firstMatch(text);
      if (m == null) continue;
      try {
        if (pat.pattern.contains('Jan|Feb')) {
          final monthMap = {
            'jan': 1, 'feb': 2, 'mar': 3, 'apr': 4, 'mei': 5, 'jun': 6,
            'jul': 7, 'agu': 8, 'sep': 9, 'okt': 10, 'nov': 11, 'des': 12,
          };
          final day = int.parse(m.group(1)!);
          final month = monthMap[m.group(2)!.toLowerCase().substring(0, 3)] ?? 1;
          final year = int.parse(m.group(3)!);
          return DateTime(year, month, day);
        } else {
          final day = int.parse(m.group(1)!);
          final month = int.parse(m.group(2)!);
          var year = int.parse(m.group(3)!);
          if (year < 100) year += 2000;
          return DateTime(year, month, day);
        }
      } catch (_) {}
    }
    return DateTime.now();
  }

  // ── Time ───────────────────────────────────────────────────────────────────
  static String _extractTime(String text) {
    final m = RegExp(r'(\d{1,2}):(\d{2})(?::\d{2})?\s*(WIB|WIT|WITA)?',
        caseSensitive: false).firstMatch(text);
    if (m != null) {
      final tz = m.group(3) ?? 'WIB';
      return '${m.group(1)}:${m.group(2)} $tz';
    }
    return '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')} WIB';
  }

  // ── Items ──────────────────────────────────────────────────────────────────
  // Matches lines like:   3 Croisant Coklat   51.000
  //                       Americano x2        32.000
  //                       1x Teh Tarik        15.000
  static List<ReceiptItem> _extractItems(List<String> lines) {
    final items = <ReceiptItem>[];
    final skipWords = RegExp(
        r'^(total|subtotal|sub total|tunai|cash|kembalian|change|diskon|discount|'
        r'pajak|tax|ppn|service|charge|grand|bayar|payment|metode|pembayaran|'
        r'terima kasih|thank|receipt|struk|no\.|order|meja|table|kasir|cashier)',
        caseSensitive: false);

    for (final line in lines) {
      if (skipWords.hasMatch(line)) continue;
      if (_isDateLine(line) || _isTimeLine(line)) continue;

      // Pattern: [qty x/pcs] name ... price
      final itemPat = RegExp(
          r'^(\d+)\s*[xX×\*]?\s*(.+?)\s+([\d.,]+)\s*$');
      final simplePat = RegExp(
          r'^(.+?)\s{2,}([\d.,]+)\s*$');

      Match? m = itemPat.firstMatch(line);
      if (m != null) {
        final qty = int.tryParse(m.group(1)!) ?? 1;
        final name = m.group(2)!.trim();
        final price = _parseAmount(m.group(3)!);
        if (price > 0 && name.length > 1) {
          items.add(ReceiptItem(name: _toTitleCase(name), qty: qty, unitPrice: price / qty));
        }
        continue;
      }

      m = simplePat.firstMatch(line);
      if (m != null) {
        final name = m.group(1)!.trim();
        final price = _parseAmount(m.group(2)!);
        if (price > 0 && name.length > 1 && !_looksLikeLabel(name)) {
          items.add(ReceiptItem(name: _toTitleCase(name), qty: 1, unitPrice: price));
        }
        continue;
      }
    }
    return items;
  }

  // ── Total ──────────────────────────────────────────────────────────────────
  static double _extractTotal(List<String> lines) {
    // Try explicit "Total", "Grand Total", "Jumlah"
    final totalPat = RegExp(r'(total|grand\s*total|jumlah|amount)',
        caseSensitive: false);
    for (final line in lines) {
      if (totalPat.hasMatch(line)) {
        final amount = _extractAmountFromLine(line);
        if (amount > 0) return amount;
      }
    }
    // Fallback: largest number on receipt
    double max = 0;
    for (final line in lines) {
      final a = _extractAmountFromLine(line);
      if (a > max) max = a;
    }
    return max;
  }

  static double _extractSubtotal(List<String> lines) {
    final pat = RegExp(r'(subtotal|sub\s*total)', caseSensitive: false);
    for (final line in lines) {
      if (pat.hasMatch(line)) {
        final a = _extractAmountFromLine(line);
        if (a > 0) return a;
      }
    }
    return 0;
  }

  static double _extractTax(List<String> lines) {
    final pat = RegExp(r'(pajak|tax|ppn|vat)', caseSensitive: false);
    for (final line in lines) {
      if (pat.hasMatch(line)) {
        final a = _extractAmountFromLine(line);
        if (a > 0) return a;
      }
    }
    return 0;
  }

  static double _extractDiscount(List<String> lines) {
    final pat = RegExp(r'(diskon|discount|potongan)', caseSensitive: false);
    for (final line in lines) {
      if (pat.hasMatch(line)) {
        final a = _extractAmountFromLine(line);
        if (a > 0) return a;
      }
    }
    return 0;
  }

  static double _extractCash(List<String> lines) {
    final pat = RegExp(r'(tunai|cash|bayar)', caseSensitive: false);
    for (final line in lines) {
      if (pat.hasMatch(line)) {
        final a = _extractAmountFromLine(line);
        if (a > 0) return a;
      }
    }
    return 0;
  }

  static double _extractChange(List<String> lines) {
    final pat = RegExp(r'(kembalian|change|kembali)', caseSensitive: false);
    for (final line in lines) {
      if (pat.hasMatch(line)) {
        final a = _extractAmountFromLine(line);
        if (a > 0) return a;
      }
    }
    return 0;
  }

  // ── Payment Method ─────────────────────────────────────────────────────────
  static String _extractPaymentMethod(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('dana')) return 'Dana';
    if (lower.contains('ovo')) return 'OVO';
    if (lower.contains('gopay') || lower.contains('go-pay')) return 'GoPay';
    if (lower.contains('shopeepay') || lower.contains('spay')) return 'ShopeePay';
    if (lower.contains('qris')) return 'QRIS';
    if (lower.contains('debit') || lower.contains('kartu debit')) return 'Kartu Debit';
    if (lower.contains('kredit') || lower.contains('kartu kredit')) return 'Kartu Kredit';
    if (lower.contains('transfer') || lower.contains('bca') ||
        lower.contains('bri') || lower.contains('bni') || lower.contains('mandiri')) { return 'Transfer'; }
    if (lower.contains('tunai') || lower.contains('cash')) { return 'Cash'; }
    return 'Cash';
  }

  // ── Category Detection ─────────────────────────────────────────────────────
  static String detectCategory(String storeName, List<ReceiptItem> items) {
    final allText = '$storeName ${items.map((i) => i.name).join(' ')}'.toLowerCase();

    if (_matches(allText, ['restoran', 'restaurant', 'cafe', 'kafe', 'coffee', 'makan',
        'bakery', 'bakeri', 'donut', 'pizza', 'burger', 'sushi', 'ramen',
        'nasi', 'mie', 'ayam', 'seafood', 'croissant', 'coklat', 'teh', 'kopi',
        'jus', 'minuman', 'snack', 'cemilan', 'waroeng', 'warung', 'warteg'])) {
      return 'Makan & Minum';
    }
    if (_matches(allText, ['indomaret', 'alfamart', 'alfamidi', 'supermarket',
        'hypermart', 'carrefour', 'giant', 'lottemart', 'swalayan', 'market'])) {
      return 'Jajan';
    }
    if (_matches(allText, ['grab', 'gojek', 'ojek', 'taxi', 'taksi', 'bus',
        'kereta', 'bbm', 'bensin', 'pertamax', 'shell', 'parkir'])) {
      return 'Transportasi';
    }
    if (_matches(allText, ['apotek', 'farmasi', 'klinik', 'rumah sakit', 'rs ',
        'obat', 'vitamin', 'medis'])) {
      return 'Kesehatan';
    }
    if (_matches(allText, ['salon', 'skincare', 'skin care', 'kosmetik', 'spa',
        'kecantikan', 'beauty', 'wardah', 'emina', 'maybelline'])) {
      return 'Skincare';
    }
    if (_matches(allText, ['netflix', 'spotify', 'bioskop', 'cinema', 'hiburan',
        'game', 'steam', 'playstation', 'nintendo'])) {
      return 'Hiburan';
    }
    if (_matches(allText, ['listrik', 'pln', 'telkom', 'internet', 'wifi',
        'indihome', 'telkomsel', 'xl', 'tri', 'axis', 'tagihan', 'bill'])) {
      return 'Tagihan';
    }
    if (_matches(allText, ['sewa', 'kos', 'kontrakan', 'rent', 'indekos'])) {
      return 'Sewa';
    }
    return 'Jajan'; // default
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  static bool _matches(String text, List<String> keywords) =>
      keywords.any((k) => text.contains(k));

  static double _parseAmount(String s) {
    // Remove currency symbols, spaces
    final cleaned = s
        .replaceAll(RegExp(r'[RrPp\s]'), '')
        .replaceAll(',', '.')
        .replaceAll('.', '')
        .trim();
    // Handle "51.000" → 51000 by removing dots that are thousands separators
    // If the number ends with exactly 3 digits after last dot → thousands
    final withDots = s.replaceAll(RegExp(r'[RrPp\s]'), '').trim();
    if (RegExp(r'^\d{1,3}(\.\d{3})+$').hasMatch(withDots)) {
      return double.tryParse(withDots.replaceAll('.', '')) ?? 0;
    }
    if (RegExp(r'^\d{1,3}(,\d{3})+$').hasMatch(withDots)) {
      return double.tryParse(withDots.replaceAll(',', '')) ?? 0;
    }
    return double.tryParse(cleaned) ?? 0;
  }

  static double _extractAmountFromLine(String line) {
    final amounts = RegExp(r'[\d]{1,3}(?:[.,]\d{3})*')
        .allMatches(line)
        .map((m) => _parseAmount(m.group(0)!))
        .where((a) => a > 0)
        .toList();
    if (amounts.isEmpty) return 0;
    // Return largest amount (usually price, not qty)
    amounts.sort((a, b) => b.compareTo(a));
    return amounts.first;
  }

  static bool _isMoneyLine(String line) =>
      RegExp(r'^[Rr][Pp]?\s*[\d.,]+').hasMatch(line) ||
      RegExp(r'^[\d.,]{4,}\s*$').hasMatch(line);

  static bool _isDateLine(String line) =>
      RegExp(r'\d{1,2}[\/\-\.]\d{1,2}[\/\-\.]\d{2,4}').hasMatch(line);

  static bool _isTimeLine(String line) =>
      RegExp(r'\d{1,2}:\d{2}').hasMatch(line);

  static bool _looksLikeLabel(String line) {
    final labels = RegExp(
        r'^(no|nama|name|alamat|address|telp|phone|npwp|invoice|receipt|struk|'
        r'kasir|cashier|meja|table|order|pesanan|tanggal|date|waktu|time)',
        caseSensitive: false);
    return labels.hasMatch(line);
  }

  static String _toTitleCase(String s) {
    return s.split(' ').map((w) {
      if (w.isEmpty) return w;
      return w[0].toUpperCase() + w.substring(1).toLowerCase();
    }).join(' ');
  }
}

// ── Data Models ───────────────────────────────────────────────────────────────

class ReceiptItem {
  final String name;
  final int qty;
  final double unitPrice;

  ReceiptItem({required this.name, required this.qty, required this.unitPrice});

  double get total => qty * unitPrice;

  @override
  String toString() => '$qty x $name @ ${unitPrice.toStringAsFixed(0)} = ${total.toStringAsFixed(0)}';
}

class ParsedReceipt {
  final String storeName;
  final DateTime? date;
  final String time;
  final List<ReceiptItem> items;
  final double total;
  final double subtotal;
  final double tax;
  final double discount;
  final double cashGiven;
  final double change;
  final String paymentMethod;
  final String rawText;

  ParsedReceipt({
    required this.storeName,
    required this.date,
    required this.time,
    required this.items,
    required this.total,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.cashGiven,
    required this.change,
    required this.paymentMethod,
    required this.rawText,
  });

  int get itemCount => items.length;

  double get effectiveTotal => total > 0 ? total :
      items.fold(0.0, (s, i) => s + i.total);

  String get detectedCategory =>
      ReceiptOcrEngine.detectCategory(storeName, items);
}
