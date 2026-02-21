import 'package:bloc/bloc.dart';
import '../../data/helper/api_helper.dart';
import '../../data/model/cart_item_model.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ApiHelper apiHelper;

  CartBloc({required this.apiHelper}) : super(CartInitialState()) {
    on<FetchCartEvent>(_fetchCart);
    on<DeleteCartItemEvent>(_deleteCartItem);
    on<UpdateCartQuantityEvent>(_updateCartQuantity);
  }

  Future<void> _fetchCart(FetchCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      final response = await apiHelper.getCartList();
      if (response['status'] == true) {
        final items = (response['data'] as List)
            .map((e) => CartItemModel.fromJson(e))
            .toList();
        emit(CartLoadedState(cartItems: items));
      } else {
        emit(CartFailureState(errorMsg: response['message']));
      }
    } catch (e) {
      emit(CartFailureState(errorMsg: e.toString()));
    }
  }

  Future<void> _deleteCartItem(DeleteCartItemEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      final response = await apiHelper.deleteCart(cartId: event.cartId);
      if (response['status'] == true) {
        add(FetchCartEvent());
      } else {
        emit(CartFailureState(errorMsg: response['message']));
      }
    } catch (e) {
      emit(CartFailureState(errorMsg: e.toString()));
    }
  }

  Future<void> _updateCartQuantity(UpdateCartQuantityEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      final response = await apiHelper.updateCartQuantity(
          productId: event.productId, quantity: event.newQuantity);

      if (response['status'] == true) {
        add(FetchCartEvent());
      } else {
        emit(CartFailureState(errorMsg: response['message']));
      }
    } catch (e) {
      emit(CartFailureState(errorMsg: e.toString()));
    }
  }
}