abstract class CartEvent {}

class AddToCartEvent extends CartEvent {
  int productId, qty;
  AddToCartEvent({required this.productId, required this.qty});
}

class FetchCartEvent extends CartEvent{}