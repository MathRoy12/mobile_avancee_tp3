import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/task.dart';

Future addTask(String name, DateTime deadline) async {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference col = FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .collection("tasks");

  col.add({
    "name": name,
    "creationDate": DateTime.now(),
    "deadline": deadline,
    "percentageDone": 0
  });
}

Future<List<Task>> getTasks() async {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference col = FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .collection("tasks");

  var result = await col.get();
  List<Task> tasks = result.docs.map((e) => snapshotToTask(e)).toList();

  return tasks;
}

Future<Task> getTaskDetail(String id) async {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference col = FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .collection("tasks");

  var result = await col.doc(id).get();
  return snapshotToTask(result);
}

Task snapshotToTask(DocumentSnapshot<Object?> snapshot) {
  return Task()
    ..id = snapshot.id
    ..name = snapshot['name']
    ..deadline = snapshot['deadline'].toDate()
    ..creationDate = snapshot['creationDate'].toDate()
    ..percentageDone = snapshot['percentageDone'];
}
