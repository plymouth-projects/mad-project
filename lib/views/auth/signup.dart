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
  final AuthService _authService = AuthService();
  
  // Text controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  
  // Focus nodes for form fields
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  
  // Field-specific error messages
  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _dateError;
  String? _genderError;
  
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
    _setupFocusListeners();
  }

  void _setupFocusListeners() {
    _firstNameFocus.addListener(() {
      if (!_firstNameFocus.hasFocus) {
        _validateFirstName();
      }
    });
    
    _lastNameFocus.addListener(() {
      if (!_lastNameFocus.hasFocus) {
        _validateLastName();
      }
    });
    
    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus) {
        _validateEmail();
      }
    });
    
    _passwordFocus.addListener(() {
      if (!_passwordFocus.hasFocus) {
        _validatePassword();
      }
    });
    
    _confirmPasswordFocus.addListener(() {
      if (!_confirmPasswordFocus.hasFocus) {
        _validateConfirmPassword();
      }
    });
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
    
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    
    super.dispose();
  }

  // Validation methods
  bool _validateFirstName() {
    if (_firstNameController.text.trim().isEmpty) {
      setState(() {
        _firstNameError = 'Please enter your first name';
      });
      return false;
    }
    setState(() {
      _firstNameError = null;
    });
    return true;
  }

  bool _validateLastName() {
    if (_lastNameController.text.trim().isEmpty) {
      setState(() {
        _lastNameError = 'Please enter your last name';
      });
      return false;
    }
    setState(() {
      _lastNameError = null;
    });
    return true;
  }

  bool _validateEmail() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _emailError = 'Please enter your email';
      });
      return false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() {
        _emailError = 'Please enter a valid email';
      });
      return false;
    }
    setState(() {
      _emailError = null;
    });
    return true;
  }

  bool _validatePassword() {
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Please enter a password';
      });
      return false;
    } else if (_passwordController.text.length < 6) {
      setState(() {
        _passwordError = 'Password must be at least 6 characters';
      });
      return false;
    }
    setState(() {
      _passwordError = null;
    });
    return true;
  }

  bool _validateConfirmPassword() {
    if (_confirmPasswordController.text.isEmpty) {
      setState(() {
        _confirmPasswordError = 'Please confirm your password';
      });
      return false;
    } else if (_confirmPasswordController.text != _passwordController.text) {
      setState(() {
        _confirmPasswordError = 'Passwords do not match';
      });
      return false;
    }
    setState(() {
      _confirmPasswordError = null;
    });
    return true;
  }

  bool _validateDate() {
    if (_selectedDate == null) {
      setState(() {
        _dateError = 'Please select your date of birth';
      });
      return false;
    }
    setState(() {
      _dateError = null;
    });
    return true;
  }

  bool _validateGender() {
    if (_selectedGender == null) {
      setState(() {
        _genderError = 'Please select your gender';
      });
      return false;
    }
    setState(() {
      _genderError = null;
    });
    return true;
  }

  // Validate all form fields
  bool _validateForm() {
    final isFirstNameValid = _validateFirstName();
    final isLastNameValid = _validateLastName();
    final isEmailValid = _validateEmail();
    final isPasswordValid = _validatePassword();
    final isConfirmPasswordValid = _validateConfirmPassword();
    final isDateValid = _validateDate();
    final isGenderValid = _validateGender();
    
    return isFirstNameValid && 
           isLastNameValid && 
           isEmailValid && 
           isPasswordValid && 
           isConfirmPasswordValid && 
           isDateValid && 
           isGenderValid;
  }

  // Validate and submit form
  Future<void> _submitForm() async {
    if (!_validateForm()) {
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

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final success = await _authService.signInWithGoogle();
      
      if (success) {
        final user = _authService.currentUser;
        
        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Signed in successfully as ${user.email}')),
          );
          
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      Image.asset(
                        "assets/images/auth_vector.png",
                        height: 100,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  CustomTextField(
                    label: "First Name",
                    controller: _firstNameController,
                    focusNode: _firstNameFocus,
                    errorText: _firstNameError,
                    onChanged: (val) {
                      if (_firstNameError != null) {
                        setState(() {
                          _firstNameError = null;
                        });
                      }
                    },
                  ),
                  
                  CustomTextField(
                    label: "Last Name",
                    controller: _lastNameController,
                    focusNode: _lastNameFocus,
                    errorText: _lastNameError,
                    onChanged: (val) {
                      if (_lastNameError != null) {
                        setState(() {
                          _lastNameError = null;
                        });
                      }
                    },
                  ),
                  
                  // Gender dropdown with error display
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDropdown(
                        label: "Gender",
                        hintText: "Select your gender",
                        value: _selectedGender,
                        items: _genderOptions,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGender = newValue;
                            _genderError = null;
                          });
                        },
                      ),
                      if (_genderError != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 12, top: 4, bottom: 8),
                          child: Text(
                            _genderError!,
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  // Date picker with error display
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDatePicker(
                        label: "Date of Birth",
                        hintText: "Select your date of birth",
                        selectedDate: _selectedDate,
                        controller: _dateController,
                        onTap: (_) {
                          _selectDate(context);
                          if (_dateError != null) {
                            setState(() {
                              _dateError = null;
                            });
                          }
                        },
                      ),
                      if (_dateError != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 12, top: 4, bottom: 8),
                          child: Text(
                            _dateError!,
                            style: TextStyle(
                              color: Colors.red[700],
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  CustomTextField(
                    label: "Email",
                    controller: _emailController,
                    focusNode: _emailFocus,
                    errorText: _emailError,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (val) {
                      if (_emailError != null) {
                        setState(() {
                          _emailError = null;
                        });
                      }
                    },
                  ),
                  
                  _buildPasswordField(),
                  
                  _buildConfirmPasswordField(),

                  const SizedBox(height: 20),

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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton("assets/images/microsoft_logo.png", "Microsoft"),
                      const SizedBox(width: 20),
                      _buildSocialButton("assets/images/google_logo.png", "Google"),
                    ],
                  ),

                  const SizedBox(height: 10),

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

  Widget _buildPasswordField() {
    return CustomTextField(
      label: "Password",
      hintText: "Enter a strong password",
      controller: _passwordController,
      focusNode: _passwordFocus,
      obscureText: !_isPasswordVisible,
      errorText: _passwordError,
      onChanged: (val) {
        if (_passwordError != null) {
          setState(() {
            _passwordError = null;
          });
        }
      },
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

  Widget _buildConfirmPasswordField() {
    return CustomTextField(
      label: "Confirm Password",
      hintText: "Confirm your password",
      controller: _confirmPasswordController,
      focusNode: _confirmPasswordFocus,
      obscureText: !_isConfirmPasswordVisible,
      errorText: _confirmPasswordError,
      onChanged: (val) {
        if (_confirmPasswordError != null) {
          setState(() {
            _confirmPasswordError = null;
          });
        }
      },
      suffixIcon: IconButton(
        icon: Icon(
          _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
          size: 20,
          color: Colors.grey[600],
        ),
        onPressed: () {
          setState(() {
            _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
          });
        },
      ),
    );
  }

  Widget _buildSocialButton(String assetPath, String label) {
    return InkWell(
      onTap: _isLoading 
        ? null 
        : () {
            if (label == "Google") {
              _handleGoogleSignIn();
            } else if (label == "Microsoft") {
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
