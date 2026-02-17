import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/usecases/post_payrecords_useCase.dart';

import '../../../domain/usecases/update_payment_usecase.dart';
import 'payment_action_event.dart';
import 'payment_action_state.dart';

@injectable
class PaymentActionBloc extends Bloc<PaymentActionEvent, PaymentActionState> {
  final PostPayRecordsUseCase postPayRecordsUseCase;
  final UpdatePaymentUseCase updatePaymentUseCase;

  PaymentActionBloc(this.postPayRecordsUseCase, this.updatePaymentUseCase)
    : super(PaymentActionInitial()) {
    // معالجة إضافة دفع جديد
    on<ExecutePostPayment>((event, emit) async {
      emit(PaymentActionLoading());
      final result = await postPayRecordsUseCase(event.params);
      result.fold(
        (failure) => emit(PaymentActionError(failure.message)),
        (_) => emit(const PaymentActionSuccess("تمت عملية الدفع بنجاح!")),
      );
    });

    // معالجة تعديل دفع
    on<ExecuteUpdatePayment>((event, emit) async {
      emit(PaymentActionLoading());
      final result = await updatePaymentUseCase(event.params);
      result.fold(
        (failure) => emit(PaymentActionError(failure.message)),
        (updateResponse) =>
            emit(const PaymentActionSuccess("تم تحديث البيانات بنجاح!")),
      );
    });
  }
}
