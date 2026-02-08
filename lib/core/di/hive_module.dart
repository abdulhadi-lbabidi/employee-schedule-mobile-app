import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

@module
abstract class HiveModule {
  @preResolve
  @lazySingleton
  Future<Box<Map>> get loanBox async {
    return await Hive.openBox<Map>('loan_box');
  }
}
