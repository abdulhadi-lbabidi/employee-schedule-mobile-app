import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import '../../data/repository/app_repository.dart';

// @lazySingleton
// class SyncService {
//   final AppRepository _repository;
//   final Connectivity _connectivity;
//   StreamSubscription? _subscription;
//
//   SyncService(this._repository, this._connectivity);
//
//   void init() {
//     _subscription = _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
//       if (results.isNotEmpty && !results.contains(ConnectivityResult.none)) {
//         _repository.syncPending();
//       }
//     });
//
//     // Initial sync attempt when service starts
//     _repository.syncPending();
//   }
//
//   void dispose() {
//     _subscription?.cancel();
//   }
// }
