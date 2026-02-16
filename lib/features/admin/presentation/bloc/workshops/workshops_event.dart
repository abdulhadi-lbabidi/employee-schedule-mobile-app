import '../../../domain/usecases/add_workshop.dart';

abstract class WorkshopsEvent {}

class GetAllWorkShopEvent extends WorkshopsEvent {}
class GetAllArchivedWorkShopEvent extends WorkshopsEvent {}
class GetWorkShopEmployeeDetailsEvent extends WorkshopsEvent {
  final int id;

  GetWorkShopEmployeeDetailsEvent({required this.id});
}

class AddWorkshopEvent extends WorkshopsEvent {
  final AddWorkshopParams params;

  AddWorkshopEvent({required this.params});
}

class DeleteWorkshopEvent extends WorkshopsEvent {
  final int id;
  DeleteWorkshopEvent(this.id);
}


class ToggleArchiveWorkshopEvent extends WorkshopsEvent {
  final String id;

  ToggleArchiveWorkshopEvent({required this.id});
}
class RestoreArchiveWorkshopEvent extends WorkshopsEvent {
  final String id;

  RestoreArchiveWorkshopEvent({required this.id});
}
