import '../entities/admin_profile_entity.dart';

abstract class AdminProfileRepository {
  Future<AdminProfileEntity> getAdminProfile();
  Future<void> updateAdminProfile(AdminProfileEntity profile);
}
