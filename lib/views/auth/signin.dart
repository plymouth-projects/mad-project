import 'package:flutter/material.dart';
import 'package:mad_project/config/app_colors.dart';
import '../../config/app_routes.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign In")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Example Sign In Form (You can modify this)
            TextField(
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            
            // Sign In Button
            ElevatedButton(
              onPressed: () {
                // Handle sign-in logic here
              },
              child: const Text("Sign In"),
            ),
            
            const SizedBox(height: 20),

            // "Don't Have an Account? SignUp Here" Text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.signup);
                  },
                  child: const Text(
                    "Sign Up Here",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentBlue,
                      ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
