// lib/data/datasources/remote/qr_code_remote_datasource.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:if_found_lost/data/models/qr_code_model.dart';

abstract class QRCodeRemoteDatasource {
  Stream<List<QRCodeModel>> getUserQRCodes(String userId);
  Future<QRCodeModel?> getQRCodeById(String qrCodeId);
  Future<QRCodeModel> createQRCode({
    required String userId,
    String? itemName,
    String? itemDescription,
    String? ownerContactInfo,
    String? reward,
    List<String>? tags,
    String? imageUrl,
  });
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
  Future<void> deleteQRCode(String qrCodeId);
  Future<void> saveQRCodeScan({
    required String qrCodeId,
    required String scannerIp,
    String? scannerLocation,
    String? message,
  });
  Future<List<QRScanModel>> getQRCodeScanHistory(String qrCodeId);
}

class FirebaseQRCodeDatasource implements QRCodeRemoteDatasource {
  final FirebaseFirestore _firestore;

  FirebaseQRCodeDatasource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  // Collection references
  CollectionReference get _qrCodesCollection =>
      _firestore.collection('qrCodes');
  CollectionReference get _qrScansCollection =>
      _firestore.collection('qrScans');

  @override
  Stream<List<QRCodeModel>> getUserQRCodes(String userId) {
    return _qrCodesCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => QRCodeModel.fromFirestore(doc))
              .toList();
        });
  }

  @override
  Future<QRCodeModel?> getQRCodeById(String qrCodeId) async {
    final docSnapshot = await _qrCodesCollection.doc(qrCodeId).get();
    if (docSnapshot.exists) {
      return QRCodeModel.fromFirestore(docSnapshot);
    }
    return null;
  }

  @override
  Future<QRCodeModel> createQRCode({
    required String userId,
    String? itemName,
    String? itemDescription,
    String? ownerContactInfo,
    String? reward,
    List<String>? tags,
    String? imageUrl,
  }) async {
    final now = DateTime.now();

    // First create the document with an auto-generated ID
    final docRef = _qrCodesCollection.doc();

    // Create the QR code model
    final qrCode = QRCodeModel(
      id: docRef.id,
      userId: userId,
      itemName: itemName,
      itemDescription: itemDescription,
      ownerContactInfo: ownerContactInfo,
      reward: reward,
      createdAt: now,
      updatedAt: now,
      isActive: true,
      tags: tags,
      imageUrl: imageUrl,
    );

    // Save to Firestore
    await docRef.set(qrCode.toMap());

    return qrCode;
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
    final updates = <String, dynamic>{
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    };

    if (itemName != null) updates['itemName'] = itemName;
    if (itemDescription != null) updates['itemDescription'] = itemDescription;
    if (ownerContactInfo != null)
      updates['ownerContactInfo'] = ownerContactInfo;
    if (reward != null) updates['reward'] = reward;
    if (isActive != null) updates['isActive'] = isActive;
    if (tags != null) updates['tags'] = tags;
    if (imageUrl != null) updates['imageUrl'] = imageUrl;

    await _qrCodesCollection.doc(qrCodeId).update(updates);
  }

  @override
  Future<void> deleteQRCode(String qrCodeId) async {
    // Delete the QR code document
    await _qrCodesCollection.doc(qrCodeId).delete();

    // Also delete all scan records for this QR code
    final scanQuery =
        await _qrScansCollection.where('qrCodeId', isEqualTo: qrCodeId).get();

    final batch = _firestore.batch();
    for (final doc in scanQuery.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  @override
  Future<void> saveQRCodeScan({
    required String qrCodeId,
    required String scannerIp,
    String? scannerLocation,
    String? message,
  }) async {
    final scan = QRScanModel(
      id: '', // Will be replaced by Firestore
      qrCodeId: qrCodeId,
      scannerIp: scannerIp,
      timestamp: DateTime.now(),
      scannerLocation: scannerLocation,
      message: message,
    );

    await _qrScansCollection.add(scan.toMap());
  }

  @override
  Future<List<QRScanModel>> getQRCodeScanHistory(String qrCodeId) async {
    final querySnapshot =
        await _qrScansCollection
            .where('qrCodeId', isEqualTo: qrCodeId)
            .orderBy('timestamp', descending: true)
            .get();

    return querySnapshot.docs
        .map((doc) => QRScanModel.fromFirestore(doc))
        .toList();
  }
}
