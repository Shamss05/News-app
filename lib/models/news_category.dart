import 'package:assignment_7/l10n/app_localizations.dart';
import 'package:flutter/widgets.dart';

class NewsCategory {
  String localizedName(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return switch (categoryId) {
      'general' => l.general,
      'business' => l.business,
      'sports' => l.sports,
      'technology' => l.technology,
      'entertainment' => l.entertainment,
      'health' => l.health,
      'science' => l.science,
      _ => categoryName,
    };
  }

  final String categoryName;
  final String categoryImage;
  final String categoryId;

  const NewsCategory({
    required this.categoryName,
    required this.categoryImage,
    required this.categoryId,
  });

  static List<NewsCategory> getCategories({bool isDark = false}) {
    final themeFolder = isDark ? 'dark' : 'light';

    return [
      NewsCategory(
        categoryId: 'general',
        categoryName: 'General',
        categoryImage: 'assets/images/$themeFolder/general.png',
      ),
      NewsCategory(
        categoryId: 'business',
        categoryName: 'Business',
        categoryImage:
            'assets/images/$themeFolder/busniess.png',
      ),
      NewsCategory(
        categoryId: 'sports',
        categoryName: 'Sports',
        categoryImage:
            'assets/images/$themeFolder/sport.png',
      ),
      NewsCategory(
        categoryId: 'technology',
        categoryName: 'Technology',
        categoryImage: 'assets/images/$themeFolder/technology.png',
      ),
      NewsCategory(
        categoryId: 'entertainment',
        categoryName: 'Entertainment',
        categoryImage: 'assets/images/$themeFolder/entertainment.png',
      ),

      NewsCategory(
        categoryId: 'health',
        categoryName: 'Health',
        categoryImage:
            'assets/images/$themeFolder/helth.png',
      ),
      NewsCategory(
        categoryId: 'science',
        categoryName: 'Science',
        categoryImage: 'assets/images/$themeFolder/science.png',
      ),
    ];
  }
}
