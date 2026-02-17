
import 'package:injectable/injectable.dart';

@injectable

class GetUnpaidWeeksParams {
  final String employeeId;

  GetUnpaidWeeksParams({required this.employeeId});
}
