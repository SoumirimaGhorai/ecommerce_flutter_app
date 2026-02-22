import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/helper/api_helper.dart';
import '../../../data/model/order_model.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final ApiHelper apiHelper;


  OrderBloc( {required this.apiHelper }) : super(OrderInitialState()) {
    on<FetchOrderEvent>((event, emit) async {
      emit(OrderLoadingState());

      try {
        final res = await apiHelper.getOrders();
      //  final res = await apiHelper.getOrders();
        print("ORDER API RESPONSE: $res");

        if (res['status'] == true) {
          List<OrderModel> orders = (res['orders'] as List)
              .map((e) => OrderModel.fromJson(e))
              .toList();

          emit(OrderLoadedState(orders));
        } else {
          emit(OrderErrorState(res['message']));
        }
      } catch (e) {
        emit(OrderErrorState(e.toString()));
      }
    });
  }
}