import 'dart:async';
import 'package:flutter/material.dart';
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
      ) async {
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
            getAllAttendanceData:
            state.getAllAttendanceData.setFaild(errorMessage: l.message),
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
          // 🔹 استدعاء تحديث التوكن بعد مزامنة ناجحة
          return;
        }

        // ================= الحالة العادية =================
        final oldList = await localeDataSource.getAttendance(); // الحضور المحلي
        final newList = r ?? [];

        final Map<String, GetAttendanceResponse> weekMap = {};
        String weekKey(GetAttendanceResponse w) =>
            "${w.startDate?.toIso8601String()}_${w.endDate?.toIso8601String()}";

        // 1️⃣ أضف البيانات الجديدة أولًا
        for (final week in newList) {
          final key = weekKey(week);
          weekMap[key] = week;
        }

        // 2️⃣ دمج الحضور المحلي مع البيانات الموجودة في الأسابيع حسب التاريخ
        for (final localWeek in oldList) {
          for (final a in localWeek.attendances ?? []) {
            if (a.id == null) continue;

            bool added = false;

            for (final key in weekMap.keys) {
              final week = weekMap[key]!;

              if (a.date != null &&
                  !a.date!.isBefore(week.startDate!) &&
                  !a.date!.isAfter(week.endDate!)) {
                final existingIds =
                    week.attendances?.map((e) => e.id).toSet() ?? {};
                if (!existingIds.contains(a.id)) {
                  final List<AttendanceModel> updatedAttendances = [...(week.attendances ?? []), a];
                  weekMap[key] = week.copyWith(attendances: updatedAttendances);
                }
                added = true;
                break;
              }
            }

            // إذا لم يكن الحضور ينتمي لأي أسبوع، أنشئ أسبوع جديد
            if (!added && a.date != null) {
              final startOfWeek = a.date!;
              final endOfWeek = startOfWeek.add(const Duration(days: 6));

              final newWeek = GetAttendanceResponse(
                startDate: startOfWeek,
                endDate: endOfWeek,
                attendances: [a],
                totalRegularHours: 0,
                totalOvertimeHours: 0,
              );

              weekMap["${startOfWeek.toIso8601String()}_${endOfWeek.toIso8601String()}"] =
                  newWeek;
            }
          }
        }

        var mergedList = weekMap.values.toList();

        // ================= حالة عدم وجود بيانات للشهر =================
        final requestedMonth = event.params.month;
        final currentYear = DateTime.now().year;

        if (requestedMonth != null) {
          final hasMonthData = mergedList.any((e) =>
          e.startDate?.month == requestedMonth &&
              e.startDate?.year == currentYear);

          if (!hasMonthData) {
            final todayList = state.localeTodayAttendanceList ?? [];
            if (todayList.isNotEmpty) {
              final generatedMonth = GetAttendanceResponse(
                startDate: DateTime(currentYear, requestedMonth, 1),
                endDate: DateTime(currentYear, requestedMonth + 1, 0),
                attendances: todayList,
                totalRegularHours: 0,
                totalOvertimeHours: 0,
              );

              mergedList.add(generatedMonth);
            }
          }
        }

        // ================= اختيار الأسبوع =================
        int getWeeksCountInMonth(int year, int month) {
          final lastDay = DateTime(year, month + 1, 0).day;
          return (lastDay / 7).ceil(); // أقصى شيء 5
        }

        DateTimeRange getWeekRangeInMonth({
          required int year,
          required int month,
          required int weekNumber,
        }) {
          final lastDay = DateTime(year, month + 1, 0).day;

          final startDay = ((weekNumber - 1) * 7) + 1;
          final endDay = (weekNumber * 7);

          final safeEndDay = endDay > lastDay ? lastDay : endDay;

          return DateTimeRange(
            start: DateTime(year, month, startDay),
            end: DateTime(year, month, safeEndDay),
          );
        }

        GetAttendanceResponse? getWeekByNumber({
          required List<GetAttendanceResponse> list,
          required int year,
          required int month,
          required int weekNumber,
        }) {
          final range = getWeekRangeInMonth(
            year: year,
            month: month,
            weekNumber: weekNumber,
          );

          return list.firstWhere(
                (w) =>
            w.startDate != null &&
                w.endDate != null &&
                !w.startDate!.isAfter(range.end) &&
                !w.endDate!.isBefore(range.start),
            orElse: () => GetAttendanceResponse(attendances: []),
          );
        }

        final selectedWeekNumber = 1; // يمكن تغييره حسب UI
        final selectedWeekData = getWeekByNumber(
          list: mergedList,
          year: currentYear,
          month: requestedMonth!,
          weekNumber: selectedWeekNumber,
        );

        // ================= قائمة اليوم =================
        final todayList = getTodayAttendancesFromList(mergedList);

        // ================= حساب الرواتب =================
        double totalSalery = 0;
        for (final e in mergedList) {
          totalSalery +=
              ((e.totalRegularHours ?? 0) / 8 *
                  AppVariables.user!.userable!.hourlyRate!) +
                  ((e.totalOvertimeHours ?? 0) *
                      AppVariables.user!.userable!.overtimeRate!);
        }

        // ================= حساب الساعات =================
        double totalHours = 0;
        for (final e in mergedList) {
          for (final g in e.attendances ?? []) {
            totalHours += (g.regularHours ?? 0) + (g.overtimeHours ?? 0);
          }
        }

        emit(
          state.copyWith(
            getAllAttendanceData:
            state.getAllAttendanceData.setSuccess(data: mergedList),
            localeAttendanceList: mergedList,
            localeTodayAttendanceList: todayList,
            totalHours: totalHours,
            totalSalery: totalSalery,
          ),
        );
      },
    );
  }

// ================= دالة اليوم =================
  List<AttendanceModel> getTodayAttendancesFromList(
      List<GetAttendanceResponse> list,
      ) {
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
        
        // 🔹 استدعاء تحديث التوكن بعد مزامنة ناجحة
      },
    );
  }

}
