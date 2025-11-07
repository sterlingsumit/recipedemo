class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://api.spoonacular.com';
  
  // API Key - Replace with your actual API key
  static const String apiKey = 'ced1a89b71734579968484ab84cfc38a';
  
  // Endpoints
  static const String popularRecipes = '/recipes/random';
  static const String complexSearch = '/recipes/complexSearch';
  static const String autocomplete = '/recipes/autocomplete';
  
  // Default parameters
  static const int defaultLimit = 10;
  static const int quickRecipeMaxTime = 30;
  
  // Cache keys
  static const String popularRecipesCacheKey = 'popular_recipes';
  static const String quickRecipesCacheKey = 'quick_recipes';
  static const String vegetarianRecipesCacheKey = 'vegetarian_recipes';
  static const String lastFetchTimeKey = 'last_fetch_time';
  
  // Cache duration (in hours)
  static const int cacheDurationHours = 24;
}

class AppConstants {
  static const String appName = 'Recipe Discovery';
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Difficulty levels based on cooking time
  static const int easyMaxMinutes = 30;
  static const int mediumMaxMinutes = 60;
}
