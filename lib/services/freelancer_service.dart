class FreelancerService {
  // Singleton pattern
  static final FreelancerService _instance = FreelancerService._internal();
  
  factory FreelancerService() {
    return _instance;
  }
  
  FreelancerService._internal();
  
  // Get all freelancers data
  List<Map<String, dynamic>> getFreelancers() {
    return [
      {
        "image": "assets/images/plumber.png",
        "name": "RAYAN FERNANDO",
        "location": "No: 123, Colombo Road, Colombo 07",
        "skills": ["Plumbing", "Electrical", "Painting"],
        "rate": "Rs. 4000/Day",
        "jobsCompleted": "20 Jobs Completed",
        "availability": "Full-Time",
        "level": "Beginner",
      },
      {
        "image": "assets/images/plumber.png",
        "name": "MALITH PERERA",
        "location": "No: 456, Kandy Road, Sri Lanka",
        "skills": ["Carpentry", "Welding", "Masonry"],
        "rate": "Rs. 5000/Day",
        "jobsCompleted": "30 Jobs Completed",
        "availability": "Part-Time",
        "level": "Intermediate",
      },
      {
        "image": "assets/images/plumber.png",
        "name": "ANJALI FONSEKA",
        "location": "Galle Road, Colombo",
        "skills": ["House Cleaning", "Gardening"],
        "rate": "Rs. 3000/Day",
        "jobsCompleted": "15 Jobs Completed",
        "availability": "Full-Time",
        "level": "Expert",
      },
      {
        "image": "assets/images/plumber.png",
        "name": "ANJALI FONSEKA",
        "location": "Galle Road, Colombo",
        "skills": ["House Cleaning", "Gardening"],
        "rate": "Rs. 3000/Day",
        "jobsCompleted": "15 Jobs Completed",
        "availability": "Full-Time",
        "level": "Verified",
      },
    ];
  }
  
  // Get featured freelancers (could be filtered by rating or other criteria)
  List<Map<String, dynamic>> getFeaturedFreelancers() {
    return getFreelancers().where((freelancer) => 
      freelancer["level"] == "Expert" || freelancer["level"] == "Verified"
    ).toList();
  }
  
  // Get freelancers by skill
  List<Map<String, dynamic>> getFreelancersBySkill(String skill) {
    return getFreelancers().where((freelancer) => 
      (freelancer["skills"] as List<String>).contains(skill)
    ).toList();
  }
  
  // Get freelancers by level
  List<Map<String, dynamic>> getFreelancersByLevel(String level) {
    return getFreelancers().where((freelancer) => 
      freelancer["level"] == level
    ).toList();
  }
}
