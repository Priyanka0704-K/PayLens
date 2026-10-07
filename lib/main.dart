import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'dashboard_screen.dart';
import 'connect_account_screen.dart';
import 'upload_statement_screen.dart';
import 'profile_settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const PayLensApp(),
  );
}

class PayLensApp extends StatelessWidget {
  const PayLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PayLens',

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Montserrat',

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2222C8),
        ),

        scaffoldBackgroundColor:
        const Color(0xFFF7F7FB),
      ),

      initialRoute: '/',

      routes: {
        '/': (context) =>
        const WelcomeScreen(),

        '/login': (context) =>
        const LoginScreen(),

        '/signup': (context) =>
        const SignupScreen(),

        '/dashboard': (context) =>
        const DashboardScreen(
          payments: [],
          pdfText: '',
          pdfFileName: '', userName: '', userEmail: '',
        ),

        '/connect-account': (context) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Please access Connect Account from Signup.',
              ),
            ),
          );
        },

        '/upload-statement': (context) =>
        const UploadStatementScreen(),

        '/profile': (context) =>
        const ProfileSettingsScreen(userName: '', userEmail: '',),
      },
    );
  }
}