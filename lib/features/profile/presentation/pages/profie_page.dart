import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled8/features/profile/presentation/pages/widgets/change_password_dialog.dart';
import 'package:untitled8/features/profile/presentation/pages/widgets/edit_profile_page.dart';
import 'package:untitled8/features/profile/presentation/pages/widgets/widget_foCard.dart';
import 'package:untitled8/features/SplashScreen/presentation/page/splashScareen.dart';
import 'package:untitled8/features/employee/presentation/pages/EmployeeRewardsPage.dart';
import 'package:untitled8/features/penalty/presentation/pages/employee_penalties_page.dart'; // 🔹 إضافة
import '../../../../core/di/injection.dart';
import '../../../auth/data/model/login_response.dart';
import '../bloc/Profile/_profile_bloc.dart';
import '../bloc/Profile/_profile_event.dart';
import '../bloc/Profile/_profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileBloc profileBloc;

  @override
  void initState() {
    profileBloc = sl<ProfileBloc>()..add(LoadProfile());
    super.initState();
  }

  @override
  void dispose() {
    profileBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: profileBloc,
      builder: (context, state) {
        return state.profile.builder(
          onSuccess: (_) {
            return Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              appBar: AppBar(
                backgroundColor: theme.scaffoldBackgroundColor,
                elevation: 0,
                title: Text(
                  "الملف الشخصي",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    _buildHeader(context, state.profile.data!, theme),
                    SizedBox(height: 25.h),
                    
                    // اختصار المكافآت
                    _buildRewardShortcut(context, state.profile.data!.user?.userableId?? 0, theme),
                    SizedBox(height: 12.h),
                    
                    // 🔹 اختصار العقوبات (جديد)
                    _buildPenaltyShortcut(context, state.profile.data?.user?.userableId ?? 0, theme),
                    
                    SizedBox(height: 35.h),
                    _buildSectionTitle("المعلومات الشخصية", theme),
                    SizedBox(height: 15.h),
                    WidgetFocard(
                      icon: Icons.phone_android_rounded,
                      label: 'رقم الهاتف',
                      value: state.profile.data!.user?.phoneNumber ?? "---",
                    ),
                    WidgetFocard(
                      icon: Icons.email_outlined,
                      label: 'البريد الإلكتروني',
                      value: state.profile.data!.user?.email ?? "---",
                    ),
                    SizedBox(height: 25.h),
                    _buildSectionTitle("تفاصيل العمل", theme),
                    SizedBox(height: 15.h),
                    WidgetFocard(
                      icon: Icons.business_center_outlined,
                      label: 'المسمى الوظيفي',
                      value: state.profile.data!.role ?? "Employee",
                    ),
                    WidgetFocard(
                      icon: Icons.lan_outlined,
                      label: "القسم",
                      value: state.profile.data!.user?.userable?.department ?? "عام",
                    ),
                    SizedBox(height: 40.h),
                    _buildLogoutButton(context, theme, profileBloc),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            );
          },
          loadingWidget: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: const Center(child: CircularProgressIndicator()),
          ),
          failedWidget: Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: Center(
              child: Text(
                "فشل تحميل البيانات",
                style: TextStyle(fontSize: 14.sp, color: theme.disabledColor),
              ),
            ),
          ),
        );
      },
      listenWhen: (pre, cur) => pre.logOutData.status != cur.logOutData.status || pre.updateProfile.status != cur.updateProfile.status,
      listener: (context, state) {
        state.logOutData.listenerFunction(
          onSuccess: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const Splashscareen()),
              (route) => false,
            );
          },
        );
        state.updateProfile.listenerFunction(
          onSuccess: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم تحديث البيانات بنجاح'), backgroundColor: Colors.green),
            );
          },
        );
      },
    );
  }

  Widget _buildPenaltyShortcut(BuildContext context, int employeeId, ThemeData theme) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => EmployeePenaltiesPage(employeeId: employeeId)),
      ),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.red.shade700, Colors.deepOrange.shade900]),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.2), blurRadius: 10.r, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Icon(Icons.gavel_rounded, color: Colors.white, size: 28.sp),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("سجل خصم", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp)),
                  Text("عرض جميع المخالفات خصم المالية", style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11.sp, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16.sp),
          ],
        ),
      ),
    ).animate().scale(delay: 300.ms);
  }

  Widget _buildRewardShortcut(
    BuildContext context,
    int employeeId,
    ThemeData theme,
  ) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EmployeeRewardsPage(employeeId: employeeId),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.amber.shade600, Colors.orange.shade900],
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.2),
              blurRadius: 10.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.stars_rounded, color: Colors.white, size: 28.sp),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "سجل مكافآتي",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    "عرض جميع المكافآت التي حصلت عليها",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 16.sp,
            ),
          ],
        ),
      ),
    ).animate().scale(delay: 200.ms);
  }

  Widget _buildHeader(
    BuildContext context,
    LoginResponse profile,
    ThemeData theme,
  ) {
    final user = profile.user;
    final String? profileImg = user?.profileImageUrl;

    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 65.r,
              backgroundColor: theme.primaryColor.withOpacity(0.1),
              backgroundImage: (profileImg != null && profileImg.isNotEmpty)
                  ? NetworkImage(profileImg)
                  : null,
              child: (profileImg == null || profileImg.isEmpty)
                  ? Icon(
                      Icons.person,
                      size: 60.sp,
                      color: theme.primaryColor,
                    )
                  : null,
            ),
            CircleAvatar(
              backgroundColor: theme.primaryColor,
              radius: 18.r,
              child: IconButton(
                icon: Icon(Icons.camera_alt, size: 16.sp, color: Colors.white),
                onPressed: () async {
                  final picked = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (picked != null) {
                    final file = File(picked.path);
                    profileBloc.add(
                      UpdateProfileImage(file),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          user?.fullName ?? "اسم المستخدم",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        Text(
          "ID: ${user?.userableId ?? "---"}",
          style: TextStyle(
            color: theme.disabledColor,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(
    BuildContext context,
    ThemeData theme,
    ProfileBloc profileBloc,
  ) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          side: const BorderSide(color: Colors.redAccent, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        onPressed: () => _showLogoutDialog(context, theme, profileBloc),
        icon: Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20.sp),
        label: Text(
          "تسجيل الخروج من النظام",
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.w900,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(
    BuildContext context,
    ThemeData theme,
    ProfileBloc profileBloc,
  ) {
    showDialog(
      context: context,
      builder: (d) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        title: Text(
          "تأكيد الخروج",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.error,
          ),
        ),
        content: Text(
          "هل تريد حقاً تسجيل الخروج من حسابك؟",
          style: TextStyle(
            fontSize: 14.sp,
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: () {
              Navigator.pop(d);
              profileBloc.add(LogOutEvent());
            },
            child: Text(
              "خروج",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          color: theme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
