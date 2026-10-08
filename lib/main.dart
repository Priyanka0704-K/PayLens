import 'package:flutter/material.dart';

import 'welcome_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'dashboard_screen.dart';
import 'connect_account_screen.dart';
import 'upload_statement_screen.dart';
import 'analyzing_payments_screen.dart';
import 'history_details_screen.dart';
import 'history_screen.dart';
import 'notifications_screen.dart';
import 'profile_settings_screen.dart';
import 'subscription_screen.dart';
import 'audit_preferences_screen.dart';
import 'payment_methods_screen.dart';
import 'paylens_insight_engine.dart';
import 'pdf_extraction_service.dart';
import 'pdf_payment_analyzer.dart';
import 'paylens_notification_service.dart';


// ============================================================
// MAIN
// ============================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ----------------------------------------------------------
  // INITIALIZE PAYLENS NOTIFICATIONS
  // ----------------------------------------------------------

  await PayLensNotificationService.initialize();

  // ----------------------------------------------------------
  // START APP
  // ----------------------------------------------------------

  runApp(
    const PayLensApp(),
  );
}


// ============================================================
// PAYLENS APP
// ============================================================

class PayLensApp extends StatelessWidget {
  const PayLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'PayLens',

      // ========================================================
      // THEME
      // ========================================================

      theme: ThemeData(
        useMaterial3: true,

        fontFamily: 'Montserrat',

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2222C8),
        ),

        scaffoldBackgroundColor:
        const Color(0xFFF7F7FB),
      ),

      // ========================================================
      // INITIAL ROUTE
      // ========================================================

      initialRoute: '/',

      // ========================================================
      // ROUTES
      // ========================================================

      routes: {
        // ------------------------------------------------------
        // WELCOME
        // ------------------------------------------------------

        '/': (context) {
          return const WelcomeScreen();
        },

        // ------------------------------------------------------
        // LOGIN
        // ------------------------------------------------------

        '/login': (context) {
          return const LoginScreen();
        },

        // ------------------------------------------------------
        // SIGN UP
        // ------------------------------------------------------

        '/signup': (context) {
          return const SignupScreen();
        },

        // ------------------------------------------------------
        // DASHBOARD
        // ------------------------------------------------------

        '/dashboard': (context) {
          return const DashboardScreen(
            payments: [],
            pdfFileName: '',
            pdfText: '',
            userName: '',
            userEmail: '',
          );
        },

        // ------------------------------------------------------
        // CONNECT ACCOUNT
        // ------------------------------------------------------

        '/connect-account': (context) {
          return const ConnectAccountScreen();
        },

        // ------------------------------------------------------
        // UPLOAD STATEMENT
        // ------------------------------------------------------

        '/upload-statement': (context) {
          return const UploadStatementScreen();
        },

        // ------------------------------------------------------
        // NOTIFICATIONS
        // ------------------------------------------------------

        '/notifications': (context) {
          return const NotificationsScreen();
        },

        // ------------------------------------------------------
        // HISTORY
        // ------------------------------------------------------

        '/history': (context) {
          return const HistoryScreen();
        },

        // ------------------------------------------------------
        // AUDIT PREFERENCES
        // ------------------------------------------------------

        '/audit-preferences': (context) {
          return const AuditPreferencesScreen();
        },

        // ------------------------------------------------------
        // PAYMENT METHODS
        // ------------------------------------------------------

        '/payment-methods': (context) {
          return const PaymentMethodsScreen();
        },
      },
    );
  }
}