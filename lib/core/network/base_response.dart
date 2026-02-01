class BaseResponse<T> {
  final T? data;
  final String? message;

  BaseResponse({this.data, this.message});

  factory BaseResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic json) fromJsonT,
      ) {
    return BaseResponse(
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'],
    );
  }
}
