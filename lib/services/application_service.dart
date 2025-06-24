import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/application.dart';
import '../models/job.dart';
import '../services/auth_service.dart';

class ApplicationService {
  static const String _baseUrl = 'https://api.careerflow.com'; // Placeholder URL
  static const String _applicationsKey = 'user_applications';
  final AuthService _authService = AuthService();

  // Singleton pattern
  static final ApplicationService _instance = ApplicationService._internal();
  factory ApplicationService() => _instance;
  ApplicationService._internal();

  Future<List<JobApplication>> getUserApplications() async {
    try {
      // For demo purposes, we'll use local storage
      // In a real app, this would make an HTTP request to your backend
      
      final prefs = await SharedPreferences.getInstance();
      final applicationsJson = prefs.getString(_applicationsKey);
      
      if (applicationsJson != null) {
        final List<dynamic> applicationsList = jsonDecode(applicationsJson);
        return applicationsList
            .map((json) => JobApplication.fromJson(json))
            .toList();
      }
      
      // Return mock data if no saved applications
      return _generateMockApplications();
    } catch (e) {
      print('Get applications error: $e');
      throw Exception('Failed to load applications');
    }
  }

  Future<bool> createApplication({
    required String jobId,
    String? notes,
    String? resumeUsed,
    String? coverLetterUsed,
  }) async {
    try {
      final currentUser = _authService.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final application = JobApplication(
        id: 'app_${DateTime.now().millisecondsSinceEpoch}',
        jobId: jobId,
        userId: currentUser.id,
        status: ApplicationStatus.applied,
        dateApplied: DateTime.now(),
        notes: notes,
        resumeUsed: resumeUsed,
        coverLetterUsed: coverLetterUsed,
      );

      // Save to local storage
      final applications = await getUserApplications();
      applications.add(application);
      await _saveApplications(applications);

      return true;
    } catch (e) {
      print('Create application error: $e');
      return false;
    }
  }

  Future<bool> updateApplication(JobApplication application) async {
    try {
      final applications = await getUserApplications();
      final index = applications.indexWhere((app) => app.id == application.id);
      
      if (index >= 0) {
        applications[index] = application;
        await _saveApplications(applications);
        return true;
      }
      
      return false;
    } catch (e) {
      print('Update application error: $e');
      return false;
    }
  }

  Future<bool> deleteApplication(String applicationId) async {
    try {
      final applications = await getUserApplications();
      applications.removeWhere((app) => app.id == applicationId);
      await _saveApplications(applications);
      return true;
    } catch (e) {
      print('Delete application error: $e');
      return false;
    }
  }

  Future<JobApplication?> getApplicationById(String applicationId) async {
    try {
      final applications = await getUserApplications();
      return applications.firstWhere(
        (app) => app.id == applicationId,
        orElse: () => throw Exception('Application not found'),
      );
    } catch (e) {
      print('Get application error: $e');
      return null;
    }
  }

  Future<bool> hasAppliedToJob(String jobId) async {
    try {
      final applications = await getUserApplications();
      return applications.any((app) => app.jobId == jobId);
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveApplications(List<JobApplication> applications) async {
    final prefs = await SharedPreferences.getInstance();
    final applicationsJson = jsonEncode(
      applications.map((app) => app.toJson()).toList(),
    );
    await prefs.setString(_applicationsKey, applicationsJson);
  }

  List<JobApplication> _generateMockApplications() {
    return [
      JobApplication(
        id: 'app_1',
        jobId: 'job_1',
        userId: 'user_123',
        status: ApplicationStatus.interviewScheduled,
        dateApplied: DateTime.now().subtract(const Duration(days: 5)),
        notes: 'Applied through company website. Received confirmation email.',
        interviews: [
          Interview(
            id: 'int_1',
            scheduledDate: DateTime.now().add(const Duration(days: 2)),
            location: 'Video call - Zoom',
            interviewerName: 'Sarah Johnson',
            notes: 'Technical interview with the engineering team',
          ),
        ],
      ),
      JobApplication(
        id: 'app_2',
        jobId: 'job_2',
        userId: 'user_123',
        status: ApplicationStatus.applied,
        dateApplied: DateTime.now().subtract(const Duration(days: 3)),
        notes: 'Submitted application with updated resume.',
      ),
      JobApplication(
        id: 'app_3',
        jobId: 'job_3',
        userId: 'user_123',
        status: ApplicationStatus.rejected,
        dateApplied: DateTime.now().subtract(const Duration(days: 10)),
        notes: 'Received rejection email. They went with a more experienced candidate.',
      ),
    ];
  }
}

