/// Constants for business/company filtering options
class BusinessFilters {
  // Existing filter options
  static const List<String> industryOptions = [
    'All',
    'Technology',
    'Finance',
    'Healthcare',
    'Education',
    'Retail',
    'Manufacturing',
    'Entertainment',
    'Other'
  ];
  static const List<String> sizeOptions = [
    'Small (1-50)',
    'Medium (51-250)',
    'Large (251+)',
    'Enterprise (1000+)'
  ];
  static const List<String> locationOptions = [
    'Remote',
    'Hybrid',
    'On-site'
  ];

  // Helper method to determine company size category based on employee count
  static String determineCompanySize(String employeeCount) {
    if (employeeCount == '1000+') {
      return 'Enterprise (1000+)';
    } else if (employeeCount == '500-1000' || employeeCount == '250-500') {
      return 'Large (251+)';
    } else if (employeeCount == '100-250' || employeeCount == '50-100') {
      return 'Medium (51-250)';
    } else {
      return 'Small (1-50)';
    }
  }

  // Filter methods
  static List<Map<String, dynamic>> filterByIndustry(List<Map<String, dynamic>> companies, String? industry) {
    if (industry == null || industry == 'All') {
      return companies;
    }
    return companies.where((company) => company['industry'] == industry).toList();
  }

  static List<Map<String, dynamic>> filterBySize(List<Map<String, dynamic>> companies, String? size) {
    if (size == null) {
      return companies;
    }
    return companies.where((company) => 
      determineCompanySize(company['employees']) == size
    ).toList();
  }

  static List<Map<String, dynamic>> filterByLocation(List<Map<String, dynamic>> companies, String? location) {
    if (location == null) {
      return companies;
    }
    return companies.where((company) => company['location'] == location).toList();
  }

  // Combined filter method
  static List<Map<String, dynamic>> applyFilters(
    List<Map<String, dynamic>> companies, {
    String? industry,
    String? size,
    String? location,
  }) {
    return companies.where((company) {
      // Filter by industry
      if (industry != null && industry != 'All') {
        if (company['industry'] != industry) {
          return false;
        }
      }
      
      // Filter by size
      if (size != null) {
        if (determineCompanySize(company['employees']) != size) {
          return false;
        }
      }
      
      // Filter by location
      if (location != null && company['location'] != location) {
        return false;
      }
      
      return true;
    }).toList();
  }
}
