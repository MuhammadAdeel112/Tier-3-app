import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/tax_report.dart';
import '../../domain/entities/invoice_history_item.dart';
import 'fbr_billing_event.dart';
import 'fbr_billing_state.dart';

class FBRBillingBloc extends Bloc<FBRBillingEvent, FBRBillingState> {
  FBRBillingBloc() : super(_initialState()) {
    on<ToggleThemeEvent>(_onToggleTheme);
    on<ChangeActiveTabEvent>(_onChangeActiveTab);
    on<SetSalesTypeEvent>(_onSetSalesType);
    on<SetCustomerEvent>(_onSetCustomer);
    on<ToggleCustomerDropdownEvent>(_onToggleCustomerDropdown);
    on<OnCustomerSearchChangedEvent>(_onCustomerSearchChanged);
    on<SetItemsPerPageEvent>(_onSetItemsPerPage);
    on<SetPageEvent>(_onSetPage);
    on<SetProductSearchQueryEvent>(_onSetProductSearchQuery);
    on<AddProductToCartEvent>(_onAddProductToCart);
    on<IncreaseQuantityEvent>(_onIncreaseQuantity);
    on<DecreaseQuantityEvent>(_onDecreaseQuantity);
    on<RemoveCartItemEvent>(_onRemoveCartItem);
    on<InsertCartItemEvent>(_onInsertCartItem);
    on<FinalizeTransactionEvent>(_onFinalizeTransaction);
  }

  static FBRBillingState _initialState() {
    final initialProducts = [
      const Product(id: "P1", name: "HP Laptop Pro EliteBook", price: 85000, gstRate: 0.18, category: "Hardware"),
      const Product(id: "P2", name: "Microsoft Office 365 Enterprise", price: 30000, gstRate: 0.18, category: "Software"),
      const Product(id: "P3", name: "Tier3 Gateway Firewall Appliance", price: 120000, gstRate: 0.18, category: "Security Hardware"),
      const Product(id: "P4", name: "Sentinel IPS Subscription (1 Year)", price: 45000, gstRate: 0.18, category: "Security Subscriptions"),
      const Product(id: "P5", name: "Secure VPN Hardware Token v2", price: 15000, gstRate: 0.18, category: "Security Accessories"),
      const Product(id: "P6", name: "Cybersecurity Compliance Audit Kit", price: 95000, gstRate: 0.18, category: "Services"),
    ];
    
    final allProducts = [
      ...initialProducts,
      ...List.generate(54, (index) {
        final i = index + 7;
        return Product(
          id: "P$i",
          name: "Enterprise Security Product $i",
          price: 10000.0 + (i * 2000),
          gstRate: 0.18,
          category: i % 3 == 0 ? "Software" : (i % 2 == 0 ? "Services" : "Hardware"),
        );
      })
    ];

    return FBRBillingState(
      selectedSalesType: "T1 - General Goods (18% GST)",
      selectedCustomer: "Secured Client Corp (ID: SEC-99482)",
      allProducts: allProducts,
      cartItems: [
        CartItem(product: allProducts[0], quantity: 1),
        CartItem(product: allProducts[1], quantity: 1),
      ],
      taxReports: const [
        TaxReport(month: "May 2026", sales: "3,450,000 PKR", gst: "621,000 PKR", wht: "44,850 PKR", status: "Filed & Audited"),
        TaxReport(month: "April 2026", sales: "2,890,000 PKR", gst: "520,200 PKR", wht: "37,570 PKR", status: "Filed & Audited"),
        TaxReport(month: "March 2026", sales: "4,120,000 PKR", gst: "741,600 PKR", wht: "53,560 PKR", status: "Filed & Audited"),
      ],
      invoiceHistory: const [
        InvoiceHistoryItem(invId: "T3-FBR-884920-11", customer: "Apex Cyber Defence", date: "01 June 2026 14:10", total: "137,200 PKR", status: "Synced"),
        InvoiceHistoryItem(invId: "T3-FBR-884919-09", customer: "Quantum Systems Ltd", date: "30 May 2026 18:32", total: "53,100 PKR", status: "Synced"),
        InvoiceHistoryItem(invId: "T3-FBR-884898-05", customer: "Global Fintech Solutions", date: "28 May 2026 11:15", total: "212,400 PKR", status: "Synced"),
        InvoiceHistoryItem(invId: "T3-FBR-884766-01", customer: "National Cryptography Corp", date: "25 May 2026 09:44", total: "1,850,000 PKR", status: "Audited"),
      ],
    );
  }

  void _onToggleTheme(ToggleThemeEvent event, Emitter<FBRBillingState> emit) {
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }

  void _onChangeActiveTab(ChangeActiveTabEvent event, Emitter<FBRBillingState> emit) {
    emit(state.copyWith(activeTabIndex: event.newIndex));
  }

  void _onSetSalesType(SetSalesTypeEvent event, Emitter<FBRBillingState> emit) {
    emit(state.copyWith(selectedSalesType: event.salesType));
  }

  void _onSetCustomer(SetCustomerEvent event, Emitter<FBRBillingState> emit) {
    event.controller.text = event.customer;
    emit(state.copyWith(
      selectedCustomer: event.customer,
      showCustomerDropdown: false,
    ));
  }

  void _onToggleCustomerDropdown(ToggleCustomerDropdownEvent event, Emitter<FBRBillingState> emit) {
    emit(state.copyWith(showCustomerDropdown: event.visible));
  }

  void _onCustomerSearchChanged(OnCustomerSearchChangedEvent event, Emitter<FBRBillingState> emit) {
    emit(state.copyWith(showCustomerDropdown: true));
  }

  void _onSetItemsPerPage(SetItemsPerPageEvent event, Emitter<FBRBillingState> emit) {
    emit(state.copyWith(itemsPerPage: event.itemsPerPage, currentPage: 0));
  }

  void _onSetPage(SetPageEvent event, Emitter<FBRBillingState> emit) {
    emit(state.copyWith(currentPage: event.page));
  }

  void _onSetProductSearchQuery(SetProductSearchQueryEvent event, Emitter<FBRBillingState> emit) {
    emit(state.copyWith(productSearchQuery: event.query, currentPage: 0));
  }

  void _onAddProductToCart(AddProductToCartEvent event, Emitter<FBRBillingState> emit) {
    final updatedCart = List<CartItem>.from(state.cartItems);
    int existingIndex = updatedCart.indexWhere((item) => item.product.id == event.product.id);
    
    if (existingIndex != -1) {
      final currentItem = updatedCart[existingIndex];
      updatedCart[existingIndex] = CartItem(
        product: currentItem.product,
        quantity: currentItem.quantity + 1,
      );
    } else {
      updatedCart.add(CartItem(product: event.product));
    }
    
    event.tabController.animateTo(0);
    emit(state.copyWith(cartItems: updatedCart, activeTabIndex: 0));

    ScaffoldMessenger.of(event.context).clearSnackBars();
    ScaffoldMessenger.of(event.context).showSnackBar(
      SnackBar(
        content: Text("Added ${event.product.name} to cart."),
        backgroundColor: state.successColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _onIncreaseQuantity(IncreaseQuantityEvent event, Emitter<FBRBillingState> emit) {
    final updatedCart = List<CartItem>.from(state.cartItems);
    final currentItem = updatedCart[event.index];
    updatedCart[event.index] = CartItem(
      product: currentItem.product,
      quantity: currentItem.quantity + 1,
    );
    emit(state.copyWith(cartItems: updatedCart));
  }

  void _onDecreaseQuantity(DecreaseQuantityEvent event, Emitter<FBRBillingState> emit) {
    final updatedCart = List<CartItem>.from(state.cartItems);
    final currentItem = updatedCart[event.index];
    if (currentItem.quantity > 1) {
      updatedCart[event.index] = CartItem(
        product: currentItem.product,
        quantity: currentItem.quantity - 1,
      );
      emit(state.copyWith(cartItems: updatedCart));
    } else {
      add(RemoveCartItemEvent(event.index, event.context));
    }
  }

  void _onRemoveCartItem(RemoveCartItemEvent event, Emitter<FBRBillingState> emit) {
    final updatedCart = List<CartItem>.from(state.cartItems);
    final removedItem = updatedCart.removeAt(event.index);
    emit(state.copyWith(cartItems: updatedCart));

    ScaffoldMessenger.of(event.context).clearSnackBars();
    ScaffoldMessenger.of(event.context).showSnackBar(
      SnackBar(
        content: Text("Removed ${removedItem.product.name} from cart."),
        backgroundColor: state.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          textColor: state.accentColor,
          label: "UNDO",
          onPressed: () {
            add(InsertCartItemEvent(event.index, removedItem));
          },
        ),
      ),
    );
  }

  void _onInsertCartItem(InsertCartItemEvent event, Emitter<FBRBillingState> emit) {
    final updatedCart = List<CartItem>.from(state.cartItems);
    updatedCart.insert(event.index, event.removedItem as CartItem);
    emit(state.copyWith(cartItems: updatedCart));
  }

  void _onFinalizeTransaction(FinalizeTransactionEvent event, Emitter<FBRBillingState> emit) {
    emit(state.copyWith(cartItems: []));
  }
}
