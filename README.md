# User List App

A Flutter application demonstrating clean architecture, SOLID principles, and best practices in mobile app development.

## Project Overview

The User List App is a demonstration of how to build a scalable and maintainable Flutter application. It implements a simple user management system with features to view, add, and delete users while showcasing various software engineering principles and best practices.

## Architecture

The project follows Clean Architecture principles, divided into three main layers:

### 1. Domain Layer
- Contains business logic and rules
- Defines entities and repository interfaces
- Houses use cases that encapsulate business operations
- Independent of any external frameworks

### 2. Data Layer
- Implements repository interfaces
- Handles data operations and transformations
- Manages local storage through data sources
- Implements caching mechanisms

### 3. Presentation Layer
- Contains UI components and controllers
- Manages state and user interactions
- Implements the user interface using Flutter widgets

## SOLID Principles Implementation

### Single Responsibility Principle (SRP)
- Each use case handles one specific operation (GetUsers, AddUser, DeleteUser)
- Repository implementation focuses solely on data operations
- Controllers are responsible only for UI state management
- Data sources handle only storage operations

### Open/Closed Principle (OCP)
- Repository interfaces allow new implementations without modifying existing code
- Use cases can be extended without changing existing ones
- Failure handling system is extensible with new failure types

### Liskov Substitution Principle (LSP)
- Repository implementations properly substitute their interfaces
- Models extend entities without breaking behavior
- All implementations can be substituted with their base types

### Interface Segregation Principle (ISP)
- Repository interfaces are focused and minimal
- Use cases have specific interfaces for their needs
- Data source interfaces include only necessary methods

### Dependency Inversion Principle (DIP)
- High-level modules depend on abstractions
- Low-level modules implement abstractions
- Dependencies are injected through constructors
- Dependency injection container manages object creation

## Best Practices

### Error Handling
- Consistent use of Either type for error handling
- Well-defined failure types
- Descriptive error messages with context
- Proper error propagation through layers

### Testing
- Comprehensive unit tests
- Mock objects for testing
- Test coverage monitoring
- Testable architecture design

### Code Organization
- Feature-based folder structure
- Clear separation of concerns
- Consistent naming conventions
- Clean and maintainable code

### State Management
- Centralized state management
- Predictable state updates
- Clear state transitions
- Efficient UI updates

### Dependency Management
- Proper dependency injection
- Clear dependency graph
- Manageable dependencies
- Easy dependency updates

## Project Structure

```
lib/
├── core/
│   ├── base/
│   │   ├── base_state.dart
│   │   └── base_view_model.dart
│   ├── error/
│   │   └── failures.dart
│   ├── usecase/
│   │   └── usecase.dart
│   └── config/
│       └── environment.dart
├── features/
│   └── user_list/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── controllers/
│           ├── pages/
│           └── state/
└── injection_container.dart
```

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter test` to execute tests
4. Run `flutter run` to start the application

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
