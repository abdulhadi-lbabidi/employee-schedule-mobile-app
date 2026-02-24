// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive/hive.dart' as _i979;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/admin/data/datasources/admin_remote_data_source_impl.dart'
    as _i14;
import '../../features/admin/data/datasources/workshop_locale_data_source.dart'
    as _i573;
import '../../features/admin/data/datasources/workshop_remote_data_source_impl.dart'
    as _i1069;
import '../../features/admin/data/models/workshop_models/workshop_model.g.dart'
    as _i493;
import '../../features/admin/data/repositories/admin_repository_impl.dart'
    as _i335;
import '../../features/admin/data/repositories/audit_log_repository.dart'
    as _i184;
import '../../features/admin/data/repositories/workshop_repository_impl.dart'
    as _i429;
import '../../features/admin/domain/repositories/admin_repository.dart'
    as _i583;
import '../../features/admin/domain/repositories/workshop_repository.dart'
    as _i200;
import '../../features/admin/domain/usecases/add_employee.dart' as _i541;
import '../../features/admin/domain/usecases/add_workshop.dart' as _i982;
import '../../features/admin/domain/usecases/confirm_payment.dart' as _i1024;
import '../../features/admin/domain/usecases/delete_employee.dart' as _i381;
import '../../features/admin/domain/usecases/delete_workshop.dart' as _i173;
import '../../features/admin/domain/usecases/get_all_archive_employee_use_case.dart'
    as _i351;
import '../../features/admin/domain/usecases/get_all_archived_workshop_use_case.dart'
    as _i578;
import '../../features/admin/domain/usecases/get_all_employees.dart' as _i345;
import '../../features/admin/domain/usecases/get_all_workshop_use_case.dart'
    as _i217;
import '../../features/admin/domain/usecases/get_dashboard_data_usecase.dart'
    as _i462;
import '../../features/admin/domain/usecases/get_employee_details.dart'
    as _i253;
import '../../features/admin/domain/usecases/get_employee_details_hours_use_case.dart'
    as _i47;
import '../../features/admin/domain/usecases/get_online_employees.dart'
    as _i940;
import '../../features/admin/domain/usecases/get_workshop_employee_details_use_case.dart'
    as _i448;
import '../../features/admin/domain/usecases/restore_employee_archive_use_case.dart'
    as _i539;
import '../../features/admin/domain/usecases/restore_workshop_use_case.dart'
    as _i19;
import '../../features/admin/domain/usecases/toggle_employee_archive.dart'
    as _i368;
import '../../features/admin/domain/usecases/toggle_workshop_archive.dart'
    as _i849;
import '../../features/admin/domain/usecases/update_employee_full_details.dart'
    as _i668;
import '../../features/admin/domain/usecases/update_hourly_rate.dart' as _i547;
import '../../features/admin/domain/usecases/update_overtime_rate.dart'
    as _i949;
import '../../features/admin/presentation/bloc/admin_dashboard/admin_dashboard_bloc.dart'
    as _i371;
import '../../features/admin/presentation/bloc/admin_profile/admin_profile_bloc.dart'
    as _i1018;
import '../../features/admin/presentation/bloc/employee_details/employee_details_bloc.dart'
    as _i125;
import '../../features/admin/presentation/bloc/employees/employees_bloc.dart'
    as _i934;
import '../../features/admin/presentation/bloc/workshops/workshops_bloc.dart'
    as _i331;
import '../../features/Attendance/data/data_source/attendance_locale_data_source.dart'
    as _i241;
import '../../features/Attendance/data/data_source/attendance_remote_data.dart'
    as _i220;
import '../../features/Attendance/data/repository/attendance_repository_impl.dart'
    as _i54;
import '../../features/Attendance/data/repository/WorkshopsRepository.dart'
    as _i976;
import '../../features/Attendance/domin/repositories/attendance_repositories.dart'
    as _i240;
import '../../features/Attendance/domin/use_cases/get_employee_attendance_use_case.dart'
    as _i538;
import '../../features/Attendance/domin/use_cases/sync_attendance_use_case.dart'
    as _i0;
import '../../features/Attendance/presentation/bloc/attendance_bloc.dart'
    as _i951;
import '../../features/auth/data/datasource/authRemoteDataSourceImpl.dart'
    as _i87;
import '../../features/auth/data/repository/login_repo.dart' as _i675;
import '../../features/auth/presentation/bloc/login_Cubit/login_cubit.dart'
    as _i424;
import '../../features/employee/data/datasources/employee_summary_remote_data_source.dart'
    as _i921;
import '../../features/employee/data/repositories/employee_summary_repository_impl.dart'
    as _i183;
import '../../features/employee/domain/repositories/employee_summary_repository.dart'
    as _i482;
import '../../features/employee/domain/usecases/get_employee_summary_usecase.dart'
    as _i443;
import '../../features/employee/presentation/bloc/employee_summary/employee_summary_bloc.dart'
    as _i390;
import '../../features/home/presentation/bloc/cubit_active_unactive/active_unactive_cubit.dart'
    as _i36;
import '../../features/home/presentation/bloc/Cubit_Button/button_cubit.dart'
    as _i492;
import '../../features/home/presentation/bloc/Cubit_dropdown/dropdown_cubit.dart'
    as _i402;
import '../../features/home/presentation/bloc/Cubit_Navigation/navigation_cubit.dart'
    as _i208;
import '../../features/home/presentation/bloc/finance/finance_bloc.dart'
    as _i964;
import '../../features/loan/data/datasources/loan_local_data_source.dart'
    as _i251;
import '../../features/loan/data/datasources/loan_remote_data_source_impl.dart'
    as _i851;
import '../../features/loan/data/repositories/loan_repository_impl.dart'
    as _i609;
import '../../features/loan/domain/repositories/loan_repository.dart' as _i415;
import '../../features/loan/domain/usecases/add_loan_usecase.dart' as _i28;
import '../../features/loan/domain/usecases/approve_loan_usecase.dart' as _i941;
import '../../features/loan/domain/usecases/get_all_loans_usecase.dart'
    as _i150;
import '../../features/loan/domain/usecases/get_employee_loans_usecase.dart'
    as _i363;
import '../../features/loan/domain/usecases/pay_loan_usecase.dart' as _i560;
import '../../features/loan/domain/usecases/record_payment_usecase.dart'
    as _i850;
import '../../features/loan/domain/usecases/reject_loan_usecase.dart' as _i579;
import '../../features/loan/domain/usecases/update_loan_status_usecase.dart'
    as _i226;
import '../../features/loan/presentation/bloc/loan_bloc.dart' as _i408;
import '../../features/Notification/data/datasources/notification_remote_data_source.dart'
    as _i306;
import '../../features/Notification/data/repositories/notification_repository_impl.dart'
    as _i558;
import '../../features/Notification/domain/repositories/notification_repository.dart'
    as _i697;
import '../../features/Notification/domain/usecases/check_in_use_case.dart'
    as _i516;
import '../../features/Notification/domain/usecases/check_out_use_case.dart'
    as _i351;
import '../../features/Notification/domain/usecases/get_notifications.dart'
    as _i585;
import '../../features/Notification/domain/usecases/send_notification_use_case.dart'
    as _i17;
import '../../features/Notification/presentation/bloc/notification_bloc.dart'
    as _i23;
import '../../features/payments/data/datasources/payments_data_sources_impl.dart'
    as _i65;
import '../../features/payments/data/repositories/payments_repository_impl.dart'
    as _i565;
import '../../features/payments/domain/payments_repository/paymenys_repository.dart'
    as _i88;
import '../../features/payments/domain/usecases/get_all_payments_uescese.dart'
    as _i5;
import '../../features/payments/domain/usecases/get_dues_report.dart' as _i879;
import '../../features/payments/domain/usecases/get_unpaid_weeks_params.dart'
    as _i4;
import '../../features/payments/domain/usecases/get_unpaid_weeks_usecase.dart'
    as _i133;
import '../../features/payments/domain/usecases/post_payrecords_params.dart'
    as _i699;
import '../../features/payments/domain/usecases/post_payrecords_useCase.dart'
    as _i992;
import '../../features/payments/domain/usecases/update_payment_params.dart'
    as _i803;
import '../../features/payments/domain/usecases/update_payment_usecase.dart'
    as _i1029;
import '../../features/payments/presentation/bloc/All-Payments/all_payments_bloc.dart'
    as _i705;
import '../../features/payments/presentation/bloc/dues-report/dues_report_bloc.dart'
    as _i467;
import '../../features/payments/presentation/bloc/PaymentAction/payment_action_bloc.dart'
    as _i427;
import '../../features/payments/presentation/bloc/UnpaidWeeks/unpaid_weeks_bloc.dart'
    as _i84;
import '../../features/profile/data/datasources/update_password_remote_data_source.dart'
    as _i138;
import '../../features/profile/data/repositories/profile_repository_impl.dart'
    as _i334;
import '../../features/profile/domain/repositories/profile_repository.dart'
    as _i894;
import '../../features/profile/domain/usecases/update_password_usecase.dart'
    as _i525;
import '../../features/profile/domain/usecases/update_profile_info_usecase.dart'
    as _i389;
import '../../features/profile/presentation/bloc/Profile/_profile_bloc.dart'
    as _i207;
import '../../features/reward/data/datasources/reward_remote_data_source.dart'
    as _i777;
import '../../features/reward/data/datasources/reward_remote_data_source_impl.dart'
    as _i22;
import '../../features/reward/data/repositories/reward_repository_impl.dart'
    as _i144;
import '../../features/reward/domain/repositories/reward_repository.dart'
    as _i180;
import '../../features/reward/domain/usecases/get_admin_rewards.dart' as _i1;
import '../../features/reward/domain/usecases/get_employee_rewards.dart'
    as _i1050;
import '../../features/reward/domain/usecases/issue_reward.dart' as _i679;
import '../../features/reward/presentation/bloc/reward_admin/reward_admin_bloc.dart'
    as _i830;
import '../../features/reward/presentation/bloc/reward_employee/reward_employee_bloc.dart'
    as _i467;
import '../../features/SplashScreen/presentation/bloc/onboarding_bloc.dart'
    as _i653;
import '../hive_service.dart' as _i351;
import '../unified_api/base_api.dart' as _i893;
import '../unified_api/logger_interceptor.dart' as _i424;
import 'injection.dart' as _i464;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final injectableModule = _$InjectableModule();
  gh.factory<_i1018.AdminProfileBloc>(() => _i1018.AdminProfileBloc());
  gh.factory<_i402.DropdownCubit>(() => _i402.DropdownCubit());
  gh.factory<_i208.NavigationnCubit>(() => _i208.NavigationnCubit());
  gh.factory<_i964.FinanceBloc>(() => _i964.FinanceBloc());
  gh.factory<_i653.OnboardingBloc>(() => _i653.OnboardingBloc());
  gh.singleton<_i361.Dio>(() => injectableModule.dio);
  gh.singleton<_i895.Connectivity>(() => injectableModule.connectivity);
  gh.singleton<_i558.FlutterSecureStorage>(
      () => injectableModule.secureStorage);
  gh.lazySingleton<_i351.HiveService>(() => _i351.HiveService());
  gh.lazySingleton<_i424.LoggerInterceptor>(() => _i424.LoggerInterceptor());
  gh.lazySingleton<_i251.LoanLocalDataSource>(
      () => _i251.LoanLocalDataSource(gh<_i460.SharedPreferences>()));
  gh.lazySingleton<_i184.AuditLogRepository>(
      () => _i184.AuditLogRepository(gh<_i460.SharedPreferences>()));
  gh.factory<_i4.GetUnpaidWeeksParams>(
      () => _i4.GetUnpaidWeeksParams(employeeId: gh<String>()));
  gh.factory<_i699.PostPayRecordsParams>(() => _i699.PostPayRecordsParams(
        employeeId: gh<int>(),
        attendanceIds: gh<List<int>>(),
        amountPaid: gh<double>(),
        paymentDate: gh<String>(),
      ));
  gh.factory<_i36.ActiveUnactiveCubit>(
      () => _i36.ActiveUnactiveCubit(gh<_i351.HiveService>()));
  gh.factory<_i492.ButtonCubit>(
      () => _i492.ButtonCubit(gh<_i351.HiveService>()));
  gh.lazySingleton<_i976.WorkshopsRepository>(() => _i976.WorkshopsRepository(
        dio: gh<_i361.Dio>(),
        workshopsBox: gh<_i979.Box<_i493.WorkshopModel>>(),
        connectivity: gh<_i895.Connectivity>(),
      ));
  gh.factory<_i803.UpdatePaymentParams>(() => _i803.UpdatePaymentParams(
        paymentId: gh<String>(),
        amountPaid: gh<double>(),
        paymentDate: gh<String>(),
        attendanceIds: gh<List<int>>(),
      ));
  gh.lazySingleton<_i893.BaseApi>(() => _i893.BaseApi(
        gh<_i361.Dio>(),
        loggingInterceptor: gh<_i424.LoggerInterceptor>(),
      ));
  gh.lazySingleton<_i22.RewardRemoteDataSourceImpl>(
      () => _i22.RewardRemoteDataSourceImpl(dio: gh<_i361.Dio>()));
  gh.lazySingleton<_i573.WorkshopLocaleDataSource>(() =>
      _i573.WorkshopLocaleDataSource(
          sharedPreferences: gh<_i460.SharedPreferences>()));
  gh.lazySingleton<_i241.AttendanceLocaleDataSource>(() =>
      _i241.AttendanceLocaleDataSource(
          sharedPreferences: gh<_i460.SharedPreferences>()));
  gh.lazySingleton<_i921.EmployeeSummaryRemoteDataSource>(
      () => _i921.EmployeeSummaryRemoteDataSource(gh<_i893.BaseApi>()));
  gh.lazySingleton<_i138.UpdatePasswordRemoteDataSource>(
      () => _i138.UpdatePasswordRemoteDataSource(gh<_i893.BaseApi>()));
  gh.lazySingleton<_i777.RewardRemoteDataSource>(
      () => _i777.RewardRemoteDataSource(gh<_i893.BaseApi>()));
  gh.lazySingleton<_i482.EmployeeSummaryRepository>(() =>
      _i183.EmployeeSummaryRepositoryImpl(
          remoteDataSource: gh<_i921.EmployeeSummaryRemoteDataSource>()));
  gh.lazySingleton<_i180.RewardRepository>(() => _i144.RewardRepositoryImpl(
      remoteDataSource: gh<_i777.RewardRemoteDataSource>()));
  gh.lazySingleton<_i14.AdminRemoteDataSourceImpl>(
      () => _i14.AdminRemoteDataSourceImpl(baseApi: gh<_i893.BaseApi>()));
  gh.lazySingleton<_i1069.WorkshopRemoteDataSource>(
      () => _i1069.WorkshopRemoteDataSource(baseApi: gh<_i893.BaseApi>()));
  gh.lazySingleton<_i220.AttendanceRemoteData>(
      () => _i220.AttendanceRemoteData(baseApi: gh<_i893.BaseApi>()));
  gh.lazySingleton<_i87.AuthRemoteDataSourceImpl>(
      () => _i87.AuthRemoteDataSourceImpl(baseApi: gh<_i893.BaseApi>()));
  gh.lazySingleton<_i851.LoanRemoteDataSourceImpl>(
      () => _i851.LoanRemoteDataSourceImpl(baseApi: gh<_i893.BaseApi>()));
  gh.lazySingleton<_i306.NotificationRemoteDataSourceImpl>(() =>
      _i306.NotificationRemoteDataSourceImpl(baseApi: gh<_i893.BaseApi>()));
  gh.lazySingleton<_i65.PaymentsDataSourcesImpl>(
      () => _i65.PaymentsDataSourcesImpl(baseApi: gh<_i893.BaseApi>()));
  gh.lazySingleton<_i415.LoanRepository>(() => _i609.LoanRepositoryImpl(
        remoteDataSource: gh<_i851.LoanRemoteDataSourceImpl>(),
        localDataSource: gh<_i251.LoanLocalDataSource>(),
      ));
  gh.factory<_i941.ApproveLoanUseCase>(
      () => _i941.ApproveLoanUseCase(gh<_i415.LoanRepository>()));
  gh.factory<_i560.PayLoanUseCase>(
      () => _i560.PayLoanUseCase(gh<_i415.LoanRepository>()));
  gh.factory<_i579.RejectLoanUseCase>(
      () => _i579.RejectLoanUseCase(gh<_i415.LoanRepository>()));
  gh.lazySingleton<_i28.AddLoanUseCase>(
      () => _i28.AddLoanUseCase(gh<_i415.LoanRepository>()));
  gh.lazySingleton<_i150.GetAllLoansUseCase>(
      () => _i150.GetAllLoansUseCase(gh<_i415.LoanRepository>()));
  gh.lazySingleton<_i363.GetEmployeeLoansUseCase>(
      () => _i363.GetEmployeeLoansUseCase(gh<_i415.LoanRepository>()));
  gh.lazySingleton<_i850.RecordPaymentUseCase>(
      () => _i850.RecordPaymentUseCase(gh<_i415.LoanRepository>()));
  gh.lazySingleton<_i226.UpdateLoanStatusUseCase>(
      () => _i226.UpdateLoanStatusUseCase(gh<_i415.LoanRepository>()));
  gh.factory<_i443.GetEmployeeSummaryUseCase>(() =>
      _i443.GetEmployeeSummaryUseCase(gh<_i482.EmployeeSummaryRepository>()));
  gh.lazySingleton<_i894.ProfileRepository>(() =>
      _i334.ProfileRepositoryImpl(gh<_i138.UpdatePasswordRemoteDataSource>()));
  gh.lazySingleton<_i240.AttendanceRepositories>(
      () => _i54.AttendanceRepositoryImpl(
            remote: gh<_i220.AttendanceRemoteData>(),
            local: gh<_i241.AttendanceLocaleDataSource>(),
            connectivity: gh<_i895.Connectivity>(),
          ));
  gh.lazySingleton<_i583.AdminRepository>(
      () => _i335.AdminRepositoryImpl(gh<_i14.AdminRemoteDataSourceImpl>()));
  gh.factory<_i1.GetAdminRewardsUseCase>(
      () => _i1.GetAdminRewardsUseCase(gh<_i180.RewardRepository>()));
  gh.factory<_i679.IssueRewardUseCase>(
      () => _i679.IssueRewardUseCase(gh<_i180.RewardRepository>()));
  gh.lazySingleton<_i1050.GetEmployeeRewardsUseCase>(
      () => _i1050.GetEmployeeRewardsUseCase(gh<_i180.RewardRepository>()));
  gh.lazySingleton<_i538.GetEmployeeAttendanceUseCase>(() =>
      _i538.GetEmployeeAttendanceUseCase(
          authRepositories: gh<_i240.AttendanceRepositories>()));
  gh.lazySingleton<_i675.AuthRepository>(() => _i675.AuthRepository(
        remoteDataSource: gh<_i87.AuthRemoteDataSourceImpl>(),
        secureStorage: gh<_i558.FlutterSecureStorage>(),
      ));
  gh.lazySingleton<_i88.PaymenysRepository>(() =>
      _i565.PaymentsRepositoryImpl(remote: gh<_i65.PaymentsDataSourcesImpl>()));
  gh.lazySingleton<_i697.NotificationRepository>(
      () => _i558.NotificationRepositoryImpl(
            hiveService: gh<_i351.HiveService>(),
            remoteDataSource: gh<_i306.NotificationRemoteDataSourceImpl>(),
          ));
  gh.lazySingleton<_i0.SyncAttendanceUseCase>(() => _i0.SyncAttendanceUseCase(
      repositories: gh<_i240.AttendanceRepositories>()));
  gh.factory<_i467.RewardEmployeeBloc>(() => _i467.RewardEmployeeBloc(
      getEmployeeRewardsUseCase: gh<_i1050.GetEmployeeRewardsUseCase>()));
  gh.factory<_i525.UpdatePasswordUseCase>(
      () => _i525.UpdatePasswordUseCase(gh<_i894.ProfileRepository>()));
  gh.factory<_i389.UpdateProfileInfoUseCase>(
      () => _i389.UpdateProfileInfoUseCase(gh<_i894.ProfileRepository>()));
  gh.factory<_i390.EmployeeSummaryBloc>(() => _i390.EmployeeSummaryBloc(
      getEmployeeSummaryUseCase: gh<_i443.GetEmployeeSummaryUseCase>()));
  gh.factory<_i207.ProfileBloc>(() => _i207.ProfileBloc(
        gh<_i675.AuthRepository>(),
        gh<_i525.UpdatePasswordUseCase>(),
        gh<_i389.UpdateProfileInfoUseCase>(),
      ));
  gh.factory<_i516.CheckInUseCase>(
      () => _i516.CheckInUseCase(gh<_i697.NotificationRepository>()));
  gh.factory<_i351.CheckOutUseCase>(
      () => _i351.CheckOutUseCase(gh<_i697.NotificationRepository>()));
  gh.factory<_i585.GetNotificationsUseCase>(
      () => _i585.GetNotificationsUseCase(gh<_i697.NotificationRepository>()));
  gh.factory<_i17.SendNotificationUseCase>(
      () => _i17.SendNotificationUseCase(gh<_i697.NotificationRepository>()));
  gh.lazySingleton<_i200.WorkshopRepository>(() => _i429.WorkshopRepositoryImpl(
        remoteDataSource: gh<_i1069.WorkshopRemoteDataSource>(),
        localeDataSource: gh<_i573.WorkshopLocaleDataSource>(),
      ));
  gh.lazySingleton<_i351.GetAllArchiveEmployeeUseCase>(
      () => _i351.GetAllArchiveEmployeeUseCase(gh<_i583.AdminRepository>()));
  gh.lazySingleton<_i345.GetAllEmployeesUseCase>(
      () => _i345.GetAllEmployeesUseCase(gh<_i583.AdminRepository>()));
  gh.lazySingleton<_i462.GetDashboardDataUsecase>(
      () => _i462.GetDashboardDataUsecase(gh<_i583.AdminRepository>()));
  gh.factory<_i668.UpdateEmployeeFullDetailsUseCase>(() =>
      _i668.UpdateEmployeeFullDetailsUseCase(gh<_i583.AdminRepository>()));
  gh.lazySingleton<_i541.AddEmployeeUseCase>(
      () => _i541.AddEmployeeUseCase(gh<_i583.AdminRepository>()));
  gh.lazySingleton<_i1024.ConfirmPaymentUseCase>(
      () => _i1024.ConfirmPaymentUseCase(gh<_i583.AdminRepository>()));
  gh.lazySingleton<_i381.DeleteEmployeeUseCase>(
      () => _i381.DeleteEmployeeUseCase(gh<_i583.AdminRepository>()));
  gh.lazySingleton<_i253.GetEmployeeDetailsUseCase>(
      () => _i253.GetEmployeeDetailsUseCase(gh<_i583.AdminRepository>()));
  gh.lazySingleton<_i47.GetEmployeeDetailsHoursUseCase>(
      () => _i47.GetEmployeeDetailsHoursUseCase(gh<_i583.AdminRepository>()));
  gh.lazySingleton<_i940.GetOnlineEmployeesUseCase>(
      () => _i940.GetOnlineEmployeesUseCase(gh<_i583.AdminRepository>()));
  gh.lazySingleton<_i539.RestoreEmployeeArchiveUseCase>(
      () => _i539.RestoreEmployeeArchiveUseCase(gh<_i583.AdminRepository>()));
  gh.lazySingleton<_i368.ToggleEmployeeArchiveUseCase>(
      () => _i368.ToggleEmployeeArchiveUseCase(gh<_i583.AdminRepository>()));
  gh.lazySingleton<_i547.UpdateHourlyRateUseCase>(
      () => _i547.UpdateHourlyRateUseCase(gh<_i583.AdminRepository>()));
  gh.lazySingleton<_i949.UpdateOvertimeRateUseCase>(
      () => _i949.UpdateOvertimeRateUseCase(gh<_i583.AdminRepository>()));
  gh.lazySingleton<_i951.AttendanceBloc>(() => _i951.AttendanceBloc(
        gh<_i538.GetEmployeeAttendanceUseCase>(),
        gh<_i0.SyncAttendanceUseCase>(),
      ));
  gh.lazySingleton<_i578.GetAllArchivedWorkshopUseCase>(() =>
      _i578.GetAllArchivedWorkshopUseCase(
          repository: gh<_i200.WorkshopRepository>()));
  gh.lazySingleton<_i217.GetAllWorkshopUseCase>(() =>
      _i217.GetAllWorkshopUseCase(repository: gh<_i200.WorkshopRepository>()));
  gh.lazySingleton<_i448.GetWorkshopEmployeeDetailsUseCase>(() =>
      _i448.GetWorkshopEmployeeDetailsUseCase(
          repository: gh<_i200.WorkshopRepository>()));
  gh.lazySingleton<_i982.AddWorkshopUseCase>(
      () => _i982.AddWorkshopUseCase(gh<_i200.WorkshopRepository>()));
  gh.lazySingleton<_i173.DeleteWorkshopUseCase>(
      () => _i173.DeleteWorkshopUseCase(gh<_i200.WorkshopRepository>()));
  gh.lazySingleton<_i19.RestoreWorkshopUseCase>(
      () => _i19.RestoreWorkshopUseCase(gh<_i200.WorkshopRepository>()));
  gh.lazySingleton<_i849.ToggleWorkshopArchiveUseCase>(
      () => _i849.ToggleWorkshopArchiveUseCase(gh<_i200.WorkshopRepository>()));
  gh.factory<_i125.EmployeeDetailsBloc>(() => _i125.EmployeeDetailsBloc(
        gh<_i47.GetEmployeeDetailsHoursUseCase>(),
        gh<_i253.GetEmployeeDetailsUseCase>(),
        gh<_i547.UpdateHourlyRateUseCase>(),
        gh<_i949.UpdateOvertimeRateUseCase>(),
        gh<_i1024.ConfirmPaymentUseCase>(),
        gh<_i381.DeleteEmployeeUseCase>(),
        gh<_i368.ToggleEmployeeArchiveUseCase>(),
        gh<_i14.AdminRemoteDataSourceImpl>(),
        gh<_i184.AuditLogRepository>(),
        gh<_i668.UpdateEmployeeFullDetailsUseCase>(),
      ));
  gh.factory<_i830.RewardAdminBloc>(() => _i830.RewardAdminBloc(
        getAdminRewardsUseCase: gh<_i1.GetAdminRewardsUseCase>(),
        issueRewardUseCase: gh<_i679.IssueRewardUseCase>(),
        getAllEmployeesUseCase: gh<_i345.GetAllEmployeesUseCase>(),
      ));
  gh.factory<_i331.WorkshopsBloc>(() => _i331.WorkshopsBloc(
        gh<_i217.GetAllWorkshopUseCase>(),
        gh<_i982.AddWorkshopUseCase>(),
        gh<_i173.DeleteWorkshopUseCase>(),
        gh<_i849.ToggleWorkshopArchiveUseCase>(),
        gh<_i448.GetWorkshopEmployeeDetailsUseCase>(),
        gh<_i19.RestoreWorkshopUseCase>(),
        gh<_i578.GetAllArchivedWorkshopUseCase>(),
      ));
  gh.factory<_i424.LoginCubit>(
      () => _i424.LoginCubit(repository: gh<_i675.AuthRepository>()));
  gh.factory<_i23.NotificationBloc>(() => _i23.NotificationBloc(
        gh<_i585.GetNotificationsUseCase>(),
        gh<_i17.SendNotificationUseCase>(),
        gh<_i516.CheckInUseCase>(),
        gh<_i351.CheckOutUseCase>(),
      ));
  gh.lazySingleton<_i5.GetAllPaymentsUescese>(
      () => _i5.GetAllPaymentsUescese(gh<_i88.PaymenysRepository>()));
  gh.lazySingleton<_i879.GetDuesReport>(
      () => _i879.GetDuesReport(gh<_i88.PaymenysRepository>()));
  gh.lazySingleton<_i133.GetUnpaidWeeksUseCase>(
      () => _i133.GetUnpaidWeeksUseCase(gh<_i88.PaymenysRepository>()));
  gh.lazySingleton<_i992.PostPayRecordsUseCase>(
      () => _i992.PostPayRecordsUseCase(gh<_i88.PaymenysRepository>()));
  gh.lazySingleton<_i1029.UpdatePaymentUseCase>(
      () => _i1029.UpdatePaymentUseCase(gh<_i88.PaymenysRepository>()));
  gh.factory<_i467.DuesReportBloc>(
      () => _i467.DuesReportBloc(gh<_i879.GetDuesReport>()));
  gh.factory<_i934.EmployeesBloc>(() => _i934.EmployeesBloc(
        gh<_i345.GetAllEmployeesUseCase>(),
        gh<_i541.AddEmployeeUseCase>(),
        gh<_i368.ToggleEmployeeArchiveUseCase>(),
        gh<_i351.GetAllArchiveEmployeeUseCase>(),
        gh<_i539.RestoreEmployeeArchiveUseCase>(),
      ));
  gh.factory<_i371.AdminDashboardBloc>(
      () => _i371.AdminDashboardBloc(gh<_i462.GetDashboardDataUsecase>()));
  gh.factory<_i427.PaymentActionBloc>(() => _i427.PaymentActionBloc(
        gh<_i992.PostPayRecordsUseCase>(),
        gh<_i1029.UpdatePaymentUseCase>(),
      ));
  gh.factory<_i84.UnpaidWeeksBloc>(
      () => _i84.UnpaidWeeksBloc(gh<_i133.GetUnpaidWeeksUseCase>()));
  gh.factory<_i408.LoanBloc>(() => _i408.LoanBloc(
        gh<_i150.GetAllLoansUseCase>(),
        gh<_i363.GetEmployeeLoansUseCase>(),
        gh<_i28.AddLoanUseCase>(),
        gh<_i941.ApproveLoanUseCase>(),
        gh<_i579.RejectLoanUseCase>(),
        gh<_i560.PayLoanUseCase>(),
        gh<_i23.NotificationBloc>(),
      ));
  gh.factory<_i705.AllPaymentsBloc>(
      () => _i705.AllPaymentsBloc(gh<_i5.GetAllPaymentsUescese>()));
  return getIt;
}

class _$InjectableModule extends _i464.InjectableModule {}
