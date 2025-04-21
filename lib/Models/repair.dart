class Repair {
  final int? id;
  final int carId;
  final String description;
  final double cost;
  final String date;

  Repair({
    this.id,
    required this.carId,
    required this.description,
    required this.cost,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'car_id': carId,
      'description': description,
      'cost': cost,
      'date': date,
    };
  }

  factory Repair.fromMap(Map<String, dynamic> map) {
    return Repair(
      id: map['id'],
      carId: map['car_id'],
      description: map['description'],
      cost: map['cost'],
      date: map['date'],
    );
  }
}
