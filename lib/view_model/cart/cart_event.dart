// cart_event.dart
abstract class CartEvent {}

class FetchCartEvent extends CartEvent {}

class UpdateCartQuantityEvent extends CartEvent {
  final String productId;
  final int newQuantity;

  UpdateCartQuantityEvent({required this.productId, required this.newQuantity});
}

class DeleteCartItemEvent extends CartEvent {
  final String cartId;

  DeleteCartItemEvent({required this.cartId});
}