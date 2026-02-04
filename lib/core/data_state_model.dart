import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:untitled8/core/toast.dart';

enum BlocStatus { loading, success, failed, init }

class DataStateModel<T> {
  final BlocStatus status;
  final String errorMessage;
  final T data;
  final T _defultValue;

  const DataStateModel({
    this.status = BlocStatus.init,
    this.errorMessage = "",
    required this.data,
    required T defultValue,
  }) : _defultValue = defultValue;

  const DataStateModel.setDefultValue({
    this.status = BlocStatus.init,
    this.errorMessage = "",
    required T defultValue,
  }) : data = defultValue,
       _defultValue = defultValue;

  bool get isInit => status == BlocStatus.init;

  bool get isLoading =>
      status == BlocStatus.loading || status == BlocStatus.init;

  bool get isFailed => status == BlocStatus.failed;

  bool get isSuccess => status == BlocStatus.success;

  DataStateModel<T> setLoading() =>
      copyWith(status: BlocStatus.loading, data: _defultValue);

  DataStateModel<T> setFaild({required String errorMessage}) =>
      copyWith(status: BlocStatus.failed, errorMessage: errorMessage);

  DataStateModel<T> setSuccess({T? data}) =>
      copyWith(data: data, status: BlocStatus.success);

  DataStateModel<T> resetData() => DataStateModel<T>(
    status: BlocStatus.init,
    errorMessage: "",
    data: _defultValue,
    defultValue: _defultValue,
  );

  void listenerFunction({
    VoidCallback? onLoading,
    VoidCallback? onFailed,
    required VoidCallback onSuccess,
  }) {
    Toaster.closeAllLoading();
    if (status == BlocStatus.loading) {
      Toaster.showLoading();
      onLoading?.call();
    } else if (status == BlocStatus.failed) {
      BotToast.showText(text: errorMessage);

      onFailed?.call();
    } else if (status == BlocStatus.success) {
      onSuccess();
    }
  }

  void listenerWithOutLoadingFunction({
    VoidCallback? onLoading,
    VoidCallback? onFailed,
    required VoidCallback onSuccess,
  }) {
    Toaster.closeAllLoading();
    if (status == BlocStatus.loading) {
    } else if (status == BlocStatus.failed) {
      BotToast.showText(text: errorMessage);

      onFailed?.call();
    } else if (status == BlocStatus.success) {
      onSuccess();
    }
  }

  Widget builder({
    Widget? loadingWidget,
    Widget? failedWidget,
    VoidCallback? onTapRetry,
    required Widget Function(T data) onSuccess,
  }) {
    if (failedWidget == null && onTapRetry == null) {
      throw ArgumentError(
        'Either failed widget or onTapRetry must be provided.',
      );
    }

    if (isSuccess) {
      return onSuccess(data);
    }
    if (isLoading) {
      return loadingWidget ?? const LoadingWidget();
    } else {
      return failedWidget ?? Text('failed');
    }
  }

  @override
  String toString() =>
      'DataStateModel(status: $status, errorMessage: $errorMessage, data: $data)';

  DataStateModel<T> copyWith({
    BlocStatus? status,
    String? errorMessage,
    T? data,
  }) {
    return DataStateModel<T>(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
      defultValue: _defultValue,
    );
  }

  @override
  bool operator ==(covariant DataStateModel<T> other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        other.errorMessage == errorMessage &&
        other.data == data &&
        other._defultValue == _defultValue;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        errorMessage.hashCode ^
        data.hashCode ^
        _defultValue.hashCode;
  }
}
