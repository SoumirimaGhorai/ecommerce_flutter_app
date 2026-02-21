abstract class CartEvent {}

class AddToCartEvent extends CartEvent {
  int productId, qty;
  AddToCartEvent({required this.productId, required this.qty});
}

class FetchCartEvent extends CartEvent{}
class DeleteCartItemEvent extends CartEvent {
  final int cartId;
  DeleteCartItemEvent({required this.cartId});
}

class UpdateCartQuantityEvent extends CartEvent {
  final int productId;
  final int newQuantity;
  UpdateCartQuantityEvent({required this.productId, required this.newQuantity});
}