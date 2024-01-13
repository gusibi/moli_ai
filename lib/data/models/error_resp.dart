class ErrorResp {
  final int code;
  final String message;
  final String status;

  ErrorResp({required this.code, required this.message, required this.status});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    data['code'] = code;
    return data;
  }

  factory ErrorResp.fromJson(Map<String, dynamic> json) {
    return ErrorResp(
      code: json['code'] as int,
      message: json['message'] as String,
      status: json['status'] as String,
    );
  }
  factory ErrorResp.fromAzureJson(Map<String, dynamic> json) {
    return ErrorResp(
      code: -1,
      message: json['message'] as String,
      status: json['code'] as String,
    );
  }
}
