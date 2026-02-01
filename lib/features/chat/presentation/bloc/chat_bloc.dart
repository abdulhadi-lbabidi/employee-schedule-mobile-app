// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../data/chat_repository.dart';
// import 'chat_event.dart';
// import 'chat_state.dart';
//
// class ChatBloc extends Bloc<ChatEvent, ChatState> {
//   final ChatRepository _repo = ChatRepository();
//   Stream? _sub;
//
//   ChatBloc() : super(ChatInitial()) {
//     on<LoadMessages>((event, emit) async {
//       emit(ChatLoading());
//       _sub = _repo.messagesStream(event.chatId).listen((snap) {
//         add(_MessagesUpdated(snap));
//       }) as Stream?;
//     });
//
//     on<SendMessage>((event, emit) async {
//       await _repo.sendTextMessage(event.chatId, event.message);
//     });
//
//     on<_MessagesUpdated>((event, emit) {
//       emit(ChatLoaded(event.snapshot));
//     });
//   }
// }
//
// // internal event
// class _MessagesUpdated extends ChatEvent {
//   final dynamic snapshot;
//   _MessagesUpdated(this.snapshot);
//   @override
//   List<Object?> get props => [snapshot];
// }