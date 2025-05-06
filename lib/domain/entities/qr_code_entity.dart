// lib/domain/entities/qr_code_entity.dart

// QR Code entity represents the domain model of a QR code
class QRCodeEntity {
  final String id;
  final String userId;
  final String? itemName;
  final String? itemDescription;
  final String? ownerContactInfo;
  final String? reward;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final List<String>? tags;
  final String? imageUrl;

  QRCodeEntity({
    required this.id,
    required this.userId,
    this.itemName,
    this.itemDescription,
    this.ownerContactInfo,
    this.reward,
    required this.createdAt,
    this.updatedAt,
    required this.isActive,
    this.tags,
    this.imageUrl,
  });
}
