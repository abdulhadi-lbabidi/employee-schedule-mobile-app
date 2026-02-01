
class OnboardingState {
  final int currentIndex;
  final bool isLastPage;

  OnboardingState({required this.currentIndex, required this.isLastPage});

  OnboardingState copyWith({int? currentIndex, bool? isLastPage}) {
    return OnboardingState(
      currentIndex: currentIndex ?? this.currentIndex,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }
}
