import 'package:hello_world/models/product.dart';

class ProductsService {
  static final ProductsService _instance = ProductsService._internal();
  factory ProductsService() => _instance;
  ProductsService._internal();

  final List<Product> _products = const [
    Product(
      id: 'p1',
      name: 'Shampoo Natura',
      description: 'Shampoo natural para todo tipo de cabello.',
      imageUrl: 'https://via.placeholder.com/300x200.png?text=Shampoo',
      price: 19.99,
      category: 'Cuidado Personal',
    ),
    Product(
      id: 'p2',
      name: 'Crema Hidratante',
      description: 'Crema para una piel suave e hidratada.',
      imageUrl: 'https://via.placeholder.com/300x200.png?text=Crema',
      price: 24.50,
      category: 'Belleza',
    ),
    Product(
      id: 'p3',
      name: 'Perfume Floral',
      description: 'Aroma fresco con notas florales.',
      imageUrl: 'https://via.placeholder.com/300x200.png?text=Perfume',
      price: 49.90,
      category: 'Fragancias',
    ),
  ];

  List<Product> getAll() => List.unmodifiable(_products);

  Product? getById(String id) {
    for (final p in _products) {
      if (p.id == id) return p;
    }
    return null;
  }
}

