import 'package:flutter/foundation.dart';
import '../models/application.dart';
import '../models/job.dart';
import '../services/application_service.dart';

class ApplicationProvider with ChangeNotifier {
  final ApplicationService _applicationService = ApplicationService();
  
  List<JobApplication> _applications = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<JobApplication> get applications => _applications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<JobApplication> get appliedApplications => 
      _applications.where((app) => app.status == ApplicationStatus.applied).toList();
  
  List<JobApplication> get interviewApplications => 
      _applications.where((app) => app.status == ApplicationStatus.interviewScheduled).toList();
  
  List<JobApplication> get offerApplications => 
      _applications.where((app) => app.status == ApplicationStatus.offerReceived).toList();
  
  List<JobApplication> get rejectedApplications => 
      _applications.where((app) => app.status == ApplicationStatus.rejected).toList();

  Future<void> loadApplications() async {
    _setLoading(true);
    _clearError();
    
    try {
      _applications = await _applicationService.getUserApplications();
    } catch (e) {
      _setError('Failed to load applications. Please try again.');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createApplication({
    required String jobId,
    String? notes,
    String? resumeUsed,
    String? coverLetterUsed,
  }) async {
    _clearError();
    
    try {
      final success = await _applicationService.createApplication(
        jobId: jobId,
        notes: notes,
        resumeUsed: resumeUsed,
        coverLetterUsed: coverLetterUsed,
      );
      
      if (success) {
        await loadApplications(); // Refresh the list
      } else {
        _setError('Failed to submit application');
      }
      
      return success;
    } catch (e) {
      _setError('Failed to submit application. Please try again.');
      return false;
    }
  }

  Future<bool> updateApplication(JobApplication application) async {
    _clearError();
    
    try {
      final success = await _applicationService.updateApplication(application);
      
      if (success) {
        final index = _applications.indexWhere((app) => app.id == application.id);
        if (index >= 0) {
          _applications[index] = application;
          notifyListeners();
        }
      } else {
        _setError('Failed to update application');
      }
      
      return success;
    } catch (e) {
      _setError('Failed to update application. Please try again.');
      return false;
    }
  }

  Future<bool> deleteApplication(String applicationId) async {
    _clearError();
    
    try {
      final success = await _applicationService.deleteApplication(applicationId);
      
      if (success) {
        _applications.removeWhere((app) => app.id == applicationId);
        notifyListeners();
      } else {
        _setError('Failed to delete application');
      }
      
      return success;
    } catch (e) {
      _setError('Failed to delete application. Please try again.');
      return false;
    }
  }

  Future<bool> hasAppliedToJob(String jobId) async {
    try {
      return await _applicationService.hasAppliedToJob(jobId);
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateApplicationStatus(String applicationId, ApplicationStatus status) async {
    final application = _applications.firstWhere(
      (app) => app.id == applicationId,
      orElse: () => throw Exception('Application not found'),
    );
    
    final updatedApplication = application.copyWith(status: status);
    return await updateApplication(updatedApplication);
  }

  Future<bool> addInterview(String applicationId, Interview interview) async {
    final application = _applications.firstWhere(
      (app) => app.id == applicationId,
      orElse: () => throw Exception('Application not found'),
    );
    
    final updatedInterviews = List<Interview>.from(application.interviews)
      ..add(interview);
    
    final updatedApplication = application.copyWith(
      interviews: updatedInterviews,
      status: ApplicationStatus.interviewScheduled,
    );
    
    return await updateApplication(updatedApplication);
  }

  Future<bool> updateInterview(String applicationId, Interview interview) async {
    final application = _applications.firstWhere(
      (app) => app.id == applicationId,
      orElse: () => throw Exception('Application not found'),
    );
    
    final updatedInterviews = application.interviews.map((int) {
      return int.id == interview.id ? interview : int;
    }).toList();
    
    final updatedApplication = application.copyWith(interviews: updatedInterviews);
    return await updateApplication(updatedApplication);
  }

  List<Interview> getUpcomingInterviews() {
    final now = DateTime.now();
    final allInterviews = <Interview>[];
    
    for (final application in _applications) {
      allInterviews.addAll(application.interviews);
    }
    
    return allInterviews
        .where((interview) => 
            interview.scheduledDate.isAfter(now) && !interview.isCompleted)
        .toList()
      ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}

