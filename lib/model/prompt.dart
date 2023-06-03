import 'package:cloud_firestore/cloud_firestore.dart';

class Prompt {
  String id;
  String title;
  String body;
  int votes;

  Prompt({
    this.id = '',
    this.title = '',
    this.body = '',
    this.votes = 0,
  });

  factory Prompt.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Prompt(
      id: snapshot.id,
      title: data['title'],
      body: data['body'],
      votes: data['votes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'votes': votes,
    };
  }
}
