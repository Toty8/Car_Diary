class Car {
  final int? id;
  final int userId;
  final String registrationNumber;
  final double fuelConsumption;
  final String lastOilChangeDate;
  final int lastOilChangeKm;
  final String insuranceDueDate;
  final String vignetteDueDate;
  final String technicalDueDate;
  final double totalSpent;

  Car({
    this.id,
    required this.userId,
    required this.registrationNumber,
    required this.fuelConsumption,
    required this.lastOilChangeDate,
    required this.lastOilChangeKm,
    required this.insuranceDueDate,
    required this.vignetteDueDate,
    required this.technicalDueDate,
    this.totalSpent = 0.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'registration_number': registrationNumber,
      'fuel_consumption': fuelConsumption,
      'last_oil_change_date': lastOilChangeDate,
      'last_oil_change_km': lastOilChangeKm,
      'insurance_due_date': insuranceDueDate,
      'vignette_due_date': vignetteDueDate,
      'technical_due_date': technicalDueDate,
      'total_spent': totalSpent,
    };
  }

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'],
      userId: map['user_id'],
      registrationNumber: map['registration_number'],
      fuelConsumption: map['fuel_consumption'],
      lastOilChangeDate: map['last_oil_change_date'],
      lastOilChangeKm: map['last_oil_change_km'],
      insuranceDueDate: map['insurance_due_date'],
      vignetteDueDate: map['vignette_due_date'],
      technicalDueDate: map['technical_due_date'],
      totalSpent: map['total_spent'],
    );
  }
}
