import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:kafe/data/models/preference_model.dart';
import 'package:kafe/data/models/user_model.dart';
import 'package:kafe/service/firestore_service.dart';
import 'package:kafe/service/shared_preferences_service.dart';
import 'package:kafe/service/storage_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final StorageService _storageService = StorageService();
  final SharedPreferencesService _prefs = SharedPreferencesService();

  Future<bool> signInUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      UserModel user = await getCurrentUser();
      await _prefs.saveUser(user);
      return true;
    } on FirebaseAuthException catch (_) {
      return false;
    }
  }

  Future<void> registerUser(String username, String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    UserModel user = UserModel(
      uid: userCredential.user!.uid,
      email: email,
      username: username,
      photoURL: "null",
      preference: PreferenceModel(
        preferLocation: [],
        preferAtmosphere: [],
        preferFacilities: [],
      ),
      created: DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now()),
    );

    await _firestoreService.createUser(user);
    await _prefs.saveUser(user);
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      return;
    }
  }

  Future<UserModel> getCurrentUser() async {
    return await _firestoreService.getUserProfile(_auth.currentUser!.uid);
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}