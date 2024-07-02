import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
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
    "percentageDone": 0,
    "imgURL": ''
  });
}

Future<List<AppTask>> getTasks() async {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference col = FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .collection("tasks");

  var result = await col.get();
  List<AppTask> tasks = result.docs.map((e) => snapshotToTask(e)).toList();

  return tasks;
}

Future<AppTask> getTaskDetail(String id) async {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference col = FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .collection("tasks");

  var result = await col.doc(id).get();
  return snapshotToTask(result);
}

Future saveProgress(String id, int progressValue) async {
  User? user = FirebaseAuth.instance.currentUser;
  await FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .collection("tasks")
      .doc(id)
      .update({'percentageDone': progressValue});
}

Future<String> saveImage(XFile file, String taskId) async {
  Reference ref = FirebaseStorage.instance.ref("$taskId.jpg");
  await ref.putData(await file.readAsBytes());

  String url = await ref.getDownloadURL();

  User? user = FirebaseAuth.instance.currentUser;
  await FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .collection("tasks")
      .doc(taskId)
      .update({'imgURL': url});

  return url;
}

AppTask snapshotToTask(DocumentSnapshot<Object?> snapshot) {
  return AppTask()
    ..id = snapshot.id
    ..name = snapshot['name']
    ..deadline = snapshot['deadline'].toDate()
    ..creationDate = snapshot['creationDate'].toDate()
    ..percentageDone = snapshot['percentageDone']
    ..imgURL = snapshot['imgURL'];
}

Future<bool> isTaskNameTaken(String name) async {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference ref = await FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .collection("tasks");

  var result = await ref. where("name", isEqualTo: name).get();

  return result.docs.isNotEmpty;
}
