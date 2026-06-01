import 'package:flutter/material.dart';
import '../viewmodels/fbr_billing_viewmodel.dart';

class HistoryTabContent extends StatelessWidget {
  final FBRBillingViewModel viewModel;

  const HistoryTabContent({
    super.key,
    required this.viewModel,
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
            "RECENT POS INVOICES ISSUED",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: viewModel.primaryColor,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: viewModel.invoiceHistory.length,
              itemBuilder: (context, idx) {
                final inv = viewModel.invoiceHistory[idx];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
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
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: viewModel.primaryColor.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.document_scanner, color: viewModel.primaryColor, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                inv.invId,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: viewModel.textPrimary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Client: ${inv.customer}",
                                style: TextStyle(fontSize: 11, color: viewModel.textSecondary, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "Issued: ${inv.date}",
                                style: TextStyle(fontSize: 10, color: viewModel.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              inv.total,
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: viewModel.primaryColor),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: (inv.status == "Synced") 
                                    ? viewModel.successColor.withValues(alpha: 0.08)
                                    : viewModel.accentColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                inv.status,
                                style: TextStyle(
                                  color: (inv.status == "Synced") ? viewModel.successColor : viewModel.primaryColor,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
