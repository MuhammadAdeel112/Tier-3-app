import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/tax_report.dart';
import '../../domain/entities/invoice_history_item.dart';
import '../../domain/usecases/billing_calculations.dart';

class FBRBillingState extends Equatable {
  final bool isDarkMode;
  final int activeTabIndex;
  final String selectedSalesType;
  final String selectedCustomer;
  final bool showCustomerDropdown;
  final List<Product> allProducts;
  final int currentPage;
  final int itemsPerPage;
  final String productSearchQuery;
  final List<CartItem> cartItems;
  final List<TaxReport> taxReports;
  final List<InvoiceHistoryItem> invoiceHistory;

  final List<String> salesTypes = const [
    "T1 - General Goods (18% GST)",
    "T2 - Services (16% GST)",
    "T3 - Special Procedure (8% GST)",
    "T4 - Zero Rated (0% GST)",
    "T5 - Exemption Regime",
    "T6 - Cottage Industry",
    "T7 - Secure VPN Infrastructure",
    "T8 - Digital Audits & Scanning",
    "T9 - Wholesaler Distribution",
    "T10 - Secure Cloud Hosting",
    "T11 - Software Licensing",
    "T12 - Hardware Assembly & POS",
    "T13 - Retail Trade (General)"
  ];

  final List<String> mockCustomers = const [
    "Secured Client Corp (ID: SEC-99482)",
    "Apex Cyber Defence (ID: APX-22910)",
    "Global Fintech Solutions (ID: GFS-44123)",
    "National Cryptography Corp (ID: NCC-00812)",
    "Quantum Systems Ltd (ID: QSL-77615)"
  ];

  final List<int> itemsPerPageOptions = const [10, 20, 30, 40, 50, 60];

  const FBRBillingState({
    this.isDarkMode = false,
    this.activeTabIndex = 0,
    required this.selectedSalesType,
    required this.selectedCustomer,
    this.showCustomerDropdown = false,
    required this.allProducts,
    this.currentPage = 0,
    this.itemsPerPage = 10,
    this.productSearchQuery = "",
    required this.cartItems,
    required this.taxReports,
    required this.invoiceHistory,
  });

  FBRBillingState copyWith({
    bool? isDarkMode,
    int? activeTabIndex,
    String? selectedSalesType,
    String? selectedCustomer,
    bool? showCustomerDropdown,
    List<Product>? allProducts,
    int? currentPage,
    int? itemsPerPage,
    String? productSearchQuery,
    List<CartItem>? cartItems,
    List<TaxReport>? taxReports,
    List<InvoiceHistoryItem>? invoiceHistory,
  }) {
    return FBRBillingState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      selectedSalesType: selectedSalesType ?? this.selectedSalesType,
      selectedCustomer: selectedCustomer ?? this.selectedCustomer,
      showCustomerDropdown: showCustomerDropdown ?? this.showCustomerDropdown,
      allProducts: allProducts ?? this.allProducts,
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      productSearchQuery: productSearchQuery ?? this.productSearchQuery,
      cartItems: cartItems ?? this.cartItems,
      taxReports: taxReports ?? this.taxReports,
      invoiceHistory: invoiceHistory ?? this.invoiceHistory,
    );
  }

  // --- Dynamic Styling Getters ---
  Color get primaryColor => isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFF0D47A1);
  Color get accentColor => isDarkMode ? const Color(0xFF00E5FF) : const Color(0xFFFFB300);
  Color get backgroundColor => isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F7);
  Color get surfaceColor => isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
  Color get dangerColor => isDarkMode ? const Color(0xFFE53935) : const Color(0xFFD32F2F);
  Color get successColor => isDarkMode ? const Color(0xFF43A047) : const Color(0xFF2E7D32);
  Color get textPrimary => isDarkMode ? const Color(0xFFFFFFFF) : const Color(0xFF1E293B);
  Color get textSecondary => isDarkMode ? const Color(0xFFA0AAB5) : const Color(0xFF64748B);
  Color get dividerColor => isDarkMode ? const Color(0xFF333333) : Colors.grey.shade300;
  Color get shadowColor => isDarkMode ? Colors.black.withValues(alpha: 0.5) : Colors.black12;

  // --- Dynamic Calculation Getters ---
  double get subtotal {
    return cartItems.fold(0, (sum, item) => sum + item.totalSubtotal);
  }

  double get gstTotal {
    return cartItems.fold(0, (sum, item) => sum + item.totalGst);
  }

  double get whtTotal {
    return BillingCalculations.calculateWht(subtotal);
  }

  double get grandTotal {
    return subtotal + gstTotal + whtTotal;
  }

  // --- Formatting Helpers ---
  String formatCurrency(double amount) {
    String str = amount.round().toString();
    if (str.length <= 3) return str;
    
    String formatted = "";
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count == 3) {
        formatted = ",$formatted";
        count = 0;
      }
      formatted = str[i] + formatted;
      count++;
    }
    return formatted;
  }

  List<Product> get filteredProducts {
    if (productSearchQuery.isEmpty) return allProducts;
    final query = productSearchQuery.toLowerCase();
    return allProducts.where((p) => 
      p.name.toLowerCase().contains(query) || 
      p.category.toLowerCase().contains(query) || 
      p.id.toLowerCase().contains(query)
    ).toList();
  }

  List<Product> get paginatedProducts {
    final list = filteredProducts;
    final startIndex = currentPage * itemsPerPage;
    final endIndex = (startIndex + itemsPerPage < list.length) ? (startIndex + itemsPerPage) : list.length;
    if (startIndex >= list.length) return [];
    return list.sublist(startIndex, endIndex);
  }

  int get totalPages {
    final list = filteredProducts;
    if (list.isEmpty) return 1;
    return (list.length / itemsPerPage).ceil();
  }

  @override
  List<Object?> get props => [
    isDarkMode,
    activeTabIndex,
    selectedSalesType,
    selectedCustomer,
    showCustomerDropdown,
    allProducts,
    currentPage,
    itemsPerPage,
    productSearchQuery,
    cartItems,
    taxReports,
    invoiceHistory,
  ];
}
