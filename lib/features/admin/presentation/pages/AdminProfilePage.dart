import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart'; // 🔹 إضافة مكتبة الانميشن
import '../../../../core/di/service_locator.dart';
import '../bloc/admin_profile/admin_profile_bloc.dart';
import 'package:untitled8/features/auth/presentation/bloc/login_Cubit/login_cubit.dart';
import 'package:untitled8/features/SplashScreen/presentation/page/splashScareen.dart';
import 'AdminAuditLogPage.dart'; 
import 'AdminRewardsPage.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => sl<AdminProfileBloc>()..add(LoadAdminProfileEvent()),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor, 
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          title: Text("إدارة الحساب", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: theme.primaryColor)),
          centerTitle: true,
        ),
        body: BlocBuilder<AdminProfileBloc, AdminProfileState>(
          builder: (context, state) {
            if (state is AdminProfileLoading) {
              return Center(child: CircularProgressIndicator(color: theme.primaryColor));
            }

            if (state is AdminProfileLoaded) {
              final profile = state.profile;
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.all(24.w),
                child: Column(
                  children: [
                    _buildIdentityHeader(profile, theme)
                        .animate()
                        .fadeIn(duration: 800.ms)
                        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), curve: Curves.easeOutBack),
                    
                    SizedBox(height: 30.h),
                    
                    _buildActionCard(
                      context,
                      title: "نظام المكافآت",
                      subtitle: "إدارة وصرف المكافآت المالية للموظفين",
                      icon: Icons.card_giftcard_rounded,
                      color: Colors.amber.shade800,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminRewardsPage())),
                      theme: theme,
                    ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideY(begin: 0.1, end: 0),
                    
                    SizedBox(height: 16.h),
                    
                    _buildActionCard(
                      context,
                      title: "سجل النشاطات الرقابي",
                      subtitle: "مراقبة كافة حركات المدير المالية والإدارية",
                      icon: Icons.security_rounded,
                      color: Colors.blue.shade700,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAuditLogPage())),
                      theme: theme,
                    ).animate().fadeIn(delay: 550.ms, duration: 600.ms).slideY(begin: 0.1, end: 0),
                    
                    SizedBox(height: 20.h),
                    _buildInfoSection(profile, theme)
                        .animate()
                        .fadeIn(delay: 700.ms, duration: 800.ms),
                    
                    SizedBox(height: 40.h),
                    _buildLogoutButton(context, theme)
                        .animate()
                        .fadeIn(delay: 900.ms, duration: 600.ms),
                  ],
                ),
              );
            }
            return Center(child: Text("فشل تحميل البيانات", style: TextStyle(fontSize: 14.sp, color: theme.disabledColor)));
          },
        ),
      ),
    );
  }

  Widget _buildIdentityHeader(dynamic profile, ThemeData theme) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20.r,
                offset: Offset(0, 10.h),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 60.r,
            backgroundColor: Colors.black, 
            child: ClipOval(
              child: Image.asset(
                'assets/image/log/logo.png',
                width: 100.r,
                height: 100.r,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Text(profile.fullName, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: theme.textTheme.bodyLarge?.color)),
        Text(profile.position, style: TextStyle(fontSize: 15.sp, color: theme.disabledColor, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap, required ThemeData theme}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10.r, offset: Offset(0, 4.h))],
          border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 22.r, backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color, size: 22.sp)),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp, color: theme.textTheme.bodyLarge?.color)),
                  Text(subtitle, style: TextStyle(color: theme.disabledColor, fontSize: 11.sp, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: theme.disabledColor),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(dynamic profile, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: theme.cardColor, 
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _infoRow(Icons.email_outlined, "البريد الإلكتروني", profile.email, theme),
          Divider(height: 30.h, color: theme.dividerColor.withOpacity(0.1)),
          _infoRow(Icons.phone_android_outlined, "رقم الهاتف", profile.phoneNumber, theme),
          Divider(height: 30.h, color: theme.dividerColor.withOpacity(0.1)),
          _infoRow(Icons.lan_outlined, "القسم الوظيفي", profile.department, theme),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, color: theme.primaryColor, size: 22.sp),
        SizedBox(width: 15.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: theme.disabledColor, fontSize: 11.sp, fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: theme.textTheme.bodyLarge?.color)),
          ],
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          side: const BorderSide(color: Colors.redAccent, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        ),
        onPressed: () => _showLogoutDialog(context, theme),
        icon: Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20.sp),
        label: Text("خروج آمن من النظام", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w900, fontSize: 14.sp)),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, ThemeData theme) {
    showDialog(
      context: context,
      builder: (d) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        title: Text("تسجيل الخروج", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: theme.textTheme.titleLarge?.color)),
        content: Text("هل تريد الخروج من لوحة تحكم الإدارة؟", style: TextStyle(fontSize: 14.sp, color: theme.textTheme.bodyMedium?.color)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d), child: Text("إلغاء", style: TextStyle(fontSize: 13.sp))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))), 
            onPressed: () {
              Navigator.pop(d);
              context.read<LoginCubit>().logout();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const Splashscareen()), (route) => false);
            }, 
            child: Text("تأكيد", style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
