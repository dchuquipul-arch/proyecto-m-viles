import 'package:hello_world/services/firebase_products_service.dart';
import 'package:hello_world/models/product.dart';

/// Script de migración para subir los productos iniciales a Firebase
/// Este script se ejecuta una sola vez para poblar la base de datos
class DataMigration {
  static Future<void> migrateProducts() async {
    final service = FirebaseProductsService();
    
    final products = [
      const Product(
        id: 'temp1',
        name: 'Ekos Jabones en barra puro vegetal cremosos y exfoliantes',
        description: 'Caja con 4 unidades de 100 g cada uno',
        imageUrl: 'https://production.na01.natura.com/on/demandware.static/-/Sites-natura-pe-storefront-catalog/default/dwf5370e51/products/NATPER-134574_1.jpg',
        price: 50.00,
        category: 'Cuidado Personal',
      ),
      const Product(
        id: 'temp2',
        name: 'Ekos Jabones en barra puro vegetal exfoliantes',
        description: 'Caja con 4 unidades de 100 g cada uno',
        imageUrl: 'https://production.na01.natura.com/on/demandware.static/-/Sites-natura-pe-storefront-catalog/default/dwb3700d4b/products/NATPER-129797_1.jpg',
        price: 50.50,
        category: 'Belleza',
      ),
      const Product(
        id: 'temp3',
        name: 'Tododia Jabones en barra puro vegetal avellana y casis',
        description: '5 unidades de 90 g cada uno',
        imageUrl: 'https://production.na01.natura.com/on/demandware.static/-/Sites-natura-pe-storefront-catalog/default/dwd235baee/products/NATPER-74852_1.jpg',
        price: 42.00,
        category: 'Fragancias',
      ),
      const Product(
        id: 'temp4',
        name: 'Kaiak eau de toilette masculino urbe',
        description: '100 ml',
        imageUrl: 'https://production.na01.natura.com/on/demandware.static/-/Sites-natura-pe-storefront-catalog/default/dw96c5bd6c/NATPER-111172_1.jpg',
        price: 120.00,
        category: 'Fragancias',
      ),
      const Product(
        id: 'temp5',
        name: 'Kaiak eau de toilette masculino oceano',
        description: '100 ml',
        imageUrl: 'https://production.na01.natura.com/on/demandware.static/-/Sites-natura-pe-storefront-catalog/default/dwc2476031/NATPER-111175_1.jpg',
        price: 64.50,
        category: 'Fragancias',
      ),
      const Product(
        id: 'temp6',
        name: 'Natura Ilía eau de parfum femenina secreto',
        description: '50 ml',
        imageUrl: 'https://production.na01.natura.com/on/demandware.static/-/Sites-natura-pe-storefront-catalog/default/dw59ddf29d/products/NATPER-83322_1.jpg',
        price: 74.00,
        category: 'Fragancias',
      ),
      const Product(
        id: 'temp7',
        name: 'Tododia Jabones en barra puro vegetal avellana y casis',
        description: '5 unidades de 90 g cada uno',
        imageUrl: 'https://production.na01.natura.com/on/demandware.static/-/Sites-natura-pe-storefront-catalog/default/dwd235baee/products/NATPER-74852_1.jpg',
        price: 42.00,
        category: 'Fragancias',
      ),
    ];

    int contador = 0;
    for (final product in products) {
      final id = await service.addProduct(product);
      if (id != null) {
        contador++;
        print('✅ Producto migrado ($contador/${products.length}): ${product.name}');
      } else {
        print('❌ Error migrando: ${product.name}');
      }
    }
    
    print('\n🎉 Migración completada: $contador productos subidos a Firebase');
  }
}

