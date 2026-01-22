import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/core/components/app_message.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/bloc/business_config_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BusinessDataPreview extends StatelessWidget {
  final BusinessConfigLoaded state;
  final AppLocalizations l10n;
  final VoidCallback onEdit;
  final ScrollController scrollController;
  const BusinessDataPreview({
    super.key,
    required this.state,
    required this.l10n,
    required this.onEdit,
    required this.scrollController,
  });

  /// Função para tratar as labels das especialidades
  String _getSubSegmentLabel(String key) {
    final Map<String, String> specialtiesLabels = {
      'corte_masculino': 'Corte Masculino',
      'barba_bigode': 'Barba e Bigode',
      'sobrancelha_masculina': 'Sobrancelha Masculina',
      'coloracao_masculina': 'Coloração Masculina',
      'hot_towel': 'Toalha Quente',
      'tratamento_capilar_masculino': 'Tratamento Capilar Masculino',
      'relaxamento_masculino': 'Relaxamento Masculino',
      'produtos_masculinos': 'Produtos Masculinos',
    };
    return specialtiesLabels[key] ?? key.replaceAll('_', ' ').split(' ').map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          if (state.message.isNotEmpty)
            AppMessage(
              key: const ValueKey('msg'),
              label: state.message.values.first,
              type: state.message.keys.first == 'success'
                  ? MessageType.success
                  : MessageType.failure,
              function: () =>
                  context.read<BusinessConfigBloc>().add(CloseMessage()),
            ),
          Text(
            l10n.businessData,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Text(
            l10n.editBusinessDescription,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
          ),
          SizedBox(),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.editBusiness,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              TextButton(
                onPressed: onEdit,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                ),
                child: const Text(
                  'Editar',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          const SizedBox(height: 0),
          _PreviewTile(
            label: l10n.yourBusinessName,
            value: BusinessData.name,
            onAdd: onEdit,
          ),
          _PreviewTile(label: 'Site', value: BusinessData.slug, onAdd: onEdit),
          _PreviewTile(
            label: 'Instagram',
            value: BusinessData.instagram ?? '',
            onAdd: onEdit,
          ),
          _PreviewTile(
            label: l10n.descriptionBusiness,
            value: BusinessData.description ?? '',
            onAdd: onEdit,
          ),
          _PreviewTile(
            label: l10n.subSegments,
            value: BusinessData.subSegments.isEmpty
                ? ''
                : BusinessData.subSegments.map((key) => _getSubSegmentLabel(key)).join(', '),
            onAdd: onEdit,
          ),
          _CountryPreviewTile(
            code: BusinessData.country ?? '-',
            label: 'País',
            onAdd: onEdit,
          ),
          _PreviewTile(
            label: 'Moeda',
            value: BusinessData.currency ?? '',
            onAdd: onEdit,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _PreviewTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onAdd;
  const _PreviewTile({required this.label, required this.value, this.onAdd});
  @override
  Widget build(BuildContext context) {
    final isEmpty = value.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        if (!isEmpty)
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
          )
        else
          TextButton(
            onPressed: onAdd,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: Colors.blue,
            ),
            child: const Text(
              'Adicionar',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _CountryPreviewTile extends StatelessWidget {
  final String code;
  final String label;
  final VoidCallback? onAdd;
  const _CountryPreviewTile({
    required this.code,
    required this.label,
    this.onAdd,
  });
  @override
  Widget build(BuildContext context) {
    final normalized = code.isEmpty || code == '-' ? '' : code.toUpperCase();
    final isEmpty = normalized.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        if (!isEmpty)
          Row(
            spacing: 8,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SvgPicture.network(
                  'https://flagicons.lipis.dev/flags/4x3/${normalized.toLowerCase()}.svg',
                  width: 20,
                  height: 18,
                  fit: BoxFit.cover,
                  placeholderBuilder: (_) => const SizedBox(
                    width: 20,
                    height: 18,
                    child: ColoredBox(color: Colors.black12),
                  ),
                ),
              ),
              Text(
                normalized,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),
            ],
          )
        else
          TextButton(
            onPressed: onAdd,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              foregroundColor: Colors.blue,
            ),
            child: const Text(
              'Adicionar',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}
