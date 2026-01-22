import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/bloc/business_config_bloc.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/views/customize/components/colorpicker.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/views/customize/components/imagepicker.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:hibeauty/core/components/custom_app_bar.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/theme/app_colors.dart';

class BusinessCustomizationScreen extends StatelessWidget {
  const BusinessCustomizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BusinessCustomizationView();
  }
}

class BusinessCustomizationView extends StatefulWidget {
  const BusinessCustomizationView({super.key});

  @override
  State<BusinessCustomizationView> createState() =>
      _BusinessCustomizationViewState();
}

class _BusinessCustomizationViewState extends State<BusinessCustomizationView> {
  final ScrollController _scrollController = ScrollController();
  Color _brandColor =
      (BusinessData.themeColor != null && BusinessData.themeColor!.isNotEmpty)
      ? Color(int.parse(BusinessData.themeColor!.replaceFirst('#', '0xff')))
      : AppColors.primary;

  File? _logoFile;
  File? _coverFile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<BusinessConfigBloc, BusinessConfigState>(
        builder: (context, state) => switch (state) {
          BusinessConfigLoading _ => const AppLoader(),
          BusinessConfigLoaded _ => Column(
            children: [
              CustomAppBar(
                title: '${l10n.customize} ${l10n.visual}',
                controller: _scrollController,
                backgroundColor: Colors.white,
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 32,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _CustomizationIntro(
                          title: '${l10n.customize} ${l10n.visual}',
                          description: l10n.customizeDescription,
                        ),
                      ),
                      CustomizationColorSelector(
                        initial: _brandColor,
                        onChanged: (c) => setState(() => _brandColor = c),
                      ),
                      // Picker da LOGO
                      BusinessImagePicker(
                        label: l10n.brandImage,
                        description: l10n.brandImageReccomendation,
                        image: _logoFile,
                        networkImage: BusinessData.logoUrl,
                        isCover: false,
                        onPicked: (file) => setState(() => _logoFile = file),
                      ),
                      // Picker da CAPA
                      BusinessImagePicker(
                        label: l10n.brandCoverImage,
                        description: l10n.brandCoverImageReccomendatio,
                        image: _coverFile,
                        networkImage: BusinessData.coverUrl,
                        isCover: true,
                        onPicked: (file) => setState(() => _coverFile = file),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _ => const AppLoader(),
        },
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: BlocBuilder<BusinessConfigBloc, BusinessConfigState>(
          builder: (context, state) {
            final loading = (state is BusinessConfigLoaded)
                ? state.loading
                : false;
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: AppButton(
                spacing: 12,
                label: l10n.save,
                loading: loading,
                function: () => context.read<BusinessConfigBloc>().add(
                  UpdateSetupCustomization(
                    themeColor:
                        // ignore: deprecated_member_use
                        '#${_brandColor.value.toRadixString(16).substring(2)}',
                    logoImage: _logoFile,
                    coverImage: _coverFile,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CustomizationIntro extends StatelessWidget {
  final String title;
  final String description;
  const _CustomizationIntro({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Text(
          description,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
