import 'package:flutter/foundation.dart';
import '../models/learning.dart';
import '../services/learning_service.dart';

class LearningProvider with ChangeNotifier {
  final LearningService _learningService = LearningService();
  
  List<Article> _articles = [];
  List<LearningResource> _learningResources = [];
  List<String> _recommendedSkills = [];
  List<Article> _savedArticles = [];
  
  bool _isLoadingArticles = false;
  bool _isLoadingResources = false;
  bool _isLoadingSkills = false;
  String? _errorMessage;

  List<Article> get articles => _articles;
  List<LearningResource> get learningResources => _learningResources;
  List<String> get recommendedSkills => _recommendedSkills;
  List<Article> get savedArticles => _savedArticles;
  
  bool get isLoadingArticles => _isLoadingArticles;
  bool get isLoadingResources => _isLoadingResources;
  bool get isLoadingSkills => _isLoadingSkills;
  String? get errorMessage => _errorMessage;

  // Get unique categories from articles
  List<String> get articleCategories {
    final categories = _articles.map((article) => article.category).toSet().toList();
    categories.sort();
    return categories;
  }

  // Get unique categories from learning resources
  List<String> get resourceCategories {
    final categories = _learningResources.map((resource) => resource.category).toSet().toList();
    categories.sort();
    return categories;
  }

  Future<void> loadArticles({String? category}) async {
    _setLoadingArticles(true);
    _clearError();
    
    try {
      _articles = await _learningService.getArticles(category: category);
    } catch (e) {
      _setError('Failed to load articles. Please try again.');
    } finally {
      _setLoadingArticles(false);
    }
  }

  Future<void> loadLearningResources({String? skill, String? category}) async {
    _setLoadingResources(true);
    _clearError();
    
    try {
      _learningResources = await _learningService.getLearningResources(
        skill: skill,
        category: category,
      );
    } catch (e) {
      _setError('Failed to load learning resources. Please try again.');
    } finally {
      _setLoadingResources(false);
    }
  }

  Future<void> loadRecommendedSkills(List<String> userSkills) async {
    _setLoadingSkills(true);
    _clearError();
    
    try {
      _recommendedSkills = await _learningService.getRecommendedSkills(userSkills);
    } catch (e) {
      _setError('Failed to load recommended skills. Please try again.');
    } finally {
      _setLoadingSkills(false);
    }
  }

  void toggleSaveArticle(Article article) {
    final index = _savedArticles.indexWhere((savedArticle) => savedArticle.id == article.id);
    
    if (index >= 0) {
      _savedArticles.removeAt(index);
    } else {
      _savedArticles.add(article);
    }
    
    notifyListeners();
  }

  bool isArticleSaved(String articleId) {
    return _savedArticles.any((article) => article.id == articleId);
  }

  List<Article> getArticlesByCategory(String category) {
    return _articles.where((article) => article.category == category).toList();
  }

  List<LearningResource> getResourcesByCategory(String category) {
    return _learningResources.where((resource) => resource.category == category).toList();
  }

  List<LearningResource> getResourcesBySkill(String skill) {
    return _learningResources.where((resource) => 
        resource.skills.any((resourceSkill) => 
            resourceSkill.toLowerCase().contains(skill.toLowerCase()))).toList();
  }

  List<LearningResource> getFreeResources() {
    return _learningResources.where((resource) => resource.isFree).toList();
  }

  List<LearningResource> getTopRatedResources() {
    final sortedResources = List<LearningResource>.from(_learningResources);
    sortedResources.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
    return sortedResources.take(10).toList();
  }

  void _setLoadingArticles(bool loading) {
    _isLoadingArticles = loading;
    notifyListeners();
  }

  void _setLoadingResources(bool loading) {
    _isLoadingResources = loading;
    notifyListeners();
  }

  void _setLoadingSkills(bool loading) {
    _isLoadingSkills = loading;
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

