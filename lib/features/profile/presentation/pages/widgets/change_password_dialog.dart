import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/Profile/_profile_bloc.dart';
import '../../bloc/Profile/_profile_event.dart';

void showChangePasswordDialog(BuildContext context, ProfileBloc bloc) {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (dialogContext) {
      final theme = Theme.of(dialogContext);
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        backgroundColor: theme.cardColor,
        title: Text(
          'تغيير كلمة المرور',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPasswordField(
                controller: oldPasswordController,
                label: 'كلمة المرور الحالية',
                validator: (val) => val!.isEmpty ? 'الحقل مطلوب' : null,
              ),
              SizedBox(height: 15.h),
              _buildPasswordField(
                controller: newPasswordController,
                label: 'كلمة المرور الجديدة',
                validator: (val) {
                  if (val!.isEmpty) return 'الحقل مطلوب';
                  if (val.length < 8) return 'يجب أن تكون 8 أحرف على الأقل';
                  return null;
                },
              ),
              SizedBox(height: 15.h),
              _buildPasswordField(
                controller: confirmPasswordController,
                label: 'تأكيد كلمة المرور الجديدة',
                validator: (val) {
                  if (val != newPasswordController.text) {
                    return 'كلمتا المرور غير متطابقتين';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                bloc.add(UpdatePasswordEvent(
                  oldPassword: oldPasswordController.text,
                  newPassword: newPasswordController.text,
                  confirmPassword: confirmPasswordController.text,
                ));
                Navigator.pop(dialogContext);
                 ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم إرسال الطلب بنجاح')),
                );
              }
            },
            child: const Text('حفظ التغييرات'),
          ),
        ],
      );
    },
  );
}

Widget _buildPasswordField({
  required TextEditingController controller,
  required String label,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    obscureText: true,
    validator: validator,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
    ),
  );
}
