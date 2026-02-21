import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/employee model/employee_model.dart';
import '../bloc/employees/employees_bloc.dart';
import '../bloc/employees/employees_event.dart';
import '../pages/EmployeeDetailsPage.dart';

class EmployeesWidget extends StatefulWidget {
  final EmployeeModel emp;
  final ThemeData theme;
  final bool isFromArchived;

  const EmployeesWidget({
    super.key,
    required this.emp,
    required this.theme,
    required this.isFromArchived,
  });

  @override
  State<EmployeesWidget> createState() => _EmployeesWidgetState();
}

class _EmployeesWidgetState extends State<EmployeesWidget> {
  late final ValueNotifier<bool> isArchived;

  @override
  void initState() {
    isArchived = ValueNotifier(widget.isFromArchived);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isArchived,
      builder: (context, value, child) {
        return Card(
          margin: EdgeInsets.only(bottom: 12.h),
          elevation: value ? 0 : 1,
          color:
              value
                  ? widget.theme.disabledColor.withOpacity(0.05)
                  : widget.theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: BorderSide(
              color: widget.theme.dividerColor.withOpacity(value ? 0.1 : 0.05),
            ),
          ),
          child: ListTile(
            onTap: () async {
              if(value==true){
                return ;
              }
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => EmployeeDetailsPage(employeeModel: widget.emp, isArchived: false,),
                ),
              );
            },
            leading: CircleAvatar(
              radius: 22.r,
              backgroundColor: widget.theme.primaryColor.withOpacity(0.1),
              child:
                  widget.emp.user?.profileImageUrl != null
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(22.r),
                        child: Image.network(
                          widget.emp.user!.profileImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => Icon(
                                Icons.person,
                                color: widget.theme.primaryColor,
                              ),
                        ),
                      )
                      : Icon(
                        Icons.person,
                        color: widget.theme.primaryColor,
                        size: 24.sp,
                      ),
            ),

            title: Text(
              widget.emp.user?.fullName ?? '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                decoration: value ? TextDecoration.lineThrough : null,
                color:
                    value
                        ? widget.theme.disabledColor
                        : widget.theme.textTheme.bodyLarge?.color,
              ),
            ),
            subtitle: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 12.sp,
                  color: widget.theme.disabledColor,
                ),
                SizedBox(width: 4.w),
                Text(
                  widget.emp.position.toString(),
                  style: TextStyle(
                    color: widget.theme.disabledColor,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                value ? Icons.unarchive_outlined : Icons.archive_outlined,
                color: value ? Colors.green : Colors.orange,
              ),
              onPressed:
                  () => _showArchiveConfirmation(
                    context,
                    widget.emp,
                    isArchived.value,
                  ),
            ),
          ),
        );
      },
    );
  }
}

void _showArchiveConfirmation(
  BuildContext context,
  EmployeeModel employee,
  bool isArchived,
) {
  final bool willArchive = !isArchived;
  showDialog(
    context: context,
    builder:
        (d) => AlertDialog(
          title: Text(willArchive ? 'أرشفة الموظف' : 'إلغاء الأرشفة'),
          content: Text(
            willArchive
                ? 'هل أنت متأكد من أرشفة الموظف ${employee.user?.fullName ?? 'المستخدم'}؟'
                : 'هل تريد إعادة تنشيط الموظف ${employee.user?.fullName ?? 'المستخدم'}؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(d),
              child: const Text("إلغاء"),
            ),
            TextButton(
              onPressed: () {
                context.read<EmployeesBloc>().add(
                  isArchived
                      ? RestoreArchiveEmployeeEvent(employee.id.toString())
                      : ToggleArchiveEmployeeEvent(employee.id.toString()),
                );
                Navigator.pop(d);
              },
              child: Text(
                willArchive ? "أرشفة" : "تنشيط",
                style: TextStyle(
                  color: willArchive ? Colors.orange : Colors.green,
                ),
              ),
            ),
          ],
        ),
  );
}
