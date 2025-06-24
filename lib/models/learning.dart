class Article {
  final String id;
  final String title;
  final String content;
  final String summary;
  final String category;
  final DateTime publishedDate;
  final String? imageUrl;
  final String? author;
  final List<String> tags;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.summary,
    required this.category,
    required this.publishedDate,
    this.imageUrl,
    this.author,
    this.tags = const [],
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      summary: json['summary'],
      category: json['category'],
      publishedDate: DateTime.parse(json['publishedDate']),
      imageUrl: json['imageUrl'],
      author: json['author'],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'summary': summary,
      'category': category,
      'publishedDate': publishedDate.toIso8601String(),
      'imageUrl': imageUrl,
      'author': author,
      'tags': tags,
    };
  }
}

class LearningResource {
  final String id;
  final String title;
  final String description;
  final String url;
  final String platform;
  final String category;
  final List<String> skills;
  final double? rating;
  final bool isFree;

  LearningResource({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.platform,
    required this.category,
    required this.skills,
    this.rating,
    this.isFree = false,
  });

  factory LearningResource.fromJson(Map<String, dynamic> json) {
    return LearningResource(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      platform: json['platform'],
      category: json['category'],
      skills: List<String>.from(json['skills'] ?? []),
      rating: json['rating']?.toDouble(),
      isFree: json['isFree'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': url,
      'platform': platform,
      'category': category,
      'skills': skills,
      'rating': rating,
      'isFree': isFree,
    };
  }
}

