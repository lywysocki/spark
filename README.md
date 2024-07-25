# Spark

Spark is a habit tracking mobile application designed to help users build and maintain healthy habits. With a user-friendly interface and various tracking features, Spark enables users to set goals, track progress, and achieve their personal growth milestones. The minimalist UI and simplified habit requirements help users get started without a steep learning curve.

## Table of Contents
- [Description](#description)
- [Tech Stack](#tech-stack)
- [How to Run](#how-to-run)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Running the App](#running-the-app)
- [Version Release](#version-release)

## Description

Spark is designed to help users establish and track their habits. Users can create custom habits and visualize their progress for each goal. Spark's intuitive design ensures that habit tracking is both effective and enjoyable.

## Tech Stack

- **Language:** Dart
- **Framework:** Flutter
- **Backend:** PostgreSQL
- **Design Tools:** Figma

## How to Run

### Prerequisites

Required:
- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Dart: Included with Flutter SDK
Optional:
- PostgreSQL: [Install PostgreSQL](https://www.postgresql.org/download/)

### Installation

1. **Clone the repository:**
    ```sh
    git clone https://github.com/your-username/spark.git
    cd spark
    ```

2. **Install dependencies:**
    ```sh
    flutter pub get
    ```

3. **Set up the PostgreSQL database (Admins only):**
   - Create a new database in PostgreSQL.
   - Update the `lib/config.dart` file with your database credentials.

### Running the App

1. **Run the Flutter app:**
    ```sh
    flutter run
    ```

2. **Ensure the PostgreSQL server is running (Admins only):**
    ```sh
    sudo service postgresql start
    ```

### Running the Version Release

1. **Download the release APK:**
   - Go to the [Releases](https://github.com/your-username/spark/releases) page.
   - Download the latest APK file.

2. **Install the APK on your device:**
   - Transfer the APK file to your device.
   - Open the file and follow the on-screen instructions to install.

3. **Run the App:**
   - Open the app from your device.
   - Log in or create an account and start tracking your habits!


### How to Update

To update to the latest version, pull the changes from the repository and run the app as described above:

```sh
git pull origin main
flutter pub get
flutter run
