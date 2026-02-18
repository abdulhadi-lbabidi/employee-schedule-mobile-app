import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/update_fcm_token_usecase.dart';

abstract class FcmEvent {}
class UpdateFcmTokenEvent extends FcmEvent {}

abstract class FcmState {}
class FcmInitial extends FcmState {}
class FcmLoading extends FcmState {}
class FcmSuccess extends FcmState {}
class FcmError extends FcmState {}

@injectable
class FcmBloc extends Bloc<FcmEvent, FcmState> {
  final UpdateFcmTokenUseCase updateFcmTokenUseCase;

  FcmBloc(this.updateFcmTokenUseCase) : super(FcmInitial()) {
    on<UpdateFcmTokenEvent>(_onUpdateToken);
  }

  Future<void> _onUpdateToken(UpdateFcmTokenEvent event, Emitter<FcmState> emit) async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      final result = await updateFcmTokenUseCase(token);
      result.fold(
        (failure) => emit(FcmError()),
        (success) => emit(FcmSuccess()),
      );
    }
  }
}
