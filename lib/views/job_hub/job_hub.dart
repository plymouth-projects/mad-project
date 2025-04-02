import 'package:flutter/material.dart';
import 'package:mad_project/config/app_colors.dart';
import 'package:mad_project/config/app_routes.dart';
import 'package:mad_project/widgets/navbar.dart';
import 'package:mad_project/widgets/job_card.dart';
import 'package:mad_project/services/job_service.dart';
import 'package:mad_project/utils/date_utils.dart' as app_date_utils;
import 'package:mad_project/constants/jobs_filters.dart';

class JobHubScreen extends StatefulWidget {
  const JobHubScreen({super.key});

  @override
  State<JobHubScreen> createState() => _JobHubScreenState();
}

class _JobHubScreenState extends State<JobHubScreen> {
  // Selected filter values
  String? _selectedEmploymentType;
  String? _selectedSeniorityLevel;
  String? _selectedSalaryRange;
  
  // Job service instance
  final JobService _jobService = JobService();
  
  // Get filtered jobs
  List<Map<String, String>> get filteredJobs {
    return _jobService.getFilteredJobs(
      employmentType: _selectedEmploymentType,
      seniorityLevel: _selectedSeniorityLevel,
      salaryRange: _selectedSalaryRange,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithDrawer(currentRoute: AppRoutes.jobHub),
      drawer: AppNavDrawer(currentRoute: AppRoutes.jobHub),
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
          _buildJobList(),
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
            'JOB LISTINGS',
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
        '${filteredJobs.length} results',
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  Widget _buildJobList() {
    return Expanded(
      child: ListView.builder(
        itemCount: filteredJobs.length,
        itemBuilder: (context, index) {
          final job = filteredJobs[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SizedBox(
              height: 300,
              child: JobCard(
                scale: 1.0,
                job: job,
                calculateDaysLeft: app_date_utils.DateUtils.calculateDaysLeft,
                onApplyPressed: () => _handleJobApplication(job),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleJobApplication(Map<String, String> job) {
    // Navigate to job details page instead of showing a dialog
    Navigator.pushNamed(
      context, 
      AppRoutes.jobDetails,
      arguments: job,
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
                'Filter Jobs',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildModalFilterCategory(
                'Types of Employment', 
                _selectedEmploymentType,
                _getEmploymentTypeOptions(),
                (value) {
                  setState(() => _selectedEmploymentType = value);
                  setModalState(() {}); // Update modal state
                },
                setModalState,
              ),
              const SizedBox(height: 12),
              _buildModalFilterCategory(
                'Experience Level',
                _selectedSeniorityLevel,
                _getSeniorityLevelOptions(),
                (value) {
                  setState(() => _selectedSeniorityLevel = value);
                  setModalState(() {}); // Update modal state
                },
                setModalState,
              ),
              const SizedBox(height: 12),
              _buildModalFilterCategory(
                'Salary Range',
                _selectedSalaryRange,
                _getSalaryRangeOptions(),
                (value) {
                  setState(() => _selectedSalaryRange = value);
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
                          _selectedEmploymentType = null;
                          _selectedSeniorityLevel = null;
                          _selectedSalaryRange = null;
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

  List<DropdownMenuItem<String>> _getEmploymentTypeOptions() {
    return FilterOptions.employmentTypes.map((type) => DropdownMenuItem(
      value: type,
      child: Text(type, style: const TextStyle(color: Colors.white)),
    )).toList();
  }
  
  List<DropdownMenuItem<String>> _getSeniorityLevelOptions() {
    return FilterOptions.seniorityLevels.map((level) => DropdownMenuItem(
      value: level,
      child: Text(level, style: const TextStyle(color: Colors.white)),
    )).toList();
  }

  List<DropdownMenuItem<String>> _getSalaryRangeOptions() {
    return FilterOptions.salaryRanges.map((range) => DropdownMenuItem(
      value: range,
      child: Text(range, style: const TextStyle(color: Colors.white)),
    )).toList();
  }
}
