import 'dart:io';
import 'package:flutter/material.dart';
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
    bool enableCrop = true, // permite desabilitar o crop se necessário
  }) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: imageSource,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (pickedFile == null) return null;

      // Verifica extensão, se a lista for passada
      if (allowedExtensions != null && allowedExtensions.isNotEmpty) {
        final extension = pickedFile.path.split('.').last.toLowerCase();
        if (!allowedExtensions.contains(extension)) {
          if (context.mounted) {
            AppFloatingMessage.show(
              context,
              message: 'Tipo de arquivo inválido',
              type: AppFloatingMessageType.error,
            );
          }
          return null;
        }
      }

      // Se crop estiver desabilitado, retorna o arquivo direto
      if (!enableCrop) {
        return File(pickedFile.path);
      }

      // Tenta fazer o crop da imagem
      try {
        final cropped = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
          maxWidth: 1024,
          maxHeight: 1024,
          compressQuality: 85,
          compressFormat: ImageCompressFormat.jpg,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: l10n.moveAndResize,
              lockAspectRatio: true,
              initAspectRatio: CropAspectRatioPreset.square,
              statusBarColor: Colors.deepPurple,
              toolbarColor: Colors.deepPurple,
              toolbarWidgetColor: Colors.white,
              backgroundColor: Colors.white,
              activeControlsWidgetColor: Colors.deepPurple,
              dimmedLayerColor: Colors.black.withOpacity(0.5),
            ),
            IOSUiSettings(
              title: l10n.moveAndResize,
              doneButtonTitle: l10n.save,
              cancelButtonTitle: l10n.cancel,
              aspectRatioLockEnabled: true,
              resetAspectRatioEnabled: false,
            ),
          ],
        );

        if (cropped == null) return null;
        return File(cropped.path);
      } catch (cropError) {
        print('Erro no crop, usando imagem original: $cropError');
        // Se o crop falhar, usa a imagem original
        return File(pickedFile.path);
      }

    } catch (e) {
      print('Erro ao selecionar imagem: $e');
      if (context.mounted) {
        AppFloatingMessage.show(
          context,
          message: 'Erro ao selecionar imagem. Tente novamente.',
          type: AppFloatingMessageType.error,
        );
      }
      return null;
    }
  }
  }
