class User {
  final String id;
  final String email;
  final String? name;
  final String? phone;
  final String? location;
  final String? professionalSummary;
  final String? resumeUrl;
  final List<String> skills;
  final List<Experience> experience;
  final List<Education> education;
  final List<String> portfolioLinks;
  final Map<String, bool> privacySettings;

  User({
    required this.id,
    required this.email,
    this.name,
    this.phone,
    this.location,
    this.professionalSummary,
    this.resumeUrl,
    this.skills = const [],
    this.experience = const [],
    this.education = const [],
    this.portfolioLinks = const [],
    this.privacySettings = const {},
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      location: json['location'],
      professionalSummary: json['professionalSummary'],
      resumeUrl: json['resumeUrl'],
      skills: List<String>.from(json['skills'] ?? []),
      experience: (json['experience'] as List?)
          ?.map((e) => Experience.fromJson(e))
          .toList() ?? [],
      education: (json['education'] as List?)
          ?.map((e) => Education.fromJson(e))
          .toList() ?? [],
      portfolioLinks: List<String>.from(json['portfolioLinks'] ?? []),
      privacySettings: Map<String, bool>.from(json['privacySettings'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'location': location,
      'professionalSummary': professionalSummary,
      'resumeUrl': resumeUrl,
      'skills': skills,
      'experience': experience.map((e) => e.toJson()).toList(),
      'education': education.map((e) => e.toJson()).toList(),
      'portfolioLinks': portfolioLinks,
      'privacySettings': privacySettings,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? location,
    String? professionalSummary,
    String? resumeUrl,
    List<String>? skills,
    List<Experience>? experience,
    List<Education>? education,
    List<String>? portfolioLinks,
    Map<String, bool>? privacySettings,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      professionalSummary: professionalSummary ?? this.professionalSummary,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      skills: skills ?? this.skills,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      portfolioLinks: portfolioLinks ?? this.portfolioLinks,
      privacySettings: privacySettings ?? this.privacySettings,
    );
  }
}

class Experience {
  final String id;
  final String company;
  final String jobTitle;
  final DateTime startDate;
  final DateTime? endDate;
  final String responsibilities;

  Experience({
    required this.id,
    required this.company,
    required this.jobTitle,
    required this.startDate,
    this.endDate,
    required this.responsibilities,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: json['id'],
      company: json['company'],
      jobTitle: json['jobTitle'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      responsibilities: json['responsibilities'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company': company,
      'jobTitle': jobTitle,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'responsibilities': responsibilities,
    };
  }
}

class Education {
  final String id;
  final String degree;
  final String institution;
  final DateTime startDate;
  final DateTime? endDate;

  Education({
    required this.id,
    required this.degree,
    required this.institution,
    required this.startDate,
    this.endDate,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      id: json['id'],
      degree: json['degree'],
      institution: json['institution'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'degree': degree,
      'institution': institution,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }
}

