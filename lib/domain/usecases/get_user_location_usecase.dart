import 'package:dartz/dartz.dart';
import 'package:recipe_discovery_app/core/errors/failures.dart';
import 'package:recipe_discovery_app/domain/entities/location.dart';
import 'package:recipe_discovery_app/domain/repositories/location_repository.dart';

class GetUserLocationUseCase {
  final LocationRepository repository;

  GetUserLocationUseCase({required this.repository});

  Future<Either<Failure, Location>> call() async {
    // Check permission first
    final permissionResult = await repository.checkLocationPermission();
    
    return permissionResult.fold(
      (failure) => Left(failure),
      (hasPermission) async {
        if (!hasPermission) {
          // Request permission
          final requestResult = await repository.requestLocationPermission();
          return requestResult.fold(
            (failure) => Left(failure),
            (granted) async {
              if (granted) {
                return await repository.getUserLocation();
              } else {
                return const Left(
                  LocationFailure('Location permission denied'),
                );
              }
            },
          );
        } else {
          return await repository.getUserLocation();
        }
      },
    );
  }
}
