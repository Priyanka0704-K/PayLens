import 'package:flutter/material.dart';

class AuditPreferencesScreen extends StatefulWidget {
  const AuditPreferencesScreen({
    super.key,
  });

  @override
  State<AuditPreferencesScreen> createState() =>
      _AuditPreferencesScreenState();
}

class _AuditPreferencesScreenState
    extends State<AuditPreferencesScreen> {

  bool renewalAlerts = true;
  bool recurringPaymentAlerts = true;
  bool duplicateSubscriptionAlerts = true;
  bool monthlySummary = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Audit Preferences',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            const Text(
              'Audit Preferences',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Choose how PayLens monitors your '
                  'recurring payments and subscriptions.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'ALERTS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF777777),
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 10),

            preferenceCard(
              icon: Icons.calendar_today_outlined,
              title: 'Renewal Alerts',
              description:
              'Get notified before a subscription renews.',
              value: renewalAlerts,
              onChanged: (value) {
                setState(() {
                  renewalAlerts = value;
                });
              },
            ),

            const SizedBox(height: 10),

            preferenceCard(
              icon: Icons.autorenew,
              title: 'Recurring Payment Alerts',
              description:
              'Notify me when recurring payments are detected.',
              value: recurringPaymentAlerts,
              onChanged: (value) {
                setState(() {
                  recurringPaymentAlerts = value;
                });
              },
            ),

            const SizedBox(height: 10),

            preferenceCard(
              icon: Icons.warning_amber_outlined,
              title: 'Duplicate Subscription Alerts',
              description:
              'Alert me when potentially overlapping '
                  'subscriptions are found.',
              value: duplicateSubscriptionAlerts,
              onChanged: (value) {
                setState(() {
                  duplicateSubscriptionAlerts = value;
                });
              },
            ),

            const SizedBox(height: 25),

            const Text(
              'REPORTS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF777777),
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 10),

            preferenceCard(
              icon: Icons.bar_chart_outlined,
              title: 'Monthly Spending Summary',
              description:
              'Receive a summary of recurring '
                  'subscription spending.',
              value: monthlySummary,
              onChanged: (value) {
                setState(() {
                  monthlySummary = value;
                });
              },
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0FF),
                borderRadius:
                BorderRadius.circular(9),
              ),
              child: const Row(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Icon(
                    Icons.info_outline,
                    size: 19,
                    color: Color(0xFF2222C8),
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      'You can change these preferences '
                          'at any time. PayLens uses them to '
                          'personalize your subscription audit.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: Color(0xFF555555),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PREFERENCE CARD
  // ============================================================

  Widget preferenceCard({
    required IconData icon,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFD0D0D0),
        ),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE7E4FF),
              borderRadius:
              BorderRadius.circular(9),
            ),
            child: Icon(
              icon,
              size: 20,
              color: const Color(0xFF2222C8),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.35,
                    color: Color(0xFF777777),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Switch(
            value: value,
            activeTrackColor:
            const Color(0xFF2222C8),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}