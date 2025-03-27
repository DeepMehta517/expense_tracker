Design Notes for Expense Tracker App.


Architecture Overview:-
The Expense Tracker app follows a client-server architecture,
where the frontend is developed in Flutter and the 
backend is powered by Node.js with Sequelize ORM for database management.
This architecture ensures a scalable, modular, and efficient design.

Frontend (Flutter):-
State Management: Uses Provider for state management, ensuring efficient and scalable data flow.
UI Framework: Utilizes sizer for responsive UI across different screen sizes.
Networking: Implements http package for API calls.
Storage: Uses shared_preferences for storing user authentication tokens.
Data Visualization: Uses fl_chart to display financial data graphically.

Backend (Node.js with Sequelize ORM):-
Framework: Built with Express.js for handling API requests.
Database: Uses PostgreSQL, managed with Sequelize ORM.
Authentication: Implements JWT-based authentication for secure user sessions.
Error Handling: Uses middleware for structured error handling.

Unique Features and Reasoning

1. Multi-Device Syncing
Why? Users can access their expenses on different devices seamlessly.
How? Uses backend authentication with persistent session storage.

2. Data Visualization for Expense Insights
Why? Helps users track spending patterns easily.
How? fl_chart is used to generate interactive charts for expenses.

3. Category-Based Expense Tracking
Why? Helps users analyze spending habits in different categories.
How? Categories are stored in the database and fetched dynamically.

4. Secure User Authentication
Why? Ensures privacy and data security.
How? Implements JWT tokens and password hashing.


