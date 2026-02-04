import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:untitled8/core/unified_api/use_case.dart';
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

  AttendanceBloc(
    this._getEmployeeAttendanceUseCase,
    this._syncAttendanceUseCase,
  ) : super(AttendanceState()) {
    on<GetAllAttendanceEvent>(_getAllAttendance);
    on<SyncAttendanceEvent>(_syncAttendance);
    on<GetLocaleAttendanceEvent>(_getLocale);
    on<AddToLocaleAttendanceEvent>(_addTooLocale);
    on<PatchLocaleAttendanceEvent>(_patchLocale);
    on<InitLocaleAttendanceEvent>(_initLocale);
  }

  FutureOr<void> _initLocale(
    InitLocaleAttendanceEvent event,
    Emitter<AttendanceState> emit,
  )
  async {
    final list = await sl<AttendanceLocaleDataSource>().getAttendance();

    final listToday =
        list.data!.where((e) => e.date?.day == DateTime.now().day).toList();
    emit(
      state.copyWith(
        localeAttendanceList: list.data,
        localeTodayAttendanceList: listToday,
      ),
    );
  }

  FutureOr<void> _getLocale(
    GetLocaleAttendanceEvent event,
    Emitter<AttendanceState> emit,
  )
  async {
    final list = await sl<AttendanceLocaleDataSource>().getAttendance();
    final val = list.data;
    if (val!.isNotEmpty) {
      final List<AttendanceModel> todayList = List.from(
        val..removeWhere((e) => e.date?.day != DateTime.now().day),
      );
      emit(
        state.copyWith(
          localeAttendanceList: val,
          localeTodayAttendanceList: todayList,
        ),
      );
    }
  }

  FutureOr<void> _addTooLocale(
    AddToLocaleAttendanceEvent event,
    Emitter<AttendanceState> emit,
  )
  async {
    sl<AttendanceLocaleDataSource>().addAttendance(event.attendanceModel);
    emit(
      state.copyWith(
        localeAttendanceList: [
          ...state.localeAttendanceList,
          event.attendanceModel,
        ],
        localeTodayAttendanceList: [
          ...state.localeTodayAttendanceList,
          event.attendanceModel,
        ],
      ),
    );
  }

  FutureOr<void> _patchLocale(
    PatchLocaleAttendanceEvent event,
    Emitter<AttendanceState> emit,
  )
  async {
    await sl<AttendanceLocaleDataSource>().patchAttendance(
      event.attendanceModel,
    );

    emit(
      state.copyWith(
        localeAttendanceList: List.of(
          state.localeAttendanceList
              .map(
                (e) =>
                    e.id == event.attendanceModel.id
                        ? event.attendanceModel
                        : e,
              )
              .toList(),
        ),
        localeTodayAttendanceList: List.of(
          state.localeTodayAttendanceList
              .map(
                (e) =>
                    e.id == event.attendanceModel.id
                        ? event.attendanceModel
                        : e,
              )
              .toList(),
        ),
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

    final val = await _getEmployeeAttendanceUseCase(NoParams());

    val.fold(
      (l) {
        emit(
          state.copyWith(
            getAllAttendanceData: state.getAllAttendanceData.setFaild(
              errorMessage: l.message,
            ),
          ),
        );
      },
      (r) {
        if(event.isAfterSync){
          sl<AttendanceLocaleDataSource>().clearAttendance();
          sl<AttendanceLocaleDataSource>().setLocaleAttendance(r);
          emit(state.copyWith(
            localeTodayAttendanceList: [],
            localeAttendanceList: []
          ));
        }
        final Map<int, AttendanceModel> map = {
          // أولاً القديمة
          for (final item in state.localeAttendanceList)
            item.id: item,

          // ثم الجديدة (تستبدل القديمة إذا نفس id)
          for (final item in r.data!)
            item.id: item,
        };

        final List<AttendanceModel> list = map.values.toList();

        emit(
          state.copyWith(
            getAllAttendanceData: state.getAllAttendanceData.setSuccess(
              data: r.copyWith(data: list),
            ),
          ),
        );
      },
    );
  }

  FutureOr<void> _syncAttendance(
    SyncAttendanceEvent event,
    Emitter<AttendanceState> emit,
  )
  async {
    emit(
      state.copyWith(syncAttendanceData: state.syncAttendanceData.setLoading()),
    );

    final List<AttendanceModel> pendingList =
        state.getAllAttendanceData.data!.data!
            .where((e) => e.status == 'pending')
            .toList();

    final List<AttendanceBody> sendList =
        pendingList.map((e) => AttendanceBody(
          status: e.status,
          checkOut: e.checkOut,
          employeeId:e.employeeId,
          note: e.note,
          checkIn: e.checkIn,
          date: e.date.toString(),
          overtimeHours: 0,
          regularHours:8,
          weekNumber:5,
          workshopId: e.employeeId,


        )).toList();
    final SyncAttendanceParams p = SyncAttendanceParams(attendanceBody: sendList);

    final val = await _syncAttendanceUseCase(p);

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
        add(GetAllAttendanceEvent(isAfterSync: true));
      },
    );
  }
}
