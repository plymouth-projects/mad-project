import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mad_project/config/app_colors.dart';
import 'package:mad_project/widgets/navbar.dart';
import '../../config/app_routes.dart';
import '../../widgets/text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithDrawer(currentRoute: AppRoutes.signin),
      drawer: const AppNavDrawer(currentRoute: AppRoutes.signin),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 20), // Removed top padding completely
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              width: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left side column with logo and text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "assets/images/findworkd.svg",
                            height: 20,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: 200,
                            child: const Text(
                              "Welcome Back",
                              style: TextStyle(
                                color: AppColors.primaryBlue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Right side image
                      Image.asset(
                        "assets/images/auth_vector.png",
                        height: 100,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  
                  // Form Fields
                  CustomTextField(
                    label: "Email",
                    hintText: "Enter your email address",
                  ),
                  _buildPasswordField(),
                  
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Handle forgot password
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: AppColors.accentBlue,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Login Button
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle login logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Divider with text
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 10.0),
                          child: Divider(
                            color: Colors.grey.withOpacity(0.5),
                            height: 1,
                          ),
                        ),
                      ),
                      Text(
                        "or Login using",
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.8),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10.0),
                          child: Divider(
                            color: Colors.grey.withOpacity(0.5),
                            height: 1,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Social Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton("assets/images/microsoft_logo.png", "Microsoft"),
                      const SizedBox(width: 20),
                      _buildSocialButton("assets/images/google_logo.png", "Google"),
                    ],
                  ),

                  const SizedBox(height: 10),
                  
                  // Don't have an account
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(color: AppColors.primaryBlue),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.signup);
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              "Sign Up Here",
                              style: TextStyle(
                                color: AppColors.accentBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Password Field Widget
  Widget _buildPasswordField() {
    return CustomTextField(
      label: "Password",
      hintText: "Enter your password",
      obscureText: !_isPasswordVisible,
      suffixIcon: IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          size: 20,
          color: Colors.grey[600],
        ),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          });
        },
      ),
    );
  }

  // Social Button Widget
  Widget _buildSocialButton(String assetPath, String label) {
    return InkWell(
      onTap: () {
        // Handle social login
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Image.asset(assetPath, width: 24, height: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
