// ignore_for_file: deprecated_member_use

import 'package:hibeauty/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppDropdown extends StatefulWidget {
  final List<Map<String, Object?>> items;
  final String? leadingKey;
  final String labelKey;
  final String? extraLabelKey;
  final String valueKey;
  final Object? selectedValue;
  final ValueChanged<Object?>? onChanged;

  final Widget? leadingAsset;
  final Color? fillColor;
  final Color? labelColor;
  final Color? borderColor;
  final Widget? placeholder;
  final double? width;
  final double? borderWidth;
  final Widget? leading;
  final double? borderRadius;
  final MainAxisAlignment? mainAxisAlignment;
  final int? maxLines;

  final double? dropdownMaxHeight;
  final double? elevation;
  final bool? enabled;
  final String? title;

  final bool multiSelection; // nova flag para multi-selection
  final VoidCallback? onAddPressed; // nova função para botão adicionar

  final bool? isrequired;

  const AppDropdown({
    super.key,
    required this.items,
    required this.labelKey,
    required this.valueKey,
    this.leadingAsset,
    this.selectedValue,
    this.onChanged,
    this.fillColor,
    this.labelColor,
    this.borderColor,
    this.placeholder,
    this.width,
    this.borderWidth,
    this.leading,
    this.borderRadius,
    this.mainAxisAlignment,
    this.maxLines,
    this.dropdownMaxHeight,
    this.elevation,
    this.leadingKey,
    this.extraLabelKey,
    this.enabled,
    this.title = '',
    this.multiSelection = false, // padrão: false
    this.onAddPressed, // função opcional para botão adicionar
    this.isrequired,
  });

  @override
  State<AppDropdown> createState() => _AppDropdownState();
}

class _AppDropdownState extends State<AppDropdown>
    with SingleTickerProviderStateMixin {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;
  late AnimationController _anim;
  late Animation<double> _fade;
  late Animation<double> _expand;
  Size _targetSize = const Size(0, 0);
  // Altura real do menu quando abrindo para cima (para ajustar offset).
  double _menuActualHeightUp = 0;

  Object? _localSelected;
  final Set<Object?> _multiSelected = {};

  ScrollableState? _ancestorScrollable;
  bool _scrollListenerAdded = false;

  bool get _isEnabled => widget.enabled ?? true;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 160),
    );
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _expand = CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _attachScrollClose();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _attachScrollClose();
  }

  void _attachScrollClose() {
    final s = Scrollable.maybeOf(context);
    if (s != null && (!_scrollListenerAdded || s != _ancestorScrollable)) {
      if (_ancestorScrollable != null &&
          // ignore: invalid_use_of_protected_member
          _ancestorScrollable!.position.isScrollingNotifier.hasListeners) {
        _ancestorScrollable!.position.isScrollingNotifier.removeListener(
          _onAnyScroll,
        );
      }
      _ancestorScrollable = s;
      s.position.isScrollingNotifier.addListener(_onAnyScroll);
      _scrollListenerAdded = true;
    }
  }

  void _onAnyScroll() {
    if (_ancestorScrollable?.position.isScrollingNotifier.value == true) {
      _close();
    }
  }

  @override
  void didUpdateWidget(covariant AppDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isEnabled) _close();

    if (oldWidget.selectedValue != widget.selectedValue &&
        widget.selectedValue != null) {
      _localSelected = null;
    }
  }

  @override
  void dispose() {
    _close();
    if (_ancestorScrollable != null) {
      _ancestorScrollable!.position.isScrollingNotifier.removeListener(
        _onAnyScroll,
      );
    }
    _anim.dispose();
    super.dispose();
  }

  void _toggle() {
    if (!_isEnabled) return;
    if (_entry == null) {
      _open();
    } else {
      _close();
    }
  }

  void _size() {
    final box = context.findRenderObject() as RenderBox?;
    if (box != null) {
      _targetSize = box.size;
    }
  }

  void _open() {
    if (!_isEnabled) return;
    _size();

    final mq = MediaQuery.of(context);
    final padding = mq.padding;
    final screenSize = mq.size;

    final box = context.findRenderObject() as RenderBox;
    final targetTopLeft = box.localToGlobal(Offset.zero);
    final targetBottom = targetTopLeft.dy + _targetSize.height;

    final spaceAbove = (targetTopLeft.dy - padding.top) - 16;
    final spaceBelow = (screenSize.height - padding.bottom) - targetBottom - 16;

    final desiredMax = widget.dropdownMaxHeight ?? 320.0;
    final openUp = spaceBelow < 200 && spaceAbove > spaceBelow;
    const gap = 4.0; // espaço padrão entre campo e menu
    final usableAbove = spaceAbove - gap;
    final usableBelow = spaceBelow - gap;
    final maxHeight = (openUp ? usableAbove : usableBelow)
      .clamp(120.0, desiredMax)
      .toDouble();

    // Inicialmente assume altura máxima disponível; ajustaremos depois se menor.
    if (openUp) {
      _menuActualHeightUp = maxHeight;
    }

    final GlobalKey menuKey = GlobalKey();

    _entry = OverlayEntry(
      builder: (ctx) {
        final borderRadius = BorderRadius.circular(widget.borderRadius ?? 8);
        final menuBorder = Border.all(
          width: widget.borderWidth ?? 1,
          color: (widget.borderColor ?? Colors.black.withOpacity(0.1)),
        );

        return Stack(
          children: [
            Positioned.fill(
              child: Listener(
                behavior: HitTestBehavior.translucent,
                onPointerDown: (_) => _close(),
                child: const SizedBox.expand(),
              ),
            ),
            CompositedTransformFollower(
              link: _link,
              showWhenUnlinked: false,
              // Offset the menu depending on direction: if opening up, place it
              // so its bottom edge touches the top edge of the target; if down,
              // place it just below the target.
              offset: Offset(
                0,
                openUp
                    ? -(_menuActualHeightUp + gap)
                    : (_targetSize.height - 20),
              ),
              child: Material(
                type: MaterialType.transparency,
                child: FadeTransition(
                  opacity: _fade,
                  child: SizeTransition(
                    sizeFactor: _expand,
                    axisAlignment: openUp ? 1.0 : -1.0,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: _targetSize.width,
                        maxWidth: _targetSize.width,
                        maxHeight: maxHeight,
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: widget.fillColor ?? Colors.white,
                          borderRadius: borderRadius,
                          border: menuBorder,
                        ),
                        child: ClipRRect(
                          borderRadius: borderRadius,
                          child: _DropdownList(
                            key: menuKey,
                            items: widget.items,
                            leadingKey: widget.leadingKey ?? '',
                            labelKey: widget.labelKey,
                            extraLabelKey: widget.extraLabelKey ?? '',
                            valueKey: widget.valueKey,
                            currentValue: widget.multiSelection
                                ? _multiSelected
                                : _effectiveSelected,
                            multiSelection: widget.multiSelection,
                            onAddPressed: widget.onAddPressed,
                            onClose: _close,
                            onSelect: (v, selected) {
                              if (widget.multiSelection) {
                                setState(() {
                                  if (selected) {
                                    _multiSelected.add(v);
                                  } else {
                                    _multiSelected.remove(v);
                                  }
                                });

                                // força atualização visual do overlay
                                _entry?.markNeedsBuild();

                                widget.onChanged?.call(_multiSelected);
                              } else {
                                if (widget.selectedValue == null) {
                                  setState(() => _localSelected = v);
                                }
                                widget.onChanged?.call(v);
                                _close();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);
    _anim.forward(from: 0);

    // Após primeiro frame do overlay, mede altura real caso esteja abrindo para cima.
    if (openUp) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final renderBox = menuKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final h = renderBox.size.height;
          if (h > 0 && h != _menuActualHeightUp) {
            if (mounted) {
              setState(() {
                _menuActualHeightUp = h;
              });
            }
            _entry?.markNeedsBuild();
          }
        }
      });
    }
  }

  void _close() {
    if (_entry != null) {
      _anim.reverse().whenComplete(() {
        _entry?.remove();
        _entry = null;
      });
    }
  }

  Object? get _effectiveSelected => widget.selectedValue ?? _localSelected;

  Map<String, Object?>? get _selectedItem {
    final val = _effectiveSelected;
    if (val == null) return null;
    try {
      // Procura o item diretamente sem usar orElse que causa problema
      for (final item in widget.items) {
        if (item[widget.valueKey] == val) {
          return item;
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(widget.borderRadius ?? 8);
    final sel = _selectedItem;

    final Widget fieldContent = widget.multiSelection
        ? _SelectedLabelMulti(
            placeholder: widget.placeholder!,
            items: widget.items,
            selectedValues: _multiSelected,
            labelKey: widget.labelKey,
            extraLabelKey: widget.extraLabelKey,
            color: widget.labelColor ?? Colors.black87,
          )
        : (sel == null
              ? (widget.placeholder ??
                    Text(
                      '',
                      maxLines: widget.maxLines ?? 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: widget.labelColor ?? Colors.black87,
                      ),
                    ))
              : _SelectedLabel(
                  label: '${sel[widget.labelKey]}',
                  extra: (widget.extraLabelKey?.isNotEmpty ?? false)
                      ? '${sel[widget.extraLabelKey]}'
                      : null,
                  color: widget.labelColor ?? Colors.black87,
                  maxLines: widget.maxLines ?? 1,
                ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title!.isNotEmpty)
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Row(
                spacing: 4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  if (widget.isrequired == true)
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            ),
          ),
        CompositedTransformTarget(
          link: _link,
          child: IgnorePointer(
            ignoring: !_isEnabled,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 120),
              opacity: _isEnabled ? 1.0 : 0.5,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _isEnabled ? _toggle : null,
                child: Container(
                  width: widget.width,
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: widget.fillColor ?? Colors.white,
                    borderRadius: borderRadius,
                    border: Border.all(
                      width: widget.borderWidth ?? 1,
                      color:
                          widget.borderColor ?? Colors.black.withOpacity(0.1),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      spacing: widget.leading != null ? 5 : 0,
                      mainAxisAlignment:
                          widget.mainAxisAlignment ?? MainAxisAlignment.start,
                      children: [
                        if (widget.leadingAsset != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: widget.leadingAsset!,
                          ),
                        if (widget.leading != null)
                          Opacity(opacity: 0.5, child: widget.leading!),
                        Expanded(child: fieldContent),
                        const Opacity(
                          opacity: 0.5,
                          child: Icon(Icons.arrow_drop_down_sharp),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectedLabel extends StatelessWidget {
  final String label;
  final String? extra;
  final Color color;
  final int maxLines;

  const _SelectedLabel({
    required this.label,
    this.extra,
    required this.color,
    required this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.9,
      child: RichText(
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: color,
          ),
          children: [
            TextSpan(text: label),
            if (extra != null && extra!.isNotEmpty) TextSpan(text: ' ($extra)'),
          ],
        ),
      ),
    );
  }
}

class _SelectedLabelMulti extends StatelessWidget {
  final List<Map<String, Object?>> items;
  final Widget placeholder;
  final Set<Object?> selectedValues;
  final String labelKey;
  final String? extraLabelKey;
  final Color color;

  const _SelectedLabelMulti({
    required this.items,
    required this.placeholder,
    required this.selectedValues,
    required this.labelKey,
    this.extraLabelKey,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    items
        .where((e) => selectedValues.contains(e['value']))
        .map(
          (e) =>
              e[labelKey].toString() +
              (extraLabelKey != null && e[extraLabelKey] != null
                  ? ' (${e[extraLabelKey]})'
                  : ''),
        )
        .join(', ');

    return Opacity(
      opacity: 0.9,
      child: placeholder
    );
  }
}

class _DropdownList extends StatefulWidget {
  final List<Map<String, Object?>> items;
  final String leadingKey;
  final String labelKey;
  final String extraLabelKey;
  final String valueKey;
  final dynamic currentValue;
  final bool multiSelection;
  final VoidCallback? onAddPressed;
  final void Function(Object?, bool) onSelect;
  final VoidCallback? onClose; // função para fechar dropdown

  const _DropdownList({
    super.key,
    required this.items,
    required this.labelKey,
    required this.valueKey,
    required this.currentValue,
    required this.onSelect,
    required this.leadingKey,
    required this.extraLabelKey,
    this.multiSelection = false,
    this.onAddPressed,
    this.onClose,
  });

  @override
  State<_DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<_DropdownList> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildLeadingWidget(String? leadingValue) {
    if (leadingValue == null || leadingValue.isEmpty) {
      return const SizedBox.shrink();
    }

    // Verifica se é um código de cor (começa com #)
    if (leadingValue.startsWith('#')) {
      try {
        final color = Color(int.parse(leadingValue.replaceAll('#', '0xff')));
        return Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        );
      } catch (e) {
        return const SizedBox.shrink();
      }
    }

    // Se não for cor, assume que é URL de bandeira (comportamento original)
    return SvgPicture.network(
      'https://flagicons.lipis.dev/flags/4x3/${leadingValue.split('/').last}',
      width: 15,
    );
  }

  Widget _buildAddButton() {
    return InkWell(
      onTap: () {
        widget.onAddPressed?.call();
        widget.onClose?.call(); // Fechar dropdown
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          spacing: 8,
          children: [
            Icon(
              Icons.add,
              size: 16,
              color: Colors.blue,
            ),
            Expanded(
              child: Text(
                'Adicionar',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const _NoGlowBehavior(),
      child: RawScrollbar(
        controller: _controller,
        thumbVisibility: true,
        trackVisibility: false,
        minThumbLength: 80,
        padding: const EdgeInsets.symmetric(vertical: 0),
        radius: const Radius.circular(4),
        thickness: 4,
        thumbColor: Colors.black.withOpacity(0.25),
        child: ListView.builder(
          controller: _controller,
          // Remove vertical padding to avoid extra perceived gap below field
          padding: EdgeInsets.zero,
          primary: false,
          shrinkWrap: true,
          itemCount: widget.items.length + (widget.onAddPressed != null ? 1 : 0),
          itemBuilder: (ctx, i) {
            // Se for o último item e onAddPressed não for null, mostrar botão adicionar
            if (i == widget.items.length && widget.onAddPressed != null) {
              return _buildAddButton();
            }
            
            final item = widget.items[i];
            final value = item[widget.valueKey];
            final isSelected = widget.multiSelection
                ? (widget.currentValue as Set<Object?>).contains(value)
                : widget.currentValue != null && widget.currentValue == value;

            return InkWell(
              onTap: () => widget.onSelect(value, !isSelected),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    if (widget.leadingKey.isNotEmpty)
                      _buildLeadingWidget(item[widget.leadingKey] as String?),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.90),
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                          children: [
                            TextSpan(text: '${item[widget.labelKey]}'),
                            if (widget.extraLabelKey.isNotEmpty)
                              TextSpan(
                                text: ' (${item[widget.extraLabelKey]})',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (widget.multiSelection) ...[
                      if (!isSelected)
                        Icon(
                          Icons.check_box_outline_blank_rounded,
                          size: 18,
                          color: Colors.black.withValues(alpha: 0.3),
                        ),
                      if (isSelected)
                        Icon(
                          Icons.check_box_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                    ],
                    if (!widget.multiSelection) ...[
                      if (isSelected)
                        Icon(Icons.check, size: 18, color: AppColors.primary),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NoGlowBehavior extends ScrollBehavior {
  const _NoGlowBehavior();
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
