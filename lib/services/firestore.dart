import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_firebase/services/auth.dart';
import 'package:flutter_firebase/services/models.dart';


class FireStoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<List<Topic>> getTopics() async {
    // try {
    //   var ref = _db.collection('topics');
    //   var snapshot = await ref.get();
    //   var data = snapshot.docs.map((s) => s.data());
    //   var topics = data.map((d) => Topic.fromJson(d)).toList();
    //   return topics;
    // } catch (e) {
    //   rethrow;
    // }
      var ref = _db.collection('topics');
      var snapshot = await ref.get();
      var data = snapshot.docs.map((s) => s.data());
      var topics = data.map((d) => Topic.fromJson(d)).toList();
      return topics;
  }

  Future<Quiz> getQuizzes(String quizId) async {
    try {
      // Get a reference to the 'quizzes' collection and specify the document ID.
      var ref = _db.collection('quizzes').doc(quizId);

      // Fetch the document snapshot from Firestore.
      var snapshot = await ref.get();

      // Convert the document data to a Quiz object using the Quiz.fromJson factory method.
      return Quiz.fromJson(snapshot.data() ?? {});
    } catch (e) {
      // If an error occurs, rethrow the exception.
      rethrow;
    }
  }

  Stream<Report> streamReport() {
    return AuthService().userStream.switchMap((user) {
      if (user == null) {
        return Stream.fromIterable([Report()]);
      } else {
        var ref = _db.collection('reports').doc(user.uid);
        return ref.snapshots().map((doc) {
          return Report.fromJson(doc.data() ?? {});
        });
      }
    });
  }

  Future<void> updateReport(Quiz quiz) {
    var user = AuthService().user!;
    var ref = _db.collection('reports').doc(user.uid);

    var data = {
      'total': FieldValue.increment(1),
      'topics': {
        quiz.topic: FieldValue.arrayUnion([quiz.id])
      },
    };

    return ref.set(data, SetOptions(merge: true));
  }

}