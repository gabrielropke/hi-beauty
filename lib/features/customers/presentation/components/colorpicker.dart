import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CustomerColorSelector extends StatefulWidget {
  final Color initial;
  final ValueChanged<Color> onChanged;
  const CustomerColorSelector({
    super.key,
    required this.initial,
    required this.onChanged,
  });

  @override
  State<CustomerColorSelector> createState() => _CustomerColorSelectorState();
}

class _CustomerColorSelectorState extends State<CustomerColorSelector> {
  late Color _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initial;
  }

  String _hex(Color c) =>
      // ignore: deprecated_member_use
      '#${c.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

  void _openPicker() {
    Color temp = _selected;
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: temp,
              onColorChanged: (c) => temp = c,
              colorPickerWidth: 300,
              pickerAreaHeightPercent: 0.7,
              enableAlpha: false,
              hexInputBar: true,
              // ignore: deprecated_member_use
              showLabel: false,
              labelTypes: const [ColorLabelType.hex],
              pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() => _selected = temp);
                widget.onChanged(_selected);
                Navigator.pop(ctx);
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Text(
          'Cor do tema',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Text(
          'Defina uma cor personalizada para este colaborador.',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
        ),
        GestureDetector(
          onTap: _openPicker,
          child: Row(
            spacing: 12,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 61,
                    height: 61,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.8),
                        width: 1,
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _selected,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  const Text(
                    'Cor personalizada',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    _hex(_selected),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
