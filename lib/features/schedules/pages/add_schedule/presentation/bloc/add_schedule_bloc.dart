import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/app/routes/app_routes.dart';
import 'package:hibeauty/core/components/app_date_picker.dart';
import 'package:hibeauty/core/components/app_floating_message.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/features/catalog/data/data_source.dart';
import 'package:hibeauty/features/catalog/data/model.dart';
import 'package:hibeauty/features/catalog/data/repository_impl.dart';
import 'package:hibeauty/features/customers/data/data_source.dart';
import 'package:hibeauty/features/customers/data/model.dart';
import 'package:hibeauty/features/schedules/data/data_source.dart';
import 'package:hibeauty/features/schedules/data/model.dart'
    hide TeamMemberModel, CustomerModel;
import 'package:hibeauty/features/team/data/data_source.dart';
import 'package:hibeauty/features/team/data/model.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

part 'add_schedule_event.dart';
part 'add_schedule_state.dart';

class AddScheduleBloc extends Bloc<AddScheduleEvent, AddScheduleState> {
  final BuildContext context;
  final VoidCallback? onNavigateToHome;

  AddScheduleBloc(this.context, {this.onNavigateToHome})
    : super(AddScheduleInitial()) {
    on<AddScheduleLoadRequested>(_onAddScheduleLoadedRequested);
    on<RefreshCustomers>(_onRefreshCustomers);
    on<CloseMessage>(_onCloseMessage);
    on<SelectDate>(_onSelectDate);
    on<RecurrenceTypeSelected>(_onRecurrenceTypeSelected);
    on<SelectCustomer>(_onSelectCustomer);
    on<SelectMember>(_onSelectMember);
    on<SelectServices>(_onSelectServices);
    on<ClearServices>(_onClearServices);
    on<NextStep>(_onNextStep);
    on<PreviousStep>(_onPreviousStep);
    on<SelectTime>(_onSelectTime);
    on<SubmitSchedule>(_onSubmitSchedule);
    on<SubmitBlock>(_onSubmitBlock);
    on<DeleteBooking>(_onDeleteBooking);
    on<DeleteBlock>(_onDeleteBlock);
    on<UpdateBooking>(_onUpdateBooking);
    on<UpdateBlock>(_onUpdateBlock);
    on<SelectPaymentDateTime>(_onSelectPaymentDateTime);
    on<SelectPaymentMethod>(_onSelectPaymentMethod);
    on<MarkAsPaid>(_onMarkAsPaid);
  }

  Future<void> _onAddScheduleLoadedRequested(
    AddScheduleLoadRequested event,
    Emitter<AddScheduleState> emit,
  ) async {
    emit(AddScheduleLoading());
    final team = await TeamRemoteDataSourceImpl().getTeam();
    final customers = await CustomersRemoteDataSourceImpl().getCustomers();

    final services = await CatalogRepositoryImpl(
      CatalogRemoteDataSourceImpl(),
    ).getServices();

    final products = await CatalogRepositoryImpl(
      CatalogRemoteDataSourceImpl(),
    ).getProducts();

    final combos = await CatalogRepositoryImpl(
      CatalogRemoteDataSourceImpl(),
    ).getCombos();

    // Se tem bookingId, carregar dados do booking para edição
    if (event.bookingId != null) {
      try {
        final scheduleData = await SchedulesRemoteDataSourceImpl()
            .getScheduleById(event.bookingId!);
        final booking = scheduleData.booking;

        // Converter data do booking
        final bookingDate = DateTime.parse(booking.scheduledFor);

        // Buscar customer correspondente
        CustomerModel? selectedCustomer;
        try {
          selectedCustomer = customers.customers.firstWhere(
            (c) => c.id == booking.customer.id,
          );
        } catch (e) {
          // Se não encontrar na lista, criar um customer model baseado nos dados detalhados
          selectedCustomer = CustomerModel(
            id: booking.customer.id,
            name: booking.customer.name,
            phone: booking.customer.phone,
            email: booking.customer.email,
            businessId: '', // Usar valor padrão
            isActive: true, // Usar valor padrão
            createdAt: DateTime.now(), // Usar valor padrão
            updatedAt: DateTime.now(), // Usar valor padrão
          );
        }

        // Buscar team member correspondente
        TeamMemberModel? selectedMember;
        try {
          selectedMember = team.teamMembers.firstWhere(
            (m) => m.id == booking.teamMember.id,
          );
        } catch (e) {
          // Se não encontrar na lista, criar um team member model baseado nos dados detalhados
          selectedMember = TeamMemberModel(
            id: booking.teamMember.id,
            userId: booking.teamMember.user.id,
            name: booking.teamMember.user.name,
            email: '', // Usar valor padrão
            phone: '', // Usar valor padrão
            profileImageUrl: booking.teamMember.user.profileImageUrl,
            role: booking.teamMember.role,
            status: 'ACTIVE', // Usar valor padrão
            themeColor: booking.teamMember.themeColor,
            workingHours: [], // Usar valor padrão
            businessId: '', // Usar valor padrão
            isActive: true, // Usar valor padrão
            createdAt: DateTime.now(), // Usar valor padrão
            updatedAt: DateTime.now(), // Usar valor padrão
          );
        }

        // Mapear serviços do booking para serviços da lista
        List<ServicesModel> selectedServices = [];
        for (final bookingService in booking.services) {
          try {
            final service = services.services.firstWhere(
              (s) => s.id == bookingService.service.id,
            );
            selectedServices.add(service);
          } catch (e) {
            // Se não encontrar na lista, criar um service model baseado nos dados detalhados
            final servicePrice =
                double.tryParse(bookingService.service.price) ?? 0.0;
            selectedServices.add(
              ServicesModel(
                id: bookingService.service.id,
                name: bookingService.service.name,
                duration: bookingService.service.duration,
                price: servicePrice,
                locationType: 'IN_PERSON', // Usar valor padrão
                currency: 'BRL', // Usar valor padrão
                visibility: 'PUBLIC', // Usar valor padrão
                teamMembers: [], // Usar valor padrão
                businessId: '', // Usar valor padrão
                isActive: true, // Usar valor padrão
                createdAt: DateTime.now(), // Usar valor padrão
                updatedAt: DateTime.now(), // Usar valor padrão
              ),
            );
          }
        }

        // Converter recurrence type
        Recurrencetypes recurrenceType = Recurrencetypes.none;
        switch (booking.recurrenceType.toUpperCase()) {
          case 'DAILY':
            recurrenceType = Recurrencetypes.daily;
            break;
          case 'WEEKLY':
            recurrenceType = Recurrencetypes.weekly;
            break;
          case 'MONTHLY':
            recurrenceType = Recurrencetypes.monthly;
            break;
          default:
            recurrenceType = Recurrencetypes.none;
        }

        emit(
          AddScheduleLoaded(
            date: bookingDate,
            team: team.teamMembers,
            customers: customers.customers,
            services: services.services,
            products: products.products,
            combos: combos.combos,
            customerSelected: selectedCustomer,
            memberSelected: selectedMember,
            selectedServices: selectedServices,
            selectedProducts:
                [], // Por enquanto vazio, pode ser expandido no futuro
            selectedCombos:
                [], // Por enquanto vazio, pode ser expandido no futuro
            recurrenceType: recurrenceType,
            currentStep: 3, // Vai direto para o step final em modo de edição
            booking: booking,
          ),
        );
        return;
      } catch (e) {
        // Se der erro ao carregar o booking, continua com o fluxo normal
      }
    }

    // Se tem blockId, carregar dados do block para edição
    if (event.blockId != null) {
      try {
        final blockData = await SchedulesRemoteDataSourceImpl().getBlockById(
          event.blockId!,
        );
        final block = blockData
            .booking; // ← Mudança aqui: usar booking ao invés de timeBlock

        // Converter data do block
        final blockDate = DateTime.parse(block.scheduledFor);

        // Buscar team member correspondente
        TeamMemberModel? selectedMember;
        try {
          selectedMember = team.teamMembers.firstWhere(
            (m) => m.id == block.teamMember.id,
          );
        } catch (e) {
          // Se não encontrar na lista, criar um team member model baseado nos dados detalhados
          selectedMember = TeamMemberModel(
            id: block.teamMember.id,
            userId: block.teamMember.user.id,
            name: block.teamMember.user.name,
            email: '', // Usar valor padrão
            phone: '', // Usar valor padrão
            profileImageUrl: block.teamMember.user.profileImageUrl,
            role: block.teamMember.role,
            status: 'ACTIVE', // Usar valor padrão
            themeColor: block.teamMember.themeColor,
            workingHours: [], // Usar valor padrão
            businessId: '', // Usar valor padrão
            isActive: true, // Usar valor padrão
            createdAt: DateTime.now(), // Usar valor padrão
            updatedAt: DateTime.now(), // Usar valor padrão
          );
        }

        // Converter recurrence type
        Recurrencetypes recurrenceType = Recurrencetypes.none;
        switch (block.recurrenceType.toUpperCase()) {
          case 'DAILY':
            recurrenceType = Recurrencetypes.daily;
            break;
          case 'WEEKLY':
            recurrenceType = Recurrencetypes.weekly;
            break;
          case 'MONTHLY':
            recurrenceType = Recurrencetypes.monthly;
            break;
          default:
            recurrenceType = Recurrencetypes.none;
        }

        emit(
          AddScheduleLoaded(
            date: blockDate,
            team: team.teamMembers,
            customers: customers.customers,
            services: services.services,
            products: products.products,
            combos: combos.combos,
            memberSelected: selectedMember,
            recurrenceType: recurrenceType,
            currentStep: 1, // Para blocks, manter no step 1
            blockName: block.name,
            blockNotes: block.notes,
            blockDuration: block.duration,
          ),
        );
        return;
      } catch (e) {
        // Se der erro ao carregar o block, continua com o fluxo normal
      }
    }

    emit(
      AddScheduleLoaded(
        date: event.initialDate ?? DateTime.now(),
        team: team.teamMembers,
        customers: customers.customers,
        services: services.services,
        products: products.products,
        combos: combos.combos,
      ),
    );
  }

  Future<void> _onSubmitBlock(
    SubmitBlock event,
    Emitter<AddScheduleState> emit,
  ) async {
    emit(
      (state as AddScheduleLoaded).copyWith(
        loading: () => true,
        message: () => '',
      ),
    );

    // Criar um completer para aguardar o resultado da API
    final Completer<bool> apiCompleter = Completer<bool>();

    // Executa a operação em segundo plano
    _submitBlockInBackground(event.block, apiCompleter);

    // Aguarda até 3 segundos ou até a API responder
    final result = await Future.any([
      Future.delayed(const Duration(seconds: 3), () => true), // sucesso após 3s
      apiCompleter.future, // resultado da API
    ]);

    emit(
      (state as AddScheduleLoaded).copyWith(
        loading: () => false,
        message: () => '',
      ),
    );

    // Só navega se não houve erro
    if (result) {
      // Navega para home
      context.pushReplacement(AppRoutes.home);

      // Chama a callback para recarregar os dados da home
      SchedulerBinding.instance.addPostFrameCallback((_) {
        onNavigateToHome?.call();
      });
    }
  }

  Future<void> _onSubmitSchedule(
    SubmitSchedule event,
    Emitter<AddScheduleState> emit,
  ) async {
    emit(
      (state as AddScheduleLoaded).copyWith(
        loading: () => true,
        message: () => '',
      ),
    );

    // Criar um completer para aguardar o resultado da API
    final Completer<bool> apiCompleter = Completer<bool>();

    // Executa a operação em segundo plano
    _submitScheduleInBackground(event.booking, apiCompleter);

    // Aguarda até 3 segundos ou até a API responder
    final result = await Future.any([
      Future.delayed(const Duration(seconds: 3), () => true), // sucesso após 3s
      apiCompleter.future, // resultado da API
    ]);

    emit(
      (state as AddScheduleLoaded).copyWith(
        loading: () => false,
        message: () => '',
      ),
    );

    // Só navega se não houve erro
    if (result) {
      // Navega para home
      context.pushReplacement(AppRoutes.home);

      // Chama a callback para recarregar os dados da home
      SchedulerBinding.instance.addPostFrameCallback((_) {
        onNavigateToHome?.call();
      });
    }
  }

  Future<void> _submitBlockInBackground(
    CreateBlockResponse block,
    Completer<bool> completer,
  ) async {
    try {
      await SchedulesRemoteDataSourceImpl().createBlock(block);

      // Se chegou até aqui, foi sucesso
      if (!completer.isCompleted) {
        completer.complete(true);
      }

      if (context.mounted) {
        AppFloatingMessage.show(
          context,
          message: 'Bloqueio criado com sucesso.',
          type: AppFloatingMessageType.success,
        );
      }
    } catch (e) {
      // Se der erro, marca como erro no completer
      if (!completer.isCompleted) {
        completer.complete(false);
      }

      // Se der erro, só mostra a mensagem se ainda estiver montado
      if (context.mounted) {
        if (e is ApiFailure) {
          AppFloatingMessage.show(
            context,
            message: e.message,
            type: AppFloatingMessageType.error,
          );
        } else {
          AppFloatingMessage.show(
            context,
            message: 'Ocorreu um erro inesperado.',
            type: AppFloatingMessageType.error,
          );
        }
      }
    }
  }

  Future<void> _submitScheduleInBackground(
    CreateBookingResponse booking,
    Completer<bool> completer,
  ) async {
    try {
      await SchedulesRemoteDataSourceImpl().createBooking(booking);

      // Se chegou até aqui, foi sucesso
      if (!completer.isCompleted) {
        completer.complete(true);
      }

      if (context.mounted) {
        AppFloatingMessage.show(
          context,
          message: 'Agendamento criado com sucesso.',
          type: AppFloatingMessageType.success,
        );
      }
    } catch (e) {
      // Se der erro, marca como erro no completer
      if (!completer.isCompleted) {
        completer.complete(false);
      }

      // Verifica se é erro de autorização (401) antes de mostrar mensagem
      if (e is ApiFailure && e.statusCode == 401) {
        throw GoException('401: ${e.message}');
      }

      // Se der erro, só mostra a mensagem se ainda estiver montado
      if (context.mounted) {
        if (e is ApiFailure) {
          AppFloatingMessage.show(
            context,
            message: e.message,
            type: AppFloatingMessageType.error,
          );
        } else {
          AppFloatingMessage.show(
            context,
            message: 'Ocorreu um erro inesperado.',
            type: AppFloatingMessageType.error,
          );
        }
      }
    }
  }

  Future<void> _onRefreshCustomers(
    RefreshCustomers event,
    Emitter<AddScheduleState> emit,
  ) async {
    emit((state as AddScheduleLoaded).copyWith(loading: () => true));

    try {
      // Recarregar apenas a lista de customers
      final customers = await CustomersRemoteDataSourceImpl().getCustomers();

      emit(
        (state as AddScheduleLoaded).copyWith(
          loading: () => false,
          customers: () => customers.customers,
        ),
      );
    } catch (e) {
      // Se der erro, não faz nada para não quebrar o fluxo
    }
  }

  Future<void> _onCloseMessage(
    CloseMessage event,
    Emitter<AddScheduleState> emit,
  ) async {
    emit((state as AddScheduleLoaded).copyWith(message: () => ''));
  }

  Future<void> _onSelectDate(
    SelectDate event,
    Emitter<AddScheduleState> emit,
  ) async {
    final currentState = state as AddScheduleLoaded;
    final currentDate = currentState.date;
    final newDate = DateTime(
      event.date.year,
      event.date.month,
      event.date.day,
      currentDate.hour,
      currentDate.minute,
      currentDate.second,
      currentDate.millisecond,
    );
    emit(currentState.copyWith(date: () => newDate));
  }

  Future<void> _onRecurrenceTypeSelected(
    RecurrenceTypeSelected event,
    Emitter<AddScheduleState> emit,
  ) async {
    emit(
      (state as AddScheduleLoaded).copyWith(recurrenceType: () => event.type),
    );
  }

  Future<void> _onSelectCustomer(
    SelectCustomer event,
    Emitter<AddScheduleState> emit,
  ) async {
    emit(
      (state as AddScheduleLoaded).copyWith(
        customerSelected: () => event.customer,
      ),
    );
  }

  Future<void> _onSelectMember(
    SelectMember event,
    Emitter<AddScheduleState> emit,
  ) async {
    emit(
      (state as AddScheduleLoaded).copyWith(memberSelected: () => event.member),
    );
  }

  Future<void> _onSelectServices(
    SelectServices event,
    Emitter<AddScheduleState> emit,
  ) async {
    emit(
      (state as AddScheduleLoaded).copyWith(
        selectedServices: () => event.services,
        selectedProducts: () => event.products,
        selectedCombos: () => event.combos,
      ),
    );
  }

  Future<void> _onClearServices(
    ClearServices event,
    Emitter<AddScheduleState> emit,
  ) async {
    emit(
      (state as AddScheduleLoaded).copyWith(
        selectedServices: () => [],
        selectedProducts: () => [],
        selectedCombos: () => [],
      ),
    );
  }

  Future<void> _onNextStep(
    NextStep event,
    Emitter<AddScheduleState> emit,
  ) async {
    final currentState = state as AddScheduleLoaded;
    if (currentState.currentStep < 3) {
      emit(
        currentState.copyWith(currentStep: () => currentState.currentStep + 1),
      );
    }
  }

  Future<void> _onPreviousStep(
    PreviousStep event,
    Emitter<AddScheduleState> emit,
  ) async {
    final currentState = state as AddScheduleLoaded;
    if (currentState.currentStep > 1) {
      emit(
        currentState.copyWith(currentStep: () => currentState.currentStep - 1),
      );
    }
  }

  Future<void> _onSelectTime(
    SelectTime event,
    Emitter<AddScheduleState> emit,
  ) async {
    emit(
      (state as AddScheduleLoaded).copyWith(
        date: () => event.dateTime,
        currentStep: () => 3,
      ),
    );
  }

  Future<void> _onDeleteBooking(
    DeleteBooking event,
    Emitter<AddScheduleState> emit,
  ) async {
    emit(
      (state as AddScheduleLoaded).copyWith(
        loading: () => true,
        message: () => '',
      ),
    );

    try {
      await SchedulesRemoteDataSourceImpl().deleteBooking(event.id);

      emit(
        (state as AddScheduleLoaded).copyWith(
          loading: () => false,
          message: () => '',
        ),
      );

      AppFloatingMessage.show(
        context,
        message: 'Agendamento deletado com sucesso.',
        type: AppFloatingMessageType.error,
      );

      context.pushReplacement(AppRoutes.home);
    } catch (e) {
      if (e is ApiFailure) {
        emit(
          (state as AddScheduleLoaded).copyWith(
            loading: () => false,
            message: () => e.message,
          ),
        );
        AppFloatingMessage.show(
          context,
          message: e.message,
          type: AppFloatingMessageType.error,
        );
        return;
      }
      AppFloatingMessage.show(
        context,
        message: 'Ocorreu um erro inesperado.',
        type: AppFloatingMessageType.error,
      );
    }
  }

  Future<void> _onDeleteBlock(
    DeleteBlock event,
    Emitter<AddScheduleState> emit,
  ) async {
    emit(
      (state as AddScheduleLoaded).copyWith(
        loading: () => true,
        message: () => '',
      ),
    );

    try {
      await SchedulesRemoteDataSourceImpl().deleteBlock(event.id);

      emit(
        (state as AddScheduleLoaded).copyWith(
          loading: () => false,
          message: () => '',
        ),
      );

      AppFloatingMessage.show(
        context,
        message: 'Bloqueio removido com sucesso.',
        type: AppFloatingMessageType.error,
      );

      context.pushReplacement(AppRoutes.home);
    } catch (e) {
      if (e is ApiFailure) {
        emit(
          (state as AddScheduleLoaded).copyWith(
            loading: () => false,
            message: () => e.message,
          ),
        );
        AppFloatingMessage.show(
          context,
          message: e.message,
          type: AppFloatingMessageType.error,
        );
        return;
      }
      AppFloatingMessage.show(
        context,
        message: 'Ocorreu um erro inesperado.',
        type: AppFloatingMessageType.error,
      );
    }
  }

  Future<void> _onUpdateBooking(
    UpdateBooking event,
    Emitter<AddScheduleState> emit,
  ) async {
    emit(
      (state as AddScheduleLoaded).copyWith(
        loading: () => true,
        message: () => '',
      ),
    );

    // Criar um completer para aguardar o resultado da API
    final Completer<bool> apiCompleter = Completer<bool>();

    // Executa a operação em segundo plano
    _updateBookingInBackground(event.booking, event.id, apiCompleter);

    // Aguarda até 3 segundos ou até a API responder
    final result = await Future.any([
      Future.delayed(const Duration(seconds: 3), () => true), // sucesso após 3s
      apiCompleter.future, // resultado da API
    ]);

    emit(
      (state as AddScheduleLoaded).copyWith(
        loading: () => false,
        message: () => '',
      ),
    );

    // Só navega se não houve erro
    if (result) {
      // Navega para home
      context.pushReplacement(AppRoutes.home);

      // Chama a callback para recarregar os dados da home
      SchedulerBinding.instance.addPostFrameCallback((_) {
        onNavigateToHome?.call();
      });
    }
  }

  Future<void> _onUpdateBlock(
    UpdateBlock event,
    Emitter<AddScheduleState> emit,
  ) async {
    emit(
      (state as AddScheduleLoaded).copyWith(
        loading: () => true,
        message: () => '',
      ),
    );

    // Criar um completer para aguardar o resultado da API
    final Completer<bool> apiCompleter = Completer<bool>();

    // Executa a operação em segundo plano
    _updateBlockInBackground(event.block, event.id, apiCompleter);

    // Aguarda até 3 segundos ou até a API responder
    final result = await Future.any([
      Future.delayed(const Duration(seconds: 3), () => true), // sucesso após 3s
      apiCompleter.future, // resultado da API
    ]);

    emit(
      (state as AddScheduleLoaded).copyWith(
        loading: () => false,
        message: () => '',
      ),
    );

    // Só navega se não houve erro
    if (result) {
      // Navega para home
      context.pushReplacement(AppRoutes.home);

      // Chama a callback para recarregar os dados da home
      SchedulerBinding.instance.addPostFrameCallback((_) {
        onNavigateToHome?.call();
      });
    }
  }

  Future<void> _updateBookingInBackground(
    CreateBookingResponse booking,
    String id,
    Completer<bool> completer,
  ) async {
    try {
      await SchedulesRemoteDataSourceImpl().updateBooking(booking, id);

      // Se chegou até aqui, foi sucesso
      if (!completer.isCompleted) {
        completer.complete(true);
      }

      if (context.mounted) {
        AppFloatingMessage.show(
          context,
          message: 'Agendamento atualizado com sucesso.',
          type: AppFloatingMessageType.success,
        );
      }
    } catch (e) {
      // Se der erro, marca como erro no completer
      if (!completer.isCompleted) {
        completer.complete(false);
      }

      // Se der erro, só mostra a mensagem se ainda estiver montado
      if (context.mounted) {
        if (e is ApiFailure) {
          AppFloatingMessage.show(
            context,
            message: e.message,
            type: AppFloatingMessageType.error,
          );
        } else {
          AppFloatingMessage.show(
            context,
            message: 'Ocorreu um erro inesperado.',
            type: AppFloatingMessageType.error,
          );
        }
      }
    }
  }

  Future<void> _updateBlockInBackground(
    CreateBlockResponse block,
    String id,
    Completer<bool> completer,
  ) async {
    try {
      await SchedulesRemoteDataSourceImpl().updateBlock(block, id);

      // Se chegou até aqui, foi sucesso
      if (!completer.isCompleted) {
        completer.complete(true);
      }

      if (context.mounted) {
        AppFloatingMessage.show(
          context,
          message: 'Bloqueio atualizado com sucesso.',
          type: AppFloatingMessageType.success,
        );
      }
    } catch (e) {
      // Se der erro, marca como erro no completer
      if (!completer.isCompleted) {
        completer.complete(false);
      }

      // Se der erro, só mostra a mensagem se ainda estiver montado
      if (context.mounted) {
        if (e is ApiFailure) {
          AppFloatingMessage.show(
            context,
            message: e.message,
            type: AppFloatingMessageType.error,
          );
        } else {
          AppFloatingMessage.show(
            context,
            message: 'Ocorreu um erro inesperado.',
            type: AppFloatingMessageType.error,
          );
        }
      }
    }
  }

  // Payment methods helpers
  String getPaymentMethodName(PaymentMethods method) {
    switch (method) {
      case PaymentMethods.PIX:
        return 'PIX';
      case PaymentMethods.CARD:
        return 'Cartão';
      case PaymentMethods.CASH:
        return 'Dinheiro';
      case PaymentMethods.OTHER:
        return 'Outro';
    }
  }

  IconData getPaymentMethodIcon(PaymentMethods method) {
    switch (method) {
      case PaymentMethods.PIX:
        return LucideIcons.qrCode;
      case PaymentMethods.CARD:
        return LucideIcons.creditCard;
      case PaymentMethods.CASH:
        return LucideIcons.wallet;
      case PaymentMethods.OTHER:
        return Icons.more_horiz;
    }
  }

  Future<void> _onSelectPaymentDateTime(
    SelectPaymentDateTime event,
    Emitter<AddScheduleState> emit,
  ) async {
    final currentState = state as AddScheduleLoaded;
    final currentDateTime = currentState.paymentDateTime ?? DateTime.now();

    final date = await showDialog<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          child: AppDatePicker(
            selectionMode: AppDateSelectionMode.single,
            firstDay: DateTime(2001),
            lastDay: DateTime.now(),
            selected: currentDateTime,
            onSelected: (date) {
              Navigator.of(context).pop(date);
            },
          ),
        );
      },
    );

    if (date != null && context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentDateTime),
      );

      if (time != null) {
        final newDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        emit(currentState.copyWith(paymentDateTime: () => newDateTime));
      }
    }
  }

  Future<void> _onSelectPaymentMethod(
    SelectPaymentMethod event,
    Emitter<AddScheduleState> emit,
  ) async {
    emit(
      (state as AddScheduleLoaded).copyWith(
        selectedPaymentMethod: () => event.method,
      ),
    );
  }

  Future<void> _onMarkAsPaid(
    MarkAsPaid event,
    Emitter<AddScheduleState> emit,
  ) async {
    emit((state as AddScheduleLoaded).copyWith(loading: () => true));

    try {
      // Aqui você implementaria a chamada da API para marcar como pago
      await SchedulesRemoteDataSourceImpl().markAsPaid(
        event.bookingId,
        event.paymentMethod,
        event.notes,
        event.paymentDateTime,
      );

      emit((state as AddScheduleLoaded).copyWith(loading: () => false));

      if (context.mounted) {
        AppFloatingMessage.show(
          context,
          message: 'Pagamento registrado com sucesso.',
          type: AppFloatingMessageType.success,
        );

        context.pushReplacement(AppRoutes.home);
      }
    } catch (e) {
      emit((state as AddScheduleLoaded).copyWith(loading: () => false));

      if (context.mounted) {
        if (e is ApiFailure) {
          AppFloatingMessage.show(
            context,
            message: e.message,
            type: AppFloatingMessageType.error,
          );
        } else {
          AppFloatingMessage.show(
            context,
            message: 'Ocorreu um erro ao registrar o pagamento.',
            type: AppFloatingMessageType.error,
          );
        }
      }
    }
  }
}
