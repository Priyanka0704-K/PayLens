import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/subscription_screen.dart';

import 'dashboard_screen.dart';
import 'upload_statement_screen.dart';
import 'notifications_screen.dart';

class ProfileSettingsScreen extends StatelessWidget {
  final String userName;
  final String userEmail;

  const ProfileSettingsScreen({
    super.key,
    required this.userName,
    required this.userEmail,
  });

  // ============================================================
  // PAYLENS THEME COLORS
  // ============================================================

  static const Color primaryBlue = Color(0xFF2222C8);
  static const Color pageBackground = Color(0xFFF7F7FB);
  static const Color lightGrey = Color(0xFF777777);
  static const Color borderGrey = Color(0xFFD0D0D0);

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 3,
        bottom: 8,
      ),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'Montserrat',
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Color(0xFF777777),
          decoration: TextDecoration.none,
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
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            const SizedBox(width: 14),

            Icon(
              icon,
              size: 18,
              color: CupertinoColors.black,
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: CupertinoColors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ),

            if (showArrow)
              const Icon(
                CupertinoIcons.chevron_right,
                size: 15,
                color: Color(0xFF777777),
              ),

            const SizedBox(width: 12),
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
        color: CupertinoColors.white,
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
    final String profileLetter =
    userName.trim().isNotEmpty
        ? userName.trim()[0].toUpperCase()
        : '?';

    return Container(
      width: double.infinity,
      height: 88,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        border: Border.all(
          color: primaryBlue,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          // ======================================================
          // PROFILE AVATAR
          // ======================================================

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
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // ======================================================
          // USER DETAILS
          // ======================================================

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userName.trim().isEmpty
                      ? 'User'
                      : userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: CupertinoColors.black,
                    decoration: TextDecoration.none,
                  ),
                ),

                const SizedBox(height: 1),

                Text(
                  userEmail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: Color(0xFF888888),
                    decoration: TextDecoration.none,
                  ),
                ),

                const SizedBox(height: 2),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
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
                        fontSize: 10,
                        color: Color(0xFF39A845),
                        decoration: TextDecoration.none,
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
      height: 40,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xFFF4DCDC),
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
                (route) => false,
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.square_arrow_right,
              size: 17,
              color: Color(0xFFD13F3F),
            ),

            SizedBox(width: 6),

            Text(
              'Sign Out',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFFD13F3F),
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HOME NAVIGATION
  // ============================================================

  void openHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardScreen(
          userName: userName,
          userEmail: userEmail,
        ),
      ),
    );
  }

  // ============================================================
  // UPLOAD NAVIGATION
  // ============================================================

  void openUpload(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
        const UploadStatementScreen(),
      ),
    );
  }

  // ============================================================
  // HISTORY
  // ============================================================

  void openHistory(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Transaction History'),
          content: const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Your transaction history will appear here after uploading a statement.',
            ),
          ),
          actions: [
            CupertinoDialogAction(
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
  // SUBSCRIPTION INSIGHTS
  // ============================================================

  void openIssues(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Issues'),
          content: const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Subscription issues and unusual subscription activity will appear here.',
            ),
          ),
          actions: [
            CupertinoDialogAction(
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

  void openReview(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Review'),
          content: const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Subscriptions that need your review will appear here.',
            ),
          ),
          actions: [
            CupertinoDialogAction(
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

  void openUpcoming(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Upcoming'),
          content: const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Upcoming subscription payments will appear here.',
            ),
          ),
          actions: [
            CupertinoDialogAction(
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
      height: 48,
      decoration: const BoxDecoration(
        color: CupertinoColors.white,
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
          // HOME
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              openHome(context);
            },
            child: const Icon(
              CupertinoIcons.home,
              size: 20,
              color: Color(0xFF777777),
            ),
          ),

          // UPLOAD
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              // Open subscriptions
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubscriptionScreen(
                    payments: const [],
                  ),
                ),
              );
            },
            child: const Icon(
              CupertinoIcons.rectangle_stack,
              size: 20,
              color: Color(0xFF777777),
            ),
          ),

          // HISTORY
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              openHistory(context);
            },
            child: const Icon(
              CupertinoIcons.clock,
              size: 20,
              color: Color(0xFF777777),
            ),
          ),

          // PROFILE
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: const Icon(
              CupertinoIcons.person,
              size: 20,
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
    return CupertinoPageScaffold(
      backgroundColor: pageBackground,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 31,
                  vertical: 17,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    // ==================================================
                    // PAGE TITLE
                    // ==================================================

                    const Text(
                      'Profile & Settings',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.black,
                        decoration: TextDecoration.none,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ==================================================
                    // PROFILE CARD
                    // ==================================================

                    profileCard(),

                    const SizedBox(height: 10),

                    // ==================================================
                    // ACCOUNT
                    // ==================================================

                    sectionTitle('Account'),

                    settingsCard(
                      children: [
                        settingsRow(
                          icon: CupertinoIcons.bell,
                          title: 'Notifications',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                const NotificationsScreen(),
                              ),
                            );
                          },
                        ),

                        settingsRow(
                          icon: CupertinoIcons.creditcard,
                          title: 'Payment Methods',
                          onTap: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return const CupertinoAlertDialog(
                                  title: Text(
                                    'Payment Methods',
                                  ),
                                  content: Text(
                                    'This feature will be available soon.',
                                  ),
                                  actions: [],
                                );
                              },
                            );
                          },
                        ),

                        settingsRow(
                          icon: CupertinoIcons.settings,
                          title: 'Audit Preferences',
                          onTap: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return const CupertinoAlertDialog(
                                  title: Text(
                                    'Audit Preferences',
                                  ),
                                  content: Text(
                                    'Audit preferences will be available soon.',
                                  ),
                                  actions: [],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // ==================================================
                    // PRIVACY
                    // ==================================================

                    sectionTitle('Privacy'),

                    settingsCard(
                      children: [
                        settingsRow(
                          icon:
                          CupertinoIcons.lock_shield,
                          title: 'Privacy & Security',
                          onTap: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return const CupertinoAlertDialog(
                                  title: Text(
                                    'Privacy & Security',
                                  ),
                                  content: Text(
                                    'Your PayLens data is protected.',
                                  ),
                                  actions: [],
                                );
                              },
                            );
                          },
                        ),

                        settingsRow(
                          icon: CupertinoIcons.lock,
                          title: 'Data Permissions',
                          onTap: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return const CupertinoAlertDialog(
                                  title: Text(
                                    'Data Permissions',
                                  ),
                                  content: Text(
                                    'Data permission settings will be available soon.',
                                  ),
                                  actions: [],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // ==================================================
                    // SUBSCRIPTION INSIGHTS
                    // ==================================================

                    sectionTitle('Subscription Insights'),

                    settingsCard(
                      children: [
                        // -------------------------------
                        // ISSUES
                        // -------------------------------

                        settingsRow(
                          icon:
                          CupertinoIcons.exclamationmark_triangle,
                          title: 'Issues',
                          onTap: () {
                            openIssues(context);
                          },
                        ),

                        // -------------------------------
                        // REVIEW
                        // -------------------------------

                        settingsRow(
                          icon:
                          CupertinoIcons.doc_text_search,
                          title: 'Review',
                          onTap: () {
                            openReview(context);
                          },
                        ),

                        // -------------------------------
                        // UPCOMING
                        // -------------------------------

                        settingsRow(
                          icon:
                          CupertinoIcons.calendar,
                          title: 'Upcoming',
                          onTap: () {
                            openUpcoming(context);
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // ==================================================
                    // SUPPORT
                    // ==================================================

                    sectionTitle('Support'),

                    settingsCard(
                      children: [
                        settingsRow(
                          icon:
                          CupertinoIcons.question_circle,
                          title: 'Help & Support',
                          onTap: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return const CupertinoAlertDialog(
                                  title: Text(
                                    'Help & Support',
                                  ),
                                  content: Text(
                                    'PayLens support will be available soon.',
                                  ),
                                  actions: [],
                                );
                              },
                            );
                          },
                        ),

                        settingsRow(
                          icon:
                          CupertinoIcons.chat_bubble,
                          title: 'Contact PayLens',
                          onTap: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return const CupertinoAlertDialog(
                                  title: Text(
                                    'Contact PayLens',
                                  ),
                                  content: Text(
                                    'Thank you for contacting PayLens.',
                                  ),
                                  actions: [],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // ==================================================
                    // SIGN OUT
                    // ==================================================

                    signOutButton(context),

                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),

            // ========================================================
            // BOTTOM NAVIGATION
            // ========================================================

            bottomNavigation(context),
          ],
        ),
      ),
    );
  }
}