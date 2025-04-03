import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mad_project/config/app_colors.dart';
import 'package:mad_project/config/app_routes.dart';
import 'package:mad_project/services/auth_service.dart';
import 'package:mad_project/widgets/navbar.dart';
import 'package:mad_project/widgets/text_field.dart';
import 'package:intl/intl.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  
  // Text controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _selectedGender;
  DateTime? _selectedDate;
  bool _isLoading = false;
  
  final List<String> _genderOptions = ['Male', 'Female', 'Other', 'Prefer not to say'];

  @override
  void initState() {
    super.initState();
    _updateDateController();
  }

  void _updateDateController() {
    if (_selectedDate != null) {
      _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
    } else {
      _dateController.text = '';
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // Validate and submit form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Check if passwords match
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }
      
      // Check if date of birth is selected
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your date of birth')),
        );
        return;
      }
      
      // Check if gender is selected
      if (_selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your gender')),
        );
        return;
      }
      
      setState(() {
        _isLoading = true;
      });
      
      try {
        final success = await _authService.registerUser(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          gender: _selectedGender!,
          dateOfBirth: _selectedDate!,
          email: _emailController.text,
          password: _passwordController.text,
        );
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
          
          // Navigate to sign in page after successful registration
          Navigator.pushNamed(context, AppRoutes.signin);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration failed. Email may already be in use.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Method to handle Google Sign In
  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final success = await _authService.signInWithGoogle();
      
      if (success) {
        // Get current user details for verification
        final user = _authService.currentUser;
        
        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Signed in successfully as ${user.email}')),
          );
          
          // Navigate to home page or dashboard
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign-in succeeded but user data could not be retrieved.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google sign-in was cancelled or failed. Please try again.')),
        );
      }
    } catch (e) {
      // Show detailed error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error with Google sign-in: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  // Method to handle Microsoft Sign In
  /* Future<void> _handleMicrosoftSignIn() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      /* final success = await _authService.signInWithMicrosoft(); */
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microsoft sign-in successful!')),
        );
        
        // Navigate to home page or dashboard
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microsoft sign-in was cancelled or failed.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error with Microsoft sign-in: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  } */

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
              child: Form(
                key: _formKey,
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
                    CustomTextField(
                      label: "First Name",
                      controller: _firstNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      label: "Last Name",
                      controller: _lastNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        return null;
                      },
                    ),
                    CustomDropdown(
                      label: "Gender",
                      hintText: "Select your gender",
                      value: _selectedGender,
                      items: _genderOptions,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedGender = newValue;
                        });
                      },
                    ),
                    CustomDatePicker(
                      label: "Date of Birth",
                      hintText: "Select your date of birth",
                      selectedDate: _selectedDate,
                      controller: _dateController,
                      onTap: (_) => _selectDate(context),
                    ),
                    CustomTextField(
                      label: "Email",
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    _buildPasswordField("Password", isConfirm: false),
                    _buildPasswordField("Confirm Password", isConfirm: true),

                    const SizedBox(height: 20),

                    // Register Button
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading 
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
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
      ),
    );
  }

  // Date Picker Function
  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = _selectedDate ?? DateTime(now.year - 18, now.month, now.day);
    final DateTime firstDate = DateTime(1900);
    final DateTime lastDate = DateTime(now.year - 13, now.month, now.day);

    final DateTime? picked = await showCustomDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _updateDateController();
      });
    }
  }

  // Password Field Widget
  Widget _buildPasswordField(String label, {required bool isConfirm}) {
    return CustomTextField(
      label: label,
      hintText: isConfirm ? "Confirm your password" : "Enter a strong password",
      controller: isConfirm ? _confirmPasswordController : _passwordController,
      obscureText: isConfirm ? !_isConfirmPasswordVisible : !_isPasswordVisible,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        if (!isConfirm && value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
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
      onTap: _isLoading 
        ? null 
        : () {
            if (label == "Google") {
              _handleGoogleSignIn();
            } else if (label == "Microsoft") {
              // Microsoft sign-in is commented out for now
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Microsoft sign-in is not configured yet')),
              );
            }
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
