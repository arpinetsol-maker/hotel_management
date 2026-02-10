import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/app/core/constants/app_constants.dart';
import 'package:hotel_management/app/data/models/food_order_model.dart';
import 'package:hotel_management/app/modules/auth/controllers/food_order_controller.dart';

class MyFoodOrdersView extends GetView<FoodOrderController> {
  const MyFoodOrdersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadUserOrders();
    });
    return Scaffold(
      backgroundColor: AppColors.userSecondary,
      appBar: AppBar(
        title: const Text('My Food Orders'),
        backgroundColor: AppColors.userPrimary,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.userOrders.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.userOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 64, color: AppColors.grey),
                const SizedBox(height: 16),
                Text('No orders yet', style: TextStyle(color: AppColors.grey)),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.userOrders.length,
          itemBuilder: (context, index) {
            final order = controller.userOrders[index];
            return _OrderCard(
              order: order,
              onCancel: order.status == 'pending'
                  ? () => controller.cancelOrder(order.id)
                  : null,
            );
          },
        );
      }),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final FoodOrderModel order;
  final VoidCallback? onCancel;

  const _OrderCard({required this.order, this.onCancel});

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 4),
            Text('Total: ₹${order.totalAmount.toStringAsFixed(0)}'),
            Text('Payment: ${order.paymentStatus}'),
            if (order.roomNumber != null) Text('Room: ${order.roomNumber}'),
            if (onCancel != null) ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: onCancel,
                child: Text(
                  'Cancel order',
                  style: TextStyle(color: AppColors.error),
                ),
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
