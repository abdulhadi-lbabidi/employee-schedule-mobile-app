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
  AppVariables.addUnSyncAttendance(event.attendanceModel);
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
    AppVariables.replaceUnSyncAttendance(event.attendanceModel);

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
    // 🔹 وضع الحالة على Loading
    emit(
      state.copyWith(
        getAllAttendanceData: state.getAllAttendanceData.setLoading(),
      ),
    );

    // 🔹 جلب البيانات من السيرفر
    final result = await _getEmployeeAttendanceUseCase(event.params);

    await result.fold(
          (failure) async {
        // 🔹 حالة الفشل
        emit(
          state.copyWith(
            getAllAttendanceData: state.getAllAttendanceData.setFaild(
              errorMessage: failure.message,
            ),
          ),
        );
      },
          (response) async {
        final List<GetAttendanceResponse> serverWeeks = response ?? [];

        // 🔹 إذا كانت مزامنة، نظف unSyncAttendanceList
        if (event.isAfterSync) {
           sl<AttendanceLocaleDataSource>().setLocaleAttendance(response);
          AppVariables.unSyncAttendanceList = [];
        }

        final List<AttendanceModel> unSynced =
            AppVariables.unSyncAttendanceList ?? [];

        final int? requestedMonth = event.params.month;
        final int currentYear = DateTime.now().year;

        // 🔹 نسخ بيانات السيرفر
        final List<GetAttendanceResponse> merged = List.from(serverWeeks);

        // 🔹 دمج الحضور غير المرفوع (unSynced) داخل merged
        for (final attendance in unSynced) {
          if (attendance.date == null) continue;

          final date = attendance.date!;

          // ❗ إضافة فقط إذا كان ضمن الشهر المطلوب
          if (requestedMonth != null &&
              (date.month != requestedMonth || date.year != currentYear)) {
            continue;
          }

          // 🔹 البحث عن أسبوع يغطي التاريخ
          final index = merged.indexWhere(
                (w) =>
            w.startDate != null &&
                w.endDate != null &&
                !date.isBefore(w.startDate!) &&
                !date.isAfter(w.endDate!),
          );

          if (index != -1) {
            // ✅ الأسبوع موجود، أضف الحضور داخله
            final week = merged[index];
            final updated = List<AttendanceModel>.from(week.attendances ?? []);

            if (!updated.any((e) => e.id == attendance.id)) {
              updated.add(attendance);
              merged[index] = week.copyWith(attendances: updated);
            }
          } else {
            // 🆕 الأسبوع غير موجود → إنشاء أسبوع جديد
            final int weekNumber = ((date.day - 1) ~/ 7) + 1;

            final startOfWeek = DateTime(
              date.year,
              date.month,
              ((weekNumber - 1) * 7) + 1,
            );

            final endOfWeek = startOfWeek.add(const Duration(days: 6));

            merged.add(
              GetAttendanceResponse(
                startDate: startOfWeek,
                endDate: endOfWeek,
                attendances: [attendance],
                totalRegularHours: 0,
                totalOvertimeHours: 0,
                weekOfMonth: weekNumber,
              ),
            );
          }
        }

        // 🔹 ترتيب الأسابيع حسب تاريخ البداية
        merged.sort((a, b) =>
            (a.startDate ?? DateTime(0)).compareTo(b.startDate ?? DateTime(0)));

        // 🔹 حساب الساعات والرواتب
        double totalHours = 0;
        double totalSalary = 0;

        for (final week in merged) {
          for (final att in week.attendances ?? []) {
            totalHours += (att.regularHours ?? 0) + (att.overtimeHours ?? 0);
          }

          totalSalary +=
              ((week.totalRegularHours ?? 0) / 8 *
                  AppVariables.user!.userable!.hourlyRate!) +
                  ((week.totalOvertimeHours ?? 0) *
                      AppVariables.user!.userable!.overtimeRate!);
        }

        // 🔹 تحديث الـ state
        emit(
          state.copyWith(
            getAllAttendanceData:
            state.getAllAttendanceData.setSuccess(data: merged),
            localeAttendanceList: merged,
            localeTodayAttendanceList: getTodayAttendancesFromList(merged),
            totalHours: totalHours,
            totalSalery: totalSalary,
          ),
        );
      },
    );
  }

  List<AttendanceModel> getTodayAttendancesFromList(
      List<GetAttendanceResponse> list,
      )
  {
    final now = DateTime.now();

    final week = list.firstWhere(
          (w) => w.containsDate(now),
      orElse: () => GetAttendanceResponse(attendances: []),
    );

    return week.attendances ?? [];
  }

  // FutureOr<void> _getAllAttendance(
  //     GetAllAttendanceEvent event,
  //     Emitter<AttendanceState> emit,
  //     ) async {
  //   emit(
  //     state.copyWith(
  //       getAllAttendanceData: state.getAllAttendanceData.setLoading(),
  //     ),
  //   );
  //
  //   final val = await _getEmployeeAttendanceUseCase(event.params);
  //
  //   await val.fold(
  //         (l) async {
  //       emit(
  //         state.copyWith(
  //           getAllAttendanceData:
  //           state.getAllAttendanceData.setFaild(errorMessage: l.message),
  //         ),
  //       );
  //     },
  //         (r) async {
  //       final localeDataSource = sl<AttendanceLocaleDataSource>();
  //
  //       // ================= حالة بعد المزامنة =================
  //       if (event.isAfterSync) {
  //         await localeDataSource.clearAttendance();
  //         await localeDataSource
  //             .setLocaleAttendance(r ?? <GetAttendanceResponse>[]);
  //
  //         final List<GetAttendanceResponse> mergedList =
  //             r ?? <GetAttendanceResponse>[];
  //
  //         final List<AttendanceModel> todayList =
  //         getTodayAttendancesFromList(mergedList);
  //
  //         emit(
  //           state.copyWith(
  //             getAllAttendanceData:
  //             state.getAllAttendanceData.setSuccess(data: mergedList),
  //             localeAttendanceList: mergedList,
  //             localeTodayAttendanceList: todayList,
  //           ),
  //         );
  //         return;
  //       }
  //
  //       // ================= الحالة العادية =================
  //       final List<GetAttendanceResponse> oldList =
  //       await localeDataSource.getAttendance();
  //
  //       final List<GetAttendanceResponse> newList =
  //           r ?? <GetAttendanceResponse>[];
  //
  //       final Map<String, GetAttendanceResponse> weekMap = {};
  //
  //       String weekKey(GetAttendanceResponse w) =>
  //           "${w.startDate?.toIso8601String()}_${w.endDate?.toIso8601String()}";
  //
  //       // 1️⃣ أضف بيانات السيرفر
  //       for (final week in newList) {
  //         weekMap[weekKey(week)] = week;
  //       }
  //
  //       // 2️⃣ دمج المحلي
  //       for (final localWeek in oldList) {
  //         final List<AttendanceModel> localAttendances =
  //             localWeek.attendances ?? <AttendanceModel>[];
  //
  //         for (final AttendanceModel a in localAttendances) {
  //           if (a.id == null) continue;
  //
  //           bool added = false;
  //
  //           for (final key in weekMap.keys) {
  //             final week = weekMap[key]!;
  //
  //             if (a.date != null &&
  //                 week.startDate != null &&
  //                 week.endDate != null &&
  //                 !a.date!.isBefore(week.startDate!) &&
  //                 !a.date!.isAfter(week.endDate!)) {
  //               final existingIds =
  //               (week.attendances ?? <AttendanceModel>[])
  //                   .map((e) => e.id)
  //                   .toSet();
  //
  //               if (!existingIds.contains(a.id)) {
  //                 final updatedAttendances = [
  //                   ...(week.attendances ?? <AttendanceModel>[]),
  //                   a
  //                 ];
  //
  //                 weekMap[key] =
  //                     week.copyWith(attendances: updatedAttendances);
  //               }
  //
  //               added = true;
  //               break;
  //             }
  //           }
  //
  //           // إذا لا ينتمي لأي أسبوع → أنشئ أسبوع جديد
  //           if (!added && a.date != null) {
  //             final DateTime startOfWeek = a.date!;
  //             final DateTime endOfWeek =
  //             startOfWeek.add(const Duration(days: 6));
  //
  //             final newWeek = GetAttendanceResponse(
  //               startDate: startOfWeek,
  //               endDate: endOfWeek,
  //               attendances: <AttendanceModel>[a],
  //               totalRegularHours: 0,
  //               totalOvertimeHours: 0,
  //             );
  //
  //             weekMap[
  //             "${startOfWeek.toIso8601String()}_${endOfWeek.toIso8601String()}"] =
  //                 newWeek;
  //           }
  //         }
  //       }
  //
  //       List<GetAttendanceResponse> mergedList =
  //       weekMap.values.toList();
  //
  //       // ================= إصلاح مشكلة تقاطع الشهر =================
  //       final int? requestedMonth = event.params.month;
  //       final int currentYear = DateTime.now().year;
  //
  //       if (requestedMonth != null) {
  //         final DateTime monthStart =
  //         DateTime(currentYear, requestedMonth, 1);
  //         final DateTime monthEnd =
  //         DateTime(currentYear, requestedMonth + 1, 0);
  //
  //         final bool hasMonthData = mergedList.any((week) {
  //           if (week.startDate == null || week.endDate == null) {
  //             return false;
  //           }
  //
  //           return !week.startDate!.isAfter(monthEnd) &&
  //               !week.endDate!.isBefore(monthStart);
  //         });
  //
  //         if (!hasMonthData) {
  //           final List<AttendanceModel> localMonthAttendances =
  //           oldList
  //               .expand<AttendanceModel>((w) =>
  //           w.attendances ?? <AttendanceModel>[])
  //               .where((a) =>
  //           a.date != null &&
  //               !a.date!.isBefore(monthStart) &&
  //               !a.date!.isAfter(monthEnd))
  //               .toList();
  //
  //           if (localMonthAttendances.isNotEmpty) {
  //             mergedList.add(
  //               GetAttendanceResponse(
  //                 startDate: monthStart,
  //                 endDate: monthEnd,
  //                 attendances: localMonthAttendances,
  //                 totalRegularHours: 0,
  //                 totalOvertimeHours: 0,
  //               ),
  //             );
  //           }
  //         }
  //       }
  //
  //       // ================= قائمة اليوم =================
  //       final List<AttendanceModel> todayList =
  //       getTodayAttendancesFromList(mergedList);
  //
  //       // ================= حساب الرواتب =================
  //       double totalSalery = 0;
  //       for (final e in mergedList) {
  //         totalSalery +=
  //             ((e.totalRegularHours ?? 0) / 8 *
  //                 AppVariables.user!.userable!.hourlyRate!) +
  //                 ((e.totalOvertimeHours ?? 0) *
  //                     AppVariables.user!.userable!.overtimeRate!);
  //       }
  //
  //       // ================= حساب الساعات =================
  //       double totalHours = 0;
  //       for (final e in mergedList) {
  //         for (final AttendanceModel g
  //         in (e.attendances ?? <AttendanceModel>[])) {
  //           totalHours +=
  //               (g.regularHours ?? 0) +
  //                   (g.overtimeHours ?? 0);
  //         }
  //       }
  //
  //       print(mergedList.map((e) => e.toJson()));
  //
  //       emit(
  //         state.copyWith(
  //           getAllAttendanceData:
  //           state.getAllAttendanceData.setSuccess(data: mergedList),
  //           localeAttendanceList: mergedList,
  //           localeTodayAttendanceList: todayList,
  //           totalHours: totalHours,
  //           totalSalery: totalSalery,
  //         ),
  //       );
  //     },
  //   );
  // }

  //
// ================= دالة اليوم =================







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
