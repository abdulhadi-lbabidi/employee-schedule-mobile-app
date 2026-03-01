import 'package:flutter/cupertino.dart'; // Keep this import as debugPrint is used
import 'package:hive/hive.dart';
import 'package:untitled8/common/helper/src/typedef.dart';
import 'package:untitled8/core/unified_api/error_handler.dart';
import '../../../../core/hive_service.dart';

import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_locale_data_sources.dart';
import '../datasources/notification_remote_data_source.dart';
import '../model/get_all_notifications_response.dart';
import '../model/notification_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl
    with HandlingException
    implements NotificationRepository {
  final NotificationRemoteDataSourceImpl _remoteDataSource;
  final NotificationLocaleDataSources _localeDataSources;

  NotificationRepositoryImpl({
    required NotificationRemoteDataSourceImpl remoteDataSource,
    required NotificationLocaleDataSources localeDataSources,
  }) : _remoteDataSource = remoteDataSource,
       _localeDataSources = localeDataSources; // Assuming this is correct
  @override
  DataResponse<void> sendNotification(BodyMap params) async =>
      wrapHandlingException(
        tryCall: () => _remoteDataSource.sendNotification(params),
      );

  @override
  DataResponse<void> checkInWorkshop(BodyMap params) async =>
      wrapHandlingException(tryCall: () => _remoteDataSource.checkIn(params));

  @override
  DataResponse<void> checkOutWorkshop(BodyMap params) async =>
      wrapHandlingException(tryCall: () => _remoteDataSource.checkOut(params));

  @override
  DataResponse<GetAllNotificationsResponse> getNotifications() async =>
      wrapHandlingException(
        tryCall: () => _remoteDataSource.getAllNotifications(),
        otherCall: () => _localeDataSources.getNotifications(),
      );

  @override
  Future<void> deleteNotification(String id) async {
    wrapHandlingException(
      tryCall: () => _remoteDataSource.deleteNotification(id),
    );
  }

  @override
  Future<void> deleteAllNotifications() async {
    wrapHandlingException(
      tryCall: () => _remoteDataSource.deleteAllNotification(),
    );
  }
}
