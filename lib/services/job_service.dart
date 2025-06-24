import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/job.dart';
import '../services/auth_service.dart';

class JobService {
  static const String _baseUrl = 'https://api.careerflow.com'; // Placeholder URL
  final AuthService _authService = AuthService();

  // Singleton pattern
  static final JobService _instance = JobService._internal();
  factory JobService() => _instance;
  JobService._internal();

  Future<List<Job>> searchJobs({
    String? keyword,
    JobFilters? filters,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      // For demo purposes, we'll return mock data
      // In a real app, this would make an HTTP request to your backend
      
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Generate mock jobs based on search criteria
      return _generateMockJobs(keyword: keyword, filters: filters);
    } catch (e) {
      print('Search jobs error: $e');
      throw Exception('Failed to search jobs');
    }
  }

  Future<Job?> getJobById(String jobId) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Return a mock job
      return _generateMockJobs().firstWhere(
        (job) => job.id == jobId,
        orElse: () => throw Exception('Job not found'),
      );
    } catch (e) {
      print('Get job error: $e');
      return null;
    }
  }

  Future<List<String>> getSuggestions(String query) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Return mock suggestions
      final suggestions = [
        'Flutter Developer',
        'Software Engineer',
        'Mobile Developer',
        'Frontend Developer',
        'Backend Developer',
        'Full Stack Developer',
        'UI/UX Designer',
        'Product Manager',
        'Data Scientist',
        'DevOps Engineer',
      ];
      
      return suggestions
          .where((suggestion) => 
              suggestion.toLowerCase().contains(query.toLowerCase()))
          .take(5)
          .toList();
    } catch (e) {
      print('Get suggestions error: $e');
      return [];
    }
  }

  List<Job> _generateMockJobs({String? keyword, JobFilters? filters}) {
    final mockJobs = [
      Job(
        id: 'job_1',
        title: 'Senior Flutter Developer',
        company: 'TechCorp Inc.',
        location: 'San Francisco, CA',
        locationType: LocationType.hybrid,
        jobType: JobType.fullTime,
        experienceLevel: ExperienceLevel.senior,
        salaryRange: '\$120,000 - \$160,000',
        description: 'We are looking for an experienced Flutter developer to join our mobile team. You will be responsible for developing high-quality mobile applications using Flutter framework.',
        companyOverview: 'TechCorp Inc. is a leading technology company focused on innovative mobile solutions.',
        requirements: [
          '5+ years of mobile development experience',
          'Strong knowledge of Flutter and Dart',
          'Experience with state management (Provider, Bloc, Riverpod)',
          'Knowledge of REST APIs and JSON',
          'Experience with Git version control',
        ],
        responsibilities: [
          'Develop and maintain Flutter mobile applications',
          'Collaborate with cross-functional teams',
          'Write clean, maintainable code',
          'Participate in code reviews',
          'Optimize app performance',
        ],
        applyUrl: 'https://techcorp.com/careers/flutter-dev',
        datePosted: DateTime.now().subtract(const Duration(days: 2)),
        industry: 'Technology',
      ),
      Job(
        id: 'job_2',
        title: 'Mobile App Developer',
        company: 'StartupXYZ',
        location: 'Remote',
        locationType: LocationType.remote,
        jobType: JobType.fullTime,
        experienceLevel: ExperienceLevel.mid,
        salaryRange: '\$80,000 - \$110,000',
        description: 'Join our dynamic startup team as a Mobile App Developer. Work on cutting-edge projects and help shape the future of mobile technology.',
        companyOverview: 'StartupXYZ is a fast-growing startup revolutionizing the mobile app industry.',
        requirements: [
          '3+ years of mobile development experience',
          'Experience with Flutter or React Native',
          'Knowledge of mobile UI/UX principles',
          'Strong problem-solving skills',
        ],
        responsibilities: [
          'Build mobile applications from scratch',
          'Implement new features and functionality',
          'Debug and fix issues',
          'Work closely with designers and product managers',
        ],
        applyUrl: 'https://startupxyz.com/jobs/mobile-dev',
        datePosted: DateTime.now().subtract(const Duration(days: 1)),
        industry: 'Technology',
      ),
      Job(
        id: 'job_3',
        title: 'Junior Flutter Developer',
        company: 'MobileTech Solutions',
        location: 'New York, NY',
        locationType: LocationType.onSite,
        jobType: JobType.fullTime,
        experienceLevel: ExperienceLevel.entry,
        salaryRange: '\$60,000 - \$80,000',
        description: 'Great opportunity for a junior developer to grow their skills in Flutter development. We provide mentorship and training.',
        companyOverview: 'MobileTech Solutions specializes in custom mobile app development for businesses.',
        requirements: [
          '1-2 years of programming experience',
          'Basic knowledge of Flutter and Dart',
          'Understanding of mobile development concepts',
          'Eagerness to learn and grow',
        ],
        responsibilities: [
          'Assist in developing Flutter applications',
          'Learn from senior developers',
          'Write and test code',
          'Participate in team meetings',
        ],
        applyUrl: 'https://mobiletech.com/careers/junior-flutter',
        datePosted: DateTime.now().subtract(const Duration(hours: 12)),
        industry: 'Technology',
      ),
      Job(
        id: 'job_4',
        title: 'Freelance Mobile Developer',
        company: 'Digital Agency Pro',
        location: 'Los Angeles, CA',
        locationType: LocationType.remote,
        jobType: JobType.freelance,
        experienceLevel: ExperienceLevel.mid,
        salaryRange: '\$50 - \$80 per hour',
        description: 'We are seeking a freelance mobile developer for various client projects. Flexible schedule and competitive rates.',
        companyOverview: 'Digital Agency Pro provides digital solutions for small and medium businesses.',
        requirements: [
          '2+ years of mobile development experience',
          'Portfolio of completed mobile apps',
          'Ability to work independently',
          'Good communication skills',
        ],
        responsibilities: [
          'Develop mobile apps for clients',
          'Communicate with project managers',
          'Meet project deadlines',
          'Provide technical documentation',
        ],
        applyUrl: 'https://digitalagencypro.com/freelance',
        datePosted: DateTime.now().subtract(const Duration(days: 3)),
        industry: 'Digital Marketing',
      ),
      Job(
        id: 'job_5',
        title: 'Mobile Development Intern',
        company: 'InnovateLab',
        location: 'Austin, TX',
        locationType: LocationType.hybrid,
        jobType: JobType.internship,
        experienceLevel: ExperienceLevel.entry,
        salaryRange: '\$20 - \$25 per hour',
        description: 'Summer internship program for students interested in mobile development. Hands-on experience with real projects.',
        companyOverview: 'InnovateLab is a research and development company focused on emerging technologies.',
        requirements: [
          'Currently pursuing Computer Science degree',
          'Basic programming knowledge',
          'Interest in mobile development',
          'Available for 3-month internship',
        ],
        responsibilities: [
          'Assist in mobile app development',
          'Learn mobile development best practices',
          'Participate in team projects',
          'Present final project',
        ],
        applyUrl: 'https://innovatelab.com/internships',
        datePosted: DateTime.now().subtract(const Duration(days: 5)),
        industry: 'Research & Development',
      ),
    ];

    // Apply filters if provided
    var filteredJobs = mockJobs;

    if (keyword != null && keyword.isNotEmpty) {
      filteredJobs = filteredJobs.where((job) =>
          job.title.toLowerCase().contains(keyword.toLowerCase()) ||
          job.company.toLowerCase().contains(keyword.toLowerCase()) ||
          job.description.toLowerCase().contains(keyword.toLowerCase())).toList();
    }

    if (filters != null) {
      if (filters.jobType != null) {
        filteredJobs = filteredJobs.where((job) => job.jobType == filters.jobType).toList();
      }
      if (filters.locationType != null) {
        filteredJobs = filteredJobs.where((job) => job.locationType == filters.locationType).toList();
      }
      if (filters.experienceLevel != null) {
        filteredJobs = filteredJobs.where((job) => job.experienceLevel == filters.experienceLevel).toList();
      }
      if (filters.location != null && filters.location!.isNotEmpty) {
        filteredJobs = filteredJobs.where((job) =>
            job.location.toLowerCase().contains(filters.location!.toLowerCase())).toList();
      }
    }

    return filteredJobs;
  }
}

