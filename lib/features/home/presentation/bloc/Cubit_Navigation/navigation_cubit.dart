import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class NavigationnCubit extends Cubit<int> {
  NavigationnCubit() : super(0);

  void navigateTo(int index) => emit(index);
}
