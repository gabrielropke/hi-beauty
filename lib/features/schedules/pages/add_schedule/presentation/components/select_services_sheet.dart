import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_button.dart';
import 'package:hibeauty/core/components/app_textformfield.dart';
import 'package:hibeauty/features/catalog/data/model.dart';
import 'package:hibeauty/features/schedules/pages/add_schedule/presentation/bloc/add_schedule_bloc.dart';
import 'package:hibeauty/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

Future<void> showSelectServicesSheet({
  required BuildContext context,
  required AddScheduleLoaded state,
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
        value: context.read<AddScheduleBloc>(),
        child: Container(
          color: Colors.white,
          child: SelectServicesSheet(state: state),
        ),
      );
    },
  );
}

class SelectServicesSheet extends StatefulWidget {
  final AddScheduleLoaded state;
  const SelectServicesSheet({super.key, required this.state});

  @override
  State<SelectServicesSheet> createState() => _SelectServicesSheetState();
}

class _SelectServicesSheetState extends State<SelectServicesSheet>
    with SingleTickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  late final TextEditingController _searchCtrl;
  late final TabController _tabController;
  bool _showHeaderTitle = false;

  // Selected items
  List<ServicesModel> _selectedServices = [];
  List<ProductsModel> _selectedProducts = [];
  List<CombosModel> _selectedCombos = [];

  // Current tab index
  int _currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _searchCtrl = TextEditingController();
    _tabController = TabController(length: 3, vsync: this);
    _controller.addListener(() {
      final shouldShow = _controller.offset > 8;
      if (shouldShow != _showHeaderTitle) {
        setState(() => _showHeaderTitle = shouldShow);
      }
    });

    // Initialize with already selected items
    _selectedServices = List.from(widget.state.selectedServices);
    _selectedProducts = List.from(widget.state.selectedProducts);
    _selectedCombos = List.from(widget.state.selectedCombos);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  String get _currentStepTitle {
    return 'Selecione os itens';
  }

  List<ServicesModel> _filteredServices() {
    final query = _searchCtrl.text.trim().toLowerCase();
    if (query.isEmpty) {
      return widget.state.services;
    }

    return widget.state.services.where((service) {
      return service.name.toLowerCase().contains(query);
    }).toList();
  }

  List<ProductsModel> _filteredProducts() {
    final query = _searchCtrl.text.trim().toLowerCase();
    if (query.isEmpty) {
      return widget.state.products;
    }

    return widget.state.products.where((product) {
      return product.name.toLowerCase().contains(query);
    }).toList();
  }

  List<CombosModel> _filteredCombos() {
    final query = _searchCtrl.text.trim().toLowerCase();
    if (query.isEmpty) {
      return widget.state.combos;
    }

    return widget.state.combos.where((combo) {
      return combo.name.toLowerCase().contains(query);
    }).toList();
  }

  void _toggleServiceSelection(ServicesModel service) {
    setState(() {
      if (_selectedServices.contains(service)) {
        _selectedServices.remove(service);
      } else {
        _selectedServices.add(service);
      }
    });
  }

  void _toggleProductSelection(ProductsModel product) {
    setState(() {
      if (_selectedProducts.contains(product)) {
        _selectedProducts.remove(product);
      } else {
        _selectedProducts.add(product);
      }
    });
  }

  void _toggleComboSelection(CombosModel combo) {
    setState(() {
      if (_selectedCombos.contains(combo)) {
        _selectedCombos.remove(combo);
      } else {
        _selectedCombos.add(combo);
      }
    });
  }

  int get _totalSelectedItems {
    return _selectedServices.length +
        _selectedProducts.length +
        _selectedCombos.length;
  }

  void _confirmSelection() {
    context.read<AddScheduleBloc>().add(
      SelectServices(
        services: _selectedServices,
        products: _selectedProducts,
        combos: _selectedCombos,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          _buildHeader(),
          _buildDivider(),
          _buildTitle(),
          _buildCustomTabBar(),
          Expanded(
            child: IndexedStack(
              index: _currentTabIndex,
              children: [
                _buildServicesTab(),
                _buildCombosTab(),
                _buildProductsTab(),
              ],
            ),
          ),
          _buildBottomAction(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 16, 0),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Expanded(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              opacity: _showHeaderTitle ? 1 : 0,
              child: IgnorePointer(
                ignoring: !_showHeaderTitle,
                child: Text(
                  _currentStepTitle,
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
    );
  }

  Widget _buildDivider() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      opacity: _showHeaderTitle ? 1 : 0,
      child: Divider(thickness: 1, color: Colors.grey[300], height: 5),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          _currentStepTitle,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildTabContainer(
              'Serviços (${_selectedServices.length})',
              0,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTabContainer('Combos (${_selectedCombos.length})', 1),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTabContainer(
              'Produtos (${_selectedProducts.length})',
              2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContainer(String title, int index) {
    final isSelected = _currentTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTabIndex = index;
          _searchCtrl.clear();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildServicesTab() {
    final filteredServices = _filteredServices();

    return SingleChildScrollView(
      controller: _controller,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          AppTextformfield(
            controller: _searchCtrl,
            borderRadius: 12,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 4),
              child: Icon(LucideIcons.search, size: 18, color: Colors.black54),
            ),
            hintText: 'Buscar serviços',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 24),
          if (filteredServices.isEmpty && _searchCtrl.text.isNotEmpty)
            const Text(
              'Nenhum resultado encontrado',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            )
          else
            for (int i = 0; i < filteredServices.length; i++) ...[
              _buildServiceTile(filteredServices[i]),
              if (i < filteredServices.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Divider(
                    height: 20,
                    thickness: 1,
                    color: Colors.black.withValues(alpha: 0.06),
                  ),
                ),
            ],
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildCombosTab() {
    final filteredCombos = _filteredCombos();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          AppTextformfield(
            controller: _searchCtrl,
            borderRadius: 12,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 4),
              child: Icon(LucideIcons.search, size: 18, color: Colors.black54),
            ),
            hintText: 'Buscar combos',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 24),
          if (filteredCombos.isEmpty && _searchCtrl.text.isNotEmpty)
            const Text(
              'Nenhum resultado encontrado',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            )
          else
            for (int i = 0; i < filteredCombos.length; i++) ...[
              _buildComboTile(filteredCombos[i]),
              if (i < filteredCombos.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Divider(
                    height: 20,
                    thickness: 1,
                    color: Colors.black.withValues(alpha: 0.06),
                  ),
                ),
            ],
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    final filteredProducts = _filteredProducts();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          AppTextformfield(
            controller: _searchCtrl,
            borderRadius: 12,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, right: 4),
              child: Icon(LucideIcons.search, size: 18, color: Colors.black54),
            ),
            hintText: 'Buscar produtos',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 24),
          if (filteredProducts.isEmpty && _searchCtrl.text.isNotEmpty)
            const Text(
              'Nenhum resultado encontrado',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            )
          else
            for (int i = 0; i < filteredProducts.length; i++) ...[
              _buildProductTile(filteredProducts[i]),
              if (i < filteredProducts.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Divider(
                    height: 20,
                    thickness: 1,
                    color: Colors.black.withValues(alpha: 0.06),
                  ),
                ),
            ],
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildServiceTile(ServicesModel service) {
    final isSelected = _selectedServices.contains(service);

    return GestureDetector(
      onTap: () => _toggleServiceSelection(service),
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 4,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  Row(
                    children: [
                      Text(
                        'R\$ ${service.price.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      Text(
                        service.duration >= 61
                            ? ' •  ${(service.duration / 61).floor()}h${service.duration % 61 > 0 ? ' ${service.duration % 61} min' : ''}'
                            : ' •  ${service.duration} min',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade400,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 12)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductTile(ProductsModel product) {
    final isSelected = _selectedProducts.contains(product);

    return GestureDetector(
      onTap: () => _toggleProductSelection(product),
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 4,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'R\$ ${product.price.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ],
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade400,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 12)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComboTile(CombosModel combo) {
    final isSelected = _selectedCombos.contains(combo);

    return GestureDetector(
      onTap: () => _toggleComboSelection(combo),
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 4,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.purple.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(32),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          combo.name,
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'R\$ ${combo.price.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ],
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade400,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 12)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              label: _totalSelectedItems > 0
                  ? 'Confirmar ($_totalSelectedItems ${_totalSelectedItems == 1 ? 'item' : 'itens'})'
                  : 'Confirmar seleção',
              function: _confirmSelection,
              fillColor: _totalSelectedItems > 0
                  ? AppColors.primary
                  : Colors.grey.shade300,
              labelStyle: TextStyle(
                color: _totalSelectedItems > 0
                    ? Colors.white
                    : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
