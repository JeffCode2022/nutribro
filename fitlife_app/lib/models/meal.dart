class Meal {
  final String id;
  final String name;
  final String description;
  final MealType mealType;
  final double calories;
  final double protein; // en gramos
  final double carbs; // en gramos
  final double fat; // en gramos
  final List<String> ingredients;
  final List<String> instructions;
  final int preparationTime; // en minutos
  final String imageUrl;

  Meal({
    required this.id,
    required this.name,
    required this.description,
    required this.mealType,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.ingredients,
    required this.instructions,
    this.preparationTime = 30,
    this.imageUrl = '',
  });
}

enum MealType {
  breakfast, // Desayuno
  morningSnack, // Media mañana
  lunch, // Almuerzo
  afternoonSnack, // Merienda
  dinner, // Cena
  eveningSnack, // Snack nocturno
}

class DailyFoodLog {
  final String id;
  final DateTime date;
  final List<MealLog> meals;
  final double waterIntake; // en litros
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;

  DailyFoodLog({
    required this.id,
    required this.date,
    required this.meals,
    this.waterIntake = 0,
    this.totalCalories = 0,
    this.totalProtein = 0,
    this.totalCarbs = 0,
    this.totalFat = 0,
  }) {
    _calculateTotals();
  }

  void _calculateTotals() {
    totalCalories = meals.fold(0, (sum, meal) => sum + meal.calories);
    totalProtein = meals.fold(0, (sum, meal) => sum + meal.protein);
    totalCarbs = meals.fold(0, (sum, meal) => sum + meal.carbs);
    totalFat = meals.fold(0, (sum, meal) => sum + meal.fat);
  }

  double get calorieProgress => totalCalories;
  
  Map<MealType, List<MealLog>> get mealsByType {
    final map = <MealType, List<MealLog>>{};
    for (var type in MealType.values) {
      map[type] = meals.where((m) => m.mealType == type).toList();
    }
    return map;
  }
}

class MealLog {
  final String mealId;
  final String mealName;
  final MealType mealType;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final DateTime timestamp;

  MealLog({
    required this.mealId,
    required this.mealName,
    required this.mealType,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.timestamp,
  });
}

class WeightRecord {
  final String id;
  final DateTime date;
  final double weight;
  final double? bodyFatPercentage;
  final List<double> measurements; // cintura, cadera, pecho, brazo, pierna

  WeightRecord({
    required this.id,
    required this.date,
    required this.weight,
    this.bodyFatPercentage,
    this.measurements = const [],
  });

  DateTime get week => DateTime(date.year, date.month, date.day - date.weekday);
  
  DateTime get month => DateTime(date.year, date.month, 1);
}
