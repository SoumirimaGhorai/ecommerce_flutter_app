class AppException implements Exception {
  String title;
  String msg;

  AppException({required this.title, required this.msg});

  @override
  String toString() => msg; // ✅ IMPORTANT (UI shows only message)
}

class NoInternetException extends AppException {
  NoInternetException({required String exceptionMsg})
      : super(title: "No Internet", msg: exceptionMsg);
}

class FetchDataException extends AppException {
  FetchDataException({required String exceptionMsg})
      : super(title: "Fetch Error", msg: exceptionMsg);
}

class BadRequestException extends AppException {
  BadRequestException({required String exceptionMsg})
      : super(title: "Bad Request", msg: exceptionMsg);
}

class UnAuthorisedException extends AppException {
  UnAuthorisedException({required String exceptionMsg})
      : super(title: "Unauthorized", msg: exceptionMsg);
}

class ServerException extends AppException {
  ServerException({required String exceptionMsg})
      : super(title: "Server Error", msg: exceptionMsg);
}