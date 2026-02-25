import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import '../../common/helper/src/location_service.dart';
import '../../features/admin/data/models/workshop_models/workshop_model.g.dart';
import '../toast.dart';

class LocationChecker {
  static Future<void> checkUserProximity({
    required BuildContext context,
    required WorkshopModel workshop,
    VoidCallback? onWithinRange,
  }) async {
    if (workshop.location == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ورشة العمل لا تحتوي على موقع")),
      );
      return;
    }

    try {
      // ✅ إظهار اللودينغ
      Toaster.showLoading();

      final LocationData? userLocation =
      await LocationServiceMain.getUserLocation().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException("انتهت مهلة جلب الموقع");
        },
      );

      if (userLocation == null ||
          userLocation.latitude == null ||
          userLocation.longitude == null) {
        Toaster.closeAllLoading(); // ✨ إغلاق اللودينغ عند الخطأ
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("تعذر الحصول على موقعك."),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final double distance = Geolocator.distanceBetween(
        userLocation.latitude!,
        userLocation.longitude!,
        // 18.252900,
        // 17.252100,
        workshop.latitude!,
        workshop.longitude!,
      );

      // ❌ خارج المجال
      if (distance > workshop.radiusInMeters!) {
        Toaster.closeAllLoading(); // ✨ إغلاق اللودينغ عند الخطأ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "أنت خارج نطاق الورشة (${distance.toStringAsFixed(1)} متر). الوصول مرفوض.",
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // ✅ داخل المجال – لا يتم إغلاق اللودينغ هنا
      if (onWithinRange != null) {
        onWithinRange();
      }
    } on TimeoutException {
      Toaster.closeAllLoading(); // ✨ إغلاق اللودينغ عند Timeout
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("انتهت مهلة تحديد الموقع. حاول مرة أخرى."),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      Toaster.closeAllLoading(); // ✨ إغلاق اللودينغ عند أي خطأ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("حدث خطأ: $e"),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}





