import 'package:flutter/material.dart';
import 'package:mad_project/config/app_routes.dart';
import 'package:mad_project/constants/jobs_filters.dart';
import 'package:mad_project/models/job_model.dart';
import 'package:mad_project/services/job_service.dart';
import 'package:mad_project/utils/date_utils.dart' as app_date_utils;
import 'package:mad_project/widgets/job_card.dart';
import 'package:mad_project/widgets/base_hub_screen.dart';
import 'package:mad_project/widgets/filter_bottom_sheet.dart';

class JobHubScreen extends BaseHubScreen<Job> {
  const JobHubScreen({super.key});

  @override
  State<JobHubScreen> createState() => _JobHubScreenState();
}

class _JobHubScreenState extends BaseHubScreenState<JobHubScreen, Job> {
  final JobService _jobService = JobService();
  
  // Filter state
  String? _selectedEmploymentType;
  String? _selectedSeniorityLevel;
  String? _selectedSalaryRange;
  String? _searchTerm;

  @override
  String get hubTitle => 'JOB LISTINGS';
  
  @override
  String get currentRoute => AppRoutes.jobHub;
  
  @override
  String get filterTitle => 'Filter Jobs';
  
  @override
  Future<void> loadData() async {
    setLoading(true);
    
    try {
      final jobs = await _jobService.getFilteredJobObjects(
        employmentType: _selectedEmploymentType,
        seniorityLevel: _selectedSeniorityLevel,
        salaryRange: _selectedSalaryRange,
        searchTerm: _searchTerm,
      );
      
      updateItems(jobs);
    } catch (e) {
      setError('Error loading jobs: $e');
    }
  }
  
  @override
  Future<void> applyFilters() async {
    // The loadData method already applies filters
    await loadData();
  }
  
  @override
  void resetFilters() {
    setState(() {
      _selectedEmploymentType = null;
      _selectedSeniorityLevel = null;
      _selectedSalaryRange = null;
      _searchTerm = null;
    });
  }
  
  @override
  List<FilterOption> buildFilterOptions() {
    return [
      FilterOption(
        title: 'Types of Employment',
        selectedValue: _selectedEmploymentType,
        options: FilterOptions.employmentTypes,
        onChanged: (value) {
          setState(() => _selectedEmploymentType = value);
        },
      ),
      FilterOption(
        title: 'Experience Level',
        selectedValue: _selectedSeniorityLevel,
        options: FilterOptions.seniorityLevels,
        onChanged: (value) {
          setState(() => _selectedSeniorityLevel = value);
        },
      ),
      FilterOption(
        title: 'Salary Range',
        selectedValue: _selectedSalaryRange,
        options: FilterOptions.salaryRanges,
        onChanged: (value) {
          setState(() => _selectedSalaryRange = value);
        },
      ),
    ];
  }

  void _handleJobApplication(Job job) {
    Navigator.pushNamed(
      context, 
      AppRoutes.jobDetails,
      arguments: job,
    );
  }

  @override
  Widget buildItemList() {
    if (items.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text(
            'No jobs match your filters',
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
        final job = items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SizedBox(
            height: 300,
            child: JobCard(
              scale: 1.0,
              job: job.toMap(),
              calculateDaysLeft: app_date_utils.DateUtils.calculateDaysLeft,
              onApplyPressed: () => _handleJobApplication(job),
            ),
          ),
        );
      },
    );
  }
}
