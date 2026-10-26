import 'package:assignment_7/l10n/app_localizations.dart';
import '../../../../core/utils/context_extention.dart';
import '../../../../core/utils/numbers_extension.dart';
import '../../../../core/utils/widget_extension.dart';
import '../../widgets/article_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/base/base_state.dart';
import '../../../../models/news_category.dart';
import 'news_view_mdoel.dart';

class NewsTab extends StatefulWidget {
  final NewsCategory category;
  const NewsTab({required this.category, super.key});

  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends BaseState<NewsTab, NewsViewModel> {
  @override
  void initState() {
    super.initState();
    viewModel.getSources();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<NewsViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.sourcesLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (viewModel.sourcesError != null) {
            return Center(child: Text(AppLocalizations.of(context)!.loadError));
          } else if (viewModel.sources.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.noSources));
          } else {
            return Column(
              children: [
                DefaultTabController(
                  length: viewModel.sources.length,
                  child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    dividerHeight: 0,
                    onTap: viewModel.changeSelectedIndex,
                    tabs: viewModel.sources
                        .map((e) => Text(
                            e.name ?? "", style: context.text.labelLarge,
                          ).allPadding(16),
                        ).toList(),
                  ),
                ), 16.verticalSpace,
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, _) {
                      if (viewModel.articlesLoading) {
                        return Center(child: CircularProgressIndicator());
                      } else if (viewModel.articlesError != null) {
                        return Center(
                          child: Text(AppLocalizations.of(context)!.loadError),
                        );
                      } else {
                        return ListView.separated(
                          padding: EdgeInsets.all(16),
                          separatorBuilder: (_, _) => 16.verticalSpace,
                          itemCount: viewModel.articles.length,
                          itemBuilder: (context, index) =>
                              ArticleCard(article: viewModel.articles[index]),
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  @override
  NewsViewModel createViewModel() {
    return NewsViewModel(widget.category);
  }
}
