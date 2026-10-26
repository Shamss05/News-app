// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get home => 'الرئيسية';

  @override
  String get appName => 'تطبيق الأخبار';

  @override
  String get goHome => 'العودة للرئيسية';

  @override
  String get theme => 'المظهر';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get search => 'بحث';

  @override
  String get clearSearch => 'مسح البحث';

  @override
  String get greeting => 'صباح الخير\nإليك بعض الأخبار';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get general => 'عام';

  @override
  String get business => 'أعمال';

  @override
  String get sports => 'رياضة';

  @override
  String get technology => 'تكنولوجيا';

  @override
  String get entertainment => 'ترفيه';

  @override
  String get health => 'صحة';

  @override
  String get science => 'علوم';

  @override
  String get searchPrompt => 'ابحث عن الأخبار.';

  @override
  String get noResults => 'لا توجد أخبار. جرّب كلمة بحث أخرى.';

  @override
  String get noMore => 'لا توجد أخبار أخرى.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get noSources => 'لا توجد مصادر أخبار متاحة.';

  @override
  String get loadError => 'تعذّر تحميل الأخبار. تحقق من اتصالك وحاول مجددًا.';

  @override
  String get invalidLink => 'لا يوجد رابط صالح لهذا الخبر.';

  @override
  String get openError => 'تعذّر فتح الخبر. حاول مجددًا.';

  @override
  String get readMore => 'اقرأ الخبر كاملًا لمزيد من التفاصيل.';

  @override
  String get opening => 'جارٍ الفتح...';

  @override
  String get fullArticle => 'عرض الخبر كاملًا';

  @override
  String byAuthor(String author) {
    return 'بواسطة: $author';
  }
}
