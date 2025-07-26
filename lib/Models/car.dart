class Car {
  final String id;
  final String color;
  final String brand;
  final String model;
  final int year;
  final num price;
  final String? imgURL;

  Car({
    this.id = '',
    required this.color,
    required this.brand,
    required this.model,
    required this.year,
    required this.price,
    this.imgURL,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['_id'],
      color: json['color'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      price: (json['price'] as num),
      imgURL: json['imgURL'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'color': color,
      'brand': brand,
      'model': model,
      'year': year,
      'price': price,
      'imgURL': imgURL,
    };
  }

  @override
  String toString() {
    return 'Car{id: $id, color: $color, brand: $brand, model: $model, year: $year, price: $price, imgURL: $imgURL}';
  }
}
