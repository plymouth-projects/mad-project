import 'package:flutter/material.dart';
import 'package:mad_project/config/app_routes.dart';
import 'package:mad_project/constants/business_filter.dart';
import 'package:mad_project/services/company_service.dart';
import 'package:mad_project/widgets/business_card.dart';
import 'package:mad_project/widgets/base_hub_screen.dart';
import 'package:mad_project/widgets/filter_bottom_sheet.dart';

class BusinessHub extends BaseHubScreen<Map<String, dynamic>> {
  const BusinessHub({super.key});

  @override
  State<BusinessHub> createState() => _BusinessHubState();
}

class _BusinessHubState extends BaseHubScreenState<BusinessHub, Map<String, dynamic>> {
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
  
  // Store all companies to avoid multiple API calls
  List<Map<String, dynamic>> _allCompanies = [];
  
  @override
  String get hubTitle => 'BUSINESS HUB';
  
  @override
  String get currentRoute => AppRoutes.businessHub;
  
  @override
  String get filterTitle => 'Filter Companies';
  
  @override
  Future<void> loadData() async {
    setLoading(true);
    
    try {
      final companies = await _companyService.getCompanies();
      _allCompanies = companies;
      updateItems(companies);
    } catch (e) {
      setError('Error fetching companies: $e');
    }
  }
  
  @override
  Future<void> applyFilters() async {
    setLoading(true);
    
    try {
      final filtered = BusinessFilters.applyFilters(
        _allCompanies,
        industry: _selectedIndustry,
        size: _selectedSize,
        location: _selectedLocation,
      );
      
      updateItems(filtered);
    } catch (e) {
      setError('Error applying filters: $e');
    }
  }
  
  @override
  void resetFilters() {
    setState(() {
      _selectedIndustry = null;
      _selectedSize = null;
      _selectedLocation = null;
    });
    
    // Reset to all companies immediately
    if (_allCompanies.isNotEmpty) {
      updateItems(_allCompanies);
    }
  }
  
  @override
  List<FilterOption> buildFilterOptions() {
    return [
      FilterOption(
        title: 'Industry',
        selectedValue: _selectedIndustry,
        options: _industryOptions,
        onChanged: (value) {
          setState(() => _selectedIndustry = value);
        },
      ),
      FilterOption(
        title: 'Company Size',
        selectedValue: _selectedSize,
        options: _sizeOptions,
        onChanged: (value) {
          setState(() => _selectedSize = value);
        },
      ),
      FilterOption(
        title: 'Location Type',
        selectedValue: _selectedLocation,
        options: _locationOptions,
        onChanged: (value) {
          setState(() => _selectedLocation = value);
        },
      ),
    ];
  }

  @override
  Widget buildItemList() {
    if (items.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No companies match your filters',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final company = items[index];
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
    );
  }
}
