import 'package:assignment_7/core/base/base_view_model.dart';
import 'package:assignment_7/models/news_category.dart';
import 'package:assignment_7/ui/home/home_navigator.dart';

class HomeViewModel extends BaseViewModel<HomeNavigator> {
  NewsCategory? selectedCategory;

  void changeCategory(NewsCategory category) {
    selectedCategory = category;
    notifyListeners();
  }

  void goToHome() {
    selectedCategory = null;
    notifyListeners();
    navigator?.pop();
  }
}
