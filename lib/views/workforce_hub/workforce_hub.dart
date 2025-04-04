import 'package:flutter/material.dart';
import 'package:mad_project/config/app_routes.dart';
import 'package:mad_project/constants/freelancer_filters.dart';
import 'package:mad_project/services/freelancer_service.dart';
import 'package:mad_project/widgets/freelancer_card.dart';
import 'package:mad_project/widgets/base_hub_screen.dart';
import 'package:mad_project/widgets/filter_bottom_sheet.dart';

class WorkforceHubScreen extends BaseHubScreen<Map<String, dynamic>> {
  const WorkforceHubScreen({super.key});

  @override
  State<WorkforceHubScreen> createState() => _WorkforceHubScreenState();
}

class _WorkforceHubScreenState extends BaseHubScreenState<WorkforceHubScreen, Map<String, dynamic>> {
  // Selected filter values
  String? _selectedSkill;
  String? _selectedLevel;
  String? _selectedAvailability;
  
  // Freelancer service instance
  final FreelancerService _freelancerService = FreelancerService();
  
  // Filter options from constants
  final List<String> _skillOptions = FreelancerFilters.skillOptions;
  final List<String> _levelOptions = FreelancerFilters.levelOptions;
  final List<String> _availabilityOptions = FreelancerFilters.availabilityOptions;
  
  @override
  String get hubTitle => 'WORKFORCE';
  
  @override
  String get currentRoute => AppRoutes.workforceHub;
  
  @override
  String get filterTitle => 'Filter Freelancers';
  
  @override
  Future<void> loadData() async {
    try {
      setLoading(true);
      final allFreelancers = await _freelancerService.getFreelancers();
      updateItems(allFreelancers.isNotEmpty ? allFreelancers : []);
    } catch (e) {
      setError('Failed to load freelancers: $e');
    }
  }
  
  @override
  Future<void> applyFilters() async {
    setLoading(true);
    
    try {
      List<Map<String, dynamic>> result = [];
      
      // If level filter is selected, use it
      if (_selectedLevel != null) {
        result = await _freelancerService.getFreelancersByLevel(_selectedLevel!);
      } else {
        result = await _freelancerService.getFreelancers();
      }
      
      // If skill filter is selected, apply it
      if (_selectedSkill != null) {
        result = result.where((freelancer) {
          if (freelancer['skills'] == null) return false;
          
          // Safely convert dynamic list to list of strings for comparison
          List<dynamic> dynamicSkills = freelancer['skills'] as List<dynamic>;
          List<String> skillsList = dynamicSkills.map((item) => item.toString()).toList();
          
          return skillsList.contains(_selectedSkill);
        }).toList();
      }
      
      // Apply availability filter
      if (_selectedAvailability != null) {
        result = result.where((freelancer) => 
          freelancer['availability']?.toString() == _selectedAvailability
        ).toList();
      }
      
      updateItems(result);
    } catch (e) {
      setError('Error applying filters: $e');
    }
  }
  
  @override
  void resetFilters() {
    setState(() {
      _selectedSkill = null;
      _selectedLevel = null;
      _selectedAvailability = null;
    });
  }
  
  @override
  List<FilterOption> buildFilterOptions() {
    return [
      FilterOption(
        title: 'Skills',
        selectedValue: _selectedSkill,
        options: _skillOptions,
        onChanged: (value) {
          setState(() => _selectedSkill = value);
        },
      ),
      FilterOption(
        title: 'Level',
        selectedValue: _selectedLevel,
        options: _levelOptions,
        onChanged: (value) {
          setState(() => _selectedLevel = value);
        },
      ),
      FilterOption(
        title: 'Availability',
        selectedValue: _selectedAvailability,
        options: _availabilityOptions,
        onChanged: (value) {
          setState(() => _selectedAvailability = value);
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
            'No freelancers found matching the filters',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final freelancer = items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.freelancerDetails,
                arguments: freelancer,
              );
            },
            child: SizedBox(
              height: 450,
              child: FreelancerCard(
                scale: 1.0,
                freelancer: freelancer,
              ),
            ),
          ),
        );
      },
    );
  }
}
