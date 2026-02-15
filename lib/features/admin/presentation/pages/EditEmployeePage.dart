import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:untitled8/features/admin/data/models/employee%20model/employee_model.dart';
import '../bloc/employee_details/employee_details_bloc.dart';
import '../bloc/employee_details/employee_details_event.dart';

class EditEmployeePage extends StatefulWidget {
  final EmployeeModel employee;

  const EditEmployeePage({
    super.key,
    required this.employee,
  });

  @override
  State<EditEmployeePage> createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends State<EditEmployeePage> {
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  late final TextEditingController positionController;
  late final TextEditingController departmentController;
  late final TextEditingController hourlyRateController;
  late final TextEditingController overtimeRateController;
  late final TextEditingController currentLocationController;

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: widget.employee.user?.fullName ?? '');
    phoneController =
        TextEditingController(text: widget.employee.user?.phoneNumber ?? '');
    emailController =
        TextEditingController(text: widget.employee.user?.email ?? '');
    passwordController = TextEditingController(text: '');
    positionController =
        TextEditingController(text: widget.employee.position ?? '');
    departmentController =
        TextEditingController(text: widget.employee.department ?? '');
    hourlyRateController =
        TextEditingController(text: widget.employee.hourlyRate.toString());
    overtimeRateController =
        TextEditingController(text: widget.employee.overtimeRate.toString());
    currentLocationController =
        TextEditingController(text: widget.employee.currentLocation ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    positionController.dispose();
    departmentController.dispose();
    hourlyRateController.dispose();
    overtimeRateController.dispose();
    currentLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text("تعديل بيانات الموظف"),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              _buildInputCard(context),
              SizedBox(height: 30.h),
              _buildSaveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== INPUT CARD =====================

  Widget _buildInputCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: theme.brightness == Brightness.light
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          )
        ]
            : [],
      ),
      child: Column(
        children: [
          _buildTextField(
            context,
            label: "الاسم الكامل",
            controller: nameController,
            icon: Icons.person_outline,
          ),
          _buildTextField(
            context,
            label: "رقم الهاتف",
            controller: phoneController,
            icon: Icons.phone_android_outlined,
            keyboardType: TextInputType.phone,
          ),
          _buildTextField(
            context,
            label: "البريد الإلكتروني",
            controller: emailController,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          _buildTextField(
            context,
            label: "كلمة المرور (اتركها فارغة لعدم التغيير)",
            controller: passwordController,
            icon: Icons.lock_outline,
            isPassword: true,
          ),
          _buildTextField(
            context,
            label: "المسمى الوظيفي",
            controller: positionController,
            icon: Icons.work_outline,
          ),
          _buildTextField(
            context,
            label: "القسم",
            controller: departmentController,
            icon: Icons.business_center_outlined,
          ),
          _buildTextField(
            context,
            label: "الموقع الحالي",
            controller: currentLocationController,
            icon: Icons.location_on_outlined,
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  context,
                  label: "راتب الساعة",
                  controller: hourlyRateController,
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: _buildTextField(
                  context,
                  label: "الراتب الإضافي",
                  controller: overtimeRateController,
                  icon: Icons.more_time,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===================== TEXT FIELD =====================

  Widget _buildTextField(
      BuildContext context, {
        required String label,
        required TextEditingController controller,
        required IconData icon,
        bool isPassword = false,
        TextInputType keyboardType = TextInputType.text,
      }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: theme.textTheme.bodySmall,
          prefixIcon: Icon(icon, color: colorScheme.primary),
          filled: true,
          fillColor: colorScheme.surface,
          contentPadding:
          EdgeInsets.symmetric(vertical: 14.h, horizontal: 15.w),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: theme.dividerColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: theme.dividerColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide:
            BorderSide(color: colorScheme.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  // ===================== SAVE BUTTON =====================

  Widget _buildSaveButton(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 55.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: theme.brightness == Brightness.light ? 4 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        onPressed: () {
          context.read<EmployeeDetailsBloc>().add(
            UpdateEmployeeFullEvent(
              name: nameController.text.trim(),
              phoneNumber: phoneController.text.trim(),
              email: emailController.text.trim(),
              password:
              passwordController.text.isEmpty
                  ? null
                  : passwordController.text,
              position: positionController.text.trim(),
              department: departmentController.text.trim(),
              hourlyRate:
              double.tryParse(hourlyRateController.text) ?? 0,
              overtimeRate:
              double.tryParse(overtimeRateController.text) ?? 0,
              currentLocation:
              currentLocationController.text.trim(),
            ),
          );

          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: colorScheme.primary,
              content: Text(
                "تم تحديث البيانات بنجاح",
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onPrimary),
              ),
            ),
          );
        },
        child: Text(
          "حفظ كافة التعديلات",
          style: theme.textTheme.titleMedium
              ?.copyWith(color: colorScheme.onPrimary),
        ),
      ),
    );
  }
}
