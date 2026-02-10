import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/app/core/constants/app_constants.dart';
import 'package:hotel_management/app/data/models/food_order_model.dart';
import 'package:hotel_management/app/modules/auth/controllers/food_order_controller.dart';

class FoodOrdersAdminView extends GetView<FoodOrderController> {
  const FoodOrdersAdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hotelId = Get.arguments as String? ?? '';
    if (hotelId.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadHotelOrders(hotelId);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.adminAccent2,
      appBar: AppBar(
        title: const Text('Food Orders'),
        backgroundColor: AppColors.adminPrimary,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.hotelOrders.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.hotelOrders.isEmpty) {
          return Center(
            child: Text(
              hotelId.isEmpty ? 'Pass hotel id' : 'No orders',
              style: TextStyle(color: AppColors.grey),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.hotelOrders.length,
          itemBuilder: (context, index) {
            final order = controller.hotelOrders[index];
            return _OrderCard(
              order: order,
              onStatusChange: (status) =>
                  controller.updateOrderStatus(order.id, status),
            );
          },
        );
      }),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final FoodOrderModel order;
  final ValueChanged<String> onStatusChange;

  const _OrderCard({required this.order, required this.onStatusChange});

  @override
  Widget build(BuildContext context) {
    final canUpdate = ['pending', 'preparing', 'ready'].contains(order.status);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id.substring(0, 8)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Chip(
                  label: Text(order.status),
                  backgroundColor: _colorForStatus(order.status),
                ),
              ],
            ),
            Text('Payment: ${order.paymentStatus}'),
            if (order.roomNumber != null) Text('Room: ${order.roomNumber}'),
            Text('Total: ₹${order.totalAmount.toStringAsFixed(0)}'),
            if (canUpdate) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  if (order.status != 'preparing')
                    ElevatedButton(
                      onPressed: () => onStatusChange('preparing'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.adminPrimary,
                      ),
                      child: const Text('Preparing'),
                    ),
                  if (order.status != 'ready')
                    ElevatedButton(
                      onPressed: () => onStatusChange('ready'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: const Text('Ready'),
                    ),
                  if (order.status != 'delivered')
                    ElevatedButton(
                      onPressed: () => onStatusChange('delivered'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                      ),
                      child: const Text('Delivered'),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color? _colorForStatus(String s) {
    switch (s) {
      case 'pending':
        return Colors.orange.shade100;
      case 'preparing':
        return Colors.blue.shade100;
      case 'ready':
        return Colors.amber.shade100;
      case 'delivered':
        return Colors.green.shade100;
      case 'cancelled':
        return Colors.red.shade100;
      default:
        return null;
    }
  }
}
