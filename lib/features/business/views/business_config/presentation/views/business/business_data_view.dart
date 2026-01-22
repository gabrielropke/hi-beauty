import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/bloc/business_config_bloc.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/views/business/business_data_edit_sheet.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/views/business/business_data_preview.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:hibeauty/core/components/custom_app_bar.dart';

class BusinessDataScreen extends StatelessWidget {
  const BusinessDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BusinessDataView();
  }
}

class BusinessDataView extends StatefulWidget {
  const BusinessDataView({super.key});

  @override
  State<BusinessDataView> createState() => _BusinessDataViewState();
}

class _BusinessDataViewState extends State<BusinessDataView> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _instagramCtrl;
  late final TextEditingController _slugCtrl;
  late final TextEditingController _descriptionCtrl;

  late List<String> _subSegments;
  bool _showAllSubSegments = false;
  late List<String> _availableSubSegments;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: BusinessData.name);
    _instagramCtrl = TextEditingController(text: BusinessData.instagram ?? '');
    _slugCtrl = TextEditingController(text: BusinessData.slug);
    _descriptionCtrl = TextEditingController(
      text: BusinessData.description ?? '',
    );
    _subSegments = List<String>.from(BusinessData.subSegments);
    _availableSubSegments = List<String>.from(BusinessData.subSegments);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _instagramCtrl.dispose();
    _slugCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<BusinessConfigBloc, BusinessConfigState>(
        builder: (context, state) => switch (state) {
          BusinessConfigLoading _ => const AppLoader(),
          BusinessConfigLoaded s => Column(
              children: [
                CustomAppBar(
                  title: l10n.businessData,
                  controller: _scrollController,
                  backgroundColor: Colors.white,
                ),
                Expanded(
                  child: BusinessDataPreview(
                    state: s,
                    l10n: l10n,
                    onEdit: () => showBusinessDataEditSheet(
                      context: context,
                      state: s,
                      l10n: l10n,
                      nameCtrl: _nameCtrl,
                      instagramCtrl: _instagramCtrl,
                      slugCtrl: _slugCtrl,
                      descriptionCtrl: _descriptionCtrl,
                      subSegments: _availableSubSegments,
                      showAllSubSegments: _showAllSubSegments,
                      onToggleShowAll: () => setState(
                        () => _showAllSubSegments = !_showAllSubSegments,
                      ),
                      onRemoveSubSegment: _removeSubSegment,
                    ),
                    scrollController: _scrollController,
                  ),
                ),
              ],
            ),
          _ => const AppLoader(),
        },
      ),
    );
  }

  void _removeSubSegment(String value) {
    setState(() {
      _subSegments.remove(value);
      _availableSubSegments.remove(value);
      if (_availableSubSegments.length <= 2) _showAllSubSegments = true;
    });
  }
}
