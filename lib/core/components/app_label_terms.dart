import 'package:flutter/material.dart';
import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class AppLabelTerms extends StatefulWidget {
  const AppLabelTerms({super.key});

  @override
  State<AppLabelTerms> createState() => _AppLabelTermsState();
}

class _AppLabelTermsState extends State<AppLabelTerms> {
  String terms = '';
  String privacy = '';

  @override
  void initState() {
    loadingBranding();
    super.initState();
  }

  void loadingBranding() async {
    final Map<String, dynamic> brandMap = await BrandLoader.load();
    terms = brandMap['terms'];
    privacy = brandMap['privacy'];
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              color: Colors.black.withValues(alpha: 0.5),
            ),
            children: [
              TextSpan(text: '${l10n.createAccountAgreement} '),
              TextSpan(
                text: ' ${l10n.termsOfUse} ',
                style: TextStyle(
                  color: Colors.black,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => _launchUrl(terms),
              ),
              TextSpan(text: ' ${l10n.and} '),
              TextSpan(
                text: ' ${l10n.privacyPolicy}',
                style: TextStyle(
                  color: Colors.black,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => _launchUrl(privacy),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
