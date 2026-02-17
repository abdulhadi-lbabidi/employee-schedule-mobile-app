import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../admin/presentation/pages/EmployeeDetailsPage.dart';
import '../bloc/dues-report/dues_report_bloc.dart';
import '../bloc/dues-report/dues_report_event.dart';
import '../bloc/dues-report/dues_report_state.dart';

class FinancialDashboard extends StatefulWidget {
  const FinancialDashboard({super.key});

  @override
  State<FinancialDashboard> createState() => _FinancialDashboardState();
}

class _FinancialDashboardState extends State<FinancialDashboard> {
  @override
  void initState() {
    super.initState();
    // استدعاء التحميل من الـ Bloc الموجود مسبقاً في الـ main
    context.read<DuesReportBloc>().add(LoadDuesReport());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المستحقات المالية'),
        centerTitle: true,
      ),
      body: BlocBuilder<DuesReportBloc, DuesReportState>(
        builder: (context, state) {
          if (state is DuesReportLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DuesReportError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("خطأ: ${state.message}"),
                  ElevatedButton(
                    onPressed: () => context.read<DuesReportBloc>().add(LoadDuesReport()),
                    child: const Text("إعادة المحاولة"),
                  )
                ],
              ),
            );
          }

          if (state is DuesReportLoaded) {
            final report = state.report;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildStatisticsCard(
                    report.summary.totalEmployeesCount,
                    report.summary.grandTotalDebt,
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "قائمة الموظفين",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: report.data.employees.length,
                      itemBuilder: (context, index) {
                        final emp = report.data.employees[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(child: Text(emp.id.toString())),
                            title: Text(emp.fullName),
                            subtitle: Text("المستحقات: ${emp.totalEarned}\$"),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (_) => EmployeeDetailsPage(
                              //       employeeModel: emp,
                              //     ),
                              //   ),
                              // );
                            },
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildStatisticsCard(int employees, double salaries) {
    return Card(
      color: Colors.indigo,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _stat("الموظفين", employees.toString(), Icons.people),
            _stat("إجمالي الرواتب", "$salaries\$", Icons.monetization_on),
          ],
        ),
      ),
    );
  }

  Widget _stat(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        Text(title, style: const TextStyle(color: Colors.white70)),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
