import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/receipt_ocr_engine.dart';
import 'home_controller.dart';

export '../utils/receipt_ocr_engine.dart' show ParsedReceipt, ReceiptItem;

enum ScanStep { permission, intro, camera, analyzing, result, success }

class ScanController extends GetxController {
  // ── Step ───────────────────────────────────────────────────────────────────
  final currentStep = ScanStep.permission.obs;
  final isAnalyzing = false.obs;
  final analysisProgress = 0.0.obs;
  final analysisStatus = 'Memindai struk...'.obs;
  final ocrError = ''.obs;

  // ── Camera ─────────────────────────────────────────────────────────────────
  CameraController? cameraController;
  final isCameraReady = false.obs;
  final hasCameraPermission = false.obs;
  final scannedImagePath = ''.obs;

  // ── OCR Result (raw parsed) ────────────────────────────────────────────────
  final parsedReceipt = Rxn<ParsedReceipt>();

  // ── Editable form fields ───────────────────────────────────────────────────
  final nameController = TextEditingController();
  final catatanController = TextEditingController();
  final selectedCategory = 'Makan & Minum'.obs;
  final selectedDate = Rxn<DateTime>();
  final selectedTime = ''.obs;
  final selectedPaymentMethod = 'Cash'.obs;
  final selectedAsalSaldo = 'Dana'.obs;
  final isSaving = false.obs;
  final lastSavedTransaction = Rxn<Transaction>();

  // ── Editable items list ────────────────────────────────────────────────────
  final editableItems = <ReceiptItem>[].obs;

  final List<String> categories = [
    'Makan & Minum', 'Sewa', 'Transportasi', 'Skincare',
    'Kesehatan', 'Hiburan', 'Tagihan', 'Jajan', 'Keluarga',
  ];
  final List<String> paymentMethods = [
    'Cash', 'Dana', 'OVO', 'GoPay', 'ShopeePay',
    'QRIS', 'Kartu Debit', 'Kartu Kredit', 'Transfer'
  ];
  final List<String> asalSaldoOptions = ['Dana', 'Cash', 'Bank'];

  // ── MLKit recognizer ───────────────────────────────────────────────────────
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  @override
  void onInit() {
    super.onInit();
    _checkPermission();
  }

  // ── Permission ─────────────────────────────────────────────────────────────
  Future<void> _checkPermission() async {
    final status = await Permission.camera.status;
    hasCameraPermission.value = status.isGranted;
    if (status.isGranted) currentStep.value = ScanStep.intro;
  }

  Future<void> requestPermission() async {
    final status = await Permission.camera.request();
    hasCameraPermission.value = status.isGranted;
    if (status.isGranted) {
      currentStep.value = ScanStep.intro;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    } else {
      Get.snackbar('Izin Ditolak',
          'Izin kamera diperlukan untuk scan struk',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white);
    }
  }

  void skipPermission() => Get.back();

  // ── Intro ──────────────────────────────────────────────────────────────────
  Future<void> startScan() async {
    currentStep.value = ScanStep.camera;
    await _initCamera();
  }

  void skipIntro() => Get.back();

  // ── Camera ─────────────────────────────────────────────────────────────────
  Future<void> _initCamera() async {
    try {
      final cams = await availableCameras();
      if (cams.isEmpty) return;
      final ctrl = CameraController(
        cams.first,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await ctrl.initialize();
      cameraController = ctrl;
      isCameraReady.value = true;
    } catch (e) {
      // Emulator fallback — camera step still shows, capture will use mock
    }
  }

  Future<void> capturePhoto() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      _startAnalysisWithPath(null);
      return;
    }
    try {
      final file = await cameraController!.takePicture();
      scannedImagePath.value = file.path;
      _startAnalysisWithPath(file.path);
    } catch (_) {
      _startAnalysisWithPath(null);
    }
  }

  Future<void> pickFromGallery() async {
    final picked = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (picked == null) return;
    scannedImagePath.value = picked.path;
    _startAnalysisWithPath(picked.path);
  }

  // ── Analysis — Real OCR ────────────────────────────────────────────────────
  Future<void> _startAnalysisWithPath(String? imagePath) async {
    currentStep.value = ScanStep.analyzing;
    isAnalyzing.value = true;
    analysisProgress.value = 0.0;
    ocrError.value = '';

    try {
      // Step 1: load image
      _setProgress(0.1, 'Memuat gambar...');

      String rawText = '';

      if (imagePath != null && File(imagePath).existsSync()) {
        // ── Real OCR with MLKit ───────────────────────────────────────────
        _setProgress(0.25, 'Menjalankan OCR...');
        final inputImage = InputImage.fromFilePath(imagePath);

        _setProgress(0.40, 'Mendeteksi teks...');
        final recognized = await _textRecognizer.processImage(inputImage);

        _setProgress(0.60, 'Membaca baris struk...');
        rawText = recognized.text;

        _setProgress(0.75, 'Menganalisa item & harga...');
        await Future.delayed(const Duration(milliseconds: 200));
      } else {
        // ── Demo mode (emulator / no image) ──────────────────────────────
        _setProgress(0.40, 'Mode demo aktif...');
        await Future.delayed(const Duration(milliseconds: 600));
        rawText = _demoReceiptText();
      }

      _setProgress(0.85, 'Menghitung total...');
      final parsed = ReceiptOcrEngine.parse(rawText);

      _setProgress(0.95, 'Memformat hasil...');
      await Future.delayed(const Duration(milliseconds: 200));

      // Populate form
      _applyParsedResult(parsed);
      _setProgress(1.0, 'Selesai!');
      await Future.delayed(const Duration(milliseconds: 300));

      isAnalyzing.value = false;
      currentStep.value = ScanStep.result;
    } catch (e) {
      isAnalyzing.value = false;
      ocrError.value = e.toString();
      // Still go to result with empty form
      _applyParsedResult(ParsedReceipt(
        storeName: 'Tidak Terdeteksi',
        date: DateTime.now(),
        time: '${DateTime.now().hour}:${DateTime.now().minute} WIB',
        items: [],
        total: 0,
        subtotal: 0,
        tax: 0,
        discount: 0,
        cashGiven: 0,
        change: 0,
        paymentMethod: 'Cash',
        rawText: '',
      ));
      currentStep.value = ScanStep.result;
    }
  }

  void _setProgress(double value, String status) {
    analysisProgress.value = value;
    analysisStatus.value = status;
  }

  void _applyParsedResult(ParsedReceipt parsed) {
    parsedReceipt.value = parsed;
    nameController.text = parsed.storeName;
    catatanController.text = parsed.items.isNotEmpty
        ? parsed.items.map((i) => '${i.qty}x ${i.name}').join(', ')
        : '';
    selectedCategory.value = parsed.detectedCategory;
    selectedDate.value = parsed.date ?? DateTime.now();
    selectedTime.value = parsed.time;
    selectedPaymentMethod.value = parsed.paymentMethod;
    editableItems.assignAll(parsed.items);
  }

  // ── Retake ─────────────────────────────────────────────────────────────────
  void retake() {
    parsedReceipt.value = null;
    scannedImagePath.value = '';
    analysisProgress.value = 0;
    editableItems.clear();
    currentStep.value = ScanStep.camera;
  }

  void batalkan() => Get.back();

  // ── Save ───────────────────────────────────────────────────────────────────
  Future<void> lanjutkan() async {
    final receipt = parsedReceipt.value;
    if (receipt == null) return;

    isSaving.value = true;
    await Future.delayed(const Duration(milliseconds: 600));
    isSaving.value = false;

    Transaction? saved;
    if (Get.isRegistered<HomeController>()) {
      saved = Transaction(
        title: nameController.text.trim().isEmpty
            ? receipt.storeName : nameController.text.trim(),
        category: selectedCategory.value,
        amount: effectiveTotal,
        isIncome: false,
        date: selectedDate.value ?? DateTime.now(),
        source: selectedAsalSaldo.value,
        note: receipt.items.isNotEmpty
            ? receipt.items.map((i) => i.name).join(', ') : '',
      );
      Get.find<HomeController>().addTransaction(saved);
    }
    lastSavedTransaction.value = saved;
    currentStep.value = ScanStep.success;
  }

  void goToDetail() {
    currentStep.value = ScanStep.success; // stays on success, detail is part of it
  }

  void selesai() => Get.back();

  // ── Computed ───────────────────────────────────────────────────────────────
  double get effectiveTotal {
    final r = parsedReceipt.value;
    if (r == null) return 0;
    if (r.total > 0) return r.total;
    return editableItems.fold(0.0, (s, i) => s + i.total);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  String formatRupiah(double amount) {
    final str = amount.abs().toStringAsFixed(0);
    final buf = StringBuffer();
    int c = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (c > 0 && c % 3 == 0) buf.write('.');
      buf.write(str[i]); c++;
    }
    return 'Rp ${buf.toString().split('').reversed.join('')}';
  }

  /// Demo receipt text for emulator testing
  String _demoReceiptText() => '''
MAKO
Jl. Sudirman No. 42, Jakarta
Tel: 021-5551234

STRUK PEMBELIAN
Tgl: 02/05/2026    16:31 WIB
Kasir: Budi

3 Croisant Coklat      51.000
Americano x1           32.000
Air Mineral            8.000

Subtotal               91.000
Pajak (10%)            9.100
Diskon                 0
Total                 100.100

Tunai                 110.000
Kembalian              9.900

Terima kasih sudah berkunjung!
''';

  @override
  void onClose() {
    _textRecognizer.close();
    cameraController?.dispose();
    nameController.dispose();
    catatanController.dispose();
    super.onClose();
  }
}
