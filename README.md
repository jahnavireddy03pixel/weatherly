# 🌦️ Weatherly – Smart Weather Explorer

Weatherly is a responsive weather application developed using **Flutter and Dart** as part of a User Interface Design (UID) project. It provides real-time weather information for different cities through the Open-Meteo API, with a clean interface and dynamic weather cards.

The application allows users to explore weather conditions, search for cities, view detailed weather information, manage favorite cities, and switch between light and dark themes.

## ✨ Features

- **Real-Time Weather Updates:** Fetches current weather information using the Open-Meteo API.
- **City Search:** Search for cities worldwide using the Open-Meteo Geocoding API.
- **Weather Cards:** Displays temperature, weather conditions, city name, and local time.
- **Weather Details:** Provides additional information such as:
  - Current temperature
  - Feels-like temperature
  - Humidity
  - Wind speed
  - Rain probability
- **Favorite Cities:** Mark and access favorite cities easily.
- **Local Time:** Displays the local time of the selected city.
- **Dark Mode:** Switch between light and dark themes.
- **Responsive UI:** Adapts the layout to different screen sizes.
- **Add City Screen:** Includes a form with input validation.

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| Flutter | Application development framework |
| Dart | Programming language |
| Provider | State management |
| HTTP | API integration and network requests |
| Open-Meteo API | Weather data |
| Open-Meteo Geocoding API | City search |

## 🌐 APIs Used

**1. Open-Meteo Weather API**

Used to retrieve current weather information based on the latitude and longitude of a city.

API: https://api.open-meteo.com/v1/forecast

**2. Open-Meteo Geocoding API**

Used to search for cities and retrieve their geographical coordinates.

API: https://geocoding-api.open-meteo.com/v1/search

Both APIs are free to use for this project, and no API key is required.

## 📁 Project Structure

```text
weatherly/
│
├── lib/
│   ├── main.dart
│   │
│   ├── models/
│   │   ├── city.dart
│   │   └── weather.dart
│   │
│   ├── providers/
│   │   └── favorites_provider.dart
│   │
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── add_city_screen.dart
│   │   ├── settings_screen.dart
│   │   └── weather_details_screen.dart
│   │
│   ├── services/
│   │   └── weather_service.dart
│   │
│   ├── theme/
│   │   └── app_theme.dart
│   │
│   ├── utils/
│   │   └── weather_utils.dart
│   │
│   └── widgets/
│       ├── weather_card.dart
│       ├── section_title.dart
│       └── stat_tile.dart
│
├── android/
├── ios/
├── linux/
├── macos/
├── web/
├── windows/
│
├── test/
├── pubspec.yaml
└── README.md
```

## 🚀 Getting Started

Follow these steps to run the project on your local machine.

### Prerequisites

- Flutter SDK (compatible with Dart 3.8 or higher)
- Dart SDK
- Visual Studio Code or Android Studio
- Android Emulator or a physical device

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/jahnavireddy03pixel/weatherly.git
```

**2. Navigate to the project directory**

```bash
cd weatherly
```

**3. Install dependencies**

```bash
flutter pub get
```

**4. Run the application**

```bash
flutter run
```

No API key configuration is required.

## ⚙️ How It Works

1. The application displays weather cards for selected cities.
2. Users can search for other cities using the search bar.
3. The Geocoding API retrieves the city's name, country, latitude, and longitude.
4. The Weather API uses the geographical coordinates to fetch current weather information.
5. The application displays the retrieved information through dynamic weather cards.
6. Users can open a city's details, mark cities as favorites, and customize the app theme.

## 🎯 Project Objective

The main objective of Weatherly is to develop a user-friendly and responsive weather application while gaining practical experience in Flutter development, REST API integration, state management, asynchronous programming, and responsive UI design.

## 👩‍💻 Developed By

**Jahnavi Reddy**

GitHub: https://github.com/jahnavireddy03pixel

---

⭐ If you find this project interesting, feel free to explore the repository!
