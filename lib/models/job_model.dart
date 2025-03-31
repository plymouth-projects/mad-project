/// Job model class for representing job listings
class Job {
  final String title;
  final String company;
  final String location;
  final String description;
  final String imageUrl;
  final String salary;
  final String deadline;
  final String employmentType;
  final String seniorityLevel;
  final String applicationCount; // Added field for application count

  /// Constructor for Job model
  const Job({
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    required this.imageUrl,
    required this.salary,
    required this.deadline,
    required this.employmentType,
    required this.seniorityLevel,
    this.applicationCount = '0', // Default to 0 if not provided
  });

  /// Create a Job from a map
  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      title: map['title'] ?? '',
      company: map['company'] ?? '',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['image'] ?? '',
      salary: map['salary'] ?? '',
      deadline: map['deadline'] ?? '',
      employmentType: map['employement_type'] ?? '',
      seniorityLevel: map['seniority_level'] ?? '',
      applicationCount: map['application_count'] ?? '0',
    );
  }

  /// Convert Job to a map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'company': company,
      'location': location,
      'description': description,
      'image': imageUrl,
      'salary': salary,
      'deadline': deadline,
      'employement_type': employmentType,
      'seniority_level': seniorityLevel,
      'application_count': applicationCount,
    };
  }

  /// Create a copy of this Job with the given fields replaced
  Job copyWith({
    String? title,
    String? company,
    String? location,
    String? description,
    String? imageUrl,
    String? salary,
    String? deadline,
    String? employmentType,
    String? seniorityLevel,
    String? applicationCount,
  }) {
    return Job(
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      salary: salary ?? this.salary,
      deadline: deadline ?? this.deadline,
      employmentType: employmentType ?? this.employmentType,
      seniorityLevel: seniorityLevel ?? this.seniorityLevel,
      applicationCount: applicationCount ?? this.applicationCount,
    );
  }

  /// Extract salary amount as a number (for filtering)
  int? get salaryAmount {
    // Extract numeric part from strings like "Rs. 75,000/Month"
    final RegExp regex = RegExp(r'Rs\.\s*([0-9,]+)');
    final match = regex.firstMatch(salary);
    
    if (match != null && match.groupCount >= 1) {
      final numericStr = match.group(1)?.replaceAll(',', '');
      if (numericStr != null) {
        return int.tryParse(numericStr);
      }
    }
    
    return null;
  }

  /// Check if the job is still open for applications
  bool get isOpen {
    try {
      final deadlineDate = DateTime.parse(deadline);
      final now = DateTime.now();
      return deadlineDate.isAfter(now);
    } catch (e) {
      return false;
    }
  }

  /// Get days remaining until the deadline
  int? get daysRemaining {
    try {
      final deadlineDate = DateTime.parse(deadline);
      final now = DateTime.now();
      return deadlineDate.difference(now).inDays;
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() {
    return 'Job(title: $title, company: $company, salary: $salary, employmentType: $employmentType, applicationCount: $applicationCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Job &&
      other.title == title &&
      other.company == company &&
      other.location == location &&
      other.description == description &&
      other.imageUrl == imageUrl &&
      other.salary == salary &&
      other.deadline == deadline &&
      other.employmentType == employmentType &&
      other.seniorityLevel == seniorityLevel &&
      other.applicationCount == applicationCount;
  }

  @override
  int get hashCode {
    return title.hashCode ^
      company.hashCode ^
      location.hashCode ^
      description.hashCode ^
      imageUrl.hashCode ^
      salary.hashCode ^
      deadline.hashCode ^
      employmentType.hashCode ^
      seniorityLevel.hashCode ^
      applicationCount.hashCode;
  }
}

/// Model for job application data
class JobApplication {
  final String jobId;
  final String userId;
  final DateTime appliedDate;
  final String status;
  final Map<String, dynamic> additionalInfo;

  const JobApplication({
    required this.jobId,
    required this.userId,
    required this.appliedDate,
    this.status = 'pending',
    this.additionalInfo = const {},
  });

  /// Create from map
  factory JobApplication.fromMap(Map<String, dynamic> map) {
    return JobApplication(
      jobId: map['jobId'] ?? '',
      userId: map['userId'] ?? '',
      appliedDate: map['appliedDate'] != null 
        ? DateTime.parse(map['appliedDate']) 
        : DateTime.now(),
      status: map['status'] ?? 'pending',
      additionalInfo: Map<String, dynamic>.from(map['additionalInfo'] ?? {}),
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'userId': userId,
      'appliedDate': appliedDate.toIso8601String(),
      'status': status,
      'additionalInfo': additionalInfo,
    };
  }
}
