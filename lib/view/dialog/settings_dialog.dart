import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_list/service/golist_languages.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late String selectedLanguage;

  @override
  void initState() {
    super.initState();
    selectedLanguage = GoListLanguages.getLanguageCode();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAlertDialog(
      title: Text(AppLocalizations.of(context)!.settings),
      content: DropdownButton<String>(
        isExpanded: true,
        value: selectedLanguage,
        icon: const Icon(Icons.language),
        elevation: 16,
        onChanged: (String? value) {
          setState(() {
            selectedLanguage = value!;
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
          child: Text(AppLocalizations.of(context)!.cancel),
          onPressed: () => Navigator.pop(context),
        ),
        PlatformDialogAction(
            child: Text(AppLocalizations.of(context)!.save),
            onPressed: () {
              GoListLanguages.setLanguage(context, selectedLanguage);
              Navigator.pop(context);
            })
      ],
    );
  }
}
