// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hibeauty/core/components/app_dropdown.dart';
// import 'package:hibeauty/core/components/app_textformfield.dart';
// import 'package:hibeauty/core/constants/default_values/ufs.dart';
// import 'package:hibeauty/features/onboarding/presentation/bloc/onboarding_bloc.dart';
// import 'package:hibeauty/l10n/app_localizations.dart';

// class AddressBusinessData extends StatefulWidget {
//   final BusinessLoaded state;
//   final TextEditingController zipCodeBusinessController;
//   final TextEditingController addressBusinessController;
//   final TextEditingController neighborhoodBusinessController;
//   final TextEditingController numberBusinessController;
//   final TextEditingController complementBusinessController;
//   final TextEditingController cityBusinessController;
//   final TextEditingController stateBusinessController;
//   final String? ufSelectedValue;
//   final ValueChanged<String>? onUfChanged;
//   const AddressBusinessData({
//     super.key,
//     required this.state,
//     required this.zipCodeBusinessController,
//     required this.addressBusinessController,
//     required this.neighborhoodBusinessController,
//     required this.numberBusinessController,
//     required this.complementBusinessController,
//     required this.cityBusinessController,
//     required this.stateBusinessController,
//     this.ufSelectedValue,
//     this.onUfChanged,
//   });

//   @override
//   State<AddressBusinessData> createState() => _AddressBusinessDataState();
// }

// class _AddressBusinessDataState extends State<AddressBusinessData> {
//   String? selectedUf;

//   @override
//   void initState() {
//     super.initState();
//     selectedUf = widget.ufSelectedValue ?? '';
//   }

//   @override
//   void didUpdateWidget(covariant AddressBusinessData oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.ufSelectedValue != oldWidget.ufSelectedValue) {
//       setState(() {
//         selectedUf = widget.ufSelectedValue;
//       });
//       if (selectedUf != null) {
//         widget.stateBusinessController.text = selectedUf!;
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//     final error = widget.state.message.values.first.isNotEmpty
//         ? (widget.state.message.keys.first == 'isEmpty' ? null : '')
//         : null;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             l10n.businessAddress,
//             style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//           ),
//           const SizedBox(height: 24),

//           AppTextformfield(
//             title: l10n.zipcode,
//             controller: widget.zipCodeBusinessController,
//             error: error,
//             keyboardType: TextInputType.text,
//             textInputAction: TextInputAction.next,
//             onChanged: (val) =>
//                 context.read<BusinessBloc>().add(CloseMessage()),
//           ),

//           const SizedBox(height: 24),

//           Row(
//             spacing: 12,
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: AppTextformfield(
//                   title: l10n.address,
//                   controller: widget.addressBusinessController, // corrigido
//                   error: error,
//                   keyboardType: TextInputType.text,
//                   textInputAction: TextInputAction.next,
//                   onChanged: (val) =>
//                       context.read<BusinessBloc>().add(CloseMessage()),
//                 ),
//               ),
//               Expanded(
//                 child: AppTextformfield(
//                   title: l10n.number,
//                   controller: widget.numberBusinessController,
//                   error: error,
//                   keyboardType: TextInputType.text,
//                   textInputAction: TextInputAction.next,
//                   onChanged: (val) =>
//                       context.read<BusinessBloc>().add(CloseMessage()),
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 24),

//           AppTextformfield(
//             title: l10n.complement,
//             controller: widget.complementBusinessController,
//             error: error,
//             keyboardType: TextInputType.text,
//             textInputAction: TextInputAction.next,
//             onChanged: (val) =>
//                 context.read<BusinessBloc>().add(CloseMessage()),
//           ),

//           const SizedBox(height: 24),

//           Row(
//             spacing: 12,
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: AppTextformfield(
//                   title: l10n.city,
//                   controller: widget.cityBusinessController,
//                   error: error,
//                   keyboardType: TextInputType.text,
//                   textInputAction: TextInputAction.next,
//                   onChanged: (val) =>
//                       context.read<BusinessBloc>().add(CloseMessage()),
//                 ),
//               ),
//               AppDropdown(
//                 width: 130,
//                 title: l10n.state,
//                 items: brazilUfs,
//                 labelKey: 'code',
//                 valueKey: 'code',
//                 placeholder: Text(
//                   selectedUf == null || selectedUf!.isEmpty
//                       ? l10n.select
//                       : selectedUf!,
//                 ),
//                 onChanged: (val) {
//                   setState(() => selectedUf = val.toString());
//                   widget.onUfChanged?.call(
//                     selectedUf!,
//                   );
//                 },
//                 borderRadius: 8,
//                 borderWidth: 1,
//                 borderColor: widget.state.message.values.first.isNotEmpty ? Colors.red : null,
//                 dropdownMaxHeight: 280,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }