// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_dropdown.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/core/components/app_toggle_switch.dart';
import 'package:hibeauty/core/constants/formatters/money.dart';
import 'package:hibeauty/core/constants/image_picker_helper.dart';
import 'package:hibeauty/features/catalog/data/model.dart';
import 'package:hibeauty/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:hibeauty/features/catalog/presentation/products/update_stock.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:hibeauty/core/components/app_floating_message.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:hibeauty/features/catalog/presentation/components/add_category.dart';

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

Future<void> showAddProduct({
  required BuildContext context,
  required CatalogLoaded state,
  required AppLocalizations l10n,
  ProductsModel? product,
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
          child: _AddProductModal(state: state, l10n: l10n, product: product),
        ),
      );
    },
  );
}

class _AddProductModal extends StatefulWidget {
  const _AddProductModal({
    required this.state,
    required this.l10n,
    this.product,
  });

  final CatalogLoaded state;
  final AppLocalizations l10n;
  final ProductsModel? product;

  @override
  State<_AddProductModal> createState() => _AddProductModalState();
}

class _AddProductModalState extends State<_AddProductModal>
    with SingleTickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  bool _showHeaderTitle = false;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descriptionCtrl;
  late final TextEditingController _skuCtrl;
  late final TextEditingController _barcodeCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _costPriceCtrl;
  late final TextEditingController _stockCtrl;
  late final TextEditingController _lowStockThresholdCtrl;
  late final TextEditingController _measurementQuantityCtrl;

  // Formatador de dinheiro inline
  late final TextInputFormatter _moneyFormatter;

  // Categoria selecionada
  String? _selectedCategoryId;

  // Unidade de medida
  String _measurementUnit = 'unidade';

  // Visibilidade
  String _visibility = 'public';

  // Controle de estoque
  bool _controllingStock = false;

  // Imagem do produto
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

    final product = widget.product;
    _nameCtrl = TextEditingController(text: product?.name ?? '');
    _descriptionCtrl = TextEditingController(text: product?.description ?? '');
    _skuCtrl = TextEditingController(text: product?.sku ?? '');
    _barcodeCtrl = TextEditingController(text: product?.barcode ?? '');
    _stockCtrl = TextEditingController(text: product?.stock.toString() ?? '');
    _lowStockThresholdCtrl = TextEditingController(
      text: product?.lowStockThreshold.toString() ?? '',
    );
    _measurementQuantityCtrl = TextEditingController(
      text: product?.measurementQuantity.toString() ?? '',
    );

    // Aplicar formatação de dinheiro nos valores iniciais
    final priceValue = product?.price ?? 0.0;
    _priceCtrl = TextEditingController(
      text: priceValue > 0 ? safeMoneyFormat(priceValue.toString()) : '',
    );

    final costPriceValue = product?.costPrice ?? 0.0;
    _costPriceCtrl = TextEditingController(
      text: costPriceValue > 0
          ? safeMoneyFormat(costPriceValue.toString())
          : '',
    );

    // Inicializar todos os campos se estiver editando
    if (product != null) {
      _selectedCategoryId = product.category?.id;
      _measurementUnit = product.measurementUnit;
      _visibility = product.visibility.toLowerCase();
      _controllingStock = product.controllingStock;
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
    _skuCtrl.dispose();
    _barcodeCtrl.dispose();
    _priceCtrl.dispose();
    _costPriceCtrl.dispose();
    _stockCtrl.dispose();
    _lowStockThresholdCtrl.dispose();
    _measurementQuantityCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    final name = _nameCtrl.text.trim();
    final price = _priceCtrl.text.trim();

    return name.isNotEmpty && price.isNotEmpty && _getPriceValue() > 0;
  }

  double _getPriceValue() {
    final priceText = _priceCtrl.text
        .replaceAll(RegExp(r'[^\d,]'), '')
        .replaceAll(',', '.');
    return double.tryParse(priceText) ?? 0.0;
  }

  double _getCostPriceValue() {
    final priceText = _costPriceCtrl.text
        .replaceAll(RegExp(r'[^\d,]'), '')
        .replaceAll(',', '.');
    return double.tryParse(priceText) ?? 0.0;
  }

  void _showValidationError() {
    String message = 'Preencha todos os campos obrigatórios';
    AppFloatingMessage.show(
      context,
      message: message,
      type: AppFloatingMessageType.error,
    );
  }

  Future<void> _pickProductImage() async {
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

    final model = CreateProductModel(
      name: _nameCtrl.text.trim(),
      description: _descriptionCtrl.text.trim().isNotEmpty
          ? _descriptionCtrl.text.trim()
          : null,
      sku: _skuCtrl.text.trim().isNotEmpty ? _skuCtrl.text.trim() : null,
      barcode: _barcodeCtrl.text.trim().isNotEmpty
          ? _barcodeCtrl.text.trim()
          : null,
      categoryId: _selectedCategoryId,
      price: _getPriceValue(),
      costPrice: _getCostPriceValue(),
      stock: int.tryParse(_stockCtrl.text.trim()) ?? 0,
      lowStockThreshold: int.tryParse(_lowStockThresholdCtrl.text.trim()) ?? 0,
      measurementUnit: _measurementUnit,
      measurementQuantity:
          double.tryParse(_measurementQuantityCtrl.text.trim()) ?? 0,
      visibility: _visibility.toUpperCase(),
      controllingStock: _controllingStock,
      image: _selectedImage,
    );

    if (widget.product != null) {
      // Modo de edição - atualizar produto existente
      context.read<CatalogBloc>().add(UpdateProduct(widget.product!.id, model));
    } else {
      // Modo de criação - criar novo produto
      context.read<CatalogBloc>().add(CreateProduct(model));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;

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
                            isEdit ? 'Editar produto' : 'Adicionar produto',
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
                              isEdit ? 'Editar produto' : 'Adicionar produto',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 32),
                            // Foto do produto
                            _ProductImagePicker(
                              image: _selectedImage,
                              networkImage: widget.product?.imageUrl,
                              hideHint: _hideImageHint,
                              onPicked: (file) {
                                setState(() {
                                  _selectedImage = file;
                                  _hideImageHint = true;
                                });
                              },
                              onTap: _pickProductImage,
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
                            // Nome
                            AppTextformfield(
                              isrequired: true,
                              title: 'Nome do produto',
                              hintText: 'Ex: Shampoo Nutritivo 500ml',
                              controller: _nameCtrl,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 32),

                            // Categoria
                            BlocBuilder<CatalogBloc, CatalogState>(
                              builder: (context, state) {
                                final categories = state is CatalogLoaded
                                    ? state.productCategories
                                    : widget.state.productCategories;

                                return AppDropdown(
                                  title: 'Categoria',
                                  items: categories
                                      .map(
                                        (category) => {
                                          'label': category.name,
                                          'value': category.id,
                                          'color': category.color,
                                        },
                                      )
                                      .toList(),
                                  labelKey: 'label',
                                  valueKey: 'value',
                                  leadingKey: 'color',
                                  placeholder: const Text(
                                    'Selecione uma categoria',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                  selectedValue: _selectedCategoryId,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategoryId = value as String?;
                                    });
                                  },
                                  onAddPressed: () {
                                    showAddCategory(
                                      context: context,
                                      l10n: widget.l10n,
                                      type: CategoryType.product,
                                    );
                                  },
                                );
                              },
                            ),

                            const SizedBox(height: 32),

                            Row(
                              spacing: 12,
                              children: [
                                // Preço de Venda
                                Expanded(
                                  child: Column(
                                    spacing: 6,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppTextformfield(
                                        isrequired: true,
                                        title: 'Preço de venda',
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
                                      Text(''),
                                    ],
                                  ),
                                ),

                                // Preço de Custo
                                Expanded(
                                  child: Column(
                                    spacing: 6,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppTextformfield(
                                        title: 'Preço de custo',
                                        hintText: 'R\$ 0,00',
                                        controller: _costPriceCtrl,
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                        textInputAction: TextInputAction.next,
                                        textInputFormatter: _moneyFormatter,
                                        onChanged: (_) => setState(() {}),
                                      ),
                                      Builder(
                                        builder: (context) {
                                          final venda = _getPriceValue();
                                          final custo = _getCostPriceValue();
                                          double margem = 0;
                                          if (venda > 0 && custo > 0) {
                                            margem =
                                                ((venda - custo) / venda) * 100;
                                          }
                                          return Text(
                                            margem > 0
                                                ? 'Margem: ${venda > 0 && custo > 0 ? margem.toStringAsFixed(1) : '--'}%'
                                                : '',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            Row(
                              spacing: 12,
                              children: [
                                // Unidade de Medida
                                Expanded(
                                  child: AppDropdown(
                                    title: 'Unidade de medida',
                                    items: const [
                                      {
                                      'label': 'Mililitros (ml)',
                                      'value': 'mL',
                                      },
                                      {'label': 'Litros (l)', 'value': 'L'},
                                      {'label': 'Gramas (g)', 'value': 'g'},
                                      {
                                      'label': 'Quilogramas (kg)',
                                      'value': 'kg',
                                      },
                                      {'label': 'Galões (gal)', 'value': 'gal'},
                                      {'label': 'Onças (oz)', 'value': 'oz'},
                                      {'label': 'Libras (lb)', 'value': 'lb'},
                                      {
                                      'label': 'Centímetros (cm)',
                                      'value': 'cm',
                                      },
                                      {'label': 'Pés (ft)', 'value': 'ft'},
                                      {
                                      'label': 'Polegadas (in)',
                                      'value': 'in',
                                      },
                                      {'label': 'Unidade', 'value': 'unidade'},
                                    ],
                                    labelKey: 'label',
                                    valueKey: 'value',
                                    placeholder: const Text(
                                      'Selecione a unidade',
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                    selectedValue: _measurementUnit,
                                    onChanged: (value) {
                                      setState(() {
                                        _measurementUnit = value as String;
                                      });
                                    },
                                  ),
                                ),

                                // Quantidade por Unidade
                                Expanded(
                                  child: AppTextformfield(
                                    title: 'Quantidade ($_measurementUnit)',
                                    hintText: _measurementUnit == 'unidade'
                                        ? '1'
                                        : '500',
                                    controller: _measurementQuantityCtrl,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // SKU
                            AppTextformfield(
                              title: 'SKU',
                              hintText: 'Ex: PROD-ABC-001',
                              controller: _skuCtrl,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 32),

                            // Código de Barras
                            AppTextformfield(
                              title: 'Código de barras',
                              hintText: 'EAN / GTIN',
                              controller: _barcodeCtrl,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 32),

                            // Controle de Estoque
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
                                        'Controle de estoque',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _controllingStock
                                            ? 'Monitorar quantidades automaticamente'
                                            : 'Não controlar estoque',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  AppToggleSwitch(
                                    isTrue: _controllingStock,
                                    function: () {
                                      setState(() {
                                        _controllingStock = !_controllingStock;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),

                            if (_controllingStock) ...[
                              // Estoque Atual
                              Row(
                                spacing: 12,
                                children: [
                                  Expanded(
                                    child: IgnorePointer(
                                      ignoring: widget.product != null, 
                                      child: Opacity(
                                        opacity: widget.product == null ? 1 : 0.5,
                                        child: AppTextformfield(
                                          isrequired: _controllingStock,
                                          title: 'Estoque atual',
                                          hintText: '30',
                                          controller: _stockCtrl,
                                          keyboardType: TextInputType.number,
                                          textInputAction: TextInputAction.next,
                                          textInputFormatter:
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (widget.product != null) ...[
                                    Column(
                                      children: [
                                        Text(''),
                                        AppButton(
                                          width: 100,
                                          height: 45,
                                          fillColor: Colors.grey[200],
                                          borderColor: Colors.grey[400],
                                          labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1.5,
                                          ),
                                          label: 'Ajustar',
                                          borderRadius: 8,
                                          function: () {
                                            final currentState = context
                                                .read<CatalogBloc>()
                                                .state;
                                            if (currentState is CatalogLoaded) {
                                              showUpdateStock(
                                                context: context,
                                                product: widget.product!,
                                                l10n: AppLocalizations.of(
                                                  context,
                                                )!,
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 32),

                              // Estoque Mínimo
                              AppTextformfield(
                                isrequired: _controllingStock,
                                title: 'Alerta de Estoque Baixo',
                                hintText: '5',
                                controller: _lowStockThresholdCtrl,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                textInputFormatter:
                                    FilteringTextInputFormatter.digitsOnly,
                              ),
                              const SizedBox(height: 32),
                            ],

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
                            const SizedBox(height: 32),

                            // Descrição
                            AppTextformfield(
                              title: 'Descrição',
                              hintText: 'Fórmula rica em óleos naturais...',
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
                  widget.product != null ? LucideIcons.check : LucideIcons.plus,
                  color: Colors.white,
                  size: 20,
                ),
                label: widget.product != null
                    ? 'Salvar alterações'
                    : 'Adicionar produto',
                function: _submitForm,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProductImagePicker extends StatelessWidget {
  final File? image;
  final String? networkImage;
  final bool hideHint;
  final ValueChanged<File> onPicked;
  final VoidCallback onTap;

  const _ProductImagePicker({
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
          'Foto do produto',
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
                              'Adicionar uma foto',
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
