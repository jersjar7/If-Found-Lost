// lib/presentation/bloc/qr_code/qr_code_bloc.dart

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:if_found_lost/domain/entities/qr_code_entity.dart';
import 'package:if_found_lost/domain/repositories/qr_code_repository.dart';
import 'package:if_found_lost/domain/usecases/qr_code_usecases.dart';

part 'qr_code_event.dart';
part 'qr_code_state.dart';

class QRCodeBloc extends Bloc<QRCodeEvent, QRCodeState> {
  final GetUserQRCodesUseCase getUserQRCodesUseCase;
  final GetQRCodeByIdUseCase getQRCodeByIdUseCase;
  final CreateQRCodeUseCase createQRCodeUseCase;
  final UpdateQRCodeUseCase updateQRCodeUseCase;
  final DeleteQRCodeUseCase deleteQRCodeUseCase;
  final GenerateQRCodeContentUseCase generateQRCodeContentUseCase;
  final GetQRCodeScanHistoryUseCase getQRCodeScanHistoryUseCase;

  StreamSubscription? _qrCodesSubscription;

  QRCodeBloc({
    required this.getUserQRCodesUseCase,
    required this.getQRCodeByIdUseCase,
    required this.createQRCodeUseCase,
    required this.updateQRCodeUseCase,
    required this.deleteQRCodeUseCase,
    required this.generateQRCodeContentUseCase,
    required this.getQRCodeScanHistoryUseCase,
  }) : super(QRCodeInitial()) {
    on<LoadUserQRCodesEvent>(_onLoadUserQRCodes);
    on<QRCodesUpdatedEvent>(_onQRCodesUpdated);
    on<LoadQRCodeByIdEvent>(_onLoadQRCodeById);
    on<CreateQRCodeEvent>(_onCreateQRCode);
    on<UpdateQRCodeEvent>(_onUpdateQRCode);
    on<DeleteQRCodeEvent>(_onDeleteQRCode);
    on<GenerateQRCodeContentEvent>(_onGenerateQRCodeContent);
    on<LoadQRCodeScanHistoryEvent>(_onLoadQRCodeScanHistory);
    on<QRCodeErrorEvent>(_onQRCodeError);
  }

  Future<void> _onLoadUserQRCodes(
    LoadUserQRCodesEvent event,
    Emitter<QRCodeState> emit,
  ) async {
    emit(QRCodeLoading());

    await _qrCodesSubscription?.cancel();
    _qrCodesSubscription = getUserQRCodesUseCase
        .execute(event.userId)
        .listen(
          (qrCodes) => add(QRCodesUpdatedEvent(qrCodes: qrCodes)),
          onError: (error) {
            // Instead of emitting directly, add an event
            add(QRCodeErrorEvent(message: error.toString()));
          },
        );
  }

  void _onQRCodesUpdated(QRCodesUpdatedEvent event, Emitter<QRCodeState> emit) {
    emit(QRCodesLoaded(qrCodes: event.qrCodes));
  }

  void _onQRCodeError(QRCodeErrorEvent event, Emitter<QRCodeState> emit) {
    emit(QRCodeError(message: event.message));
  }

  Future<void> _onLoadQRCodeById(
    LoadQRCodeByIdEvent event,
    Emitter<QRCodeState> emit,
  ) async {
    emit(QRCodeLoading());

    try {
      final qrCode = await getQRCodeByIdUseCase.execute(event.qrCodeId);
      if (qrCode != null) {
        emit(QRCodeLoaded(qrCode: qrCode));
      } else {
        emit(const QRCodeError(message: 'QR Code not found'));
      }
    } catch (e) {
      emit(QRCodeError(message: e.toString()));
    }
  }

  Future<void> _onCreateQRCode(
    CreateQRCodeEvent event,
    Emitter<QRCodeState> emit,
  ) async {
    emit(QRCodeLoading());

    try {
      final newQRCode = await createQRCodeUseCase.execute(
        userId: event.userId,
        itemName: event.itemName,
        itemDescription: event.itemDescription,
        ownerContactInfo: event.ownerContactInfo,
        reward: event.reward,
        tags: event.tags,
        imageUrl: event.imageUrl,
      );

      emit(QRCodeCreated(qrCode: newQRCode));
    } catch (e) {
      emit(QRCodeError(message: e.toString()));
    }
  }

  Future<void> _onUpdateQRCode(
    UpdateQRCodeEvent event,
    Emitter<QRCodeState> emit,
  ) async {
    emit(QRCodeLoading());

    try {
      await updateQRCodeUseCase.execute(
        qrCodeId: event.qrCodeId,
        itemName: event.itemName,
        itemDescription: event.itemDescription,
        ownerContactInfo: event.ownerContactInfo,
        reward: event.reward,
        isActive: event.isActive,
        tags: event.tags,
        imageUrl: event.imageUrl,
      );

      emit(QRCodeUpdated());
    } catch (e) {
      emit(QRCodeError(message: e.toString()));
    }
  }

  Future<void> _onDeleteQRCode(
    DeleteQRCodeEvent event,
    Emitter<QRCodeState> emit,
  ) async {
    emit(QRCodeLoading());

    try {
      await deleteQRCodeUseCase.execute(event.qrCodeId);
      emit(QRCodeDeleted());
    } catch (e) {
      emit(QRCodeError(message: e.toString()));
    }
  }

  void _onGenerateQRCodeContent(
    GenerateQRCodeContentEvent event,
    Emitter<QRCodeState> emit,
  ) {
    try {
      final content = generateQRCodeContentUseCase.execute(event.qrCodeId);
      emit(QRCodeContentGenerated(content: content));
    } catch (e) {
      emit(QRCodeError(message: e.toString()));
    }
  }

  Future<void> _onLoadQRCodeScanHistory(
    LoadQRCodeScanHistoryEvent event,
    Emitter<QRCodeState> emit,
  ) async {
    emit(QRCodeLoading());

    try {
      final scanHistory = await getQRCodeScanHistoryUseCase.execute(
        event.qrCodeId,
      );
      emit(QRCodeScanHistoryLoaded(scanHistory: scanHistory));
    } catch (e) {
      emit(QRCodeError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _qrCodesSubscription?.cancel();
    return super.close();
  }
}
