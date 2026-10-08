import 'package:flutter/material.dart';
import 'package:project/analyzing_payments_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'payment_methods_screen.dart';
import 'audit_preferences_screen.dart';
import 'dashboard_screen.dart';
import 'history_screen.dart';
import 'notifications_screen.dart';

class ProfileSettingsScreen extends StatelessWidget {
  final String userName;
  final String userEmail;

  const ProfileSettingsScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    required List<BankTransaction> payments,
  });

  // ============================================================
  // PAYLENS COLORS
  // ============================================================

  static const Color primaryBlue = Color(0xFF2222C8);
  static const Color pageBackground = Color(0xFFF7F7FB);
  static const Color borderGrey = Color(0xFFD0D0D0);

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 2,
        bottom: 5,
      ),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF777777),
        ),
      ),
    );
  }

  // ============================================================
  // SETTINGS ROW
  // ============================================================

  Widget settingsRow({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            const SizedBox(width: 12),

            Icon(
              icon,
              size: 19,
              color: Colors.black,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),

            if (showArrow)
              const Icon(
                Icons.chevron_right,
                size: 18,
                color: Color(0xFF777777),
              ),

            const SizedBox(width: 11),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SETTINGS CARD
  // ============================================================

  Widget settingsCard({
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: borderGrey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // ============================================================
  // PROFILE CARD
  // ============================================================

  Widget profileCard() {
    final profileLetter = userName.trim().isNotEmpty
        ? userName.trim().substring(0, 1).toUpperCase()
        : '?';

    return Container(
      width: double.infinity,
      height: 70,
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: primaryBlue,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFD8D3FF),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                profileLetter,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: primaryBlue,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName.trim().isEmpty ? 'User' : userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 1),

                Text(
                  userEmail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 10,
                    color: Color(0xFF888888),
                  ),
                ),

                const SizedBox(height: 2),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Color(0xFF39A845),
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 4),

                    const Text(
                      'Account active',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 8,
                        color: Color(0xFF39A845),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SIGN OUT
  // ============================================================

  Widget signOutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 38,
      child: ElevatedButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();

          await prefs.setBool(
            'paylens_logged_in',
            false,
          );

          if (!context.mounted) {
            return;
          }

          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
                (route) => false,
          );
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFFF4DCDC),
          foregroundColor: const Color(0xFFD13F3F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              size: 18,
              color: Color(0xFFD13F3F),
            ),

            SizedBox(width: 6),

            Text(
              'Sign Out',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFD13F3F),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HOME
  // ============================================================

  void openHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardScreen(
          userName: userName,
          userEmail: userEmail,
        ),
      ),
    );
  }

  // ============================================================
  // SUBSCRIPTIONS
  // ============================================================

  void openSubscriptions(BuildContext context) {
    Navigator.pop(context);
  }

  // ============================================================
  // HISTORY
  // ============================================================

  void openHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const HistoryScreen(),
      ),
    );
  }

  // ============================================================
  // NOTIFICATIONS
  // ============================================================

  void openNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const NotificationsScreen(),
      ),
    );
  }

  // ============================================================
  // PAYMENT METHODS
  // ============================================================

  void openPaymentMethods(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PaymentMethodsScreen(),
      ),
    );
  }

  // ============================================================
  // AUDIT PREFERENCES
  // ============================================================

  void openAuditPreferences(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AuditPreferencesScreen(),
      ),
    );
  }

  // ============================================================
  // INSIGHTS - ISSUES
  // ============================================================

  void openIssues(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFE6A700),
              ),
              SizedBox(width: 8),
              Text('Issues'),
            ],
          ),
          content: const Text(
            'PayLens will show unusual, duplicate, or potentially '
                'unnecessary recurring payments here.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // INSIGHTS - REVIEW
  // ============================================================

  void openReview(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.star_rounded,
                color: Color(0xFFE6A700),
              ),
              SizedBox(width: 8),
              Text('Review'),
            ],
          ),
          content: const Text(
            'Your PayLens review and feedback options will be '
                'available here.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // INSIGHTS - UPCOMING
  // ============================================================

  void openUpcoming(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.calendar_month_rounded,
                color: primaryBlue,
              ),
              SizedBox(width: 8),
              Text('Upcoming'),
            ],
          ),
          content: const Text(
            'Upcoming subscription renewals and recurring '
                'payments will appear here.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget bottomNavigation(BuildContext context) {
    return Container(
      height: 58,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // HOME
          IconButton(
            onPressed: () {
              openHome(context);
            },
            icon: const Icon(
              Icons.home_outlined,
              size: 23,
              color: Color(0xFF777777),
            ),
          ),

          // SUBSCRIPTIONS
          IconButton(
            onPressed: () {
              openSubscriptions(context);
            },
            icon: const Icon(
              Icons.view_list_outlined,
              size: 23,
              color: Color(0xFF777777),
            ),
          ),

          // HISTORY
          IconButton(
            onPressed: () {
              openHistory(context);
            },
            icon: const Icon(
              Icons.access_time,
              size: 23,
              color: Color(0xFF777777),
            ),
          ),

          // PROFILE
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.person_outline,
              size: 23,
              color: primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 650;

            return Column(
              children: [
                // ==================================================
                // MAIN CONTENT
                // ==================================================

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: compact ? 12 : 16,
                      vertical: compact ? 8 : 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ==========================================
                        // PAGE TITLE
                        // ==========================================

                        Text(
                          'Profile & Settings',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: compact ? 17 : 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),

                        SizedBox(
                          height: compact ? 6 : 8,
                        ),

                        // ==========================================
                        // PROFILE CARD
                        // ==========================================

                        profileCard(),

                        SizedBox(
                          height: compact ? 6 : 8,
                        ),

                        // ==========================================
                        // ACCOUNT
                        // ==========================================

                        sectionTitle('Account'),

                        settingsCard(
                          children: [
                            settingsRow(
                              icon: Icons.notifications_none,
                              title: 'Notifications',
                              onTap: () {
                                openNotifications(context);
                              },
                            ),

                            settingsRow(
                              icon: Icons.credit_card_outlined,
                              title: 'Payment Methods',
                              onTap: () {
                                openPaymentMethods(context);
                              },
                            ),

                            settingsRow(
                              icon: Icons.settings_outlined,
                              title: 'Audit Preferences',
                              onTap: () {
                                openAuditPreferences(context);
                              },
                            ),
                          ],
                        ),

                        SizedBox(
                          height: compact ? 7 : 10,
                        ),

                        // ==========================================
                        // INSIGHTS
                        // ==========================================

                        sectionTitle('Insights'),

                        settingsCard(
                          children: [
                            settingsRow(
                              icon: Icons.warning_amber_outlined,
                              title: 'Issues',
                              onTap: () {
                                openIssues(context);
                              },
                            ),

                            settingsRow(
                              icon: Icons.star_border_rounded,
                              title: 'Review',
                              onTap: () {
                                openReview(context);
                              },
                            ),

                            settingsRow(
                              icon: Icons.calendar_month_outlined,
                              title: 'Upcoming',
                              onTap: () {
                                openUpcoming(context);
                              },
                            ),
                          ],
                        ),

                        const Spacer(),

                        // ==========================================
                        // SIGN OUT
                        // ==========================================

                        signOutButton(context),
                      ],
                    ),
                  ),
                ),

                // ==================================================
                // BOTTOM NAVIGATION
                // ==================================================

                bottomNavigation(context),
              ],
            );
          },
        ),
      ),
    );
  }
}