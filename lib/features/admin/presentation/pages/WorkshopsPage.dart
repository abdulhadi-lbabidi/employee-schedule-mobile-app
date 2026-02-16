import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart'; // 🔹 إضافة الانميشن
import 'package:latlong2/latlong.dart' as latlong;
import 'package:untitled8/features/admin/data/models/workshop_models/workshop_model.g.dart';
import 'package:untitled8/features/admin/domain/usecases/add_workshop.dart';
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
  void initState() {
    context.read<WorkshopsBloc>()
      ..add(GetAllWorkShopEvent())
      ..add(GetAllArchivedWorkShopEvent());

    // TODO: implement initState
    super.initState();
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
          "إدارة الورشات",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: theme.primaryColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: theme.primaryColor),
            onPressed:
                () => context.read<WorkshopsBloc>().add(GetAllWorkShopEvent()),
          ),
        ],
      ),
      body: BlocConsumer<WorkshopsBloc, WorkshopsState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              state.getAllWorkshopData.builder(
                onSuccess: (_) {
                  final activeWorkshops = state.getAllWorkshopData.data!.data!;

                  return ListView(
                    padding: EdgeInsets.all(16.w),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      if (activeWorkshops.isNotEmpty) ...[
                        _buildSectionTitle(
                          "الورشات النشطة",
                          Icons.storefront_rounded,
                          theme,
                        ).animate().fadeIn(delay: 200.ms),
                        ...activeWorkshops.asMap().entries.map(
                          (entry) => _buildWorkshopCard(
                                context,
                                entry.value,
                                false,
                                theme,
                              )
                              .animate()
                              .fadeIn(
                                delay: (300 + (entry.key * 150)).ms,
                                duration: 600.ms,
                              )
                              .scale(
                                begin: const Offset(0.95, 0.95),
                                end: const Offset(1, 1),
                              ),
                        ),
                      ],
                    ],
                  );
                },
                loadingWidget: Expanded(
                  child: Center(child: CircularProgressIndicator()),
                ),
                failedWidget: Center(
                  child: Text(
                    state.getAllWorkshopData.errorMessage,
                    style: TextStyle(color: theme.disabledColor),
                  ),
                ),
              ),
              state.getAllArchivedWorkshopData.builder(
                onSuccess: (_) {
                  final archivedWorkShops =
                      state.getAllArchivedWorkshopData.data!.data!;

                  return ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.all(16.w),
                    children: [
                      if (archivedWorkShops.isNotEmpty) ...[
                        _buildSectionTitle(
                          "الورشات المؤرشفة",
                          Icons.storefront_rounded,
                          theme,
                        ).animate().fadeIn(delay: 200.ms),
                        ...archivedWorkShops.asMap().entries.map(
                          (entry) => _buildWorkshopCard(
                                context,
                                entry.value,
                                true,
                                theme,
                              )
                              .animate()
                              .fadeIn(
                                delay: (300 + (entry.key * 150)).ms,
                                duration: 600.ms,
                              )
                              .scale(
                                begin: const Offset(0.95, 0.95),
                                end: const Offset(1, 1),
                              ),
                        ),
                      ],
                    ],
                  );
                },
                loadingWidget: Expanded(
                  child: Center(child: CircularProgressIndicator()),
                ),
                failedWidget: Center(
                  child: Text(
                    state.getAllArchivedWorkshopData.errorMessage,
                    style: TextStyle(color: theme.disabledColor),
                  ),
                ),
              ),
            ],
          );
        },
        listener: (context, state) {
          state.addWorkshopData.listenerFunction(
            onSuccess: () {
              context.read<WorkshopsBloc>().add(GetAllWorkShopEvent());
            },
          );

          state.restoreArchiveData.listenerFunction(
            onSuccess: () {
            },
          );
          state.toggleWorkshopArchiveData.listenerFunction(
            onSuccess: () {
            },
          );
        },
        listenWhen:
            (pre, cur) =>
                (pre.addWorkshopData.status != cur.addWorkshopData.status) ||
                (pre.restoreArchiveData.status !=
                    cur.restoreArchiveData.status) ||
                (pre.toggleWorkshopArchiveData.status !=
                    cur.toggleWorkshopArchiveData.status),
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
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkshopCard(
    BuildContext context,
    WorkshopModel workshop,
    bool isArchived,
    ThemeData theme,
  ) {
    return Card(
      elevation: isArchived ? 0 : 1,
      margin: EdgeInsets.only(bottom: 12.h),
      color:
          isArchived ? theme.disabledColor.withOpacity(0.05) : theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.1)),
      ),
      child: ListTile(
        onTap:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WorkshopDetailsPage(workshop: workshop),
              ),
            ),
        leading: CircleAvatar(
          radius: 22.r,
          backgroundColor:
              isArchived
                  ? theme.disabledColor.withOpacity(0.2)
                  : theme.primaryColor.withOpacity(0.1),
          child: Icon(
            Icons.home_work_rounded,
            color: isArchived ? theme.disabledColor : theme.primaryColor,
            size: 22.sp,
          ),
        ),
        title: Text(
          workshop.name!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.sp,
            decoration: isArchived ? TextDecoration.lineThrough : null,
            color:
                isArchived
                    ? theme.disabledColor
                    : theme.textTheme.bodyLarge?.color,
          ),
        ),
        subtitle: Text(
          "الموقع: ${workshop.location ?? "لايوجد وصف"}",
          style: TextStyle(
            color: theme.disabledColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            isArchived ? Icons.unarchive_outlined : Icons.archive_outlined,
            color: isArchived ? Colors.green : Colors.orange,
          ),
          onPressed:
              () => _showArchiveDialog(
                context,
                workshop.id!.toString(),
                workshop.name!,
                isArchived,
                theme,
              ),
        ),
      ),
    );
  }

  void _showAddWorkshopDialog(BuildContext context, ThemeData theme) {
    final nameController = TextEditingController();
    final cityController = TextEditingController();
    final descriptionController = TextEditingController();
    latlong.LatLng? selectedLocation;
    double selectedRadius = 200;
    final workshopsBloc = context.read<WorkshopsBloc>();

    showDialog(
      context: context,
      builder: (context) {
        final GlobalKey<FormState> formKey = GlobalKey<FormState>();

        return StatefulBuilder(
          builder:
              (context, setDialogState) => AlertDialog(
                backgroundColor: theme.cardColor,
                title: Text(
                  "إضافة ورشة جديدة",
                  style: TextStyle(color: theme.textTheme.titleLarge?.color),
                ),
                content: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: nameController,
                          style: TextStyle(
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                          validator: (text) {
                            if (text == null || text.trim().length < 2) {
                              return 'الاسم غير صالح';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "اسم الورشة",
                            hintText: "مثلاً: ورشة النجارة",
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: cityController,
                          style: TextStyle(
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                          validator: (text) {
                            if (text == null || text.trim().length < 2) {
                              return 'الاسم غير صالح';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "اسم المدينة",
                            hintText: "مثلاً: مدينة حلب",
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: descriptionController,
                          style: TextStyle(
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                          validator: (text) {
                            if (text == null || text.trim().length < 2) {
                              return 'الاسم غير صالح';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "الوصف",
                            hintText: "مثلاً: شقة منزلية",
                          ),
                        ),
                        SizedBox(height: 20),

                        /// زر اختيار الموقع
                        OutlinedButton.icon(
                          onPressed: () async {
                            final result =
                                await Navigator.push<MapPickerResult>(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => MapPickerWidget(
                                          initialLocation: selectedLocation,
                                          initialRadius: selectedRadius,
                                        ),
                                  ),
                                );

                            if (result != null) {
                              setDialogState(() {
                                selectedLocation = result.location;
                                selectedRadius = result.radius;
                              });
                            }
                          },
                          icon: Icon(
                            Icons.map,
                            color:
                                selectedLocation != null
                                    ? Colors.green
                                    : theme.primaryColor,
                          ),
                          label: Text(
                            selectedLocation != null
                                ? "تم تحديد الموقع"
                                : "تحديد الموقع على الخريطة",
                            style: TextStyle(
                              color:
                                  selectedLocation != null
                                      ? Colors.green
                                      : theme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("إلغاء"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (!(formKey.currentState?.validate() ?? false)) return;

                      if (selectedLocation == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("يرجى تحديد موقع الورشة"),
                          ),
                        );
                        return;
                      }

                      workshopsBloc.add(
                        AddWorkshopEvent(
                          params: AddWorkshopParams(
                            name: nameController.text.trim(),
                            latitude: selectedLocation!.latitude,
                            longitude: selectedLocation!.longitude,
                            radius: selectedRadius,
                            city: cityController.text,
                            description: descriptionController.text,
                          ),
                        ),
                      );

                      Navigator.pop(context);
                    },
                    child: const Text("إضافة"),
                  ),
                ],
              ),
        );
      },
    );
  }

  void _showArchiveDialog(
    BuildContext context,
    String workshopId,
    String name,
    bool isArchived,
    ThemeData theme,
  ) {
    final workshopsBloc = context.read<WorkshopsBloc>();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: theme.cardColor,
            title: Text(
              isArchived ? "إلغاء الأرشفة" : "تأكيد الأرشفة",
              style: TextStyle(color: theme.textTheme.titleLarge?.color),
            ),
            content: Text(
              "هل أنت متأكد من ${isArchived ? 'إلغاء أرشفة' : 'أرشفة'} ورشة $name؟",
              style: TextStyle(color: theme.textTheme.bodyMedium?.color),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("إلغاء"),
              ),
              TextButton(
                onPressed: () {
                  isArchived
                      ? workshopsBloc.add(
                        RestoreArchiveWorkshopEvent(id: workshopId),
                      )
                      : workshopsBloc.add(
                        ToggleArchiveWorkshopEvent(id: workshopId),
                      );
                  Navigator.pop(context);
                },
                child: Text(
                  isArchived ? "إعادة تنشيط" : "أرشفة",
                  style: TextStyle(
                    color: isArchived ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
