// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';

  @override
  String get appName => 'News App';

  @override
  String get goHome => 'Go to Home';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get search => 'Search';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get greeting => 'Good Morning\nHere is Some News For You';

  @override
  String get viewAll => 'View All';

  @override
  String get general => 'General';

  @override
  String get business => 'Business';

  @override
  String get sports => 'Sports';

  @override
  String get technology => 'Technology';

  @override
  String get entertainment => 'Entertainment';

  @override
  String get health => 'Health';

  @override
  String get science => 'Science';

  @override
  String get searchPrompt => 'Search for news articles.';

  @override
  String get noResults => 'No articles found. Try another keyword.';

  @override
  String get noMore => 'No more articles.';

  @override
  String get retry => 'Retry';

  @override
  String get noSources => 'No news sources available.';

  @override
  String get loadError =>
      'Unable to load news. Check your connection and try again.';

  @override
  String get invalidLink => 'This article has no valid link.';

  @override
  String get openError => 'Could not open the article. Please try again.';

  @override
  String get readMore => 'Read the full article for more details.';

  @override
  String get opening => 'Opening...';

  @override
  String get fullArticle => 'View Full Article';

  @override
  String byAuthor(String author) {
    return 'By: $author';
  }
}
