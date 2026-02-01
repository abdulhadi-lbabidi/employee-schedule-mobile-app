

class ButtonState {
  final bool isLoginEnabled;
  final bool isLogoutEnabled;
  final bool isPressed;

  ButtonState({
    required this.isLoginEnabled,
    required this.isLogoutEnabled,
    this.isPressed = false,
  });

  ButtonState copyWith({
    bool? isLoginEnabled,
    bool? isLogoutEnabled,
    bool? isPressed,
  }) {
    return ButtonState(
      isLoginEnabled: isLoginEnabled ?? this.isLoginEnabled,
      isLogoutEnabled: isLogoutEnabled ?? this.isLogoutEnabled,
      isPressed: isPressed ?? this.isPressed,
    );
  }
}