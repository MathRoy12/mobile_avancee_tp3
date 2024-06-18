import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../dto/transfer.dart';
import '../models/task.dart';

Future addTask(AddTaskRequest req) async {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference col = FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .collection("tasks");

  col.add({
    "name": req.name,
    "creationDate": DateTime.now(),
    "deadline": req.deadline,
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
  List<Task> tasks = result.docs
      .map((e) => Task()
        ..id = e.id
        ..name = e['name']
        ..deadline = e['deadline']
        ..creationDate = e['creationDate']
        ..percentageDone = e['percentageDone'])
      .toList();

  return tasks;
}
