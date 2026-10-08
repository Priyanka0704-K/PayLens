import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() =>
      _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState
    extends State<PaymentMethodsScreen> {

  final List<Map<String, String>> paymentMethods = [
    {
      'type': 'UPI',
      'name': 'Google Pay',
      'details': 'Primary payment method',
    },
  ];

  // ============================================================
  // ADD PAYMENT METHOD
  // ============================================================

  void addPaymentMethod() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const Text(
                  'Add Payment Method',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Choose a payment method to add.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: Color(0xFF2222C8),
                  ),
                  title: const Text('UPI'),
                  subtitle: const Text(
                    'Google Pay, PhonePe, Paytm',
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    addMethod(
                      'UPI',
                      'UPI Payment',
                      'Available for subscriptions',
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.credit_card_outlined,
                    color: Color(0xFF2222C8),
                  ),
                  title: const Text(
                    'Debit / Credit Card',
                  ),
                  subtitle: const Text(
                    'Add a card for subscription tracking',
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    addMethod(
                      'Card',
                      'Debit / Credit Card',
                      'Subscription payment card',
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.account_balance_outlined,
                    color: Color(0xFF2222C8),
                  ),
                  title: const Text(
                    'Bank Account',
                  ),
                  subtitle: const Text(
                    'Track payments from your bank',
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    addMethod(
                      'Bank',
                      'Bank Account',
                      'Bank payment method',
                    );
                  },
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // ADD METHOD
  // ============================================================

  void addMethod(
      String type,
      String name,
      String details,
      ) {
    setState(() {
      paymentMethods.add({
        'type': type,
        'name': name,
        'details': details,
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$name added successfully',
        ),
      ),
    );
  }

  // ============================================================
  // REMOVE METHOD
  // ============================================================

  void removePaymentMethod(int index) {
    setState(() {
      paymentMethods.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Payment method removed',
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Payment Methods',
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
              'Payment Methods',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Manage the payment methods used '
                  'for your subscriptions.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'SAVED METHODS',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF777777),
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 10),

            if (paymentMethods.isEmpty)
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFD0D0D0),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.credit_card_outlined,
                      size: 35,
                      color: Color(0xFF777777),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'No payment methods added',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      'Add a payment method to track '
                          'subscription payments.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

            ...List.generate(
              paymentMethods.length,
                  (index) {
                final method = paymentMethods[index];

                return Container(
                  margin: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFD0D0D0),
                    ),
                  ),
                  child: Row(
                    children: [

                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7E4FF),
                          borderRadius:
                          BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.credit_card_outlined,
                          color: Color(0xFF2222C8),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            Text(
                              method['name'] ?? '',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              method['details'] ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                color:
                                Color(0xFF777777),
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              method['type'] ?? '',
                              style: const TextStyle(
                                fontSize: 11,
                                color:
                                Color(0xFF2222C8),
                                fontWeight:
                                FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          removePaymentMethod(index);
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: Color(0xFFD13F3F),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: addPaymentMethod,
                icon: const Icon(
                  Icons.add,
                  size: 19,
                ),
                label: const Text(
                  'Add Payment Method',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(0xFF2222C8),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(13),
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
                    Icons.lock_outline,
                    size: 18,
                    color: Color(0xFF2222C8),
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      'PayLens does not require your '
                          'banking password or direct bank '
                          'login credentials.',
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
}