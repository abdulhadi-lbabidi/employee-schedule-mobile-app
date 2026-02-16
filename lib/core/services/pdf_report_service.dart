import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../features/admin/data/models/employee model/employee_model.dart';
import '../../features/Attendance/data/models/attendance_record.dart';

class PdfReportService {
  // 🔹 قالب 1: كشف المستحقات المالية
  static Future<void> generateFinanceReport({
    required List<EmployeeModel> employees,
    required double totalDue,
  })
  async {
    try {
      final pdf = pw.Document();
      final fontRegular = await PdfGoogleFonts.cairoRegular();
      final fontBold = await PdfGoogleFonts.cairoBold();

      pdf.addPage(pw.MultiPage(
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: fontRegular, bold: fontBold),
        build: (context) => [
          _buildHeader("كشف المستحقات المالية الأسبوعي"),
          pw.SizedBox(height: 20),
          _buildSummary(totalDue, fontBold),
          pw.SizedBox(height: 20),
          // _buildFinanceTable(employees, fontBold),
          pw.SizedBox(height: 40),
          _buildFooter(),
        ],
      ));

      await Printing.layoutPdf(onLayout: (format) async => pdf.save(), name: 'Finance_Report.pdf');
    } catch (e) { debugPrint("❌ PDF Error: $e"); }
  }

  // 🔹 قالب 2: كشف حضور وانصراف (الميزة الجديدة)
  static Future<void> generateAttendanceReport({
    required String workshopName,
    required List<AttendanceRecord> records,
    required List<EmployeeModel> allEmployees,
  })
  async {
    try {
      final pdf = pw.Document();
      final fontRegular = await PdfGoogleFonts.cairoRegular();
      final fontBold = await PdfGoogleFonts.cairoBold();

      pdf.addPage(pw.MultiPage(
        textDirection: pw.TextDirection.rtl,
        theme: pw.ThemeData.withFont(base: fontRegular, bold: fontBold),
        build: (context) => [
          _buildHeader("سجل حضور وانصراف - $workshopName"),
          pw.SizedBox(height: 20),
          _buildAttendanceTable(records, allEmployees, fontBold),
          pw.SizedBox(height: 40),
          _buildFooter(),
        ],
      ));

      await Printing.layoutPdf(onLayout: (format) async => pdf.save(), name: 'Attendance_$workshopName.pdf');
    } catch (e) { debugPrint("❌ PDF Error: $e"); }
  }

  static pw.Widget _buildHeader(String title) {
    return pw.Column(children: [
      pw.Text("وكالة نوح- Nouh Agency", style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
      pw.Divider(thickness: 1),
      pw.Text(title, style: pw.TextStyle(fontSize: 16)),
      pw.Align(alignment: pw.Alignment.centerLeft, child: pw.Text("تاريخ الاستخراج:${DateTime.now().toString().split(' ')[0]}", style: const pw.TextStyle(fontSize: 10))),
    ]);
  }

  static pw.Widget _buildSummary(double total, pw.Font boldFont) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: const pw.BoxDecoration(color: PdfColors.grey100),
      child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
        pw.Text("إجمالي المستحقات:", style: pw.TextStyle(font: boldFont, fontWeight: pw.FontWeight.bold)),
        pw.Text("${total.toStringAsFixed(0)} ل.س", style: pw.TextStyle(font: boldFont, color: PdfColors.green800, fontWeight: pw.FontWeight.bold)),
      ]),
    );
  }

  // static pw.Widget _buildFinanceTable(List<EmployeeModel> employees, pw.Font boldFont) {
  //   final list = employees.where((e) => e.weeklyHistory.any((w) => !w.isPaid)).toList();
  //   return pw.TableHelper.fromTextArray(
  //     headers: ['الموظف', 'الساعات', 'المبلغ', 'الورشة'],
  //     headerStyle: pw.TextStyle(font: boldFont, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
  //     headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey900),
  //     cellAlignment: pw.Alignment.center,
  //     data: list.map((e) {
  //       double due = 0; double hrs = 0;
  //       for (var w in e.weeklyHistory) { if (!w.isPaid) { for (var ws in w.workshops) { due += ws.calculateValue(e.hourlyRate, e.overtimeRate); hrs += (ws.regularHours + ws.overtimeHours); } } }
  //       return [e.name, hrs.toStringAsFixed(1), "${due.toStringAsFixed(0)} ل.س", e.workshopName];
  //     }).toList(),
  //   );
  // }

  // 🔹 جدول حضور خاص بالورشات
  static pw.Widget _buildAttendanceTable(List<AttendanceRecord> records, List<EmployeeModel> employees, pw.Font boldFont) {
    return pw.TableHelper.fromTextArray(
      headers: ['العامل', 'التاريخ', 'دخول', 'خروج', 'الساعات'],
      headerStyle: pw.TextStyle(font: boldFont, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo900),
      cellAlignment: pw.Alignment.center,
      data: records.map((r) {
        // البحث عن اسم الموظف من القائمة (محاكاة الربط)
        return [
          "عامل ميداني", // يمكن جلب الاسم الحقيقي هنا بربط الـ ID
          r.date,
          r.checkInFormatted,
          r.checkOutFormatted,
          r.hoursFormatted,
        ];
      }).toList(),
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text("توقيع المدير"), pw.Text("ختم الشركة")]);
  }
}
