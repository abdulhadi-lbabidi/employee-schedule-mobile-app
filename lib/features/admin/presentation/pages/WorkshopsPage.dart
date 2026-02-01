import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart'; // 🔹 إضافة الانميشن
import 'package:latlong2/latlong.dart' as latlong;
import '../bloc/workshops/workshops_bloc.dart';
import '../bloc/workshops/workshops_event.dart';
import '../bloc/workshops/workshops_state.dart';
import '../widgets/map_picker_widget.dart';
import 'WorkshopDetailsPage.dart';

class WorkshopsPage extends StatefulWidget {
  const WorkshopsPage({super.key});

  @override
  State<WorkshopsPage> createState() => _WorkshopsPageState();
}

class _WorkshopsPageState extends State<WorkshopsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text("إدارة الورشات", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: theme.primaryColor)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: theme.primaryColor),
            onPressed: () => context.read<WorkshopsBloc>().add(LoadWorkshopsEvent()),
          )
        ],
      ),
      body: BlocBuilder<WorkshopsBloc, WorkshopsState>(
        builder: (context, state) {
          if (state is WorkshopsLoading) return const Center(child: CircularProgressIndicator());

          if (state is WorkshopsLoaded) {
            final activeWorkshops = state.workshops.where((w) => !w.isArchived).toList();
            final archivedWorkshops = state.workshops.where((w) => w.isArchived).toList();

            return ListView(
              padding: EdgeInsets.all(16.w),
              physics: const BouncingScrollPhysics(),
              children: [
                if (activeWorkshops.isNotEmpty) ...[
                  _buildSectionTitle("الورشات النشطة", Icons.storefront_rounded, theme).animate().fadeIn(delay: 200.ms),
                  ...activeWorkshops.asMap().entries.map((entry) => 
                    _buildWorkshopCard(context, entry.value, false, theme)
                      .animate()
                      .fadeIn(delay: (300 + (entry.key * 150)).ms, duration: 600.ms)
                      .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1))
                  ),
                ],
                
                if (archivedWorkshops.isNotEmpty) ...[
                  SizedBox(height: 30.h),
                  _buildSectionTitle("الورشات المؤرشفة", Icons.archive_outlined, theme).animate().fadeIn(delay: 600.ms),
                  ...archivedWorkshops.asMap().entries.map((entry) => 
                    _buildWorkshopCard(context, entry.value, true, theme)
                      .animate()
                      .fadeIn(delay: (700 + (entry.key * 150)).ms, duration: 600.ms)
                      .slideX(begin: 0.05, end: 0)
                  ),
                ],
              ],
            );
          }
          return Center(child: Text("لا توجد بيانات حالياً", style: TextStyle(color: theme.disabledColor)));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWorkshopDialog(context, theme),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_rounded),
      ).animate().scale(delay: 1000.ms, curve: Curves.bounceOut),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: theme.primaryColor.withOpacity(0.7)),
          SizedBox(width: 8.w),
          Text(title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color)),
        ],
      ),
    );
  }

  Widget _buildWorkshopCard(BuildContext context, dynamic workshop, bool isArchived, ThemeData theme) {
    return Card(
      elevation: isArchived ? 0 : 1,
      margin: EdgeInsets.only(bottom: 12.h),
      color: isArchived ? theme.disabledColor.withOpacity(0.05) : theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: ListTile(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => WorkshopDetailsPage(workshop: workshop))),
        leading: CircleAvatar(
          radius: 22.r,
          backgroundColor: isArchived ? theme.disabledColor.withOpacity(0.2) : theme.primaryColor.withOpacity(0.1),
          child: Icon(Icons.home_work_rounded, color: isArchived ? theme.disabledColor : theme.primaryColor, size: 22.sp),
        ),
        title: Text(workshop.name, 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 15.sp,
            decoration: isArchived ? TextDecoration.lineThrough : null,
            color: isArchived ? theme.disabledColor : theme.textTheme.bodyLarge?.color,
          )),
        subtitle: Text("عدد العمال: ${workshop.employeeCount}", 
          style: TextStyle(color: theme.disabledColor, fontSize: 12.sp, fontWeight: FontWeight.bold)),
        trailing: IconButton(
          icon: Icon(isArchived ? Icons.unarchive_outlined : Icons.archive_outlined, 
              color: isArchived ? Colors.green : Colors.orange),
          onPressed: () => _showArchiveDialog(context, workshop.id, workshop.name, isArchived, theme),
        ),
      ),
    );
  }

  void _showAddWorkshopDialog(BuildContext context, ThemeData theme) {
    final nameController = TextEditingController();
    latlong.LatLng? selectedLocation;
    double selectedRadius = 200;
    final workshopsBloc = context.read<WorkshopsBloc>();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: theme.cardColor,
          title: Text("إضافة ورشة جديدة", style: TextStyle(color: theme.textTheme.titleLarge?.color)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                  decoration: const InputDecoration(labelText: "اسم الورشة", hintText: "مثلاً: ورشة النجارة"),
                ),
                SizedBox(height: 20.h),
                OutlinedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const MapPickerWidget()));
                    if (result != null && result is Map<String, dynamic>) {
                      setDialogState(() {
                        selectedLocation = result['location'];
                        selectedRadius = result['radius'];
                      });
                    }
                  },
                  icon: Icon(Icons.map, color: selectedLocation != null ? Colors.green : theme.primaryColor),
                  label: Text(
                    selectedLocation != null ? "تم تحديد الموقع" : "تحديد الموقع على الخريطة",
                    style: TextStyle(color: selectedLocation != null ? Colors.green : theme.primaryColor),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  workshopsBloc.add(AddWorkshopEvent(
                    name: nameController.text,
                    latitude: selectedLocation?.latitude,
                    longitude: selectedLocation?.longitude,
                    radius: selectedRadius,
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text("إضافة"),
            ),
          ],
        ),
      ),
    );
  }

  void _showArchiveDialog(BuildContext context, String workshopId, String name, bool isArchived, ThemeData theme) {
    final workshopsBloc = context.read<WorkshopsBloc>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.cardColor,
        title: Text(isArchived ? "إلغاء الأرشفة" : "تأكيد الأرشفة", style: TextStyle(color: theme.textTheme.titleLarge?.color)),
        content: Text("هل أنت متأكد من ${isArchived ? 'إلغاء أرشفة' : 'أرشفة'} ورشة $name؟", style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("إلغاء")),
          TextButton(
            onPressed: () {
              workshopsBloc.add(ToggleArchiveWorkshopEvent(workshopId, !isArchived));
              Navigator.pop(context);
            },
            child: Text(isArchived ? "إعادة تنشيط" : "أرشفة", 
                style: TextStyle(color: isArchived ? Colors.green : Colors.orange, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
