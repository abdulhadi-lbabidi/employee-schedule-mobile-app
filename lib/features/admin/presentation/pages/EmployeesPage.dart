import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:untitled8/features/admin/data/models/employee%20model/employee_model.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_strings.dart';
import '../bloc/employees/employees_bloc.dart';
import '../bloc/employees/employees_event.dart';
import '../bloc/employees/employees_state.dart';
import 'AddEmployeePage.dart'; 
import 'EmployeeDetailsPage.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocProvider(
      create: (_) => sl<EmployeesBloc>()..add(LoadEmployeesEvent()),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          title: Text(AppStrings.employeesTitle,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp, color: theme.primaryColor)),
          centerTitle: true,
          elevation: 0,
        ),
        body: Column(
          children: [
            _buildSearchField(theme).animate().fadeIn(duration: 600.ms).slideY(begin: -0.1, end: 0),
            Expanded(
              child: BlocBuilder<EmployeesBloc, EmployeesState>(
                builder: (context, state) {
                  if (state is EmployeesLoading) return const Center(child: CircularProgressIndicator());
                  if (state is EmployeesEmpty) return Center(child: Text(AppStrings.noEmployeesFound, style: TextStyle(fontSize: 14.sp, color: theme.disabledColor)));
                  if (state is EmployeesError) return Center(child: Text(state.message, style: TextStyle(fontSize: 14.sp, color: theme.colorScheme.error)));

                  if (state is EmployeesLoaded) {

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<EmployeesBloc>().add(LoadEmployeesEvent());
                      },
                      child: ListView(
                        padding: EdgeInsets.all(16.w),
                        physics: const BouncingScrollPhysics(),
                        children: [
                          if (state.employees.isNotEmpty) ...[
                            _buildSectionTitle("الموظفون النشطون", Icons.people_alt_rounded, theme).animate().fadeIn(delay: 400.ms),
                            ...state.employees.asMap().entries.map((entry) =>
                              _buildEmployeeCard(context, entry.value, theme,false)
                                .animate()
                                .fadeIn(delay: (500 + (entry.key * 150)).ms, duration: 600.ms) // أبطأ
                                .slideX(begin: 0.05, end: 0)
                            ),
                          ],
                          // if (archivedEmployees.isNotEmpty) ...[
                          //   SizedBox(height: 24.h),
                          //   _buildSectionTitle("الموظفون المؤرشفون", Icons.archive_outlined, theme).animate().fadeIn(delay: 800.ms),
                          //   ...archivedEmployees.asMap().entries.map((entry) =>
                          //     _buildEmployeeCard(context, entry.value, theme)
                          //       .animate()
                          //       .fadeIn(delay: (900 + (entry.key * 150)).ms, duration: 600.ms) // أبطأ
                          //       .slideX(begin: 0.05, end: 0)
                          //   ),
                          // ],
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEmployeePage()));
            },
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            icon: Icon(Icons.person_add_alt_1_rounded, size: 20.sp),
            label: Text("إضافة موظف", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
          ).animate().scale(delay: 1200.ms, duration: 800.ms, curve: Curves.elasticOut), // هدوء أكثر
        ),
      ),
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

  Widget _buildSearchField(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          context.read<EmployeesBloc>().add(SearchEmployeesEvent(val));
        },
        style: TextStyle(fontSize: 14.sp, color: theme.textTheme.bodyLarge?.color),
        decoration: InputDecoration(
          hintText: AppStrings.searchHint,
          hintStyle: TextStyle(fontSize: 13.sp, color: theme.disabledColor),
          prefixIcon: Icon(Icons.search, size: 20.sp, color: theme.primaryColor),
          suffixIcon: _searchController.text.isNotEmpty 
            ? IconButton(
                icon: Icon(Icons.clear, size: 18.sp, color: theme.disabledColor),
                onPressed: () {
                  _searchController.clear();
                  context.read<EmployeesBloc>().add(SearchEmployeesEvent(""));
                },
              )
            : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(color: theme.dividerColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: BorderSide(color: theme.dividerColor.withOpacity(0.2)),
          ),
          filled: true,
          fillColor: theme.cardColor,
          contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(BuildContext context, EmployeeModel emp, ThemeData theme,bool isFromArchived) {
    final bool isArchived = isFromArchived;
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: isArchived ? 0 : 1,
      color: isArchived ? theme.disabledColor.withOpacity(0.05) : theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: theme.dividerColor.withOpacity(isArchived ? 0.1 : 0.05)),
      ),
      child: ListTile(
        onTap: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => EmployeeDetailsPage(employeeId: emp.id.toString())));
          if (context.mounted) {
            context.read<EmployeesBloc>().add(LoadEmployeesEvent());
          }
        },
        leading: CircleAvatar(
          radius: 22.r,
          backgroundColor: theme.primaryColor.withOpacity(0.1), 
          child: emp.user?.profileImageUrl!=null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(22.r),
                child: Image.network(emp.user!.profileImageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.person, color: theme.primaryColor)))
            : Icon(Icons.person, color: theme.primaryColor, size: 24.sp)
        ),

        title: Text(emp.user!.fullName!,
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 14.sp,
            decoration: isArchived ? TextDecoration.lineThrough : null,
            color: isArchived ? theme.disabledColor : theme.textTheme.bodyLarge?.color,
          )),
        subtitle: Row(
          children: [
            Icon(Icons.location_on_outlined, size: 12.sp, color: theme.disabledColor),
            SizedBox(width: 4.w),
           // Text(emp.workshopName, style: TextStyle(color: theme.disabledColor, fontSize: 12.sp)),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: theme.disabledColor.withOpacity(0.5)),
      ),
    );

  }

//  Widget _buildEmployeeCard(BuildContext context, dynamic emp, ThemeData theme) {
//     final bool isArchived = emp.isArchived;
//     return Card(
//       margin: EdgeInsets.only(bottom: 12.h),
//       elevation: isArchived ? 0 : 1,
//       color: isArchived ? theme.disabledColor.withOpacity(0.05) : theme.cardColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16.r),
//         side: BorderSide(color: theme.dividerColor.withOpacity(isArchived ? 0.1 : 0.05)),
//       ),
//       child: ListTile(
//         onTap: () async {
//           await Navigator.push(context, MaterialPageRoute(builder: (_) => EmployeeDetailsPage(employeeId: emp.id)));
//           if (context.mounted) {
//             context.read<EmployeesBloc>().add(LoadEmployeesEvent());
//           }
//         },
//         leading: CircleAvatar(
//           radius: 22.r,
//           backgroundColor: theme.primaryColor.withOpacity(0.1),
//           child: emp.imageUrl.isNotEmpty
//             ? ClipRRect(
//                 borderRadius: BorderRadius.circular(22.r),
//                 child: Image.network(emp.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.person, color: theme.primaryColor)))
//             : Icon(Icons.person, color: theme.primaryColor, size: 24.sp)
//         ),
//
//         title: Text(emp.name,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 14.sp,
//             decoration: isArchived ? TextDecoration.lineThrough : null,
//             color: isArchived ? theme.disabledColor : theme.textTheme.bodyLarge?.color,
//           )),
//         subtitle: Row(
//           children: [
//             Icon(Icons.location_on_outlined, size: 12.sp, color: theme.disabledColor),
//             SizedBox(width: 4.w),
//             Text(emp.workshopName, style: TextStyle(color: theme.disabledColor, fontSize: 12.sp)),
//           ],
//         ),
//         trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: theme.disabledColor.withOpacity(0.5)),
//       ),
//     );
//
//   }
}
