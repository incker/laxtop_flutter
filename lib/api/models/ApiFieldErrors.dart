import 'package:json_annotation/json_annotation.dart';

part 'ApiFieldErrors.g.dart';

@JsonSerializable()
class ApiFieldErrors {
  final List<List<String>> errors;

  ApiFieldErrors(this.errors) : assert(errors != null);

  factory ApiFieldErrors.fromJson(Map<String, dynamic> json) =>
      _$ApiFieldErrorsFromJson(json);

  Map<String, dynamic> toJson() => _$ApiFieldErrorsToJson(this);
}

// flutter packages pub run build_runner build --delete-conflicting-outputs
