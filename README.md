# Privae – Get a Personal Chef

A comprehensive Flutter-based marketplace platform that bridges the gap between professional **Chefs** and **Customers**. This app facilitates seamless discovery, booking, and management of private culinary services and home-cooked meal experiences.

## 🚀 Overview

The Privae App is built with a scalable feature-based architecture using **GetX** for state management. It provides a specialized experience for two distinct user types:
1.  **Customers**: Who can discover chefs, manage dietary preferences, and book personalized meals.
2.  **Chefs**: Who can showcase their culinary skills, manage their menus, and track their business analytics.

---

## ✨ Key Features

### 👤 Customer Features
*   **Discovery & Search**: Browse various cuisines and search for chefs or kitchens nearby.
*   **Chef Details**: View detailed chef profiles, including their specialties, ratings, and reviews.
*   **Cart & Checkout**: Streamlined ordering process with support for promo codes and tax detail management (Personal/Business).
*   **Booking Management**: Request changes to bookings and track order status in real-time.
*   **Preferences**: Set and manage dietary restrictions and preferences.
*   **Address Management**: Easily add, edit, and manage multiple delivery/service locations.
*   **Payment Integration**: Securely manage payment methods and cards.
*   **Kitchen & Equipment**: Options to manage kitchen settings and equipment availability.
*   **Orders & Reviews**: Reorder past favorites and leave feedback for chefs.

### 👨‍🍳 Chef Features
*   **Professional Dashboard**: Overview of bookings, earnings, and business analytics.
*   **Menu Management**: Create, edit, and organize menus with ease.
*   **Availability Control**: Set and manage work schedules and availability for bookings.
*   **Booking Control**: Accept or manage customer requests and booking changes.
*   **Public Profile**: Showcase culinary expertise and update kitchen locations.
*   **Financial Management**: track earnings, manage withdrawal methods, and view transaction history.

### 🌐 Common Features
*   **Real-time Notifications**: Instant alerts for bookings, messages, and order updates.
*   **In-App Messaging**: Direct communication channel between chefs and customers via Socket.io.
*   **Secure Authentication**: robust sign-up/sign-in flows, including email verification and password recovery.
*   **Onboarding**: Interactive onboarding screens for a smooth user introduction.

---

## 🛠 Tech Stack

-   **Framework**: [Flutter](https://flutter.dev/)
-   **State Management & Routing**: [GetX](https://pub.dev/packages/get)
-   **Networking**: [Dio](https://pub.dev/packages/dio) with [Pretty Dio Logger](https://pub.dev/packages/pretty_dio_logger)
-   **Backend & Auth**: [Firebase](https://firebase.google.com/) (Core, Auth)
-   **Real-time Communication**: [Socket.io Client](https://pub.dev/packages/socket_io_client)
-   **Location Services**: [Google Maps Flutter](https://pub.dev/packages/google_maps_flutter), [Geolocator](https://pub.dev/packages/geolocator), [Geocoding](https://pub.dev/packages/geocoding)
-   **Local Storage**: [Hive](https://pub.dev/packages/hive) & [Shared Preferences](https://pub.dev/packages/shared_preferences)
-   **UI & Design**: 
    -   [Flutter ScreenUtil](https://pub.dev/packages/flutter_screenutil) for responsiveness.
    -   [Google Fonts](https://pub.dev/packages/google_fonts) for typography.
    -   [Cached Network Image](https://pub.dev/packages/cached_network_image) for image loading.
    -   [Lottie](https://pub.dev/packages/lottie) & [SVG](https://pub.dev/packages/flutter_svg) for animations and icons.
-   **Utils**: [Intl](https://pub.dev/packages/intl) for formatting, [Image Picker/Cropper](https://pub.dev/packages/image_picker) for media handling.

---

## 🏗 Project Structure

The project follows a clean **Feature-based Architecture**:

```text
lib/
├── config/             # Routes, Themes, Dependencies, API Endpoints
├── features/           # Core business logic separated by role
│   ├── chef/           # Menu, Availability, Analytics, Booking
│   ├── customer/       # Home, Cart, Kitchen, Profile, Order
│   └── common/         # Auth, Notifications, Messaging, Splash
├── services/           # Socket, Notifications, Local Storage services
├── utils/              # Extensions, Constants, App Images/Colors
├── component/          # Shared UI widgets (CommonText, CommonImage, etc.)
└── main.dart           # App entry point & initialization
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (^3.7.2)
- Android Studio / VS Code
- Firebase Project setup

### Installation
1.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    ```
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Environment Setup**:
    - Add your `.env` file to the root directory.
    - Setup `google_services.json` (Android) and `GoogleService-Info.plist` (iOS) from Firebase.
4.  **Run the app**:
    ```bash
    flutter run
    ```

---

## 📄 License
This project is for private use as part of the Privae platform.
