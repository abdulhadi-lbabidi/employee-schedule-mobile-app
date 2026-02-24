import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled8/core/widget/shimmer_widget.dart';
import 'package:untitled8/features/admin/data/models/employee%20model/employee_model.dart';
import 'package:untitled8/features/admin/data/models/workshop_models/workshop_model.g.dart';
import 'package:untitled8/features/admin/presentation/bloc/employees/employees_bloc.dart';
import 'package:untitled8/features/admin/presentation/bloc/employees/employees_event.dart';
import 'package:untitled8/features/admin/presentation/bloc/employees/employees_state.dart';
import 'package:untitled8/features/admin/presentation/bloc/workshops/workshops_bloc.dart';
import 'package:untitled8/features/admin/presentation/bloc/workshops/workshops_event.dart';
import 'package:untitled8/features/admin/presentation/bloc/workshops/workshops_state.dart';
import '../../../Notification/domain/usecases/send_notification_use_case.dart';
import '../../../Notification/presentation/bloc/notification_bloc.dart';
import '../../../Notification/presentation/bloc/notification_event.dart';
import '../../../Notification/presentation/bloc/notification_state.dart';

class AddNotificationSheetWidget extends StatefulWidget {
  final ThemeData theme;

  const AddNotificationSheetWidget({super.key, required this.theme});

  @override
  State<AddNotificationSheetWidget> createState() =>
      _AddNotificationSheetWidgetState();
}

class _AddNotificationSheetWidgetState
    extends State<AddNotificationSheetWidget> {
  late final TextEditingController titleController;

  late final TextEditingController bodyController;

  late final ValueNotifier<String?> selected;
  late final ValueNotifier<EmployeeModel?> selectedEmp;
  late final ValueNotifier<WorkshopModel?> selectedWorkshop;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    titleController = TextEditingController();
    bodyController = TextEditingController();
    selected = ValueNotifier(null);
    selectedEmp = ValueNotifier(null);
    selectedWorkshop = ValueNotifier(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _globalKey,
      child: BlocListener<NotificationBloc, NotificationState>(
        listenWhen:
            (pre, cur) =>
                pre.sendNotificationData.status !=
                cur.sendNotificationData.status,

        listener: (context, state) {
          state.sendNotificationData.listenerFunction(
            onSuccess: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("تم إرسال التنبيه بنجاح ✓"),
                  backgroundColor: Colors.green,
                ),
              );
            },
          );
          // TODO: implement listener
        },
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24.w,
            right: 24.w,
            top: 24.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: widget.theme.dividerColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "بث تنبيه جديد للموظفين",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: widget.theme.primaryColor,
                ),
              ),
              SizedBox(height: 20.h),
              TextFormField(
                controller: titleController,
                style: TextStyle(
                  color: widget.theme.textTheme.bodyLarge?.color,
                ),
                decoration: const InputDecoration(
                  labelText: "عنوان التنبيه",
                  prefixIcon: Icon(Icons.title_rounded),
                ),
                validator: (val) => val!.isEmpty ? 'هذا الحقل مطلوب' : null,
              ),
              SizedBox(height: 15.h),
              TextFormField(
                controller: bodyController,
                validator: (val) => val!.isEmpty ? 'هذا الحقل مطلوب' : null,

                style: TextStyle(
                  color: widget.theme.textTheme.bodyLarge?.color,
                ),
                decoration: const InputDecoration(
                  labelText: "نص الرسالة",
                  prefixIcon: Icon(Icons.message_rounded),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "حدد المستهدفون",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: widget.theme.primaryColor,
                ),
              ),
              SizedBox(height: 20.h),
              ValueListenableBuilder(
                valueListenable: selected,
                builder: (context, value, child) {
                  return _buildDropdown<String>(
                    items: ["موظف معين", "موظفين ضمن نفس الورشة"],
                    onChanged: (val) {
                      selected.value = val;
                      if (val == "موظف معين") {
                        context.read<EmployeesBloc>().add(
                          GetAllEmployeeEvent(),
                        );
                        selectedWorkshop.value=null;
                        selectedEmp.value=null;

                      }
                      if (val == "موظفين ضمن نفس الورشة") {
                        context.read<WorkshopsBloc>().add(
                          GetAllWorkShopEvent(),
                        );
                        selectedEmp.value=null;
                        selectedWorkshop.value=null;

                      }
                    },
                    hint: 'حدد الفئة',
                    theme: widget.theme,
                    value: value,
                    itemLabel: (val) => val,
                    validator:
                        (val) =>
                            val == null || val.isEmpty
                                ? 'هذا الحقل مطلوب'
                                : null,
                  );
                },
              ),
              SizedBox(height: 20.h),
              ValueListenableBuilder(
                valueListenable: selected,
                builder: (context, value, child) {
                  if (value == "موظف معين") {
                    return BlocBuilder<EmployeesBloc, EmployeesState>(
                      builder: (context, state) {
                        return state.employeesData.builder(
                          onSuccess: (_) {
                            return ValueListenableBuilder(
                              valueListenable: selectedEmp,
                              builder: (context, value, child) {
                                return _buildDropdown<EmployeeModel?>(
                                  items: state.employeesData.data!.data!,
                                  onChanged: (val) {
                                    selectedEmp.value = val;
                                  },
                                  theme: widget.theme,
                                  value: value,
                                  itemLabel: (val) => val!.user!.fullName!,
                                  validator:
                                      (val) =>
                                          val == null
                                              ? 'هذا الحقل مطلوب'
                                              : null,
                                  hint: 'حدد الموظف'
                                );
                              },
                            );
                          },
                          failedWidget: Center(
                            child: Text(state.employeesData.errorMessage),
                          ),
                          loadingWidget: ShimmerWidget(
                            height: 50,
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(18),
                          ),
                        );
                      },
                    );
                  } else if (value == "موظفين ضمن نفس الورشة") {
                    return BlocBuilder<WorkshopsBloc, WorkshopsState>(
                      builder: (context, state) {
                        return state.getAllWorkshopData.builder(
                          onSuccess: (_) {
                            return ValueListenableBuilder(
                              valueListenable: selectedWorkshop,
                              builder: (context, value, child) {
                                return _buildDropdown<WorkshopModel?>(
                                  items: state.getAllWorkshopData.data!.data!,
                                  onChanged: (val) {
                                    selectedWorkshop.value = val;
                                  },
                                  validator:
                                      (val) =>
                                          val == null
                                              ? 'هذا الحقل مطلوب'
                                              : null,
                                  theme: widget.theme,
                                  value: value,
                                  itemLabel: (val) => val!.name!,
                                  hint: 'حدد الورشة'
                                );
                              },
                            );
                          },
                          failedWidget: Center(
                            child: Text(state.getAllWorkshopData.errorMessage),
                          ),
                          loadingWidget: ShimmerWidget(
                            height: 50,
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(18),
                          ),
                        );
                      },
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
              SizedBox(height: 20.h),

          ValueListenableBuilder(
            valueListenable: selectedEmp,
            builder: (context, emp, _) {
              return ValueListenableBuilder(
                valueListenable: selectedWorkshop,
                builder: (context, workshop, __) {
                  final isDisabled = emp == null && workshop == null;

                  return SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: isDisabled
                          ? null
                          : () {
                        if (!(_globalKey.currentState?.validate() ?? false)) {
                          return;
                        }

                        context.read<NotificationBloc>().add(
                          SendNotificationsEvent(
                            params: SendNotificationParams(
                              title: titleController.text,
                              body: bodyController.text,
                              targetEmployeeId: emp?.user?.id,
                              targetWorkshop: workshop?.id,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "إرسال الآن",
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildDropdown<T>({
  required T? value,
  required List<T> items,
  required ValueChanged<T?> onChanged,
  required ThemeData theme,
  String?  hint,
  String Function(T)? itemLabel,
  String? Function(T?)? validator, // 👈 أضف هذا
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 6.h),
      DropdownButtonFormField<T>(
        value: value,
        validator: validator,
        decoration: InputDecoration(
          filled: true,
          fillColor: theme.scaffoldBackgroundColor,
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
          ),
        ),
        hint: Text(
          hint??  "اختر عنصر",
          style: TextStyle(fontSize: 13.sp, color: theme.hintColor),
        ),
        dropdownColor: theme.cardColor,
        icon: Icon(Icons.keyboard_arrow_down, color: theme.primaryColor),
        items:
            items
                .map(
                  (T item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      itemLabel != null ? itemLabel(item) : item.toString(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                )
                .toList(),
        onChanged: onChanged,
      ),
    ],
  );
}
