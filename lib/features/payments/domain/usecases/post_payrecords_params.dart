class PostPayRecordsParams {
  final int employeeId;
  final List<int> attendanceIds;
  final double totalAmount;
  final double amountPaid;
  final String paymentDate;

  PostPayRecordsParams({
    required this.employeeId,
    required this.attendanceIds,
    required this.totalAmount,
    required this.amountPaid,
    required this.paymentDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "employee_id": employeeId,
      "attendance_ids": attendanceIds,
      "total_amount": totalAmount,
      "amount_paid": amountPaid,
      "payment_date": paymentDate,
    };
  }
}
