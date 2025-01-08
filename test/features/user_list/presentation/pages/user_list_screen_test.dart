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

  void setState(UserListState newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  Future<void> loadUsers() async {
    return Future.value();
  }
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
}
