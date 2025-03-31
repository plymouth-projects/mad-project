/// Constants for job filtering options
class FilterOptions {
  // Employment Type options
  static const List<String> employmentTypes = [
    'Full-time',
    'Part-time',
    'Freelance',
    'On-Time',
    'Contract',
  ];

  // Seniority Level options
  static const List<String> seniorityLevels = [
    'Entry Level',
    'Junior',
    'Mid-Level',
    'Senior',
    'Lead',
    'Manager',
  ];

  // Salary Range options
  static const List<String> salaryRanges = [
    'Under Rs. 25,000',
    'Rs. 25,000 - 50,000',
    'Rs. 50,000 - 75,000',
    'Rs. 75,000 - 100,000',
    'Above Rs. 100,000',
  ];
  
  // Map for converting displayed text to numerical ranges for filtering
  static const Map<String, Map<String, dynamic>> salaryRangeValues = {
    'Under Rs. 25,000': {'min': 0, 'max': 25000},
    'Rs. 25,000 - 50,000': {'min': 25000, 'max': 50000},
    'Rs. 50,000 - 75,000': {'min': 50000, 'max': 75000},
    'Rs. 75,000 - 100,000': {'min': 75000, 'max': 100000},
    'Above Rs. 100,000': {'min': 100000, 'max': double.infinity},
  };
  
  // Filter keys for use in querying data
  static const String kEmploymentTypeKey = 'employement_type';
  static const String kSeniorityLevelKey = 'seniority_level';
  static const String kSalaryKey = 'salary';
  
  // Default values for filters
  static const String allOption = 'All';
}
