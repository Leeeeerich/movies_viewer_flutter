class Status {
  final bool isSuccessful;
  final int rawCode;
  final String message;
  final String method;
  final String request;

  Status(this.isSuccessful, this.rawCode,
      {this.message, this.method, this.request});

  get code {
    for (var i = 0; i < ListCode.length; i++) {
      var element = ListCode.entries.elementAt(i);
      if (element.value.contains(rawCode)) {
        return element.key;
      }
    }
    return Code.unknown_error;
  }
}

enum Code {
  ok,
  not_found,
  conflict,
  server_error,
  unauthorized_error,
  bad_request_error,
  unknown_error,
  no_internet_connection,
  internet_connection_timeout
}

const Map<Code, List<int>> ListCode = {
  Code.ok: [200],
  Code.not_found: [404, 410],
  Code.conflict: [409],
  Code.server_error: [
    500,
    501,
    502,
    503,
    504,
    505,
    506,
    507,
    508,
    509,
    510,
    511,
    520,
    521,
    522,
    523,
    524,
    525,
    526
  ],
  Code.unauthorized_error: [401],
  Code.bad_request_error: [400],
  Code.unknown_error: [0],
  Code.no_internet_connection: [-1],
  Code.internet_connection_timeout: [-2]
};
