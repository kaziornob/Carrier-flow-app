enum JobType {
  fullTime,
  partTime,
  contract,
  internship,
  freelance,
}

enum ExperienceLevel {
  entry,
  mid,
  senior,
  executive,
}

enum LocationType {
  remote,
  hybrid,
  onSite,
}

class Job {
  final String id;
  final String title;
  final String company;
  final String location;
  final LocationType locationType;
  final JobType jobType;
  final ExperienceLevel experienceLevel;
  final String? salaryRange;
  final String description;
  final String companyOverview;
  final List<String> requirements;
  final List<String> responsibilities;
  final String? applyUrl;
  final DateTime datePosted;
  final String? industry;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.locationType,
    required this.jobType,
    required this.experienceLevel,
    this.salaryRange,
    required this.description,
    required this.companyOverview,
    required this.requirements,
    required this.responsibilities,
    this.applyUrl,
    required this.datePosted,
    this.industry,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      title: json['title'],
      company: json['company'],
      location: json['location'],
      locationType: LocationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['locationType'],
      ),
      jobType: JobType.values.firstWhere(
        (e) => e.toString().split('.').last == json['jobType'],
      ),
      experienceLevel: ExperienceLevel.values.firstWhere(
        (e) => e.toString().split('.').last == json['experienceLevel'],
      ),
      salaryRange: json['salaryRange'],
      description: json['description'],
      companyOverview: json['companyOverview'],
      requirements: List<String>.from(json['requirements'] ?? []),
      responsibilities: List<String>.from(json['responsibilities'] ?? []),
      applyUrl: json['applyUrl'],
      datePosted: DateTime.parse(json['datePosted']),
      industry: json['industry'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'locationType': locationType.toString().split('.').last,
      'jobType': jobType.toString().split('.').last,
      'experienceLevel': experienceLevel.toString().split('.').last,
      'salaryRange': salaryRange,
      'description': description,
      'companyOverview': companyOverview,
      'requirements': requirements,
      'responsibilities': responsibilities,
      'applyUrl': applyUrl,
      'datePosted': datePosted.toIso8601String(),
      'industry': industry,
    };
  }
}

class JobFilters {
  final String? keyword;
  final JobType? jobType;
  final LocationType? locationType;
  final ExperienceLevel? experienceLevel;
  final String? industry;
  final String? location;
  final double? minSalary;
  final double? maxSalary;
  final DateTime? datePostedAfter;

  JobFilters({
    this.keyword,
    this.jobType,
    this.locationType,
    this.experienceLevel,
    this.industry,
    this.location,
    this.minSalary,
    this.maxSalary,
    this.datePostedAfter,
  });

  JobFilters copyWith({
    String? keyword,
    JobType? jobType,
    LocationType? locationType,
    ExperienceLevel? experienceLevel,
    String? industry,
    String? location,
    double? minSalary,
    double? maxSalary,
    DateTime? datePostedAfter,
  }) {
    return JobFilters(
      keyword: keyword ?? this.keyword,
      jobType: jobType ?? this.jobType,
      locationType: locationType ?? this.locationType,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      industry: industry ?? this.industry,
      location: location ?? this.location,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      datePostedAfter: datePostedAfter ?? this.datePostedAfter,
    );
  }
}

