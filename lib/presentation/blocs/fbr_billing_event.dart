import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

abstract class FBRBillingEvent extends Equatable {
  const FBRBillingEvent();

  @override
  List<Object?> get props => [];
}

class ToggleThemeEvent extends FBRBillingEvent {}

class ChangeActiveTabEvent extends FBRBillingEvent {
  final int newIndex;
  const ChangeActiveTabEvent(this.newIndex);

  @override
  List<Object?> get props => [newIndex];
}

class SetSalesTypeEvent extends FBRBillingEvent {
  final String salesType;
  const SetSalesTypeEvent(this.salesType);

  @override
  List<Object?> get props => [salesType];
}

class SetCustomerEvent extends FBRBillingEvent {
  final String customer;
  final TextEditingController controller;
  const SetCustomerEvent(this.customer, this.controller);

  @override
  List<Object?> get props => [customer, controller];
}

class ToggleCustomerDropdownEvent extends FBRBillingEvent {
  final bool visible;
  const ToggleCustomerDropdownEvent(this.visible);

  @override
  List<Object?> get props => [visible];
}

class OnCustomerSearchChangedEvent extends FBRBillingEvent {
  final String query;
  const OnCustomerSearchChangedEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class SetItemsPerPageEvent extends FBRBillingEvent {
  final int itemsPerPage;
  const SetItemsPerPageEvent(this.itemsPerPage);

  @override
  List<Object?> get props => [itemsPerPage];
}

class SetPageEvent extends FBRBillingEvent {
  final int page;
  const SetPageEvent(this.page);

  @override
  List<Object?> get props => [page];
}

class SetProductSearchQueryEvent extends FBRBillingEvent {
  final String query;
  const SetProductSearchQueryEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class AddProductToCartEvent extends FBRBillingEvent {
  final Product product;
  final TabController tabController;
  final BuildContext context;

  const AddProductToCartEvent(this.product, this.tabController, this.context);

  @override
  List<Object?> get props => [product, tabController, context];
}

class IncreaseQuantityEvent extends FBRBillingEvent {
  final int index;
  const IncreaseQuantityEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class DecreaseQuantityEvent extends FBRBillingEvent {
  final int index;
  final BuildContext context;
  const DecreaseQuantityEvent(this.index, this.context);

  @override
  List<Object?> get props => [index, context];
}

class RemoveCartItemEvent extends FBRBillingEvent {
  final int index;
  final BuildContext context;
  const RemoveCartItemEvent(this.index, this.context);

  @override
  List<Object?> get props => [index, context];
}

class InsertCartItemEvent extends FBRBillingEvent {
  final int index;
  final dynamic removedItem; // using dynamic to avoid passing CartItem directly if not imported, though it is imported via state. Wait, we should import CartItem. Let's just pass CartItem.
  const InsertCartItemEvent(this.index, this.removedItem);

  @override
  List<Object?> get props => [index, removedItem];
}

class FinalizeTransactionEvent extends FBRBillingEvent {}
