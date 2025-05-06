// lib/data/repositories/qr_code_repository_impl.dart

import 'package:if_found_lost/data/datasources/remote/qr_code_remote_datasource.dart';
import 'package:if_found_lost/domain/entities/qr_code_entity.dart';
import 'package:if_found_lost/domain/repositories/qr_code_repository.dart';

class QRCodeRepositoryImpl implements QRCodeRepository {
  final QRCodeRemoteDatasource remoteDatasource;
  final String baseUrl; // URL for the QR code scanner page

  QRCodeRepositoryImpl({
    required this.remoteDatasource,
    this.baseUrl = 'https://iffoundlost.app/scan/',
  });

  @override
  Stream<List<QRCodeEntity>> getUserQRCodes(String userId) {
    return remoteDatasource.getUserQRCodes(userId);
  }

  @override
  Future<QRCodeEntity?> getQRCodeById(String qrCodeId) async {
    return await remoteDatasource.getQRCodeById(qrCodeId);
  }

  @override
  Future<QRCodeEntity> createQRCode({
    required String userId,
    String? itemName,
    String? itemDescription,
    String? ownerContactInfo,
    String? reward,
    List<String>? tags,
    String? imageUrl,
  }) async {
    return await remoteDatasource.createQRCode(
      userId: userId,
      itemName: itemName,
      itemDescription: itemDescription,
      ownerContactInfo: ownerContactInfo,
      reward: reward,
      tags: tags,
      imageUrl: imageUrl,
    );
  }

  @override
  Future<void> updateQRCode({
    required String qrCodeId,
    String? itemName,
    String? itemDescription,
    String? ownerContactInfo,
    String? reward,
    bool? isActive,
    List<String>? tags,
    String? imageUrl,
  }) async {
    await remoteDatasource.updateQRCode(
      qrCodeId: qrCodeId,
      itemName: itemName,
      itemDescription: itemDescription,
      ownerContactInfo: ownerContactInfo,
      reward: reward,
      isActive: isActive,
      tags: tags,
      imageUrl: imageUrl,
    );
  }

  @override
  Future<void> deleteQRCode(String qrCodeId) async {
    await remoteDatasource.deleteQRCode(qrCodeId);
  }

  @override
  String generateQRCodeContent(String qrCodeId) {
    // Generate a URL that points to the scanner page with the QR code ID
    return '$baseUrl$qrCodeId';
  }

  @override
  Future<void> saveQRCodeScan({
    required String qrCodeId,
    required String scannerIp,
    String? scannerLocation,
    String? message,
  }) async {
    await remoteDatasource.saveQRCodeScan(
      qrCodeId: qrCodeId,
      scannerIp: scannerIp,
      scannerLocation: scannerLocation,
      message: message,
    );
  }

  @override
  Future<List<QRScanEntity>> getQRCodeScanHistory(String qrCodeId) async {
    return await remoteDatasource.getQRCodeScanHistory(qrCodeId);
  }
}
