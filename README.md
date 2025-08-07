
---

# Clean Architecture TODO Application

A feature-complete, robust TODO list application for Flutter, built following the principles of Clean Architecture. This project serves as a comprehensive example of building scalable, testable, and maintainable Flutter apps.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Architecture](#architecture)
- [Screenshots](#screenshots)
- [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation & Setup](#installation--setup)
- [Tech Stack & Dependencies](#tech-stack--dependencies)

## Introduction

This application is a simple yet powerful tool for managing daily tasks. It allows users to create, read, update, delete, and filter their TODOs. The primary purpose of this repository is to demonstrate a high-quality implementation of modern Flutter development practices, including:

-   **Clean Architecture:** Decoupling the business logic from the UI and data layers.
-   **State Management:** Using the BLoC (Business Logic Component) pattern for predictable and scalable state management.
-   **Local Persistence:** Leveraging a local SQLite database via the `floor` package.
-   **Dependency Injection:** Using `get_it` and `injectable` for managing dependencies throughout the app.
-   **Reactive UI:** Building a UI that automatically reacts to changes in the application state.

## Features

-   **CRUD Operations:** Full Create, Read, Update, and Delete functionality for tasks.
-   **Local Database:** All tasks are persisted locally on the device using SQLite.
-   **Tabbed Layout:** Filter tasks by "All", "Pending", and "Completed" status with live counts.
-   **Real-time Search:** Instantly filter tasks by title using a pinned search bar.
-   **Robust Error Handling:** Gracefully handles user errors (e.g., duplicate titles) with SnackBars and catastrophic errors (e.g., database failure) with dedicated error screens.
-   **Modern UI:** A clean, responsive UI built with Material 3, featuring slivers for efficient scrolling.
-   **Empty States:** Informative and user-friendly views for when no tasks are present or search results are empty.

## Architecture

The project strictly follows the **Clean Architecture** pattern, separating the code into three main layers:

-   **`Data Layer`:** Responsible for data retrieval from the local database (`floor` DAOs) and handling data models. It implements the abstract repositories defined in the Domain layer.
-   **`Domain Layer`** The core of the application. It contains the business logic (Use Cases), business objects (Entities), and repository interfaces. This layer is completely independent of Flutter and any external packages.
-   **`Presentation Layer`** The UI of the app. This layer contains the Flutter widgets, which are orchestrated by the BLoC state management library. The UI dispatches events to the BLoCs and listens for state changes to rebuild itself.

This separation ensures that the business logic is independent of the UI and the data source, making the application easy to test, maintain, and scale.

*(You can add screenshots of your running app here to make the README more visually appealing)*
## Screenshots

| All Tasks | Search | Add/Edit Task |
| :---: | :---: | :---: |
| ![Screenshot of the main task list](https://raw.githubusercontent.com/JagdishOnGH/todo_karobar/refs/heads/main/screenshots/Screenshot_20250807_160630.png) | ![Screenshot of the search functionality](https://raw.githubusercontent.com/JagdishOnGH/todo_karobar/refs/heads/main/screenshots/Screenshot_20250807_162014.png) | ![Screenshot of the add/edit bottom sheet](https://raw.githubusercontent.com/JagdishOnGH/todo_karobar/refs/heads/main/screenshots/Screenshot_20250807_160813.png) |

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

-   [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.x.x or higher)
-   [Dart SDK](https://dart.dev/get-dart) (bundled with Flutter)
-   An IDE like [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/) with the Flutter plugin.

### Installation & Setup

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/JagdishOnGH/todo_karobar.git
    cd YOUR_REPOSITORY_NAME
    ```

2.  **Get dependencies:**
    Run the following command to fetch all the required packages specified in `pubspec.yaml`.
    ```sh
    flutter pub get
    ```

3.  **Run the Build Runner:**
    This project uses code generation for dependency injection (`injectable`) and the local database (`floor`). You must run the build runner to generate the necessary files.
    ```sh
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
    *Note: If you make changes to any file with a `@injectable` annotation or a `floor` database/DAO, you will need to run this command again.*

4.  **Run the application:**
    Connect a device or start an emulator/simulator and run the app.
    ```sh
    flutter run
    ```

## Tech Stack & Dependencies

-   **State Management:** [flutter_bloc](https://pub.dev/packages/flutter_bloc) - For predictable state management.
-   **Database:** [floor](https://pub.dev/packages/floor) - A typesafe, reactive, and lightweight SQLite abstraction.
-   **Dependency Injection:** [get_it](https://pub.dev/packages/get_it) & [injectable](https://pub.dev/packages/injectable) - For service location and DI.
-   **Value Equality:** [equatable](https://pub.dev/packages/equatable) - To simplify equality comparisons in BLoC states/events.
-   **Logging:** [logger](https://pub.dev/packages/logger) - For beautiful and informative console logs.
