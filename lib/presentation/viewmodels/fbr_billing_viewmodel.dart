import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/tax_report.dart';
import '../../domain/entities/invoice_history_item.dart';
import '../../domain/usecases/billing_calculations.dart';

class FBRBillingViewModel extends ChangeNotifier {
  // --- Theme State ---
  bool isDarkMode = false;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
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

  // --- States & Data Stores ---
  int activeTabIndex = 0;
  
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
  late String selectedSalesType;

  final List<String> mockCustomers = const [
    "Secured Client Corp (ID: SEC-99482)",
    "Apex Cyber Defence (ID: APX-22910)",
    "Global Fintech Solutions (ID: GFS-44123)",
    "National Cryptography Corp (ID: NCC-00812)",
    "Quantum Systems Ltd (ID: QSL-77615)"
  ];
  String selectedCustomer = "Secured Client Corp (ID: SEC-99482)";
  
  final TextEditingController customerSearchController = TextEditingController();
  bool showCustomerDropdown = false;

  late final List<Product> allProducts;
  
  // Pagination & Search State
  int currentPage = 0;
  int itemsPerPage = 10;
  final List<int> itemsPerPageOptions = [10, 20, 30, 40, 50, 60];
  String productSearchQuery = "";

  final List<CartItem> cartItems = [];

  final List<TaxReport> taxReports = const [
    TaxReport(month: "May 2026", sales: "3,450,000 PKR", gst: "621,000 PKR", wht: "44,850 PKR", status: "Filed & Audited"),
    TaxReport(month: "April 2026", sales: "2,890,000 PKR", gst: "520,200 PKR", wht: "37,570 PKR", status: "Filed & Audited"),
    TaxReport(month: "March 2026", sales: "4,120,000 PKR", gst: "741,600 PKR", wht: "53,560 PKR", status: "Filed & Audited"),
  ];

  final List<InvoiceHistoryItem> invoiceHistory = const [
    InvoiceHistoryItem(invId: "T3-FBR-884920-11", customer: "Apex Cyber Defence", date: "01 June 2026 14:10", total: "137,200 PKR", status: "Synced"),
    InvoiceHistoryItem(invId: "T3-FBR-884919-09", customer: "Quantum Systems Ltd", date: "30 May 2026 18:32", total: "53,100 PKR", status: "Synced"),
    InvoiceHistoryItem(invId: "T3-FBR-884898-05", customer: "Global Fintech Solutions", date: "28 May 2026 11:15", total: "212,400 PKR", status: "Synced"),
    InvoiceHistoryItem(invId: "T3-FBR-884766-01", customer: "National Cryptography Corp", date: "25 May 2026 09:44", total: "1,850,000 PKR", status: "Audited"),
  ];

  FBRBillingViewModel() {
    selectedSalesType = salesTypes[0];
    customerSearchController.text = selectedCustomer;

    final initialProducts = [
      const Product(id: "P1", name: "HP Laptop Pro EliteBook", price: 85000, gstRate: 0.18, category: "Hardware"),
      const Product(id: "P2", name: "Microsoft Office 365 Enterprise", price: 30000, gstRate: 0.18, category: "Software"),
      const Product(id: "P3", name: "Tier3 Gateway Firewall Appliance", price: 120000, gstRate: 0.18, category: "Security Hardware"),
      const Product(id: "P4", name: "Sentinel IPS Subscription (1 Year)", price: 45000, gstRate: 0.18, category: "Security Subscriptions"),
      const Product(id: "P5", name: "Secure VPN Hardware Token v2", price: 15000, gstRate: 0.18, category: "Security Accessories"),
      const Product(id: "P6", name: "Cybersecurity Compliance Audit Kit", price: 95000, gstRate: 0.18, category: "Services"),
    ];
    
    allProducts = [
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

    // Pre-populate cart (Defaults matching mockup requirements):
    cartItems.add(CartItem(product: allProducts[0], quantity: 1));
    cartItems.add(CartItem(product: allProducts[1], quantity: 1));
  }

  @override
  void dispose() {
    customerSearchController.dispose();
    super.dispose();
  }

  // --- Dynamic Calculation Getters ---
  double get subtotal {
    return cartItems.fold(0, (sum, item) => sum + item.totalSubtotal);
  }

  double get gstTotal {
    return cartItems.fold(0, (sum, item) => sum + item.totalGst);
  }

  // Uses Domain Usecase for tax calculations
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

  // --- Business Operations & State Setters ---
  void changeActiveTab(int newIndex) {
    activeTabIndex = newIndex;
    notifyListeners();
  }

  void setSalesType(String value) {
    selectedSalesType = value;
    notifyListeners();
  }

  // Pagination Setters
  void setItemsPerPage(int value) {
    itemsPerPage = value;
    currentPage = 0; // Reset to first page when changing items per page
    notifyListeners();
  }

  void setPage(int page) {
    currentPage = page;
    notifyListeners();
  }

  void setProductSearchQuery(String query) {
    productSearchQuery = query;
    currentPage = 0;
    notifyListeners();
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

  void setCustomer(String customer) {
    selectedCustomer = customer;
    customerSearchController.text = customer;
    showCustomerDropdown = false;
    notifyListeners();
  }

  void toggleCustomerDropdown(bool visible) {
    showCustomerDropdown = visible;
    notifyListeners();
  }

  void onCustomerSearchChanged(String value) {
    showCustomerDropdown = true;
    notifyListeners();
  }

  void increaseQuantity(int index) {
    cartItems[index].quantity++;
    notifyListeners();
  }

  void decreaseQuantity(int index, BuildContext context) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
      notifyListeners();
    } else {
      removeCartItem(index, context);
    }
  }

  void removeCartItem(int index, BuildContext context) {
    final removedItem = cartItems[index];
    cartItems.removeAt(index);
    notifyListeners();

    // Trigger premium Undo micro-interaction snackbar
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Removed ${removedItem.product.name} from cart."),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          textColor: accentColor,
          label: "UNDO",
          onPressed: () {
            cartItems.insert(index, removedItem);
            notifyListeners();
          },
        ),
      ),
    );
  }

  void addProductToCart(Product product, TabController tabController, BuildContext context) {
    int existingIndex = cartItems.indexWhere((item) => item.product.id == product.id);
    if (existingIndex != -1) {
      cartItems[existingIndex].quantity++;
    } else {
      cartItems.add(CartItem(product: product));
    }
    
    activeTabIndex = 0;
    tabController.animateTo(0);
    notifyListeners();

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Added ${product.name} to cart."),
        backgroundColor: successColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void finalizeTransaction() {
    cartItems.clear();
    notifyListeners();
  }
}
