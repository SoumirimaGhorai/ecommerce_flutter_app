import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/helper/api_helper.dart';
import '../../data/model/cart_item_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ApiHelper apiHelper;

  CartBloc({required this.apiHelper}) : super(CartInitialState()) {
    on<FetchCartEvent>(_fetchCartItems);
    on<AddToCartEvent>(_addToCart);
    on<UpdateCartQuantityEvent>(_updateQuantity);
    on<DeleteCartItemEvent>(_deleteCartItem);
  }

  Future<void> _fetchCartItems(FetchCartEvent event, Emitter<CartState> emit) async {
    try {
      emit(CartLoadingState());
      final res = await apiHelper.getCartList();
      List<CartItemModel> items = (res['data'] as List)
          .map((e) => CartItemModel.fromJson(e))
          .toList();
      emit(CartLoadedState(cartItems: items));
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }

  Future<void> _addToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    try {
      emit(CartLoadingState());
      await apiHelper.updateCartQuantity(
        productId: event.productId,
        quantity: event.qty,
      );
      // Fetch updated cart
      final res = await apiHelper.getCartList();
      List<CartItemModel> items = (res['data'] as List)
          .map((e) => CartItemModel.fromJson(e))
          .toList();
      emit(CartLoadedState(cartItems: items));
    } catch (e) {
      emit(CartErrorState(message: e.toString()));
    }
  }

  Future<void> _updateQuantity(UpdateCartQuantityEvent event, Emitter<CartState> emit) async {
    // optional: not used for ProductDetailPage setup
  }

  /// Delete cart item


  Future<void> _deleteCartItem(DeleteCartItemEvent event, Emitter<CartState> emit) async {
    if (state is CartLoadedState) {
      final currentState = state as CartLoadedState;
      try {
        await apiHelper.deleteCart(cartId: int.parse(event.cartId));
        final updatedList = currentState.cartItems
            .where((item) => item.id != event.cartId)
            .toList();
        emit(CartLoadedState(cartItems: updatedList));
      } catch (e) {
        emit(CartErrorState(message: "Failed to delete item: $e"));
      }
    }
  }
  }
