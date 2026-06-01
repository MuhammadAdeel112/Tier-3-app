class BillingCalculations {
  /// Proportional withholding tax calculation logic
  /// (1.3043478% yields exactly 1,500 PKR on a subtotal of 115,000 PKR)
  static double calculateWht(double subtotal) {
    if (subtotal == 0) return 0.0;
    return (subtotal * 0.013043478).roundToDouble();
  }
}
