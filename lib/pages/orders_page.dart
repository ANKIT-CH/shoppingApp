import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersPage extends StatelessWidget {
  static const routeName = '/orderspage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndAddOrders(),
          builder: (ctx, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapShot.error != null) {
                //error handling
                return Center(
                  child: Text('An Error occured'),
                );
              }
            }
            return Consumer<Orders>(
              builder: (ctx, ordersData, child) => ListView.builder(
                itemCount: ordersData.orders.length,
                itemBuilder: (ctx, index) =>
                    OrderItem(ordersData.orders[index]),
              ),
            );
          }),
    );
  }
}

// class OrdersPage extends StatefulWidget {
//   static const routeName = '/orderspage';

//   @override
//   _OrdersPageState createState() => _OrdersPageState();
// }

// class _OrdersPageState extends State<OrdersPage> {
//   var _isLoading = false;

//   @override
//   void initState() {
//     // Future.delayed(Duration.zero).then((_) async {
//     //   setState(() {
//     //     _isLoading = true;
//     //   });
//     //   await Provider.of<Orders>(context, listen: false).fetchAndAddOrders();
//     //   setState(() {
//     //     _isLoading = false;
//     //   });
//     // });

//     // OR

//     _isLoading = true;

//     Provider.of<Orders>(context, listen: false).fetchAndAddOrders().then((_) {
//       setState(() {
//         _isLoading = false;
//       });
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ordersData = Provider.of<Orders>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Your orders'),
//       ),
//       drawer: AppDrawer(),
//       body: _isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : ListView.builder(
//               itemCount: ordersData.orders.length,
//               itemBuilder: (ctx, index) => OrderItem(ordersData.orders[index]),
//             ),
//     );
//   }
// }
