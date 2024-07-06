import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(AppLocalizations.of(context).about),
      ),
      body: ListView(
        children: [
          PlatformListTile(
            title: Text(AppLocalizations.of(context).version),
            subtitle: FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Text(
                      "${snapshot.data!.version}+${snapshot.data!.buildNumber}");
                }
                return const SizedBox();
              },
            ),
            leading: const Icon(Icons.language),
          ),
          PlatformListTile(
            title: Text(AppLocalizations.of(context).privacy_policy),
            leading: const Icon(Icons.policy_outlined),
            subtitle: Text(AppLocalizations.of(context).privacy_policy_url),
            onTap: () => launchUrl(
                Uri.parse(AppLocalizations.of(context).privacy_policy_url),
                mode: LaunchMode.inAppWebView),
          ),
          PlatformListTile(
            title: Text(AppLocalizations.of(context).source_code),
            leading: const Icon(Icons.code_outlined),
            subtitle: const Text("https://github.com/daniel17903/GoList"),
            onTap: () => launchUrl(
                Uri.parse("https://github.com/daniel17903/GoList"),
                mode: LaunchMode.externalApplication),
          ),
        ],
      ),
    );
  }
}
