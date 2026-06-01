import 'package:flutter/material.dart';
import '../viewmodels/fbr_billing_viewmodel.dart';
import 'customer_search_bar.dart';
import 'sales_type_dropdown.dart';
import 'cart_item_card.dart';
import 'sticky_summary_footer.dart';

class BillingTabContent extends StatelessWidget {
  final FBRBillingViewModel viewModel;
  final TabController tabController;

  const BillingTabContent({
    super.key,
    required this.viewModel,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Security Status Indicators
        Container(
          width: double.infinity,
          color: viewModel.primaryColor.withValues(alpha: 0.08),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: viewModel.successColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "SECURE POS CHANNEL STABLE | SYSTEM INTEGRITY CHECK PASSED",
                  style: TextStyle(
                    color: viewModel.primaryColor,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        // Scrollable Configurator
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomerSearchBar(viewModel: viewModel),
                const SizedBox(height: 16),
                SalesTypeDropdown(viewModel: viewModel),
                const SizedBox(height: 20),
                
                // Cart Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.shopping_cart_outlined, color: viewModel.primaryColor, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          "BILLING CART ITEMS",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: viewModel.textPrimary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: viewModel.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${viewModel.cartItems.length} Products",
                        style: TextStyle(
                          color: viewModel.primaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 12),

                // Cart List Elements
                viewModel.cartItems.isEmpty
                    ? _buildEmptyCartPlaceholder()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: viewModel.cartItems.length,
                        itemBuilder: (context, index) {
                          return CartItemCard(
                            viewModel: viewModel,
                            item: viewModel.cartItems[index],
                            index: index,
                          );
                        },
                      ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),

        // Sticky Summary Bottom Footer
        StickySummaryFooter(viewModel: viewModel),
      ],
    );
  }

  Widget _buildEmptyCartPlaceholder() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
      decoration: BoxDecoration(
        color: viewModel.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: viewModel.dividerColor, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Icon(Icons.shopping_bag_outlined, color: viewModel.textSecondary.withValues(alpha: 0.3), size: 48),
          const SizedBox(height: 12),
          Text(
            "Billing Cart is Empty",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: viewModel.textPrimary),
          ),
          const SizedBox(height: 4),
          Text(
            "Go to the 'Products' tab to securely add items",
            style: TextStyle(fontSize: 12, color: viewModel.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => tabController.animateTo(1),
            icon: const Icon(Icons.add),
            label: const Text("BROWSE SECURE PRODUCTS"),
            style: ElevatedButton.styleFrom(
              backgroundColor: viewModel.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}
