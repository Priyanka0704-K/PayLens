import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'connect_account_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController fullNameController =
  TextEditingController();

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  final TextEditingController confirmPasswordController =
  TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;

  static const Color primaryBlue = Color(0xFF2222C8);

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> createAccount() async {
    FocusScope.of(context).unfocus();

    final name = fullNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showMessage('Please fill in all fields.');
      return;
    }

    if (password.length < 8) {
      showMessage(
        'Password must be at least 8 characters.',
      );
      return;
    }

    if (password != confirmPassword) {
      showMessage('Passwords do not match.');
      return;
    }

    // Save account details on the device.
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('paylens_user_name', name);
    await prefs.setString('paylens_user_email', email);
    await prefs.setString('paylens_user_password', password);

    // Mark the account as logged in.
    await prefs.setBool('paylens_logged_in', true);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ConnectAccountScreen(),
      ),
    );
  }

  void showMessage(String message) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('PayLens'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: primaryBlue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget fieldTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  InputDecoration inputDecoration({
    required String hint,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 16,
        color: Color(0xFF999999),
      ),
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFD5D5D5),
          width: 1.3,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: Color(0xFFD5D5D5),
          width: 1.3,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: primaryBlue,
          width: 1.8,
        ),
      ),
    );
  }

  Widget payLensLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/paylens_logo.png',
          width: 35,
          height: 35,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 7),
        const Text(
          'Pay',
          style: TextStyle(
            color: Colors.black,
            fontSize: 29,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Text(
          'Lens',
          style: TextStyle(
            color: primaryBlue,
            fontSize: 29,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (
              BuildContext context,
              BoxConstraints constraints,
              ) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(
                    maxWidth: 520,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 15,
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),

                      payLensLogo(),

                      const SizedBox(height: 30),

                      const Text(
                        'Create your\nPayLens account',
                        style: TextStyle(
                          fontSize: 30,
                          height: 1.12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'Start auditing your recurring payments.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF777777),
                        ),
                      ),

                      const SizedBox(height: 27),

                      fieldTitle('Full name'),

                      const SizedBox(height: 7),

                      TextField(
                        controller: fullNameController,
                        textCapitalization:
                        TextCapitalization.words,
                        textInputAction:
                        TextInputAction.next,
                        decoration: inputDecoration(
                          hint: 'Priyanka',
                        ),
                      ),

                      const SizedBox(height: 17),

                      fieldTitle('Email Address'),

                      const SizedBox(height: 7),

                      TextField(
                        controller: emailController,
                        keyboardType:
                        TextInputType.emailAddress,
                        textInputAction:
                        TextInputAction.next,
                        decoration: inputDecoration(
                          hint: 'you@example.com',
                        ),
                      ),

                      const SizedBox(height: 17),

                      fieldTitle('Password'),

                      const SizedBox(height: 7),

                      TextField(
                        controller: passwordController,
                        obscureText: hidePassword,
                        textInputAction:
                        TextInputAction.next,
                        decoration: inputDecoration(
                          hint: 'At least 8 characters',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hidePassword =
                                !hidePassword;
                              });
                            },
                            icon: Icon(
                              hidePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 21,
                              color:
                              const Color(0xFF777777),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 17),

                      fieldTitle('Confirm Password'),

                      const SizedBox(height: 7),

                      TextField(
                        controller:
                        confirmPasswordController,
                        obscureText:
                        hideConfirmPassword,
                        textInputAction:
                        TextInputAction.done,
                        onSubmitted: (_) {
                          createAccount();
                        },
                        decoration: inputDecoration(
                          hint: 'Repeat your password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hideConfirmPassword =
                                !hideConfirmPassword;
                              });
                            },
                            icon: Icon(
                              hideConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 21,
                              color:
                              const Color(0xFF777777),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 23),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: createAccount,
                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            primaryBlue,
                            foregroundColor:
                            Colors.white,
                            elevation: 0,
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(7),
                            ),
                          ),
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 23),

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              color:
                              const Color(0xFFD0D0D0),
                            ),
                          ),
                          const Padding(
                            padding:
                            EdgeInsets.symmetric(
                              horizontal: 14,
                            ),
                            child: Text(
                              'or',
                              style: TextStyle(
                                fontSize: 15,
                                color:
                                Color(0xFF777777),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              color:
                              const Color(0xFFD0D0D0),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: () {
                            // Google Sign-In
                          },
                          style:
                          OutlinedButton.styleFrom(
                            backgroundColor:
                            Colors.white,
                            side: const BorderSide(
                              color: Color(0xFFD5D5D5),
                              width: 1.3,
                            ),
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(7),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/google_logo.png',
                                width: 21,
                                height: 21,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 9),
                              const Text(
                                'Continue with Google',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight:
                                  FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 5),

                      Center(
                        child: Wrap(
                          alignment:
                          WrapAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style: TextStyle(
                                fontSize: 15,
                                color:
                                Color(0xFF666666),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator
                                    .pushReplacementNamed(
                                  context,
                                  '/login',
                                );
                              },
                              child: const Text(
                                'Sign in',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: primaryBlue,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}