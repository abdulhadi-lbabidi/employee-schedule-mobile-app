import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../admin/data/datasources/admin_remote_data_source.dart';
import '../../../../admin/data/repositories/audit_log_repository.dart';
import '../../../data/mappers/employee_to_datum_mapper.dart';
import '../../../domain/entities/employee_entity.dart';
import '../../../domain/usecases/confirm_payment.dart';
import '../../../domain/usecases/delete_employee.dart';
import '../../../domain/usecases/get_employee_details.dart';
import '../../../domain/usecases/update_hourly_rate.dart';
import '../../../domain/usecases/update_overtime_rate.dart';
import '../../../domain/usecases/toggle_employee_archive.dart';
import 'employee_details_event.dart';
import 'employee_details_state.dart';
@injectable
class EmployeeDetailsBloc
    extends Bloc<EmployeeDetailsEvent, EmployeeDetailsState> {
  final GetEmployeeDetailsUseCase getEmployeeDetailsUseCase;
  final UpdateHourlyRateUseCase updateHourlyRateUseCase;
  final UpdateOvertimeRateUseCase updateOvertimeRateUseCase;
  final ConfirmPaymentUseCase confirmPaymentUseCase;
  final DeleteEmployeeUseCase deleteEmployeeUseCase;
  final ToggleEmployeeArchiveUseCase toggleEmployeeArchiveUseCase;
  final AdminRemoteDataSource remoteDataSource;
  final AuditLogRepository auditLogRepository;

  EmployeeEntity? _employee;

  EmployeeDetailsBloc(
      this.getEmployeeDetailsUseCase,
      this.updateHourlyRateUseCase,
      this.updateOvertimeRateUseCase,
      this.confirmPaymentUseCase,
      this.deleteEmployeeUseCase,
      this.toggleEmployeeArchiveUseCase,
      this.remoteDataSource,
      this.auditLogRepository,
      ) : super(EmployeeDetailsInitial()) {
    on<LoadEmployeeDetailsEvent>(_onLoadDetails);
    on<UpdateHourlyRateEvent>(_onUpdateHourlyRate);
    on<UpdateOvertimeRateEvent>(_onUpdateOvertimeRate);
    on<ConfirmPaymentEvent>(_onConfirmPayment);
    on<DeleteEmployeeEvent>(_onDeleteEmployee);
    on<ToggleArchiveEmployeeDetailEvent>(_onToggleArchiveEmployee);
    on<UpdateEmployeeFullEvent>(_onUpdateFullEmployee);
  }

  Future<void> _onLoadDetails(
      LoadEmployeeDetailsEvent event,
      Emitter<EmployeeDetailsState> emit,
      ) async {
    emit(EmployeeDetailsLoading());
    try {
      _employee = await getEmployeeDetailsUseCase(event.employeeId);
      emit(EmployeeDetailsLoaded(_employee!));
    } catch (e) {
      debugPrint('Error loading employee details: $e');
      emit(EmployeeDetailsError('فشل تحميل بيانات الموظف'));
    }
  }

  Future<void> _onToggleArchiveEmployee(
      ToggleArchiveEmployeeDetailEvent event,
      Emitter<EmployeeDetailsState> emit,
      ) async {
    if (_employee == null) return;
    try {
      await toggleEmployeeArchiveUseCase(event.employeeId, event.isArchived);
      _employee = _employee!.copyWith(isArchived: event.isArchived);
      emit(EmployeeDetailsLoaded(_employee!));

      await auditLogRepository.logAction(
        actionType: event.isArchived ? "أرشفة موظف" : "إلغاء أرشفة موظف",
        targetName: _employee!.name,
        details: event.isArchived
            ? "تمت أرشفة الموظف"
            : "تمت إعادة تنشيط الموظف",
      );
    } catch (e) {
      debugPrint('Error toggling employee archive: $e');
      emit(EmployeeDetailsError('فشل تغيير حالة الأرشفة'));
    }
  }

  Future<void> _onConfirmPayment(
      ConfirmPaymentEvent event,
      Emitter<EmployeeDetailsState> emit,
      ) async {
    try {
      final currentEmp = event.employee;
      emit(HourlyRateUpdating(currentEmp));

      if (event.isFullPayment) {
        await confirmPaymentUseCase(
          employeeId: currentEmp.id,
          weekNumber: event.weekNumber,
        );
      }

      await auditLogRepository.logAction(
        actionType: event.isFullPayment
            ? "تأكيد صرف رواتب كاملة"
            : "صرف دفعة جزئية",
        targetName: currentEmp.name,
        details: event.isFullPayment
            ? "دفع مستحقات الأسبوع ${event.weekNumber} بالكامل"
            : "دفع مبلغ ${event.amountPaid} ل.س من مستحقات الأسبوع ${event.weekNumber}",
      );

      final updatedHistory = currentEmp.weeklyHistory.map((week) {
        if (week.weekNumber == event.weekNumber) {
          double newAmountPaid = week.amountPaid + event.amountPaid;
          return WeeklyWorkHistory(
            weekNumber: week.weekNumber,
            month: week.month,
            year: week.year,
            workshops: week.workshops,
            isPaid: event.isFullPayment,
            amountPaid: newAmountPaid,
          );
        }
        return week;
      }).toList();

      final updatedEmployee = currentEmp.copyWith(
        weeklyHistory: updatedHistory,
      );

      _employee = updatedEmployee;
      emit(EmployeeDetailsLoaded(updatedEmployee));
    } catch (e) {
      debugPrint('Error confirming payment: $e');
      emit(EmployeeDetailsError('فشل العملية: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateFullEmployee(
      UpdateEmployeeFullEvent event,
      Emitter<EmployeeDetailsState> emit,
      ) async {
    if (_employee == null) return;

    emit(EmployeeDetailsLoading());

    try {
      final oldEmployee = _employee!;

      final updatedEmployee = _employee!.copyWith(
        name: event.name,
        phoneNumber: event.phoneNumber,
        workshopName: event.workshop,
        hourlyRate: event.hourlyRate,
        overtimeRate: event.overtimeRate,
      );

      // ✅ التصحيح: استخدام toDatumModel() كـ Extension
      final updatedDatum = updatedEmployee.toDatumModel();

      await remoteDataSource.updateEmployee(updatedDatum);

      _employee = updatedEmployee;

      await auditLogRepository.logAction(
        actionType: "تحديث بيانات الموظف",
        targetName: _employee!.name,
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
      ) async {
    emit(EmployeeDetailsLoading());
    try {
      await deleteEmployeeUseCase(event.employeeId);

      // Log audit action for employee deletion
      if (_employee != null) {
        await auditLogRepository.logAction(
          actionType: "حذف موظف",
          targetName: _employee!.name,
          details: "تم حذف الموظف بنجاح",
        );
      }

      emit(EmployeeDeleted());
    } catch (e) {
      debugPrint('Error deleting employee: $e');
      emit(EmployeeDetailsError('فشل حذف الموظف: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateHourlyRate(
      UpdateHourlyRateEvent event,
      Emitter<EmployeeDetailsState> emit,
      ) async {
    if (_employee == null) return;
    try {
      emit(HourlyRateUpdating(_employee!));
      await updateHourlyRateUseCase(
        employeeId: _employee!.id,
        newRate: event.newRate,
      );

      final oldRate = _employee!.hourlyRate;
      _employee = _employee!.copyWith(hourlyRate: event.newRate);

      // Log audit action for hourly rate update
      await auditLogRepository.logAction(
        actionType: "تحديث الراتب الساعي",
        targetName: _employee!.name,
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
        employeeId: _employee!.id,
        newRate: event.newRate,
      );

      final oldRate = _employee!.overtimeRate;
      _employee = _employee!.copyWith(overtimeRate: event.newRate);

      // Log audit action for overtime rate update
      await auditLogRepository.logAction(
        actionType: "تحديث معدل الإضافي",
        targetName: _employee!.name,
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
      EmployeeEntity oldEmployee,
      UpdateEmployeeFullEvent event,
      ) {
    final changes = <String>[];

    if (oldEmployee.name != event.name) {
      changes.add('الاسم: من "${oldEmployee.name}" إلى "${event.name}"');
    }
    if (oldEmployee.phoneNumber != event.phoneNumber) {
      changes.add(
        'رقم الهاتف: من "${oldEmployee.phoneNumber}" إلى "${event.phoneNumber}"',
      );
    }
    if (oldEmployee.workshopName != event.workshop) {
      changes.add(
        'ورشة العمل: من "${oldEmployee.workshopName}" إلى "${event.workshop}"',
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
