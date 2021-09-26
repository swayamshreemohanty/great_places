//@dart=2.9
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:native_device/models/place.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class Authentication with ChangeNotifier {
  String _userName;
  UserData _userData;

  String get user {
    if (_userName == null) {
      return null;
    } else {
      return _userName;
    }
  }

  UserData get userData {
    return _userData;
  }

  static Future<FirebaseApp> initializeFirebase({BuildContext context}) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  static SnackBar customSnackBar({String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  Future<User> signInWithGoogle({BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User user;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
        _userName = user.displayName.toString();
        print("User Signin Data");
        print(user);

        _userData = UserData(
          displayName: user.displayName.toString(),
          email: user.email.toString(),
          photoUrl: user.photoURL.toString(),
        );
        notifyListeners();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content:
                  'The account already exists with a different credential.',
            ),
          );
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred while accessing credentials. Try again.',
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'Error occurred using Google Sign-In. Try again.',
          ),
        );
      }
    }
    return user;
  }

  Future<void> signOut({BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      _userName = null;
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }

  Future<bool> tryAutoLogin() async {
    googleSignIn.onCurrentUserChanged.listen(
      (account) {
        print("Account Details");
        // print(account);
        print(account);

        _userName = account.displayName.toString();
        _userData = UserData(
          displayName: account.displayName.toString(),
          email: account.email.toString(),
          photoUrl: account.photoUrl.toString(),
        );
      },
      onError: (error) {
        print('Sign In $error');
      },
    );
    googleSignIn.signInSilently(suppressErrors: true).then(
      (account) {
        print("User Name");
        print(account);
        _userName = account.displayName.toString();
        UserData(
          displayName: account.displayName.toString(),
          email: account.email.toString(),
          photoUrl: account.photoUrl.toString(),
        );

        notifyListeners();
      },
    ).catchError(
      (error) {
        print('Error signIn $error');
      },
    );

    return true;
  }
}
