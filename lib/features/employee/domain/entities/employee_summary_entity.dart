// import 'package:equatable/equatable.dart';
//
// // 1. كيان المستخدم
// class UserEntity extends Equatable {
//   final int? id;
//   final String? fullName;
//   final String? phoneNumber;
//   final String? email;
//   final dynamic profileImageUrl;
//
//   const UserEntity({
//     this.id,
//     this.fullName,
//     this.phoneNumber,
//     this.email,
//     this.profileImageUrl,
//   });
//
//   @override
//   List<Object?> get props => [
//     id,
//     fullName,
//     phoneNumber,
//     email,
//     profileImageUrl,
//   ];
// }
//
// // 2. كيان الموظف (يحتوي على كيان المستخدم)
// class EmployeeEntity extends Equatable {
//   final int? id;
//   final String? position;
//   final String? department;
//   final int? hourlyRate;
//   final int? overtimeRate;
//   final bool? isOnline;
//   final String? currentLocation;
//   final UserEntity? user; // لاحظ هنا استخدمنا UserEntity وليس Model
//
//   const EmployeeEntity({
//     this.id,
//     this.position,
//     this.department,
//     this.hourlyRate,
//     this.overtimeRate,
//     this.isOnline,
//     this.currentLocation,
//     this.user,
//   });
//
//   @override
//   List<Object?> get props => [
//     id,
//     position,
//     department,
//     hourlyRate,
//     overtimeRate,
//     isOnline,
//     currentLocation,
//     user,
//   ];
// }
//
// // 3. كيان الإجماليات
// class GrandTotalsEntity extends Equatable {
//   final int? totalRegularHours;
//   final int? totalOvertimeHours;
//   final int? totalRegularPay;
//   final int? totalOvertimePay;
//   final int? grandTotalPay;
//
//   const GrandTotalsEntity({
//     this.totalRegularHours,
//     this.totalOvertimeHours,
//     this.totalRegularPay,
//     this.totalOvertimePay,
//     this.grandTotalPay,
//   });
//
//   @override
//   List<Object?> get props => [
//     totalRegularHours,
//     totalOvertimeHours,
//     totalRegularPay,
//     totalOvertimePay,
//     grandTotalPay,
//   ];
// }
//
// // 4. كيان ملخص ورش العمل
// class WorkshopsSummaryEntity extends Equatable {
//   final int? workshopId;
//   final String? workshopName;
//   final String? location;
//   final int? regularHours;
//   final int? overtimeHours;
//   final int? regularPay;
//   final int? overtimePay;
//   final int? totalPay;
//
//   const WorkshopsSummaryEntity({
//     this.workshopId,
//     this.workshopName,
//     this.location,
//     this.regularHours,
//     this.overtimeHours,
//     this.regularPay,
//     this.overtimePay,
//     this.totalPay,
//   });
//
//   @override
//   List<Object?> get props => [
//     workshopId,
//     workshopName,
//     location,
//     regularHours,
//     overtimeHours,
//     regularPay,
//     overtimePay,
//     totalPay,
//   ];
// }
//
// // 5. الكيان الرئيسي الذي يجمع كل ما سبق
// class EmployeeSummaryEntity extends Equatable {
//   final EmployeeEntity? employee; // نستخدم الـ Entity هنا
//   final List<WorkshopsSummaryEntity>? workshopsSummary; // نستخدم الـ Entity هنا
//   final GrandTotalsEntity? grandTotals; // نستخدم الـ Entity هنا
//
//   const EmployeeSummaryEntity({
//     this.employee,
//     this.workshopsSummary,
//     this.grandTotals,
//   });
//
//   @override
//   List<Object?> get props => [
//     employee,
//     workshopsSummary,
//     grandTotals,
//   ];
// }