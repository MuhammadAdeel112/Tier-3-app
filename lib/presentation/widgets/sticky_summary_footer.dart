import 'package:flutter/material.dart';
import '../viewmodels/fbr_billing_viewmodel.dart';
import 'fbr_qr_code_painter.dart';
import 'interactive_receipt_dialog.dart';

class StickySummaryFooter extends StatelessWidget {
  final FBRBillingViewModel viewModel;

  const StickySummaryFooter({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: viewModel.surfaceColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 16,
            offset: Offset(0, -4),
          )
        ],
        border: Border(
          top: BorderSide(color: Colors.grey.shade200, width: 1.2),
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Breakdown details
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _buildSummaryRow("Subtotal", "${viewModel.formatCurrency(viewModel.subtotal)} PKR"),
                      _buildSummaryRow("Total GST 18%", "${viewModel.formatCurrency(viewModel.gstTotal)} PKR"),
                      _buildSummaryRow("WHT (Proportional)", "${viewModel.formatCurrency(viewModel.whtTotal)} PKR"),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                
                // Vector FBR QR Stamp
                Column(
                  children: [
                    CustomPaint(
                      size: const Size(54, 54),
                      painter: FBRQRCodePainter(color: viewModel.primaryColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "FBR VERIFIED",
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        color: viewModel.primaryColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const Divider(height: 16, thickness: 1),
            
            // Grand Total Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "GRAND TOTAL:",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: viewModel.primaryColor,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  "${viewModel.formatCurrency(viewModel.grandTotal)} PKR",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: viewModel.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Action Buttons Footer Row
            Row(
              children: [
                // Wide Generate Button
                Expanded(
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: viewModel.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () => _showGenerateInvoiceDialog(context),
                      icon: const Icon(Icons.verified_user, size: 18),
                      label: const Text(
                        "GENERATE INVOICE",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.8),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: viewModel.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                
                // Thermal print circular button
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: viewModel.surfaceColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: viewModel.primaryColor.withValues(alpha: 0.2), width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.print_outlined, color: viewModel.primaryColor),
                    tooltip: "Thermal Print Receipt",
                    onPressed: () => _triggerThermalPrintSimulation(context),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 11, color: viewModel.textSecondary, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 11, color: viewModel.textPrimary, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: viewModel.textSecondary,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                color: viewModel.textPrimary,
                fontWeight: isBold ? FontWeight.bold : viewModel.textPrimary.value == 0xFF1E293B ? FontWeight.w600 : FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Dialog / Overlay View Handlers ---
  void _showGenerateInvoiceDialog(BuildContext context) {
    if (viewModel.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text("Cannot generate invoice for an empty cart.")),
            ],
          ),
          backgroundColor: viewModel.dangerColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return InteractiveReceiptDialog(viewModel: viewModel);
      },
    );
  }

  void _triggerThermalPrintSimulation(BuildContext context) {
    if (viewModel.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Cannot print an empty receipt."),
          backgroundColor: viewModel.dangerColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        Future.delayed(const Duration(milliseconds: 1400), () {
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.print, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(child: Text("Print success: Connected at 192.168.10.25 (Port: 9100)")),
                  ],
                ),
                backgroundColor: viewModel.successColor,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        });

        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: viewModel.surfaceColor,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: viewModel.primaryColor,
                  strokeWidth: 3,
                ),
                const SizedBox(height: 20),
                Text(
                  "CONNECTING THERMAL PRINTER",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: viewModel.primaryColor,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Securing wireless handshakes & formatting layout...",
                  style: TextStyle(fontSize: 11, color: viewModel.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
