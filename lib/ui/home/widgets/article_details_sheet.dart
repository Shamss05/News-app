import 'package:assignment_7/l10n/app_localizations.dart';
import 'package:assignment_7/models/articles_response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailsSheet extends StatefulWidget {
  final Article article;

  const ArticleDetailsSheet({required this.article, super.key});

  static Future<void> show(BuildContext context, Article article) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ArticleDetailsSheet(article: article),
    );
  }

  @override
  State<ArticleDetailsSheet> createState() => _ArticleDetailsSheetState();
}

class _ArticleDetailsSheetState extends State<ArticleDetailsSheet> {
  bool _opening = false;

  Future<void> _openArticle() async {
    if (_opening) return;
    final uri = Uri.tryParse(widget.article.url?.trim() ?? '');
    if (uri == null ||
        (uri.scheme != 'https' && uri.scheme != 'http') ||
        uri.host.isEmpty) {
      _showError(AppLocalizations.of(context)!.invalidLink);
      return;
    }
    setState(() => _opening = true);
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened && mounted) {
        _showError(AppLocalizations.of(context)!.openError);
      }
    } catch (_) {
      if (mounted) _showError(AppLocalizations.of(context)!.openError);
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final article = widget.article;
    final description = article.description?.trim() ?? '';
    final content = article.content?.trim() ?? '';
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * .85,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding:  EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: article.urlToImage ?? '',
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (_, _) => _placeholder(),
                          errorWidget: (_, _, _) => _placeholder(),
                        ),
                      ),
                       SizedBox(height: 12),
                      if (article.title?.trim().isNotEmpty == true) ...[
                        Text(article.title!, style: TextStyle(color: colors.onPrimary, fontSize: 18, fontWeight: FontWeight.bold,),),
                         SizedBox(height: 8),
                      ],
                      Text(
                        [
                          if (description.isNotEmpty) description,
                          if (content.isNotEmpty && content != description)
                            content,
                          if (description.isEmpty && content.isEmpty)
                            AppLocalizations.of(context)!.readMore,
                        ].join('\n\n'),
                        style: TextStyle(
                          color: colors.onPrimary,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                       SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: colors.onPrimary,
                  foregroundColor: colors.primary,
                  disabledBackgroundColor: colors.onPrimary.withValues(
                    alpha: 0.6,
                  ),
                  disabledForegroundColor: colors.primary,
                  minimumSize:  Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _opening ? null : _openArticle,
                child: Text(_opening ? AppLocalizations.of(context)!.opening : AppLocalizations.of(context)!.fullArticle,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
    height: 220,
    color:  Color(0xFFF0F0F0),
    child:  Icon(
      Icons.image_not_supported_outlined,
      color: Colors.grey,
      size: 48,
    ),
  );
}
