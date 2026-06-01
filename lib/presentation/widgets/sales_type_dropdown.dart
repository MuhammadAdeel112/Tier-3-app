import 'package:flutter/material.dart';
import '../viewmodels/fbr_billing_viewmodel.dart';

class SalesTypeDropdown extends StatelessWidget {
  final FBRBillingViewModel viewModel;

  const SalesTypeDropdown({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: DropdownButtonFormField<String>(
        value: viewModel.selectedSalesType,
        dropdownColor: viewModel.surfaceColor,
        style: TextStyle(color: viewModel.textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelText: "Sales Type",
          labelStyle: TextStyle(color: viewModel.primaryColor, fontSize: 13, fontWeight: FontWeight.bold),
          prefixIcon: Icon(Icons.receipt_long, color: viewModel.primaryColor),
          filled: true,
          fillColor: viewModel.surfaceColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: viewModel.primaryColor, width: 1.5),
          ),
        ),
        items: viewModel.salesTypes.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          if (newValue != null) {
            viewModel.setSalesType(newValue);
          }
        },
      ),
    );
  }
}
