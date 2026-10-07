import 'package:flutter/material.dart';
import 'analyzing_payments_screen.dart';

const Color payLensBlue = Color(0xFF2929C9);

class SubscriptionScreen extends StatefulWidget {
  final List<BankTransaction> payments;

  const SubscriptionScreen({
    super.key,
    required this.payments,
  });

  @override
  State<SubscriptionScreen> createState() =>
      _SubscriptionScreenState();
}

class _SubscriptionScreenState
    extends State<SubscriptionScreen> {
  int selectedTab = 0;

  // ------------------------------------------------------------
  // FILTERED DATA
  // ------------------------------------------------------------

  List<BankTransaction> get filteredPayments {
    if (selectedTab == 0) {
      return widget.payments;
    }

    if (selectedTab == 1) {
      return widget.payments.where((payment) {
        return _isMonthly(payment.description);
      }).toList();
    }

    return widget.payments.where((payment) {
      return _isYearly(payment.description);
    }).toList();
  }

  bool _isMonthly(String description) {
    final text = description.toLowerCase();

    const monthlyWords = [
      'monthly',
      'month',
      'netflix',
      'spotify',
      'canva',
      'youtube premium',
      'youtube music',
      'google one',
      'google storage',
      'amazon prime',
      'prime video',
      'hotstar',
      'jiohotstar',
      'sonyliv',
      'zee5',
      'adobe',
      'creative cloud',
      'microsoft 365',
      'office 365',
      'icloud',
      'dropbox',
      'notion',
      'zoom',
      'grammarly',
      'chatgpt',
      'openai',
      'membership',
      'subscription',
      'premium',
      'autopay',
      'auto pay',
      'recurring',
    ];

    return monthlyWords.any(
          (word) => text.contains(word),
    );
  }

  bool _isYearly(String description) {
    final text = description.toLowerCase();

    const yearlyWords = [
      'yearly',
      'annual',
      'annually',
      'annual plan',
      'year plan',
      '12 month',
    ];

    return yearlyWords.any(
          (word) => text.contains(word),
    );
  }

  double get totalAmount {
    return filteredPayments.fold(
      0.0,
          (sum, payment) => sum + payment.amount,
    );
  }

  // ------------------------------------------------------------
  // APP / SERVICE DOMAIN DETECTION
  // ------------------------------------------------------------

  String? _getAppDomain(String description) {
    final text = description.toLowerCase();

    // Entertainment
    if (text.contains('netflix')) {
      return 'netflix.com';
    }

    if (text.contains('spotify')) {
      return 'spotify.com';
    }

    if (text.contains('youtube')) {
      return 'youtube.com';
    }

    if (text.contains('amazon') ||
        text.contains('prime video') ||
        text.contains('amazon prime')) {
      return 'amazon.com';
    }

    if (text.contains('disney')) {
      return 'disneyplus.com';
    }

    if (text.contains('hotstar') ||
        text.contains('jiohotstar')) {
      return 'hotstar.com';
    }

    if (text.contains('sonyliv')) {
      return 'sonyliv.com';
    }

    if (text.contains('zee5')) {
      return 'zee5.com';
    }

    if (text.contains('gaana')) {
      return 'gaana.com';
    }

    if (text.contains('wynk')) {
      return 'wynk.in';
    }

    // Software / Cloud
    if (text.contains('adobe') ||
        text.contains('creative cloud')) {
      return 'adobe.com';
    }

    if (text.contains('canva')) {
      return 'canva.com';
    }

    if (text.contains('microsoft') ||
        text.contains('office 365')) {
      return 'microsoft.com';
    }

    if (text.contains('google one') ||
        text.contains('google storage')) {
      return 'one.google.com';
    }

    if (text.contains('icloud')) {
      return 'icloud.com';
    }

    if (text.contains('dropbox')) {
      return 'dropbox.com';
    }

    if (text.contains('notion')) {
      return 'notion.so';
    }

    if (text.contains('zoom')) {
      return 'zoom.us';
    }

    if (text.contains('grammarly')) {
      return 'grammarly.com';
    }

    if (text.contains('chatgpt') ||
        text.contains('openai')) {
      return 'openai.com';
    }

    if (text.contains('linkedin')) {
      return 'linkedin.com';
    }

    // Education
    if (text.contains('coursera')) {
      return 'coursera.org';
    }

    if (text.contains('udemy')) {
      return 'udemy.com';
    }

    // Fitness
    if (text.contains('cult.fit') ||
        text.contains('cultfit')) {
      return 'cult.fit';
    }

    return null;
  }

  // ------------------------------------------------------------
  // APP LOGO
  // ------------------------------------------------------------

  Widget _appLogo(String description) {
    final String? domain =
    _getAppDomain(description);

    // Unknown service
    if (domain == null) {
      return Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Color(0xFFEDEBFF),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.subscriptions_rounded,
          color: payLensBlue,
          size: 21,
        ),
      );
    }

    return Container(
      width: 40,
      height: 40,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFE1E1EA),
        ),
      ),
      child: ClipOval(
        child: Image.network(
          'https://www.google.com/s2/favicons?domain=$domain&sz=128',
          width: 28,
          height: 28,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) {
            return const Icon(
              Icons.subscriptions_rounded,
              color: payLensBlue,
              size: 21,
            );
          },
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final List<BankTransaction> items =
        filteredPayments;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FC),
      body: SafeArea(
        child: Column(
          children: [
            // --------------------------------------------------
            // HEADER
            // --------------------------------------------------

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                10,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(11),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 17,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Image.asset(
                    'assets/paylens_logo.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) {
                      return const SizedBox(
                        width: 30,
                        height: 30,
                      );
                    },
                  ),

                  const SizedBox(width: 7),

                  const Text(
                    'Pay',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),

                  const Text(
                    'Lens',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: payLensBlue,
                    ),
                  ),

                  const Spacer(),

                  const Text(
                    'Subscriptions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // --------------------------------------------------
            // SUMMARY
            // --------------------------------------------------

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: payLensBlue,
                  borderRadius:
                  BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            selectedTab == 0
                                ? 'All subscriptions'
                                : selectedTab == 1
                                ? 'Monthly subscriptions'
                                : 'Yearly subscriptions',
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight:
                              FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            '₹${totalAmount.toStringAsFixed(2)}',
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            '${items.length} subscriptions',
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
                        color: Colors.white.withValues(
                          alpha: 0.15,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.subscriptions_rounded,
                        color: Colors.white,
                        size: 23,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // --------------------------------------------------
            // TABS
            // --------------------------------------------------

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Container(
                height: 43,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9E9F4),
                  borderRadius:
                  BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _tabButton(
                      title: 'All',
                      index: 0,
                    ),
                    _tabButton(
                      title: 'Monthly',
                      index: 1,
                    ),
                    _tabButton(
                      title: 'Yearly',
                      index: 2,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // --------------------------------------------------
            // SUBSCRIPTIONS
            // --------------------------------------------------

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: items.isEmpty
                    ? _emptyState()
                    : Column(
                  children: List.generate(
                    items.length,
                        (index) {
                      return Expanded(
                        child: Padding(
                          padding:
                          const EdgeInsets.only(
                            bottom: 6,
                          ),
                          child:
                          _subscriptionCard(
                            items[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // TAB BUTTON
  // ------------------------------------------------------------

  Widget _tabButton({
    required String title,
    required int index,
  }) {
    final bool selected =
        selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? Colors.white
                : Colors.transparent,
            borderRadius:
            BorderRadius.circular(9),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected
                  ? payLensBlue
                  : const Color(0xFF777777),
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SUBSCRIPTION CARD
  // ------------------------------------------------------------

  Widget _subscriptionCard(
      BankTransaction payment,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFDCDCE8),
        ),
      ),
      child: Row(
        children: [
          // ACTUAL APP LOGO
          _appLogo(payment.description),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                Text(
                  payment.description,
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Detected from ${payment.date}',
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Text(
            '₹${payment.amount.toStringAsFixed(2)}',
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // EMPTY STATE
  // ------------------------------------------------------------

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFEDEBFF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.subscriptions_outlined,
              color: payLensBlue,
              size: 32,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'No subscriptions found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'No matching subscriptions were detected.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF888888),
            ),
          ),
        ],
      ),
    );
  }
}