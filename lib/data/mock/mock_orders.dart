import '../models/order_model.dart';
import 'mock_foods.dart';

class MockOrders {
  static List<OrderModel> get orders => [
        OrderModel(
          id: 'ORD-88219',
          restaurantName: 'Urban Bites',
          restaurantLogo: 'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=200',
          items: [
            CartItemModel(
              id: 'cart_1',
              food: MockFoods.foods[0], // Classic Beef Cheeseburger
              quantity: 2,
              selectedAddOns: [MockFoods.foods[0].addOns[0]],
            ),
            CartItemModel(
              id: 'cart_2',
              food: MockFoods.foods[17], // Nutella Milkshake
              quantity: 1,
            ),
          ],
          subtotal: 33.48,
          deliveryFee: 1.99,
          tax: 1.67,
          discount: 3.00,
          totalPrice: 34.14,
          createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
          status: OrderStatus.onTheWay,
          deliveryAddress: 'Home • 124 Grand Avenue, Apt 4B',
          paymentMethod: 'Visa ending in 4242',
          driverName: 'Michael Scott',
          driverPhone: '+1 (555) 234-5678',
          driverAvatar: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=200',
          estimatedTime: '15-20 min',
        ),
        OrderModel(
          id: 'ORD-77102',
          restaurantName: 'Pizza Craft',
          restaurantLogo: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=200',
          items: [
            CartItemModel(
              id: 'cart_3',
              food: MockFoods.foods[3], // Margherita Special
              quantity: 1,
            ),
          ],
          subtotal: 14.99,
          deliveryFee: 1.99,
          tax: 0.75,
          discount: 0.0,
          totalPrice: 17.73,
          createdAt: DateTime.now().subtract(const Duration(minutes: 40)),
          status: OrderStatus.preparing,
          deliveryAddress: 'Home • 124 Grand Avenue, Apt 4B',
          paymentMethod: 'Cash on Delivery',
          driverName: 'Alex Johnson',
          driverPhone: '+1 (555) 987-6543',
          driverAvatar: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200',
          estimatedTime: '25 min',
        ),
        OrderModel(
          id: 'ORD-65109',
          restaurantName: 'Spice Garden',
          restaurantLogo: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=200',
          items: [
            CartItemModel(
              id: 'cart_4',
              food: MockFoods.foods[6], // Chicken Biryani
              quantity: 2,
            ),
          ],
          subtotal: 27.98,
          deliveryFee: 2.49,
          tax: 1.40,
          discount: 5.00,
          totalPrice: 26.87,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          status: OrderStatus.delivered,
          deliveryAddress: 'Office • 88 Tech Park, Floor 3',
          paymentMethod: 'Mastercard ending in 8899',
          estimatedTime: 'Delivered',
        ),
        OrderModel(
          id: 'ORD-54122',
          restaurantName: 'The Breakfast Club',
          restaurantLogo: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=200',
          items: [
            CartItemModel(
              id: 'cart_5',
              food: MockFoods.foods[19], // Stack of Pancakes
              quantity: 1,
            ),
            CartItemModel(
              id: 'cart_6',
              food: MockFoods.foods[20], // Avocado Toast
              quantity: 1,
            ),
          ],
          subtotal: 21.98,
          deliveryFee: 1.29,
          tax: 1.10,
          discount: 0.0,
          totalPrice: 24.37,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          status: OrderStatus.delivered,
          deliveryAddress: 'Home • 124 Grand Avenue, Apt 4B',
          paymentMethod: 'Visa ending in 4242',
          estimatedTime: 'Delivered',
        ),
        OrderModel(
          id: 'ORD-43100',
          restaurantName: 'Green Bowl',
          restaurantLogo: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=200',
          items: [
            CartItemModel(
              id: 'cart_7',
              food: MockFoods.foods[11], // Grilled Chicken Caesar Salad
              quantity: 1,
            ),
          ],
          subtotal: 11.50,
          deliveryFee: 1.49,
          tax: 0.58,
          discount: 0.0,
          totalPrice: 13.57,
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
          status: OrderStatus.cancelled,
          deliveryAddress: 'Home • 124 Grand Avenue, Apt 4B',
          paymentMethod: 'Visa ending in 4242',
          estimatedTime: 'Cancelled',
        ),
      ];
}
