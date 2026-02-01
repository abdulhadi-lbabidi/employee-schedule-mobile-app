// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/chat_bloc.dart';
// import '../bloc/chat_event.dart';
// import '../bloc/chat_state.dart';
//
// class ChatPage extends StatefulWidget {
//   const ChatPage({super.key});
//
//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   final _controller = TextEditingController();
//   final _chatId = 'sample_chat_1';
//
//   @override
//   void initState() {
//     super.initState();
//     context.read<ChatBloc>().add(LoadMessages(_chatId));
//   }
//
//   void _send() {
//     final text = _controller.text.trim();
//     if (text.isEmpty) return;
//     final message = {
//       'text': text,
//       'senderId': 'me',
//       'timestamp': FieldValue.serverTimestamp(),
//       'isSeen': false,
//     };
//     context.read<ChatBloc>().add(SendMessage(_chatId, message));
//     _controller.clear();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Chat')),
//       body: Column(
//         children: [
//           Expanded(child: BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
//             if (state is ChatLoading) return const Center(child: CircularProgressIndicator());
//             if (state is ChatLoaded) {
//               final snap = state.snapshot as QuerySnapshot;
//               return ListView.builder(
//                 reverse: true,
//                 itemCount: snap.docs.length,
//                 itemBuilder: (context, index) {
//                   final doc = snap.docs[index];
//                   final data = doc.data() as Map<String, dynamic>;
//                   return ListTile(title: Text(data['text'] ?? ''));
//                 },
//               );
//             }
//             return const Center(child: Text('No messages'));
//           })),
//           SafeArea(
//             child: Row(
//               children: [
//                 Expanded(child: TextField(controller: _controller)),
//                 IconButton(onPressed: _send, icon: const Icon(Icons.send))
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }