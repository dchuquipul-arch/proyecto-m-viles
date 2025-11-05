import 'package:hello_world/models/product.dart';

class ProductsService {
  static final ProductsService _instance = ProductsService._internal();
  factory ProductsService() => _instance;
  ProductsService._internal();

  final List<Product> _products = const [
    Product(
      id: 'p1',
      name: 'Ekos Jabones en barra puro vegetal cremosos y exfoliantes',
      description: 'Caja con 4 unidades de 100 g cada uno',
      imageUrl: 'https://production.na01.natura.com/on/demandware.static/-/Sites-natura-pe-storefront-catalog/default/dwf5370e51/products/NATPER-134574_1.jpg',
      price: 50.00,
      category: 'Cuidado Personal',
    ),
    Product(
      id: 'p2',
      name: 'Ekos Jabones en barra puro vegetal exfoliantes',
      description: 'Caja con 4 unidades de 100 g cada uno',
      imageUrl: 'https://production.na01.natura.com/on/demandware.static/-/Sites-natura-pe-storefront-catalog/default/dwb3700d4b/products/NATPER-129797_1.jpg',
      price: 50.50,
      category: 'Belleza',
    ),
    Product(
      id: 'p3',
      name: 'Tododia Jabones en barra puro vegetal avellana y casis',
      description: '5 unidades de 90 g cada uno',
      imageUrl: 'https://production.na01.natura.com/on/demandware.static/-/Sites-natura-pe-storefront-catalog/default/dwd235baee/products/NATPER-74852_1.jpg',
      price: 42.00,
      category: 'Fragancias',
    ),
    Product(
      id: 'p4',
      name: 'Kaiak eau de toilette masculino urbe',
      description: '100 ml',
      imageUrl: 'https://production.na01.natura.com/on/demandware.static/-/Sites-natura-pe-storefront-catalog/default/dw96c5bd6c/NATPER-111172_1.jpg',
      price: 120.00,
      category: 'Fragancias',
    ),
    Product(
      id: 'p5',
      name: 'Kaiak eau de toilette masculino oceano',
      description: '100 ml',
      imageUrl: 'https://production.na01.natura.com/on/demandware.static/-/Sites-natura-pe-storefront-catalog/default/dwc2476031/NATPER-111175_1.jpg',
      price: 64.50,
      category: 'Fragancias',
    ),
    Product(
      id: 'p6',
      name: 'Natura Ilía eau de parfum femenina secreto',
      description: '50 ml',
      imageUrl: 'https://production.na01.natura.com/on/demandware.static/-/Sites-natura-pe-storefront-catalog/default/dw59ddf29d/products/NATPER-83322_1.jpg',
      price: 74.00,
      category: 'Fragancias',
    ),
    Product(
      id: 'p7',
      name: 'Tododia Jabones en barra puro vegetal avellana y casis',
      description: '5 unidades de 90 g cada uno',
      imageUrl: 'https://production.na01.natura.com/on/demandware.static/-/Sites-natura-pe-storefront-catalog/default/dwd235baee/products/NATPER-74852_1.jpg',
      price: 42.00,
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

