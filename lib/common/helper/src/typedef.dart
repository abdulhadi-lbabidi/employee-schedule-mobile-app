import 'package:dartz/dartz.dart';
import '../../../core/unified_api/failures.dart';


typedef FromJson<T> = T Function(dynamic body);

typedef QueryParams = Map<String, String?>;

typedef BodyMap = Map<String, dynamic>;

typedef DataResponse<T> = Future<Either<Failure, T>>;

typedef DataStreamResponse<T> = Stream<Either<Failure ,T>> ;
