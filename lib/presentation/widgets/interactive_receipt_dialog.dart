import 'dart:math';
import 'package:flutter/material.dart';
import '../viewmodels/fbr_billing_viewmodel.dart';
import 'fbr_qr_code_painter.dart';

class InteractiveReceiptDialog extends StatefulWidget {
  final FBRBillingViewModel viewModel;

  const InteractiveReceiptDialog({super.key, required this.viewModel});

  @override
  State<InteractiveReceiptDialog> createState() => _InteractiveReceiptDialogState();
}

class _InteractiveReceiptDialogState extends State<InteractiveReceiptDialog> {
  bool _isLoading = true;
  bool _isQrExpanded = false;
  late String _invoiceNumber;
  late String _timestamp;

  @override
  void initState() {
    super.initState();
    // Generate dummy details
    int randomPart = Random().nextInt(900) + 100;
    _invoiceNumber = "T3-FBR-2026-$randomPart";
    final now = DateTime.now();
    _timestamp = "${now.day.toString().padLeft(2, '0')} Jun 2026, ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    // Simulate API call for 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              color: widget.viewModel.primaryColor,
              strokeWidth: 4,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Securing Transaction...",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: widget.viewModel.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Syncing with FBR Gateway",
            style: TextStyle(
              fontSize: 13,
              color: widget.viewModel.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptState(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Success Badge
            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF2E7D32),
                  size: 48,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Center(
              child: Text(
                "Tier3 Secure Transaction Verified",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Invoice Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.viewModel.backgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  _buildRow("Invoice No:", _invoiceNumber),
                  const Divider(height: 24),
                  _buildRow("Date & Time:", _timestamp),
                  const Divider(height: 24),
                  _buildRow("Grand Total:", "${widget.viewModel.formatCurrency(widget.viewModel.grandTotal)} PKR", isTotal: true),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Interactive QR Code
            GestureDetector(
              onTap: () {
                setState(() {
                  _isQrExpanded = !_isQrExpanded;
                });
              },
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.all(_isQrExpanded ? 24 : 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: _isQrExpanded ? 0.15 : 0.05),
                        blurRadius: _isQrExpanded ? 20 : 10,
                        spreadRadius: _isQrExpanded ? 2 : 0,
                      )
                    ],
                    border: Border.all(
                      color: widget.viewModel.primaryColor.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomPaint(
                        size: Size(_isQrExpanded ? 140 : 80, _isQrExpanded ? 140 : 80),
                        painter: FBRQRCodePainter(color: widget.viewModel.primaryColor),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: _isQrExpanded ? 24 : 0,
                        child: _isQrExpanded
                            ? const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "Tap to collapse",
                                  style: TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                "Tap QR to expand",
                style: TextStyle(fontSize: 12, color: widget.viewModel.textSecondary),
              ),
            ),
            const SizedBox(height: 32),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Sharing Digital PDF Receipt..."),
                          backgroundColor: widget.viewModel.primaryColor,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.share),
                    label: const Text("Share PDF"),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: widget.viewModel.primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      foregroundColor: widget.viewModel.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      widget.viewModel.finalizeTransaction();
                    },
                    icon: const Icon(Icons.done_all),
                    label: const Text("Done"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.viewModel.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: widget.viewModel.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? widget.viewModel.primaryColor : widget.viewModel.textPrimary,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      elevation: 20,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: _isLoading 
            ? KeyedSubtree(key: const ValueKey("loading"), child: _buildLoadingState())
            : KeyedSubtree(key: const ValueKey("receipt"), child: _buildReceiptState(context)),
        ),
      ),
    );
  }
}
