import '../../domain/entities/tax_report.dart';

class TaxReportModel extends TaxReport {
  const TaxReportModel({
    required super.month,
    required super.sales,
    required super.gst,
    required super.wht,
    required super.status,
  });

  factory TaxReportModel.fromJson(Map<String, dynamic> json) {
    return TaxReportModel(
      month: json['month'] as String,
      sales: json['sales'] as String,
      gst: json['gst'] as String,
      wht: json['wht'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'sales': sales,
      'gst': gst,
      'wht': wht,
      'status': status,
    };
  }
}
