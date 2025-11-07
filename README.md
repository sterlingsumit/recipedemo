# Recipe Discovery App

A beautiful Flutter application for discovering and exploring recipes with Clean Architecture, BLoC pattern, and offline caching support.

## Features

- 🍳 **Recipe Discovery**: Browse popular, quick & easy, and vegetarian recipes
- 🔍 **Smart Search**: Search recipes by name or ingredient
- 📍 **Location-based**: Shows user's current city and country
- 📱 **Responsive Design**: Works seamlessly on both Android and iOS
- 🔄 **Pull to Refresh**: Refresh all recipe sections with a simple gesture
- 📖 **Pagination**: Load more recipes as you scroll
- 💾 **Offline Support**: Caches data for offline viewing
- ⚡ **Performance**: Optimized loading with shimmer effects and cached images

## Architecture

The app follows **Clean Architecture** principles with clear separation of concerns:

### Layers

1. **Presentation Layer**
    - UI components (Screens, Widgets)
    - State Management (BLoC/Cubit)
    - User interaction handling

2. **Domain Layer**
    - Business logic
    - Entities
    - Use Cases
    - Repository interfaces

3. **Data Layer**
    - Repository implementations
    - Data sources (Remote & Local)
    - Models with JSON serialization
    - Caching logic

## Tech Stack

- **Flutter**: Latest stable version
- **State Management**: flutter_bloc (BLoC pattern)
- **Network**: http for API calls
- **Local Storage**: hive for caching
- **Location**: geolocator & geocoding
- **Functional Programming**: dartz for Either type
- **UI**: cached_network_image

## Setup Instructions

### Prerequisites

1. Flutter SDK (3.0.0 or higher)
2. Dart SDK
3. Android Studio / Xcode (for device emulators)
4. Spoonacular API Key

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd recipe_discovery_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API Key**

   Open `lib/core/constants/api_constants.dart` and replace `YOUR_API_KEY_HERE` with your actual Spoonacular API key:
   ```dart
   static const String apiKey = 'YOUR_ACTUAL_API_KEY';
   ```

   To get an API key:
    - Visit [Spoonacular API](https://spoonacular.com/food-api)
    - Sign up for a free account
    - Navigate to your dashboard to get the API key

4. **Run code generation** (if needed)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Setup Platform-specific configurations**

   **iOS**:
    - Add location permission in `ios/Runner/Info.plist`:
   ```xml
   <key>NSLocationWhenInUseUsageDescription</key>
   <string>This app needs access to location to show your current city.</string>
   ```

   **Android**:
    - Permissions are already configured in the manifest

6. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/
│   ├── constants/      # API constants and app configuration
│   ├── di/             # Dependency injection setup
│   └── errors/         # Failure classes
├── data/
│   ├── datasources/    # Remote and Local data sources
│   ├── models/         # Data models with Hive adapters
│   └── repositories/   # Repository implementations
├── domain/
│   ├── entities/       # Business entities
│   ├── repositories/   # Repository contracts
│   └── usecases/       # Business logic use cases
├── presentation/
│   ├── blocs/          # BLoC state management
│   ├── screens/        # App screens
│   └── widgets/        # Reusable UI components
└── main.dart           # App entry point
```

## Key Features Implementation

### Caching Strategy
- **Cache-first approach**: App tries to load from cache first
- **Smart refresh**: Cache expires after 24 hours
- **Fallback mechanism**: Shows cached data when offline
- **Selective caching**: Only caches initial page loads, not paginated data




### Error Handling
- Network errors with retry options
- API rate limit handling with cached data fallback
- Location permission handling
- Empty state views

## API Endpoints Used

- **Popular Recipes**: `/recipes/random`
- **Quick Recipes**: `/recipes/complexSearch?maxReadyTime=30`
- **Vegetarian**: `/recipes/complexSearch?diet=vegetarian`
- **Search**: `/recipes/complexSearch?query={searchTerm}`

## Assumptions Made

1. **API Rate Limiting**: Implemented aggressive caching to minimize API calls (50/day limit)
2. **Recipe Difficulty**: Calculated based on cooking time as specified
3. **Rating Calculation**: Normalized likes to a 5-star rating system
4. **Image Caching**: Using cached_network_image for optimal performance
5. **Location Fallback**: Shows "Unknown City, Unknown Country" if geocoding fails
6. **Search Behavior**: Search doesn't use caching for real-time results
