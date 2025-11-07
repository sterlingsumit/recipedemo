import 'package:dartz/dartz.dart';
import 'package:recipe_discovery_app/core/errors/failures.dart';
import 'package:recipe_discovery_app/domain/entities/location.dart';

abstract class LocationRepository {
  Future<Either<Failure, Location>> getUserLocation();
  Future<Either<Failure, bool>> checkLocationPermission();
  Future<Either<Failure, bool>> requestLocationPermission();
}
