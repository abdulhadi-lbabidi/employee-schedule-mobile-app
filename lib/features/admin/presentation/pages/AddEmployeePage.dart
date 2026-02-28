import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/usecases/add_employee.dart';
import '../bloc/employees/employees_bloc.dart';
import '../bloc/employees/employees_event.dart';
import '../bloc/employees/employees_state.dart';

class AddEmployeePage extends StatefulWidget {
  final EmployeesBloc employeesBloc;

  const AddEmployeePage({super.key, required this.employeesBloc});

  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final positionController = TextEditingController();
  final departmentController = TextEditingController();
  final currentLocationController = TextEditingController();

  /// راتب 8 ساعات
  final salary8HoursController = TextEditingController(text: "48");

  /// راتب الساعة (محسوب تلقائياً)
  final salaryPerHourController = TextEditingController();

  final overtimeRateController = TextEditingController(text: "1");

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();

    salary8HoursController.addListener(_calculateSalaryPerHour);
    _calculateSalaryPerHour();
  }

  void _calculateSalaryPerHour() {
    final total = double.tryParse(salary8HoursController.text) ?? 0;
    final perHour = total / 8;

    salaryPerHourController.text =
    perHour == 0 ? "0" : perHour.toStringAsFixed(2);
  }

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
      body: BlocListener<EmployeesBloc, EmployeesState>(
        bloc: widget.employeesBloc,
        listener: (context, state) {
          state.addEmployeeData.listenerFunction(
            onSuccess: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("تمت إضافة الموظف بنجاح ✓"),
                  backgroundColor: Colors.green,
                ),
              );
            },
          );
        },
        listenWhen:
            (pre, cur) =>
        pre.addEmployeeData.status != cur.addEmployeeData.status,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle("المعلومات الأساسية", theme),
                _textField("الاسم الكامل", nameController, Icons.person, theme),
                _textField(
                  "البريد الإلكتروني",
                  emailController,
                  Icons.email,
                  theme,
                  keyboardType: TextInputType.emailAddress,
                ),
                _passwordField(theme),
                _textField(
                  "رقم الهاتف",
                  phoneController,
                  Icons.phone,
                  theme,
                  keyboardType: TextInputType.phone,
                ),
                _textField(
                  "المسمى الوظيفي",
                  positionController,
                  Icons.work_outline,
                  theme,
                ),
                _textField(
                  "القسم",
                  departmentController,
                  Icons.business_center,
                  theme,
                ),
                _textField(
                  "الموقع الحالي",
                  currentLocationController,
                  Icons.location_on_outlined,
                  theme,
                ),
                SizedBox(height: 25.h),
                _sectionTitle("الإعدادات المالية", theme),
                _textField(
                  "راتب خلال فترة 8 ساعات",
                  salary8HoursController,
                  Icons.monetization_on,
                  theme,
                  isNumber: true,
                ),
                _readOnlyField(
                  "راتب الساعة الواحدة خلال 8 ساعات",
                  salaryPerHourController,
                  theme,
                ),
                _textField(
                  "راتب الساعة الإضافية",
                  overtimeRateController,
                  Icons.more_time,
                  theme,
                  isNumber: true,
                ),
                SizedBox(height: 40.h),
                _submitButton(context, theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, ThemeData theme) => Padding(
    padding: EdgeInsets.only(bottom: 12.h),
    child: Text(
      title,
      style: TextStyle(
        color: theme.primaryColor,
        fontSize: 15.sp,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _textField(
      String label,
      TextEditingController controller,
      IconData icon,
      ThemeData theme, {
        bool isNumber = false,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        validator:
            (value) =>
        value == null || value.isEmpty ? "هذا الحقل مطلوب" : null,
      ),
    );
  }

  Widget _readOnlyField(
      String label,
      TextEditingController controller,
      ThemeData theme,
      ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calculate),
          filled: true,
          fillColor: theme.cardColor.withOpacity(0.6),
          suffixText: "\$ / ساعة",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
      ),
    );
  }

  Widget _passwordField(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: TextFormField(
        controller: passwordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          labelText: "كلمة المرور",
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        validator:
            (value) =>
        value != null && value.length < 6
            ? "كلمة المرور 6 أحرف على الأقل"
            : null,
      ),
    );
  }

  Widget _submitButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 55.h,
      child: ElevatedButton(
        onPressed: _submit,
        child: const Text("إتمام عملية الإضافة"),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final params = AddEmployeeParams(
      fullName: nameController.text,
      email: emailController.text,
      phone_number: phoneController.text,
      password: passwordController.text,
      position: positionController.text,
      department: departmentController.text,
      current_location: currentLocationController.text,
      hourly_rate: double.tryParse(salary8HoursController.text) ?? 0,
      overtime_rate: double.tryParse(overtimeRateController.text) ?? 0,
    );

    widget.employeesBloc.add(AddEmployeeEvent(params));
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    positionController.dispose();
    departmentController.dispose();
    currentLocationController.dispose();
    salary8HoursController.dispose();
    salaryPerHourController.dispose();
    overtimeRateController.dispose();
    super.dispose();
  }
}