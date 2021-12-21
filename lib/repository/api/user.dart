import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipes_app/model/user.dart';

class UserApi {
  final _reference = FirebaseFirestore.instance.collection("Users");
  final _auth = FirebaseAuth.instance;

  Future<void> _addUserToDB(UserModel user) =>
      _reference.doc(user.id).set(user.toJson());

  Future<void> authenticate(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  Future<void> register(String email, String name, String password) async {
    UserCredential credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    UserModel model = UserModel(
      id: credential.user.uid,
      email: email,
      name: name,
    );
    return _addUserToDB(model);
  }

  Future<String> getUid() async => _auth.currentUser.uid;
}
