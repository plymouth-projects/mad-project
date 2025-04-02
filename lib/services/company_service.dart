class CompanyService {
  List<Map<String, dynamic>> getCompanies() {
    return [
      {
        'id': 1,
        'name': 'TechGiant Corp',
        'logo': 'assets/images/companies/techgiant.png',
        'rating': 4.8,
        'location': 'San Francisco, CA',
        'description': 'Pioneering technology firm creating innovative solutions for global enterprises and transforming digital experiences through cutting-edge products.',
        'industry': 'Technology',
        'founded': '2005',
        'employees': '1000+',
        'website': 'www.techgiant.com',
        'jobs': [
          'Senior Software Engineer',
          'UI/UX Designer',
          'Product Manager'
        ],
      },
      {
        'id': 2,
        'name': 'Creative Solutions',
        'logo': 'assets/images/companies/creative.png',
        'rating': 4.5,
        'location': 'New York, NY',
        'description': 'Award-winning creative agency delivering impactful digital marketing campaigns that elevate brands and drive measurable business growth worldwide.',
        'industry': 'Marketing & Advertising',
        'founded': '2010',
        'employees': '250-500',
        'website': 'www.creativesolutions.com',
        'jobs': [
          'Digital Marketing Specialist',
          'Graphic Designer',
          'Content Strategist'
        ],
      },
      {
        'id': 3,
        'name': 'FinEdge',
        'logo': 'assets/images/companies/finedge.png',
        'rating': 4.7,
        'location': 'Chicago, IL',
        'description': 'Disruptive fintech startup revolutionizing banking with AI-powered solutions that make financial services more accessible, secure and user-friendly.',
        'industry': 'FinTech',
        'founded': '2015',
        'employees': '100-250',
        'website': 'www.finedge.com',
        'jobs': [
          'Financial Analyst',
          'Backend Developer',
          'Data Scientist'
        ],
      },
      {
        'id': 4,
        'name': 'HealthPlus',
        'logo': 'assets/images/companies/healthplus.png',
        'rating': 4.6,
        'location': 'Boston, MA',
        'description': 'Innovative healthcare company developing patient-centered technologies to improve medical outcomes and streamline healthcare delivery across communities.',
        'industry': 'Healthcare',
        'founded': '2012',
        'employees': '500-1000',
        'website': 'www.healthplus.com',
        'jobs': [
          'Healthcare Consultant',
          'Medical Software Developer',
          'AI Research Scientist'
        ],
      },
      {
        'id': 5,
        'name': 'GreenEarth',
        'logo': 'assets/images/companies/greenearth.png',
        'rating': 4.9,
        'location': 'Seattle, WA',
        'description': 'Environmental leader creating sustainable solutions for businesses and communities, fighting climate change through innovative green technologies.',
        'industry': 'Environmental',
        'founded': '2018',
        'employees': '50-100',
        'website': 'www.greenearth.com',
        'jobs': [
          'Environmental Engineer',
          'Sustainability Consultant',
          'Project Manager'
        ],
      },
    ];
  }
}
