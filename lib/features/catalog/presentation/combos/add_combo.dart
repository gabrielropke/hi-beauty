// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/core/components/app_toggle_switch.dart';
import 'package:hibeauty/core/constants/formatters/money.dart';
import 'package:hibeauty/core/constants/image_picker_helper.dart';
import 'package:hibeauty/features/catalog/data/model.dart';
import 'package:hibeauty/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:hibeauty/core/components/app_floating_message.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'combo_items_selector.dart';

String mapVisibility(String value) {
  switch (value) {
    case 'public':
      return 'Público';
    case 'private':
      return 'Privado';
    default:
      return value;
  }
}

Future<void> showAddCombo({
  required BuildContext context,
  required CatalogLoaded state,
  required AppLocalizations l10n,
  CombosModel? combo,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    useSafeArea: true,
    barrierColor: Colors.transparent,
    clipBehavior: Clip.hardEdge,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
    ),
    builder: (ctx) {
      return BlocProvider.value(
        value: context.read<CatalogBloc>(),
        child: Container(
          color: Colors.white,
          child: _AddComboModal(state: state, l10n: l10n, combo: combo),
        ),
      );
    },
  );
}

class _AddComboModal extends StatefulWidget {
  const _AddComboModal({required this.state, required this.l10n, this.combo});

  final CatalogLoaded state;
  final AppLocalizations l10n;
  final CombosModel? combo;

  @override
  State<_AddComboModal> createState() => _AddComboModalState();
}

class _AddComboModalState extends State<_AddComboModal>
    with SingleTickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  bool _showHeaderTitle = false;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _priceCtrl;

  // Formatador de dinheiro inline
  late final TextInputFormatter _moneyFormatter;

  // Visibilidade
  String _visibility = 'public';

  // Seleção de serviços e produtos para o combo
  Set<String> _selectedServiceIds = {};
  Map<String, int> _selectedProductQuantities = {}; // productId -> quantity

  // Gera lista de IDs repetidos conforme a quantidade
  List<String> _getProductsList() {
    final List<String> productsList = [];
    for (final entry in _selectedProductQuantities.entries) {
      for (int i = 0; i < entry.value; i++) {
        productsList.add(entry.key);
      }
    }
    return productsList;
  }

  // Imagem do combo
  File? _selectedImage;
  bool _hideImageHint = false;
  final _imagePickerHelper = ImagePickerHelper();

  @override
  void initState() {
    super.initState();

    // Inicializar formatador de dinheiro
    _moneyFormatter = TextInputFormatter.withFunction((oldValue, newValue) {
      if (newValue.text.isEmpty) return newValue;

      final value =
          double.tryParse(newValue.text.replaceAll(RegExp(r'[^\d]'), '')) ?? 0;
      final formatted = safeMoneyFormat((value / 100).toString());

      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    });

    final combo = widget.combo;
    _nameCtrl = TextEditingController(text: combo?.name ?? '');
    _descriptionCtrl = TextEditingController(text: combo?.description ?? '');

    // Aplicar formatação de dinheiro no valor inicial
    final priceValue = combo?.price ?? 0.0;
    _priceCtrl = TextEditingController(
      text: priceValue > 0 ? safeMoneyFormat(priceValue.toString()) : '',
    );

    // Inicializar todos os campos se estiver editando
    if (combo != null) {
      _visibility = combo.visibility.toLowerCase();
      _selectedServiceIds = combo.services.map((s) => s.id).toSet();
      _selectedProductQuantities = Map.fromEntries(
        combo.products.map((p) => MapEntry(p.id, p.quantity)),
      );
    }

    _controller.addListener(() {
      final shouldShow = _controller.offset > 8;
      if (shouldShow != _showHeaderTitle) {
        setState(() => _showHeaderTitle = shouldShow);
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    _priceCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    final name = _nameCtrl.text.trim();
    final price = _priceCtrl.text.trim();
    final totalSelected =
        _selectedServiceIds.length + _selectedProductQuantities.length;

    return name.isNotEmpty &&
        price.isNotEmpty &&
        _getPriceValue() > 0 &&
        totalSelected >= 2;
  }

  double _getPriceValue() {
    final priceText = _priceCtrl.text
        .replaceAll(RegExp(r'[^\d,]'), '')
        .replaceAll(',', '.');
    return double.tryParse(priceText) ?? 0.0;
  }

  double _getOriginalPrice() {
    double total = 0.0;
    
    // Soma preços dos serviços selecionados
    for (final serviceId in _selectedServiceIds) {
      final service = widget.state.services.firstWhere(
        (s) => s.id == serviceId,
        orElse: () => ServicesModel(
          id: '',
          name: '',
          price: 0.0,
          duration: 0,
          visibility: '',
          isActive: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(), locationType: '', currency: '', teamMembers: [], businessId: '',
        ),
      );
      total += service.price;
    }
    
    // Soma preços dos produtos selecionados (com quantidade)
    for (final entry in _selectedProductQuantities.entries) {
      final product = widget.state.products.firstWhere(
        (p) => p.id == entry.key,
        orElse: () => ProductsModel(
          id: '',
          name: '',
          price: 0.0,
          visibility: '',
          isActive: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(), costPrice: 0.0, stock: 0, lowStockThreshold: 0, isLowStock: false, businessId: '', measurementUnit: '', measurementQuantity: 0, controllingStock: false,
        ),
      );
      total += product.price * entry.value;
    }
    
    return total;
  }

  double _getDiscountPercentage() {
    final originalPrice = _getOriginalPrice();
    final promotionalPrice = _getPriceValue();
    
    if (originalPrice <= 0 || promotionalPrice >= originalPrice) {
      return 0.0;
    }
    
    return ((originalPrice - promotionalPrice) / originalPrice) * 100;
  }

  int _getTotalDuration() {
    int totalMinutes = 0;
    
    // Soma duração dos serviços selecionados
    for (final serviceId in _selectedServiceIds) {
      final service = widget.state.services.firstWhere(
        (s) => s.id == serviceId,
        orElse: () => ServicesModel(
          id: '',
          name: '',
          price: 0.0,
          duration: 0,
          visibility: '',
          isActive: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          locationType: '',
          currency: '',
          teamMembers: [],
          businessId: '',
        ),
      );
      totalMinutes += service.duration;
    }
    
    return totalMinutes;
  }

  void _showValidationError() {
    final totalSelected =
        _selectedServiceIds.length + _selectedProductQuantities.length;
    String message = 'Preencha todos os campos obrigatórios';

    if (totalSelected < 2) {
      message = 'Selecione pelo menos 2 itens (serviços ou produtos)';
    }

    AppFloatingMessage.show(
      context,
      message: message,
      type: AppFloatingMessageType.error,
    );
  }

  Future<void> _pickComboImage() async {
    final l10n = widget.l10n;
    final file = await _imagePickerHelper.pickImage(
      context: context,
      l10n: l10n,
      imageSource: ImageSource.gallery,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    if (mounted && file != null) {
      setState(() {
        _selectedImage = file;
        _hideImageHint = true;
      });
    }
  }

  void _submitForm() {
    if (!_isFormValid()) {
      _showValidationError();
      return;
    }

    final originalPrice = _getOriginalPrice();
    final promotionalPrice = _getPriceValue();
    final discountPercentage = _getDiscountPercentage();
    final totalDuration = _getTotalDuration();

    final model = CreateComboModel(
      name: _nameCtrl.text.trim(),
      description: _descriptionCtrl.text.trim().isNotEmpty
          ? _descriptionCtrl.text.trim()
          : null,
      price: promotionalPrice,
      originalPrice: originalPrice,
      discount: discountPercentage,
      totalDuration: totalDuration,
      serviceIds: _selectedServiceIds.toList(),
      productsIds: _getProductsList(), // Lista com IDs repetidos
      visibility: _visibility.toUpperCase(),
      coverImage: _selectedImage,
    );

    if (widget.combo != null) {
      // Modo de edição - atualizar combo existente
      context.read<CatalogBloc>().add(UpdateCombo(widget.combo!.id, model));
    } else {
      // Modo de criação - criar novo combo
      context.read<CatalogBloc>().add(CreateCombo(model));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.combo != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                        opacity: _showHeaderTitle ? 1 : 0,
                        child: IgnorePointer(
                          ignoring: !_showHeaderTitle,
                          child: Text(
                            isEdit ? 'Editar combo' : 'Adicionar combo',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                opacity: _showHeaderTitle ? 1 : 0,
                child: Divider(
                  thickness: 1,
                  color: Colors.grey[300],
                  height: 5,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _controller,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEdit ? 'Editar combo' : 'Adicionar combo',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 32),
                            // Foto do combo
                            _ComboImagePicker(
                              image: _selectedImage,
                              networkImage: widget.combo?.coverImageUrl,
                              hideHint: _hideImageHint,
                              onPicked: (file) {
                                setState(() {
                                  _selectedImage = file;
                                  _hideImageHint = true;
                                });
                              },
                              onTap: _pickComboImage,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 32),
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: Colors.grey[50],
                      ),
                      SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            // Nome do Combo
                            AppTextformfield(
                              isrequired: true,
                              title: 'Nome do combo',
                              hintText: 'Ex: Corte + Barba Premium',
                              controller: _nameCtrl,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 32),

                            // Seleção de Serviços/Produtos
                            ComboItemsSelector(
                              selectedServiceIds: _selectedServiceIds,
                              selectedProductQuantities:
                                  _selectedProductQuantities,
                              onServiceToggle: (serviceId) {
                                setState(() {
                                  if (_selectedServiceIds.contains(serviceId)) {
                                    _selectedServiceIds.remove(serviceId);
                                  } else {
                                    _selectedServiceIds.add(serviceId);
                                  }
                                });
                              },
                              onProductToggle: (productId) {
                                setState(() {
                                  if (_selectedProductQuantities.containsKey(
                                    productId,
                                  )) {
                                    _selectedProductQuantities.remove(
                                      productId,
                                    );
                                  } else {
                                    _selectedProductQuantities[productId] = 1;
                                  }
                                });
                              },
                              onProductQuantityChange: (productId, quantity) {
                                setState(() {
                                  if (quantity > 0) {
                                    _selectedProductQuantities[productId] =
                                        quantity;
                                  } else {
                                    _selectedProductQuantities.remove(
                                      productId,
                                    );
                                  }
                                });
                              },
                              initialState: widget.state,
                            ),

                            // Preço promocional
                            const SizedBox(height: 32),

                            AppTextformfield(
                              isrequired: true,
                              title: 'Preço promocional',
                              hintText: 'R\$ 0,00',
                              controller: _priceCtrl,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              textInputAction: TextInputAction.next,
                              textInputFormatter: _moneyFormatter,
                              onChanged: (_) => setState(() {}),
                            ),
                            SizedBox(height: 4),
                            Builder(
                              builder: (context) {
                                final originalPrice = _getOriginalPrice();
                                final discountPercentage = _getDiscountPercentage();
                                final hasItems = _selectedServiceIds.isNotEmpty || _selectedProductQuantities.isNotEmpty;
                                
                                if (!hasItems) {
                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'Selecione itens para ver o desconto',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  );
                                }
                                
                                return Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Original: R\$ ${originalPrice.toStringAsFixed(2).replaceAll('.', ',')}${discountPercentage > 0 ? ' • Desconto ${discountPercentage.toStringAsFixed(0)}%' : ''}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 32),

                            // Visibilidade
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[300]!,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        mapVisibility(_visibility),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _visibility == 'public'
                                            ? 'Visível no catálogo online para clientes'
                                            : 'Apenas para uso interno',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  AppToggleSwitch(
                                    isTrue: _visibility == 'public',
                                    function: () {
                                      setState(() {
                                        _visibility = _visibility == 'private'
                                            ? 'public'
                                            : 'private';
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Descrição
                            AppTextformfield(
                              title: 'Descrição',
                              hintText: 'Descreva o que este combo inclui...',
                              controller: _descriptionCtrl,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              isMultiline: true,
                              multilineInitialLines: 3,
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: BlocBuilder<CatalogBloc, CatalogState>(
          builder: (context, state) {
            final loading = state is CatalogLoaded ? state.loading : false;
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: AppButton(
                spacing: 10,
                loading: loading,
                preffixIcon: Icon(
                  widget.combo != null ? LucideIcons.check : LucideIcons.plus,
                  color: Colors.white,
                  size: 20,
                ),
                label: widget.combo != null
                    ? 'Salvar alterações'
                    : 'Adicionar combo',
                function: _submitForm,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ComboImagePicker extends StatelessWidget {
  final File? image;
  final String? networkImage;
  final bool hideHint;
  final ValueChanged<File> onPicked;
  final VoidCallback onTap;

  const _ComboImagePicker({
    required this.image,
    required this.networkImage,
    required this.hideHint,
    required this.onPicked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ImageProvider? imageProvider = image != null
        ? FileImage(image!)
        : (networkImage != null && networkImage!.isNotEmpty
              ? NetworkImage(networkImage!)
              : null);

    final showHint = !hideHint && imageProvider == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Imagem de capa',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  image: imageProvider != null
                      ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
                      : null,
                ),
              ),
              if (showHint)
                Positioned.fill(
                  child: AnimatedOpacity(
                    opacity: 1,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.imagePlus,
                              size: 20,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Adicionar imagem de capa',
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (imageProvider != null)
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              foregroundColor: Colors.blue,
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Alterar imagem',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ),
      ],
    );
  }
}
