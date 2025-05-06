// lib/domain/usecases/qr_code_usecases.dart

import 'package:if_found_lost/domain/entities/qr_code_entity.dart';
import 'package:if_found_lost/domain/repositories/qr_code_repository.dart';

class GetUserQRCodesUseCase {
  final QRCodeRepository repository;

  GetUserQRCodesUseCase(this.repository);

  Stream<List<QRCodeEntity>> execute(String userId) {
    return repository.getUserQRCodes(userId);
  }
}

class GetQRCodeByIdUseCase {
  final QRCodeRepository repository;

  GetQRCodeByIdUseCase(this.repository);

  Future<QRCodeEntity?> execute(String qrCodeId) {
    return repository.getQRCodeById(qrCodeId);
  }
}

class CreateQRCodeUseCase {
  final QRCodeRepository repository;

  CreateQRCodeUseCase(this.repository);

  Future<QRCodeEntity> execute({
    required String userId,
    String? itemName,
    String? itemDescription,
    String? ownerContactInfo,
    String? reward,
    List<String>? tags,
    String? imageUrl,
  }) {
    return repository.createQRCode(
      userId: userId,
      itemName: itemName,
      itemDescription: itemDescription,
      ownerContactInfo: ownerContactInfo,
      reward: reward,
      tags: tags,
      imageUrl: imageUrl,
    );
  }
}

class UpdateQRCodeUseCase {
  final QRCodeRepository repository;

  UpdateQRCodeUseCase(this.repository);

  Future<void> execute({
    required String qrCodeId,
    String? itemName,
    String? itemDescription,
    String? ownerContactInfo,
    String? reward,
    bool? isActive,
    List<String>? tags,
    String? imageUrl,
  }) {
    return repository.updateQRCode(
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
}

class DeleteQRCodeUseCase {
  final QRCodeRepository repository;

  DeleteQRCodeUseCase(this.repository);

  Future<void> execute(String qrCodeId) {
    return repository.deleteQRCode(qrCodeId);
  }
}

class GenerateQRCodeContentUseCase {
  final QRCodeRepository repository;

  GenerateQRCodeContentUseCase(this.repository);

  String execute(String qrCodeId) {
    return repository.generateQRCodeContent(qrCodeId);
  }
}

class SaveQRCodeScanUseCase {
  final QRCodeRepository repository;

  SaveQRCodeScanUseCase(this.repository);

  Future<void> execute({
    required String qrCodeId,
    required String scannerIp,
    String? scannerLocation,
    String? message,
  }) {
    return repository.saveQRCodeScan(
      qrCodeId: qrCodeId,
      scannerIp: scannerIp,
      scannerLocation: scannerLocation,
      message: message,
    );
  }
}

class GetQRCodeScanHistoryUseCase {
  final QRCodeRepository repository;

  GetQRCodeScanHistoryUseCase(this.repository);

  Future<List<QRScanEntity>> execute(String qrCodeId) {
    return repository.getQRCodeScanHistory(qrCodeId);
  }
}
