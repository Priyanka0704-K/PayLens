import 'package:flutter/material.dart';

import 'analyzing_payments_screen.dart';
import 'subscription_screen.dart';
import 'profile_settings_screen.dart';

const Color payLensBlue = Color(0xFF2929C9);

class DashboardScreen extends StatefulWidget {
  final List<BankTransaction> payments;
  final String pdfFileName;
  final String pdfText;

  // Logged-in user's details.
  final String userName;
  final String userEmail;

  const DashboardScreen({
    super.key,
    this.payments = const [],
    this.pdfFileName = '',
    this.pdfText = '',
    this.userName = '',
    this.userEmail = '',
  });

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {
  int selectedBottom = 0;

  double get totalSubscriptionSpend {
    return widget.payments.fold(
      0.0,
          (sum, item) => sum + item.amount,
    );
  }

  int get subscriptionCount =>
      widget.payments.length;

  String get userInitial {
    final name = widget.userName.trim();

    if (name.isEmpty) {
      return 'U';
    }

    return name.substring(0, 1).toUpperCase();
  }

  void openSubscriptions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SubscriptionScreen(
          payments: widget.payments,
        ),
      ),
    );
  }

  void openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileSettingsScreen(
          userName: widget.userName,
          userEmail: widget.userEmail,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, screen) {
            final compact = screen.maxHeight < 650;

            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Column(
                      children: [
                        // =========================
                        // HEADER
                        // =========================

                        SizedBox(
                          height: compact ? 54 : 62,
                          child: Row(
                            children: [
                              SizedBox(
                                width: compact ? 30 : 34,
                                height: compact ? 30 : 34,
                                child: Image.asset(
                                  'assets/paylens_logo.png',
                                  fit: BoxFit.contain,
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return const Icon(
                                      Icons
                                          .account_balance_wallet_rounded,
                                      color: payLensBlue,
                                      size: 27,
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(width: 7),

                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Pay',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                        compact ? 22 : 25,
                                        fontWeight:
                                        FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Lens',
                                      style: TextStyle(
                                        color: payLensBlue,
                                        fontSize:
                                        compact ? 22 : 25,
                                        fontWeight:
                                        FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Spacer(),

                              // =========================
                              // USER INITIAL
                              // =========================

                              GestureDetector(
                                behavior:
                                HitTestBehavior.opaque,
                                onTap: openProfile,
                                child: Container(
                                  width:
                                  compact ? 38 : 42,
                                  height:
                                  compact ? 38 : 42,
                                  decoration:
                                  const BoxDecoration(
                                    color:
                                    Color(0xFFEDEDFF),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      userInitial,
                                      style:
                                      TextStyle(
                                        color:
                                        payLensBlue,
                                        fontSize:
                                        compact
                                            ? 16
                                            : 18,
                                        fontWeight:
                                        FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // =========================
                        // SUBSCRIPTION SUMMARY
                        // =========================

                        Container(
                          width: double.infinity,
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: payLensBlue,
                            borderRadius:
                            BorderRadius.circular(17),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize:
                                  MainAxisSize.min,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Your subscription spend',
                                      maxLines: 1,
                                      overflow:
                                      TextOverflow
                                          .ellipsis,
                                      style: TextStyle(
                                        color:
                                        Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 3,
                                    ),

                                    Text(
                                      '₹${totalSubscriptionSpend.toStringAsFixed(2)}',
                                      maxLines: 1,
                                      overflow:
                                      TextOverflow
                                          .ellipsis,
                                      style:
                                      const TextStyle(
                                        color:
                                        Colors.white,
                                        fontSize: 26,
                                        fontWeight:
                                        FontWeight.w700,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 2,
                                    ),

                                    Text(
                                      '$subscriptionCount subscription'
                                          '${subscriptionCount == 1 ? '' : 's'} detected',
                                      maxLines: 1,
                                      overflow:
                                      TextOverflow
                                          .ellipsis,
                                      style:
                                      const TextStyle(
                                        color:
                                        Colors.white70,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 12),

                              Container(
                                width: 44,
                                height: 44,
                                decoration:
                                BoxDecoration(
                                  color: Colors.white
                                      .withValues(
                                    alpha: 0.15,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons
                                      .subscriptions_rounded,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // =========================
                        // ANALYZED PDF
                        // =========================

                        if (widget.pdfFileName.isNotEmpty)
                          SizedBox(
                            height: 26,
                            child: Align(
                              alignment:
                              Alignment.centerLeft,
                              child: Text(
                                'Analyzed: ${widget.pdfFileName}',
                                maxLines: 1,
                                overflow:
                                TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color:
                                  Color(0xFF888888),
                                  fontSize: 9,
                                ),
                              ),
                            ),
                          ),

                        // =========================
                        // SUBSCRIPTIONS TITLE
                        // =========================

                        SizedBox(
                          height: compact ? 34 : 38,
                          child: Row(
                            children: [
                              const Icon(
                                Icons
                                    .subscriptions_rounded,
                                color: payLensBlue,
                                size: 21,
                              ),

                              const SizedBox(width: 7),

                              const Text(
                                'Subscriptions',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 19,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),

                              const SizedBox(width: 7),

                              Container(
                                padding:
                                const EdgeInsets
                                    .symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration:
                                BoxDecoration(
                                  color:
                                  const Color(
                                    0xFFEDEEFF,
                                  ),
                                  borderRadius:
                                  BorderRadius
                                      .circular(20),
                                ),
                                child: Text(
                                  '$subscriptionCount',
                                  style:
                                  const TextStyle(
                                    color:
                                    payLensBlue,
                                    fontSize: 10,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // =========================
                        // SUBSCRIPTIONS
                        // =========================

                        Expanded(
                          child: LayoutBuilder(
                            builder:
                                (context, box) {
                              return _subscriptionSection(
                                box.maxHeight,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // =========================
                // BOTTOM NAVIGATION
                // =========================

                Container(
                  height: 50,
                  decoration:
                  const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        color:
                        Color(0xFFE2E2E2),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceAround,
                    children: [
                      _bottomItem(
                        Icons.home_rounded,
                        'Home',
                        0,
                      ),
                      _bottomItem(
                        Icons
                            .subscriptions_rounded,
                        'Subscriptions',
                        1,
                      ),
                      _bottomItem(
                        Icons.history_rounded,
                        'History',
                        2,
                      ),
                      _bottomItem(
                        Icons
                            .person_outline_rounded,
                        'Profile',
                        3,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // =========================================================
  // SUBSCRIPTION SECTION
  // =========================================================

  Widget _subscriptionSection(
      double availableHeight,
      ) {
    if (widget.payments.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.subscriptions_outlined,
              color: Color(0xFF999999),
              size: 42,
            ),

            SizedBox(height: 8),

            Text(
              'No subscriptions found',
              style: TextStyle(
                color: Color(0xFF777777),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: 3),

            Text(
              'No subscription payments were detected in this statement.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF999999),
                fontSize: 10,
              ),
            ),
          ],
        ),
      );
    }

    const cardHeight = 58.0;
    const cardGap = 5.0;
    const moreHeight = 24.0;

    int possibleCards =
    ((availableHeight - moreHeight) /
        (cardHeight + cardGap))
        .floor();

    if (possibleCards < 1) {
      possibleCards = 1;
    }

    if (possibleCards >
        widget.payments.length) {
      possibleCards =
          widget.payments.length;
    }

    final visible =
    widget.payments
        .take(possibleCards)
        .toList();

    final remaining =
        widget.payments.length -
            visible.length;

    return Column(
      children: [
        ...visible.map(
              (item) => _subscriptionCard(
            item,
            cardHeight,
          ),
        ),

        const Spacer(),

        if (remaining > 0)
          SizedBox(
            height: moreHeight,
            child: GestureDetector(
              behavior:
              HitTestBehavior.opaque,
              onTap: openSubscriptions,
              child: Center(
                child: Text(
                  '+$remaining more subscriptions',
                  style: const TextStyle(
                    color: payLensBlue,
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // =========================================================
  // SUBSCRIPTION CARD
  // =========================================================

  Widget _subscriptionCard(
      BankTransaction subscription,
      double height,
      ) {
    return Container(
      width: double.infinity,
      height: height,
      margin:
      const EdgeInsets.only(bottom: 5),
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E2EA),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration:
            const BoxDecoration(
              color: Color(0xFFEEEEFF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.subscriptions_rounded,
              color: payLensBlue,
              size: 20,
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
                  subscription.description,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  'Detected from ${subscription.date}',
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          Text(
            '₹${subscription.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight:
              FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // BOTTOM NAVIGATION
  // =========================================================

  Widget _bottomItem(
      IconData icon,
      String label,
      int index,
      ) {
    final selected =
        selectedBottom == index;

    return GestureDetector(
      onTap: () {
        if (index == 1) {
          setState(() {
            selectedBottom = 1;
          });

          openSubscriptions();
          return;
        }

        if (index == 3) {
          setState(() {
            selectedBottom = 3;
          });

          openProfile();
          return;
        }

        setState(() {
          selectedBottom = index;
        });
      },
      child: SizedBox(
        width: 80,
        height: 50,
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: selected
                  ? payLensBlue
                  : const Color(0xFF999999),
            ),

            const SizedBox(height: 1),

            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: selected
                    ? payLensBlue
                    : const Color(0xFF999999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}