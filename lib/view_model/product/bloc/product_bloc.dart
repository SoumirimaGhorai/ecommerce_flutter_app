
import 'package:bloc/bloc.dart';
import 'package:e_commarce_project/view_model/product/bloc/product_event.dart';
import 'package:e_commarce_project/view_model/product/bloc/product_state.dart';

import '../../../core/constants/app_url.dart';
import '../../../data/helper/api_helper.dart';
import '../../../data/model/product_model.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ApiHelper apiHelper;

  ProductBloc({required this.apiHelper}) : super(ProductInitialState()) {
    on<FetchAllProductEvent>((event, emit) async{
      emit(ProductLoadingState());

      try {

        dynamic mData = await apiHelper.postAPI(url: AppUrls.product_url);
        if(mData["status"]){
          List<ProductModel> mProducts = [];
          for(Map<String, dynamic> eachMap in mData["data"]){
            mProducts.add(ProductModel.fromJson(eachMap));
          }
          emit(ProductLoadedState(products: mProducts));
        } else {
          emit(ProductErrorState(errorMsg: mData["message"]));
        }

      } catch (e) {
        emit(ProductErrorState(errorMsg: e.toString()));
      }
    });
  }
}