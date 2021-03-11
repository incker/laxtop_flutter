import 'package:firebase_auth/firebase_auth.dart' as auth;

class AuthLogic {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  String _verificationId = '';

  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// validate phoneNumber, receive _verificationId
  Future<void> verifyPhoneNumber(
      String phoneNumber, Function() onOk, Function(String) onErr) async {
    print('PHONE NUMBER GIVEN: $phoneNumber');

    final auth.PhoneVerificationCompleted verificationCompleted =
        (auth.AuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      String message = 'Received phone auth credential: $phoneAuthCredential';
      print('_________________________');
      print(message);
    };

    final auth.PhoneVerificationFailed verificationFailed =
        (auth.FirebaseAuthException authException) async {
      print(authException.code);
      print(authException.message);

      onErr(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    final auth.PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      _verificationId = verificationId;
      onOk();
    };

    final auth.PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) async {
      _verificationId = verificationId;
      onOk();
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  /// validate by _verificationId + smsCode
  Future<auth.User?> signInWithPhoneNumber(String smsCode) async {
    final auth.AuthCredential credential = auth.PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: smsCode,
    );

    return (await _auth.signInWithCredential(credential)).user;
  }

  Future<auth.User?> getUser() async {
    return _auth.currentUser;
  }
}
