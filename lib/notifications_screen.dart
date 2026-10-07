import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const Color primaryBlue = Color(0xFF2222C8);
  static const Color pageBackground = Color(0xFFF7F7FB);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackground,

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: Column(
          children: [

            // =====================================================
            // MAIN CONTENT
            // =====================================================

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  13,
                  10,
                  13,
                  15,
                ),

                child: Column(
                  children: [

                    // =================================================
                    // HEADER
                    // =================================================

                    Row(
                      children: [

                        // BACK BUTTON
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },

                          child: Container(
                            width: 27,
                            height: 27,

                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),

                            child: const Icon(
                              Icons.chevron_left,
                              size: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        const SizedBox(width: 9),

                        // TITLE
                        const Expanded(
                          child: Text(
                            'Stay informed',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        // MARK ALL READ
                        GestureDetector(
                          onTap: () {},
                          child: const Row(
                            children: [
                              Text(
                                'Mark all read',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              SizedBox(width: 3),

                              Icon(
                                Icons.done_all,
                                size: 12,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 17),

                    // =================================================
                    // NOTIFICATION 1
                    // =================================================

                    notificationCard(
                      title: 'Netflix price increased',
                      description:
                      'Your recurring payment changed from \$149 to \$199 - an increase of \$50/month.',
                      time: '2 hrs ago',
                      icon: Icons.movie_outlined,
                      backgroundColor:
                      const Color(0xFFE9B8BC),
                      borderColor:
                      const Color(0xFFB86A70),
                    ),

                    const SizedBox(height: 16),

                    // =================================================
                    // NOTIFICATION 2
                    // =================================================

                    notificationCard(
                      title: 'Annual renewal approaching',
                      description:
                      'Adobe CC renews in 7 days for \$1,675. Ensure your payment method is active.',
                      time: '5 hrs ago',
                      icon: Icons.credit_card_outlined,
                      backgroundColor:
                      const Color(0xFFFFFDD5),
                      borderColor:
                      const Color(0xFFE6DF70),
                    ),

                    const SizedBox(height: 16),

                    // =================================================
                    // NOTIFICATION 3
                    // =================================================

                    notificationCard(
                      title: 'New re-payment detected',
                      description:
                      'A new recurring transaction of \$129 was identified - YouTube premium.',
                      time: 'Yesterday',
                      icon: Icons.monetization_on_outlined,
                      backgroundColor:
                      const Color(0xFFFFD8C8),
                      borderColor:
                      const Color(0xFFFF765C),
                    ),

                    const SizedBox(height: 16),

                    // =================================================
                    // NOTIFICATION 4
                    // =================================================

                    notificationCard(
                      title: 'Old payment source detected',
                      description:
                      'Amazon Prime is linked to a payment method ending in 7734 that may be expired.',
                      time: '2 days ago',
                      icon: Icons.block_outlined,
                      backgroundColor:
                      const Color(0xFFF7F7FB),
                      borderColor:
                      const Color(0xFF9A9AFF),
                    ),
                  ],
                ),
              ),
            ),

            // =========================================================
            // BOTTOM NAVIGATION
            // =========================================================

            Container(
              height: 58,

              decoration: const BoxDecoration(
                color: Colors.white,

                border: Border(
                  top: BorderSide(
                    color: Color(0xFFE0E0E0),
                    width: 0.8,
                  ),
                ),
              ),

              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceAround,

                children: [

                  // HOME
                  bottomIcon(
                    icon: Icons.home_outlined,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  // UPLOAD / STATEMENT
                  bottomIcon(
                    icon: Icons.receipt_long_outlined,
                    onTap: () {},
                  ),

                  // HISTORY
                  bottomIcon(
                    icon: Icons.access_time_outlined,
                    onTap: () {},
                  ),

                  // PROFILE
                  bottomIcon(
                    icon: Icons.person_outline,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================================================
  // NOTIFICATION CARD
  // ===============================================================

  Widget notificationCard({
    required String title,
    required String description,
    required String time,
    required IconData icon,
    required Color backgroundColor,
    required Color borderColor,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(
        9,
        9,
        9,
        9,
      ),

      decoration: BoxDecoration(
        color: backgroundColor,

        borderRadius: BorderRadius.circular(8),

        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          // =========================================================
          // TITLE ROW
          // =========================================================

          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              // ICON
              Container(
                width: 20,
                height: 20,

                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.65),
                  borderRadius:
                  BorderRadius.circular(3),
                ),

                child: Icon(
                  icon,
                  size: 14,
                  color: Colors.black,
                ),
              ),

              const SizedBox(width: 6),

              // TITLE
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),

              // BLUE DOT
              Container(
                width: 10,
                height: 10,

                margin: const EdgeInsets.only(
                  top: 2,
                  right: 1,
                ),

                decoration: const BoxDecoration(
                  color: Color(0xFF1298F3),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // =========================================================
          // DESCRIPTION
          // =========================================================

          Padding(
            padding: const EdgeInsets.only(
              left: 26,
              right: 8,
            ),

            child: Text(
              description,
              style: const TextStyle(
                fontSize: 8.5,
                height: 1.35,
                color: Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 7),

          // =========================================================
          // TIME
          // =========================================================

          Padding(
            padding: const EdgeInsets.only(
              left: 26,
            ),

            child: Text(
              time,
              style: const TextStyle(
                fontSize: 8.5,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // BOTTOM NAV ICON
  // ===============================================================

  Widget bottomIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: SizedBox(
        width: 55,
        height: 55,

        child: Center(
          child: Icon(
            icon,
            size: 20,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}