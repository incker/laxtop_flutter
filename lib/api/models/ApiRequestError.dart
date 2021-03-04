class ApiRequestError {
  final ApiError apiError;
  final int statusCode;

  final String jsonError;
  final String jsonBody;

  ApiRequestError(
      this.apiError, this.statusCode, this.jsonError, this.jsonBody);
}

enum ApiError {
  NotLoggedIn,
  ResponseStatusNotOk,
  ResponseNotJson,
  UnknownJsonStruct,
}
