import 'package:assignment_7/l10n/app_localizations.dart';
import 'package:assignment_7/ui/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:assignment_7/core/base/base_state.dart';
import 'package:assignment_7/core/providers/app_config_provider.dart';
import 'package:assignment_7/core/utils/context_extention.dart';
import 'package:assignment_7/core/utils/numbers_extension.dart';
import 'package:assignment_7/core/utils/widget_extension.dart';
import 'package:assignment_7/ui/home/home_navigator.dart';
import 'package:assignment_7/ui/home/home_view_model.dart';
import 'package:assignment_7/ui/home/tabs/home_tab.dart';
import 'package:assignment_7/ui/home/tabs/news/news_tab.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home_screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeScreen, HomeViewModel>
    implements HomeNavigator {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<HomeViewModel>(
        builder: (_, _, _) => Scaffold(
          appBar: AppBar(
            title: Text(
              viewModel.selectedCategory == null ? AppLocalizations.of(context)!.home : viewModel.selectedCategory!.localizedName(context),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                tooltip: AppLocalizations.of(context)!.search,
                onPressed: () => Navigator.pushNamed(context, SearchScreen.routeName),
                icon:  Icon(Icons.search),
              ),
            ],
          ),
          drawer: _drawer(provider),
          body: viewModel.selectedCategory == null ? HomeTab(onClick: viewModel.changeCategory) : NewsTab(category: viewModel.selectedCategory!),
        ),
      ),
    );
  }

  Widget _drawer(AppConfigProvider provider) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Container(
              width: double.infinity,
              height: 240,
              alignment: .center,
              decoration: BoxDecoration(color: context.colors.primary),
              child: Text(
                AppLocalizations.of(context)!.appName,
                style: context.text.titleLarge!.copyWith(
                  color: context.colors.surface,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                viewModel.goToHome();
              },
              child: Row(
                children: [
                  Icon(Icons.home, size: 32), 16.horizontalSpace,
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.goHome,
                      style: context.text.titleLarge!,
                    ),
                  ),
                ],
              ).allPadding(16),
            ),
            Divider(),
            Row(
              children: [
                 Icon(Icons.format_paint_outlined, size: 24), 8.horizontalSpace,
                Text(
                  AppLocalizations.of(context)!.theme,
                  style: context.text.titleLarge,
                ),
              ],
            ).symmetricPadding(8, 16),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: context.colors.primary),
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButton<ThemeMode>(
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text(AppLocalizations.of(context)!.light),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text(AppLocalizations.of(context)!.dark),
                  ),
                ],
                isExpanded: true,
                borderRadius: BorderRadius.circular(16),
                underline: SizedBox(),
                value: provider.themeMode,
                onChanged: (mode) {
                  provider.changeTheme(mode!);
                },
              ),
            ),
             Divider(),
            Row(
              children: [
                 Icon(Icons.language, size: 24), 8.horizontalSpace,
                Text(
                  AppLocalizations.of(context)!.language,
                  style: context.text.titleLarge,
                ),
              ],
            ).symmetricPadding(8, 16),
            Container(
              margin:  EdgeInsets.symmetric(horizontal: 16),
              padding:  EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: context.colors.primary),
                borderRadius: BorderRadius.circular(16),
              ),
              child: DropdownButton<String>(
                value: provider.locale.languageCode,
                isExpanded: true,
                borderRadius: BorderRadius.circular(16),
                underline:  SizedBox(),
                items: [
                  DropdownMenuItem(
                    value: 'en',
                    child: Text(AppLocalizations.of(context)!.english),
                  ),
                  DropdownMenuItem(
                    value: 'ar',
                    child: Text(AppLocalizations.of(context)!.arabic),
                  ),
                ],
                onChanged: (language) {
                  if (language != null) provider.changeLanguage(language);
                },
              ),
            ),
            16.verticalSpace,
          ],
        ),
      ),
    );
  }

  @override
  void pop() {
    Navigator.pop(context);
  }

  @override
  HomeViewModel createViewModel() {
    return HomeViewModel();
  }
}
