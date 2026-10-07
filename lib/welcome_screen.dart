import 'package:flutter/material.dart';

const payLensTitleBlackStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontSize: 40,
  fontWeight: FontWeight.w500,
  color: Colors.black,
  decoration: TextDecoration.none,
);

const payLensTitleBlueStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontSize: 40,
  fontWeight: FontWeight.w500,
  color: Color(0xFF2222C8),
  decoration: TextDecoration.none,
);

const TextStyle headingBlackStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontSize: 30,
  fontWeight: FontWeight.w500,
  color: Colors.black,
  decoration: TextDecoration.none,
);

const TextStyle headingBlueStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontSize: 30,
  fontWeight: FontWeight.w500,
  color: Color(0xFF2222C8),
  decoration: TextDecoration.none,
);

const TextStyle descriptionStyle = TextStyle(
  fontFamily: 'Montserrat',
  fontSize: 20,
  fontWeight: FontWeight.w500,
  color: Color(0xFF777777),
  height: 1.35,
  decoration: TextDecoration.none,
);

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double height = constraints.maxHeight;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PayLens title
                  SizedBox(
                    height: height * 0.13,
                    child: Center(
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Pay',
                              style: payLensTitleBlackStyle,
                            ),
                            TextSpan(
                              text: 'Lens',
                              style: payLensTitleBlueStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Logo
                  SizedBox(
                    height: height * 0.25,
                    child: Center(
                      child: Image.asset(
                        'assets/paylens_logo.png',
                        width: 500,
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.05),

                  const Text(
                    'Smarter insights for',
                    style: headingBlackStyle,
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'your recurring payments',
                    style: headingBlueStyle,
                  ),

                  const SizedBox(height: 15),

                  Text(
                    'Discover hidden subscriptions, spot,\n'
                        'unusual charges, and take control of\n'
                        'your money – all in one place',
                    style: descriptionStyle.copyWith(
                      fontSize: 20,
                      color: const Color(0xFF777777),
                      height: 1.35,
                    ),
                  ),

                  const Spacer(),

                  // Get Started
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/signup',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xE58E3FE8),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Get Started',
                            style: descriptionStyle.copyWith(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 15),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Sign In
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/login',
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(
                          color: Color(0xFFAAAAAA),
                          width: 2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'Sign In',
                        style: descriptionStyle.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}