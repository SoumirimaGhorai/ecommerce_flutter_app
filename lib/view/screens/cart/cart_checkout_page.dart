// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../data/helper/api_helper.dart';
// import '../../../view_model_bloc/create_order_bloc/order_success_page.dart';
//
//
// class CheckoutPage extends StatefulWidget {
//   final int productId;
//
//   const CheckoutPage({
//     super.key,
//     required this.productId,
//   });
//
//   @override
//   State<CheckoutPage> createState() => _CheckoutPageState();
// }
//
// class _CheckoutPageState extends State<CheckoutPage> {
//   bool isLoading = false;
//   final ApiHelper apiHelper = ApiHelper();
//
//   Future<void> _placeOrder() async {
//     setState(() => isLoading = true);
//
//     try {
//       SharedPreferences prefs =
//       await SharedPreferences.getInstance();
//
//       final userId = prefs.getInt('user_id') ?? 1;
//
//       final response = await apiHelper.createOrder(
//         userId: userId,
//         productId: widget.productId,
//       );
//
//       if (response['status'] == true) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => const OrderSuccessPage(),
//           ),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(response['message'])),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(e.toString())),
//       );
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Checkout'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: SizedBox(
//             width: double.infinity,
//             height: 50,
//             child: ElevatedButton(
//               onPressed: isLoading ? null : _placeOrder,
//               child: isLoading
//                   ? const CircularProgressIndicator(
//                 color: Colors.white,
//               )
//                   : const Text(
//                 'Place Order',
//                 style: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }