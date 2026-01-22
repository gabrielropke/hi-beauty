import 'package:flutter/material.dart';
import 'package:hibeauty/core/components/app_back_button.dart';

class CustomAppBar extends StatefulWidget {
  final String title;
  final ScrollController? controller;
  final Widget? leading;
  final List<Widget>? actions;
  final double threshold;
  final bool pinned;
  final Color? backgroundColor;
  final bool? fixShowTitle;
  final bool? safeAreaTopOn;
  const CustomAppBar({
    super.key,
    required this.title,
    this.controller,
    this.leading,
    this.actions,
    this.threshold = 8,
    this.pinned = true,
    this.backgroundColor,
    this.fixShowTitle,
    this.safeAreaTopOn = true,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _showTitle = false;

  void _listen() {
    final controller = widget.controller;
    if (controller == null || !controller.hasClients) return;

    final shouldShow = controller.offset > widget.threshold;
    if (shouldShow != _showTitle) {
      setState(() => _showTitle = shouldShow);
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_listen);
  }

  @override
  void didUpdateWidget(covariant CustomAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_listen);
      widget.controller?.addListener(_listen);
      _listen();
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_listen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bar = SafeArea(
      top: widget.safeAreaTopOn ?? true,
      bottom: false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: 56,
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? Colors.transparent,
          border: _showTitle
              ? Border(
                  bottom: BorderSide(
                    color: Colors.black.withValues(alpha: 0.08),
                    width: 1,
                  ),
                )
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            widget.leading ?? AppBackButton(),
            Expanded(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                opacity: widget.fixShowTitle == true ? 1 : (_showTitle ? 1 : 0),
                child: IgnorePointer(
                  ignoring: !_showTitle,
                  child: Text(
                    widget.title,
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
            if (widget.actions != null) ...widget.actions!,
          ],
        ),
      ),
    );

    if (widget.pinned) return bar;

    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        if (widget.controller != null) return false; // usando controller
        final shouldShow = n.metrics.pixels > widget.threshold;
        if (shouldShow != _showTitle) {
          setState(() => _showTitle = shouldShow);
        }
        return false;
      },
      child: bar,
    );
  }
}
