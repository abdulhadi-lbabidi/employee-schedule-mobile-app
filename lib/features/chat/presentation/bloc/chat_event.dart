// import 'package:equatable/equatable.dart';
//
// abstract class ChatEvent extends Equatable {
//   @override
//   List<Object?> get props => [];
// }
//
// class LoadMessages extends ChatEvent {
//   final String chatId;
//   LoadMessages(this.chatId);
//   @override
//   List<Object?> get props => [chatId];
// }
//
// class SendMessage extends ChatEvent {
//   final String chatId;
//   final Map<String, dynamic> message;
//   SendMessage(this.chatId, this.message);
//   @override
//   List<Object?> get props => [chatId, message];
// }