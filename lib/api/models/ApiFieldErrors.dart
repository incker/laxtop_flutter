class ApiFieldErrors {
  final List<List<String>> errors;

  ApiFieldErrors(this.errors) : assert(errors != null);

  factory ApiFieldErrors.fromJson(Map<String, dynamic> json) => ApiFieldErrors(
        (json['errors'] as List)
            ?.map((e) =>
                (e as List)?.map((e) => e as String)?.toList(growable: false))
            ?.toList(growable: false),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'errors': errors,
      };
}

// flutter packages pub run build_runner build --delete-conflicting-outputs
