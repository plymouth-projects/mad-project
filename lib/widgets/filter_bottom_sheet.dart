import 'package:flutter/material.dart';
import 'package:mad_project/config/app_colors.dart';

class FilterOption {
  final String title;
  final String? selectedValue;
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final bool hasSearch;
  
  FilterOption({
    required this.title,
    this.selectedValue,
    required this.options,
    required this.onChanged,
    this.hasSearch = false,
  });
}

class FilterBottomSheet extends StatefulWidget {
  final String title;
  final List<FilterOption> filterOptions;
  final VoidCallback onApply;
  final VoidCallback onReset;
  
  const FilterBottomSheet({
    Key? key,
    required this.title,
    required this.filterOptions,
    required this.onApply,
    required this.onReset,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // State to track filtered options when search is enabled
  Map<String, List<String>> _filteredOptions = {};
  Map<String, TextEditingController> _searchControllers = {};
  
  @override
  void initState() {
    super.initState();
    // Initialize filtered options and search controllers
    for (var option in widget.filterOptions) {
      _filteredOptions[option.title] = option.options;
      
      if (option.hasSearch) {
        _searchControllers[option.title] = TextEditingController();
        _searchControllers[option.title]!.addListener(() {
          _filterOptions(option.title, _searchControllers[option.title]!.text);
        });
      }
    }
  }
  
  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _searchControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
  
  void _filterOptions(String title, String query) {
    final option = widget.filterOptions.firstWhere((o) => o.title == title);
    
    if (query.isEmpty) {
      setState(() {
        _filteredOptions[title] = option.options;
      });
      return;
    }
    
    setState(() {
      _filteredOptions[title] = option.options
          .where((o) => o.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...widget.filterOptions.map((option) => Column(
            children: [
              _buildFilterCategory(option),
              const SizedBox(height: 12),
            ],
          )).toList(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildFilterCategory(FilterOption option) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          option.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (option.hasSearch) _buildSearchField(option.title),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A5C83),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: option.selectedValue,
              dropdownColor: const Color(0xFF1A5C83),
              hint: Text(
                'Select ${option.title}',
                style: const TextStyle(color: Colors.white),
              ),
              items: (_filteredOptions[option.title] ?? option.options).map((value) => DropdownMenuItem(
                value: value,
                child: Text(value, style: const TextStyle(color: Colors.white)),
              )).toList(),
              onChanged: option.onChanged,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSearchField(String title) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A5C83),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _searchControllers[title],
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search ${title.toLowerCase()}',
          hintStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.search, color: Colors.white70),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(right: 16, bottom: 25.0, top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: widget.onReset,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              backgroundColor: AppColors.tealDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Reset',
              style: TextStyle(color: Colors.white),
            ),
          ),                  
          const SizedBox(width: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              backgroundColor: AppColors.tealDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onApply();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF0E3A5D),
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}

void showFilterBottomSheet({
  required BuildContext context,
  required String title,
  required List<FilterOption> filterOptions,
  required VoidCallback onApply,
  required VoidCallback onReset,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF0E3A5D),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    isScrollControlled: true, // Makes the modal expandable
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: StatefulBuilder(
        builder: (context, setState) => FilterBottomSheet(
          title: title,
          filterOptions: filterOptions,
          onApply: onApply,
          onReset: onReset,
        ),
      ),
    ),
  );
}
