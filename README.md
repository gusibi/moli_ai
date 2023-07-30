# MoliAI

MoliAI is a Google Palm client written in Flutter, designed to provide a practical learning project for personal usage. It currently supports conversations with Google Palm and offers a unique diary enhancement feature. You can input daily inspiration, messages, etc., and MoliAI will summarize your day, providing intelligent suggestions and to-do items based on the information you input.


<div>
  <img src="conversation-list.png" alt="assets/screenshots/conversation-list.png" style="display: inline-block;">
  <img src="chat-mobile.png" alt="assets/screenshots/chat-mobile.png" style="display: inline-block;">
  <img src="setting.png" alt="assets/screenshots/setting.png" style="display: inline-block;">
  <img src="setting-green.png" alt="assets/screenshots/setting-green.png" style="display: inline-block;">
</div>

## Features

- Chat with Google Palm AI assistant
- Diary assistant to summarize your day

## Tech Stack

- Flutter
- flex_color_scheme for theming
- flutter_markdown for text formatting
- sqflite for local storage

## Getting Started

To start using MoliAI, follow these steps:

1. Install Flutter
2. Clone the repository
3. Run the project using `flutter run`

## Build

### macOS

```
flutter build macos --no-tree-shake-icons
```
### android

```
flutter build apk --no-tree-shake-icons
```

## Directory Structure

```
├── lib
│   ├── main.dart
│   ├── models
│   ├── repositories
│   ├── screens
│   ├── services
│   └── widgets
├── android
├── ios
└── test
```

- `lib`: Contains all application code. This directory usually contains these subdirectories:
    - `models`: Contains data model classes.
    - `repositories`: Contains data repository classes, responsible for retrieving data from different sources.
    - `screens`: Contains screen components, each typically corresponding to a screen in the app.
    - `services`: Contains service classes, such as network services, database services, etc.
    - `widgets`: Contains widget components, typically used to compose larger screen components.
- `android` and `ios`: These directories contain native code for Android and iOS platforms. You can add native code such as plugins and native libraries here.
- `test`: Contains application testing code, including unit tests and integration tests.

## Roadmap

Currently, MoliAI only supports Google Palm. Plans are underway to include support for OpenAI and Microsoft Bing AI.

## License

This project is licensed under the Creative Commons Attribution-NonCommercial (CC BY-NC) license. For more information, see the LICENSE file.

## Contact

If you need any help or have any questions, feel free to open an issue. I will respond as soon as possible.

Thank you for checking out MoliAI! If you have any feedback or suggestions for improving this README, please let me know.

