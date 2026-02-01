// import 'dart:typed_data';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
//
//
// class ChatRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;
//
//
//   Stream<QuerySnapshot> messagesStream(String chatId) {
//     return _firestore.collection('chats').doc(chatId).collection('messages')
//         .orderBy('timestamp', descending: true).snapshots();
//   }
//
//   Future<void> sendTextMessage(String chatId, Map<String, dynamic> message) async {
//     await _firestore.collection('chats').doc(chatId).collection('messages').add(message);
//     await _firestore.collection('chats').doc(chatId).set({
//       'lastMessage': message['text'],
//       'lastTimestamp': message['timestamp']
//     }, SetOptions(merge: true));
//   }
//
//   Future<String> uploadFile(String path, List<int> bytes) async {
//     final ref = _storage.ref().child(path);
//     final upload = await ref.putData(Uint8List.fromList(bytes));
//     return await upload.ref.getDownloadURL();
//   }
// }
//
