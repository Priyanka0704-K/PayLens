import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/analyzing_payments_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_screen.dart';
import 'history_screen.dart';
import 'notifications_screen.dart';

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

  Widget sectionTitle(
      String title,
      ) {
    return Padding(
      padding:
      const EdgeInsets.only(
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
          decoration:
          TextDecoration.none,
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
        height: 40,
        child: Row(
          children: [
            const SizedBox(width: 12),

            Icon(
              icon,
              size: 17,
              color: CupertinoColors.black,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,
                style:
                const TextStyle(
                  fontFamily:
                  'Montserrat',
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w500,
                  color:
                  CupertinoColors.black,
                  decoration:
                  TextDecoration.none,
                ),
              ),
            ),

            if (showArrow)
              const Icon(
                CupertinoIcons
                    .chevron_right,
                size: 13,
                color:
                Color(0xFF777777),
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
        color: CupertinoColors.white,
        border: Border.all(
          color: borderGrey,
          width: 1,
        ),
        borderRadius:
        BorderRadius.circular(6),
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
    final profileLetter =
    userName.trim().isNotEmpty
        ? userName
        .trim()
        .substring(0, 1)
        .toUpperCase()
        : '?';

    return Container(
      width: double.infinity,
      height: 70,
      padding:
      const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        border: Border.all(
          color: primaryBlue,
          width: 2,
        ),
        borderRadius:
        BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color:
              const Color(0xFFD8D3FF),
              borderRadius:
              BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                profileLetter,
                style:
                const TextStyle(
                  fontFamily:
                  'Montserrat',
                  fontSize: 20,
                  fontWeight:
                  FontWeight.w500,
                  color: primaryBlue,
                  decoration:
                  TextDecoration.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

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
                  overflow:
                  TextOverflow.ellipsis,
                  style:
                  const TextStyle(
                    fontFamily:
                    'Montserrat',
                    fontSize: 15,
                    fontWeight:
                    FontWeight.w500,
                    color:
                    CupertinoColors
                        .black,
                    decoration:
                    TextDecoration.none,
                  ),
                ),

                const SizedBox(height: 1),

                Text(
                  userEmail,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style:
                  const TextStyle(
                    fontFamily:
                    'Montserrat',
                    fontSize: 10,
                    color:
                    Color(0xFF888888),
                    decoration:
                    TextDecoration.none,
                  ),
                ),

                const SizedBox(height: 2),

                Row(
                  mainAxisSize:
                  MainAxisSize.min,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration:
                      const BoxDecoration(
                        color:
                        Color(0xFF39A845),
                        shape:
                        BoxShape.circle,
                      ),
                    ),

                    const SizedBox(
                      width: 4,
                    ),

                    const Text(
                      'Account active',
                      style:
                      TextStyle(
                        fontFamily:
                        'Montserrat',
                        fontSize: 8,
                        color:
                        Color(
                          0xFF39A845,
                        ),
                        decoration:
                        TextDecoration
                            .none,
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

  Widget signOutButton(
      BuildContext context,
      ) {
    return SizedBox(
      width: double.infinity,
      height: 38,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        borderRadius:
        BorderRadius.circular(5),
        color:
        const Color(0xFFF4DCDC),
        onPressed: () async {
          final prefs =
          await SharedPreferences
              .getInstance();

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
        child: const Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons
                  .square_arrow_right,
              size: 18,
              color:
              Color(0xFFD13F3F),
            ),

            SizedBox(width: 6),

            Text(
              'Sign Out',
              style: TextStyle(
                fontFamily:
                'Montserrat',
                fontSize: 16,
                fontWeight:
                FontWeight.w600,
                color:
                Color(0xFFD13F3F),
                decoration:
                TextDecoration.none,
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

  void openHome(
      BuildContext context,
      ) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            DashboardScreen(
              userName: userName,
              userEmail: userEmail,
            ),
      ),
    );
  }

  // ============================================================
  // SUBSCRIPTIONS
  // ============================================================

  void openSubscriptions(
      BuildContext context,
      ) {
    // The Profile page does not itself receive
    // the currently analyzed transaction list.
    //
    // Return to Dashboard where the real parsed
    // subscription list is available.
    Navigator.pop(context);
  }

  // ============================================================
  // HISTORY
  // ============================================================

  void openHistory(
      BuildContext context,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const HistoryScreen(),
      ),
    );
  }

  // ============================================================
  // NOTIFICATIONS
  // ============================================================

  void openNotifications(
      BuildContext context,
      ) {
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

  void openPaymentMethods(
      BuildContext context,
      ) {
    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: const Text(
            'Payment Methods',
          ),
          content: const Padding(
            padding:
            EdgeInsets.only(top: 8),
            child: Text(
              'This feature will be available soon.',
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // AUDIT
  // ============================================================

  void openAuditPreferences(
      BuildContext context,
      ) {
    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: const Text(
            'Audit Preferences',
          ),
          content: const Padding(
            padding:
            EdgeInsets.only(top: 8),
            child: Text(
              'Audit preferences will be available soon.',
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // PRIVACY
  // ============================================================

  void openPrivacy(
      BuildContext context,
      ) {
    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: const Text(
            'Privacy & Security',
          ),
          content: const Padding(
            padding:
            EdgeInsets.only(top: 8),
            child: Text(
              'Your PayLens data is protected.',
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // DATA PERMISSIONS
  // ============================================================

  void openDataPermissions(
      BuildContext context,
      ) {
    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: const Text(
            'Data Permissions',
          ),
          content: const Padding(
            padding:
            EdgeInsets.only(top: 8),
            child: Text(
              'Data permission settings will be available soon.',
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // HELP
  // ============================================================

  void openHelp(
      BuildContext context,
      ) {
    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: const Text(
            'Help & Support',
          ),
          content: const Padding(
            padding:
            EdgeInsets.only(top: 8),
            child: Text(
              'PayLens support will be available soon.',
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // CONTACT
  // ============================================================

  void openContact(
      BuildContext context,
      ) {
    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: const Text(
            'Contact PayLens',
          ),
          content: const Padding(
            padding:
            EdgeInsets.only(top: 8),
            child: Text(
              'Thank you for contacting PayLens.',
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(
                  context,
                );
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

  Widget bottomNavigation(
      BuildContext context,
      ) {
    return Container(
      height: 58,
      decoration:
      const BoxDecoration(
        color:
        CupertinoColors.white,
        border: Border(
          top: BorderSide(
            color: Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment
            .spaceAround,
        children: [
          // ======================================================
          // HOME
          // ======================================================

          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              openHome(context);
            },
            child: const Icon(
              CupertinoIcons.home,
              size: 23,
              color:
              Color(0xFF777777),
            ),
          ),

          // ======================================================
          // SUBSCRIPTIONS
          // ======================================================

          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              openSubscriptions(
                context,
              );
            },
            child: const Icon(
              CupertinoIcons
                  .rectangle_stack,
              size: 23,
              color:
              Color(0xFF777777),
            ),
          ),

          // ======================================================
          // HISTORY
          // ======================================================

          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              openHistory(context);
            },
            child: const Icon(
              CupertinoIcons.clock,
              size: 23,
              color:
              Color(0xFF777777),
            ),
          ),

          // ======================================================
          // PROFILE
          // ======================================================

          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            child: const Icon(
              CupertinoIcons.person,
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
  Widget build(
      BuildContext context,
      ) {
    return CupertinoPageScaffold(
      backgroundColor:
      pageBackground,
      child: SafeArea(
        child: LayoutBuilder(
          builder:
              (context, constraints) {
            final compact =
                constraints.maxHeight <
                    650;

            return Column(
              children: [
                // ==================================================
                // MAIN CONTENT
                // ==================================================

                Expanded(
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(
                      horizontal:
                      compact ? 12 : 16,
                      vertical:
                      compact ? 8 : 10,
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        // ==========================================
                        // PAGE TITLE
                        // ==========================================

                        Text(
                          'Profile & Settings',
                          style:
                          TextStyle(
                            fontFamily:
                            'Montserrat',
                            fontSize:
                            compact
                                ? 17
                                : 18,
                            fontWeight:
                            FontWeight
                                .w600,
                            color:
                            CupertinoColors
                                .black,
                            decoration:
                            TextDecoration
                                .none,
                          ),
                        ),

                        SizedBox(
                          height:
                          compact ? 6 : 8,
                        ),

                        // ==========================================
                        // PROFILE CARD
                        // ==========================================

                        profileCard(),

                        SizedBox(
                          height:
                          compact ? 6 : 8,
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
                              CupertinoIcons
                                  .bell,
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
                              CupertinoIcons
                                  .creditcard,
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
                              CupertinoIcons
                                  .settings,
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
                          compact ? 7 : 10,
                        ),

                        // ==========================================
                        // PRIVACY
                        // ==========================================

                        sectionTitle(
                          'Privacy',
                        ),

                        settingsCard(
                          children: [
                            settingsRow(
                              icon:
                              CupertinoIcons
                                  .lock_shield,
                              title:
                              'Privacy & Security',
                              onTap: () {
                                openPrivacy(
                                  context,
                                );
                              },
                            ),

                            settingsRow(
                              icon:
                              CupertinoIcons
                                  .lock,
                              title:
                              'Data Permissions',
                              onTap: () {
                                openDataPermissions(
                                  context,
                                );
                              },
                            ),
                          ],
                        ),

                        SizedBox(
                          height:
                          compact ? 7 : 10,
                        ),

                        // ==========================================
                        // SUPPORT
                        // ==========================================

                        sectionTitle(
                          'Support',
                        ),

                        settingsCard(
                          children: [
                            settingsRow(
                              icon:
                              CupertinoIcons
                                  .question_circle,
                              title:
                              'Help & Support',
                              onTap: () {
                                openHelp(
                                  context,
                                );
                              },
                            ),

                            settingsRow(
                              icon:
                              CupertinoIcons
                                  .chat_bubble,
                              title:
                              'Contact PayLens',
                              onTap: () {
                                openContact(
                                  context,
                                );
                              },
                            ),
                          ],
                        ),

                        const Spacer(),

                        // ==========================================
                        // SIGN OUT
                        // ==========================================

                        signOutButton(
                          context,
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