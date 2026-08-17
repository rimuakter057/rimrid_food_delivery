import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/restaurant_model.dart';
import 'app_network_image.dart';
import 'app_rating.dart';

class AppRestaurantCard extends StatelessWidget {
  final RestaurantModel restaurant;
  final VoidCallback? onTap;
  final VoidCallback? onToggleFavorite;
  final bool isFavorite;

  const AppRestaurantCard({
    super.key,
    required this.restaurant,
    this.onTap,
    this.onToggleFavorite,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.borderLg,
          border: Border.all(color: AppColors.border),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AppNetworkImage(
                  imageUrl: restaurant.coverImageUrl,
                  height: 140,
                  width: double.infinity,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time_filled_rounded, color: AppColors.primary, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          restaurant.deliveryTime,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (onToggleFavorite != null)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: onToggleFavorite,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isFavorite ? AppColors.error : AppColors.iconGrey,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: AppTextStyles.subtitle.copyWith(fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AppRating(rating: restaurant.rating, reviewCount: restaurant.reviewCount),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        restaurant.tags.join(' • '),
                        style: AppTextStyles.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.delivery_dining_rounded, color: AppColors.primary, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        restaurant.deliveryFee == 0
                            ? 'Free Delivery'
                            : '${AppFormatters.currency(restaurant.deliveryFee)} Delivery',
                        style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.location_on_rounded, color: AppColors.iconGrey, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        AppFormatters.distance(restaurant.distanceKm),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
