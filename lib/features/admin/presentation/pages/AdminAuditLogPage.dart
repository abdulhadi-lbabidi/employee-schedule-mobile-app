import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart'; // 🔹 إضافة الانميشن
import '../../../../core/di/service_locator.dart';
import '../../data/models/audit_log_model.dart';
import '../../data/repositories/audit_log_repository.dart';


class AdminAuditLogPage extends StatefulWidget {
  const AdminAuditLogPage({super.key});

  @override
  State<AdminAuditLogPage> createState() => _AdminAuditLogPageState();
}

class _AdminAuditLogPageState extends State<AdminAuditLogPage> {
  late List<AuditLogModel> logs;
  final AuditLogRepository _repository = sl<AuditLogRepository>();

  @override
  void initState() {
    super.initState();
    _refreshLogs();
  }

  void _refreshLogs() {
    setState(() {
      logs = _repository.getLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text("سجل النشاطات الرقابي", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp, color: theme.primaryColor)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep_outlined, color: Colors.redAccent, size: 24.sp),
            onPressed: () => _confirmClearLogs(theme),
            tooltip: "مسح السجل",
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: logs.isEmpty
          ? _buildEmptyState(theme).animate().fadeIn(duration: 600.ms)
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(16.w),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                return _buildLogItem(logs[index], index == logs.length - 1, theme)
                    .animate()
                    .fadeIn(delay: (200 + (index * 100)).ms, duration: 600.ms) // ظهور متتابع أبطأ
                    .slideX(begin: 0.05, end: 0, curve: Curves.easeOutQuad);
              },
            ),
    );
  }

  Widget _buildLogItem(AuditLogModel log, bool isLast, ThemeData theme) {
    final timeStr = DateFormat('hh:mm a').format(log.timestamp);
    final dateStr = DateFormat('yyyy/MM/dd').format(log.timestamp);
    final actionColor = _getActionColor(log.actionType);

    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: actionColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.cardColor, width: 2.w),
                  boxShadow: [BoxShadow(color: actionColor.withOpacity(0.3), blurRadius: 4)],
                ),
              ).animate().scale(delay: 400.ms, duration: 400.ms), // انميشن للنقطة
              if (!isLast)
                Expanded(
                  child: Container(width: 2.w, color: theme.dividerColor.withOpacity(0.2)),
                ),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 20.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10.r, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(log.actionType, style: TextStyle(fontWeight: FontWeight.w900, color: actionColor, fontSize: 13.sp)),
                      Text(timeStr, style: TextStyle(fontSize: 10.sp, color: theme.disabledColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "${log.adminName} قام بـ ${log.actionType} لـ ${log.targetName}",
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
                  ),
                  SizedBox(height: 6.h),
                  Text(log.details, style: TextStyle(fontSize: 12.sp, color: theme.textTheme.bodyMedium?.color, fontWeight: FontWeight.w500)),
                  SizedBox(height: 12.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(dateStr, style: TextStyle(fontSize: 10.sp, color: theme.disabledColor, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getActionColor(String type) {
    if (type.contains("دفع") || type.contains("صرف")) return Colors.green.shade600;
    if (type.contains("حذف")) return Colors.red.shade600;
    if (type.contains("تعديل")) return Colors.blue.shade600;
    return Colors.orange.shade700;
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_turned_in_outlined, size: 70.sp, color: theme.dividerColor.withOpacity(0.2)),
          SizedBox(height: 16.h),
          Text("السجل فارغ حالياً", style: TextStyle(color: theme.disabledColor, fontSize: 15.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _confirmClearLogs(ThemeData theme) {
    showDialog(
      context: context,
      builder: (d) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        title: Text("تنبيه أمني", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: theme.colorScheme.error)),
        content: Text("هل أنت متأكد من رغبتك في مسح سجل النشاطات بالكامل؟", style: TextStyle(fontSize: 14.sp, color: theme.textTheme.bodyMedium?.color)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d), child: Text("إلغاء", style: TextStyle(fontSize: 13.sp))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
            onPressed: () async {
              await _repository.clearLogs();
              if (mounted) {
                Navigator.pop(d);
                _refreshLogs();
              }
            },
            child: Text("مسح السجل", style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
