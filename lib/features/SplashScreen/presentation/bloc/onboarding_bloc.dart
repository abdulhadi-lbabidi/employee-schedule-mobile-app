import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/helper/src/helper_func.dart';
import 'onboarding_state.dart';
import 'onboarding_event.dart';
import 'package:injectable/injectable.dart';

@injectable
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingState()) {
    on<OnPageChanged>((event, emit) {
      final bool isLast = event.pageIndex == state.pages.length - 1;
      emit(state.copyWith(currentIndex: event.pageIndex, isLastPage: isLast));
    });
    on<InitSplash>((event, emit) {
      final List<(String, String, String)> list = [
        (
          "مرحباً بك في Nouh agency",
          "نظامك المتكامل لإدارة الحضور والرواتب الميدانية.",
          "assets/image/biuilding.png",
        ),
        (
          "سجل حضورك بلمسة",
          "تقنية المزامنة الذكية تضمن وصول بياناتك حتى بدون إنترنت.",
          "assets/image/project02.png",
        ),
        (
          "شفافية مالية تامة",
          "تابع مستحقاتك المالية الأسبوعية بدقة ووضوح.",
          "assets/image/project03.png",
        ),
      ];

      emit(state.copyWith(currentIndex: 0, pages: list));
    });

    on<OnNextPressed>((event, emit) {
      final newIndex = state.currentIndex! + 1;
      if (newIndex < state.pages.length) {
        emit(
          state.copyWith(
            currentIndex: newIndex,
            isLastPage: newIndex == state.pages.length - 1,
          ),
        );
      }
    });
    on<CheckSplashStatus>((event, emit) {
      if (HelperFunc.isAuth()) {
        emit(state.copyWith(splashStatus: SplashStatus.isAuth));
      } else {
        emit(state.copyWith(splashStatus: SplashStatus.unauthorized));
      }
    });
  }
}
