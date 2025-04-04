import 'package:flutter/material.dart';
import 'package:mad_project/config/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? padding;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final String? errorText;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.padding = const EdgeInsets.only(bottom: 15),
    this.keyboardType,
    this.focusNode,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            validator: validator,
            obscureText: obscureText,
            keyboardType: keyboardType,
            focusNode: focusNode,
            onChanged: onChanged,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.navyBlue,
            ),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
              floatingLabelStyle: TextStyle(
                color: AppColors.primaryBlue,
              ),
              hintText: hintText ?? "Enter your $label",
              hintStyle: TextStyle(
                fontSize: 13,
                color: Colors.grey[400],
              ),
              border: OutlineInputBorder(),
              filled: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryBlue, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primaryBlue[100]!.withOpacity(0.7)),
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: suffixIcon,
              errorText: errorText,
              errorStyle: TextStyle(
                color: Colors.red[700],
                fontSize: 12,
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red[500]!, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String label;
  final String? hintText;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;
  final EdgeInsetsGeometry? padding;

  const CustomDropdown({
    super.key,
    required this.label,
    this.hintText,
    this.value,
    required this.items,
    required this.onChanged,
    this.padding = const EdgeInsets.only(bottom: 15),
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController(text: value ?? '');

    return Padding(
      padding: padding!,
      child: Stack(
        children: [
          CustomTextField(
            label: label,
            hintText: hintText ?? "Select an option",
            controller: textController,
            suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            padding: EdgeInsets.zero,
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () async {
                  final result = await _showDropdownDialog(context, items, value);
                  if (result != null) {
                    textController.text = result;
                    onChanged(result);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _showDropdownDialog(
    BuildContext context,
    List<String> items,
    String? currentValue,
  ) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(
            'Select $label',
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Container(
            width: double.maxFinite,
            constraints: const BoxConstraints(maxHeight: 300),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Instruction text
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
                  child: Text(
                    "Please select an option:",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                // List of options
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = items[index];
                      final isSelected = item == currentValue;
                      
                      return ListTile(
                        title: Text(
                          item,
                          style: TextStyle(
                            color: isSelected ? AppColors.primaryBlue : Colors.black87,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        leading: isSelected 
                          ? const Icon(Icons.check_circle, color: AppColors.primaryBlue, size: 20)
                          : Icon(Icons.circle_outlined, color: Colors.grey[400], size: 20),
                        selected: isSelected,
                        onTap: () {
                          Navigator.of(context).pop(item);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}

class CustomDatePicker extends StatelessWidget {
  final String label;
  final String? hintText;
  final DateTime? selectedDate;
  final Function(BuildContext) onTap;
  final EdgeInsetsGeometry? padding;
  final TextEditingController? controller;

  const CustomDatePicker({
    super.key,
    required this.label,
    this.hintText,
    this.selectedDate,
    required this.onTap,
    this.padding = const EdgeInsets.only(bottom: 15),
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: TextField(
        controller: controller,
        readOnly: true,
        onTap: () => onTap(context),
        style: TextStyle(
          fontSize: 14,
          color: AppColors.navyBlue,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
          floatingLabelStyle: TextStyle(
            color: AppColors.primaryBlue,
          ),
          hintText: hintText ?? "Select your $label",
          hintStyle: TextStyle(
            fontSize: 13,
            color: Colors.grey[400],
          ),
          border: OutlineInputBorder(),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryBlue, width: 1.5),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryBlue[100]!.withOpacity(0.7)),
            borderRadius: BorderRadius.circular(8),
          ),
          suffixIcon: const Icon(Icons.calendar_today, size: 20, color: Colors.grey),
        ),
      ),
    );
  }
}

// Helper function for date picker
Future<DateTime?> showCustomDatePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  return showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    builder: (context, child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primaryBlue,
          ),
        ),
        child: child!,
      );
    },
  );
}
