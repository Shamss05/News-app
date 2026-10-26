import 'package:assignment_7/l10n/app_localizations.dart';
import 'package:assignment_7/ui/home/widgets/article_card.dart';
import 'package:flutter/material.dart';
import 'search_view_model.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = 'search_screen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _viewModel = SearchViewModel();
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadNearBottom);
  }

  void _loadNearBottom() {
    if (_scrollController.hasClients &&
        _scrollController.position.extentAfter < 300 &&
        _viewModel.error == null) {
      _viewModel.loadMore();
    }
  }

  void _search(String value, {bool immediate = false}) {
    if (_scrollController.hasClients) _scrollController.jumpTo(0);
    _viewModel.changeQuery(value, immediate: immediate);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.search)),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                controller: _textController,
                autofocus: true,
                maxLength: 500,
                textInputAction: TextInputAction.search,
                onChanged: _search,
                onSubmitted: (value) {
                  _search(value, immediate: true);
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.search,
                  counterText: '',
                  prefixIcon:  Icon(Icons.search),
                  suffixIcon: IconButton(
                    tooltip: AppLocalizations.of(context)!.clearSearch,
                    icon:  Icon(Icons.close),
                    onPressed: () {
                      _textController.clear();
                      _search('');
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: _viewModel,
                builder: (context, _) => _buildResults(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (_viewModel.query.isEmpty) {return Center(child: Text(AppLocalizations.of(context)!.searchPrompt));}
    if (_viewModel.articles.isEmpty) {
      if (_viewModel.error != null) return _error();
      if (_viewModel.isLoading || _viewModel.hasMore) {return  Center(child: CircularProgressIndicator());}
      return Center(child: Text(AppLocalizations.of(context)!.noResults));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadNearBottom();
    });
    return ListView.separated(
      controller: _scrollController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.all(16),
      itemCount: _viewModel.articles.length + 1,
      separatorBuilder: (_, _) =>  SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index < _viewModel.articles.length) {return ArticleCard(article: _viewModel.articles[index]);}
        if (_viewModel.error != null) return _error();
        if (_viewModel.isLoading) {
          return  Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return Center(
          child: Text(
            _viewModel.hasMore ? '' : AppLocalizations.of(context)!.noMore,
          ),
        );
      },
    );
  }

  Widget _error() => Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppLocalizations.of(context)!.loadError,
          textAlign: TextAlign.center,
        ),
        TextButton(
          onPressed: _viewModel.loadMore,
          child: Text(AppLocalizations.of(context)!.retry),
        ),
      ],
    ),
  );
}
