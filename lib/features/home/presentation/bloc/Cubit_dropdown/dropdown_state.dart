class DropdownState {
  final String? selectedValue;

  DropdownState({required this.selectedValue});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DropdownState &&
              runtimeType == other.runtimeType &&
              selectedValue == other.selectedValue;

  @override
  int get hashCode => selectedValue.hashCode;

  @override
  String toString() => 'DropdownState(selectedValue: $selectedValue)';
}