import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/helper/src/app_varibles.dart';
import '../../../../core/data_state_model.dart';
import '../../../../core/widget/show_snack_bar.dart';
import '../bloc/attendance_bloc.dart';

class SyncWidget extends StatelessWidget {
 final ThemeData theme;

  const SyncWidget({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, state) {
        return state.syncAttendanceData.status == BlocStatus.init
            ? TextButton.icon(
          onPressed: () {
            final isEnable =
                state.getAllAttendanceData.data?.any(
                      (week) =>
                  week.attendances?.any(
                        (e) => e.status?.toLowerCase() == "pending",
                  ) ??
                      false,
                ) ??
                    false;
            final isNotEnd = AppVariables.localeAttendance != null;
            if ((isNotEnd && isEnable)) {
              showSnackBar(
                context,
                'الرجاء انهاء المناوبة اولا',
                Colors.red,
              );
            }
            else
              if (isEnable) {
              context.read<AttendanceBloc>().add(
                SyncAttendanceEvent(),
              );
            } else {
                showSnackBar(
                context,
                'لايوجد ساعات لرفعها',
                Colors.orange,
              );
            }
          },
          icon: Icon(
            Icons.sync_rounded,
            color: theme.primaryColor,
            size: 20.sp,
          ),
          label: Text(
            "مزامنة البيانات",
            style: TextStyle(
              color: theme.primaryColor,
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
            : state.syncAttendanceData.builder(
          onSuccess: (_) {
            return TextButton.icon(
              onPressed: () {
                if (state.getAllAttendanceData.data?.any(
                      (week) =>
                  week.attendances?.any(
                        (e) =>
                    e.status?.toLowerCase() == "pending",
                  ) ??
                      false,
                ) ??
                    false) {
                  context.read<AttendanceBloc>().add(
                    SyncAttendanceEvent(),
                  );
                } else {
                  showSnackBar(
                    context,
                    'لايوجد ساعات لرفعها',
                    Colors.orange,
                  );
                }
              },
              icon: Icon(
                Icons.sync_rounded,
                color: theme.primaryColor,
                size: 20.sp,
              ),
              label: Text(
                "مزامنة البيانات",
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
          loadingWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "جاري المزامنة...",
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 5.w),
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          failedWidget: TextButton.icon(
            onPressed:
                () => context.read<AttendanceBloc>().add(
              SyncAttendanceEvent(),
            ),
            icon: Icon(
              Icons.sync_rounded,
              color: theme.primaryColor,
              size: 20.sp,
            ),
            label: Text(
              "مزامنة البيانات",
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
