import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../data/models/order_model.dart';
import '../../../../shared/widgets/app_app_bar.dart';
import '../../../../shared/widgets/app_badge.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_empty_view.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../providers/order_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: AppStrings.myOrders, showBackButton: false),
      body: Column(
        children: [
          Container(
            color: AppColors.surface,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelStyle: AppTextStyles.subtitle.copyWith(fontSize: 15),
              tabs: const [
                Tab(text: AppStrings.activeOrders),
                Tab(text: AppStrings.pastOrders),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOrdersList(orderProvider.activeOrders, isActive: true),
                _buildOrdersList(orderProvider.pastOrders, isActive: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<OrderModel> orders, {required bool isActive}) {
    if (orders.isEmpty) {
      return AppEmptyView(
        icon: Icons.receipt_long_outlined,
        title: 'No ${isActive ? 'Active' : 'Past'} Orders',
        description: isActive
            ? 'You currently have no active orders in progress.'
            : 'You have not completed any past orders yet.',
        buttonText: 'Order Food Now',
        onButtonPressed: () => context.go('/home'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.borderLg,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      AppNetworkImage(
                        imageUrl: order.restaurantLogo,
                        width: 40,
                        height: 40,
                        borderRadius: AppRadius.borderSm,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order.restaurantName, style: AppTextStyles.subtitle.copyWith(fontSize: 15)),
                          Text('#${order.id} • ${AppFormatters.date(order.createdAt)}', style: AppTextStyles.caption),
                        ],
                      ),
                    ],
                  ),
                  _buildStatusBadge(order.status),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: AppColors.divider),
              const SizedBox(height: 8),
              Text(
                order.items.map((i) => '${i.quantity}x ${i.food.name}').join(', '),
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Amount', style: AppTextStyles.caption),
                      Text(AppFormatters.currency(order.totalPrice), style: AppTextStyles.price.copyWith(fontSize: 16)),
                    ],
                  ),
                  if (isActive)
                    AppButton(
                      text: AppStrings.trackOrder,
                      fullWidth: false,
                      width: 120,
                      height: 38,
                      onPressed: () => context.push('/order-tracking/${order.id}'),
                    )
                  else
                    AppButton(
                      text: 'Reorder',
                      type: AppButtonType.outline,
                      fullWidth: false,
                      width: 100,
                      height: 38,
                      onPressed: () {
                        context.showSnackBar('Reordering items from ${order.restaurantName}');
                        context.go('/home');
                      },
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    switch (status) {
      case OrderStatus.confirmed:
        return const AppBadge(text: 'Confirmed', backgroundColor: AppColors.warningLight, textColor: AppColors.warning);
      case OrderStatus.preparing:
        return const AppBadge(text: 'Preparing', backgroundColor: AppColors.primaryLight, textColor: AppColors.primary);
      case OrderStatus.onTheWay:
        return const AppBadge(text: 'On The Way', backgroundColor: Color(0xFFE3F2FD), textColor: Color(0xFF1E88E5));
      case OrderStatus.delivered:
        return const AppBadge(text: 'Delivered', backgroundColor: AppColors.successLight, textColor: AppColors.success);
      case OrderStatus.cancelled:
        return const AppBadge(text: 'Cancelled', backgroundColor: AppColors.errorLight, textColor: AppColors.error);
    }
  }
}
