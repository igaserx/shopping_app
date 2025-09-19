class ProductEntity {
  final int id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final double rating;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
  });
}
