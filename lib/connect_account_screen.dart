import 'package:flutter/material.dart';
import 'upload_statement_screen.dart';

class ConnectAccountScreen extends StatefulWidget {
  const ConnectAccountScreen({super.key});

  @override
  State<ConnectAccountScreen> createState() =>
      _ConnectAccountScreenState();
}

class _ConnectAccountScreenState
    extends State<ConnectAccountScreen> {
  int selectedOption = -1;

  static const Color primaryBlue = Color(0xFF2222C8);

  void selectOption(int index) {
    setState(() {
      selectedOption = index;
    });
  }

  void connectAccount() {
    if (selectedOption == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select an account option.',
          ),
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
        const UploadStatementScreen(),
      ),
    );
  }

  void doLater() {
    Navigator.pushReplacementNamed(
      context,
      '/dashboard',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double screenHeight =
                constraints.maxHeight;

            final bool compact = screenHeight < 700;

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: compact ? 8 : 14,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  // LOGO
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/paylens_logo.png',
                        width: compact ? 30 : 35,
                        height: compact ? 30 : 35,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 9),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Pay',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: 'Lens',
                              style: TextStyle(
                                color: primaryBlue,
                                fontSize: 26,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: compact ? 15 : 24,
                  ),

                  // TITLE
                  Text(
                    'Find your recurring payments',
                    style: TextStyle(
                      fontSize: compact ? 22 : 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    'Connect a payment source so PayLens can '
                        'identify recurring transactions and '
                        'subscription patterns.',
                    style: TextStyle(
                      fontSize: compact ? 13 : 15,
                      height: 1.35,
                      color: Colors.black54,
                    ),
                  ),

                  SizedBox(
                    height: compact ? 12 : 18,
                  ),

                  // BANK ACCOUNT
                  _accountOption(
                    index: 0,
                    icon: Icons.account_balance,
                    iconColor: primaryBlue,
                    title: 'Bank Account',
                    subtitle:
                    'Analyze recurring bank transactions',
                    compact: compact,
                  ),

                  SizedBox(
                    height: compact ? 8 : 11,
                  ),

                  // CREDIT / DEBIT CARD
                  _accountOption(
                    index: 4,
                    icon: Icons.credit_card,
                    iconColor: const Color(0xFF149447),
                    title: 'Credit / Debit Card',
                    subtitle:
                    'Identify recurring card payments',
                    compact: compact,
                  ),

                  SizedBox(
                    height: compact ? 8 : 11,
                  ),

                  // UPLOAD STATEMENT
                  _accountOption(
                    index: 2,
                    icon: Icons.description,
                    iconColor: const Color(0xFF7B3FF2),
                    title: 'Upload Statement',
                    subtitle:
                    'Import a bank or card statement file',
                    showArrow: true,
                    compact: compact,
                  ),

                  SizedBox(
                    height: compact ? 10 : 14,
                  ),

                  // SECURITY INFORMATION
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: compact ? 10 : 13,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1FFF3),
                      border: Border.all(
                        color: const Color(0xFF8ED79A),
                      ),
                      borderRadius:
                      BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          color: const Color(0xFF3B9B4A),
                          size: compact ? 21 : 25,
                        ),
                        const SizedBox(width: 9),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Read-only access',
                                style: TextStyle(
                                  fontSize:
                                  compact ? 15 : 18,
                                  fontWeight:
                                  FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Your payment information is analyzed '
                                    'to identify recurring patterns. PayLens '
                                    'never stores or shares your credentials.',
                                style: TextStyle(
                                  fontSize:
                                  compact ? 11 : 13,
                                  height: 1.3,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // CONNECT BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: compact ? 44 : 50,
                    child: ElevatedButton(
                      onPressed: connectAccount,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(7),
                        ),
                      ),
                      child: Text(
                        'Connect Account',
                        style: TextStyle(
                          fontSize: compact ? 14 : 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: compact ? 8 : 14,
                  ),

                  // DO LATER
                  Center(
                    child: GestureDetector(
                      onTap: doLater,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: compact ? 4 : 10,
                        ),
                        child: Text(
                          'Do this later',
                          style: TextStyle(
                            fontSize: compact ? 12 : 14,
                            color: primaryBlue,
                            fontWeight:
                            FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _accountOption({
    required int index,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    bool showArrow = false,
    bool compact = false,
  }) {
    final bool selected =
        selectedOption == index;

    return GestureDetector(
      onTap: () {
        if (index == 2) {
          if (selectedOption == 0 ||
              selectedOption == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const UploadStatementScreen(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(
              const SnackBar(
                content: Text(
                  'Please select Bank Account or Credit / Debit Card first.',
                ),
              ),
            );
          }
        } else {
          selectOption(index);
        }
      },
      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 180),
        width: double.infinity,

        // Smaller cards on short screens
        height: compact ? 78 : 90,

        padding: EdgeInsets.symmetric(
          horizontal: 13,
          vertical: compact ? 10 : 12,
        ),

        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFF5F1FF)
              : Colors.white,
          border: Border.all(
            color: selected
                ? const Color(0xFF9B5CFF)
                : const Color(0xFFAAAAAA),
            width: selected ? 1.5 : 2,
          ),
          borderRadius:
          BorderRadius.circular(8),
        ),

        child: Row(
          children: [
            Container(
              width: compact ? 42 : 48,
              height: compact ? 42 : 48,
              decoration: BoxDecoration(
                color: iconColor.withValues(
                  alpha: 0.12,
                ),
                borderRadius:
                BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: compact ? 19 : 21,
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
                    title,
                    style: TextStyle(
                      fontSize:
                      compact ? 15 : 18,
                      fontWeight:
                      FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize:
                      compact ? 11 : 13,
                      height: 1.2,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            if (showArrow)
              Icon(
                Icons.chevron_right,
                size: compact ? 20 : 23,
                color: Colors.black87,
              )
            else
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? primaryBlue
                        : const Color(0xFF999999),
                    width: 1.3,
                  ),
                ),
                child: selected
                    ? Center(
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration:
                    const BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryBlue,
                    ),
                  ),
                )
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}