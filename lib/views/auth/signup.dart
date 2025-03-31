import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mad_project/config/app_colors.dart';
import 'package:mad_project/config/app_routes.dart';
import 'package:mad_project/widgets/navbar.dart';
import 'package:mad_project/widgets/text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithDrawer(currentRoute: AppRoutes.signup),
      drawer: const AppNavDrawer(currentRoute: AppRoutes.signup),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [ // Added subtle shadow for better visibility
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
                          SizedBox(
                            width: 200,
                            child: const Text(
                              "Start Your Career with Us",
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
                  const SizedBox(height: 20),
                  
                  // Form Fields
                  CustomTextField(label: "First Name"),
                  CustomTextField(label: "Last Name"),
                  CustomTextField(label: "Gender"),
                  CustomTextField(label: "Date of Birth"),
                  CustomTextField(label: "Email"),
                  _buildPasswordField("Password", isConfirm: false),
                  _buildPasswordField("Confirm Password", isConfirm: true),

                  const SizedBox(height: 20),

                  // Register Button
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle registration logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Register",
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
                        "or Register using",
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

                  // Already have an account
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(color: AppColors.primaryBlue),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.signin);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            "Login Here",
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
  Widget _buildPasswordField(String label, {required bool isConfirm}) {
    return CustomTextField(
      label: label,
      hintText: isConfirm ? "Confirm your password" : "Enter a strong password",
      obscureText: isConfirm ? !_isConfirmPasswordVisible : !_isPasswordVisible,
      suffixIcon: IconButton(
        icon: Icon(
          isConfirm
              ? (_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off)
              : (_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          size: 20,
          color: Colors.grey[600],
        ),
        onPressed: () {
          setState(() {
            if (isConfirm) {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            } else {
              _isPasswordVisible = !_isPasswordVisible;
            }
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
