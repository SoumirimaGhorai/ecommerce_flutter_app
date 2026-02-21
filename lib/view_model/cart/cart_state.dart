abstract class CartState{}

class CartInitialState extends CartState{}
class CartLoadingState extends CartState{}
class CartSuccessState extends CartState{}
class CartLoadedState extends CartState{}
class CartFailureState extends CartState{
  String errorMsg;
  CartFailureState({required this.errorMsg});
}