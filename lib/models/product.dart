// Modelo de producto utilizado en la app
class Product {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String category;

  // Crea una instancia inmutable de producto
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
  });
}
