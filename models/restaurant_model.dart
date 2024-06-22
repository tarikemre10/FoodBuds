class Restaurant {
  final String? id;
  final String restaurantName;
  final String location;
  final String cuisineType;
  final String rating;
  final String? filePath;
  final String closingHour;

  const Restaurant({
    this.id,
    required this.restaurantName,
    required this.location,
    required this.cuisineType,
    required this.rating,
    this.filePath,
    required this.closingHour,
  });
}
