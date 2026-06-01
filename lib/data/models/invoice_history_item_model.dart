import '../../domain/entities/invoice_history_item.dart';

class InvoiceHistoryItemModel extends InvoiceHistoryItem {
  const InvoiceHistoryItemModel({
    required super.invId,
    required super.customer,
    required super.date,
    required super.total,
    required super.status,
  });

  factory InvoiceHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return InvoiceHistoryItemModel(
      invId: json['invId'] as String,
      customer: json['customer'] as String,
      date: json['date'] as String,
      total: json['total'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invId': invId,
      'customer': customer,
      'date': date,
      'total': total,
      'status': status,
    };
  }
}
