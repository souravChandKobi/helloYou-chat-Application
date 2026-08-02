# helloYou!

helloYou! is a Flutter-based real-time chat application built using Firebase. It allows users to sign in with their Google account, exchange messages instantly, share images, and receive push notifications through Firebase Cloud Messaging. The application is designed with a simple and responsive Material 3 interface.

## Features

* Google Sign-In authentication
* Real-time messaging using Cloud Firestore
* Image sharing with Firebase Storage
* Firebase Cloud Messaging (FCM) support
* User profiles
* Online and offline user status
* Clean Material 3 interface
* Fast and responsive performance

## Built With

* Flutter
* Dart
* Firebase Authentication
* Cloud Firestore
* Firebase Storage
* Firebase Cloud Messaging
* Google Sign-In

## Project Structure

```text
lib/
├── api/
├── blocs/
├── models/
├── screens/
├── services/
├── utils/
├── widgets/
└── main.dart
```

## Getting Started

### Prerequisites

* Flutter SDK
* Android Studio or Visual Studio Code
* A Firebase project
* Android Emulator or a physical Android device

### Installation

Clone the repository:

```bash
git clone https://github.com/souravChandKobi/helloYou.git
```

Navigate to the project:

```bash
cd helloYou
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

## Firebase Configuration

1. Create a Firebase project.
2. Register your Android application.
3. Download the `google-services.json` file.
4. Place it inside the `android/app/` directory.
5. Enable the following Firebase services:

   * Authentication (Google Sign-In)
   * Cloud Firestore
   * Firebase Storage
   * Firebase Cloud Messaging

## Screenshots

Add screenshots of the application here.

```text
screenshots/
├── login.png
├── chats.png
├── conversation.png
└── profile.png
```

## Future Improvements

* Group chats
* Voice messages
* Video calling
* Read receipts
* Message reactions
* Dark mode
* End-to-end encryption

## Contributing

Contributions are welcome. Feel free to fork the repository, make improvements, and submit a pull request.

## License

This project is licensed under the MIT License.

## Author

KobiW

GitHub: https://github.com/souravChandKobi
