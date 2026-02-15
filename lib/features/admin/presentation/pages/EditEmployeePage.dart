import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled8/features/admin/data/models/employee%20model/employee_model.dart';
import '../bloc/employee_details/employee_details_bloc.dart';
import '../bloc/employee_details/employee_details_event.dart';
import '../../domain/entities/employee_entity.dart';

class EditEmployeePage extends StatefulWidget {
  final EmployeeModel employee;

  const EditEmployeePage({super.key, required this.employee});

  @override
  State<EditEmployeePage> createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends State<EditEmployeePage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController positionController;
  late TextEditingController departmentController;
  late TextEditingController hourlyRateController;
  late TextEditingController overtimeRateController;
  late TextEditingController currentLocationController;
  String selectedWorkshop = '';

  final List<String> workshops = ['ورشة النجارة', 'ورشة الخياطة', 'المستودع', 'ورشة الإلكترونيات'];

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.employee.user?.fullName??'');
    phoneController = TextEditingController(text: widget.employee.user?.phoneNumber??'');
    emailController = TextEditingController(text: widget.employee.user?.email??'');
    passwordController = TextEditingController(text: '********'); // 🔹 لا نعرض كلمة المرور الحالية
    positionController = TextEditingController(text: widget.employee.position??'');
    departmentController = TextEditingController(text: widget.employee.department??'');
    hourlyRateController = TextEditingController(text: widget.employee.hourlyRate.toString());
    overtimeRateController = TextEditingController(text: widget.employee.overtimeRate.toString());
    currentLocationController = TextEditingController(text: widget.employee.currentLocation??'');
    
    //  التصحيح: تهيئة selectedWorkshop من قائمة الورش
    if (widget.employee.workshops != null && widget.employee.workshops!.isNotEmpty) {
      selectedWorkshop = widget.employee.workshops!.first.name ?? ''; //  استخدام اسم أول ورشة
    } else {
      selectedWorkshop = workshops.first; //  تعيين إلى أول ورشة افتراضية إذا لم تكن هناك ورش
    }
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
    return Directionality(textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7F9),
        appBar: AppBar(
          title: Text("تعديل بيانات الموظف", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              _buildInputCard(),
              SizedBox(height: 30.h),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10.r, offset: Offset(0, 4.h))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField("الاسم الكامل", nameController, Icons.person_outline),
          _buildTextField("رقم الهاتف", phoneController, Icons.phone_android_outlined, isPhone: true),
          _buildTextField("البريد الإلكتروني", emailController, Icons.email_outlined, keyboardType: TextInputType.emailAddress),
          _buildTextField("كلمة المرور (اتركها فارغة لعدم التغيير)", passwordController, Icons.lock_outline, isPassword: true),
          _buildTextField("المسمى الوظيفي", positionController, Icons.work_outline),
          _buildTextField("القسم", departmentController, Icons.business_center_outlined),
          _buildTextField("الموقع الحالي", currentLocationController, Icons.location_on_outlined),

          SizedBox(height: 15.h),
          Text("الورشة الميدانية", style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(child: _buildTextField("راتب الساعة", hourlyRateController, Icons.money, isNumber: true)),
              SizedBox(width: 15.w),
              Expanded(child: _buildTextField("راتب الإضافي", overtimeRateController, Icons.more_time, isNumber: true)),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool isNumber = false, bool isPhone = false, bool isPassword = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 14.sp),
        keyboardType: keyboardType == TextInputType.text && (isNumber || isPhone) ? TextInputType.number : keyboardType,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 12.sp),
          prefixIcon: Icon(icon, color: Colors.blueAccent, size: 20.sp),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A237E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
          elevation: 4,
        ),
        onPressed: () {
          context.read<EmployeeDetailsBloc>().add(UpdateEmployeeFullEvent(
            name: nameController.text,
            phoneNumber: phoneController.text,
            email: emailController.text,
            password: passwordController.text == '********' ? null : passwordController.text,
            position: positionController.text,
            department: departmentController.text,

            hourlyRate: double.tryParse(hourlyRateController.text) ?? 0.0,
            overtimeRate: double.tryParse(overtimeRateController.text) ?? 0.0,
            currentLocation: currentLocationController.text,
          ));
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم تحديث البيانات بنجاح", style: TextStyle(fontSize: 13.sp))));
        },
        child: Text("حفظ كافة التعديلات", style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
