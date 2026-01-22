import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/core/components/app_back_button.dart';
import 'package:hibeauty/core/data/business.dart';
import 'package:hibeauty/features/functions/presentation/components/card.dart';

class PrePageFunctionsArgs {
  final String title;
  final List<FunctionsCardOption> options;
  final IconData leadingIcon;
  final String titlePage;
  final String descriptionPage;
  const PrePageFunctionsArgs({
    required this.title,
    required this.options,
    required this.leadingIcon,
    required this.titlePage,
    required this.descriptionPage,
  });
}

class PrePageFunctions extends StatefulWidget {
  final PrePageFunctionsArgs args;
  const PrePageFunctions({super.key, required this.args});

  @override
  State<PrePageFunctions> createState() => _PrePageFunctionsState();
}

class _PrePageFunctionsState extends State<PrePageFunctions> {
  final ScrollController _controller = ScrollController();
  bool _showCompactTitle = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final shouldShow = _controller.offset > 8;
      if (shouldShow != _showCompactTitle) {
        setState(() => _showCompactTitle = shouldShow);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = widget.args;
    return Scaffold(
      // HEADER AGORA EM appBar (resolve sobreposição com status bar)
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                const AppBackButton(),
                Expanded(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    opacity: _showCompactTitle ? 1 : 0,
                    child: IgnorePointer(
                      ignoring: !_showCompactTitle,
                      child: Text(
                        args.titlePage,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // REMOVIDO HEADER DO BODY
            // const SizedBox(height: 12) substituído por padding interno
            Expanded(
              child: SingleChildScrollView(
                controller: _controller,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    // título completo só quando no topo
                    if (!_showCompactTitle)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Text(
                            args.titlePage,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            '${args.descriptionPage} ${BusinessData.name}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(color: Colors.black.withValues(alpha: 0.08), width: 1),
                      ),
                      child: Column(
                        spacing: 24,
                        children: args.options.map((o) {
                          final disabled = o.disable;
                          return InkWell(
                            onTap: disabled
                                ? null
                                : () {
                                    if (o.route != null) context.push(o.route!);
                                    o.onTap?.call();
                                  },
                            borderRadius: BorderRadius.circular(10),
                            splashColor: disabled ? Colors.transparent : null,
                            highlightColor: disabled ? Colors.transparent : null,
                            child: Row(
                              children: [
                                Opacity(
                                  opacity: disabled ? 0.4 : 1,
                                  child: Icon(o.icon, size: 22, color: Colors.black87),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Opacity(
                                    opacity: disabled ? 0.4 : 1,
                                    child: Text(
                                      o.label,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                                if (o.inDevelopment)
                                  Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(32),
                                      border: Border.all(color: Colors.orange.withValues(alpha: 0.5), width: 1),
                                    ),
                                    child: const Text(
                                      'Em breve',
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14,
                                  color: Colors.black.withValues(alpha: 0.5),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
