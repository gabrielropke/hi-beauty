import 'package:flutter/material.dart';
import 'package:hibeauty/config/brand_loader.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class BusinessTop extends StatefulWidget {
  final bool? completed;
  const BusinessTop({super.key, this.completed = false});

  @override
  State<BusinessTop> createState() => _BusinessTopState();
}

class _BusinessTopState extends State<BusinessTop> {
  String? _domainUrl;

  @override
  void initState() {
    super.initState();
    _loadBrand();
  }

  Future<void> _loadBrand() async {
    try {
      final brand = await BrandLoader.load();
      if (mounted) {
        setState(() {
          _domainUrl = brand['domain'] as String?;
        });
      }
    } catch (_) {
      // silent fail; keep null
    }
  }

  Future<void> _openSite() async {
    final domain = (_domainUrl ?? '').trim();
    final slug = (BusinessData.slug).trim();
    if (domain.isEmpty || slug.isEmpty) return;

    final normalizedDomain =
        domain.startsWith('http://') || domain.startsWith('https://')
        ? domain
        : 'https://$domain';

    final url = '$normalizedDomain/$slug';
    debugPrint('abrindo $url');

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final name = BusinessData.name;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return widget.completed == false
        ? Align(
            alignment: AlignmentGeometry.topLeft,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.secondary,
                  child: Text(
                    initial,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  right: 1,
                  bottom: 1,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Row(
            spacing: 12,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.secondary,
                    child: Text(
                      initial,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        Text(
                          '${BusinessData.segment}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Container(
                          width: 5,
                          height: 5,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black26,
                          ),
                        ),
                        GestureDetector(
                          onTap: _openSite,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 4,
                            children: [
                              Text(
                                l10n.mySite,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Icon(
                                Icons.open_in_new,
                                size: 16,
                                color: Colors.black38,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
