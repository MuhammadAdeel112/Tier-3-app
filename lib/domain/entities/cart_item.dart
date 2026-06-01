import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalSubtotal => product.price * quantity;
  double get totalGst => product.price * quantity * product.gstRate;
  double get totalGrand => totalSubtotal + totalGst;
}
