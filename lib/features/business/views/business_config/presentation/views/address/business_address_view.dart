import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_loader.dart';
import 'package:hibeauty/core/components/custom_app_bar.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/bloc/business_config_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/views/address/address_edit_sheet.dart';

class BusinessAddressScreen extends StatelessWidget {
  const BusinessAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BusinessAddressView();
  }
}

class BusinessAddressView extends StatefulWidget {
  const BusinessAddressView({super.key});

  @override
  State<BusinessAddressView> createState() => _BusinessAddressViewState();
}

class _BusinessAddressViewState extends State<BusinessAddressView> {
  late final TextEditingController _zipCodeCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _neighborhoodCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _stateCtrl;
  late final TextEditingController _countryCtrl;
  late final TextEditingController _numberCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _instagramCtrl;
  late final TextEditingController _slugCtrl;
  late final TextEditingController _descriptionCtrl;

  @override
  void initState() {
    super.initState();
    _zipCodeCtrl = TextEditingController(text: BusinessData.zipCode ?? '');
    _addressCtrl = TextEditingController(text: BusinessData.address ?? '');
    _neighborhoodCtrl = TextEditingController(
      text: BusinessData.neighborhood ?? '',
    );
    _cityCtrl = TextEditingController(text: BusinessData.city ?? '');
    _stateCtrl = TextEditingController(text: BusinessData.state ?? '');
    _countryCtrl = TextEditingController(text: BusinessData.country ?? 'BR');
    _numberCtrl = TextEditingController();
    _nameCtrl = TextEditingController(text: BusinessData.name);
    _instagramCtrl = TextEditingController(text: BusinessData.instagram ?? '');
    _slugCtrl = TextEditingController(text: BusinessData.slug);
    _descriptionCtrl = TextEditingController(
      text: BusinessData.description ?? '',
    );
  }

  @override
  void dispose() {
    _zipCodeCtrl.dispose();
    _addressCtrl.dispose();
    _neighborhoodCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _countryCtrl.dispose();
    _numberCtrl.dispose();
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
        builder: (context, state) {
          return switch (state) {
            BusinessConfigLoading _ => const AppLoader(),
            BusinessConfigLoaded s => _loaded(s, context, l10n),
            BusinessConfigState() => const AppLoader(),
          };
        },
      ),
    );
  }

  Widget _loaded(
    BusinessConfigLoaded state,
    BuildContext context,
    AppLocalizations l10n,
  ) {
    final ScrollController scrollController = ScrollController();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            CustomAppBar(
              title: l10n.businessAddress,
              controller: scrollController,
              backgroundColor: Colors.white,
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: AddressDataPreview(
                  l10n: l10n,
                  onEdit: () => showAddressDataEditSheet(
                    context: context,
                    state: state,
                    l10n: l10n,
                    zipCodeCtrl: _zipCodeCtrl,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Preview de endereço (similar ao BusinessDataPreview)
class AddressDataPreview extends StatelessWidget {
  final AppLocalizations l10n;
  final VoidCallback onEdit;
  const AddressDataPreview({
    super.key,
    required this.l10n,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Text(
          l10n.businessAddress,
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
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.addressEdit,
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
        const SizedBox(height: 4),
        _AddressPreviewTile(
          label: 'CEP',
          value: BusinessData.zipCode ?? '',
          onAdd: onEdit,
        ),
        _AddressPreviewTile(
          label: 'Endereço',
          value: BusinessData.address ?? '',
          onAdd: onEdit,
        ),
        _AddressPreviewTile(
          label: 'Número',
          value: BusinessData.number ?? '',
          onAdd: onEdit,
        ),
        _AddressPreviewTile(
          label: 'Complemento',
          value: BusinessData.complement ?? '',
          onAdd: onEdit,
        ),
        _AddressPreviewTile(
          label: 'Bairro',
          value: BusinessData.neighborhood ?? '',
          onAdd: onEdit,
        ),
        _AddressPreviewTile(
          label: 'Cidade',
          value: BusinessData.city ?? '',
          onAdd: onEdit,
        ),
        _AddressPreviewTile(
          label: 'Estado',
          value: BusinessData.state ?? '',
          onAdd: onEdit,
        ),
        _AddressPreviewTile(
          label: 'País',
          value: BusinessData.country ?? '',
          onAdd: onEdit,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _AddressPreviewTile extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onAdd;
  const _AddressPreviewTile({
    required this.label,
    required this.value,
    this.onAdd,
  });

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
              ' + Adicionar',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
            ),
          ),
      ],
    );
  }
}
