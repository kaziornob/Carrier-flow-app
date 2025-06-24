enum ApplicationStatus {
  applied,
  interviewScheduled,
  offerReceived,
  rejected,
  withdrawn,
}

class JobApplication {
  final String id;
  final String jobId;
  final String userId;
  final ApplicationStatus status;
  final DateTime dateApplied;
  final String? notes;
  final String? resumeUsed;
  final String? coverLetterUsed;
  final List<Interview> interviews;

  JobApplication({
    required this.id,
    required this.jobId,
    required this.userId,
    required this.status,
    required this.dateApplied,
    this.notes,
    this.resumeUsed,
    this.coverLetterUsed,
    this.interviews = const [],
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id'],
      jobId: json['jobId'],
      userId: json['userId'],
      status: ApplicationStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      dateApplied: DateTime.parse(json['dateApplied']),
      notes: json['notes'],
      resumeUsed: json['resumeUsed'],
      coverLetterUsed: json['coverLetterUsed'],
      interviews: (json['interviews'] as List?)
          ?.map((e) => Interview.fromJson(e))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobId': jobId,
      'userId': userId,
      'status': status.toString().split('.').last,
      'dateApplied': dateApplied.toIso8601String(),
      'notes': notes,
      'resumeUsed': resumeUsed,
      'coverLetterUsed': coverLetterUsed,
      'interviews': interviews.map((e) => e.toJson()).toList(),
    };
  }

  JobApplication copyWith({
    String? id,
    String? jobId,
    String? userId,
    ApplicationStatus? status,
    DateTime? dateApplied,
    String? notes,
    String? resumeUsed,
    String? coverLetterUsed,
    List<Interview>? interviews,
  }) {
    return JobApplication(
      id: id ?? this.id,
      jobId: jobId ?? this.jobId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      dateApplied: dateApplied ?? this.dateApplied,
      notes: notes ?? this.notes,
      resumeUsed: resumeUsed ?? this.resumeUsed,
      coverLetterUsed: coverLetterUsed ?? this.coverLetterUsed,
      interviews: interviews ?? this.interviews,
    );
  }
}

class Interview {
  final String id;
  final DateTime scheduledDate;
  final String? location;
  final String? interviewerName;
  final String? notes;
  final bool isCompleted;

  Interview({
    required this.id,
    required this.scheduledDate,
    this.location,
    this.interviewerName,
    this.notes,
    this.isCompleted = false,
  });

  factory Interview.fromJson(Map<String, dynamic> json) {
    return Interview(
      id: json['id'],
      scheduledDate: DateTime.parse(json['scheduledDate']),
      location: json['location'],
      interviewerName: json['interviewerName'],
      notes: json['notes'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scheduledDate': scheduledDate.toIso8601String(),
      'location': location,
      'interviewerName': interviewerName,
      'notes': notes,
      'isCompleted': isCompleted,
    };
  }
}

