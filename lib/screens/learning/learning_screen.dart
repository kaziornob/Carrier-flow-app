import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/learning_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/article_card.dart';
import '../../widgets/learning_resource_card.dart';
import '../../widgets/skill_recommendation_card.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final learningProvider = Provider.of<LearningProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      learningProvider.loadArticles();
      learningProvider.loadLearningResources();
      
      if (authProvider.currentUser != null) {
        learningProvider.loadRecommendedSkills(authProvider.currentUser!.skills);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learning & Development'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: 'Skills'),
            Tab(text: 'Articles'),
            Tab(text: 'Courses'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSkillsTab(),
          _buildArticlesTab(),
          _buildCoursesTab(),
        ],
      ),
    );
  }

  Widget _buildSkillsTab() {
    return Consumer2<LearningProvider, AuthProvider>(
      builder: (context, learningProvider, authProvider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Skills
              if (authProvider.currentUser?.skills.isNotEmpty == true) ...[
                const Text(
                  'Your Skills',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: authProvider.currentUser!.skills.map((skill) {
                    return Chip(
                      label: Text(skill),
                      backgroundColor: Colors.blue.shade50,
                      labelStyle: TextStyle(color: Colors.blue.shade700),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
              ],
              
              // Recommended Skills
              const Text(
                'Recommended Skills',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Based on your profile and industry trends',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),
              
              if (learningProvider.isLoadingSkills)
                const Center(child: CircularProgressIndicator())
              else if (learningProvider.recommendedSkills.isEmpty)
                const Center(
                  child: Text(
                    'No skill recommendations available',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                ...learningProvider.recommendedSkills.map((skill) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SkillRecommendationCard(
                      skill: skill,
                      onLearnMore: () {
                        learningProvider.loadLearningResources(skill: skill);
                        _tabController.animateTo(2); // Switch to courses tab
                      },
                    ),
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildArticlesTab() {
    return Consumer<LearningProvider>(
      builder: (context, learningProvider, child) {
        if (learningProvider.isLoadingArticles) {
          return const Center(child: CircularProgressIndicator());
        }

        if (learningProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  learningProvider.errorMessage!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    learningProvider.loadArticles();
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        if (learningProvider.articles.isEmpty) {
          return const Center(
            child: Text(
              'No articles available',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => learningProvider.loadArticles(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: learningProvider.articles.length,
            itemBuilder: (context, index) {
              final article = learningProvider.articles[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ArticleCard(
                  article: article,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/article-detail',
                      arguments: article,
                    );
                  },
                  onSave: () {
                    learningProvider.toggleSaveArticle(article);
                  },
                  isSaved: learningProvider.isArticleSaved(article.id),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCoursesTab() {
    return Consumer<LearningProvider>(
      builder: (context, learningProvider, child) {
        if (learningProvider.isLoadingResources) {
          return const Center(child: CircularProgressIndicator());
        }

        if (learningProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  learningProvider.errorMessage!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    learningProvider.loadLearningResources();
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        if (learningProvider.learningResources.isEmpty) {
          return const Center(
            child: Text(
              'No learning resources available',
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => learningProvider.loadLearningResources(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter Chips
                SizedBox(
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: const Text('All'),
                          selected: true,
                          onSelected: (selected) {
                            learningProvider.loadLearningResources();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: const Text('Free'),
                          selected: false,
                          onSelected: (selected) {
                            // Filter free resources
                          },
                        ),
                      ),
                      ...learningProvider.resourceCategories.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: false,
                            onSelected: (selected) {
                              learningProvider.loadLearningResources(category: category);
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Learning Resources
                ...learningProvider.learningResources.map((resource) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: LearningResourceCard(
                      resource: resource,
                      onTap: () {
                        // Open resource URL
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

