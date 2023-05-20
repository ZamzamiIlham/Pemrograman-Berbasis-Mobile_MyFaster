import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Metode untuk mendaftar pengguna baru dengan email dan kata sandi
  Future<String> signUp(String username, String email, String password) async {
    try {
      UserCredential result =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        // Update profil pengguna dengan nama
        await user.updateProfile(displayName: username);
        await user
            .reload(); // Muat ulang informasi pengguna untuk memperbarui displayName
        return 'success';
      } else {
        return 'Failed to create user';
      }
    } catch (e) {
      return e.toString();
    }
  }

  // Metode untuk masuk dengan email dan kata sandi
  Future<String> logIn(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

  // Metode untuk keluar dari akun
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
