import 'package:bloc/bloc.dart';

import '../../core/constants/app_url.dart';
import '../../data/helper/api_helper.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  ApiHelper apiHelper;

  CartBloc({required this.apiHelper}) : super(CartInitialState()) {
    on<AddToCartEvent>((event, emit) async {
      emit(CartLoadingState());

      try {
        dynamic mData = await apiHelper.postAPI(isAuth: true,
            url: AppUrls.add_to_cart_url, mBodyParams: {
          "product_id": event.productId,
          "quantity": event.qty
        });

        if (mData["status"] == "true" || mData["status"]) {
          ///true, "true"
          emit(CartSuccessState());
        } else {
          emit(CartFailureState(errorMsg: mData["message"]));
        }
      } catch (e) {
        emit(CartFailureState(errorMsg: e.toString()));
      }
    });
  }
}