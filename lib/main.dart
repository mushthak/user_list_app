import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/config/environment.dart';
import 'core/config/theme.dart';
import 'injection_container.dart' as di;
import 'features/user_list/presentation/controllers/user_list_controller.dart';
import 'features/user_list/presentation/pages/user_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set environment
  Environment.currentEnvironment = Environment.development;

  // Initialize dependencies
  await di.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => di.sl<UserListController>(),
      child: MaterialApp(
        title: 'User List App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode:
            ThemeMode.system, // Automatically use light/dark based on system
        home: const UserListScreen(),
      ),
    );
  }
}
