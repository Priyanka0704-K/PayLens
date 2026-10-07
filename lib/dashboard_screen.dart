import 'package:flutter/material.dart';

import 'analyzing_payments_screen.dart';
import 'history_screen.dart';
import 'profile_settings_screen.dart';
import 'subscription_screen.dart';
import 'upload_statement_screen.dart';

const Color payLensBlue = Color(0xFF2929C9);

class DashboardScreen extends StatefulWidget {
  final List<BankTransaction> payments;
  final String pdfFileName;
  final String pdfText;
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

  double get totalSpending {
    return widget.payments
        .where((item) => !item.isCredit)
        .fold(
      0.0,
          (sum, item) => sum + item.amount,
    );
  }

  int get spendingCount {
    return widget.payments
        .where((item) => !item.isCredit)
        .length;
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

  void openHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const HistoryScreen(),
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
          payments: widget.payments,
        ),
      ),
    );
  }

  void openUpload() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
        const UploadStatementScreen(),
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
                // ======================================================
                // MAIN CONTENT
                // ======================================================

                Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: Column(
                      children: [
                        // ==================================================
                        // HEADER
                        // ==================================================

                        SizedBox(
                          height: compact ? 50 : 60,
                          child: Row(
                            children: [
                              SizedBox(
                                width: compact ? 29 : 32,
                                height: compact ? 29 : 32,
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

                              GestureDetector(
                                onTap: openProfile,
                                child: Container(
                                  width: compact ? 38 : 42,
                                  height: compact ? 38 : 42,
                                  decoration:
                                  const BoxDecoration(
                                    color: Color(0xFFEDEDFF),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons
                                        .person_outline_rounded,
                                    color: payLensBlue,
                                    size: 21,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ==================================================
                        // TOTAL SPENDING
                        // ==================================================

                        Container(
                          width: double.infinity,
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
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
                                      'Total spending',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),

                                    const SizedBox(height: 2),

                                    Text(
                                      '₹${totalSpending.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight:
                                        FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 2),

                                    Text(
                                      '$spendingCount payments',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: Colors.white
                                      .withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.bar_chart_rounded,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ==================================================
                        // PDF FILE NAME
                        // ==================================================

                        if (widget.pdfFileName.isNotEmpty)
                          SizedBox(
                            height: 19,
                            child: Align(
                              alignment:
                              Alignment.centerLeft,
                              child: Text(
                                widget.pdfFileName,
                                maxLines: 1,
                                overflow:
                                TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color:
                                  Color(0xFF999999),
                                  fontSize: 9,
                                ),
                              ),
                            ),
                          ),

                        // ==================================================
                        // TRANSACTIONS HEADER
                        // ==================================================

                        SizedBox(
                          height: compact ? 29 : 32,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.receipt_long_rounded,
                                color: payLensBlue,
                                size: 21,
                              ),

                              const SizedBox(width: 7),

                              const Text(
                                'Transactions',
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
                                const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                  const Color(
                                    0xFFEDEEFF,
                                  ),
                                  borderRadius:
                                  BorderRadius.circular(
                                    20,
                                  ),
                                ),
                                child: Text(
                                  '${widget.payments.length}',
                                  style:
                                  const TextStyle(
                                    color: payLensBlue,
                                    fontSize: 10,
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ==================================================
                        // TRANSACTIONS
                        // ==================================================

                        Expanded(
                          child: LayoutBuilder(
                            builder: (
                                context,
                                box,
                                ) {
                              return _transactionSection(
                                box.maxHeight,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ======================================================
                // BOTTOM BAR + PLUS BUTTON
                // ======================================================

                SizedBox(
                  height: 72,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // ==================================================
                      // BOTTOM NAVIGATION BAR
                      // ==================================================

                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 58,
                          decoration:
                          const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              top: BorderSide(
                                color:
                                Color(0xFFE0E0E0),
                                width: 1,
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
                      ),

                      // ==================================================
                      // PLUS BUTTON
                      //
                      // IMPORTANT:
                      // bottom bar top = 14
                      // circle height = 56
                      // top = -14
                      //
                      // So circle center sits EXACTLY on
                      // the top border of bottom bar.
                      // ==================================================

                      Positioned(
                        right: 12,
                        top: -45,
                        child: Container(
                          width: 56,
                          height: 56,
                          padding:
                          const EdgeInsets.all(3),
                          decoration:
                          const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            decoration:
                            const BoxDecoration(
                              color: payLensBlue,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: openUpload,
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 31,
                              ),
                            ),
                          ),
                        ),
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

  // ================================================================
  // TRANSACTION SECTION
  // ================================================================

  Widget _transactionSection(
      double availableHeight,
      ) {
    if (widget.payments.isEmpty) {
      return const Center(
        child: Text(
          'No transactions detected',
          style: TextStyle(
            color: Color(0xFF888888),
            fontSize: 14,
          ),
        ),
      );
    }

    const cardHeight = 54.0;
    const cardGap = 4.0;
    const moreHeight = 22.0;

    int possibleCards =
    ((availableHeight - moreHeight) /
        (cardHeight + cardGap))
        .floor();

    if (possibleCards < 1) {
      possibleCards = 1;
    }

    if (possibleCards > widget.payments.length) {
      possibleCards = widget.payments.length;
    }

    final visible =
    widget.payments.take(possibleCards).toList();

    final remaining =
        widget.payments.length - visible.length;

    return Column(
      children: [
        ...visible.map(
              (item) => _transactionCard(
            item,
            cardHeight,
          ),
        ),

        const Spacer(),

        if (remaining > 0)
          SizedBox(
            height: moreHeight,
            child: GestureDetector(
              onTap: openSubscriptions,
              child: Center(
                child: Text(
                  '+$remaining more',
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

  // ================================================================
  // CLEAN TRANSACTION NAME
  //
  // Removes:
  // Currency
  // INR
  // Rs
  // ₹
  //
  // So:
  // "September Currency INR (n) Subscription Transactions"
  //
  // becomes:
  // "September Subscription Transactions"
  // ================================================================

  String _cleanTransactionName(
      String value,
      ) {
    String text = value;

    text = text.replaceAll(
      RegExp(
        r'\bCurrency\b',
        caseSensitive: false,
      ),
      '',
    );

    text = text.replaceAll(
      RegExp(
        r'\bINR\b',
        caseSensitive: false,
      ),
      '',
    );

    text = text.replaceAll(
      RegExp(
        r'\bRs\.?\b',
        caseSensitive: false,
      ),
      '',
    );

    text = text.replaceAll('₹', '');

    text = text.replaceAll(
      RegExp(r'\s+'),
      ' ',
    );

    return text.trim();
  }

  // ================================================================
  // TRANSACTION CARD
  // ================================================================

  Widget _transactionCard(
      BankTransaction transaction,
      double height,
      ) {
    final cleanName =
    _cleanTransactionName(
      transaction.description,
    );

    return Container(
      width: double.infinity,
      height: height,
      margin:
      const EdgeInsets.only(
        bottom: 5,
      ),
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration:
      BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(12),
        border: Border.all(
          color:
          const Color(0xFFE0E2EA),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration:
            const BoxDecoration(
              color:
              Color(0xFFEEEEFF),
              shape:
              BoxShape.circle,
            ),
            child: Icon(
              _transactionIcon(
                cleanName,
              ),
              color:
              payLensBlue,
              size: 20,
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment
                  .center,
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  cleanName.isEmpty
                      ? 'Transaction'
                      : cleanName,
                  maxLines: 1,
                  overflow:
                  TextOverflow
                      .ellipsis,
                  style:
                  const TextStyle(
                    color:
                    Colors.black,
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(
                  height: 2,
                ),

                Text(
                  transaction.date,
                  style:
                  const TextStyle(
                    color:
                    Color(0xFF999999),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _transactionIcon(
      String description,
      ) {
    final text =
    description.toLowerCase();

    if (text.contains('netflix') ||
        text.contains('spotify') ||
        text.contains('subscription')) {
      return Icons
          .subscriptions_rounded;
    }

    if (text.contains('amazon') ||
        text.contains('purchase')) {
      return Icons
          .shopping_bag_rounded;
    }

    if (text.contains('grocery')) {
      return Icons
          .shopping_cart_rounded;
    }

    if (text.contains('electricity')) {
      return Icons.bolt_rounded;
    }

    if (text.contains('mobile') ||
        text.contains('phone')) {
      return Icons
          .phone_android_rounded;
    }

    if (text.contains('upi') ||
        text.contains('transfer') ||
        text.contains('neft') ||
        text.contains('imps')) {
      return Icons
          .swap_horiz_rounded;
    }

    if (text.contains('atm') ||
        text.contains('withdrawal')) {
      return Icons.local_atm_rounded;
    }

    return Icons.payments_rounded;
  }

  // ================================================================
  // BOTTOM NAV ITEM
  // ================================================================

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

        if (index == 2) {
          setState(() {
            selectedBottom = 2;
          });

          openHistory();
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
          selectedBottom = 0;
        });
      },
      child: SizedBox(
        width: 78,
        height: 58,
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 23,
              color: selected
                  ? payLensBlue
                  : const Color(
                0xFF999999,
              ),
            ),

            const SizedBox(height: 1),

            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: selected
                    ? payLensBlue
                    : const Color(
                  0xFF999999,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}