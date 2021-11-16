import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String id;
  String content;
  bool done;

  Todo({
    this.id,
    this.content,
    this.done,
  });

  Todo.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    print(documentSnapshot.get('content'));

    content = documentSnapshot.get('content').toString();
    done = true;
    /*content = documentSnapshot.data()["content"] as String;
    done = documentSnapshot.data()['done'] as bool;*/
  }
}
