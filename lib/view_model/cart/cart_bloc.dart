// cart_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:e_commarce_project/core/constants/app_url.dart';
import '../../data/helper/api_helper.dart';
import 'cart_event.dart';
import 'cart_state.dart';
import '../../data/model/cart_item_model.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ApiHelper apiHelper;
  CartBloc({required this.apiHelper}) : super(CartInitialState()) {
    on<FetchCartEvent>(_fetchCart);
  //  on<UpdateCartQuantityEvent>(_updateQuantity);
    on<DeleteCartItemEvent>(_deleteItem);
  }

  Future<void> _fetchCart(FetchCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      final response = await apiHelper.getCartList(); // GET /view-cart

      if (response['status'] == true) {
        List<CartItemModel> cartItems = (response['data'] as List)
            .map((e) => CartItemModel.fromJson(e))
            .toList();
        emit(CartLoadedState(cartItems: cartItems));
      } else {
        emit(CartFailureState(errorMsg: response['message']));
      }
    } catch (e) {
      emit(CartFailureState(errorMsg: e.toString()));
    }
  }

  // Future<void> _updateQuantity(UpdateCartQuantityEvent event, Emitter<CartState> emit) async {
  //   emit(CartLoadingState());
  //   try {
  //     final response = await apiHelper.postAPI(
  //       url: AppUrls.up
  //       mBodyParams: {
  //         "product_id": event.productId,
  //         "quantity": event.newQuantity,
  //       },
  //     );
  //
  //     if (response['status'] == true) {
  //       add(FetchCartEvent()); // Refresh cart
  //     } else {
  //       emit(CartFailureState(errorMsg: response['message']));
  //     }
  //   } catch (e) {
  //     emit(CartFailureState(errorMsg: e.toString()));
  //   }
  // }

  Future<void> _deleteItem(DeleteCartItemEvent event, Emitter<CartState> emit) async {
    emit(CartLoadingState());
    try {
      final response = await apiHelper.postAPI(
        url: AppUrls.delete_cart_url,
        mBodyParams: {"cart_id": event.cartId},
      );

      if (response['status'] == true) {
        add(FetchCartEvent()); // Refresh cart
      } else {
        emit(CartFailureState(errorMsg: response['message']));
      }
    } catch (e) {
      emit(CartFailureState(errorMsg: e.toString()));
    }
  }
}