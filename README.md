# helloYou!

<p align="center">
  <img src="/images/home.png" width="30%" />
  <img src="/images/chat.png" width="30%" />
  <img src="/images/profile" width="30%" />
</p>

helloYou! is a real-time chat application built with Flutter and Firebase. It allows users to sign in with their Google account, exchange messages instantly, share images, and receive push notifications. The app is built using Material 3 and focuses on providing a clean, responsive, and user-friendly messaging experience.

## Features

* Google Sign-In authentication
* Real-time messaging with Cloud Firestore
* One-to-one and group chats
* Image sharing using Firebase Storage
* Push notifications with Firebase Cloud Messaging (FCM)
* User profiles
* Online and offline user status
* Read receipts
* Material 3 interface
* Fast and responsive performance

## Tech Stack

* Flutter
* Dart
* Firebase Authentication
* Cloud Firestore
* Firebase Storage
* Firebase Cloud Messaging (FCM)
* Google Sign-In

## Getting Started

### Prerequisites

* Flutter SDK
* Android Studio or Visual Studio Code
* Firebase project
* Android emulator or physical device

### Installation

Clone the repository:

```bash
git clone https://github.com/souravChandKobi/helloYou.git
```

Navigate to the project:

```bash
cd helloYou
```

Install the dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

## Firebase Setup

1. Create a Firebase project.
2. Register your Android application.
3. Download the `google-services.json` file.
4. Place the file inside the `android/app/` directory.
5. Enable:

   * Authentication (Google Sign-In)
   * Cloud Firestore
   * Firebase Storage
   * Firebase Cloud Messaging

## Screenshots

Place your screenshots in a `screenshots` folder.

```text
screenshots/
├── login.png
├── chats.png
├── group_chat.png
├── conversation.png
└── profile.png
```

## Planned Features

* Voice messages
* Video calling
* Message reactions
* Dark mode
* End-to-end encryption

## Author

**KobiW**

GitHub: https://github.com/souravChandKobi
