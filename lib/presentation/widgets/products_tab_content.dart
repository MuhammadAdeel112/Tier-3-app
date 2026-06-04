import 'package:flutter/material.dart';
import '../viewmodels/fbr_billing_viewmodel.dart';

class ProductsTabContent extends StatelessWidget {
  final FBRBillingViewModel viewModel;
  final TabController tabController;

  const ProductsTabContent({
    super.key,
    required this.viewModel,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: viewModel.backgroundColor,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SECURE HARDWARE & SOFTWARE INVENTORY",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: viewModel.primaryColor,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          
          Expanded(
            child: Column(
              children: [
                // Search Bar
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: viewModel.surfaceColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: viewModel.dividerColor),
                  ),
                  child: TextField(
                    onChanged: viewModel.setProductSearchQuery,
                    style: TextStyle(fontSize: 13, color: viewModel.textPrimary),
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: viewModel.textSecondary, size: 20),
                      hintText: "Search products by name, ID, or category...",
                      hintStyle: TextStyle(fontSize: 13, color: viewModel.textSecondary),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Products Inventory", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: viewModel.textPrimary)),
                    Row(
                      children: [
                        Text("Show: ", style: TextStyle(color: viewModel.textSecondary, fontSize: 12)),
                        DropdownButton<int>(
                          value: viewModel.itemsPerPage,
                          isDense: true,
                          dropdownColor: viewModel.surfaceColor,
                          underline: const SizedBox(),
                          items: viewModel.itemsPerPageOptions.map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString(), style: TextStyle(color: viewModel.textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null) viewModel.setItemsPerPage(newValue);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: viewModel.surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: viewModel.shadowColor,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        // Table Header
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: viewModel.primaryColor.withValues(alpha: 0.1),
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                          ),
                          child: Row(
                            children: [
                              Expanded(flex: 3, child: Text("PRODUCT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: viewModel.primaryColor))),
                              Expanded(flex: 2, child: Text("CATEGORY", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: viewModel.primaryColor))),
                              Expanded(flex: 2, child: Text("PRICE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: viewModel.primaryColor))),
                              Expanded(flex: 2, child: Text("ACTION", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: viewModel.primaryColor))),
                            ],
                          ),
                        ),
                        // Table Body
                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: viewModel.paginatedProducts.length,
                            separatorBuilder: (context, index) => Divider(color: viewModel.dividerColor, height: 1),
                            itemBuilder: (context, index) {
                              final product = viewModel.paginatedProducts[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(product.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: viewModel.textPrimary)),
                                          const SizedBox(height: 2),
                                          Text("ID: ${product.id}", style: TextStyle(fontSize: 10, color: viewModel.textSecondary)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: viewModel.primaryColor.withValues(alpha: 0.06),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            product.category,
                                            style: TextStyle(color: viewModel.primaryColor, fontSize: 10, fontWeight: FontWeight.w600),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("${viewModel.formatCurrency(product.price)} PKR", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: viewModel.textPrimary)),
                                          Text("+ GST: ${(product.gstRate * 100).round()}%", style: TextStyle(fontSize: 9, color: viewModel.textSecondary)),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: SizedBox(
                                          height: 32,
                                          child: ElevatedButton.icon(
                                            onPressed: () => viewModel.addProductToCart(product, tabController, context),
                                            icon: const Icon(Icons.add_shopping_cart, size: 12),
                                            label: const Text("ADD", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: viewModel.primaryColor,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        // Pagination Controls
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border(top: BorderSide(color: viewModel.dividerColor)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Page ${viewModel.currentPage + 1} of ${viewModel.totalPages}",
                                style: TextStyle(color: viewModel.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.chevron_left, size: 24),
                                    color: viewModel.currentPage > 0 ? viewModel.primaryColor : viewModel.dividerColor,
                                    onPressed: viewModel.currentPage > 0 ? () => viewModel.setPage(viewModel.currentPage - 1) : null,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  const SizedBox(width: 16),
                                  IconButton(
                                    icon: const Icon(Icons.chevron_right, size: 24),
                                    color: viewModel.currentPage < viewModel.totalPages - 1 ? viewModel.primaryColor : viewModel.dividerColor,
                                    onPressed: viewModel.currentPage < viewModel.totalPages - 1 ? () => viewModel.setPage(viewModel.currentPage + 1) : null,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
