class Response {
  int status;
  bool success;
  String message;

  Response(
      {required this.status, required this.success, required this.message});

  String getMessage() => message;
}

class SuccessResponse extends Response {
  SuccessResponse(String message)
      : super(status: 201, success: true, message: message);
}

enum ErrorType {
  invalidEmail,
  weakPassword,
  emailAlreadyExists,
  invalidFirstName,
  invalidLastName,
  unknownError,
  userNotFound,
  incorrectPassword
}

class ErrorResponse extends Response {
  ErrorType errorType;
  ErrorResponse(String message, this.errorType)
      : super(status: 400, success: false, message: message);
}
