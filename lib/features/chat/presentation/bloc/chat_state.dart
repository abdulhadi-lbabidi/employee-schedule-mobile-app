// import 'package:equatable/equatable.dart';
//
// abstract class ChatState extends Equatable {
//   @override
//   List<Object?> get props => [];
// }
//
// class ChatInitial extends ChatState {}
// class ChatLoading extends ChatState {}
// class ChatLoaded extends ChatState {
//   final dynamic snapshot; // keep generic to display
//   ChatLoaded(this.snapshot);
//   @override
//   List<Object?> get props => [snapshot];
// }
// class ChatError extends ChatState {
//   final String message;
//   ChatError(this.message);
//   @override
//   List<Object?> get props => [message];
// }