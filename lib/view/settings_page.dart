import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_list/model/global_app_state.dart';
import 'package:go_list/service/golist_languages.dart';
import 'package:go_list/view/about_page.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedLanguageCode = GoListLanguages.defaultLanguage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        selectedLanguageCode =
            Provider.of<GlobalAppState>(context, listen: false).languageCode;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(AppLocalizations.of(context).settings),
      ),
      body: ListView(
        children: [
          PlatformListTile(
            title: Text(AppLocalizations.of(context).language),
            subtitle:
                Text(GoListLanguages.getLanguageName(selectedLanguageCode)),
            leading: const Icon(Icons.language),
            onTap: () {
              showPlatformDialog(
                context: context,
                builder: (_) => PlatformAlertDialog(
                  title: Text(AppLocalizations.of(context).language),
                  content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: GoListLanguages.supportedLanguageCodes
                          .asMap()
                          .entries
                          .map(
                            (entry) => [
                              ListTile(
                                title: Text(GoListLanguages.getLanguageName(
                                    entry.value)),
                                onTap: () {
                                  setState(() {
                                    selectedLanguageCode = entry.value;
                                  });
                                  Provider.of<GlobalAppState>(context,
                                          listen: false)
                                      .setLocale(Locale(selectedLanguageCode));
                                  Navigator.pop(context);
                                },
                              ),
                              // not add a divider after the last element
                              if (entry.key !=
                                  GoListLanguages
                                          .supportedLanguageCodes.length -
                                      1)
                                const Divider()
                            ],
                          )
                          .toList()
                          // makes it flat
                          .expand<Widget>((e) => e)
                          .toList()),
                ),
              );
            },
          ),
          const Divider(),
          PlatformListTile(
              title: Text(AppLocalizations.of(context).about),
              leading: const Icon(Icons.info_outline_rounded),
              onTap: () => Navigator.push(
                  context,
                  platformPageRoute(
                      context: context,
                      builder: (context) => const AboutPage()))),
        ],
      ),
    );
  }
}
