import '../../domain/entities/cart_item.dart';
import 'product_model.dart';

class CartItemModel extends CartItem {
  CartItemModel({
    required ProductModel super.product,
    super.quantity = 1,
  });
}
