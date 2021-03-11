class SignInDetails {
  final String firebaseToken;

  SignInDetails(this.firebaseToken);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'firebaseToken': firebaseToken,
      };
}
