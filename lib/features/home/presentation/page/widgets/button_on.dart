import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled8/common/helper/src/app_varibles.dart';
import 'package:untitled8/features/Attendance/presentation/bloc/attendance_bloc.dart';
import 'package:untitled8/features/home/presentation/bloc/Cubit_dropdown/dropdown_cubit.dart';

import '../../../../Attendance/data/models/attendance_model.dart';
import '../../bloc/Cubit_dropdown/dropdown_state.dart';



class ButtonOnIn extends StatefulWidget {
  const ButtonOnIn({super.key});

  @override
  State<ButtonOnIn> createState() => _ButtonOnInState();
}

class _ButtonOnInState extends State<ButtonOnIn> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DropdownCubit, DropdownState>(
      builder: (context, state) {
        bool isEnable =
            context.read<DropdownCubit>().state.localeAttendanceModel == null;
        return GestureDetector(
          onTap:
              isEnable
                  ? () async {
                    final val =
                        context.read<DropdownCubit>().state.selectedValue;
                    if (val == null) {
                      _showSnackBar(
                        context,
                        'يرجى اختيار الورشة أولاً',
                        Colors.orange,
                      );
                      return;
                    }
                    AttendanceModel attendanceModel = AttendanceModel(
                      id: DateTime.now().millisecondsSinceEpoch * 1000 + Random().nextInt(1000),
                      workshopId: val.id,
                      workshop: AttendanceWorkshop(
                        id: val.id!,
                        name: val.name!,
                      ),
                      date: DateTime.now(),
                      checkIn: DateTime.now().toString(),
                      regularHours: AppVariables.user!.userable!.hourlyRate!,
                      overtimeHours: AppVariables.user!.userable!.overtimeRate!,
                      employeeId: AppVariables.user!.id,
                      status: "pending",


                    );
                    context.read<DropdownCubit>().changeAttendance(
                      newValue: attendanceModel,
                      workshopEntity: val,
                    );
                    context.read<AttendanceBloc>().add(
                      AddToLocaleAttendanceEvent(
                        attendanceModel: attendanceModel,
                      ),
                    );

                    _showSnackBar(
                      context,
                      'تم تسجيل الحضور بنجاح',
                      Colors.green,
                    );
                  }
                  : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: double.infinity,
            height: 45.h,
            transform: Matrix4.identity()..scale(isEnable ? 0.96 : 1.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              boxShadow:
                  isEnable
                      ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : null,
              border: Border.all(
                color:
                    isEnable
                        ? (isEnable
                            ? Colors.blue.shade900
                            : Colors.blue.shade500)
                        : Colors.grey.shade400,
                width: 1.5.w,
              ),
              color: isEnable ? Colors.blue.shade100 : Colors.grey.shade200,
            ),
            child: Center(
              child: Text(
                'تسجيل الحضور',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isEnable ? Colors.blue.shade900 : Colors.blue.shade500,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ButtonOut extends StatefulWidget {
  const ButtonOut({super.key});

  @override
  State<ButtonOut> createState() => _ButtonOutState();
}

class _ButtonOutState extends State<ButtonOut> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DropdownCubit, DropdownState>(
      builder: (context, state) {
        bool isEnable =
            (context.read<DropdownCubit>().state.localeAttendanceModel != null);

        return GestureDetector(
          onTap:
              isEnable
                  ? () {
                    // final val = AppVariables.getLocaleAttendance!;
                    final val =
                        context
                            .read<DropdownCubit>()
                            .state
                            .localeAttendanceModel!;


                    context.read<AttendanceBloc>().add(
                      PatchLocaleAttendanceEvent(
                        attendanceModel: val.copyWith(
                          checkOut: DateTime.now().toString(),
                        ),
                      ),
                    );
                    context.read<DropdownCubit>().clearSelected();
                  }
                  : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: double.infinity,
            height: 45.h,
            transform: Matrix4.identity()..scale(isEnable ? 0.96 : 1.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              boxShadow:
                  !isEnable
                      ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : null,
              border: Border.all(
                color: isEnable ? Colors.blue.shade900 : Colors.blue.shade500,
                width: 1.5.w,
              ),
              color: isEnable ? Colors.blue.shade100 : Colors.grey.shade200,
            ),
            child: Center(
              child: Text(
                'تسجيل الانصراف',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: isEnable ? Colors.blue.shade900 : Colors.grey.shade500,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

void _showSnackBar(BuildContext context, String msg, Color color) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg, style: TextStyle(fontSize: 13.sp)),
      backgroundColor: color,
    ),
  );
}
