class Exercise {
  final String id;
  final String name;
  final String description;
  final String targetMuscle;
  final String equipment; // máquina, peso libre, cable, etc.
  final List<ExerciseSet> defaultSets;
  final String tips; // consejos para realizar el ejercicio correctamente
  final String imageUrl;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.targetMuscle,
    required this.equipment,
    required this.defaultSets,
    required this.tips,
    this.imageUrl = '',
  });
}

class ExerciseSet {
  final int setNumber;
  final int repetitions;
  final double weight; // en kg
  final int restTime; // en segundos

  ExerciseSet({
    required this.setNumber,
    required this.repetitions,
    this.weight = 0,
    this.restTime = 60,
  });
}

class WorkoutSession {
  final String id;
  final DateTime date;
  final List<CompletedExercise> exercises;
  final int totalDuration; // en minutos
  final int caloriesBurned;

  WorkoutSession({
    required this.id,
    required this.date,
    required this.exercises,
    this.totalDuration = 0,
    this.caloriesBurned = 0,
  });

  int get totalSets => exercises.fold(0, (sum, ex) => sum + ex.completedSets.length);
  
  int get totalReps => exercises.fold(
    0,
    (sum, ex) => sum + ex.completedSets.fold(0, (s, set) => s + set.repetitions),
  );
}

class CompletedExercise {
  final String exerciseId;
  final String exerciseName;
  final List<CompletedSet> completedSets;

  CompletedExercise({
    required this.exerciseId,
    required this.exerciseName,
    required this.completedSets,
  });
}

class CompletedSet {
  final int setNumber;
  final int repetitions;
  final double weight;
  final bool completed;

  CompletedSet({
    required this.setNumber,
    required this.repetitions,
    this.weight = 0,
    this.completed = true,
  });
}
