import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart' as AppSettings;

import 'location_event.dart';
import 'location_state.dart';


class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<GetLocationEvent>(_onGetLocation);
    add(GetLocationEvent());
    _lifecycleStateStream().listen((
        AppLifecycleState state
        ) async {
      if(state == AppLifecycleState.resumed){
        await Future.delayed(const Duration(seconds: 1),(){
          add(GetLocationEvent());
        });
      }
    });
  }

  Stream<AppLifecycleState> _lifecycleStateStream() async*{
    final binding = WidgetsBinding.instance;
    yield binding.lifecycleState ?? AppLifecycleState.resumed;
    final lifecycleStreamController = StreamController<AppLifecycleState>();
    binding.addObserver(_AppLifecycleObserver(lifecycleStreamController));
    yield* lifecycleStreamController.stream;
  }

  Future<void> _onGetLocation(
      GetLocationEvent event,
      Emitter<LocationState> emit,
      ) async {
    emit(LocationLoading());

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(const LocationError('Location services are disabled.'));
        await Geolocator.openLocationSettings();

        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(LocationPermissionDenied());
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(const LocationError(
            'Location permissions are permanently denied. Enable from settings.'));
        return;
      }

      // Step 2: Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Step 3: Reverse geocode to get address
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address =
            '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';

        emit(LocationLoaded(address));
      } else {
        emit(const LocationError('Unable to fetch location'));
      }
    } catch (e) {
      emit(const LocationError("Please check you internet connection"));
    }
  }
}

class _AppLifecycleObserver  extends WidgetsBindingObserver{
  final StreamController<AppLifecycleState> controller;

  _AppLifecycleObserver(this.controller);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    controller.add(state);
  }
}
