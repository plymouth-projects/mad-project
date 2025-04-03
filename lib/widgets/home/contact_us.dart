import 'package:flutter/material.dart';
import 'package:mad_project/config/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  String? _selectedArea;
  bool _isSubmitting = false;

  // Controllers for the text fields
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  // Focus nodes to track focus state
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _messageFocus = FocusNode();
  
  // Error messages for each field
  String? _firstNameError;
  String? _lastNameError;
  String? _emailError;
  String? _phoneError;
  String? _messageError;

  @override
  void initState() {
    super.initState();
    // Add focus listeners to validate on focus change
    _firstNameFocus.addListener(_onFirstNameFocusChange);
    _lastNameFocus.addListener(_onLastNameFocusChange);
    _emailFocus.addListener(_onEmailFocusChange);
    _phoneFocus.addListener(_onPhoneFocusChange);
    _messageFocus.addListener(_onMessageFocusChange);
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    
    // Dispose focus nodes
    _firstNameFocus.removeListener(_onFirstNameFocusChange);
    _lastNameFocus.removeListener(_onLastNameFocusChange);
    _emailFocus.removeListener(_onEmailFocusChange);
    _phoneFocus.removeListener(_onPhoneFocusChange);
    _messageFocus.removeListener(_onMessageFocusChange);
    
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _messageFocus.dispose();
    super.dispose();
  }

  // Focus change handlers
  void _onFirstNameFocusChange() {
    if (!_firstNameFocus.hasFocus) {
      _validateFirstName();
    }
  }

  void _onLastNameFocusChange() {
    if (!_lastNameFocus.hasFocus) {
      _validateLastName();
    }
  }

  void _onEmailFocusChange() {
    if (!_emailFocus.hasFocus) {
      _validateEmail();
    }
  }

  void _onPhoneFocusChange() {
    if (!_phoneFocus.hasFocus) {
      _validatePhone();
    }
  }

  void _onMessageFocusChange() {
    if (!_messageFocus.hasFocus) {
      _validateMessage();
    }
  }

  // Individual field validation methods
  void _validateFirstName() {
    setState(() {
      if (_firstNameController.text.isEmpty) {
        _firstNameError = 'First name is required';
      } else {
        _firstNameError = null;
      }
    });
  }

  void _validateLastName() {
    setState(() {
      if (_lastNameController.text.isEmpty) {
        _lastNameError = 'Last name is required';
      } else {
        _lastNameError = null;
      }
    });
  }

  void _validateEmail() {
    setState(() {
      if (_emailController.text.isEmpty) {
        _emailError = 'Email is required';
      } else if (!_isValidEmail(_emailController.text)) {
        _emailError = 'Please enter a valid email address';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePhone() {
    setState(() {
      if (_phoneController.text.isEmpty || _phoneController.text.length < 10) {
        _phoneError = 'Please enter a valid phone number';
      } else {
        _phoneError = null;
      }
    });
  }

  void _validateMessage() {
    setState(() {
      if (_messageController.text.isEmpty) {
        _messageError = 'Message is required';
      } else {
        _messageError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 23.0, right: 23.0, top: 60.0, bottom: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "CONTACT US",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField("First Name"),
                _buildTextField("Last Name"),
                _buildTextField("Email"),
                _buildTextField("Phone Number"),
                const SizedBox(height: 15),
                const Text("Select Area?", style: TextStyle(color: AppColors.navyBlue, fontWeight: FontWeight.bold)),
                _buildRadioOption("Home Maintenance"),
                _buildRadioOption("Personal Care"),
                _buildRadioOption("Constructions And Repairs"),
                _buildRadioOption("Transport And Security"),
                _buildTextField("Message"),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tealDark,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    onPressed: _isSubmitting ? null : _submitForm,
                    child: _isSubmitting 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Send Message", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Validate all fields and return true if all are valid
  bool _validateAllFields() {
    _validateFirstName();
    _validateLastName();
    _validateEmail();
    _validatePhone();
    _validateMessage();
    
    // Check if any errors exist
    return _firstNameError == null &&
           _lastNameError == null &&
           _emailError == null &&
           _phoneError == null &&
           _messageError == null &&
           _selectedArea != null;
  }
  
  // Submit form data to Firestore
  void _submitForm() async {
    // Validate all fields
    if (!_validateAllFields()) {
      // Show error message if any field is invalid
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields correctly'),
          backgroundColor: Colors.red,
        ),
      );
      
      // If area is not selected, show specific error
      if (_selectedArea == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an area'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }
    
    // Set submitting state to show loading indicator
    setState(() {
      _isSubmitting = true;
    });
    
    try {
      // Get a reference to the Firestore collection
      final contactCollection = FirebaseFirestore.instance.collection('contacts');
      
      // Create a data map to send to Firestore
      final contactData = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'area': _selectedArea,
        'message': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      };
      
      // Add the document to Firestore
      await contactCollection.add(contactData);
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Message sent successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Clear all fields after successful submission
        _firstNameController.clear();
        _lastNameController.clear();
        _emailController.clear();
        _phoneController.clear();
        _messageController.clear();
        setState(() {
          _selectedArea = null;
        });
      }
    } catch (e) {
      // Show error message if submission fails
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Reset submitting state
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
  
  // Validate email format
  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  Widget _buildTextField(String label) {
    // Assign the appropriate controller and focus node based on the field
    TextEditingController controller;
    FocusNode focusNode;
    String? errorText;
    
    switch (label) {
      case 'First Name':
        controller = _firstNameController;
        focusNode = _firstNameFocus;
        errorText = _firstNameError;
      case 'Last Name':
        controller = _lastNameController;
        focusNode = _lastNameFocus;
        errorText = _lastNameError;
      case 'Email':
        controller = _emailController;
        focusNode = _emailFocus;
        errorText = _emailError;
      case 'Phone Number':
        controller = _phoneController;
        focusNode = _phoneFocus;
        errorText = _phoneError;
      case 'Message':
        controller = _messageController;
        focusNode = _messageFocus;
        errorText = _messageError;
      default:
        controller = TextEditingController();
        focusNode = FocusNode();
    }
    
    // For the Message field, create a multi-line text area with word limit
    if (label == "Message") {
      return Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(color: AppColors.navyBlue),
              maxLines: 4,
              maxLength: 200,
              buildCounter: (BuildContext context, {required int currentLength, required bool isFocused, required int? maxLength}) {
                return Text(
                  '$currentLength/$maxLength',
                  style: const TextStyle(color: AppColors.navyBlue, fontSize: 12),
                );
              },
              decoration: InputDecoration(
                labelStyle: const TextStyle(color: AppColors.navyBlue, fontSize: 14),
                labelText: label,
                alignLabelWithHint: true,
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primaryBlue),
                ),
                errorText: errorText,
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    // Regular single-line text fields for other inputs
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        style: const TextStyle(color: AppColors.navyBlue),
        decoration: InputDecoration(
          labelStyle: const TextStyle(color: AppColors.navyBlue, fontSize: 14),
          labelText: label,
          border: const UnderlineInputBorder(),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryBlue),
          ),
          errorText: errorText,
          errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String title) {
    bool isSelected = _selectedArea == title;
    
    return InkWell(
      onTap: () {
        setState(() {
          // If this option is already selected, unselect it
          // Otherwise, select it
          _selectedArea = isSelected ? null : title;
        });
      },
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.tealDark : AppColors.navyBlue,
              size: 20,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: AppColors.navyBlue,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
