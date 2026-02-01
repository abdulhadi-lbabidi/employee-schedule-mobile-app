 class OnboardingEvent {}

class OnPageChanged extends OnboardingEvent {
  final int pageIndex;
  OnPageChanged(this.pageIndex);
}

class OnNextPressed extends OnboardingEvent {}
