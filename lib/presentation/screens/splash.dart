import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_discovery_app/core/routes/app_router.dart';
import 'package:recipe_discovery_app/presentation/blocs/location/location_bloc.dart';
import 'package:recipe_discovery_app/presentation/blocs/location/location_event.dart';
import 'package:recipe_discovery_app/presentation/blocs/location/location_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationBloc(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFF6B35),
        body: BlocConsumer<LocationBloc, LocationState>(
          listener: (context, state) async {
            if (state is LocationError) {
              String error = state.message;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error),
                  backgroundColor: Colors.redAccent,
                  duration: const Duration(seconds: 3),
                ),
              );
            }

            if (state is LocationLoaded) {
              // Navigate to next screen (Home or Main)
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.pushNamedAndRemoveUntil(context, AppRouter.homeScreen,(value)=>true,arguments: state.address);
              });
            }
          },
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.restaurant_menu,
                      size: 60,
                      color: Color(0xFFFF6B35),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // App Name
                  const Text(
                    "Recipe App",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Discover Delicious Recipes',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Loading Indicator
                  Column(
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        state is LocationLoading
                            ? 'Getting your location...'
                            : state is LocationError
                            ? 'Location unavailable'
                            : 'Preparing your recipes...',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
