
 class OnboardingEvent {}

class OnPageChanged extends OnboardingEvent {
  final int pageIndex;
  OnPageChanged(this.pageIndex);
}

class OnNextPressed extends OnboardingEvent {}

 class CheckSplashStatus extends OnboardingEvent{}


 class InitSplash extends OnboardingEvent{}
