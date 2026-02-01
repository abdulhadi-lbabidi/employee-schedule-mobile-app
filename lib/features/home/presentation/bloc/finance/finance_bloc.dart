import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/finance_entity.dart';

// Events
abstract class FinanceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFinanceHistory extends FinanceEvent {}

// States
abstract class FinanceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FinanceInitial extends FinanceState {}
class FinanceLoading extends FinanceState {}
class FinanceLoaded extends FinanceState {
  final List<FinanceWeekEntity> history;
  final double totalEarned;
  final double currentDue;

  FinanceLoaded({
    required this.history,
    required this.totalEarned,
    required this.currentDue,
  });

  @override
  List<Object?> get props => [history, totalEarned, currentDue];
}
class FinanceError extends FinanceState {
  final String message;
  FinanceError(this.message);
}

// Bloc
class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  FinanceBloc() : super(FinanceInitial()) {
    on<LoadFinanceHistory>(_onLoadFinanceHistory);
  }

  Future<void> _onLoadFinanceHistory(LoadFinanceHistory event, Emitter<FinanceState> emit) async {
    emit(FinanceLoading());
    try {
      // محاكاة جلب البيانات من السيرفر (بيانات وهمية احترافية)
      await Future.delayed(const Duration(milliseconds: 1000));
      
      final mockHistory = [
        const FinanceWeekEntity(
          weekNumber: 1,
          isPaid: true,
          regularHours: 40.0,
          overtimeHours: 5.0,
          workshops: ['ورشة النجارة'],
          hourlyRate: 3000.0,
          overtimeRate: 4500.0,
        ),
        const FinanceWeekEntity(
          weekNumber: 2,
          isPaid: false,
          regularHours: 35.0,
          overtimeHours: 2.0,
          workshops: ['ورشة النجارة', 'ورشة الدهان'],
          hourlyRate: 3000.0,
          overtimeRate: 4500.0,
        ),
      ];

      double totalEarned = 0;
      double currentDue = 0;

      for (var week in mockHistory) {
        if (week.isPaid) {
          totalEarned += week.totalAmount;
        } else {
          currentDue += week.totalAmount;
        }
      }

      emit(FinanceLoaded(
        history: mockHistory,
        totalEarned: totalEarned,
        currentDue: currentDue,
      ));
    } catch (e) {
      emit(FinanceError("فشل تحميل البيانات المالية"));
    }
  }
}
