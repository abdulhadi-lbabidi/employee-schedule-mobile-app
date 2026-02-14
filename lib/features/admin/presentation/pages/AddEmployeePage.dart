import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_strings.dart';
import '../../data/models/employee model/employee_model.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/usecases/add_employee.dart';
import '../bloc/employees/employees_bloc.dart';
import '../bloc/employees/employees_event.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final hourlyRateController = TextEditingController(text: "6");
  final overtimeRateController = TextEditingController(text: "1");
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "إضافة موظف جديد",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: theme.primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("المعلومات الأساسية", theme),
              SizedBox(height: 15.h),
              _buildTextField(
                "الاسم الكامل",
                nameController,
                Icons.person_add_alt_1_rounded,
                theme,
              ),
              _buildTextField(
                "email",
                emailController,
                Icons.person_add_alt_1_rounded,
                theme,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                  decoration: InputDecoration(
                    labelText: "كلمة المرور",
                    labelStyle: TextStyle(
                      fontSize: 12.sp,
                      color: theme.disabledColor,
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outline_rounded,
                      color: theme.primaryColor,
                      size: 20.sp,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 18.sp,
                        color: theme.disabledColor,
                      ),
                      onPressed:
                          () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.r),
                      borderSide: BorderSide(
                        color: theme.dividerColor.withOpacity(0.2),
                      ),
                    ),
                    filled: true,
                    fillColor: theme.cardColor,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 15.w,
                    ),
                  ),
                  validator:
                      (value) =>
                          (value == null || value.length < 6)
                              ? "يجب أن تكون كلمة المرور 6 أحرف على الأقل"
                              : null,
                ),
              ),
              _buildTextField(
                "رقم الهاتف",
                phoneController,
                Icons.phone_android_rounded,
                theme,
                isPhone: true,
              ),

              // ✅ حذفنا قسم الورشات بالكلية
              SizedBox(height: 25.h),
              _buildSectionTitle("الإعدادات المالية (ل.س)", theme),
              SizedBox(height: 15.h),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      "راتب الساعة",
                      hourlyRateController,
                      Icons.monetization_on_rounded,
                      theme,
                      isNumber: true,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: _buildTextField(
                      "راتب الإضافي",
                      overtimeRateController,
                      Icons.more_time_rounded,
                      theme,
                      isNumber: true,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40.h),
              _buildSubmitButton(context, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: TextStyle(
        color: theme.primaryColor,
        fontSize: 15.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
    ThemeData theme, {
    bool isNumber = false,
    bool isPhone = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          fontSize: 14.sp,
          color: theme.textTheme.bodyLarge?.color,
        ),
        keyboardType:
            isNumber || isPhone ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 12.sp, color: theme.disabledColor),
          prefixIcon: Icon(icon, color: theme.primaryColor, size: 20.sp),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.r)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
          ),
          filled: true,
          fillColor: theme.cardColor,
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 15.w,
          ),
        ),
        validator:
            (value) =>
                value == null || value.isEmpty ? "هذا الحقل مطلوب" : null,
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 55.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          elevation: 4,
        ),
        onPressed: () => _handleSubmit(context),
        child: Text(
          "إتمام عملية الإضافة",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ✅ _handleSubmit مبسط بدون ورشات
  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // ⚠️ هذا الجزء هو مصدر الخطأ: يجب أن يكون التحويل آمناً
      final hourlyRate = _safeParseDouble(hourlyRateController.text);
      final overtimeRate = _safeParseDouble(overtimeRateController.text);

      final newEmployee = AddEmployeeParams(
        // id: DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: nameController.text,
        phone_number: phoneController.text,
        email: emailController.text,
        password: passwordController.text,

        current_location: 'غير محدد',
        hourly_rate: hourlyRate,
        overtime_rate: overtimeRate,
        department: 'Developer',
        position: 'IT',
        // dailyWorkHours: 8.0, // ✅ تم إصلاح: تمرير double بدلاً من Map
        // weeklyHistory: [],
        // weeklyOvertime: 0,
        // isArchived: false,
      );

      context.read<EmployeesBloc>().add(AddEmployeeEvent(newEmployee));
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "تمت إضافة الموظف بنجاح ✓",
            style: TextStyle(fontSize: 13.sp),
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // دالة مساعدة للتحويل الآمن من String إلى double
  double _safeParseDouble(String text) {
    try {
      return double.parse(text.trim());
    } catch (e) {
      // إذا فشل التحويل، نرجع 0.0 أو قيمة افتراضية
      return 0.0;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    hourlyRateController.dispose();
    overtimeRateController.dispose();
    super.dispose();
  }
}
