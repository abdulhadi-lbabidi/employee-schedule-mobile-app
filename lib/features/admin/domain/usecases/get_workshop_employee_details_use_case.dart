

import 'package:injectable/injectable.dart';
import 'package:untitled8/common/helper/src/typedef.dart';
import 'package:untitled8/core/unified_api/use_case.dart';
import 'package:untitled8/features/admin/data/models/workshop_models/get_workshop_employees_details_response.dart';
import 'package:untitled8/features/admin/domain/repositories/workshop_repository.dart';

@lazySingleton
class GetWorkshopEmployeeDetailsUseCase implements UseCase<GetWorkshopEmployeeDetailsResponse, int>{

  final WorkshopRepository _repository;

  GetWorkshopEmployeeDetailsUseCase({required WorkshopRepository repository}) : _repository = repository;

  @override
  DataResponse<GetWorkshopEmployeeDetailsResponse> call(int params) {

    return  _repository.getWorkShopEmployees(params);
  }
 }