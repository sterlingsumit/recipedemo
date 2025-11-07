import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String city;
  final String country;
  final double latitude;
  final double longitude;

  const Location({
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  String get displayName => '$city, $country';

  @override
  List<Object> get props => [city, country, latitude, longitude];
}
