import 'package:flutter/material.dart';
import '../../domain/entities/cart_item.dart';
import '../viewmodels/fbr_billing_viewmodel.dart';

class CartItemCard extends StatelessWidget {
  final FBRBillingViewModel viewModel;
  final CartItem item;
  final int index;

  const CartItemCard({
    super.key,
    required this.viewModel,
    required this.item,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.product.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: viewModel.dangerColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.red),
      ),
      onDismissed: (_) => viewModel.removeCartItem(index, context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: viewModel.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: viewModel.shadowColor,
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
          border: Border.all(color: viewModel.dividerColor, width: 1.2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon category badge
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: viewModel.primaryColor.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      item.product.category.contains("Hardware") ? Icons.dns : Icons.terminal,
                      color: viewModel.primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Item details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${index + 1}. ${item.product.name}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: viewModel.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Qty: ${item.quantity}  |  Price: ${viewModel.formatCurrency(item.product.price)} PKR  |  GST: ${(item.product.gstRate * 100).round()}%",
                          style: TextStyle(
                            fontSize: 11,
                            color: viewModel.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(height: 16, thickness: 0.8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Quantity Selector Controls
                  Row(
                    children: [
                      _buildQtyBtn(Icons.remove, () => viewModel.decreaseQuantity(index, context)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          "${item.quantity}",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: viewModel.textPrimary,
                          ),
                        ),
                      ),
                      _buildQtyBtn(Icons.add, () => viewModel.increaseQuantity(index)),
                    ],
                  ),
                  
                  // Subtotal for single product card
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Subtotal + Tax",
                        style: TextStyle(fontSize: 9, color: viewModel.textSecondary, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${viewModel.formatCurrency(item.totalGrand)} PKR",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: viewModel.primaryColor,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: viewModel.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, size: 14, color: viewModel.primaryColor),
        padding: EdgeInsets.zero,
        onPressed: onPressed,
      ),
    );
  }
}
