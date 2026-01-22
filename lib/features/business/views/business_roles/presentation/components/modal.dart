import 'package:flutter/material.dart';

// Classe para armazenar ranges de formatação
class FormatRange {
  final int start;
  final int end;
  
  FormatRange(this.start, this.end);
  
  bool contains(int offset) => offset >= start && offset <= end;
  bool overlaps(FormatRange other) => start < other.end && end > other.start;
}

class EditTermsModal extends StatefulWidget {
  final String initialContent;
  final Function(String) onSave;

  const EditTermsModal({super.key, 
    required this.initialContent,
    required this.onSave,
  });

  @override
  State<EditTermsModal> createState() => EditTermsModalState();
}

class EditTermsModalState extends State<EditTermsModal> {
  late TextEditingController _controller;
  final List<FormatRange> _boldRanges = [];
  final List<FormatRange> _italicRanges = [];

  // Função para extrair texto puro do HTML
  String _htmlToPlainText(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .trim();
  }

  @override
  void initState() {
    super.initState();
    // Converter HTML para texto puro ao iniciar
    final plainText = _htmlToPlainText(widget.initialContent);
    _controller = TextEditingController(text: plainText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleBold() {
    final selection = _controller.selection;
    
    if (selection.isValid && !selection.isCollapsed) {
      final range = FormatRange(selection.start, selection.end);
      
      // Verificar se já existe formatação bold neste range
      final existingRangeIndex = _boldRanges.indexWhere(
        (r) => r.start == range.start && r.end == range.end,
      );
      
      setState(() {
        if (existingRangeIndex != -1) {
          // Remover bold
          _boldRanges.removeAt(existingRangeIndex);
        } else {
          // Adicionar bold
          _boldRanges.add(range);
        }
      });
    }
  }

  void _toggleItalic() {
    final selection = _controller.selection;
    
    if (selection.isValid && !selection.isCollapsed) {
      final range = FormatRange(selection.start, selection.end);
      
      // Verificar se já existe formatação italic neste range
      final existingRangeIndex = _italicRanges.indexWhere(
        (r) => r.start == range.start && r.end == range.end,
      );
      
      setState(() {
        if (existingRangeIndex != -1) {
          // Remover italic
          _italicRanges.removeAt(existingRangeIndex);
        } else {
          // Adicionar italic
          _italicRanges.add(range);
        }
      });
    }
  }

  String _convertToHtml(String plainText) {
    return plainText
        .replaceAll('\n\n', '</p><p>')
        .replaceAll('\n', '<br>')
        .replaceAll(RegExp(r'\*\*(.*?)\*\*'), '<strong>${1}</strong>')
        .replaceAll(RegExp(r'\*(.*?)\*'), '<em>${1}</em>')
        .replaceAll(RegExp(r'__(.*?)__'), '<strong>${1}</strong>')
        .replaceAll(RegExp(r'_(.*?)_'), '<em>${1}</em>');
  }

  Widget _buildFormattingToolbar() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          _buildToolbarButton(
            icon: Icons.format_bold,
            onPressed: _toggleBold,
            tooltip: 'Negrito',
          ),
          const SizedBox(width: 8),
          _buildToolbarButton(
            icon: Icons.format_italic,
            onPressed: _toggleItalic,
            tooltip: 'Itálico',
          ),
          const SizedBox(width: 8),
          _buildToolbarButton(
            icon: Icons.format_list_bulleted,
            onPressed: () => _toggleBulletPoint(),
            tooltip: 'Lista',
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              icon,
              size: 20,
              color: Colors.grey[700],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleBulletPoint() {
    final text = _controller.text;
    final cursorPos = _controller.selection.baseOffset;
    
    // Encontrar o início da linha atual
    int lineStart = text.lastIndexOf('\n', cursorPos - 1);
    if (lineStart == -1) {
      lineStart = 0;
    } else {
      lineStart += 1;
    }
    
    // Encontrar o final da linha atual
    int lineEnd = text.indexOf('\n', cursorPos);
    if (lineEnd == -1) lineEnd = text.length;
    
    final currentLine = text.substring(lineStart, lineEnd);
    
    String newText;
    int newCursorPos;
    
    if (currentLine.startsWith('• ')) {
      // Remover bullet se já existe
      newText = text.replaceRange(lineStart, lineStart + 2, '');
      newCursorPos = cursorPos - 2;
    } else {
      // Adicionar bullet se não existe
      newText = text.replaceRange(lineStart, lineStart, '• ');
      newCursorPos = cursorPos + 2;
    }
    
    _controller.text = newText;
    _controller.selection = TextSelection.collapsed(
      offset: newCursorPos.clamp(0, newText.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final safeAreaHeight = MediaQuery.of(context).size.height - 
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom;
    
    return Container(
      height: safeAreaHeight * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Editar Termos e Condições',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          
          // Toolbar de formatação
          _buildFormattingToolbar(),
          
          // Conteúdo principal - sempre preview editável
          Expanded(
            child: _buildEditablePreview(),
          ),
          
          // Botões de ação
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Converter o texto simples para HTML
                    final htmlContent = '<p>${_convertToHtml(_controller.text)}</p>';
                    widget.onSave(htmlContent);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditablePreview() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Use os botões acima para formatar o texto:',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _RichTextField(
              controller: _controller,
              boldRanges: _boldRanges,
              italicRanges: _italicRanges,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget customizado para TextField com formatação rica
class _RichTextField extends StatefulWidget {
  final TextEditingController controller;
  final List<FormatRange> boldRanges;
  final List<FormatRange> italicRanges;

  const _RichTextField({
    required this.controller,
    required this.boldRanges,
    required this.italicRanges,
  });

  @override
  State<_RichTextField> createState() => _RichTextFieldState();
}

class _RichTextFieldState extends State<_RichTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // TextField invisível para capturar input
          TextField(
            controller: widget.controller,
            maxLines: null,
            expands: true,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Colors.transparent, // Texto invisível
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
          // RichText visível sobreposto
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: AnimatedBuilder(
                animation: widget.controller,
                builder: (context, child) {
                  return RichText(
                    text: _buildTextSpan(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextSpan _buildTextSpan() {
    final text = widget.controller.text;
    if (text.isEmpty) {
      return const TextSpan(
        text: 'Digite seus termos e condições aqui...',
        style: TextStyle(
          fontSize: 14,
          height: 1.4,
          color: Colors.grey,
        ),
      );
    }

    final spans = <TextSpan>[];
    int currentIndex = 0;

    // Criar lista de todos os ranges com seus tipos
    final allRanges = <Map<String, dynamic>>[];
    
    for (final range in widget.boldRanges) {
      allRanges.add({
        'start': range.start,
        'end': range.end,
        'type': 'bold',
      });
    }
    
    for (final range in widget.italicRanges) {
      allRanges.add({
        'start': range.start,
        'end': range.end,
        'type': 'italic',
      });
    }

    // Ordenar por posição inicial
    allRanges.sort((a, b) => a['start'].compareTo(b['start']));

    for (final range in allRanges) {
      final start = range['start'] as int;
      final end = range['end'] as int;
      final type = range['type'] as String;

      // Adicionar texto antes do range formatado
      if (start > currentIndex) {
        spans.add(TextSpan(
          text: text.substring(currentIndex, start),
          style: const TextStyle(
            fontSize: 14,
            height: 1.4,
            color: Colors.black,
          ),
        ));
      }

      // Adicionar texto formatado
      if (start < text.length && end <= text.length) {
        spans.add(TextSpan(
          text: text.substring(start, end),
          style: TextStyle(
            fontSize: 14,
            height: 1.4,
            color: Colors.black,
            fontWeight: type == 'bold' ? FontWeight.bold : FontWeight.normal,
            fontStyle: type == 'italic' ? FontStyle.italic : FontStyle.normal,
          ),
        ));
        currentIndex = end;
      }
    }

    // Adicionar texto restante
    if (currentIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentIndex),
        style: const TextStyle(
          fontSize: 14,
          height: 1.4,
          color: Colors.black,
        ),
      ));
    }

    return TextSpan(children: spans.isEmpty ? [
      TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 14,
          height: 1.4,
          color: Colors.black,
        ),
      )
    ] : spans);
  }
}