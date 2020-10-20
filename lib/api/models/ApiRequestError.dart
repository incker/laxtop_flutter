class ApiRequestError {
  final ApiError apiError;
  final int statusCode;

  final String jsonError;
  final String jsonBody;

  ApiRequestError(this.apiError, this.statusCode, this.jsonError, this.jsonBody)
      : assert(apiError != null),
        assert(statusCode != null);
}

enum ApiError {
  NotLoggedIn,
  ResponseStatusNotOk,
  ResponseNotJson,
  UnknownJsonStruct,
}
