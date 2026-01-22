import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_floating_message.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/features/catalog/presentation/bloc/catalog_bloc.dart';
import 'package:hibeauty/features/catalog/presentation/components/colorpicker.dart';
import 'package:hibeauty/features/categories/data/model.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum CategoryType { service, product, combo }

Future<void> showAddCategory({
  required BuildContext context,
  required AppLocalizations l10n,
  required CategoryType type,
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
          child: _AddCategoryModal(
            state: context.read<CatalogBloc>().state as CatalogLoaded,
            l10n: l10n,
            type: type,
          ),
        ),
      );
    },
  );
}

class _AddCategoryModal extends StatefulWidget {
  const _AddCategoryModal({required this.state, required this.l10n, required this.type});

  final CatalogLoaded state;
  final AppLocalizations l10n;
  final CategoryType type;

  @override
  State<_AddCategoryModal> createState() => _AddCategoryModalState();
}

class _AddCategoryModalState extends State<_AddCategoryModal>
    with SingleTickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  bool _showHeaderTitle = false;

  late final TextEditingController _nameCtrl;
  late final TextEditingController _descriptionCtrl;
  Color _selectedColor = const Color(0xFF3B82F6);

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _descriptionCtrl = TextEditingController();

    _controller.addListener(() {
      final shouldShow = _controller.offset > 8;
      if (shouldShow != _showHeaderTitle) {
        setState(() => _showHeaderTitle = shouldShow);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  void _submitForm() async {
    // Validação básica
    if (_nameCtrl.text.trim().isEmpty) {
      AppFloatingMessage.show(
        context,
        message: 'Nome da categoria é obrigatório',
        type: AppFloatingMessageType.error,
      );
      return;
    }

    final model = CreateCategorieModel(
      name: _nameCtrl.text.trim(),
      description: _descriptionCtrl.text.trim(),
      color:
          // ignore: deprecated_member_use
          '#${_selectedColor.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
    );

    if (widget.type == CategoryType.service) {
      context.read<CatalogBloc>().add(CreateServiceCategorie(model));
    }

    if (widget.type == CategoryType.product) {
      context.read<CatalogBloc>().add(CreateProductCategorie(model));
    }

    if (widget.type == CategoryType.combo) {
      // context.read<CatalogBloc>().add(CreateServiceCategorie(model));
    }
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
                            'Adicionar categoria',
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
                            const Text(
                              'Adicionar categoria',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Crie uma nova categoria para organizar melhor seus serviços.',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            // Nome
                            AppTextformfield(
                              controller: _nameCtrl,
                              isrequired: true,
                              title: 'Nome da categoria',
                              hintText: 'Ex: Cabelo, Barba, Unhas...',
                              textInputAction: TextInputAction.next,
                            ),

                            const SizedBox(height: 24),
                            CategorieColorPicker(
                              initial: _selectedColor,
                              onChanged: (color) {
                                setState(() => _selectedColor = color);
                              },
                            ),
                            SizedBox(height: 24),

                            AppTextformfield(
                              controller: _descriptionCtrl,
                              title: 'Descrição',
                              hintText: 'Descreva esta categoria...',
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
                    // ignore: deprecated_member_use
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
                  LucideIcons.plus,
                  color: Colors.white,
                  size: 20,
                ),
                label: 'Criar categoria',
                function: _submitForm,
              ),
            );
          },
        ),
      ),
    );
  }
}
