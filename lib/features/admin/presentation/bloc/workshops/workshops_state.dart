import '../../../domain/entities/workshop_entity.dart';


abstract class WorkshopsState {}

class WorkshopsInitial extends WorkshopsState {}

class WorkshopsLoading extends WorkshopsState {}

class WorkshopsLoaded extends WorkshopsState {
  final List<WorkshopEntity> workshops;
  WorkshopsLoaded(this.workshops);
}

class WorkshopsError extends WorkshopsState {
  final String message;
  WorkshopsError(this.message);
}
