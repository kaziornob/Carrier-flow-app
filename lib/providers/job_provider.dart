import 'package:flutter/foundation.dart';
import '../models/job.dart';
import '../services/job_service.dart';

class JobProvider with ChangeNotifier {
  final JobService _jobService = JobService();
  
  List<Job> _jobs = [];
  List<Job> _savedJobs = [];
  List<String> _searchSuggestions = [];
  JobFilters _currentFilters = JobFilters();
  String _currentKeyword = '';
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMoreJobs = true;

  List<Job> get jobs => _jobs;
  List<Job> get savedJobs => _savedJobs;
  List<String> get searchSuggestions => _searchSuggestions;
  JobFilters get currentFilters => _currentFilters;
  String get currentKeyword => _currentKeyword;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get errorMessage => _errorMessage;
  bool get hasMoreJobs => _hasMoreJobs;

  Future<void> searchJobs({
    String? keyword,
    JobFilters? filters,
    bool refresh = false,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _hasMoreJobs = true;
      _jobs.clear();
    }

    if (refresh || _currentPage == 1) {
      _setLoading(true);
    } else {
      _setLoadingMore(true);
    }
    
    _clearError();
    
    try {
      _currentKeyword = keyword ?? '';
      _currentFilters = filters ?? JobFilters();
      
      final newJobs = await _jobService.searchJobs(
        keyword: keyword,
        filters: filters,
        page: _currentPage,
        limit: 20,
      );
      
      if (refresh || _currentPage == 1) {
        _jobs = newJobs;
      } else {
        _jobs.addAll(newJobs);
      }
      
      _currentPage++;
      _hasMoreJobs = newJobs.length >= 20;
      
    } catch (e) {
      _setError('Failed to search jobs. Please try again.');
    } finally {
      _setLoading(false);
      _setLoadingMore(false);
    }
  }

  Future<void> loadMoreJobs() async {
    if (!_hasMoreJobs || _isLoadingMore) return;
    
    await searchJobs(
      keyword: _currentKeyword.isNotEmpty ? _currentKeyword : null,
      filters: _currentFilters,
      refresh: false,
    );
  }

  Future<void> getSuggestions(String query) async {
    try {
      _searchSuggestions = await _jobService.getSuggestions(query);
      notifyListeners();
    } catch (e) {
      _searchSuggestions = [];
      notifyListeners();
    }
  }

  void clearSuggestions() {
    _searchSuggestions = [];
    notifyListeners();
  }

  void toggleSaveJob(Job job) {
    final index = _savedJobs.indexWhere((savedJob) => savedJob.id == job.id);
    
    if (index >= 0) {
      _savedJobs.removeAt(index);
    } else {
      _savedJobs.add(job);
    }
    
    notifyListeners();
  }

  bool isJobSaved(String jobId) {
    return _savedJobs.any((job) => job.id == jobId);
  }

  void updateFilters(JobFilters filters) {
    _currentFilters = filters;
    notifyListeners();
  }

  void clearFilters() {
    _currentFilters = JobFilters();
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setLoadingMore(bool loading) {
    _isLoadingMore = loading;
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

