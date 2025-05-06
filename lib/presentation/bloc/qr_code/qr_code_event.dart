// lib/presentation/bloc/qr_code/qr_code_event.dart

// Part of the qr_code_bloc.dart file
part of 'qr_code_bloc.dart';

// Events
abstract class QRCodeEvent extends Equatable {
  const QRCodeEvent();

  @override
  List<Object?> get props => []; // Changed to Object? to handle nullable types
}

class LoadUserQRCodesEvent extends QRCodeEvent {
  final String userId;

  const LoadUserQRCodesEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

class QRCodesUpdatedEvent extends QRCodeEvent {
  final List<QRCodeEntity> qrCodes;

  const QRCodesUpdatedEvent({required this.qrCodes});

  @override
  List<Object> get props => [qrCodes];
}

class LoadQRCodeByIdEvent extends QRCodeEvent {
  final String qrCodeId;

  const LoadQRCodeByIdEvent({required this.qrCodeId});

  @override
  List<Object> get props => [qrCodeId];
}

class CreateQRCodeEvent extends QRCodeEvent {
  final String userId;
  final String? itemName;
  final String? itemDescription;
  final String? ownerContactInfo;
  final String? reward;
  final List<String>? tags;
  final String? imageUrl;

  const CreateQRCodeEvent({
    required this.userId,
    this.itemName,
    this.itemDescription,
    this.ownerContactInfo,
    this.reward,
    this.tags,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    userId,
    itemName,
    itemDescription,
    ownerContactInfo,
    reward,
    tags,
    imageUrl,
  ];
}

class UpdateQRCodeEvent extends QRCodeEvent {
  final String qrCodeId;
  final String? itemName;
  final String? itemDescription;
  final String? ownerContactInfo;
  final String? reward;
  final bool? isActive;
  final List<String>? tags;
  final String? imageUrl;

  const UpdateQRCodeEvent({
    required this.qrCodeId,
    this.itemName,
    this.itemDescription,
    this.ownerContactInfo,
    this.reward,
    this.isActive,
    this.tags,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    qrCodeId,
    itemName,
    itemDescription,
    ownerContactInfo,
    reward,
    isActive,
    tags,
    imageUrl,
  ];
}

class DeleteQRCodeEvent extends QRCodeEvent {
  final String qrCodeId;

  const DeleteQRCodeEvent({required this.qrCodeId});

  @override
  List<Object> get props => [qrCodeId];
}

class GenerateQRCodeContentEvent extends QRCodeEvent {
  final String qrCodeId;

  const GenerateQRCodeContentEvent({required this.qrCodeId});

  @override
  List<Object> get props => [qrCodeId];
}

class LoadQRCodeScanHistoryEvent extends QRCodeEvent {
  final String qrCodeId;

  const LoadQRCodeScanHistoryEvent({required this.qrCodeId});

  @override
  List<Object> get props => [qrCodeId];
}
