import 'package:equatable/equatable.dart';

class AdminProfileEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String position;
  final String department;
  final String? profileImageUrl;

  const AdminProfileEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.position,
    required this.department,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [id, fullName, email, phoneNumber, position, department, profileImageUrl];
}
