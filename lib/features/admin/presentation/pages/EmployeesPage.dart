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
import '../widgets/employees_widget.dart';
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
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmployeesBloc>()
        ..add(GetAllEmployeeEvent())
        ..add(GetAllEmployeeArchivedEvent());
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Text(
          AppStrings.employeesTitle,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: theme.primaryColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSearchField(
              theme,
            ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.1, end: 0),
            BlocBuilder<EmployeesBloc, EmployeesState>(
              builder: (context, state) {
                return state.employeesData.builder(
                  onSuccess: (result) {
                    final data = result!.data!;
                    return data.isEmpty
                        ? Center(
                          child: Text(
                            AppStrings.noEmployeesFound,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: theme.disabledColor,
                            ),
                          ),
                        )
                        : ListView(
                          padding: EdgeInsets.all(16.w),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            if (data.isNotEmpty) ...[
                              _buildSectionTitle(
                                "الموظفون النشطون",
                                Icons.people_alt_rounded,
                                theme,
                              ).animate().fadeIn(delay: 400.ms),
                              ...data.asMap().entries.map(
                                (entry) => EmployeesWidget(
                                      theme: theme,
                                      emp: entry.value,
                                      isFromArchived: false,
                                    )
                                    .animate()
                                    .fadeIn(
                                      delay: (500 + (entry.key * 150)).ms,
                                      duration: 600.ms,
                                    ) // أبطأ
                                    .slideX(begin: 0.05, end: 0),
                              ),
                            ],
                          ],
                        );
                  },
                  failedWidget: Center(
                    child: Text(
                      state.employeesData.errorMessage,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                  loadingWidget: SizedBox(
                    height: 300.h,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              },
            ),
            BlocBuilder<EmployeesBloc, EmployeesState>(
              builder: (context, state) {
                return state.employeesArchivedData.builder(
                  onSuccess: (result) {
                    final data = result!.data!;
                    return data!.isEmpty
                        ? Center(
                          child: Text(
                            'لا يوجد موظفون مؤرشفون',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: theme.disabledColor,
                            ),
                          ),
                        )
                        : ListView(
                          padding: EdgeInsets.all(16.w),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            if (data.isNotEmpty) ...[
                              _buildSectionTitle(
                                "الموظفون المؤرشفون",
                                Icons.people_alt_rounded,
                                theme,
                              ).animate().fadeIn(delay: 400.ms),
                              ...data.asMap().entries.map(
                                (entry) => EmployeesWidget(
                                      theme: theme,
                                      emp: entry.value,
                                      isFromArchived: true,
                                    )
                                    .animate()
                                    .fadeIn(
                                      delay: (500 + (entry.key * 150)).ms,
                                      duration: 600.ms,
                                    ) // أبطأ
                                    .slideX(begin: 0.05, end: 0),
                              ),
                            ],
                          ],
                        );
                  },
                  failedWidget: Center(
                    child: Text(
                      state.employeesData.errorMessage,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                  loadingWidget: SizedBox(
                    height: 300.h,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder:
            (context) => FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddEmployeePage()),
                );
              },
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              icon: Icon(Icons.person_add_alt_1_rounded, size: 20.sp),
              label: Text(
                "إضافة موظف",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
            ).animate().scale(
              delay: 1200.ms,
              duration: 800.ms,
              curve: Curves.elasticOut,
            ), // هدوء أكثر
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

  Widget _buildSearchField(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          context.read<EmployeesBloc>().add(SearchEmployeesEvent(val));
        },
        style: TextStyle(
          fontSize: 14.sp,
          color: theme.textTheme.bodyLarge?.color,
        ),
        decoration: InputDecoration(
          hintText: AppStrings.searchHint,
          hintStyle: TextStyle(fontSize: 13.sp, color: theme.disabledColor),
          prefixIcon: Icon(
            Icons.search,
            size: 20.sp,
            color: theme.primaryColor,
          ),
          suffixIcon:
              _searchController.text.isNotEmpty
                  ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 18.sp,
                      color: theme.disabledColor,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      context.read<EmployeesBloc>().add(
                        SearchEmployeesEvent(""),
                      );
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
          contentPadding: EdgeInsets.symmetric(
            vertical: 10.h,
            horizontal: 15.w,
          ),
        ),
      ),
    );
  }
}
