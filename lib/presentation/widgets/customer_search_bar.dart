import 'package:flutter/material.dart';
import '../viewmodels/fbr_billing_viewmodel.dart';

class CustomerSearchBar extends StatelessWidget {
  final FBRBillingViewModel viewModel;

  const CustomerSearchBar({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
              ),
              child: TextField(
                controller: viewModel.customerSearchController,
                style: TextStyle(color: viewModel.textPrimary, fontSize: 14, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: "Customer Search",
                  hintStyle: TextStyle(color: viewModel.textSecondary.withValues(alpha: 0.7)),
                  prefixIcon: Icon(Icons.search, color: viewModel.primaryColor),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.qr_code_scanner, color: viewModel.primaryColor),
                        tooltip: "Scan Barcode/QR",
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("FBR QR scanner active... listening for client security token."),
                              backgroundColor: viewModel.primaryColor,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          viewModel.showCustomerDropdown ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          color: viewModel.primaryColor,
                        ),
                        onPressed: () {
                          viewModel.toggleCustomerDropdown(!viewModel.showCustomerDropdown);
                        },
                      ),
                    ],
                  ),
                  filled: true,
                  fillColor: viewModel.surfaceColor,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: viewModel.primaryColor, width: 1.5),
                  ),
                ),
                onChanged: viewModel.onCustomerSearchChanged,
              ),
            ),
            
            // Search dropdown list simulator
            if (viewModel.showCustomerDropdown)
              Container(
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: viewModel.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: viewModel.dividerColor),
                  boxShadow: [
                    BoxShadow(
                      color: viewModel.shadowColor,
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    )
                  ],
                ),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  children: viewModel.mockCustomers
                      .where((c) => c.toLowerCase().contains(viewModel.customerSearchController.text.toLowerCase()))
                      .map((customer) {
                    return ListTile(
                      title: Text(
                        customer,
                        style: TextStyle(fontSize: 13, color: viewModel.textPrimary, fontWeight: FontWeight.w500),
                      ),
                      leading: Icon(Icons.business_center, color: viewModel.primaryColor, size: 18),
                      dense: true,
                      hoverColor: viewModel.backgroundColor,
                      onTap: () {
                        viewModel.setCustomer(customer);
                        FocusScope.of(context).unfocus();
                      },
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
