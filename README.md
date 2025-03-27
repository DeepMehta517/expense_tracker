📌 Expense Tracker App (Flutter + Node.js Backend)

🛠️ Setup Instructions

🔹 1. Prerequisites
Ensure you have the following installed:
Flutter SDK
Android Studio or Visual Studio Code
A physical or virtual Android/iOS device
Node.js Backend should be running

🔹 2. Clone the Repository
Run the following command to clone the project and navigate to the frontend directory:
git clone https://github.com/your-repo/expense-tracker.git
cd expense-tracker/frontend

🔹 3. Install Dependencies
Run the following command to install all required Flutter dependencies:
flutter pub get
If any dependencies are missing, install them manually using:
flutter pub add package_name

Dependencies used:
flutter:
sdk: flutter
cupertino_icons: ^1.0.8
intl: ^0.20.2
provider: ^6.1.2
sizer: ^3.0.4
fl_chart: ^0.63.0
http: ^1.3.0
shared_preferences: ^2.5.2


🔹 4. Run the Flutter App
🏗️ For Android:
flutter run
🍏 For iOS:
flutter run --no-sound-null-safety
Ensure your emulator or device is connected.

🔹 5. Folder Structure
Expense_tracker/
│── lib/
│   ├── main.dart           # Entry point
│   ├── features/         # All the features folder and all individual feature folder contains its controller(provider),screen and model(wherever required)
│── pubspec.yaml            # Dependencies
│── README.md               # Project Documentation

🔹 6. Troubleshooting

Issue
Solution
App not running?
Check if the backend server is running (npm start) 
if not running than write cmd -  npx nodemon server.js

API calls failing?
Ensure base URL is correct (config.dart)
Emulator not detecting API?
Use http://10.0.2.2:5000/

🚀 Your Flutter Expense Tracker App is now set up and ready to use!