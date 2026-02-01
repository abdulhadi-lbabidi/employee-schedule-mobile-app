
enum ActiveUnactiveStatue {
  initial,
  loading,
  success,
  error,
  active,    // حالة تسجيل دخول
  inactive,  // حالة تسجيل خروج
}

class ActiveUnactiveState {
  final ActiveUnactiveStatue status;
  final DateTime? currentCheckInTime;
  final DateTime? currentCheckOutTime;
  final String? successMessage;
  final String? errorMessage;

  ActiveUnactiveState({
    required this.status,
    this.currentCheckInTime,
    this.currentCheckOutTime,
    this.successMessage,
    this.errorMessage,
  });

  // الحالة الأولية
  factory ActiveUnactiveState.initial() {
    return ActiveUnactiveState(
      status: ActiveUnactiveStatue.inactive,
      currentCheckInTime: null,
      currentCheckOutTime: null,
      successMessage: null,
      errorMessage: null,
    );
  }

  // إنشاء نسخة جديدة مع تعديلات
  ActiveUnactiveState copyWith({
    ActiveUnactiveStatue? status,
    DateTime? currentCheckInTime,
    DateTime? currentCheckOutTime,
    String? successMessage,
    String? errorMessage,
  }) {
    return ActiveUnactiveState(
      status: status ?? this.status,
      currentCheckInTime: currentCheckInTime ?? this.currentCheckInTime,
      currentCheckOutTime: currentCheckOutTime ?? this.currentCheckOutTime,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }
}
