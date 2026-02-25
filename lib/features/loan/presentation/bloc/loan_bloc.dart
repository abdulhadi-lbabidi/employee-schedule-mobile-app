import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled8/features/loan/data/models/get_all_loan_response.dart';
import '../../../../core/data_state_model.dart';
import '../../data/models/get_all_loane.dart';
import '../../data/models/loan_model.dart';
import '../../domain/usecases/add_loan_usecase.dart';
import '../../domain/usecases/get_all_loans_usecase.dart';
import '../../domain/usecases/get_employee_loans_usecase.dart';
import '../../domain/usecases/approve_loan_usecase.dart';
import '../../domain/usecases/reject_loan_usecase.dart';
import '../../domain/usecases/pay_loan_usecase.dart';
import '../../../Notification/presentation/bloc/notification_bloc.dart';
import 'package:injectable/injectable.dart';

part 'loan_event.dart';
part 'loan_state.dart';

@injectable
class LoanBloc extends Bloc<LoanEvent, LoanState> {
  final GetAllLoansUseCase getAllLoansUseCase;
  final GetEmployeeLoansUseCase getEmployeeLoansUseCase;
  final AddLoanUseCase addLoanUseCase;
  final ApproveLoanUseCase approveLoanUseCase;
  final RejectLoanUseCase rejectLoanUseCase;
  final PayLoanUseCase payLoanUseCase;
  final NotificationBloc notificationBloc;

  LoanBloc(
    this.getAllLoansUseCase,
    this.getEmployeeLoansUseCase,
    this.addLoanUseCase,
    this.approveLoanUseCase,
    this.rejectLoanUseCase,
    this.payLoanUseCase,
    this.notificationBloc,
  ) : super(LoanState()) {
    on<GetAllLoansEvent>(_getAllLoan);
    on<ApproveLoanEvent>(_onApproveLoan);
    on<RejectLoanEvent>(_onRejectLoan);
    on<PayLoanEvent>(_onPayLoan);
    on<AddLoanEvent>(_onAddLoan); // تفعيل حدث الإضافة
  }

  FutureOr<void> _getAllLoan(
      GetAllLoansEvent event,
      Emitter<LoanState> emit,
      )
  async {
    emit(
      state.copyWith(
        getAllLoansData: state.getAllLoansData.setLoading(),
      ),
    );

    final result = await getAllLoansUseCase();

    result.fold(
          (failure) {
        emit(
          state.copyWith(
            getAllLoansData: state.getAllLoansData
                .setFaild(errorMessage: failure.message),
          ),
        );
      },
          (response) {
        /// 🔁 تحويل من API Model → UI Model
        final loans = response.data.map((e) => Loane(
          id: e.id,
          employee: e.employee,
          amount: e.amount,
          paidAmount: e.paidAmount,
          date: e.date,
          status: e.status,
        )).toList();

        emit(
          state.copyWith(
            getAllLoansData:
            state.getAllLoansData.setSuccess(data: loans),
          ),
        );
      },
    );
  }

  FutureOr<void> _onAddLoan(AddLoanEvent event, Emitter<LoanState> emit) async {
    // يمكننا إضافة حالة تحميل هنا إذا أردت
    final result = await addLoanUseCase(event.params);
    result.fold(
      (l) => null, // تعامل مع الخطأ هنا إذا أردت إظهار Snackbar بالخطأ
      (r) {
        add(GetAllLoansEvent()); // تحديث القائمة فوراً بعد النجاح
      },
    );
  }

  FutureOr<void> _onApproveLoan(ApproveLoanEvent event, Emitter<LoanState> emit) async {
    final result = await approveLoanUseCase(event.loanId);
    result.fold(
      (l) => null,
      (r) => add(GetAllLoansEvent()),
    );
  }

  FutureOr<void> _onRejectLoan(RejectLoanEvent event, Emitter<LoanState> emit) async {
    final result = await rejectLoanUseCase(event.loanId);
    result.fold(
      (l) => null,
      (r) => add(GetAllLoansEvent()),
    );
  }

  FutureOr<void> _onPayLoan(PayLoanEvent event, Emitter<LoanState> emit) async {
    final result = await payLoanUseCase(event.loanId, event.amount);
    result.fold(
      (l) => null,
      (r) => add(GetAllLoansEvent()),
    );
  }
}
