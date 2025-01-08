import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:user_list_app/features/user_list/presentation/controllers/user_list_controller.dart';
import 'package:user_list_app/features/user_list/presentation/models/user_view_model.dart';
import 'package:user_list_app/features/user_list/presentation/pages/user_list_screen.dart';
import 'package:user_list_app/features/user_list/presentation/state/user_list_state.dart';

class MockUserListController extends Mock implements UserListController {
  @override
  UserListState get state => _state;
  UserListState _state = const UserListState();
  final List<VoidCallback> _listeners = [];

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void setState(UserListState newState) {
    _state = newState;
    for (final listener in _listeners) {
      listener();
    }
  }

  @override
  Future<void> loadUsers() async => super.noSuchMethod(
        Invocation.method(#loadUsers, []),
        returnValue: Future<void>.value(),
      );

  @override
  Future<void> addUser(String name) async => super.noSuchMethod(
        Invocation.method(#addUser, [name]),
        returnValue: Future<void>.value(),
      );

  @override
  Future<void> deleteUser(int id) async => super.noSuchMethod(
        Invocation.method(#deleteUser, [id]),
        returnValue: Future<void>.value(),
      );
}

void main() {
  late MockUserListController mockController;

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: ChangeNotifierProvider<UserListController>.value(
        value: mockController,
        child: const UserListScreen(),
      ),
    );
  }

  setUp(() {
    mockController = MockUserListController();
  });

  testWidgets('should show loading indicator when status is loading',
      (WidgetTester tester) async {
    // arrange
    mockController.setState(
      const UserListState(status: UserListStatus.loading),
    );

    // act
    await tester.pumpWidget(createWidgetUnderTest());

    // assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
      'should show error message and retry button when status is failure',
      (WidgetTester tester) async {
    // arrange
    const errorMessage = 'Failed to load users';
    mockController.setState(
      const UserListState(
        status: UserListStatus.failure,
        errorMessage: errorMessage,
      ),
    );

    // act
    await tester.pumpWidget(createWidgetUnderTest());

    // assert
    expect(find.text(errorMessage), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('should show list of users when status is success',
      (WidgetTester tester) async {
    // arrange
    final users = [
      const UserViewModel(id: 1, name: 'Test 1'),
      const UserViewModel(id: 2, name: 'Test 2'),
    ];
    mockController.setState(
      UserListState(
        status: UserListStatus.success,
        users: users,
      ),
    );

    // act
    await tester.pumpWidget(createWidgetUnderTest());

    // assert
    expect(find.text('Test 1'), findsOneWidget);
    expect(find.text('Test 2'), findsOneWidget);
  });

  testWidgets('should show add user dialog when FAB is tapped',
      (WidgetTester tester) async {
    // arrange
    await tester.pumpWidget(createWidgetUnderTest());

    // act
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // assert
    expect(find.text('Add New User'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('should close dialog when Cancel is pressed',
      (WidgetTester tester) async {
    // arrange
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // act
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // assert
    expect(find.text('Add New User'), findsNothing);
  });

  testWidgets('should show empty state when no users exist',
      (WidgetTester tester) async {
    // arrange
    mockController.setState(
      const UserListState(
        status: UserListStatus.success,
        users: [],
      ),
    );

    // act
    await tester.pumpWidget(createWidgetUnderTest());

    // assert
    expect(find.text('No users found'), findsOneWidget);
  });

  testWidgets('should call addUser when Add button is pressed',
      (WidgetTester tester) async {
    // arrange
    when(mockController.addUser('New User')).thenAnswer((_) async {});
    await tester.pumpWidget(createWidgetUnderTest());

    // act
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'New User');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // assert
    verify(mockController.addUser('New User')).called(1);
  });

  testWidgets('should call deleteUser when item is dismissed',
      (WidgetTester tester) async {
    // arrange
    when(mockController.deleteUser(1)).thenAnswer((_) async {});
    mockController.setState(
      const UserListState(
        status: UserListStatus.success,
        users: [UserViewModel(id: 1, name: 'Test User')],
      ),
    );

    // act
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
    await tester.pumpAndSettle();

    // assert
    verify(mockController.deleteUser(1)).called(1);
  });

  testWidgets('should call loadUsers when retry button is pressed',
      (WidgetTester tester) async {
    // arrange
    when(mockController.loadUsers()).thenAnswer((_) async {});
    mockController.setState(
      const UserListState(
        status: UserListStatus.failure,
        errorMessage: 'Error',
      ),
    );

    // act
    await tester.pumpWidget(createWidgetUnderTest());
    clearInteractions(mockController);

    await tester.tap(find.text('Retry'));
    await tester.pump();

    // assert
    verify(mockController.loadUsers()).called(1);
  });
}
