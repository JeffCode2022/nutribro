class UserProfile {
  final String id;
  final String name;
  final int age;
  final double height; // en cm
  final double initialWeight; // en kg
  final double currentWeight; // en kg
  final double goalWeight; // en kg
  final String gender;
  final DateTime startDate;
  final double dailyWaterGoal; // en litros
  final double dailyCalorieGoal;

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.height,
    required this.initialWeight,
    required this.currentWeight,
    required this.goalWeight,
    required this.gender,
    required this.startDate,
    this.dailyWaterGoal = 2.5,
    this.dailyCalorieGoal = 2000,
  });

  double get weightLost => initialWeight - currentWeight;
  
  double get bmi {
    final heightInMeters = height / 100;
    return currentWeight / (heightInMeters * heightInMeters);
  }

  String get bmiCategory {
    if (bmi < 18.5) return 'Bajo peso';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Sobrepeso';
    return 'Obesidad';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'height': height,
      'initialWeight': initialWeight,
      'currentWeight': currentWeight,
      'goalWeight': goalWeight,
      'gender': gender,
      'startDate': startDate.toIso8601String(),
      'dailyWaterGoal': dailyWaterGoal,
      'dailyCalorieGoal': dailyCalorieGoal,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      name: map['name'],
      age: map['age'],
      height: map['height'],
      initialWeight: map['initialWeight'],
      currentWeight: map['currentWeight'],
      goalWeight: map['goalWeight'],
      gender: map['gender'],
      startDate: DateTime.parse(map['startDate']),
      dailyWaterGoal: map['dailyWaterGoal'] ?? 2.5,
      dailyCalorieGoal: map['dailyCalorieGoal'] ?? 2000,
    );
  }

  UserProfile copyWith({
    String? id,
    String? name,
    int? age,
    double? height,
    double? initialWeight,
    double? currentWeight,
    double? goalWeight,
    String? gender,
    DateTime? startDate,
    double? dailyWaterGoal,
    double? dailyCalorieGoal,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      height: height ?? this.height,
      initialWeight: initialWeight ?? this.initialWeight,
      currentWeight: currentWeight ?? this.currentWeight,
      goalWeight: goalWeight ?? this.goalWeight,
      gender: gender ?? this.gender,
      startDate: startDate ?? this.startDate,
      dailyWaterGoal: dailyWaterGoal ?? this.dailyWaterGoal,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
    );
  }
}
