// lib/data/models/qr_code_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:if_found_lost/domain/entities/qr_code_entity.dart';
import 'package:if_found_lost/domain/repositories/qr_code_repository.dart';

class QRCodeModel extends QRCodeEntity {
  QRCodeModel({
    required super.id,
    required super.userId,
    super.itemName,
    super.itemDescription,
    super.ownerContactInfo,
    super.reward,
    required super.createdAt,
    super.updatedAt,
    required super.isActive,
    super.tags,
    super.imageUrl,
  });

  factory QRCodeModel.fromEntity(QRCodeEntity entity) {
    return QRCodeModel(
      id: entity.id,
      userId: entity.userId,
      itemName: entity.itemName,
      itemDescription: entity.itemDescription,
      ownerContactInfo: entity.ownerContactInfo,
      reward: entity.reward,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isActive: entity.isActive,
      tags: entity.tags,
      imageUrl: entity.imageUrl,
    );
  }

  factory QRCodeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    // Handle tags if they exist
    List<String>? tags;
    if (data['tags'] != null) {
      tags = List<String>.from(data['tags'] as List);
    }

    return QRCodeModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      itemName: data['itemName'],
      itemDescription: data['itemDescription'],
      ownerContactInfo: data['ownerContactInfo'],
      reward: data['reward'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      isActive: data['isActive'] ?? true,
      tags: tags,
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'itemName': itemName,
      'itemDescription': itemDescription,
      'ownerContactInfo': ownerContactInfo,
      'reward': reward,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'isActive': isActive,
      'tags': tags,
      'imageUrl': imageUrl,
    };
  }
}

class QRScanModel extends QRScanEntity {
  QRScanModel({
    required super.id,
    required super.qrCodeId,
    required super.scannerIp,
    required super.timestamp,
    super.scannerLocation,
    super.message,
  });

  factory QRScanModel.fromEntity(QRScanEntity entity) {
    return QRScanModel(
      id: entity.id,
      qrCodeId: entity.qrCodeId,
      scannerIp: entity.scannerIp,
      timestamp: entity.timestamp,
      scannerLocation: entity.scannerLocation,
      message: entity.message,
    );
  }

  factory QRScanModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    return QRScanModel(
      id: doc.id,
      qrCodeId: data['qrCodeId'] ?? '',
      scannerIp: data['scannerIp'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      scannerLocation: data['scannerLocation'],
      message: data['message'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'qrCodeId': qrCodeId,
      'scannerIp': scannerIp,
      'timestamp': Timestamp.fromDate(timestamp),
      'scannerLocation': scannerLocation,
      'message': message,
    };
  }
}
