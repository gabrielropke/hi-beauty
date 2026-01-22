part of 'catalog_bloc.dart';

abstract class CatalogEvent extends Equatable {
  const CatalogEvent();

  @override
  List<Object?> get props => [];
}

class CatalogLoadRequested extends CatalogEvent {}

class SetMessage extends CatalogEvent {
  final Map<String, String> message;

  const SetMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class CloseMessage extends CatalogEvent {}

class DeleteService extends CatalogEvent {
  final String id;

  const DeleteService(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateService extends CatalogEvent {
  final CreateServiceModel body;

  const CreateService(this.body);

  @override
  List<Object?> get props => [body];
}

class UpdateService extends CatalogEvent {
  final String serviceId;
  final CreateServiceModel body;

  const UpdateService(this.serviceId, this.body);

  @override
  List<Object?> get props => [serviceId, body];
}

class CreateServiceCategorie extends CatalogEvent {
  final CreateCategorieModel body;

  const CreateServiceCategorie(this.body);

  @override
  List<Object?> get props => [body];
}

class DeleteProduct extends CatalogEvent {
  final String id;

  const DeleteProduct(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateProduct extends CatalogEvent {
  final CreateProductModel body;

  const CreateProduct(this.body);

  @override
  List<Object?> get props => [body];
}

class CreateProductCategorie extends CatalogEvent {
  final CreateCategorieModel body;

  const CreateProductCategorie(this.body);

  @override
  List<Object?> get props => [body];
}

class UpdateProduct extends CatalogEvent {
  final String productId;
  final CreateProductModel body;

  const UpdateProduct(this.productId, this.body);

  @override
  List<Object?> get props => [productId, body];
}

class AdjustStock extends CatalogEvent {
  final String id;
  final int delta;
  final String reason;

  const AdjustStock(this.id, this.delta, this.reason);

  @override
  List<Object?> get props => [id, delta, reason];
}

class CreateCombo extends CatalogEvent {
  final CreateComboModel body;

  const CreateCombo(this.body);

  @override
  List<Object?> get props => [body];
}

class DeleteCombo extends CatalogEvent {
  final String id;

  const DeleteCombo(this.id);

  @override
  List<Object?> get props => [id];
}

class UpdateCombo extends CatalogEvent {
  final String comboId;
  final CreateComboModel body;

  const UpdateCombo(this.comboId, this.body);

  @override
  List<Object?> get props => [comboId, body];
}