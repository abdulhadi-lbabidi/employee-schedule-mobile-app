import 'package:geolocator/geolocator.dart';

class LocationService {
  /// التحقق من صلاحيات الموقع والحصول على الموقع الحالي
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // التأكد من تفعيل خدمة الموقع
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'خدمة الموقع الجغرافي معطلة، يرجى تفعيلها من الإعدادات.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'تم رفض صلاحية الوصول للموقع الجغرافي.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'صلاحيات الموقع مرفوضة نهائياً، يرجى تفعيلها من إعدادات الهاتف.';
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// التحقق مما إذا كان المستخدم داخل النطاق الجغرافي للورشة
  bool isWithinRange({
    required double userLat,
    required double userLng,
    required double targetLat,
    required double targetLng,
    required double radiusInMeters,
  }) {
    final double distanceInMeters = Geolocator.distanceBetween(
      userLat,
      userLng,
      targetLat,
      targetLng,
    );

    return distanceInMeters <= radiusInMeters;
  }

  /// حساب المسافة بين نقطتين بالمتر
  double calculateDistance(double startLat, double startLng, double endLat, double endLng) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }
}
