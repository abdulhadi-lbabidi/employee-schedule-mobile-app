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
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.edit_note_rounded,
                      size: 28.sp,
                      color: theme.primaryColor,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: profileBloc,
                          child: const EditProfilePage(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                ],
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  children: [
                    _buildHeader(context, state.profile.data!, theme),
                    // SizedBox(height: 30.h),
                    // _buildStatsRow(state.profile, theme),
                    SizedBox(height: 25.h),
                    _buildRewardShortcut(
                      context,
                      state.profile.data!.user?.id ?? 0,
                      theme,
                    ),
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
                    SizedBox(height: 15.h),
                    _buildChangePasswordButton(context, theme),
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
          onFailed: () {
             // الرسالة تظهر تلقائياً من الـ DataStateModel
          }
        );
      },
    );
  }

  Widget _buildChangePasswordButton(BuildContext context, ThemeData theme) {
    return InkWell(
      onTap: () => showChangePasswordDialog(context, profileBloc),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: theme.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(color: theme.primaryColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.lock_reset_rounded, color: theme.primaryColor, size: 22.sp),
            SizedBox(width: 12.w),
            Text(
              "تغيير كلمة المرور",
              style: TextStyle(
                fontSize: 14.sp,
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios_rounded, color: theme.primaryColor, size: 14.sp),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 300.ms);
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
                  ? (profileImg.startsWith('http')
                      ? NetworkImage(profileImg)
                      : FileImage(File(profileImg)) as ImageProvider)
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
          "ID: ${user?.id ?? "---"}",
          style: TextStyle(
            color: theme.disabledColor,
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Widget _buildStatsRow(state, ThemeData theme) {
  //   return Row(
  //     children: [
  //       _buildStatCard("ساعات العمل", '8', Icons.access_time_filled, [
  //         const Color(0xFF1A237E),
  //         const Color(0xFF3949AB),
  //       ], theme),
  //       SizedBox(width: 12.w),
  //       _buildStatCard(
  //         "أيام الدوام",
  //         '6',
  //         Icons.calendar_today_rounded,
  //         [const Color(0xFF00695C), const Color(0xFF43A047)],
  //         theme,
  //       ),
  //       SizedBox(width: 12.w),
  //       _buildStatCard("آخر ورشة", 'أخر ورشة', Icons.warehouse_rounded, [
  //         const Color(0xFF4527A0),
  //         const Color(0xFF7B1FA2),
  //       ], theme),
  //     ],
  //   ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  // }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    List<Color> colors,
    ThemeData theme,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: colors.first.withOpacity(0.2),
              blurRadius: 8.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.8), size: 20.sp),
            SizedBox(height: 8.h),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
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
