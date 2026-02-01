// onboarding_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_state.dart';
import 'onboarding_event.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final int totalPages;

  OnboardingBloc({required this.totalPages})
    : super(OnboardingState(currentIndex: 0, isLastPage: false)) {
    on<OnPageChanged>((event, emit) {
      emit(
        state.copyWith(
          currentIndex: event.pageIndex,
          isLastPage: event.pageIndex == totalPages - 1,
        ),
      );
    });

    on<OnNextPressed>((event, emit) {
      final newIndex = state.currentIndex + 1;
      if (newIndex < totalPages) {
        emit(
          state.copyWith(
            currentIndex: newIndex,
            isLastPage: newIndex == totalPages - 1,
          ),
        );
      }
    });
  }
}
