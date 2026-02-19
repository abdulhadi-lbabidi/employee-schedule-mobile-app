import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/get_all_payments_uescese.dart'; // تأكد من المسار
import 'all_payments_event.dart';
import 'all_payments_state.dart';

@injectable
class AllPaymentsBloc extends Bloc<AllPaymentsEvent, AllPaymentsState> {
  final GetAllPaymentsUescese getAllPaymentsUseCase; // الاسم كما ورد في كودك

  AllPaymentsBloc(this.getAllPaymentsUseCase) : super(AllPaymentsInitial()) {
    on<FetchAllPayments>((event, emit) async {
      emit(AllPaymentsLoading());
      final result = await getAllPaymentsUseCase();
      result.fold(
            (failure) => emit(AllPaymentsError(failure.message)),
            (successData) => emit(AllPaymentsLoaded(successData.data ?? [])),
      );
    });
  }
}