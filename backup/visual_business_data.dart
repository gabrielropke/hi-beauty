// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hibeauty/core/components/app_dropdown.dart';
// import 'package:hibeauty/core/components/app_textformfield.dart';
// import 'package:hibeauty/core/constants/default_values/colors.dart';
// import 'package:hibeauty/core/constants/default_values/segments.dart';
// import 'package:hibeauty/features/onboarding/presentation/bloc/onboarding_bloc.dart';
// import 'package:hibeauty/features/onboarding/presentation/components/favorite_color.dart';
// import 'package:hibeauty/features/onboarding/presentation/components/images.dart';
// import 'package:hibeauty/l10n/app_localizations.dart';
// import 'package:hibeauty/theme/app_colors.dart';

// class VisualBusinessData extends StatefulWidget {
//   final BusinessLoaded state;
//   final Color? selectedColorValue;
//   final ValueChanged<Color>? onSelectedColorChanged;
//   final String? segmentsValue;
//   final ValueChanged<String>? onSelectedSegmentsChanged;
//   final List<String>? subSegmentsValue;
//   final ValueChanged<List<String>>? onSelectedSubSegmentsChanged;

//   const VisualBusinessData({
//     super.key,
//     required this.state,
//     this.selectedColorValue,
//     this.onSelectedColorChanged,
//     this.segmentsValue,
//     this.onSelectedSegmentsChanged,
//     this.subSegmentsValue,
//     this.onSelectedSubSegmentsChanged,
//   });

//   @override
//   State<VisualBusinessData> createState() => _VisualBusinessDataState();
// }

// class _VisualBusinessDataState extends State<VisualBusinessData> {
//   Color selectedColor = AppColors.primary;
//   String? selectedSegment;
//   List<String>? selectedSubSegments;

//   @override
//   void initState() {
//     super.initState();
//     selectedColor = widget.selectedColorValue ?? AppColors.primary;
//     selectedSegment = widget.segmentsValue;
//     selectedSubSegments = widget.subSegmentsValue;
//   }

//   @override
//   void didUpdateWidget(covariant VisualBusinessData oldWidget) {
//     super.didUpdateWidget(oldWidget);

//     bool shouldUpdate = false;

//     if (widget.selectedColorValue != oldWidget.selectedColorValue &&
//         widget.selectedColorValue != null) {
//       selectedColor = widget.selectedColorValue!;
//       shouldUpdate = true;
//     }

//     if (widget.segmentsValue != oldWidget.segmentsValue) {
//       selectedSegment = widget.segmentsValue;
//       shouldUpdate = true;
//     }

//     if (widget.subSegmentsValue != oldWidget.subSegmentsValue) {
//       selectedSubSegments = widget.subSegmentsValue;
//       shouldUpdate = true;
//     }

//     if (shouldUpdate) setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//     final hasError = widget.state.message.values.first.isNotEmpty;
//     final errorBorderColor = hasError ? Colors.red : null;
//     final error = widget.state.message.values.first.isNotEmpty ? (widget.state.message.keys.first == 'isEmpty' ? null : '') : null;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ===== Título =====
//           Text(
//             l10n.customizeIdentify,
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//           ),
//           Divider(color: Colors.grey[300], height: 40),

//           // ===== Seção de cores =====
//           _sectionTitle(l10n.favoriteColor),
//           _colorsSection(l10n),
//           Divider(color: Colors.grey[300], height: 60),

//           // ===== Dropdown de segmento =====
//           AppDropdown(
//             title: l10n.segmentBusiness,
//             items: segments,
//             labelKey: 'label',
//             valueKey: 'label',
//             placeholder: Text(
//               widget.segmentsValue!.isEmpty
//                   ? 'Selecione uma opção'
//                   : widget.segmentsValue!,
//             ),
//             onChanged: (val) {
//               setState(() => selectedSegment = val.toString());
//               widget.onSelectedSegmentsChanged?.call(selectedSegment!);
//             },
//             borderRadius: 8,
//             borderWidth: 1,
//             borderColor: errorBorderColor,
//             dropdownMaxHeight: 280,
//           ),
//           const SizedBox(height: 24),

//           // ===== Dropdown de subsegmento =====
//           AppDropdown(
//             multiSelection: true,
//             enabled: widget.segmentsValue!.isNotEmpty,
//             title: l10n.subSegmentBusiness,
//             items: (selectedSegment != null)
//                 ? (subsegments.firstWhere(
//                         (seg) => seg['label'] == selectedSegment,
//                         orElse: () => {'subsegments': <Map<String, Object?>>[]},
//                       )['subsegments']
//                       as List<Map<String, Object?>>)
//                 : <Map<String, Object?>>[],
//             labelKey: 'label',
//             valueKey: 'label',
//             placeholder: Text(
//               widget.subSegmentsValue!.isEmpty
//                   ? 'Selecione uma opção'
//                   : '${widget.subSegmentsValue!.length} selecionado${widget.subSegmentsValue!.length > 1 ? 's' : ''}',
//             ),
//             onChanged: (val) {
//               if (val is Set<Object?>) {
//                 final list = val.map((e) => e.toString()).toList();
//                 setState(() => selectedSubSegments = list);
//                 widget.onSelectedSubSegmentsChanged?.call(list);
//               } else if (val != null) {
//                 // caso venha um único valor
//                 setState(() => selectedSubSegments = [val.toString()]);
//                 widget.onSelectedSubSegmentsChanged?.call([val.toString()]);
//               }
//             },

//             borderRadius: 8,
//             borderWidth: 1,
//             borderColor: errorBorderColor,
//             dropdownMaxHeight: 280,
//           ),
//           const SizedBox(height: 24),

//           // ===== Seção de imagens =====
//           _sectionTitle(l10n.insertImageAndCoverImage),
//           BusinessImages(),
//           const SizedBox(height: 42),
//           Divider(color: Colors.grey[300], height: 40),
//           AppTextformfield(
//             title: l10n.instagram,
//             // controller: widget.zipCodeBusinessController,
//             prefixIcon: Padding(
//               padding: const EdgeInsets.only(left: 12, right: 4),
//               child: const Icon(
//                 Icons.alternate_email_sharp,
//                 color: Colors.grey,
//                 size: 20,
//               ),
//             ),
//             error: error,
//             keyboardType: TextInputType.text,
//             textInputAction: TextInputAction.next,
//             onChanged: (val) =>
//                 context.read<BusinessBloc>().add(CloseMessage()),
//           ),

//           const SizedBox(height: 1000), // Placeholder final
//         ],
//       ),
//     );
//   }

//   // ==== Helpers ====
//   Widget _sectionTitle(String title) => Padding(
//     padding: const EdgeInsets.only(bottom: 12),
//     child: Text(
//       title,
//       style: const TextStyle(
//         fontSize: 14,
//         fontWeight: FontWeight.w500,
//         color: Colors.black,
//       ),
//     ),
//   );

//   Widget _colorsSection(AppLocalizations l10n) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Cores divididas em linhas
//         for (var i = 0; i < colors.length; i += 6)
//           Padding(
//             padding: const EdgeInsets.only(bottom: 6),
//             child: Row(
//               children: colors
//                   .sublist(i, (i + 6) > colors.length ? colors.length : (i + 6))
//                   .map(
//                     (color) => GestureDetector(
//                       onTap: () {
//                         setState(() => selectedColor = color);
//                         widget.onSelectedColorChanged?.call(selectedColor);
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.only(right: 6),
//                         child: FavoriteColorItem(
//                           selectedColor: selectedColor,
//                           color: color,
//                         ),
//                       ),
//                     ),
//                   )
//                   .toList(),
//             ),
//           ),

//         const SizedBox(height: 12),

//         // Descrição da seleção de cor
//         Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: Colors.black.withValues(alpha: 0.05),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const Icon(Icons.info, color: Colors.black38, size: 16),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Text(
//                   l10n.favoriteColorDescription,
//                   style: const TextStyle(fontSize: 12, color: Colors.black54),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
