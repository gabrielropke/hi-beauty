import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hibeauty/core/components/app_floating_message.dart';
import 'package:hibeauty/core/data/api_error.dart';
import 'package:hibeauty/features/catalog/data/data_source.dart';
import 'package:hibeauty/features/catalog/data/model.dart';
import 'package:hibeauty/features/catalog/data/repository_impl.dart';
import 'package:hibeauty/features/categories/data/data_source.dart';
import 'package:hibeauty/features/categories/data/model.dart';
import 'package:hibeauty/features/categories/data/repository_impl.dart';
import 'package:hibeauty/features/team/data/data_source.dart';
import 'package:hibeauty/features/team/data/model.dart';

part 'catalog_event.dart';
part 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final BuildContext context;
  CatalogBloc(this.context) : super(CatalogInitial()) {
    on<CatalogLoadRequested>(_onCatalogLoadedRequested);
    on<CloseMessage>(_onCloseMessage);
    on<SetMessage>(_onSetMessage);
    on<DeleteService>(_onDeleteService);
    on<DeleteProduct>(_onDeleteProduct);
    on<CreateService>(_onCreateService);
    on<UpdateService>(_onUpdateService);
    on<UpdateProduct>(_onUpdateProduct);
    on<CreateServiceCategorie>(_onCreateServiceCategorie);
    on<CreateProduct>(_onCreateProduct);
    on<CreateProductCategorie>(_onCreateProductCategorie);
    on<AdjustStock>(_onAdjustStock);
    on<CreateCombo>(_onCreateCombo);
    on<DeleteCombo>(_onDeleteCombo);
    on<UpdateCombo>(_onUpdateCombo);
  }

  Future<void> _onCatalogLoadedRequested(
    CatalogLoadRequested event,
    Emitter<CatalogState> emit,
  ) async {
    emit(CatalogLoading());

    final services = await CatalogRepositoryImpl(
      CatalogRemoteDataSourceImpl(),
    ).getServices();

    final serviceCategories = await CatalogRepositoryImpl(
      CatalogRemoteDataSourceImpl(),
    ).getServiceCategories();

    final products = await CatalogRepositoryImpl(
      CatalogRemoteDataSourceImpl(),
    ).getProducts();

    final productCategories = await CategorieRepositoryImpl(
      CategorieRemoteDataSourceImpl(),
    ).getProductCategories();

    final team = await TeamRemoteDataSourceImpl().getTeam();

    final combos = await CatalogRepositoryImpl(
      CatalogRemoteDataSourceImpl(),
    ).getCombos();

    emit(
      CatalogLoaded(
        services: services.services,
        serviceCategories: serviceCategories.categories,
        team: team,
        products: products.products,
        productCategories: productCategories.categories,
        combos: combos.combos,
      ),
    );
  }

  Future<void> _onAdjustStock(
    AdjustStock event,
    Emitter<CatalogState> emit,
  ) async {
    emit((state as CatalogLoaded).copyWith(loading: () => true));

    final currentState = state as CatalogLoaded;

    try {
      await CatalogRepositoryImpl(
        CatalogRemoteDataSourceImpl(),
      ).adjustStock(event.id, event.delta, event.reason);

      final updatedProducts = await CatalogRepositoryImpl(
        CatalogRemoteDataSourceImpl(),
      ).getProducts();

      emit(
        currentState.copyWith(
          products: () => updatedProducts.products,
          loading: () => false,
        ),
      );

      context.pop();
      context.pop();
      context.pop();

      AppFloatingMessage.show(
        context,
        message: 'Estoque ajustado com sucesso.',
        type: AppFloatingMessageType.success,
      );
    } catch (e) {
      if (e is ApiFailure) {
        emit((state as CatalogLoaded).copyWith(loading: () => false));
        AppFloatingMessage.show(
          context,
          message: e.message,
          type: AppFloatingMessageType.error,
        );
        return;
      } else {
        emit((state as CatalogLoaded).copyWith(loading: () => false));
        AppFloatingMessage.show(
          context,
          message: 'Ocorreu um erro inesperado.',
          type: AppFloatingMessageType.error,
        );
        return;
      }
    }
  }

  Future<void> _onCreateCombo(
    CreateCombo event,
    Emitter<CatalogState> emit,
  ) async {
    emit((state as CatalogLoaded).copyWith(loading: () => true));

    final currentState = state as CatalogLoaded;

    try {
      await CatalogRepositoryImpl(
        CatalogRemoteDataSourceImpl(),
      ).createCombo(event.body);

      final updatedCombos = await CatalogRepositoryImpl(
        CatalogRemoteDataSourceImpl(),
      ).getCombos();

      emit(
        currentState.copyWith(
          combos: () => updatedCombos.combos,
          loading: () => false,
        ),
      );

      context.pop();

      AppFloatingMessage.show(
        context,
        message: 'Combo criado com sucesso.',
        type: AppFloatingMessageType.success,
      );
    } catch (e) {
      if (e is ApiFailure) {
        emit((state as CatalogLoaded).copyWith(loading: () => false));
        AppFloatingMessage.show(
          context,
          message: e.message,
          type: AppFloatingMessageType.error,
        );
        return;
      } else {
        emit((state as CatalogLoaded).copyWith(loading: () => false));
        AppFloatingMessage.show(
          context,
          message: 'Ocorreu um erro inesperado.',
          type: AppFloatingMessageType.error,
        );
        return;
      }
    }
  }

  Future<void> _onCreateService(
    CreateService event,
    Emitter<CatalogState> emit,
  ) async {
    emit((state as CatalogLoaded).copyWith(loading: () => true));

    final currentState = state as CatalogLoaded;

    try {
      await CatalogRepositoryImpl(
        CatalogRemoteDataSourceImpl(),
      ).createService(event.body);

      final updatedServices = await CatalogRepositoryImpl(
        CatalogRemoteDataSourceImpl(),
      ).getServices();

      emit(
        currentState.copyWith(
          services: () => updatedServices.services,
          loading: () => false,
        ),
      );

      context.pop();

      AppFloatingMessage.show(
        context,
        message: 'Serviço criado com sucesso.',
        type: AppFloatingMessageType.success,
      );
    } catch (e) {
      if (e is ApiFailure) {
        emit((state as CatalogLoaded).copyWith(loading: () => false));
        AppFloatingMessage.show(
          context,
          message: e.message,
          type: AppFloatingMessageType.error,
        );
        return;
      } else {
        emit((state as CatalogLoaded).copyWith(loading: () => false));
        AppFloatingMessage.show(
          context,
          message: 'Ocorreu um erro inesperado.',
          type: AppFloatingMessageType.error,
        );
        return;
      }
    }
  }

  Future<void> _onCreateProduct(
    CreateProduct event,
    Emitter<CatalogState> emit,
  ) async {
    emit((state as CatalogLoaded).copyWith(loading: () => true));

    final currentState = state as CatalogLoaded;

    try {
      await CatalogRepositoryImpl(
        CatalogRemoteDataSourceImpl(),
      ).createProduct(event.body);

      final updatedProducts = await CatalogRepositoryImpl(
        CatalogRemoteDataSourceImpl(),
      ).getProducts();

      emit(
        currentState.copyWith(
          products: () => updatedProducts.products,
          loading: () => false,
        ),
      );

      context.pop();

      AppFloatingMessage.show(
        context,
        message: 'Produto criado com sucesso.',
        type: AppFloatingMessageType.success,
      );
    } catch (e) {
      if (e is ApiFailure) {
        emit((state as CatalogLoaded).copyWith(loading: () => false));
        AppFloatingMessage.show(
          context,
          message: e.message,
          type: AppFloatingMessageType.error,
        );
        return;
      } else {
        emit((state as CatalogLoaded).copyWith(loading: () => false));
        AppFloatingMessage.show(
          context,
          message: 'Ocorreu um erro inesperado.',
          type: AppFloatingMessageType.error,
        );
        return;
      }
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<CatalogState> emit,
  ) async {
    emit((state as CatalogLoaded).copyWith(loading: () => true));

    final currentState = state as CatalogLoaded;

    try {
      await CatalogRepositoryImpl(
        CatalogRemoteDataSourceImpl(),
      ).updateProduct(event.productId, event.body);

      final updatedProducts = await CatalogRepositoryImpl(
        CatalogRemoteDataSourceImpl(),
      ).getProducts();

      emit(
        currentState.copyWith(
          products: () => updatedProducts.products,
          loading: () => false,
        ),
      );

      context.pop();
      context.pop();

      AppFloatingMessage.show(
        context,
        message: 'Produto atualizado com sucesso.',
        type: AppFloatingMessageType.success,
      );
    } catch (e) {
      if (e is ApiFailure) {
        emit((state as CatalogLoaded).copyWith(loading: () => false));
        AppFloatingMessage.show(
          context,
          message: e.message,
          type: AppFloatingMessageType.error,
        );
        return;
      } else {
        emit((state as CatalogLoaded).copyWith(loading: () => false));
        AppFloatingMessage.show(
          context,
          message: 'Ocorreu um erro inesperado.',
          type: AppFloatingMessageType.error,
        );
        return;
      }
    }
  }

  Future<void> _onUpdateCombo(
    UpdateCombo event,
    Emitter<CatalogState> emit,
  ) async {
    emit((state as CatalogLoaded).copyWith(loading: () => true));

    final currentState = state as CatalogLoaded;

    try {
      await CatalogRepositoryImpl(
        CatalogRemoteDataSourceImpl(),
      ).updateCombo(event.comboId, event.body);

      final updatedCombos = await CatalogRepositoryImpl(
        CatalogRemoteDataSourceImpl(),
      ).getCombos();

      emit(
        currentState.copyWith(
          combos: () => updatedCombos.combos,
          loading: () => false,
        ),
      );

      context.pop();
      context.pop();

      AppFloatingMessage.show(
        context,
        message: 'Combo atualizado com sucesso.',
        type: AppFloatingMessageType.success,
      );
    } catch (e) {
      if (e is ApiFailure) {
        emit((state as CatalogLoaded).copyWith(loading: () => false));
        AppFloatingMessage.show(
          context,
          message: e.message,
          type: AppFloatingMessageType.error,
        );
        return;
      } else {
        emit((state as CatalogLoaded).copyWith(loading: () => false));
        AppFloatingMessage.show(
          context,
          message: 'Ocorreu um erro inesperado.',
          type: AppFloatingMessageType.error,
        );
        return;
      }
    }
  }

  Future<void> _onUpdateService(
    UpdateService event,
    Emitter<CatalogState> emit,
  ) async {
    emit((state as CatalogLoaded).copyWith(loading: () => true));

    final currentState = state as CatalogLoaded;

    try {
      await CatalogRepositoryImpl(
        CatalogRemoteDataSourceImpl(),
      ).updateService(event.serviceId, event.body);

      final updatedServices = await CatalogRepositoryImpl(
        CatalogRemoteDataSourceImpl(),
      ).getServices();

      emit(
        currentState.copyWith(
          services: () => updatedServices.services,
          loading: () => false,
        ),
      );

      context.pop();
      context.pop();

      AppFloatingMessage.show(
        context,
        message: 'Serviço atualizado com sucesso.',
        type: AppFloatingMessageType.success,
      );
    } catch (e) {
      if (e is ApiFailure) {
        emit((state as CatalogLoaded).copyWith(loading: () => false));
        AppFloatingMessage.show(
          context,
          message: e.message,
          type: AppFloatingMessageType.error,
        );
        return;
      } else {
        emit((state as CatalogLoaded).copyWith(loading: () => false));
        AppFloatingMessage.show(
          context,
          message: 'Ocorreu um erro inesperado.',
          type: AppFloatingMessageType.error,
        );
        return;
      }
    }
  }

  Future<void> _onDeleteService(
    DeleteService event,
    Emitter<CatalogState> emit,
  ) async {
    emit(
      (state as CatalogLoaded).copyWith(
        loading: () => true,
        message: () => {'': ''},
      ),
    );

    final currentState = state as CatalogLoaded;

    try {
      await CatalogRepositoryImpl(
        CatalogRemoteDataSourceImpl(),
      ).deleteService(event.id);

      final updatedServices = currentState.services
          .where((service) => service.id != event.id)
          .toList();

      emit(currentState.copyWith(services: () => updatedServices));

      emit((state as CatalogLoaded).copyWith(loading: () => false));

      AppFloatingMessage.show(
        context,
        message: 'Serviço deletado com sucesso.',
        type: AppFloatingMessageType.success,
      );
    } catch (e) {
      if (e is ApiFailure) {
        emit((state as CatalogLoaded).copyWith(loading: () => false));
        AppFloatingMessage.show(
          context,
          message: e.message,
          type: AppFloatingMessageType.error,
        );
        return;
      }
    }
  }

  Future<void> _onDeleteCombo(
    DeleteCombo event,
    Emitter<CatalogState> emit,
  ) async {
    emit(
      (state as CatalogLoaded).copyWith(
        loading: () => true,
        message: () => {'': ''},
      ),
    );

    final currentState = state as CatalogLoaded;

    try {
      await CatalogRepositoryImpl(
        CatalogRemoteDataSourceImpl(),
      ).deleteCombo(event.id);

      final updatedCombos = currentState.combos
          .where((combo) => combo.id != event.id)
          .toList();

      emit(currentState.copyWith(combos: () => updatedCombos));
      emit((state as CatalogLoaded).copyWith(loading: () => false));

      AppFloatingMessage.show(
        context,
        message: 'Combo deletado com sucesso.',
        type: AppFloatingMessageType.success,
      );
    } catch (e) {
      if (e is ApiFailure) {
        emit((state as CatalogLoaded).copyWith(loading: () => false));
        AppFloatingMessage.show(
          context,
          message: e.message,
          type: AppFloatingMessageType.error,
        );
        return;
      }
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<CatalogState> emit,
  ) async {
    emit(
      (state as CatalogLoaded).copyWith(
        loading: () => true,
        message: () => {'': ''},
      ),
    );

    final currentState = state as CatalogLoaded;

    try {
      await CatalogRepositoryImpl(
        CatalogRemoteDataSourceImpl(),
      ).deleteProduct(event.id);

      final updatedProducts = currentState.products
          .where((product) => product.id != event.id)
          .toList();

      emit(currentState.copyWith(products: () => updatedProducts));

      emit((state as CatalogLoaded).copyWith(loading: () => false));

      AppFloatingMessage.show(
        context,
        message: 'Produto deletado com sucesso.',
        type: AppFloatingMessageType.success,
      );
    } catch (e) {
      if (e is ApiFailure) {
        emit((state as CatalogLoaded).copyWith(loading: () => false));
        AppFloatingMessage.show(
          context,
          message: e.message,
          type: AppFloatingMessageType.error,
        );
        return;
      }
    }
  }

  Future<void> _onCreateServiceCategorie(
    CreateServiceCategorie event,
    Emitter<CatalogState> emit,
  ) async {
    emit((state as CatalogLoaded).copyWith(loading: () => true));

    final currentState = state as CatalogLoaded;

    try {
      await CategorieRepositoryImpl(
        CategorieRemoteDataSourceImpl(),
      ).createServiceCategorie(event.body);

      final serviceCategories = await CatalogRepositoryImpl(
        CatalogRemoteDataSourceImpl(),
      ).getServiceCategories();

      emit(
        currentState.copyWith(
          loading: () => false,
          serviceCategories: () => serviceCategories.categories,
        ),
      );

      context.pop();

      AppFloatingMessage.show(
        context,
        message: 'Categoria criada com sucesso.',
        type: AppFloatingMessageType.success,
      );
    } catch (e) {
      if (e is ApiFailure) {
        emit((state as CatalogLoaded).copyWith(loading: () => false));
        AppFloatingMessage.show(
          context,
          message: e.message,
          type: AppFloatingMessageType.error,
        );
        return;
      } else {
        emit((state as CatalogLoaded).copyWith(loading: () => false));
        AppFloatingMessage.show(
          context,
          message: 'Ocorreu um erro inesperado.',
          type: AppFloatingMessageType.error,
        );
        return;
      }
    }
  }

  Future<void> _onCreateProductCategorie(
    CreateProductCategorie event,
    Emitter<CatalogState> emit,
  ) async {
    emit((state as CatalogLoaded).copyWith(loading: () => true));

    final currentState = state as CatalogLoaded;

    try {
      await CategorieRepositoryImpl(
        CategorieRemoteDataSourceImpl(),
      ).createProductCategorie(event.body);

      final productCategories = await CategorieRepositoryImpl(
        CategorieRemoteDataSourceImpl(),
      ).getProductCategories();

      emit(
        currentState.copyWith(
          loading: () => false,
          productCategories: () => productCategories.categories,
        ),
      );

      context.pop();

      AppFloatingMessage.show(
        context,
        message: 'Categoria criada com sucesso.',
        type: AppFloatingMessageType.success,
      );
    } catch (e) {
      if (e is ApiFailure) {
        emit((state as CatalogLoaded).copyWith(loading: () => false));
        AppFloatingMessage.show(
          context,
          message: e.message,
          type: AppFloatingMessageType.error,
        );
        return;
      } else {
        emit((state as CatalogLoaded).copyWith(loading: () => false));
        AppFloatingMessage.show(
          context,
          message: 'Ocorreu um erro inesperado.',
          type: AppFloatingMessageType.error,
        );
        return;
      }
    }
  }

  Future<void> _onCloseMessage(
    CloseMessage event,
    Emitter<CatalogState> emit,
  ) async {
    emit((state as CatalogLoaded).copyWith(message: () => {'': ''}));
  }

  Future<void> _onSetMessage(
    SetMessage event,
    Emitter<CatalogState> emit,
  ) async {
    emit((state as CatalogLoaded).copyWith(message: () => event.message));
  }
}
