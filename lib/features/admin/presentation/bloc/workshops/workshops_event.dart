abstract class WorkshopsEvent {}

class LoadWorkshopsEvent extends WorkshopsEvent {}

class AddWorkshopEvent extends WorkshopsEvent {
  final String name;
  final double? latitude;
  final double? longitude;
  final double radius;

  AddWorkshopEvent({
    required this.name,
    this.latitude,
    this.longitude,
    this.radius = 200,
  });
}

class DeleteWorkshopEvent extends WorkshopsEvent {
  final String id;
  DeleteWorkshopEvent(this.id);
}

class ToggleArchiveWorkshopEvent extends WorkshopsEvent {
  final String id;
  final bool isArchived;
  ToggleArchiveWorkshopEvent(this.id, this.isArchived);
}
