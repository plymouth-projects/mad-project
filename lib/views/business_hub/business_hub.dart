import 'package:flutter/material.dart';
import 'package:mad_project/config/app_colors.dart';
import 'package:mad_project/config/app_routes.dart';
import 'package:mad_project/widgets/navbar.dart';
import 'package:mad_project/widgets/business_card.dart';
import 'package:mad_project/services/company_service.dart';
import 'package:mad_project/constants/business_filter.dart';

class BusinessHub extends StatefulWidget {
  const BusinessHub({super.key});

  @override
  State<BusinessHub> createState() => _BusinessHubState();
}

class _BusinessHubState extends State<BusinessHub> {
  // Selected filter values
  String? _selectedIndustry;
  String? _selectedSize;
  String? _selectedLocation;
  
  // Company service instance
  final CompanyService _companyService = CompanyService();
  
  // Filter options from constants
  final List<String> _industryOptions = BusinessFilters.industryOptions;
  final List<String> _sizeOptions = BusinessFilters.sizeOptions;
  final List<String> _locationOptions = BusinessFilters.locationOptions;
  
  // Companies data
  List<Map<String, dynamic>> _allCompanies = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _fetchCompanies();
  }
  
  Future<void> _fetchCompanies() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final companies = await _companyService.getCompanies();
      setState(() {
        _allCompanies = companies;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching companies: $e');
    }
  }
  
  // Get filtered companies
  List<Map<String, dynamic>> get filteredCompanies {
    return BusinessFilters.applyFilters(
      _allCompanies,
      industry: _selectedIndustry,
      size: _selectedSize,
      location: _selectedLocation,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithDrawer(currentRoute: AppRoutes.businessHub),
      drawer: AppNavDrawer(currentRoute: AppRoutes.businessHub),
      body: Container(
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildResultCount(),
          const SizedBox(height: 16),
          _buildCompanyList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'BUSINESS HUB',
            style: TextStyle(
              color: Colors.white, 
              fontSize: 22, 
              fontWeight: FontWeight.bold
            ),
          ),
          _buildFilterButton(),
        ],
      ),
    );
  }

  Widget _buildResultCount() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0),
      child: Text(
        '${filteredCompanies.length} Results',
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildCompanyList() {
    if (filteredCompanies.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
            'No companies match your filters',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }
    
    return Expanded(
      child: ListView.builder(
        itemCount: filteredCompanies.length,
        itemBuilder: (context, index) {
          final company = filteredCompanies[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: CompanyCard(
              company: company,
              scale: 1.0,
              onViewDetails: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.businessDetails,
                  arguments: company,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterButton() {
    return ElevatedButton.icon(
      onPressed: _showFilterOptions,
      icon: const Icon(Icons.filter_list, color: Colors.white),
      label: const Text('Filter'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1A5C83),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0E3A5D),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter Companies',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildModalFilterCategory(
                'Industry', 
                _selectedIndustry,
                _getIndustryOptions(),
                (value) {
                  setState(() => _selectedIndustry = value);
                  setModalState(() {});
                },
                setModalState,
              ),
              const SizedBox(height: 12),
              _buildModalFilterCategory(
                'Company Size',
                _selectedSize,
                _getSizeOptions(),
                (value) {
                  setState(() => _selectedSize = value);
                  setModalState(() {});
                },
                setModalState,
              ),
              const SizedBox(height: 12),
              _buildModalFilterCategory(
                'Location Type',
                _selectedLocation,
                _getLocationOptions(),
                (value) {
                  setState(() => _selectedLocation = value);
                  setModalState(() {});
                },
                setModalState,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, bottom: 25.0, top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndustry = null;
                          _selectedSize = null;
                          _selectedLocation = null;
                        });
                        setModalState(() {});
                      },
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
                        // Trigger UI refresh based on filters
                        setState(() {});
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModalFilterCategory(
    String title, 
    String? selectedValue,
    List<DropdownMenuItem<String>> items,
    ValueChanged<String?> onChanged,
    StateSetter setModalState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
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
              value: selectedValue,
              dropdownColor: const Color(0xFF1A5C83),
              hint: Text(
                'Select $title',
                style: const TextStyle(color: Colors.white),
              ),
              items: items,
              onChanged: onChanged,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _getIndustryOptions() {
    return _industryOptions.map((industry) => DropdownMenuItem(
      value: industry,
      child: Text(industry, style: const TextStyle(color: Colors.white)),
    )).toList();
  }
  
  List<DropdownMenuItem<String>> _getSizeOptions() {
    return _sizeOptions.map((size) => DropdownMenuItem(
      value: size,
      child: Text(size, style: const TextStyle(color: Colors.white)),
    )).toList();
  }

  List<DropdownMenuItem<String>> _getLocationOptions() {
    return _locationOptions.map((location) => DropdownMenuItem(
      value: location,
      child: Text(location, style: const TextStyle(color: Colors.white)),
    )).toList();
  }
}
