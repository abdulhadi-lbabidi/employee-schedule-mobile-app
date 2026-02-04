enum SplashStatus { init, isAuth, unauthorized }

class OnboardingState {
  final int? currentIndex;
  final bool isLastPage;
  final SplashStatus splashStatus;
  final List<(String,String,String)> pages;

  OnboardingState({
    this.currentIndex,
    this.pages=const[],
    this.isLastPage = false,
    this.splashStatus = SplashStatus.init,
  });

  OnboardingState copyWith({
    int? currentIndex,
    bool? isLastPage,
    SplashStatus? splashStatus,
     List<(String,String,String)>? pages

  }) {
    return OnboardingState(
      currentIndex: currentIndex ?? this.currentIndex,
      isLastPage: isLastPage ?? this.isLastPage,
      splashStatus: splashStatus ?? this.splashStatus,
      pages: pages ?? this.pages,
    );
  }
}
