import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/features/business/views/business_config/presentation/bloc/business_config_bloc.dart';

class BusinessConfigProvider extends StatelessWidget {
  final Widget child;
  
  const BusinessConfigProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BusinessConfigBloc(context)..add(BusinessConfigLoadRequested()),
      child: child,
    );
  }
}