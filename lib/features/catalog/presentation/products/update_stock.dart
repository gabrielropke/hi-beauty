
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/core/components/app_floating_message.dart';
import 'package:hibeauty/features/catalog/data/model.dart';
import 'package:hibeauty/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

Future<void> showUpdateStock({
  required BuildContext context,
  required ProductsModel product,
  required AppLocalizations l10n,
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
          child: _UpdateStockModal(product: product, l10n: l10n),
        ),
      );
    },
  );
}

class _UpdateStockModal extends StatefulWidget {
  const _UpdateStockModal({required this.product, required this.l10n});

  final ProductsModel product;
  final AppLocalizations l10n;

  @override
  State<_UpdateStockModal> createState() => _UpdateStockModalState();
}

class _UpdateStockModalState extends State<_UpdateStockModal>
    with SingleTickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  bool _showHeaderTitle = false;
  late final TextEditingController _deltaCtrl;
  late final TextEditingController _reasonCtrl;

  int _currentStock = 0;
  int _afterStock = 0;

  @override
  void initState() {
    super.initState();

    _deltaCtrl = TextEditingController();
    _reasonCtrl = TextEditingController();
    _currentStock = widget.product.stock;
    _afterStock = _currentStock;

    _deltaCtrl.addListener(() {
      final deltaValue = int.tryParse(_deltaCtrl.text) ?? 0;
      setState(() {
        _afterStock = _currentStock + deltaValue;
      });
    });

    _controller.addListener(() {
      final shouldShow = _controller.offset > 8;
      if (shouldShow != _showHeaderTitle) {
        setState(() => _showHeaderTitle = shouldShow);
      }
    });
  }

  @override
  void dispose() {
    _deltaCtrl.dispose();
    _reasonCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  bool _isFormValid() {
    final delta = _deltaCtrl.text.trim();
    final reason = _reasonCtrl.text.trim();

    return delta.isNotEmpty &&
        reason.isNotEmpty &&
        int.tryParse(delta) != null &&
        _afterStock >= 0; // Não permitir estoque negativo
  }

  void _showValidationError() {
    String message = 'Preencha todos os campos obrigatórios';
    if (_afterStock < 0) {
      message = 'O estoque resultante não pode ser negativo';
    }
    AppFloatingMessage.show(
      context,
      message: message,
      type: AppFloatingMessageType.error,
    );
  }

  void _submitForm() {
    if (!_isFormValid()) {
      _showValidationError();
      return;
    }

    context.read<CatalogBloc>().add(AdjustStock(widget.product.id, int.parse(_deltaCtrl.text), _reasonCtrl.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              // Header padrão
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
                            'Ajuste de Estoque',
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        // Título
                        Text(
                          'Ajuste de Estoque',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Nome do produto
                        Text(
                          widget.product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Container de estoque
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[50],
                          ),
                          child: Column(
                          children: [
                            Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Atual
                              Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                Text(
                                  'Atual:',
                                  style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _currentStock.toString(),
                                  style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                ],
                              ),
                              ),

                              Icon(
                              LucideIcons.arrowRight,
                              color: Colors.grey[600],
                              size: 20,
                              ),

                              // Após
                              Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                Text(
                                  'Após:',
                                  style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _afterStock.toString(),
                                  style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: _afterStock < 0
                                    ? Colors.red
                                    : _afterStock > _currentStock
                                      ? Colors.green[700]
                                      : _afterStock < _currentStock
                                        ? Colors.orange[700]
                                        : Colors.black87,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                ],
                              ),
                              ),
                            ],
                            ),
                          ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Delta
                        AppTextformfield(
                          isrequired: true,
                          title: 'Delta (positivo entrada / negativo saída)',
                          hintText: 'Ex: 10 ou -5',
                          controller: _deltaCtrl,
                          keyboardType: TextInputType.numberWithOptions(
                            signed: true,
                          ),
                          textInputAction: TextInputAction.next,
                          textInputFormatter: FilteringTextInputFormatter.allow(
                            RegExp(r'^-?\d*'),
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          spacing: 4,
                          children: [
                            Icon(
                              _afterStock > _currentStock 
                                  ? LucideIcons.circleArrowUp 
                                  : _afterStock < _currentStock 
                                      ? LucideIcons.circleArrowDown 
                                      : LucideIcons.circle,
                              color: _afterStock > _currentStock 
                                  ? Colors.green 
                                  : _afterStock < _currentStock 
                                      ? Colors.red 
                                      : Colors.grey,
                              size: 20,
                            ),
                            Text(
                              _afterStock > _currentStock 
                                  ? 'Entrada de estoque' 
                                  : _afterStock < _currentStock 
                                      ? 'Saída de estoque' 
                                      : 'Sem alteração',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: _afterStock > _currentStock 
                                    ? Colors.green[700] 
                                    : _afterStock < _currentStock 
                                        ? Colors.red[700] 
                                        : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Motivo
                        AppTextformfield(
                          isrequired: true,
                          title: 'Motivo',
                          hintText:
                              'Ex: Entrada de novo lote, perda, ajuste inventário...',
                          controller: _reasonCtrl,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          isMultiline: true,
                          multilineInitialLines: 2,
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
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
                    color: Colors.black.withValues(alpha: 0.1),
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
                  LucideIcons.check,
                  color: Colors.white,
                  size: 20,
                ),
                label: 'Aplicar',
                function: _submitForm,
              ),
            );
          },
        ),
      ),
    );
  }
}