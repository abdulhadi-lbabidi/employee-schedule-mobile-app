import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:untitled8/core/services/sync_service.dart';
import 'package:untitled8/core/utils/app_strings.dart';
import 'package:untitled8/core/unified_api/base_api.dart'; 
import 'package:untitled8/core/unified_api/auth_interceptor.dart';

import '../../data/remote/remote_data_source.dart';
import '../../data/local/local_data_source.dart';

import 'package:untitled8/data/repository/app_repository.dart';
import 'package:untitled8/features/Attendance/Repository/AttendanceRepository.dart';
import 'package:untitled8/features/Attendance/data/repository/WorkshopsRepository.dart';
import 'package:untitled8/features/Attendance/data/models/attendance_record.dart'; 
import 'package:untitled8/features/Attendance/pages/bloc/Cubit_Attendance/attendance_cubit.dart';
import 'package:untitled8/features/Notification/data/datasources/notification_remote_data_source.dart';
import 'package:untitled8/features/Notification/data/model/notification_model.dart';
import 'package:untitled8/features/Notification/data/repositories/notification_repository_impl.dart';
import 'package:untitled8/features/Notification/domain/repositories/notification_repository.dart';
import 'package:untitled8/features/Notification/presentation/bloc/notification_bloc.dart';
import 'package:untitled8/features/SplashScreen/presentation/bloc/onboarding_bloc.dart';
import 'package:untitled8/features/admin/data/models/audit_log_model.dart'; 
import 'package:untitled8/features/admin/data/repositories/audit_log_repository.dart'; 
import 'package:untitled8/features/admin/domain/usecases/add_employee.dart';
import 'package:untitled8/features/admin/domain/usecases/add_workshop.dart';
import 'package:untitled8/features/admin/domain/usecases/confirm_payment.dart';
import 'package:untitled8/features/admin/domain/usecases/delete_employee.dart';
import 'package:untitled8/features/admin/domain/usecases/delete_workshop.dart';
import 'package:untitled8/features/admin/domain/usecases/get_online_employees.dart';
import 'package:untitled8/features/admin/domain/usecases/get_workshops.dart';
import 'package:untitled8/features/admin/domain/usecases/update_hourly_rate.dart';
import 'package:untitled8/features/admin/domain/usecases/update_overtime_rate.dart';
import 'package:untitled8/features/admin/domain/usecases/toggle_workshop_archive.dart';
import 'package:untitled8/features/admin/domain/usecases/toggle_employee_archive.dart';
import 'package:untitled8/features/admin/presentation/bloc/workshops/workshops_bloc.dart';
import 'package:untitled8/features/home/presentation/bloc/Cubit_Button/button_cubit.dart';
import 'package:untitled8/features/home/presentation/bloc/Cubit_Navigation/navigation_cubit.dart';
import 'package:untitled8/features/home/presentation/bloc/Cubit_dropdown/dropdown_cubit.dart';
import 'package:untitled8/features/home/presentation/bloc/cubit_active_unactive/active_unactive_cubit.dart';
import 'package:untitled8/features/profile/presentation/bloc/Profile/_profile_bloc.dart';
import 'package:untitled8/features/home/presentation/bloc/finance/finance_bloc.dart';

import '../../features/admin/data/datasources/admin_remote_data_source.dart';
import '../../features/admin/data/datasources/admin_remote_data_source_impl.dart';
import '../../features/admin/data/models/workshop_model.dart'; 
import '../../features/admin/data/repositories/admin_repository_impl.dart';
import '../../features/admin/domain/repositories/admin_repository.dart';
import '../../features/admin/domain/repositories/workshop_repository.dart';
import '../../features/admin/data/repositories/workshop_repository_impl.dart';
import '../../features/admin/data/datasources/workshop_remote_data_source.dart';
import '../../features/admin/data/datasources/workshop_remote_data_source_impl.dart';
import '../../features/admin/domain/usecases/get_all_employees.dart';
import '../../features/admin/domain/usecases/get_employee_details.dart';
import '../../features/admin/presentation/bloc/admin_dashboard/admin_dashboard_bloc.dart';
import '../../features/admin/presentation/bloc/admin_profile/admin_profile_bloc.dart';
import '../../features/admin/presentation/bloc/employee_details/employee_details_bloc.dart';
import '../../features/admin/presentation/bloc/employees/employees_bloc.dart';
import '../../features/auth/data/datasource/auth_remote_data_source.dart';
import '../../features/auth/data/datasource/authRemoteDataSourceImpl.dart';
import '../../features/auth/data/repository/login_repo.dart';
import '../../features/auth/presentation/bloc/login_Cubit/login_cubit.dart';

// 🔹 Rewards Feature Imports
import '../../features/reward/data/datasources/reward_remote_data_source.dart';
import '../../features/reward/data/datasources/reward_remote_data_source_impl.dart';
import '../../features/reward/data/repositories/reward_repository_impl.dart';
import '../../features/reward/domain/repositories/reward_repository.dart';
import '../../features/reward/domain/usecases/get_admin_rewards.dart';
import '../../features/reward/domain/usecases/get_employee_rewards.dart';
import '../../features/reward/domain/usecases/issue_reward.dart';
import '../../features/reward/presentation/bloc/reward_admin/reward_admin_bloc.dart';
import '../../features/reward/presentation/bloc/reward_employee/reward_employee_bloc.dart';

// 🔹 Loan Feature Imports
import '../../features/loan/data/datasources/loan_remote_data_source.dart';
import '../../features/loan/data/datasources/loan_remote_data_source_impl.dart';
import '../../features/loan/data/datasources/loan_local_data_source.dart';
import '../../features/loan/data/repositories/loan_repository_impl.dart';
import '../../features/loan/domain/repositories/loan_repository.dart';
import '../../features/loan/domain/usecases/add_loan_usecase.dart';
import '../../features/loan/domain/usecases/get_all_loans_usecase.dart';
import '../../features/loan/domain/usecases/get_employee_loans_usecase.dart';
import '../../features/loan/domain/usecases/update_loan_status_usecase.dart';
import '../../features/loan/domain/usecases/record_payment_usecase.dart';
import '../../features/loan/presentation/bloc/loan_bloc.dart';

import 'package:untitled8/features/Attendance/data/model/work/workshope.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  await Hive.initFlutter();
  
  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(AttendanceRecordAdapter());
  if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(NotificationModelAdapter());
  if (!Hive.isAdapterRegistered(20)) Hive.registerAdapter(WorkshopModelAdapter()); 
  if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(CustomerAdapter());
  if (!Hive.isAdapterRegistered(15)) Hive.registerAdapter(AuditLogModelAdapter());

  final settingsBox = await Hive.openBox('settings');
  final attendanceBox = await Hive.openBox<AttendanceRecord>(AppStrings.attendanceBox);
  final statusBox = await Hive.openBox('attendanceStatusBox');
  final notifBox = await Hive.openBox<NotificationModel>(AppStrings.notificationsBox);
  final pendingBox = await Hive.openBox<AttendanceRecord>('pendingAttendance');
  final workshopsBox = await Hive.openBox<WorkshopModel>('workshops_v20');
  final loanBox = await Hive.openBox<Map>('loan_box');
  final auditBox = await Hive.openBox<AuditLogModel>('auditLogBox_final_v3'); 

  // 🔹 إعدادات محسنة لضمان الحفظ في الأندرويد
  sl.registerLazySingleton<FlutterSecureStorage>(() => const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  ));

  sl.registerLazySingleton<Connectivity>(() => Connectivity());
  
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(
      baseUrl: "https://employee-api.nouh-agency.com/",
      headers: {"Accept": "application/json", "Content-Type": "application/json"},
      connectTimeout: const Duration(milliseconds: 60000), 
      receiveTimeout: const Duration(milliseconds: 60000), 
    ));
    dio.interceptors.add(AuthInterceptor());
    return dio;
  });

  sl.registerLazySingleton<BaseApi>(() => BaseApi(sl<Dio>()));

  sl.registerLazySingleton(() => LocalDataSource(
    settingsBox: settingsBox,
    attendanceBox: attendanceBox,
    pendingBox: pendingBox,
    workshopsBox: workshopsBox,
  ));

  sl.registerLazySingleton(() => RemoteDataSource(dio: sl(), secureStorage: sl()));
  sl.registerLazySingleton(() => AppRepository(remote: sl(), local: sl(), connectivity: sl()));
  
  sl.registerLazySingleton(() => WorkshopsRepository(
    dio: sl(), 
    workshopsBox: workshopsBox, 
    connectivity: sl(),
  ));
  
  sl.registerLazySingleton(() => AuditLogRepository(auditBox));

  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<AdminRemoteDataSource>(() => AdminRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<NotificationRemoteDataSource>(() => NotificationRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<WorkshopRemoteDataSource>(() => WorkshopRemoteDataSourceImpl(dio: sl()));
  
  sl.registerLazySingleton<RewardRemoteDataSource>(() => RewardRemoteDataSourceImpl(dio: sl()));
  sl.registerLazySingleton<LoanRemoteDataSource>(() => LoanRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton(() => LoanLocalDataSource(loanBox));

  sl.registerLazySingleton<AuthRepository>(() => AuthRepository(remoteDataSource: sl(), secureStorage: sl()));
  sl.registerLazySingleton<AdminRepository>(() => AdminRepositoryImpl(sl()));
  sl.registerLazySingleton<NotificationRepository>(() => NotificationRepositoryImpl(localBox: notifBox, remoteDataSource: sl()));
  sl.registerLazySingleton<AttendanceRepository>(() => AttendanceRepository(attendanceBox));
  
  sl.registerLazySingleton<WorkshopRepository>(() => WorkshopRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<RewardRepository>(() => RewardRepositoryImpl(remoteDataSource: sl()));
  sl.registerLazySingleton<LoanRepository>(() => LoanRepositoryImpl(
    remoteDataSource: sl(),
    localDataSource: sl(),
    connectivity: sl(),
  ));

  sl.registerLazySingleton(() => GetAllEmployeesUseCase(sl()));
  sl.registerLazySingleton(() => GetOnlineEmployeesUseCase(sl()));
  sl.registerLazySingleton(() => GetEmployeeDetailsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateHourlyRateUseCase(sl()));
  sl.registerLazySingleton(() => UpdateOvertimeRateUseCase(sl()));
  sl.registerLazySingleton(() => ConfirmPaymentUseCase(sl()));
  sl.registerLazySingleton(() => AddEmployeeUseCase(sl()));
  sl.registerLazySingleton(() => DeleteEmployeeUseCase(sl()));
  sl.registerLazySingleton(() => GetWorkshopsUseCase(sl()));
  sl.registerLazySingleton(() => AddWorkshopUseCase(sl()));
  sl.registerLazySingleton(() => DeleteWorkshopUseCase(sl()));
  sl.registerLazySingleton(() => ToggleWorkshopArchiveUseCase(sl()));
  sl.registerLazySingleton(() => ToggleEmployeeArchiveUseCase(sl()));
  
  sl.registerLazySingleton(() => GetAdminRewardsUseCase(sl()));
  sl.registerLazySingleton(() => GetEmployeeRewardsUseCase(sl()));
  sl.registerLazySingleton(() => IssueRewardUseCase(sl()));
  
  sl.registerLazySingleton(() => GetAllLoansUseCase(sl()));
  sl.registerLazySingleton(() => GetEmployeeLoansUseCase(sl()));
  sl.registerLazySingleton(() => AddLoanUseCase(sl()));
  sl.registerLazySingleton(() => UpdateLoanStatusUseCase(sl()));
  sl.registerLazySingleton(() => RecordPaymentUseCase(sl()));

  sl.registerLazySingleton(() => NotificationBloc(sl()));
  sl.registerLazySingleton(() => AttendanceCubit(
    statusBox: statusBox, 
    attendanceBox: attendanceBox, 
    repository: sl(),
    authRepository: sl<AuthRepository>(), 
    workshopRepository: sl<WorkshopRepository>(), 
    notificationBloc: sl<NotificationBloc>(),
    appRepository: sl<AppRepository>(), 
  ));
  
  sl.registerLazySingleton(() => ButtonCubit(statusBox: statusBox));
  sl.registerLazySingleton(() => ActiveUnactiveCubit(statusBox: statusBox));

  sl.registerLazySingleton(() => SyncService(sl<AppRepository>(), sl<Connectivity>()));

  sl.registerFactory(() => WorkshopsBloc(
    getWorkshopsUseCase: sl(),
    addWorkshopUseCase: sl(),
    deleteWorkshopUseCase: sl(),
    toggleWorkshopArchiveUseCase: sl(),
  ));
  
  sl.registerFactory<LoginCubit>(() => LoginCubit(repository: sl()));
  sl.registerFactory(() => OnboardingBloc(totalPages: 3));
  sl.registerFactory(() => ProfileBloc(
    authRepository: sl(),
    attendanceRepository: sl(),
  ));
  sl.registerFactory(() => FinanceBloc());
  sl.registerFactory(() => AdminDashboardBloc(sl(), sl()));
  sl.registerFactory(() => AdminProfileBloc());
  sl.registerFactory(() => EmployeesBloc(
    getAllEmployeesUseCase: sl(),
    addEmployeeUseCase: sl(),
    toggleEmployeeArchiveUseCase: sl(),
  ));
  sl.registerFactory(() => EmployeeDetailsBloc(
    sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(),
  ));
  sl.registerFactory(() => RewardAdminBloc(
    getAdminRewardsUseCase: sl(),
    issueRewardUseCase: sl(),
    getAllEmployeesUseCase: sl(),
  ));
  sl.registerFactory(() => RewardEmployeeBloc(getEmployeeRewardsUseCase: sl()));
  sl.registerFactory(() => LoanBloc(
    getAllLoansUseCase: sl(),
    getEmployeeLoansUseCase: sl(),
    addLoanUseCase: sl(),
    updateLoanStatusUseCase: sl(),
    recordPaymentUseCase: sl(),
    notificationBloc: sl(),
  ));
  sl.registerFactory(() => NavigationnCubit());
  sl.registerFactory(() => DropdownCubit());
}
