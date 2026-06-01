import 'package:flutter/material.dart';
import '../viewmodels/fbr_billing_viewmodel.dart';

class TaxReportsTabContent extends StatelessWidget {
  final FBRBillingViewModel viewModel;

  const TaxReportsTabContent({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "FBR GST & WHT COMPLIANCE DESK",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: viewModel.primaryColor,
                  letterSpacing: 1.1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: viewModel.successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.verified, color: viewModel.successColor, size: 12),
                    const SizedBox(width: 4),
                    const Text(
                      "AUDITED",
                      style: TextStyle(color: Colors.green, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          
          // Audited status indicator card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [viewModel.primaryColor, viewModel.primaryColor.withValues(alpha: 0.85)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: viewModel.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.gpp_good, color: viewModel.accentColor, size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      "Secured Fiscal Ledger System",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  "All dynamic billing logs are timestamped, hashed using SHA-256, and verified with Tier3 Cryptographic services before submission to the FBR gateway.",
                  style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.4),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "FBR Fiscal ID: T3-LE-884920",
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Active Connection: Secure",
                      style: TextStyle(color: viewModel.accentColor, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          Text(
            "MONTHLY SUBMISSIONS LEDGER",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              color: viewModel.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.taxReports.length,
            itemBuilder: (context, idx) {
              final report = viewModel.taxReports[idx];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: viewModel.surfaceColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: viewModel.shadowColor,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: viewModel.primaryColor.withValues(alpha: 0.08),
                    child: Icon(Icons.summarize, color: viewModel.primaryColor, size: 20),
                  ),
                  title: Text(
                    report.month,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: viewModel.textPrimary),
                  ),
                  subtitle: Text(
                    "Sales: ${report.sales} | GST: ${report.gst}",
                    style: TextStyle(fontSize: 11, color: viewModel.textSecondary),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: viewModel.successColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      report.status,
                      style: TextStyle(color: viewModel.successColor, fontSize: 9, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
