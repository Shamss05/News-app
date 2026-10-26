import 'package:assignment_7/l10n/app_localizations.dart';
import 'article_details_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:assignment_7/core/providers/app_config_provider.dart';
import 'package:assignment_7/core/utils/context_extention.dart';
import 'package:assignment_7/core/utils/widget_extension.dart';
import 'package:assignment_7/models/articles_response.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({required this.article, super.key});

  @override
  Widget build(BuildContext context) {
    final publishedAt = DateTime.tryParse(article.publishedAt ?? '');
    var provider = Provider.of<AppConfigProvider>(context);
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => ArticleDetailsSheet.show(context, article),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(width: 1, color: context.colors.primary),
        ),
        child: Column(
          mainAxisAlignment: .start,
          spacing: 16,
          children: [
            CachedNetworkImage(
              imageUrl: article.urlToImage ?? "",
              placeholder: (_, _) => Image.asset("assets/images/${provider.isDarkMode ? "dark" : "light"}/news_logo.png",),
              errorWidget: (_, _, _) => Image.asset("assets/images/${provider.isDarkMode ? "dark" : "light"}/news_logo.png",),
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              imageBuilder: (_, imageProvider) => Image(image: imageProvider, fit: .cover).clip(16),
            ),
            Text(article.title ?? "", style: context.text.labelLarge),
            Row(
              children: [
                Expanded(
                  child: Text(
                    article.author != null ? AppLocalizations.of(context,)!.byAuthor(article.author!) : "",
                    style: context.text.labelSmall,
                  ),
                ),
                Text(
                  publishedAt != null ? timeago.format(
                          publishedAt,
                          locale: Localizations.localeOf(context).languageCode,
                        ) : "", style: context.text.labelSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
