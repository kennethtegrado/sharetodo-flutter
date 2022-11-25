import 'response.dart';

class SuccessResponse extends Response {
  SuccessResponse(String message)
      : super(status: 201, success: true, message: message);
}
