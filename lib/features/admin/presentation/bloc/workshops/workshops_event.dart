abstract class WorkshopsEvent {}

class LoadWorkshopsEvent extends WorkshopsEvent {}

class AddWorkshopEvent extends WorkshopsEvent {

  final String name;
  final String location;
  final String description;
  final double? latitude;
  final double? longitude;
  final double radius;

  AddWorkshopEvent({
    required this.name,
    this.latitude,
    this.longitude,
    this.radius = 200, required this.location, required this.description,
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
