// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:injectable/injectable.dart';
// import 'package:untitled8/features/admin/data/models/audit_log_model.dart';
//
// @module
// abstract class HiveModule {
//   @preResolve
//   @lazySingleton
//   Future<Box<Map>> get loanBox async {
//     return await Hive.openBox<Map>('loan_box');
//   }
//
//   // 🔹 إضافة دالة لفتح وتسجيل صندوق سجلات التدقيق
//   @preResolve
//   @lazySingleton
//   Future<Box<AuditLogModel>> get auditLogBox async {
//     return await Hive.openBox<AuditLogModel>('audit_log_box');
//   }
// }
