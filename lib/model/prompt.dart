import 'package:cloud_firestore/cloud_firestore.dart';

class Prompt {
  String id;
  String title;
  String body;

  Prompt({
    this.id = '',
    this.title = '',
    this.body = '',
  });

  factory Prompt.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Prompt(
      id: snapshot.id,
      title: data['title'],
      body: data['body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
    };
  }
}
