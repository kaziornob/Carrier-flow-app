import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/learning.dart';

class LearningService {
  static const String _baseUrl = 'https://api.careerflow.com'; // Placeholder URL

  // Singleton pattern
  static final LearningService _instance = LearningService._internal();
  factory LearningService() => _instance;
  LearningService._internal();

  Future<List<Article>> getArticles({String? category}) async {
    try {
      // For demo purposes, we'll return mock data
      // In a real app, this would make an HTTP request to your backend
      
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 600));
      
      return _generateMockArticles(category: category);
    } catch (e) {
      print('Get articles error: $e');
      throw Exception('Failed to load articles');
    }
  }

  Future<List<LearningResource>> getLearningResources({
    String? skill,
    String? category,
  }) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      return _generateMockLearningResources(skill: skill, category: category);
    } catch (e) {
      print('Get learning resources error: $e');
      throw Exception('Failed to load learning resources');
    }
  }

  Future<List<String>> getRecommendedSkills(List<String> userSkills) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 400));
      
      final allSkills = [
        'Flutter',
        'Dart',
        'React Native',
        'Swift',
        'Kotlin',
        'JavaScript',
        'TypeScript',
        'Python',
        'Java',
        'C#',
        'Node.js',
        'React',
        'Vue.js',
        'Angular',
        'Firebase',
        'AWS',
        'Docker',
        'Kubernetes',
        'Git',
        'REST APIs',
        'GraphQL',
        'MongoDB',
        'PostgreSQL',
        'MySQL',
        'Redis',
        'UI/UX Design',
        'Figma',
        'Adobe XD',
        'Sketch',
        'Product Management',
        'Agile',
        'Scrum',
        'DevOps',
        'CI/CD',
        'Testing',
        'Machine Learning',
        'Data Science',
        'Blockchain',
      ];
      
      // Return skills not already in user's skill list
      return allSkills
          .where((skill) => !userSkills.contains(skill))
          .take(10)
          .toList();
    } catch (e) {
      print('Get recommended skills error: $e');
      return [];
    }
  }

  Future<Article?> getArticleById(String articleId) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      return _generateMockArticles().firstWhere(
        (article) => article.id == articleId,
        orElse: () => throw Exception('Article not found'),
      );
    } catch (e) {
      print('Get article error: $e');
      return null;
    }
  }

  List<Article> _generateMockArticles({String? category}) {
    final mockArticles = [
      Article(
        id: 'article_1',
        title: 'How to Ace Your Next Technical Interview',
        content: '''
Technical interviews can be challenging, but with the right preparation, you can succeed. Here are some key strategies:

## Preparation is Key
- Review fundamental concepts in your field
- Practice coding problems on platforms like LeetCode
- Understand system design principles
- Prepare questions to ask your interviewer

## During the Interview
- Think out loud and explain your reasoning
- Ask clarifying questions
- Start with a simple solution, then optimize
- Test your code with examples

## Common Mistakes to Avoid
- Not asking questions when unclear
- Jumping into coding without planning
- Getting stuck on one approach
- Not testing your solution

Remember, the interviewer wants to see your problem-solving process, not just the final answer.
        ''',
        summary: 'Essential tips and strategies for succeeding in technical interviews, from preparation to execution.',
        category: 'Interview Tips',
        publishedDate: DateTime.now().subtract(const Duration(days: 2)),
        imageUrl: 'https://example.com/interview-tips.jpg',
        author: 'Sarah Johnson',
        tags: ['interview', 'technical', 'career', 'preparation'],
      ),
      Article(
        id: 'article_2',
        title: 'Building a Strong Developer Portfolio',
        content: '''
Your portfolio is often the first impression you make on potential employers. Here's how to make it count:

## Essential Elements
- Clear, professional design
- Showcase your best work
- Include diverse project types
- Provide live demos and source code

## Project Selection
- Choose projects that demonstrate different skills
- Include both personal and professional work
- Show progression and growth over time
- Highlight problem-solving abilities

## Technical Considerations
- Ensure fast loading times
- Make it mobile-responsive
- Use clean, readable code
- Include proper documentation

## Content Tips
- Write clear project descriptions
- Explain your role and contributions
- Highlight technologies used
- Include challenges faced and solutions

A well-crafted portfolio can set you apart from other candidates and showcase your skills effectively.
        ''',
        summary: 'Learn how to create a compelling developer portfolio that showcases your skills and attracts employers.',
        category: 'Career Development',
        publishedDate: DateTime.now().subtract(const Duration(days: 5)),
        imageUrl: 'https://example.com/portfolio-tips.jpg',
        author: 'Mike Chen',
        tags: ['portfolio', 'career', 'development', 'showcase'],
      ),
      Article(
        id: 'article_3',
        title: 'Remote Work Best Practices for Developers',
        content: '''
Remote work has become the norm for many developers. Here are best practices to stay productive and connected:

## Setting Up Your Workspace
- Create a dedicated work area
- Invest in good equipment
- Ensure reliable internet connection
- Minimize distractions

## Communication Strategies
- Over-communicate rather than under-communicate
- Use video calls for important discussions
- Be responsive to messages
- Set clear expectations with your team

## Time Management
- Establish a routine
- Take regular breaks
- Use time-blocking techniques
- Set boundaries between work and personal time

## Staying Connected
- Participate in virtual team activities
- Schedule regular one-on-ones
- Join online developer communities
- Attend virtual conferences and meetups

Remote work requires discipline and good communication skills, but it can lead to increased productivity and better work-life balance.
        ''',
        summary: 'Essential strategies for thriving as a remote developer, covering workspace setup, communication, and productivity.',
        category: 'Remote Work',
        publishedDate: DateTime.now().subtract(const Duration(days: 7)),
        imageUrl: 'https://example.com/remote-work.jpg',
        author: 'Emily Rodriguez',
        tags: ['remote work', 'productivity', 'communication', 'work-life balance'],
      ),
      Article(
        id: 'article_4',
        title: 'Negotiating Your Developer Salary',
        content: '''
Salary negotiation is a crucial skill that can significantly impact your career earnings. Here's how to approach it:

## Research and Preparation
- Know your market value
- Research company salary ranges
- Document your achievements
- Prepare your negotiation points

## Timing Matters
- Wait for the right moment
- Don't negotiate too early in the process
- Consider the company's financial situation
- Be patient and strategic

## Negotiation Strategies
- Focus on value, not just salary
- Consider the total compensation package
- Be prepared to walk away
- Maintain professionalism throughout

## Beyond Base Salary
- Stock options or equity
- Flexible working arrangements
- Professional development budget
- Additional vacation time
- Health and wellness benefits

Remember, negotiation is a normal part of the hiring process, and most employers expect it.
        ''',
        summary: 'A comprehensive guide to negotiating your developer salary, including research, timing, and strategies.',
        category: 'Career Development',
        publishedDate: DateTime.now().subtract(const Duration(days: 10)),
        imageUrl: 'https://example.com/salary-negotiation.jpg',
        author: 'David Kim',
        tags: ['salary', 'negotiation', 'career', 'compensation'],
      ),
      Article(
        id: 'article_5',
        title: 'Staying Updated with Technology Trends',
        content: '''
The tech industry evolves rapidly. Here's how to stay current with the latest trends and technologies:

## Information Sources
- Follow industry blogs and publications
- Subscribe to developer newsletters
- Listen to tech podcasts
- Watch conference talks and tutorials

## Hands-on Learning
- Build side projects with new technologies
- Contribute to open source projects
- Take online courses
- Attend workshops and bootcamps

## Community Engagement
- Join developer communities
- Attend local meetups
- Participate in hackathons
- Follow thought leaders on social media

## Continuous Learning Mindset
- Set aside time for learning
- Focus on fundamentals, not just trends
- Learn from failures and mistakes
- Share your knowledge with others

Staying updated requires consistent effort, but it's essential for career growth in the fast-paced tech industry.
        ''',
        summary: 'Strategies for keeping up with rapidly evolving technology trends and maintaining relevant skills.',
        category: 'Learning',
        publishedDate: DateTime.now().subtract(const Duration(days: 12)),
        imageUrl: 'https://example.com/tech-trends.jpg',
        author: 'Lisa Wang',
        tags: ['learning', 'technology', 'trends', 'professional development'],
      ),
    ];

    if (category != null) {
      return mockArticles.where((article) => article.category == category).toList();
    }

    return mockArticles;
  }

  List<LearningResource> _generateMockLearningResources({
    String? skill,
    String? category,
  }) {
    final mockResources = [
      LearningResource(
        id: 'resource_1',
        title: 'Flutter Complete Course',
        description: 'Learn Flutter from scratch and build beautiful mobile apps for iOS and Android.',
        url: 'https://www.udemy.com/course/flutter-complete-course',
        platform: 'Udemy',
        category: 'Mobile Development',
        skills: ['Flutter', 'Dart', 'Mobile Development'],
        rating: 4.8,
        isFree: false,
      ),
      LearningResource(
        id: 'resource_2',
        title: 'JavaScript Fundamentals',
        description: 'Master the fundamentals of JavaScript programming language.',
        url: 'https://www.freecodecamp.org/learn/javascript-algorithms-and-data-structures/',
        platform: 'freeCodeCamp',
        category: 'Web Development',
        skills: ['JavaScript', 'Programming Fundamentals'],
        rating: 4.9,
        isFree: true,
      ),
      LearningResource(
        id: 'resource_3',
        title: 'React Native Development',
        description: 'Build cross-platform mobile apps using React Native framework.',
        url: 'https://www.coursera.org/learn/react-native',
        platform: 'Coursera',
        category: 'Mobile Development',
        skills: ['React Native', 'JavaScript', 'Mobile Development'],
        rating: 4.6,
        isFree: false,
      ),
      LearningResource(
        id: 'resource_4',
        title: 'System Design Interview Prep',
        description: 'Prepare for system design interviews with real-world examples and case studies.',
        url: 'https://www.educative.io/courses/grokking-the-system-design-interview',
        platform: 'Educative',
        category: 'Interview Preparation',
        skills: ['System Design', 'Architecture', 'Scalability'],
        rating: 4.7,
        isFree: false,
      ),
      LearningResource(
        id: 'resource_5',
        title: 'Git and GitHub Mastery',
        description: 'Learn version control with Git and collaborate effectively using GitHub.',
        url: 'https://www.youtube.com/watch?v=RGOj5yH7evk',
        platform: 'YouTube',
        category: 'Development Tools',
        skills: ['Git', 'GitHub', 'Version Control'],
        rating: 4.5,
        isFree: true,
      ),
      LearningResource(
        id: 'resource_6',
        title: 'AWS Cloud Practitioner',
        description: 'Get started with Amazon Web Services and cloud computing fundamentals.',
        url: 'https://aws.amazon.com/training/digital/aws-cloud-practitioner-essentials/',
        platform: 'AWS Training',
        category: 'Cloud Computing',
        skills: ['AWS', 'Cloud Computing', 'DevOps'],
        rating: 4.4,
        isFree: true,
      ),
      LearningResource(
        id: 'resource_7',
        title: 'UI/UX Design Principles',
        description: 'Learn the fundamentals of user interface and user experience design.',
        url: 'https://www.interaction-design.org/courses/user-experience-the-beginner-s-guide',
        platform: 'Interaction Design Foundation',
        category: 'Design',
        skills: ['UI Design', 'UX Design', 'Design Thinking'],
        rating: 4.6,
        isFree: false,
      ),
      LearningResource(
        id: 'resource_8',
        title: 'Python for Beginners',
        description: 'Start your programming journey with Python, one of the most popular languages.',
        url: 'https://www.python.org/about/gettingstarted/',
        platform: 'Python.org',
        category: 'Programming Languages',
        skills: ['Python', 'Programming Fundamentals'],
        rating: 4.8,
        isFree: true,
      ),
    ];

    var filteredResources = mockResources;

    if (skill != null) {
      filteredResources = filteredResources
          .where((resource) => resource.skills.any(
              (resourceSkill) => resourceSkill.toLowerCase().contains(skill.toLowerCase())))
          .toList();
    }

    if (category != null) {
      filteredResources = filteredResources
          .where((resource) => resource.category == category)
          .toList();
    }

    return filteredResources;
  }
}

