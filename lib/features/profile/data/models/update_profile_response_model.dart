import '../../../auth/data/model/login_response.dart';

class UpdateProfileResponseModel {
  final String message;
  final User? user;
  final int status;

  UpdateProfileResponseModel({
    required this.message,
    this.user,
    required this.status,
  });

  factory UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponseModel(
      message: json['message'] ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      status: json['status'] ?? 0,
    );
  }
}
