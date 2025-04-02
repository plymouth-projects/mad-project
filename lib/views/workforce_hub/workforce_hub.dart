import 'package:flutter/material.dart';
import 'package:mad_project/config/app_colors.dart';
import 'package:mad_project/config/app_routes.dart';
import 'package:mad_project/widgets/navbar.dart';
import 'package:mad_project/widgets/freelancer_card.dart';
import 'package:mad_project/services/freelancer_service.dart';
import 'package:mad_project/constants/freelancer_filters.dart';

class WorkforceHubScreen extends StatefulWidget {
  const WorkforceHubScreen({super.key});

  @override
  State<WorkforceHubScreen> createState() => _WorkforceHubScreenState();
}

class _WorkforceHubScreenState extends State<WorkforceHubScreen> {
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
  
  // Get filtered freelancers
  List<Map<String, dynamic>> get filteredFreelancers {
    final allFreelancers = _freelancerService.getFreelancers();
    
    return allFreelancers.where((freelancer) {
      // Filter by skill
      if (_selectedSkill != null) {
        final List<String> skills = freelancer['skills'] as List<String>;
        if (!skills.contains(_selectedSkill)) {
          return false;
        }
      }
      
      // Filter by level
      if (_selectedLevel != null && freelancer['level'] != _selectedLevel) {
        return false;
      }
      
      // Filter by availability
      if (_selectedAvailability != null && freelancer['availability'] != _selectedAvailability) {
        return false;
      }
      
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithDrawer(currentRoute: AppRoutes.workforceHub),
      drawer: AppNavDrawer(currentRoute: AppRoutes.workforceHub),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildResultCount(),
          const SizedBox(height: 16),
          _buildFreelancerList(),
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
            'WORKFORCE',
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
        '${filteredFreelancers.length} results',
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildFreelancerList() {
    return Expanded(
      child: ListView.builder(
        itemCount: filteredFreelancers.length,
        itemBuilder: (context, index) {
          final freelancer = filteredFreelancers[index];
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
                height: 450, // Adjusted height for the freelancer card
                child: FreelancerCard(
                  scale: 1.0,
                  freelancer: freelancer,
                ),
              ),
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
                'Filter Freelancers',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildModalFilterCategory(
                'Skills', 
                _selectedSkill,
                _getSkillOptions(),
                (value) {
                  setState(() => _selectedSkill = value);
                  setModalState(() {}); // Update modal state
                },
                setModalState,
              ),
              const SizedBox(height: 12),
              _buildModalFilterCategory(
                'Level',
                _selectedLevel,
                _getLevelOptions(),
                (value) {
                  setState(() => _selectedLevel = value);
                  setModalState(() {}); // Update modal state
                },
                setModalState,
              ),
              const SizedBox(height: 12),
              _buildModalFilterCategory(
                'Availability',
                _selectedAvailability,
                _getAvailabilityOptions(),
                (value) {
                  setState(() => _selectedAvailability = value);
                  setModalState(() {}); // Update modal state
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
                          _selectedSkill = null;
                          _selectedLevel = null;
                          _selectedAvailability = null;
                        });
                        setModalState(() {}); // Update modal state
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

  List<DropdownMenuItem<String>> _getSkillOptions() {
    return _skillOptions.map((skill) => DropdownMenuItem(
      value: skill,
      child: Text(skill, style: const TextStyle(color: Colors.white)),
    )).toList();
  }
  
  List<DropdownMenuItem<String>> _getLevelOptions() {
    return _levelOptions.map((level) => DropdownMenuItem(
      value: level,
      child: Text(level, style: const TextStyle(color: Colors.white)),
    )).toList();
  }

  List<DropdownMenuItem<String>> _getAvailabilityOptions() {
    return _availabilityOptions.map((availability) => DropdownMenuItem(
      value: availability,
      child: Text(availability, style: const TextStyle(color: Colors.white)),
    )).toList();
  }
}
