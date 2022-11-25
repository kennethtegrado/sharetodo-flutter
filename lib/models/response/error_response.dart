import 'response.dart';

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
