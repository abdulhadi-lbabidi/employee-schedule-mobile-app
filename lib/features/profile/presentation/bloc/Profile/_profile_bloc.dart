import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Attendance/Repository/AttendanceRepository.dart';
import '../../../../auth/data/repository/login_repo.dart';
import '../../../data/models/profile_model.dart';
import '_profile_event.dart';
import '_profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthRepository authRepository;
  final AttendanceRepository attendanceRepository;

  String? _cachedImagePath; // 🔹 متغير لحفظ مسار الصورة محلياً

  ProfileBloc({
    required this.authRepository,
    required this.attendanceRepository,
  }) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfileImage>(_onUpdateProfileImage); // 🔹 معالجة حدث تحديث الصورة
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final user = await authRepository.getCurrentUser();

      if (user != null) {
        final records = await attendanceRepository.getAllRecords(); // 🔹 تم إضافة await

        double totalHours = 0;
        for (var r in records) {
          if (r.workDuration != null) {
            totalHours += r.workDuration!.inMinutes / 60.0;
          }
        }

        final activeDays = records.map((r) => r.date).toSet().length;
        String lastWS = records.isNotEmpty
            ? "W${records.last.workshopNumber}"
            : "لم يحدد بعد";
        final isIdmin = user.userableType?.toLowerCase() == 'admin';

        // lib/features/profile/presentation/bloc/Profile/_profile_bloc.dart

        final profile = ProfileModel(
          user: User(
            id: user.id,
            fullName: user.fullName,
            phoneNumber: user.phoneNumber,
            email: user.email,
            profileImageUrl: _cachedImagePath ?? user.profileImageUrl, // استخدام الصورة المخزنة أو القادمة من الباك
            userable: Userable(
              id: user.userableId,
              position: user.userable?.name ?? (isIdmin ? "المدير العام (CEO)" : "موظف ميداني"),
              department: isIdmin ? "مجلس الإدارة" : "قسم العمليات",
              hourlyRate: user.userable?.hourlyRate?.toDouble(),
              overtimeRate: user.userable?.overtimeRate?.toDouble(),
            ),
          ),
          role: user.userableType,
          status: 1, // حالة نشطة افتراضية
        );

        emit(
          ProfileLoaded(
            profile: profile,
            totalHours: double.parse(totalHours.toStringAsFixed(1)),
            activeDays: activeDays,
            lastWorkshop: lastWS,
          ),
        );
      } else {
        emit(const ProfileError("فشل في تحميل بيانات المستخدم"));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // 🔹 إضافة معالج حدث تحديث الصورة
  Future<void> _onUpdateProfileImage(
    UpdateProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    _cachedImagePath = event.imagePath;
    add(
      LoadProfile(),
    ); // إعادة تحميل الملف الشخصي لتحديث الواجهة بالصورة الجديدة
  }
}
