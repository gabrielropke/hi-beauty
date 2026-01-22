import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hibeauty/core/constants/image_picker_helper.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:dotted_border/dotted_border.dart';

class BusinessImagePicker extends StatefulWidget {
  final String label;
  final String description;
  final File? image;
  final String? networkImage;
  final bool isCover;
  final ValueChanged<File> onPicked;

  const BusinessImagePicker({
    super.key,
    required this.label,
    required this.description,
    required this.image,
    required this.networkImage,
    required this.isCover,
    required this.onPicked,
  });

  @override
  State<BusinessImagePicker> createState() => _BusinessImagePickerState();
}

class _BusinessImagePickerState extends State<BusinessImagePicker> {
  bool _hideHint = false;
  final _helper = ImagePickerHelper();

  Future<void> _pick() async {
    final l10n = AppLocalizations.of(context)!;
    final file = await _helper.pickImage(
      context: context,
      l10n: l10n,
      imageSource: ImageSource.gallery,
      allowedExtensions: ['jpg','jpeg','png'],
    );
    if (mounted) {
      if (file != null) _hideHint = true; // oculta dica após seleção
      if (file != null) widget.onPicked(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ImageProvider? imageProvider = widget.image != null
        ? FileImage(widget.image!)
        : (widget.networkImage != null && widget.networkImage!.isNotEmpty
              ? NetworkImage(widget.networkImage!)
              : null);


    final showHint = !_hideHint && imageProvider == null;

    Widget visual = widget.isCover
        ? DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: const Radius.circular(16),
              dashPattern: const [4, 3],
              color: Colors.black26,
              strokeWidth: 1,
            ),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    image: imageProvider != null
                        ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
                        : null,
                  ),
                ),
                if (showHint)
                  Positioned.fill(
                    child: AnimatedOpacity(
                      opacity: 1,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 6,
                            children: const [
                              Icon(Icons.touch_app,
                                  size: 28, color: Colors.white),
                              Text(
                                'Toque para escolher a capa',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          )
        : DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: const Radius.circular(16),
              dashPattern: const [4, 3],
              color: Colors.black26,
              strokeWidth: 1,
            ),
            child: Stack(
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    image: imageProvider != null
                        ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
                        : null,
                  ),
                ),
                if (showHint)
                  Positioned.fill(
                    child: AnimatedOpacity(
                      opacity: 1,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 6,
                            children: const [
                              Icon(Icons.touch_app,
                                  size: 28, color: Colors.white),
                              Text(
                                'Toque para escolher a logo',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 8,
            children: [
              Icon(LucideIcons.camera, size: 20),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            widget.description,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 12),
          GestureDetector(
            onTap: _pick,
            child: visual,
          ),
          if (imageProvider != null)
            TextButton(
              onPressed: _pick,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                foregroundColor: Colors.blue,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: const Text(
                  'Alterar imagem',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
