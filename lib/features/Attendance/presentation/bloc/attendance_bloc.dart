import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:untitled8/common/helper/src/app_varibles.dart';
import 'package:untitled8/features/Attendance/data/models/sync_attendance_response.dart';
import '../../../../core/data_state_model.dart';
import '../../../../core/di/injection.dart';
import '../../data/data_source/attendance_locale_data_source.dart';
import '../../data/models/attendance_model.dart';
import '../../data/models/get_attendance_response.dart';
import '../../domin/use_cases/get_employee_attendance_use_case.dart';
import '../../domin/use_cases/sync_attendance_use_case.dart';

part 'attendance_event.dart';

part 'attendance_state.dart';

@lazySingleton
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GetEmployeeAttendanceUseCase _getEmployeeAttendanceUseCase;
  final SyncAttendanceUseCase _syncAttendanceUseCase;

  AttendanceBloc(this._getEmployeeAttendanceUseCase,
      this._syncAttendanceUseCase,) : super(AttendanceState()) {
    on<GetAllAttendanceEvent>(_getAllAttendance);
    on<SyncAttendanceEvent>(_syncAttendance);
    on<GetLocaleAttendanceEvent>(_getLocale);
    on<AddToLocaleAttendanceEvent>(_addTooLocale);
    on<PatchLocaleAttendanceEvent>(_patchLocale);
    on<InitLocaleAttendanceEvent>(_initLocale);
  }

// دالة مساعدة لجلب الحضور اليومي
  Future<List<AttendanceModel>> getTodayAttendances() async {
    final now = DateTime.now();
    final list = await sl<AttendanceLocaleDataSource>().getAttendance();
    final week = list.firstWhere(
          (w) => w.containsDate(now),
      orElse: () => GetAttendanceResponse(attendances: []),
    );
    return week.attendances ?? [];
  }

// ====================== الأحداث ======================
  FutureOr<void> _initLocale(
      InitLocaleAttendanceEvent event,
      Emitter<AttendanceState> emit,
      )
  async {
    final list = await sl<AttendanceLocaleDataSource>().getAttendance();
    final todayList = await getTodayAttendances();

    emit(
      state.copyWith(
        localeAttendanceList: list,
        localeTodayAttendanceList: todayList,
      ),
    );
  }

  FutureOr<void> _getLocale(
      GetLocaleAttendanceEvent event,
      Emitter<AttendanceState> emit,
      )
  async {
    final list = await sl<AttendanceLocaleDataSource>().getAttendance();
    final todayList = await getTodayAttendances();

    emit(
      state.copyWith(
        localeAttendanceList: list,
        localeTodayAttendanceList: todayList,
      ),
    );
  }

  FutureOr<void> _addTooLocale(
      AddToLocaleAttendanceEvent event,
      Emitter<AttendanceState> emit,
      )
  async {
    // أضف attendance في الـ SharedPreferences
    await sl<AttendanceLocaleDataSource>().addAttendance(
      attendance: event.attendanceModel,
    );

    // استرجع القائمة الكاملة بعد الإضافة
    final list = await sl<AttendanceLocaleDataSource>().getAttendance();
    final todayList = await getTodayAttendances();

    emit(
      state.copyWith(
        localeAttendanceList: list,
        localeTodayAttendanceList: todayList,
      ),
    );
  }

  FutureOr<void> _patchLocale(
      PatchLocaleAttendanceEvent event,
      Emitter<AttendanceState> emit,
      )
  async {
    // حدث الـ SharedPreferences
    await sl<AttendanceLocaleDataSource>().patchAttendance(
      attendance: event.attendanceModel,
    );

    final list = await sl<AttendanceLocaleDataSource>().getAttendance();
    final todayList = await getTodayAttendances();

    emit(
      state.copyWith(
        localeAttendanceList: list,
        localeTodayAttendanceList: todayList,
      ),
    );
  }

  FutureOr<void> _getAllAttendance(
      GetAllAttendanceEvent event,
      Emitter<AttendanceState> emit,
      )
  async {
    emit(
      state.copyWith(
        getAllAttendanceData: state.getAllAttendanceData.setLoading(),
      ),
    );

    final val = await _getEmployeeAttendanceUseCase(event.params);

    await val.fold(
          (l) async {
        emit(
          state.copyWith(
            getAllAttendanceData: state.getAllAttendanceData.setFaild(
              errorMessage: l.message,
            ),
          ),
        );
      },
          (r) async {
        final localeDataSource = sl<AttendanceLocaleDataSource>();

        // ================= حالة بعد المزامنة =================
        if (event.isAfterSync) {
          await localeDataSource.clearAttendance();
          await localeDataSource.setLocaleAttendance(r ?? []);

          final mergedList = r ?? [];
          final todayList = getTodayAttendancesFromList(mergedList);

          emit(
            state.copyWith(
              getAllAttendanceData:
              state.getAllAttendanceData.setSuccess(data: r),
              localeAttendanceList: mergedList,
              localeTodayAttendanceList: todayList,
            ),
          );
          return;
        }

        // ================= الحالة العادية =================
        // دمج القديم مع الجديد حسب الأسبوع
        final oldList = await localeDataSource.getAttendance();
        final newList = r ?? [];

        final Map<String, GetAttendanceResponse> weekMap = {};
        String weekKey(GetAttendanceResponse w) =>
            "${w.startDate?.toIso8601String()}_${w.endDate?.toIso8601String()}";

        // أضف الأسابيع القديمة أولاً
        // for (final week in oldList) {
        //   weekMap[weekKey(week)] = week;
        // }

        // دمج الأسابيع الجديدة من الباك
        for (final week in newList) {
          final key = weekKey(week);
          if (weekMap.containsKey(key)) {
            final oldWeek = weekMap[key]!;

            // دمج attendances: المحلي + الجديد من الباك
            final Map<int, AttendanceModel> attendancesMap = {
              for (final a in oldWeek.attendances ?? []) a.id!: a,
              for (final a in week.attendances ?? []) a.id!: a,
            };

            weekMap[key] =
                oldWeek.copyWith(attendances: attendancesMap.values.toList());
          } else {
            weekMap[key] = week;
          }
        }

        final mergedList = weekMap.values.toList();
// قائمة اليوم من المدموج
            final todayList = getTodayAttendancesFromList(mergedList);

// مجموع الرواتب
            double totalSalery = 0;
            mergedList.forEach((e) {
              totalSalery +=
              ((e.totalRegularHours! / 8) * AppVariables.user!.userable!.hourlyRate!) +
                  (e.totalOvertimeHours! * AppVariables.user!.userable!.overtimeRate!);

            });

// مجموع الساعات
            double totalHours = 0;
            mergedList.forEach((e) {
              e.attendances?.forEach((g) {
                totalHours += (g.regularHours ?? 0) + (g.overtimeHours ?? 0);
              });
            });

            print('Total:');
            print(totalSalery);
            print(totalHours);

        emit(
          state.copyWith(
            getAllAttendanceData:
            state.getAllAttendanceData.setSuccess(data: mergedList),
            localeAttendanceList: mergedList,
            localeTodayAttendanceList: todayList,
            totalHours: totalHours,
            totalSalery:totalSalery
          ),
        );
      },
    );
  }

// دالة مساعدة
  List<AttendanceModel> getTodayAttendancesFromList(
      List<GetAttendanceResponse> list) {
    final now = DateTime.now();
    final week = list.firstWhere(
          (w) => w.containsDate(now),
      orElse: () => GetAttendanceResponse(attendances: []),
    );
    return week.attendances ?? [];
  }


  FutureOr<void> _syncAttendance(
      SyncAttendanceEvent event,
      Emitter<AttendanceState> emit,
      ) async {
    emit(
      state.copyWith(
        syncAttendanceData: state.syncAttendanceData.setLoading(),
      ),
    );

    // احصل على الحضور المعلق
    final List<AttendanceModel> pendingList = state.getAllAttendanceData.data
        ?.expand<AttendanceModel>((week) => week.attendances ?? [])
        .where((e) => e.status == 'pending')
        .toList() ??
        [];

    // جهّز للإرسال
    final List<AttendanceBody> sendList = pendingList.map((e) {
      return AttendanceBody(
        employeeId: AppVariables.user!.userableId,
        workshopId: e.workshop!.id,
        date: e.date?.toIso8601String() ?? '',
        checkIn: e.checkIn,
        checkOut: e.checkOut,
        weekNumber: e.weekNumber,
        regularHours: e.regularHours ?? 8,
        overtimeHours: e.overtimeHours ?? 0,
        status: e.status,
        note: e.note,

      );
    }).toList();

    final params = SyncAttendanceParams(attendanceBody: sendList);

    final val = await _syncAttendanceUseCase(params);

    val.fold(
          (l) {
        emit(
          state.copyWith(
            syncAttendanceData: state.syncAttendanceData.setFaild(
              errorMessage: l.message,
            ),
          ),
        );
      },
          (r) {
        emit(
          state.copyWith(
            syncAttendanceData: state.syncAttendanceData.setSuccess(data: r),
          ),
        );
        add(GetAllAttendanceEvent(isAfterSync: true,params: GetEmployeeAttendanceParams(month: DateTime.now().month)));
      },
    );
  }

}
