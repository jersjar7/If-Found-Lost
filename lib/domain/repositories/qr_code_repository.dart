// lib/domain/repositories/qr_code_repository.dart

import 'package:if_found_lost/domain/entities/qr_code_entity.dart';

abstract class QRCodeRepository {
  // Get all QR codes for a user
  Stream<List<QRCodeEntity>> getUserQRCodes(String userId);

  // Get a specific QR code by ID
  Future<QRCodeEntity?> getQRCodeById(String qrCodeId);

  // Create a new QR code
  Future<QRCodeEntity> createQRCode({
    required String userId,
    String? itemName,
    String? itemDescription,
    String? ownerContactInfo,
    String? reward,
    List<String>? tags,
    String? imageUrl,
  });

  // Update an existing QR code
  Future<void> updateQRCode({
    required String qrCodeId,
    String? itemName,
    String? itemDescription,
    String? ownerContactInfo,
    String? reward,
    bool? isActive,
    List<String>? tags,
    String? imageUrl,
  });

  // Delete a QR code
  Future<void> deleteQRCode(String qrCodeId);

  // Generate QR code content string
  String generateQRCodeContent(String qrCodeId);

  // Save QR code view/scan history
  Future<void> saveQRCodeScan({
    required String qrCodeId,
    required String scannerIp,
    String? scannerLocation,
    String? message,
  });

  // Get scan history for a QR code
  Future<List<QRScanEntity>> getQRCodeScanHistory(String qrCodeId);
}

// Additional entity for QR code scans
class QRScanEntity {
  final String id;
  final String qrCodeId;
  final String scannerIp;
  final DateTime timestamp;
  final String? scannerLocation;
  final String? message;

  QRScanEntity({
    required this.id,
    required this.qrCodeId,
    required this.scannerIp,
    required this.timestamp,
    this.scannerLocation,
    this.message,
  });
}
