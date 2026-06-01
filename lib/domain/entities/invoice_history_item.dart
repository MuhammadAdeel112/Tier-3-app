class InvoiceHistoryItem {
  final String invId;
  final String customer;
  final String date;
  final String total;
  final String status;

  const InvoiceHistoryItem({
    required this.invId,
    required this.customer,
    required this.date,
    required this.total,
    required this.status,
  });
}
