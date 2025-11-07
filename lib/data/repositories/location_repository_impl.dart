import 'package:dartz/dartz.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:recipe_discovery_app/core/errors/failures.dart';
import 'package:recipe_discovery_app/domain/entities/location.dart' as app;
import 'package:recipe_discovery_app/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<Either<Failure, app.Location>> getUserLocation() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const Left(
          LocationFailure('Location services are disabled'),
        );
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      // Reverse geocode to get city and country
      try {
        final placemarks = await geocoding.placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          
          final city = placemark.locality ?? 
                       placemark.subAdministrativeArea ?? 
                       placemark.administrativeArea ?? 
                       'Unknown City';
                       
          final country = placemark.country ?? 'Unknown Country';

          return Right(
            app.Location(
              city: city,
              country: country,
              latitude: position.latitude,
              longitude: position.longitude,
            ),
          );
        } else {
          return Right(
            app.Location(
              city: 'Unknown City',
              country: 'Unknown Country',
              latitude: position.latitude,
              longitude: position.longitude,
            ),
          );
        }
      } catch (e) {
        // If reverse geocoding fails, return location with coordinates only
        return Right(
          app.Location(
            city: 'Unknown City',
            country: 'Unknown Country',
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );
      }
    } on PermissionDeniedException {
      return const Left(
        LocationFailure('Location permission denied'),
      );
    } on LocationServiceDisabledException {
      return const Left(
        LocationFailure('Location services are disabled'),
      );
    } catch (e) {
      return Left(
        LocationFailure('Failed to get location: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> checkLocationPermission() async {
    try {
      final permission = await Geolocator.checkPermission();
      return Right(
        permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse,
      );
    } catch (e) {
      return Left(
        LocationFailure('Failed to check permission: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> requestLocationPermission() async {
    try {
      final permission = await Geolocator.requestPermission();
      return Right(
        permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse,
      );
    } catch (e) {
      return Left(
        LocationFailure('Failed to request permission: $e'),
      );
    }
  }
}
