import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:untitled8/features/admin/domain/usecases/get_employee_details_hours_use_case.dart';
import '../../../../../core/toast.dart';
import '../../../../admin/data/repositories/audit_log_repository.dart';
import '../../../data/datasources/admin_remote_data_source_impl.dart';
import '../../../data/models/employee model/employee_model.dart';
import '../../../domain/usecases/confirm_payment.dart';
import '../../../domain/usecases/delete_employee.dart';
import '../../../domain/usecases/get_employee_details.dart';
import '../../../domain/usecases/update_hourly_rate.dart';
import '../../../domain/usecases/update_overtime_rate.dart';
import '../../../domain/usecases/toggle_employee_archive.dart';
import '../../../domain/usecases/update_employee_full_details.dart'; // 🔹 إضافة

import 'employee_details_event.dart';
import 'employee_details_state.dart';

@injectable
class EmployeeDetailsBloc
    extends Bloc<EmployeeDetailsEvent, EmployeeDetailsState> {
  final GetEmployeeDetailsUseCase getEmployeeDetailsUseCase;
  final GetEmployeeDetailsHoursUseCase getEmployeeDetailsHoursUseCase;
  final UpdateHourlyRateUseCase updateHourlyRateUseCase;
  final UpdateOvertimeRateUseCase updateOvertimeRateUseCase;
  final ConfirmPaymentUseCase confirmPaymentUseCase;
  final DeleteEmployeeUseCase deleteEmployeeUseCase;
  final ToggleEmployeeArchiveUseCase toggleEmployeeArchiveUseCase;
  final UpdateEmployeeFullDetailsUseCase updateEmployeeFullDetailsUseCase; // 🔹 إضافة

  final AdminRemoteDataSourceImpl remoteDataSource;
  final AuditLogRepository auditLogRepository;

  EmployeeModel? _employee;

  EmployeeDetailsBloc(
    this.getEmployeeDetailsHoursUseCase,
    this.getEmployeeDetailsUseCase,
    this.updateHourlyRateUseCase,
    this.updateOvertimeRateUseCase,
    this.confirmPaymentUseCase,
    this.deleteEmployeeUseCase,
    this.toggleEmployeeArchiveUseCase,
    this.remoteDataSource,
    this.auditLogRepository,
    this.updateEmployeeFullDetailsUseCase, // 🔹 إضافة
  ) : super(EmployeeDetailsInitial()) {
    on<LoadEmployeeDetailsEvent>(_onLoadDetails);
    on<LoadEmployeeDetailsHoursEvent>(_onLoadHoursDetails);
    on<UpdateHourlyRateEvent>(_onUpdateHourlyRate);
    on<UpdateOvertimeRateEvent>(_onUpdateOvertimeRate);
    on<ConfirmPaymentEvent>(_onConfirmPayment);
    on<DeleteEmployeeEvent>(_onDeleteEmployee);
    // on<ToggleArchiveEmployeeDetailEvent>(_onToggleArchiveEmployee);
    on<UpdateEmployeeFullEvent>(_onUpdateFullEmployee);
  }

  Future<void> _onLoadDetails(
    LoadEmployeeDetailsEvent event,
    Emitter<EmployeeDetailsState> emit,
  )
  async {
    emit(EmployeeDetailsLoading());

    final val = await getEmployeeDetailsUseCase(event.employeeId);
    val.fold(
      (l) {
        emit(EmployeeDetailsError(l.message));
      },
      (r) {
        _employee = r.data;
        emit(EmployeeDetailsLoaded(_employee!));
      },
    );
  }


  Future<void> _onLoadHoursDetails(
      LoadEmployeeDetailsHoursEvent event,
      Emitter<EmployeeDetailsState> emit,
      )
  async {
    emit(EmployeeDetailsLoading());

    final val = await getEmployeeDetailsHoursUseCase(event.employeeId);
    val.fold(
          (l) {
        emit(EmployeeDetailsError(l.message));
      },
          (r) {

        emit(EmployeeDetailsHoursLoaded(r));
      },
    );
  }

  // Future<void> _onToggleArchiveEmployee(
  //   ToggleArchiveEmployeeDetailEvent event,
  //   Emitter<EmployeeDetailsState> emit,
  // )
  // async {
  //   if (_employee == null) return;
  //   try {
  //     await toggleEmployeeArchiveUseCase(event.employeeId);
  //     _employee = _employee!;
  //     emit(EmployeeDetailsLoaded(_employee!));
  //
  //     await auditLogRepository.logAction(
  //       actionType: event.isArchived ? "أرشفة موظف" : "إلغاء أرشفة موظف",
  //       targetName: _employee!.user!.fullName!,
  //       details:
  //           event.isArchived ? "تمت أرشفة الموظف" : "تمت إعادة تنشيط الموظف",
  //     );
  //   } catch (e) {
  //     debugPrint('Error toggling employee archive: $e');
  //     emit(EmployeeDetailsError('فشل تغيير حالة الأرشفة'));
  //   }
  // }

  Future<void> _onConfirmPayment(
    ConfirmPaymentEvent event,
    Emitter<EmployeeDetailsState> emit,
  )
  async {
    try {
      final currentEmp = event.employee;
      emit(HourlyRateUpdating(currentEmp));

      if (event.isFullPayment) {
        await confirmPaymentUseCase(
          employeeId: currentEmp.id.toString(),
          weekNumber: event.weekNumber,
        );
      }

      await auditLogRepository.logAction(
        actionType:
            event.isFullPayment ? "تأكيد صرف رواتب كاملة" : "صرف دفعة جزئية",
        targetName: currentEmp.user!.fullName!,
        details:
            event.isFullPayment
                ? "دفع مستحقات الأسبوع ${event.weekNumber} بالكامل"
                : "دفع مبلغ ${event.amountPaid} \$ من مستحقات الأسبوع ${event.weekNumber}",
      );
    } catch (e) {
      debugPrint('Error confirming payment: $e');
      emit(EmployeeDetailsError('فشل العملية: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateFullEmployee(
    UpdateEmployeeFullEvent event,
    Emitter<EmployeeDetailsState> emit,
  )
  async {
    if (_employee == null) return;

    emit(EmployeeDetailsLoading());

    try {
      final oldEmployee = _employee!;

      // 🔹 استدعاء الـ UseCase الجديد بجميع الحقول
      await updateEmployeeFullDetailsUseCase(UpdateEmployeeFullDetailsParams(
        employeeId: oldEmployee.id.toString(),
        name: event.name,
        phoneNumber: event.phoneNumber,
        email: event.email,
        password: event.password,
        position: event.position,
        department: event.department,
        hourlyRate: event.hourlyRate,
        overtimeRate: event.overtimeRate,
        currentLocation: event.currentLocation,
      ));

      // 🔹 تحديث الكائن المحلي _employee بعد النجاح
      _employee = _employee!.copyWith(
        user: _employee!.user!.copyWith(
          fullName: event.name,
          phoneNumber: event.phoneNumber,
          email: event.email,
        ),
        position: event.position,
        department: event.department,

        hourlyRate: event.hourlyRate,
        overtimeRate: event.overtimeRate,
        currentLocation: event.currentLocation,
        // كلمة المرور لا يتم تحديثها محليًا هنا، فقط يتم إرسالها للباك إند
      );

      await auditLogRepository.logAction(
        actionType: "تحديث بيانات الموظف",
        targetName: _employee!.user!.fullName!,
        details: _buildUpdateDetails(oldEmployee, event),
      );

      emit(EmployeeDetailsLoaded(_employee!));
    } catch (e) {
      debugPrint('Error updating employee: $e');
      emit(EmployeeDetailsError('فشل تحديث البيانات: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteEmployee(
    DeleteEmployeeEvent event,
    Emitter<EmployeeDetailsState> emit,
  )
  async {
    emit(EmployeeDetailsLoading());
    Toaster.showLoading();
    try {
    print('deleteeeeeee');
    print('deleteeeeeee');
      await deleteEmployeeUseCase(event.employeeId);
    Toaster.closeAllLoading();

      if (_employee != null) {

        await auditLogRepository.logAction(
          actionType: "حذف موظف",
          targetName: _employee!.user!.fullName!,
          details: "تم حذف الموظف بنجاح",
        );
      }

      emit(EmployeeDeleted());
    } catch (e) {
      Toaster.closeAllLoading();

      debugPrint('Error deleting employee: $e');
      emit(EmployeeDetailsError('فشل حذف الموظف: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateHourlyRate(
    UpdateHourlyRateEvent event,
    Emitter<EmployeeDetailsState> emit,
  )
  async {
    if (_employee == null) return;
    try {
      emit(HourlyRateUpdating(_employee!));
      await updateHourlyRateUseCase(
        employeeId: _employee!.id.toString(),
        newRate: event.newRate,
      );

      final oldRate = _employee!.hourlyRate;
      _employee = _employee!.copyWith(hourlyRate: event.newRate);

      await auditLogRepository.logAction(
        actionType: "تحديث الراتب الساعي",
        targetName: _employee!.user!.fullName!,
        details: "تم تحديث الراتب الساعي من $oldRate إلى ${event.newRate}",
      );

      emit(EmployeeDetailsLoaded(_employee!));
    } catch (e) {
      debugPrint('Error updating hourly rate: $e');
      emit(EmployeeDetailsError('فشل التحديث: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateOvertimeRate(
    UpdateOvertimeRateEvent event,
    Emitter<EmployeeDetailsState> emit,
  ) async {
    if (_employee == null) return;
    try {
      emit(HourlyRateUpdating(_employee!));
      await updateOvertimeRateUseCase(
        employeeId: _employee!.user!.id.toString(),
        newRate: event.newRate,
      );

      final oldRate = _employee!.overtimeRate;
      _employee = _employee!.copyWith(overtimeRate: event.newRate);

      await auditLogRepository.logAction(
        actionType: "تحديث معدل الإضافي",
        targetName: _employee!.user!.fullName!,
        details: "تم تحديث معدل الإضافي من $oldRate إلى ${event.newRate}",
      );

      emit(EmployeeDetailsLoaded(_employee!));
    } catch (e) {
      debugPrint('Error updating overtime rate: $e');
      emit(EmployeeDetailsError('فشل التحديث: ${e.toString()}'));
    }
  }

  /// بناء رسالة تفصيلية لتسجيل التعديلات
  String _buildUpdateDetails(
    EmployeeModel oldEmployee,
    UpdateEmployeeFullEvent event,
  )
  {
    final changes = <String>[];

    if (oldEmployee.user!.fullName != event.name) {
      changes.add(
        'الاسم: من "${oldEmployee.user!.fullName}" إلى "${event.name}"',
      );
    }
    if (oldEmployee.user!.phoneNumber != event.phoneNumber) {
      changes.add(
        'رقم الهاتف: من "${oldEmployee.user!.phoneNumber}" إلى "${event.phoneNumber}"',
      );
    }
    if (oldEmployee.user!.email != event.email && event.email != null) {
      changes.add(
        'البريد الإلكتروني: من "${oldEmployee.user!.email}" إلى "${event.email}"',
      );
    }
    if (oldEmployee.position != event.position && event.position != null) {
      changes.add(
        'المسمى الوظيفي: من "${oldEmployee.position}" إلى "${event.position}"',
      );
    }
    if (oldEmployee.department != event.department && event.department != null) {
      changes.add(
        'القسم: من "${oldEmployee.department}" إلى "${event.department}"',
      );
    }
    if (oldEmployee.currentLocation != event.currentLocation && event.currentLocation != null) {
      changes.add(
        'الموقع الحالي: من "${oldEmployee.currentLocation}" إلى "${event.currentLocation}"',
      );
    }
    if (oldEmployee.hourlyRate != event.hourlyRate) {
      changes.add(
        'الراتب الساعي: من ${oldEmployee.hourlyRate} إلى ${event.hourlyRate}',
      );
    }
    if (oldEmployee.overtimeRate != event.overtimeRate) {
      changes.add(
        'معدل الإضافي: من ${oldEmployee.overtimeRate} إلى ${event.overtimeRate}',
      );
    }

    return changes.isNotEmpty
        ? 'تم تحديث: ${changes.join(', ')}'
        : 'لم يتم إجراء أي تغييرات';
  }
}
