import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_message.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/bloc/business_config_bloc.dart';

class ErrorMessage extends StatelessWidget {
  final BusinessConfigLoaded state;

  const ErrorMessage({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return AppMessage(
      key: const ValueKey('msg'),
      label: state.message.values.first,
      type: state.message.keys.first == 'success'
          ? MessageType.success
          : MessageType.failure,
      function: () => context.read<BusinessConfigBloc>().add(CloseMessage()),
    );
  }
}