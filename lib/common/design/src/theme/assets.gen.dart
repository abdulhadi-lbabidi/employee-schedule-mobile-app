/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImageGen {
  const $AssetsImageGen();

  /// File path: assets/image/Home.png
  AssetGenImage get home => const AssetGenImage('assets/image/Home.png');

  /// File path: assets/image/biuilding.png
  AssetGenImage get biuilding =>
      const AssetGenImage('assets/image/biuilding.png');

  $AssetsImageGifGen get gif => const $AssetsImageGifGen();
  $AssetsImageLogGen get log => const $AssetsImageLogGen();

  /// File path: assets/image/project02.png
  AssetGenImage get project02 =>
      const AssetGenImage('assets/image/project02.png');

  /// File path: assets/image/project03.png
  AssetGenImage get project03 =>
      const AssetGenImage('assets/image/project03.png');

  /// File path: assets/image/project09.png
  AssetGenImage get project09 =>
      const AssetGenImage('assets/image/project09.png');

  /// File path: assets/image/project16.png
  AssetGenImage get project16 =>
      const AssetGenImage('assets/image/project16.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [home, biuilding, project02, project03, project09, project16];
}

class $AssetsImageGifGen {
  const $AssetsImageGifGen();

  /// File path: assets/image/gif/logogif.gif
  AssetGenImage get logogif =>
      const AssetGenImage('assets/image/gif/logogif.gif');

  /// List of all assets
  List<AssetGenImage> get values => [logogif];
}

class $AssetsImageLogGen {
  const $AssetsImageLogGen();

  /// File path: assets/image/log/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/image/log/logo.png');

  /// File path: assets/image/log/logoapp.png
  AssetGenImage get logoapp =>
      const AssetGenImage('assets/image/log/logoapp.png');

  /// List of all assets
  List<AssetGenImage> get values => [logo, logoapp];
}

class Assets {
  Assets._();

  static const $AssetsImageGen image = $AssetsImageGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
