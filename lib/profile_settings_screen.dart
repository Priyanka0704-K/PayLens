import 'package:flutter/material.dart';
import 'package:project/analyzing_payments_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_screen.dart';
import 'history_screen.dart';
import 'notifications_screen.dart';
import 'payment_methods_screen.dart';
import 'audit_preferences_screen.dart';
import 'upcoming_screen.dart';

class ProfileSettingsScreen extends StatelessWidget {
  final String userName;
  final String userEmail;

  const ProfileSettingsScreen({
    super.key,
    required this.userName,
    required this.userEmail, required List<BankTransaction> payments,
  });

  // ============================================================
  // PAYLENS COLORS
  // ============================================================

  static const Color primaryBlue =
  Color(0xFF2222C8);

  static const Color pageBackground =
  Color(0xFFF7F7FB);

  static const Color borderGrey =
  Color(0xFFD0D0D0);

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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 44,
          child: Row(
            children: [
              const SizedBox(width: 12),

              Icon(
                icon,
                size: 19,
                color: Colors.black87,
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
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: Color(0xFF777777),
                ),

              const SizedBox(width: 9),
            ],
          ),
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
        borderRadius: BorderRadius.circular(7),
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
    final String profileLetter =
    userName.trim().isNotEmpty
        ? userName.trim().substring(0, 1).toUpperCase()
        : '?';

    return Container(
      width: double.infinity,
      height: 74,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: primaryBlue,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        children: [
          // ======================================================
          // AVATAR
          // ======================================================

          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFD8D3FF),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Center(
              child: Text(
                profileLetter,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: primaryBlue,
                ),
              ),
            ),
          ),

          const SizedBox(width: 11),

          // ======================================================
          // USER INFO
          // ======================================================

          Expanded(
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  userName.trim().isEmpty
                      ? 'User'
                      : userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 2),

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

                const SizedBox(height: 3),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration:
                      const BoxDecoration(
                        color: Color(0xFF39A845),
                        shape: BoxShape.circle,
                      ),
                    ),

                    const SizedBox(width: 5),

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
  // NOTIFICATIONS
  // ============================================================

  void openNotifications(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const NotificationsScreen(),
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
        builder: (_) =>
        const PaymentMethodsScreen(),
      ),
    );
  }

  // ============================================================
  // AUDIT PREFERENCES
  // ============================================================

  void openAuditPreferences(
      BuildContext context,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const AuditPreferencesScreen(),
      ),
    );
  }

  // ============================================================
  // UPCOMING
  // ============================================================

  void openUpcoming(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const UpcomingScreen(),
      ),
    );
  }

  // ============================================================
  // ISSUES
  // ============================================================

  void openIssues(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
              ),
              SizedBox(width: 8),
              Text('Issues'),
            ],
          ),
          content: const Text(
            'PayLens will show subscription issues '
                'and unusual recurring payment patterns here.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: primaryBlue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // REVIEW
  // ============================================================

  void openReview(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.star_outline_rounded,
                color: Colors.amber,
              ),
              SizedBox(width: 8),
              Text('Review'),
            ],
          ),
          content: const Text(
            'Your PayLens review option will be '
                'available here.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: primaryBlue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // SIGN OUT
  // ============================================================

  Widget signOutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 42,
      child: ElevatedButton(
        onPressed: () async {
          final prefs =
          await SharedPreferences.getInstance();

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
          backgroundColor:
          const Color(0xFFF4DCDC),
          foregroundColor:
          const Color(0xFFD13F3F),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(6),
          ),
        ),
        child: const Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_rounded,
              size: 19,
              color: Color(0xFFD13F3F),
            ),

            SizedBox(width: 7),

            Text(
              'Sign Out',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 15,
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
  // HISTORY
  // ============================================================

  void openHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const HistoryScreen(),
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget bottomNavigation(
      BuildContext context,
      ) {
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
        mainAxisAlignment:
        MainAxisAlignment.spaceAround,
        children: [
          // ======================================================
          // HOME
          // ======================================================

          IconButton(
            onPressed: () {
              openHome(context);
            },
            icon: const Icon(
              Icons.home_outlined,
              size: 24,
              color: Color(0xFF777777),
            ),
          ),

          // ======================================================
          // UPLOAD / SUBSCRIPTIONS
          // ======================================================

          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/upload-statement',
              );
            },
            icon: const Icon(
              Icons.receipt_long_outlined,
              size: 24,
              color: Color(0xFF777777),
            ),
          ),

          // ======================================================
          // HISTORY
          // ======================================================

          IconButton(
            onPressed: () {
              openHistory(context);
            },
            icon: const Icon(
              Icons.history_rounded,
              size: 24,
              color: Color(0xFF777777),
            ),
          ),

          // ======================================================
          // PROFILE - ACTIVE
          // ======================================================

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.person_outline_rounded,
              size: 24,
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

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool compact =
                constraints.maxHeight < 650;

            return Column(
              children: [
                // ==================================================
                // MAIN CONTENT
                // ==================================================

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal:
                      compact ? 12 : 16,
                      vertical:
                      compact ? 8 : 10,
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        // ==========================================
                        // TITLE
                        // ==========================================

                        Text(
                          'Profile & Settings',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize:
                            compact ? 17 : 18,
                            fontWeight:
                            FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),

                        SizedBox(
                          height:
                          compact ? 6 : 8,
                        ),

                        // ==========================================
                        // PROFILE
                        // ==========================================

                        profileCard(),

                        SizedBox(
                          height:
                          compact ? 8 : 10,
                        ),

                        // ==========================================
                        // ACCOUNT
                        // ==========================================

                        sectionTitle(
                          'Account',
                        ),

                        settingsCard(
                          children: [
                            settingsRow(
                              icon:
                              Icons.notifications_none_rounded,
                              title:
                              'Notifications',
                              onTap: () {
                                openNotifications(
                                  context,
                                );
                              },
                            ),

                            settingsRow(
                              icon:
                              Icons.credit_card_outlined,
                              title:
                              'Payment Methods',
                              onTap: () {
                                openPaymentMethods(
                                  context,
                                );
                              },
                            ),

                            settingsRow(
                              icon:
                              Icons.settings_outlined,
                              title:
                              'Audit Preferences',
                              onTap: () {
                                openAuditPreferences(
                                  context,
                                );
                              },
                            ),
                          ],
                        ),

                        SizedBox(
                          height:
                          compact ? 8 : 10,
                        ),

                        // ==========================================
                        // INSIGHTS
                        // ==========================================

                        sectionTitle(
                          'Insights',
                        ),

                        settingsCard(
                          children: [
                            settingsRow(
                              icon:
                              Icons.warning_amber_outlined,
                              title: 'Issues',
                              onTap: () {
                                openIssues(
                                  context,
                                );
                              },
                            ),

                            settingsRow(
                              icon:
                              Icons.star_outline_rounded,
                              title: 'Review',
                              onTap: () {
                                openReview(
                                  context,
                                );
                              },
                            ),

                            settingsRow(
                              icon:
                              Icons.calendar_month_outlined,
                              title: 'Upcoming',
                              onTap: () {
                                openUpcoming(
                                  context,
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        // ==========================================
                        // SIGN OUT
                        // ==========================================

                        signOutButton(
                          context,
                        ),

                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ),

                // ==================================================
                // BOTTOM NAVIGATION
                // ==================================================

                bottomNavigation(
                  context,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}