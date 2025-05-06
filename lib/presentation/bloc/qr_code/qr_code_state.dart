// lib/presentation/bloc/qr_code/qr_code_state.dart

// Part of the qr_code_bloc.dart file
part of 'qr_code_bloc.dart';

abstract class QRCodeState extends Equatable {
  const QRCodeState();

  @override
  List<Object?> get props => []; // Changed to Object? to handle nullable types
}

class QRCodeInitial extends QRCodeState {}

class QRCodeLoading extends QRCodeState {}

class QRCodesLoaded extends QRCodeState {
  final List<QRCodeEntity> qrCodes;

  const QRCodesLoaded({required this.qrCodes});

  @override
  List<Object> get props => [qrCodes];
}

class QRCodeLoaded extends QRCodeState {
  final QRCodeEntity qrCode;

  const QRCodeLoaded({required this.qrCode});

  @override
  List<Object> get props => [qrCode];
}

class QRCodeCreated extends QRCodeState {
  final QRCodeEntity qrCode;

  const QRCodeCreated({required this.qrCode});

  @override
  List<Object> get props => [qrCode];
}

class QRCodeUpdated extends QRCodeState {}

class QRCodeDeleted extends QRCodeState {}

class QRCodeContentGenerated extends QRCodeState {
  final String content;

  const QRCodeContentGenerated({required this.content});

  @override
  List<Object> get props => [content];
}

class QRCodeScanHistoryLoaded extends QRCodeState {
  final List<QRScanEntity> scanHistory;

  const QRCodeScanHistoryLoaded({required this.scanHistory});

  @override
  List<Object> get props => [scanHistory];
}

class QRCodeError extends QRCodeState {
  final String message;

  const QRCodeError({required this.message});

  @override
  List<Object> get props => [message];
}
