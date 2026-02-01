import 'package:equatable/equatable.dart';

class FinanceWeekEntity extends Equatable {
  final int weekNumber;
  final bool isPaid;
  final double regularHours;
  final double overtimeHours;
  final List<String> workshops;
  final double hourlyRate;
  final double overtimeRate;

  const FinanceWeekEntity({
    required this.weekNumber,
    required this.isPaid,
    required this.regularHours,
    required this.overtimeHours,
    required this.workshops,
    required this.hourlyRate,
    required this.overtimeRate,
  });

  double get totalAmount => (regularHours * hourlyRate) + (overtimeHours * overtimeRate);

  @override
  List<Object?> get props => [weekNumber, isPaid, regularHours, overtimeHours, workshops];
}
