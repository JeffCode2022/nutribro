import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/exercise.dart';
import '../models/meal.dart';

class AppProvider with ChangeNotifier {
  UserProfile? _userProfile;
  List<WeightRecord> _weightRecords = [];
  List<WorkoutSession> _workoutSessions = [];
  List<DailyFoodLog> _foodLogs = [];
  
  // Datos del día actual
  double _todayWaterIntake = 0;
  DateTime _currentDate = DateTime.now();

  // Getters
  UserProfile? get userProfile => _userProfile;
  List<WeightRecord> get weightRecords => _weightRecords;
  List<WorkoutSession> get workoutSessions => _workoutSessions;
  List<DailyFoodLog> get foodLogs => _foodLogs;
  double get todayWaterIntake => _todayWaterIntake;
  DateTime get currentDate => _currentDate;

  // Inicializar perfil de usuario
  Future<void> initializeUserProfile(UserProfile profile) async {
    _userProfile = profile;
    notifyListeners();
    // Aquí se guardaría en la base de datos local
  }

  // Actualizar peso
  Future<void> updateWeight(double weight) async {
    if (_userProfile == null) return;
    
    final record = WeightRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      weight: weight,
    );
    
    _weightRecords.add(record);
    _userProfile = _userProfile!.copyWith(currentWeight: weight);
    notifyListeners();
  }

  // Registrar sesión de ejercicio
  Future<void> logWorkout(WorkoutSession session) async {
    _workoutSessions.add(session);
    notifyListeners();
  }

  // Registrar comida
  Future<void> logMeal(MealLog meal) async {
    final today = DateTime.now();
    final existingLogIndex = _foodLogs.indexWhere(
      (log) => log.date.year == today.year && 
               log.date.month == today.month && 
               log.date.day == today.day
    );

    if (existingLogIndex >= 0) {
      _foodLogs[existingLogIndex].meals.add(meal);
    } else {
      final newLog = DailyFoodLog(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: today,
        meals: [meal],
      );
      _foodLogs.add(newLog);
    }
    notifyListeners();
  }

  // Registrar consumo de agua
  Future<void> addWaterIntake(double liters) async {
    _todayWaterIntake += liters;
    notifyListeners();
  }

  // Obtener progreso por período
  Map<String, double> getProgressByPeriod() {
    if (_weightRecords.isEmpty || _userProfile == null) {
      return {'day': 0, 'week': 0, 'month': 0};
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekAgo = today.subtract(const Duration(days: 7));
    final monthAgo = DateTime(now.year, now.month - 1, now.day);

    final todayWeight = _getLatestWeightBefore(today);
    final weekAgoWeight = _getLatestWeightBefore(weekAgo);
    final monthAgoWeight = _getLatestWeightBefore(monthAgo);
    final initialWeight = _userProfile!.initialWeight;

    return {
      'total': initialWeight - _userProfile!.currentWeight,
      'day': todayWeight != null ? _userProfile!.currentWeight - todayWeight : 0,
      'week': weekAgoWeight != null ? _userProfile!.currentWeight - weekAgoWeight : 0,
      'month': monthAgoWeight != null ? _userProfile!.currentWeight - monthAgoWeight : 0,
    };
  }

  double? _getLatestWeightBefore(DateTime date) {
    final recordsBefore = _weightRecords
        .where((r) => r.date.isBefore(date))
        .toList();
    
    if (recordsBefore.isEmpty) return null;
    
    recordsBefore.sort((a, b) => b.date.compareTo(a.date));
    return recordsBefore.first.weight;
  }

  // Obtener ejercicios recomendados por grupo muscular
  List<Exercise> getRecommendedExercises(String muscleGroup) {
    // Esto se conectaría a una base de datos real
    return _generateSampleExercises(muscleGroup);
  }

  List<Exercise> _generateSampleExercises(String muscleGroup) {
    final exercises = <Exercise>[];
    
    switch (muscleGroup.toLowerCase()) {
      case 'pecho':
        exercises.addAll([
          Exercise(
            id: '1',
            name: 'Press de Banca con Barra',
            description: 'Ejercicio compuesto para desarrollar el pecho',
            targetMuscle: 'Pecho',
            equipment: 'Barra',
            defaultSets: [
              ExerciseSet(setNumber: 1, repetitions: 12, restTime: 90),
              ExerciseSet(setNumber: 2, repetitions: 10, restTime: 90),
              ExerciseSet(setNumber: 3, repetitions: 8, restTime: 120),
              ExerciseSet(setNumber: 4, repetitions: 8, restTime: 120),
            ],
            tips: 'Mantén los pies firmes en el suelo, arquea ligeramente la espalda y baja la barra hasta tocar el pecho.',
          ),
          Exercise(
            id: '2',
            name: 'Press Inclinado con Mancuernas',
            description: 'Enfocado en la parte superior del pecho',
            targetMuscle: 'Pecho',
            equipment: 'Mancuernas',
            defaultSets: [
              ExerciseSet(setNumber: 1, repetitions: 12, restTime: 90),
              ExerciseSet(setNumber: 2, repetitions: 10, restTime: 90),
              ExerciseSet(setNumber: 3, repetitions: 10, restTime: 90),
            ],
            tips: 'Banco a 30-45 grados, controla el movimiento y no bloquees los codos al subir.',
          ),
        ]);
        break;
      
      case 'espalda':
        exercises.addAll([
          Exercise(
            id: '3',
            name: 'Jalón al Pecho',
            description: 'Excelente para desarrollar la amplitud de la espalda',
            targetMuscle: 'Espalda',
            equipment: 'Máquina de cables',
            defaultSets: [
              ExerciseSet(setNumber: 1, repetitions: 15, restTime: 60),
              ExerciseSet(setNumber: 2, repetitions: 12, restTime: 90),
              ExerciseSet(setNumber: 3, repetitions: 10, restTime: 90),
              ExerciseSet(setNumber: 4, repetitions: 10, restTime: 90),
            ],
            tips: 'Tira hacia abajo llevando la barra al pecho superior, mantén el torso estable.',
          ),
          Exercise(
            id: '4',
            name: 'Remo con Barra',
            description: 'Ejercicio compuesto para grosor de espalda',
            targetMuscle: 'Espalda',
            equipment: 'Barra',
            defaultSets: [
              ExerciseSet(setNumber: 1, repetitions: 12, restTime: 90),
              ExerciseSet(setNumber: 2, repetitions: 10, restTime: 90),
              ExerciseSet(setNumber: 3, repetitions: 8, restTime: 120),
            ],
            tips: 'Mantén la espalda recta, tira de la barra hacia el ombligo.',
          ),
        ]);
        break;
      
      case 'piernas':
        exercises.addAll([
          Exercise(
            id: '5',
            name: 'Sentadilla con Barra',
            description: 'El rey de los ejercicios de pierna',
            targetMuscle: 'Piernas',
            equipment: 'Barra',
            defaultSets: [
              ExerciseSet(setNumber: 1, repetitions: 15, restTime: 120),
              ExerciseSet(setNumber: 2, repetitions: 12, restTime: 120),
              ExerciseSet(setNumber: 3, repetitions: 10, restTime: 150),
              ExerciseSet(setNumber: 4, repetitions: 8, restTime: 150),
            ],
            tips: 'Pies al ancho de hombros, baja hasta que los muslos estén paralelos al suelo.',
          ),
          Exercise(
            id: '6',
            name: 'Prensa de Piernas',
            description: 'Ejercicio seguro para cuádriceps',
            targetMuscle: 'Piernas',
            equipment: 'Máquina de prensa',
            defaultSets: [
              ExerciseSet(setNumber: 1, repetitions: 15, restTime: 90),
              ExerciseSet(setNumber: 2, repetitions: 12, restTime: 90),
              ExerciseSet(setNumber: 3, repetitions: 12, restTime: 90),
            ],
            tips: 'No bloquees las rodillas al extender, controla el descenso.',
          ),
        ]);
        break;
      
      case 'hombros':
        exercises.addAll([
          Exercise(
            id: '7',
            name: 'Press Militar con Mancuernas',
            description: 'Desarrollo general de hombros',
            targetMuscle: 'Hombros',
            equipment: 'Mancuernas',
            defaultSets: [
              ExerciseSet(setNumber: 1, repetitions: 12, restTime: 90),
              ExerciseSet(setNumber: 2, repetitions: 10, restTime: 90),
              ExerciseSet(setNumber: 3, repetitions: 8, restTime: 120),
            ],
            tips: 'Siéntate recto, presiona hacia arriba sin arquear la espalda.',
          ),
          Exercise(
            id: '8',
            name: 'Elevaciones Laterales',
            description: 'Aislamiento de deltoides laterales',
            targetMuscle: 'Hombros',
            equipment: 'Mancuernas',
            defaultSets: [
              ExerciseSet(setNumber: 1, repetitions: 15, restTime: 60),
              ExerciseSet(setNumber: 2, repetitions: 12, restTime: 60),
              ExerciseSet(setNumber: 3, repetitions: 12, restTime: 60),
            ],
            tips: 'Levanta hasta la altura de los hombros, codos ligeramente flexionados.',
          ),
        ]);
        break;
      
      case 'brazos':
        exercises.addAll([
          Exercise(
            id: '9',
            name: 'Curl de Bíceps con Barra',
            description: 'Ejercicio clásico para bíceps',
            targetMuscle: 'Bíceps',
            equipment: 'Barra',
            defaultSets: [
              ExerciseSet(setNumber: 1, repetitions: 12, restTime: 60),
              ExerciseSet(setNumber: 2, repetitions: 10, restTime: 60),
              ExerciseSet(setNumber: 3, repetitions: 10, restTime: 60),
            ],
            tips: 'Mantén los codos pegados al cuerpo, no uses impulso.',
          ),
          Exercise(
            id: '10',
            name: 'Extensiones de Tríceps en Polea',
            description: 'Aislamiento de tríceps',
            targetMuscle: 'Tríceps',
            equipment: 'Máquina de cables',
            defaultSets: [
              ExerciseSet(setNumber: 1, repetitions: 15, restTime: 60),
              ExerciseSet(setNumber: 2, repetitions: 12, restTime: 60),
              ExerciseSet(setNumber: 3, repetitions: 12, restTime: 60),
            ],
            tips: 'Codos fijos, extiende completamente los brazos.',
          ),
        ]);
        break;
    }
    
    return exercises;
  }

  // Obtener plan de rutina semanal
  Map<String, List<String>> getWeeklyRoutine() {
    return {
      'Lunes': ['Pecho', 'Tríceps'],
      'Martes': ['Espalda', 'Bíceps'],
      'Miércoles': ['Descanso activo'],
      'Jueves': ['Piernas'],
      'Viernes': ['Hombros', 'Abdomen'],
      'Sábado': ['Cardio LISS'],
      'Domingo': ['Descanso'],
    };
  }

  // Resetear contador de agua para nuevo día
  void resetDailyData() {
    final now = DateTime.now();
    if (now.day != _currentDate.day) {
      _currentDate = now;
      _todayWaterIntake = 0;
      notifyListeners();
    }
  }
}
