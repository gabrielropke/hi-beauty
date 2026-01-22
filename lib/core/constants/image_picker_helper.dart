import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:hibeauty/core/components/app_floating_message.dart';
import 'package:hibeauty/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImagePickerHelper {
  final ImagePicker _picker = ImagePicker();

  /// Seleciona uma imagem opcionalmente filtrando por extensões
  Future<File?> pickImage({
    required BuildContext context,
    required AppLocalizations l10n,
    required ImageSource imageSource,
    List<String>?
    allowedExtensions, // extensões permitidas (ex: ['jpg','jpeg','png'])
  }) async {
    final pickedFile = await _picker.pickImage(source: imageSource);
    if (pickedFile == null) return null;

    // Verifica extensão, se a lista for passada
    if (allowedExtensions != null && allowedExtensions.isNotEmpty) {
      final extension = pickedFile.path.split('.').last.toLowerCase();
      if (!allowedExtensions.contains(extension)) {
        AppFloatingMessage.show(
          context,
          message: 'Tipo de arquivo inválido',
          type: AppFloatingMessageType.error,
        );
        return null;
      }
    }

    final cropped = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: l10n.moveAndResize,
          lockAspectRatio: true,
          initAspectRatio: CropAspectRatioPreset.square,
        ),
        IOSUiSettings(
          title: l10n.moveAndResize,
          doneButtonTitle: l10n.save,
          cancelButtonTitle: l10n.cancel,
        ),
      ],
    );

    if (cropped == null) return null;

    return File(cropped.path);
  }
}
