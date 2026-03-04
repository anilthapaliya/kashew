# KASHew: Personal expense tracker
A light-weight, privacy-focused offline expense manager built with Flutter. KASHew helps users track their daily spending, categorize expenses, and visualize their financial habits without ever requiring an internet connection.

## Overview
The goal of this project is to implement a robust MVVM (Model-View-ViewModel) architecture using the Provider package for state management and SQLite for high-performance local data persistence.
### Key Features

    Offline First: All data stays on your device using an encrypted-ready SQLite database.
    Categorized Spending: Group expenses by Food, Transport, Entertainment, etc.
    Real-time Totals: Automatic balance updates using the Observer pattern via Provider.
    Clean Architecture: Strict separation between UI, Business Logic, and Data layers.

## Architectural Design
To keep the codebase scalable, the project follows the Repository Pattern integrated with MVVM:

    Model: Defines the Expense and Category data structures.
    View: Pure Flutter widgets. They listen to the ViewModel and have zero knowledge of SQLite.
    ViewModel: Acts as the bridge. It holds the list of expenses and calls the Repository to fetch or save data. It calls notifyListeners() to refresh the UI.
    Repository: The "Gatekeeper" of data. It abstracts the SQLite implementation details from the rest of the app.

## Project Structure
    lib/
    ├── database/
    │   ├── helper/         # SQLite database helper (CRUD operations)
    │   └── repositories/   # Abstracting data sources from the ViewModel
    ├── models/             # Plain Old Dart Objects (PODOs)
    ├── view_models/        # Provider classes (Business logic)
    ├── views/              # UI Screens and Widgets
    └── utils/              # Constants, Theme, and Formatters


