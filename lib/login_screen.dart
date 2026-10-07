import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const Color primaryBlue = Color(0xFF2222C8);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool rememberMe = false;
  bool hidePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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

  Future<void> signIn() async {
    FocusScope.of(context).unfocus();

    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showMessage(
        'Please enter your email and password.',
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    final savedEmail =
    prefs.getString('paylens_user_email');

    final savedPassword =
    prefs.getString('paylens_user_password');

    final savedName =
    prefs.getString('paylens_user_name');

    // No account has been created yet.
    if (savedEmail == null ||
        savedPassword == null ||
        savedName == null) {
      showMessage(
        'No PayLens account found. Please create an account first.',
      );
      return;
    }

    // Check email and password.
    if (savedEmail.trim().toLowerCase() !=
        email.toLowerCase() ||
        savedPassword != password) {
      showMessage(
        'Incorrect email or password.',
      );
      return;
    }

    // Mark the user as logged in.
    await prefs.setBool(
      'paylens_logged_in',
      true,
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardScreen(
          userName: savedName,
          userEmail: savedEmail,
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),

                Center(
                  child: payLensLogo(),
                ),

                const SizedBox(height: 40),

                const Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Sign in to continue to your PayLens account.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF777777),
                  ),
                ),

                const SizedBox(height: 35),

                const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: emailController,
                  keyboardType:
                  TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: const TextStyle(
                      color: Color(0xFF999999),
                    ),
                    prefixIcon: const Icon(
                      Icons.email_outlined,
                      color: Color(0xFF777777),
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(7),
                      borderSide: const BorderSide(
                        color: Color(0xFFD6D6D6),
                      ),
                    ),
                    enabledBorder:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(7),
                      borderSide: const BorderSide(
                        color: Color(0xFFD6D6D6),
                      ),
                    ),
                    focusedBorder:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(7),
                      borderSide: const BorderSide(
                        color: primaryBlue,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: passwordController,
                  obscureText: hidePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: const TextStyle(
                      color: Color(0xFF999999),
                    ),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Color(0xFF777777),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword =
                          !hidePassword;
                        });
                      },
                      icon: Icon(
                        hidePassword
                            ? Icons
                            .visibility_off_outlined
                            : Icons
                            .visibility_outlined,
                        color:
                        const Color(0xFF777777),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(7),
                      borderSide: const BorderSide(
                        color: Color(0xFFD6D6D6),
                      ),
                    ),
                    enabledBorder:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(7),
                      borderSide: const BorderSide(
                        color: Color(0xFFD6D6D6),
                      ),
                    ),
                    focusedBorder:
                    OutlineInputBorder(
                      borderRadius:
                      BorderRadius.circular(7),
                      borderSide: const BorderSide(
                        color: primaryBlue,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      activeColor: primaryBlue,
                      onChanged: (value) {
                        setState(() {
                          rememberMe =
                              value ?? false;
                        });
                      },
                    ),
                    const Text(
                      'Remember me',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: primaryBlue,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: signIn,
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
                      'Sign In',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: Color(0xFFD6D6D6),
                        thickness: 1,
                      ),
                    ),
                    const Padding(
                      padding:
                      EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color:
                          Color(0xFF777777),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Color(0xFFD6D6D6),
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 47,
                  child: OutlinedButton(
                    onPressed: () {},
                    style:
                    OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFFD6D6D6),
                        width: 2,
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(6),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/google_logo.png',
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Continue with Google',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight:
                            FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Center(
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 15,
                          color:
                          Color(0xFF777777),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/signup',
                          );
                        },
                        child: const Text(
                          'Create account',
                          style: TextStyle(
                            color: primaryBlue,
                            fontSize: 15,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Center(
                  child: Row(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 16,
                        color: Color(0xFF888888),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Your information is securely encrypted.',
                        textAlign:
                        TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color:
                          Color(0xFF888888),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}