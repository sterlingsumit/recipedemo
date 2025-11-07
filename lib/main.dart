import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_discovery_app/core/routes/app_router.dart';
import 'package:recipe_discovery_app/core/services/hive_service.dart';
import 'package:recipe_discovery_app/presentation/screens/splash.dart';

import 'data/datasources/recipe_api_data_source.dart';
import 'data/datasources/recipe_local_data_source.dart';
import 'data/repositories/recipe_repository_impl.dart';

final httpClient = http.Client();
final apiDataSource = RecipeApiDataSourceImpl(client: httpClient);

// Create Local Data Source
final localDataSource = RecipeLocalDataSourceImpl();

// Create Repository with both data sources
final recipeRepository = RecipeRepositoryImpl(
  remoteDataSource: apiDataSource,
  localDataSource: localDataSource,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  HiveService.init();


  runApp(RepositoryProvider(
    create: (context) => recipeRepository,
    child: const RecipeDiscoveryApp(),
  ));
}

class RecipeDiscoveryApp extends StatelessWidget {
  const RecipeDiscoveryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Discovery',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: AppRouter.generateRoute,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: const Color(0xFFFF6B35),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
        home: const SplashScreen(),
    );
  }
}
