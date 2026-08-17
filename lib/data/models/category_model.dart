import 'package:equatable/equatable.dart';

class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String icon;
  final String imageUrl;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, icon, imageUrl];
}
