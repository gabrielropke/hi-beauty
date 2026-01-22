import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hibeauty/core/components/app_floating_message.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/core/services/notifications_service.dart';
import 'package:hibeauty/features/notifications/data/data_source.dart';
import 'package:hibeauty/features/notifications/data/model.dart';
import 'package:hibeauty/features/notifications/data/repository_impl.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final BuildContext context;
  NotificationsBloc(this.context) : super(NotificationsNotifications()) {
    on<NotificationsLoadRequested>(_onNotificationsLoadedRequested);
    on<CloseMessage>(_onCloseMessage);
    on<MarkRead>(_onMarkRead);
    on<MarkAllRead>(_onMarkAllRead);
    on<DeleteNotification>(_onDeleteNotification);
  }

  Future<void> _onNotificationsLoadedRequested(
    NotificationsLoadRequested event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading());

    final notifications = await NotificationsRepositoryImpl(
      NotificationsRemoteDataSourceImpl(),
    ).getNotifications();

    emit(NotificationsLoaded(notifications: notifications.notifications));
  }

  Future<void> _onCloseMessage(
    CloseMessage event,
    Emitter<NotificationsState> emit,
  ) async {
    emit((state as NotificationsLoaded).copyWith(message: () => ''));
  }

  Future<void> _onMarkAllRead(
    MarkAllRead event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(
      (state as NotificationsLoaded).copyWith(
        loading: () => true,
        message: () => '',
      ),
    );

    try {
      await NotificationsRepositoryImpl(
        NotificationsRemoteDataSourceImpl(),
      ).markAllRead();

      final notifications = await NotificationsRepositoryImpl(
        NotificationsRemoteDataSourceImpl(),
      ).getNotifications();

      await NotificationsService().refreshCount();

      emit(
        (state as NotificationsLoaded).copyWith(
          loading: () => false,
          message: () => '',
          notifications: () => notifications.notifications,
        ),
      );
    } catch (e) {
      if (e is ApiFailure) {
        emit(
          (state as NotificationsLoaded).copyWith(
            loading: () => false,
            message: () => e.message,
          ),
        );
        return;
      }
    }
  }

  Future<void> _onMarkRead(
    MarkRead event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(
      (state as NotificationsLoaded).copyWith(
        loading: () => true,
        message: () => '',
      ),
    );

    try {
      await NotificationsRepositoryImpl(
        NotificationsRemoteDataSourceImpl(),
      ).markRead(event.id);

      final notifications = await NotificationsRepositoryImpl(
        NotificationsRemoteDataSourceImpl(),
      ).getNotifications();

      await NotificationsService().refreshCount();

      emit(
        (state as NotificationsLoaded).copyWith(
          loading: () => false,
          message: () => '',
          notifications: () => notifications.notifications,
        ),
      );
    } catch (e) {
      if (e is ApiFailure) {
        emit(
          (state as NotificationsLoaded).copyWith(
            loading: () => false,
            message: () => e.message,
          ),
        );
        return;
      }
    }
  }

  Future<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(
      (state as NotificationsLoaded).copyWith(
        loading: () => true,
        message: () => '',
      ),
    );

    try {
      await NotificationsRepositoryImpl(
        NotificationsRemoteDataSourceImpl(),
      ).deleteNotification(event.id);

      final notifications = await NotificationsRepositoryImpl(
        NotificationsRemoteDataSourceImpl(),
      ).getNotifications();

      await NotificationsService().refreshCount();

      AppFloatingMessage.show(
        context,
        message: 'Notificação deletada com sucesso',
        type: AppFloatingMessageType.success,
      );

      emit(
        (state as NotificationsLoaded).copyWith(
          loading: () => false,
          message: () => '',
          notifications: () => notifications.notifications,
        ),
      );

      
    } catch (e) {
      if (e is ApiFailure) {
        emit(
          (state as NotificationsLoaded).copyWith(
            loading: () => false,
            message: () => e.message,
          ),
        );
        return;
      }
    }
  }
}
