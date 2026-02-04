import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/loan_entity.dart';
import '../../domain/usecases/add_loan_usecase.dart';
import '../../domain/usecases/get_all_loans_usecase.dart';
import '../../domain/usecases/get_employee_loans_usecase.dart';
import '../../domain/usecases/update_loan_status_usecase.dart';
import '../../domain/usecases/record_payment_usecase.dart';
import '../../../Notification/presentation/bloc/notification_bloc.dart';
import '../../../Notification/presentation/bloc/notification_event.dart';
import 'package:injectable/injectable.dart';

part 'loan_event.dart';
part 'loan_state.dart';
@injectable
class LoanBloc extends Bloc<LoanEvent, LoanState> {
  final GetAllLoansUseCase getAllLoansUseCase;
  final GetEmployeeLoansUseCase getEmployeeLoansUseCase;
  final AddLoanUseCase addLoanUseCase;
  final UpdateLoanStatusUseCase updateLoanStatusUseCase;
  final RecordPaymentUseCase recordPaymentUseCase;
  final NotificationBloc notificationBloc;

  LoanBloc({
    required this.getAllLoansUseCase,
    required this.getEmployeeLoansUseCase,
    required this.addLoanUseCase,
    required this.updateLoanStatusUseCase,
    required this.recordPaymentUseCase,
    required this.notificationBloc,
  }) : super(LoanInitial()) {
    on<LoadAllLoans>(_onLoadAllLoans);
    on<LoadEmployeeLoans>(_onLoadEmployeeLoans);
    on<AddLoan>(_onAddLoan);
    on<UpdateLoanStatus>(_onUpdateLoanStatus);
    on<RecordPayment>(_onRecordPayment);
  }

  Future<void> _onLoadAllLoans(LoadAllLoans event, Emitter<LoanState> emit) async {
    emit(LoanLoading());
    try {
      final loans = await getAllLoansUseCase();
      emit(LoansLoaded(loans));
    } catch (e) {
      emit(LoanError(e.toString()));
    }
  }

  Future<void> _onLoadEmployeeLoans(LoadEmployeeLoans event, Emitter<LoanState> emit) async {
    emit(LoanLoading());
    try {
      final loans = await getEmployeeLoansUseCase(event.employeeId);
      emit(LoansLoaded(loans));
    } catch (e) {
      emit(LoanError(e.toString()));
    }
  }

  Future<void> _onAddLoan(AddLoan event, Emitter<LoanState> emit) async {
    try {
      await addLoanUseCase(event.loan);
      
      // إرسال إشعار للموظف
      notificationBloc.add(AdminSendNotificationEvent(
        title: "سلفة جديدة",
        body: "تم إضافة سلفة جديدة لك بقيمة ${event.loan.amount.toStringAsFixed(0)} ل.س",
        targetWorkshop: null, // أو تحديد الورشة إذا لزم الأمر
      ));

      add(LoadAllLoans());
    } catch (e) {
      emit(LoanError(e.toString()));
    }
  }

  Future<void> _onUpdateLoanStatus(UpdateLoanStatus event, Emitter<LoanState> emit) async {
    try {
      await updateLoanStatusUseCase(event.loanId, event.status);
      
      String statusText = event.status == LoanStatus.fullyPaid ? "مسددة بالكامل" : "محدثة";
      notificationBloc.add(AdminSendNotificationEvent(
        title: "تحديث حالة السلفة",
        body: "تم تغيير حالة سلفك إلى $statusText",
        targetWorkshop: null,
      ));

      add(LoadAllLoans());
    } catch (e) {
      emit(LoanError(e.toString()));
    }
  }

  Future<void> _onRecordPayment(RecordPayment event, Emitter<LoanState> emit) async {
    try {
      await recordPaymentUseCase(event.loanId, event.amount);
      
      notificationBloc.add(AdminSendNotificationEvent(
        title: "تسديد سلفة",
        body: "تم تسجيل عملية تسديد بقيمة ${event.amount.toStringAsFixed(0)} ل.س",
        targetWorkshop: null,
      ));

      add(LoadAllLoans());
    } catch (e) {
      emit(LoanError(e.toString()));
    }
  }
}
