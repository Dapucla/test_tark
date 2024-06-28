# GitHub Users App

Welcome to the GitHub Users App project! This Flutter application is designed to fetch and display GitHub users categorized alphabetically.

## Project Description

GitHub Users App allows users to browse and search GitHub users, organized into tabs ('A-H', 'I-P', 'Q-Z'). The app features pagination, search functionality, and dynamic UI updates.

## Architecture and Framework

The app is built using the BLoC (Business Logic Component) architecture for effective state management in Flutter. This ensures separation of concerns and scalability.

## Key Features

- **Tabbed Navigation**: Users are categorized into tabs ('A-H', 'I-P', 'Q-Z') for easy browsing.
- **Pagination**: Users are fetched in batches for optimal performance.
- **Search**: Users can search for GitHub users by username with real-time results.
- **Loading Indicators**: Visual indicators like CircularProgressIndicator show ongoing tasks.

## Project Structure

- **Main.dart**: Entry point and configuration of the Flutter application.
- **GitHubUsersList.dart**: Main screen displaying categorized GitHub users and handling user interactions.
- **GitHubUser.dart**: GitHubUser model and JSON parsing methods.
- **BLoC Classes**: GitHubUsersBloc manages state transitions based on events.

## State Management

State changes are managed using BLoC, with transitions between states like UsersLoading, UsersLoaded, SearchResultsLoaded, and UsersError.

## API Integration

Data is fetched from the GitHub API using HTTP requests. JSON responses are parsed into GitHubUser objects.

## User Interface

The app features a dynamic AppBar that switches between a search field and tabs based on user interaction. TabBar and TabBarView widgets organize users alphabetically, with ListView and ListTile widgets displaying user information.

## Deployment and Testing

The Flutter app was compiled into an APK using `flutter build apk --split-per-abi` for deployment on Android. Extensive testing was conducted for compatibility and functionality.

## Dependencies

The project uses the following key dependencies:
- `flutter_bloc`: For implementing BLoC architecture.
- `http`: For making HTTP requests to the GitHub API.
- Other dependencies are listed in the `pubspec.yaml` file.

## Installation and Running

1. Make sure you have Flutter SDK and Android Studio (or another IDE of your choice) installed.
2. Clone the project repository from GitHub.
3. Open the project in your IDE and run it on an emulator or a real device using `flutter run`.

## Contribution and Support

Contributions to the project are welcome! Create Pull Requests and Issues on GitHub.

## License

[Specify your project's license, e.g., MIT License]

---

### Attachments

- Attach the compiled APK file to the README or provide a download link from a cloud storage service.

This README file provides users and developers with a comprehensive understanding of your project and its implementation, offering useful information and context for usage and collaboration.
