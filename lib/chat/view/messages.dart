import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/chat/chat.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    CollectionReference<Map<String, dynamic>> collection =
        FirebaseFirestore.instance.collection('chat');
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder(
      stream: collection.orderBy('createdAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final documents = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: documents.length,
          itemBuilder: (context, i) => MessageBubble(
            documents[i]['text'],
            documents[i]['userId'] == userId,
            documents[i]['username'],
            documents[i]['userImage'],
            ValueKey(documents[i].id),
          ),
        );
      },
    );
  }
}
