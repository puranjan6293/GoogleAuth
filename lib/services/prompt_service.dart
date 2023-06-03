import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firenotes/model/prompt.dart';

class PromptService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // getprompts stream
  Stream<List<Prompt>> getPromptsStream() {
    return _firestore.collection('prompts').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Prompt.fromSnapshot(doc)).toList();
    });
  }

  //addprompts
  Future<String> addPrompts(Prompt prompt) async {
    DocumentReference docRef =
        await _firestore.collection('prompts').add(prompt.toJson());
    return docRef.id;
  }

  //update
  Future<void> updatePrompt(Prompt prompt) async {
    await _firestore
        .collection('prompts')
        .doc(prompt.id)
        .update(prompt.toJson());
  }

  //delete
  Future<void> deletePromptById(String id) async {
    await _firestore.collection('prompts').doc(id).delete();
  }
}
