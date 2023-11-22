import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_list/model/global_app_state.dart';
import 'package:go_list/service/golist_languages.dart';
import 'package:provider/provider.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  String? selectedLanguageCode;

  @override
  Widget build(BuildContext context) {
    String selectedLanguageOrDefault = selectedLanguageCode ??
        Provider.of<GlobalAppState>(context, listen: false).languageCode;
    return PlatformAlertDialog(
      title: Text(AppLocalizations.of(context).settings),
      content: DropdownButton<String>(
        isExpanded: true,
        value: selectedLanguageOrDefault,
        icon: const Icon(Icons.language),
        elevation: 16,
        onChanged: (String? value) {
          setState(() {
            selectedLanguageCode = value!;
          });
        },
        items: GoListLanguages.supportedLanguageCodes
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(GoListLanguages.getLanguageName(value)),
          );
        }).toList(),
      ),
      actions: <Widget>[
        PlatformDialogAction(
          child: Text(AppLocalizations.of(context).cancel),
          onPressed: () => Navigator.pop(context),
        ),
        PlatformDialogAction(
            child: Text(AppLocalizations.of(context).save),
            onPressed: () {
              Provider.of<GlobalAppState>(context, listen: false)
                  .setLocale(Locale(selectedLanguageOrDefault));
              Navigator.pop(context);
            })
      ],
    );
  }
}
