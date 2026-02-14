import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled8/features/admin/data/models/employee%20model/employee_model.dart';
import '../../domain/entities/employee_entity.dart';

class EmployeeStatusCard extends StatelessWidget {
  final EmployeeModel employee;

  const EmployeeStatusCard({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: theme.primaryColor.withOpacity(0.1),
                backgroundImage:
                    employee.user?.profileImageUrl != null
                        ? NetworkImage(employee.user!.profileImageUrl!)
                        : null,
                child:
                    (employee.user?.profileImageUrl == null)
                        ? Icon(
                          Icons.person,
                          color: theme.primaryColor,
                          size: 30.sp,
                        )
                        : null,
              ),
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  width: 14.w,
                  height: 14.w,
                  decoration: BoxDecoration(
                    color:
                        employee.isOnline == null
                            ? Colors.grey
                            : employee.isOnline != null
                            ? Colors.green
                            : Colors.grey,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.cardColor, width: 2),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.user?.fullName ?? 'N/A', // ✅ Null safety
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 12.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 4.w),
                    // Text(
                    //   employee.workshopName ?? 'N/A', // ✅ Null safety
                    //   style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color:
                  employee.isOnline == null
                      ? Colors.grey.withOpacity(0.1)
                      : employee.isOnline!
                      ? Colors.green.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              employee.isOnline! ? "نشط" : "خامل",
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: employee.isOnline! ? Colors.green : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
