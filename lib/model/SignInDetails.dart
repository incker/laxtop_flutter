class SignInDetails {
  final String firebaseToken;

  SignInDetails(this.firebaseToken) : assert(firebaseToken != null);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'firebaseToken': firebaseToken,
      };
}
