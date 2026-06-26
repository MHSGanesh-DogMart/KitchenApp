/// A dish on a kitchen's menu. Mirrors the backend `MenuItem` model
/// (GET/POST/PUT /api/kitchen/menu).
class MenuItem {
  const MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.perDay,
    required this.diet,
    required this.spice,
    required this.eggless,
    required this.isAvailable,
    this.imageUrl,
    this.portion,
    this.ingredients,
    this.description,
  });

  final String id;
  final String name;
  final double price;
  final int perDay;
  final String diet; // Veg | Non-veg | Vegan | Jain
  final String spice; // Mild | Medium | Spicy | Extra spicy
  final bool eggless;
  final bool isAvailable;
  final String? imageUrl;
  final String? portion;
  final String? ingredients;
  final String? description;

  factory MenuItem.fromJson(Map<String, dynamic> j) => MenuItem(
        id: j['id']?.toString() ?? '',
        name: j['name']?.toString() ?? '',
        price: (j['price'] as num?)?.toDouble() ?? 0,
        perDay: (j['perDay'] as num?)?.toInt() ?? 0,
        diet: j['diet']?.toString() ?? 'Veg',
        spice: j['spice']?.toString() ?? 'Medium',
        eggless: j['eggless'] as bool? ?? true,
        isAvailable: j['isAvailable'] as bool? ?? true,
        imageUrl: j['imageUrl']?.toString(),
        portion: j['portion']?.toString(),
        ingredients: j['ingredients']?.toString(),
        description: j['description']?.toString(),
      );

  /// Body for POST/PUT — only sends meaningful values.
  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'perDay': perDay,
        if (imageUrl != null && imageUrl!.isNotEmpty) 'imageUrl': imageUrl,
        'diet': diet,
        'spice': spice,
        'eggless': eggless,
        if (portion != null && portion!.isNotEmpty) 'portion': portion,
        if (ingredients != null && ingredients!.isNotEmpty)
          'ingredients': ingredients,
        if (description != null && description!.isNotEmpty)
          'description': description,
        'isAvailable': isAvailable,
      };

  /// Short meta line shown on the menu card, e.g. "Veg · Medium · Eggless".
  String get metaLine {
    final parts = <String>[diet, spice];
    if (eggless) parts.add('Eggless');
    return parts.join(' · ');
  }
}
