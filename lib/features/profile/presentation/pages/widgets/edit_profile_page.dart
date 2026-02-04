import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled8/core/data_state_model.dart';

import '../../bloc/Profile/_profile_bloc.dart';
import '../../bloc/Profile/_profile_event.dart';
import '../../bloc/Profile/_profile_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileBloc>().state.profile;
    if (state.status == BlocStatus.success) {
      nameController = TextEditingController(text: state.data!.user!.fullName!);
      phoneController = TextEditingController(
        text: state.data!.user!.phoneNumber!,
      );
    } else {
      nameController = TextEditingController();
      phoneController = TextEditingController();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: theme.primaryColor,
            size: 20.sp,
          ),
        ),
        title: Text(
          "تعديل الملف الشخصي",
          style: TextStyle(
            color: theme.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            _inputField("الاسم الكامل", nameController, theme),
            SizedBox(height: 16.h),
            _inputField("رقم الهاتف", phoneController, theme),
            SizedBox(height: 40.h),
            _buildSaveButton(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
        onPressed: () {
          context.read<ProfileBloc>().add(
            UpdateProfileInfo(
              name: nameController.text,
              phone: phoneController.text,
            ),
          );
          Navigator.pop(context);
        },
        child: Text(
          "حفظ التعديلات",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _inputField(
    String label,
    TextEditingController controller,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: theme.disabledColor,
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            fillColor: theme.cardColor,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: theme.dividerColor.withOpacity(0.1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: theme.dividerColor.withOpacity(0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
          ),
        ),
      ],
    );
  }
}
