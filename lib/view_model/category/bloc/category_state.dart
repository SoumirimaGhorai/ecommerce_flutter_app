import '../../../data/model/category_model.dart';

abstract class CategoryState {}

class CategoryInitialState extends CategoryState {}

class CategoryLoadingState extends CategoryState {}

class CategoryLoadedState extends CategoryState {
  final List<CategoryModel> categories;

  CategoryLoadedState({required this.categories});
}

class CategoryErrorState extends CategoryState {
  final String errorMsg;

  CategoryErrorState({required this.errorMsg});
}