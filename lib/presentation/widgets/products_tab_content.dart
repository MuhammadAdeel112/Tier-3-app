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
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.82,
              ),
              itemCount: viewModel.allProducts.length,
              itemBuilder: (context, idx) {
                final product = viewModel.allProducts[idx];
                return Container(
                  decoration: BoxDecoration(
                    color: viewModel.surfaceColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: viewModel.shadowColor,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: viewModel.primaryColor.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product.category,
                          style: TextStyle(color: viewModel.primaryColor, fontSize: 9, fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Text(
                          product.name,
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: viewModel.textPrimary),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${viewModel.formatCurrency(product.price)} PKR",
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: viewModel.primaryColor),
                      ),
                      Text(
                        "+ GST: ${(product.gstRate * 100).round()}%",
                        style: TextStyle(fontSize: 10, color: viewModel.textSecondary, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 32,
                        child: ElevatedButton.icon(
                          onPressed: () => viewModel.addProductToCart(product, tabController, context),
                          icon: const Icon(Icons.add_shopping_cart, size: 12),
                          label: const Text("ADD TO CART", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: viewModel.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
