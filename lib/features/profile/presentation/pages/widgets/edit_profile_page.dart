import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled8/core/data_state_model.dart';
import 'package:untitled8/core/di/injection.dart';
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
  File? _imageFile;
  String? _authToken;

  @override
  void initState() {
    super.initState();
    _loadToken();
    final state = context.read<ProfileBloc>().state.profile;
    if (state.status == BlocStatus.success) {
      nameController = TextEditingController(text: state.data!.user!.fullName ?? "");
      phoneController = TextEditingController(text: state.data!.user!.phoneNumber ?? "");
    } else {
      nameController = TextEditingController();
      phoneController = TextEditingController();
    }
  }

  Future<void> _loadToken() async {
    final storage = sl<FlutterSecureStorage>();
    final token = await storage.read(key: 'auth_token');
    if (mounted) {
      setState(() {
        _authToken = token;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    context.read<ProfileBloc>().add(ResetUpdateStatus());
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      // تحديث الصورة فوراً في الـ Bloc
      if (mounted) {
        context.read<ProfileBloc>().add(UpdateProfileImage(_imageFile!));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        state.updateProfile.listenerFunction(
          onSuccess: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم حفظ التعديلات بنجاح'), backgroundColor: Colors.green),
            );
            Navigator.pop(context);
          },
          onFailed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.updateProfile.errorMessage), backgroundColor: Colors.red),
            );
          },
        );
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: theme.primaryColor, size: 20.sp),
          ),
          title: Text(
            "تعديل الملف الشخصي",
            style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold, fontSize: 18.sp),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            children: [
              _buildImagePicker(theme),
              SizedBox(height: 30.h),
              _inputField("الاسم الكامل", nameController, theme),
              SizedBox(height: 16.h),
              _inputField("رقم الهاتف", phoneController, theme),
              SizedBox(height: 40.h),
              _buildSaveButton(context, theme),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider? _getImageProvider() {
    final user = context.read<ProfileBloc>().state.profile.data?.user;
    if (_imageFile != null) {
      return FileImage(_imageFile!);
    }
    if (user?.profileImageUrl != null && _authToken != null) {
      return NetworkImage(
        user!.profileImageUrl!,
        headers: {'Authorization': 'Bearer $_authToken'},
      );
    }
    return null;
  }

  Widget _buildImagePicker(ThemeData theme) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50.r,
            backgroundColor: theme.primaryColor.withOpacity(0.1),
            backgroundImage: _getImageProvider(),
            child: _getImageProvider() == null
                ? Icon(Icons.person, size: 50.sp, color: theme.primaryColor)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 16.r,
                backgroundColor: theme.primaryColor,
                child: Icon(Icons.camera_alt, color: Colors.white, size: 16.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context, ThemeData theme) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final isLoading = state.updateProfile.isLoading;
        return SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              elevation: 0,
            ),
            onPressed: isLoading
                ? null
                : () {
                    context.read<ProfileBloc>().add(
                          UpdateProfileInfo(
                            name: nameController.text,
                            phone: phoneController.text,
                          ),
                        );
                  },
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    "حفظ التعديلات",
                    style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.bold),
                  ),
          ),
        );
      },
    );
  }

  Widget _inputField(String label, TextEditingController controller, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: theme.disabledColor, fontSize: 11.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontSize: 14.sp, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            fillColor: theme.cardColor,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: BorderSide.none),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          ),
        ),
      ],
    );
  }
}
