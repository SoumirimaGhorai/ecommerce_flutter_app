abstract class CartEvent {}

class LoadLocalCartEvent extends CartEvent {}

class FetchCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final int productId;
  final int qty;

  AddToCartEvent({required this.productId, required this.qty});
}

class UpdateCartQuantityEvent extends CartEvent {
  final String productId;
  final int newQuantity;

  UpdateCartQuantityEvent({required this.productId, required this.newQuantity});
}

class DeleteCartItemEvent extends CartEvent {
  final String cartId;

  DeleteCartItemEvent({required this.cartId});
}