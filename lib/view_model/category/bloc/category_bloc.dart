import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/helper/api_helper.dart';
import '../../../data/model/category_model.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ApiHelper apiHelper;

  CategoryBloc({required this.apiHelper})
      : super(CategoryInitialState()) {
    on<FetchCategoryEvent>(_fetchCategories);
  }

  Future<void> _fetchCategories(
      FetchCategoryEvent event, Emitter<CategoryState> emit) async {
    emit(CategoryLoadingState());

    try {
      final response = await apiHelper.getCategories();

      if (response['status'] == true) {
        List<CategoryModel> list = (response['data'] as List)
            .map((e) => CategoryModel.fromJson(e))
            .toList();

        emit(CategoryLoadedState(categories: list));
      } else {
        emit(CategoryErrorState(
            errorMsg: response['message'] ?? 'Something went wrong'));
      }
    } catch (e) {
      emit(CategoryErrorState(errorMsg: e.toString()));
    }
  }
}