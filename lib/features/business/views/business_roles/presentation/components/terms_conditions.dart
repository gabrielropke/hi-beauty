import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hibeauty/features/business/data/model.dart';
import 'package:hibeauty/features/business/views/business_roles/presentation/components/modal.dart';

class TermsConditionsModal extends StatefulWidget {
  final BusinessRulesResponseModel roles;
  const TermsConditionsModal({super.key, required this.roles});

  @override
  State<TermsConditionsModal> createState() => _TermsConditionsModalState();
}

class _TermsConditionsModalState extends State<TermsConditionsModal> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final htmlContent = widget.roles.businessRules.termsAndConditions ?? '';
    
    if (htmlContent.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum termo e condição definido',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.black54,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Termos e Condições',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Text(
                  _isExpanded ? 'Ocultar' : 'Exibir',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Conteúdo',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () => _showEditModal(context),
                    //   child: Container(
                    //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    //     decoration: BoxDecoration(
                    //       color: Colors.blue[50],
                    //       borderRadius: BorderRadius.circular(6),
                    //       border: Border.all(color: Colors.blue[200]!),
                    //     ),
                    //     child: const Text(
                    //       'Editar conteúdo',
                    //       style: TextStyle(
                    //         fontSize: 11,
                    //         color: Colors.blue,
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(height: 12),
                Html(
                  data: htmlContent,
                  style: {
                    "body": Style(
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                      fontSize: FontSize(14),
                      lineHeight: const LineHeight(1.5),
                    ),
                    "h1, h2, h3, h4, h5, h6": Style(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                    ),
                    "p": Style(
                      margin: Margins.only(bottom: 12),
                      fontSize: FontSize(14),
                      lineHeight: const LineHeight(1.6),
                    ),
                    "strong": Style(
                      fontWeight: FontWeight.w600,
                    ),
                    "div": Style(
                      margin: Margins.only(bottom: 16),
                    ),
                  },
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ignore: unused_element
  void _showEditModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (context) => EditTermsModal(
        initialContent: widget.roles.businessRules.termsAndConditions ?? '',
        onSave: (newContent) {
          // Aqui você implementaria a lógica para salvar o novo conteúdo
          Navigator.pop(context);
        },
      ),
    );
  }
}