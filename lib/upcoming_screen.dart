import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpcomingScreen extends StatelessWidget {
  const UpcomingScreen({
    super.key,
    this.items = const [],
  });

  final List<UpcomingPayment> items;

  static const Color primaryBlue = Color(0xFF2222C8);
  static const Color pageBackground = Color(0xFFF7F7FB);

  // ============================================================
  // SAMPLE DATA
  // ============================================================

  List<UpcomingPayment> get _displayItems {
    if (items.isNotEmpty) {
      return items;
    }

    return const [
      UpcomingPayment(
        name: 'Netflix',
        amount: 649.00,
        date: 'Oct 12',
        category: 'Entertainment',
        icon: CupertinoIcons.play_rectangle,
        color: Color(0xFFE50914),
      ),
      UpcomingPayment(
        name: 'Spotify',
        amount: 119.00,
        date: 'Oct 15',
        category: 'Music',
        icon: CupertinoIcons.music_note_2,
        color: Color(0xFF1DB954),
      ),
      UpcomingPayment(
        name: 'Amazon Prime',
        amount: 299.00,
        date: 'Oct 18',
        category: 'Entertainment',
        icon: CupertinoIcons.shopping_cart,
        color: Color(0xFFFF9900),
      ),
    ];
  }

  // ============================================================
  // PAYMENT CARD
  // ============================================================

  Widget _paymentCard(UpcomingPayment payment) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
        ),
      ),
      child: Row(
        children: [
          // ICON
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: payment.color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              payment.icon,
              color: payment.color,
              size: 22,
            ),
          ),

          const SizedBox(width: 11),

          // NAME + CATEGORY
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  payment.category,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 10,
                    color: Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // AMOUNT + DATE
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${payment.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFEFFF),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  payment.date,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: primaryBlue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFEFEFFF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                CupertinoIcons.calendar,
                color: primaryBlue,
                size: 34,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'No upcoming payments',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Your upcoming subscription payments will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 11,
                color: Color(0xFF888888),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SUMMARY CARD
  // ============================================================

  Widget _summaryCard() {
    final double total = _displayItems.fold(
      0,
          (sum, item) => sum + item.amount,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              CupertinoIcons.calendar,
              color: Colors.white,
              size: 21,
            ),
          ),

          const SizedBox(width: 11),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Upcoming payments',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Next scheduled subscriptions',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 9,
                    color: Color(0xFFDCDCFD),
                  ),
                ),
              ],
            ),
          ),

          Text(
            '₹${total.toStringAsFixed(2)}',
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
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
    final List<UpcomingPayment> data = _displayItems;

    return CupertinoPageScaffold(
      backgroundColor: pageBackground,
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: pageBackground,
        border: null,
        middle: Text(
          'Upcoming Payments',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      child: SafeArea(
        child: data.isEmpty
            ? _emptyState()
            : ListView(
          padding: const EdgeInsets.fromLTRB(
            16,
            10,
            16,
            20,
          ),
          children: [
            _summaryCard(),

            const SizedBox(height: 18),

            const Text(
              'UPCOMING',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF777777),
              ),
            ),

            const SizedBox(height: 7),

            ...data.map(_paymentCard),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// UPCOMING PAYMENT MODEL
// ============================================================

class UpcomingPayment {
  final String name;
  final double amount;
  final String date;
  final String category;
  final IconData icon;
  final Color color;

  const UpcomingPayment({
    required this.name,
    required this.amount,
    required this.date,
    required this.category,
    required this.icon,
    required this.color,
  });
}