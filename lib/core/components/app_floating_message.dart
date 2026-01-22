import 'dart:io';

import 'package:flutter/material.dart';

enum AppFloatingMessageType { success, error, warning }

class AppFloatingMessage extends StatefulWidget {
  final String message;
  final AppFloatingMessageType type;
  final Duration duration;

  const AppFloatingMessage({
    super.key,
    required this.message,
    required this.type,
    this.duration = const Duration(seconds: 3),
  });

  static void show(
    BuildContext context, {
    required String message,
    required AppFloatingMessageType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (_) => AppFloatingMessage(message: message, type: type, duration: duration),
    );
    overlay.insert(entry);
  }

  @override
  State<AppFloatingMessage> createState() => _AppFloatingMessageState();
}

class _AppFloatingMessageState extends State<AppFloatingMessage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  bool _dismissed = false;

  Color get _color {
    switch (widget.type) {
      case AppFloatingMessageType.success:
        return Colors.green;
      case AppFloatingMessageType.error:
        return Colors.red;
      case AppFloatingMessageType.warning:
        return Colors.amber[700]!;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 280));
    _slide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(_controller);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
    Future.delayed(widget.duration, () async {
      if (!mounted) return;
      await _controller.reverse();
      if (mounted) setState(() => _dismissed = true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: Platform.isAndroid ? 12 : 4,
      left: 0,
      right: 0,
      child: IgnorePointer(
        ignoring: _dismissed,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SlideTransition(
              position: _slide,
              child: FadeTransition(
                opacity: _fade,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  color: _color,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Icon(
                          widget.type == AppFloatingMessageType.success
                              ? Icons.check_circle
                              : widget.type == AppFloatingMessageType.error
                                  ? Icons.error
                                  : Icons.warning_amber_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            await _controller.reverse();
                            if (mounted) setState(() => _dismissed = true);
                          },
                          child: const Icon(Icons.close, color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}